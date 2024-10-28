//{"T":3,"a":13,"arr":10,"cov_mu0":2,"cov_obs":1,"data_vec":7,"inv_mat":9,"k0":4,"loc_vec":8,"logp":11,"n":0,"p":12,"sigma":6,"v0":5}
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
      mat_inner += (data_vec[hook(7, data_i * dim + j)] - loc_vec[hook(8, cluster_i * dim + j)]) * inv_mat[hook(9, cluster_i * dim * dim + j * dim + i)];
    }
    mat_mul += mat_inner * (data_vec[hook(7, data_i * dim + i)] - loc_vec[hook(8, cluster_i * dim + i)]);
  }
  float part3 = -0.5f * (df + dim) * log(1.0f + mat_mul / df);
  return part1 + part2 + part3;
}

float max_arr(global float* arr, int start, int length) {
  float result = arr[hook(10, start)];
  for (int i = start + 1; i < start + length; i++) {
    result = fmax(result, arr[hook(10, i)]);
  }
  return result;
}

float min_arr(global float* arr, int start, int length) {
  float result = arr[hook(10, start)];
  for (int i = start + 1; i < start + length; i++) {
    result = fmin(result, arr[hook(10, i)]);
  }
  return result;
}

float sum(global float* arr, int start, int length) {
  float result = 0;
  for (int i = start; i < start + length; i++) {
    result += arr[hook(10, i)];
  }
  return result;
}

void lognormalize(global float* logp, int start, int length) {
  float m = max_arr(logp, start, length);
  for (int i = start; i < start + length; i++) {
    logp[hook(11, i)] = powr(exp(1.0f), logp[hook(11, i)] - m);
  }
  float p_sum = sum(logp, start, length);
  for (int i = start; i < start + length; i++) {
    logp[hook(11, i)] = logp[hook(11, i)] / p_sum;
  }
}

unsigned int sample(unsigned int a_size, global unsigned int* a, global float* p, int start, float rand) {
  float total = 0.0f;
  for (int i = start; i < start + a_size; i++) {
    total = total + p[hook(12, i)];
    if (total > rand)
      return a[hook(13, i - start)];
  }
  return a[hook(13, a_size - 1)];
}

kernel void normal_kd_sigma_matrix(global unsigned int* n, global float* cov_obs, global float* cov_mu0, global float* T, float k0, float v0, global float* sigma) {
  unsigned int cluster_i = get_global_id(0);
  unsigned int dim = get_global_size(1);
  unsigned int d1 = get_global_id(1);
  unsigned int d2 = get_global_id(2);
  unsigned int cluster_size = n[hook(0, cluster_i)];
  unsigned int _3d_increm = dim * dim;
  float k_n, v_n;

  k_n = k0 + cluster_size;
  v_n = v0 + cluster_size;

  sigma[hook(6, d1 * dim + d2 + cluster_i * _3d_increm)] = (T[hook(3, d1 * dim + d2)] + cov_obs[hook(1, d1 * dim + d2 + cluster_i * _3d_increm)] + k0 * cluster_size / k_n * cov_mu0[hook(2, d1 * dim + d2 + cluster_i * _3d_increm)]) * (k_n + 1) / (k_n * (v_n - dim + 1));
}