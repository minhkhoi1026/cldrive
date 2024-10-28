//{"a":10,"arr":7,"data":1,"data_vec":4,"hyper_param":2,"inv_mat":6,"labels":0,"loc_vec":5,"logp":8,"logprob":3,"p":9}
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
      mat_inner += (data_vec[hook(4, data_i * dim + j)] - loc_vec[hook(5, cluster_i * dim + j)]) * inv_mat[hook(6, cluster_i * dim * dim + j * dim + i)];
    }
    mat_mul += mat_inner * (data_vec[hook(4, data_i * dim + i)] - loc_vec[hook(5, cluster_i * dim + i)]);
  }
  float part3 = -0.5f * (df + dim) * log(1.0f + mat_mul / df);
  return part1 + part2 + part3;
}

float max_arr(global float* arr, int start, int length) {
  float result = arr[hook(7, start)];
  for (int i = start + 1; i < start + length; i++) {
    result = fmax(result, arr[hook(7, i)]);
  }
  return result;
}

float min_arr(global float* arr, int start, int length) {
  float result = arr[hook(7, start)];
  for (int i = start + 1; i < start + length; i++) {
    result = fmin(result, arr[hook(7, i)]);
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
    logp[hook(8, i)] = powr(exp(1.0f), logp[hook(8, i)] - m);
  }
  float p_sum = sum(logp, start, length);
  for (int i = start; i < start + length; i++) {
    logp[hook(8, i)] = logp[hook(8, i)] / p_sum;
  }
}

unsigned int sample(unsigned int a_size, global unsigned int* a, global float* p, int start, float rand) {
  float total = 0.0f;
  for (int i = start; i < start + a_size; i++) {
    total = total + p[hook(9, i)];
    if (total > rand)
      return a[hook(10, i - start)];
  }
  return a[hook(10, a_size - 1)];
}

kernel void joint_logprob_1d(global unsigned int* labels, global float* data, global float* hyper_param, global float* logprob) {
  unsigned int data_pos = get_global_id(0);
  unsigned int label = labels[hook(0, data_pos)];

  float gaussian_mu0 = hyper_param[hook(2, 0)];
  float gaussian_k0 = hyper_param[hook(2, 1)];
  float gamma_alpha0 = hyper_param[hook(2, 2)];
  float gamma_beta0 = hyper_param[hook(2, 3)];
  float alpha = hyper_param[hook(2, 4)];

  float k_n, mu_n;
  float alpha_n, beta_n;
  float Lambda, sigma;
  float sum = 0.0f, mu = 0.0f, ss = 0.0f;
  int n = 0;

  for (int i = 0; i < data_pos; i++) {
    if (labels[hook(0, i)] == label) {
      n += 1;
      sum += data[hook(1, i)];
    }
  }
  if (n == 0) {
    mu = 0.0f;
    ss = 0.0f;
  } else {
    mu = sum / n;
    for (int i = 0; i < data_pos; i++) {
      if (labels[hook(0, i)] == label) {
        ss += pow(data[hook(1, i)] - mu, 2.0f);
      }
    }
  }

  k_n = gaussian_k0 + n;
  mu_n = (gaussian_k0 * gaussian_mu0 + n * mu) / k_n;
  alpha_n = gamma_alpha0 + n / 2.0f;
  beta_n = gamma_beta0 + 0.5f * ss + gaussian_k0 * n * pow(mu - gaussian_mu0, 2.0f) / (2.0f * k_n);
  Lambda = alpha_n * k_n / (beta_n * (k_n + 1.0f));
  sigma = pow(1.0f / Lambda, 0.5f);

  logprob[hook(3, data_pos)] = t_logpdf(data[hook(1, data_pos)], 2.0f * alpha_n, mu_n, sigma);
  logprob[hook(3, data_pos)] += (n > 0) ? log((float)n / ((float)data_pos + alpha)) : log(alpha / ((float)data_pos + alpha));
}