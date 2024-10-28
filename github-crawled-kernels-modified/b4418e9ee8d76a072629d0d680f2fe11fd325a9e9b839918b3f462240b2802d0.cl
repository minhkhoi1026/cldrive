//{"a":16,"arr":13,"cluster_num":6,"data":1,"data_vec":10,"hyper_param":7,"inv_mat":12,"labels":0,"loc_vec":11,"logp":14,"logpost":9,"mu":3,"n":5,"p":15,"rand":8,"ss":4,"uniq_label":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float t_logpdf(float theta, float df, float loc, float scale) {
  float part1 = lgamma((df + 1.0f) / 2.0f) - lgamma(0.5f * df) - log(pow(df * 3.14159265358979323846264338327950288f, 0.5f) * scale);
  float part2 = -0.5f * (df + 1.0f) * log(1.0f + (1.0f / df) * pow((float)(theta - loc) / scale, 2.0f));
  return part1 + part2;
}

float mvt_logpdf(global float* data_vec, int data_i, int dim, float df, global float* loc_vec, int cluster_i, float det, global float* inv_mat) {
  float part1 = lgamma((df + dim) / 2.0f) - lgamma(df / 2.0f);
  float part2 = -0.5f * log(det) - 0.5f * dim * log(df * 3.14159265358979323846264338327950288f);
  float mat_mul = 0.0f;
  float mat_inner;
  for (int i = 0; i < dim; i++) {
    mat_inner = 0.0f;
    for (int j = 0; j < dim; j++) {
      mat_inner += (data_vec[hook(10, data_i * dim + j)] - loc_vec[hook(11, cluster_i * dim + j)]) * inv_mat[hook(12, cluster_i * dim * dim + j * dim + i)];
    }
    mat_mul += mat_inner * (data_vec[hook(10, data_i * dim + i)] - loc_vec[hook(11, cluster_i * dim + i)]);
  }
  float part3 = -0.5f * (df + dim) * log(1.0f + mat_mul / df);
  return part1 + part2 + part3;
}

float max_arr(global float* arr, int start, int length) {
  float result = arr[hook(13, start)];
  for (int i = start + 1; i < start + length; i++) {
    result = fmax(result, arr[hook(13, i)]);
  }
  return result;
}

float min_arr(global float* arr, int start, int length) {
  float result = arr[hook(13, start)];
  for (int i = start + 1; i < start + length; i++) {
    result = fmin(result, arr[hook(13, i)]);
  }
  return result;
}

float sum(global float* arr, int start, int length) {
  float result = 0;
  for (int i = start; i < start + length; i++) {
    result += arr[hook(13, i)];
  }
  return result;
}

void lognormalize(global float* logp, int start, int length) {
  float m = max_arr(logp, start, length);
  for (int i = start; i < start + length; i++) {
    logp[hook(14, i)] = powr(exp(1.0f), logp[hook(14, i)] - m);
  }
  float p_sum = sum(logp, start, length);
  for (int i = start; i < start + length; i++) {
    logp[hook(14, i)] = logp[hook(14, i)] / p_sum;
  }
}

unsigned int sample(unsigned int a_size, global unsigned int* a, global float* p, int start, float rand) {
  float total = 0.0f;
  for (int i = start; i < start + a_size; i++) {
    total = total + p[hook(15, i)];
    if (total > rand)
      return a[hook(16, i - start)];
  }
  return a[hook(16, a_size - 1)];
}

kernel void normal_1d_logpost_loopy(global unsigned int* labels, global float* data, global unsigned int* uniq_label, global float* mu, global float* ss, global unsigned int* n, unsigned int cluster_num, global float* hyper_param, global float* rand, global float* logpost) {
  unsigned int i = get_global_id(0);
  unsigned int data_size = get_global_size(0);

  float gaussian_mu0 = hyper_param[hook(7, 0)];
  float gaussian_k0 = hyper_param[hook(7, 1)];
  float gamma_alpha0 = hyper_param[hook(7, 2)];
  float gamma_beta0 = hyper_param[hook(7, 3)];
  float alpha = hyper_param[hook(7, 4)];

  unsigned int old_label = labels[hook(0, i)];
  unsigned int new_label;
  unsigned int new_size;
  unsigned int original_cluster;
  float k_n, mu_n;
  float alpha_n, beta_n;
  float Lambda, sigma;
  unsigned int empty_n = 1;

  for (int c = 0; c < cluster_num; c++) {
    new_label = uniq_label[hook(2, c)];
    new_size = n[hook(5, c)];
    original_cluster = old_label == new_label;
    empty_n += (original_cluster && new_size == 1);

    k_n = gaussian_k0 + new_size;
    mu_n = (gaussian_k0 * gaussian_mu0 + new_size * mu[hook(3, c)]) / k_n;
    alpha_n = gamma_alpha0 + new_size / 2.0f;
    beta_n = gamma_beta0 + 0.5f * ss[hook(4, c)] + gaussian_k0 * new_size * pow((mu[hook(3, c)] - gaussian_mu0), 2.0f) / (2.0f * k_n);
    Lambda = alpha_n * k_n / (beta_n * (k_n + 1.0f));
    sigma = pow(1.0f / Lambda, 0.5f);
    logpost[hook(9, i * cluster_num + c)] = t_logpdf(data[hook(1, i)], 2.0f * alpha_n, mu_n, sigma);

    logpost[hook(9, i * cluster_num + c)] += (new_size > original_cluster) ? log((new_size - original_cluster) / (alpha + data_size - 1)) : log(alpha / (float)empty_n / (alpha + data_size - 1));
  }

  lognormalize(logpost, i * cluster_num, cluster_num);
  labels[hook(0, i)] = sample(cluster_num, uniq_label, logpost, i * cluster_num, rand[hook(8, i)]);
}