//{"a":10,"arr":7,"cluster_num":3,"data":1,"hyper_param":4,"labels":0,"logp":8,"logpost":6,"p":9,"rand":5,"uniq_label":2}
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
  float result = arr[hook(7, start)];
  for (int i = start + 1; i < start + length; i++) {
    if (arr[hook(7, i)] > result)
      result = arr[hook(7, i)];
  }
  return result;
}

float sum(global float* arr, int start, int length) {
  float result = 0;
  for (int i = start; i < start + length; i++) {
    result += arr[hook(7, i)];
  }
  return result;
}

void lognormalize(global float* logp, int start, int length) {
  float m = max_arr(logp, start, length);
  for (int i = start; i < start + length; i++) {
    logp[hook(8, i)] = exp(logp[hook(8, i)] - m);
  }
  float p_sum = sum(logp, start, length);
  for (int i = start; i < start + length; i++) {
    logp[hook(8, i)] = logp[hook(8, i)] / p_sum;
  }
}

int sample(unsigned int a_size, global unsigned int* a, global float* p, int start, float rand) {
  float total = 0;
  for (int i = start; i < start + a_size; i++) {
    total += p[hook(9, i)];
    if (total > rand)
      return a[hook(10, i - start)];
  }
  return a[hook(10, a_size - 1)];
}

kernel void logpost(global unsigned int* labels, global float* data, global unsigned int* uniq_label, unsigned int cluster_num, global float* hyper_param, global float* rand, global float* logpost) {
  int i = get_global_id(0);
  size_t data_num = get_global_size(0);

  float gaussian_mu0 = hyper_param[hook(4, 0)];
  float gaussian_k0 = hyper_param[hook(4, 1)];
  float gamma_alpha0 = hyper_param[hook(4, 2)];
  float gamma_beta0 = hyper_param[hook(4, 3)];
  float alpha = hyper_param[hook(4, 4)];
  float k_n, mu_n;
  float alpha_n, beta_n;
  float Lambda, sigma;
  float sum, mu, ss;
  unsigned int n;
  unsigned int empty_n = 0;

  for (int c = 0; c < cluster_num; c++) {
    n = 0;
    mu = 0;
    ss = 0;
    sum = 0;

    for (int d = 0; d < data_num; d++) {
      if (labels[hook(0, d)] == uniq_label[hook(2, c)] && d != i) {
        n++;
        sum += data[hook(1, d)];
      }
    }
    if (n > 0) {
      mu = sum / n;
    } else
      empty_n++;

    for (int d = 0; d < data_num; d++) {
      if (labels[hook(0, d)] == uniq_label[hook(2, c)] && d != i) {
        ss += pow(data[hook(1, d)] - mu, 2.0f);
      }
    }

    k_n = gaussian_k0 + n;
    mu_n = (gaussian_k0 * gaussian_mu0 + n * mu) / k_n;
    alpha_n = gamma_alpha0 + n / 2.0f;
    beta_n = gamma_beta0 + 0.5f * ss + gaussian_k0 * n * pow((mu - gaussian_mu0), 2.0f) / (2.0f * k_n);
    Lambda = alpha_n * k_n / (beta_n * (k_n + 1));
    sigma = pow(1.0f / Lambda, 0.5f);
    logpost[hook(6, i * cluster_num + c)] = t_logpdf(data[hook(1, i)], 2.0f * alpha_n, mu_n, sigma);
  }

  for (int c = 0; c < cluster_num; c++) {
    n = 0;

    for (int d = 0; d < data_num; d++) {
      if (labels[hook(0, d)] == uniq_label[hook(2, c)] && d != i) {
        n++;
      }
    }
    logpost[hook(6, i * cluster_num + c)] += (n > 0) ? log((float)n) : log(alpha / (float)empty_n);
  }

  lognormalize(logpost, i * cluster_num, cluster_num);
  labels[hook(0, i)] = sample(cluster_num, uniq_label, logpost, i * cluster_num, rand[hook(5, i)]);
}