//{"a":15,"arr":12,"cluster_num":6,"data":1,"empty_n":9,"hyper_param":7,"labels":0,"logp":13,"logpost":10,"mu":3,"n":5,"p":14,"post":11,"rand":8,"ss":4,"uniq_label":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float t_logpdf(float theta, float df, float loc, float scale) {
  float part1 = lgamma((df + 1) / 2.0f) - lgamma(0.5f * df) - log(pow(df * 3.14159265358979323846264338327950288f, 0.5f) * scale);
  float part2 = -0.5f * (df + 1) * log(1 + (1 / df) * pow((theta - loc) / scale, 2.0f));
  return part1 + part2;
}

float max_arr(global float* arr, int start, int length) {
  float result = arr[hook(12, start)];
  for (unsigned int i = start + 1; i < start + length; i++) {
    if (arr[hook(12, i)] > result)
      result = arr[hook(12, i)];
  }
  return result;
}

float sum(global float* arr, int start, int length) {
  float result = 0;
  for (unsigned int i = start; i < start + length; i++) {
    result += arr[hook(12, i)];
  }
  return result;
}

void lognormalize(global float* logp, global float* post, int data_i, int cluster_size) {
  int start = data_i * cluster_size;
  int length = cluster_size;

  for (int j = start; j < start + length; j++) {
    post[hook(11, j)] = exp(logp[hook(13, j)]);
  }
  float p_sum = sum(post, start, length);
  for (int i = start; i < start + length; i++) {
    post[hook(11, i)] = post[hook(11, i)] / p_sum;
  }
}

int sample(unsigned int a_size, global unsigned int* a, global float* p, int start, float rand) {
  float total = 0;
  for (unsigned int i = start; i < start + a_size; i++) {
    total += p[hook(14, i)];
    if (total > rand)
      return a[hook(15, i - start)];
  }
  return a[hook(15, a_size - 1)];
}

kernel void normal_1d_logpost(global unsigned int* labels, global float* data, global unsigned int* uniq_label, global float* mu, global float* ss, global unsigned int* n, int cluster_num, global float* hyper_param, global float* rand, global unsigned int* empty_n, global float* logpost, global float* post) {
  int i = get_global_id(0);
  unsigned int data_i = i / cluster_num;
  unsigned int cluster_i = i % cluster_num;
  size_t data_num = get_global_size(0) / cluster_num;

  float gaussian_mu0 = hyper_param[hook(7, 0)];
  float gaussian_k0 = hyper_param[hook(7, 1)];
  float gamma_alpha0 = hyper_param[hook(7, 2)];
  float gamma_beta0 = hyper_param[hook(7, 3)];
  float alpha = hyper_param[hook(7, 4)];
  float k_n, mu_n;
  float alpha_n, beta_n;
  float Lambda, sigma;

  if (n[hook(5, cluster_i)] == 0)
    empty_n[hook(9, data_i)]++;

  if (labels[hook(0, data_i)] == uniq_label[hook(2, cluster_i)] && n[hook(5, cluster_i)] == 1) {
    empty_n[hook(9, data_i)]++;
    k_n = gaussian_k0;
    mu_n = gaussian_mu0;
    alpha_n = gamma_alpha0;
    beta_n = gamma_beta0;
  } else {
    k_n = gaussian_k0 + n[hook(5, cluster_i)];
    mu_n = (gaussian_k0 * gaussian_mu0 + n[hook(5, cluster_i)] * mu[hook(3, cluster_i)]) / k_n;
    alpha_n = gamma_alpha0 + n[hook(5, cluster_i)] / 2.0f;
    beta_n = gamma_beta0 + 0.5f * ss[hook(4, cluster_i)] + gaussian_k0 * n[hook(5, cluster_i)] * pow((mu[hook(3, cluster_i)] - gaussian_mu0), 2.0f) / (2.0f * k_n);
  }

  Lambda = alpha_n * k_n / (beta_n * (k_n + 1.0f));
  sigma = pow(1.0f / Lambda, 0.5f);
  logpost[hook(10, i)] = t_logpdf(data[hook(1, data_i)], 2.0f * alpha_n, mu_n, sigma);
  barrier(0x01 | 0x02);

  if (labels[hook(0, data_i)] == uniq_label[hook(2, cluster_i)]) {
    logpost[hook(10, i)] += (n[hook(5, cluster_i)] == 1) ? log(alpha / (float)empty_n[hook(9, data_i)]) : log(n[hook(5, cluster_i)] - 1.0f);
  } else {
    logpost[hook(10, i)] += (n[hook(5, cluster_i)] > 0) ? log((float)n[hook(5, cluster_i)]) : log(alpha / (float)empty_n[hook(9, data_i)]);
  }
  barrier(0x01 | 0x02);

  if (cluster_i == 0) {
    lognormalize(logpost, post, data_i, cluster_num);
    labels[hook(0, data_i)] = sample(cluster_num, uniq_label, post, data_i * cluster_num, rand[hook(8, data_i)]);
  }
}