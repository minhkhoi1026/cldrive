//{"a":19,"alpha":8,"arr":16,"cluster_num":7,"data":1,"data_vec":13,"determinants":5,"dim":9,"inv_mat":15,"inverses":6,"labels":0,"loc_vec":14,"logp":17,"logpost":11,"mu":3,"n":4,"p":18,"rand":12,"uniq_label":2,"v0":10}
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
      mat_inner += (data_vec[hook(13, data_i * dim + j)] - loc_vec[hook(14, cluster_i * dim + j)]) * inv_mat[hook(15, cluster_i * dim * dim + j * dim + i)];
    }
    mat_mul += mat_inner * (data_vec[hook(13, data_i * dim + i)] - loc_vec[hook(14, cluster_i * dim + i)]);
  }
  float part3 = -0.5f * (df + dim) * log(1.0f + mat_mul / df);
  return part1 + part2 + part3;
}

float max_arr(global float* arr, int start, int length) {
  float result = arr[hook(16, start)];
  for (int i = start + 1; i < start + length; i++) {
    result = fmax(result, arr[hook(16, i)]);
  }
  return result;
}

float min_arr(global float* arr, int start, int length) {
  float result = arr[hook(16, start)];
  for (int i = start + 1; i < start + length; i++) {
    result = fmin(result, arr[hook(16, i)]);
  }
  return result;
}

float sum(global float* arr, int start, int length) {
  float result = 0;
  for (int i = start; i < start + length; i++) {
    result += arr[hook(16, i)];
  }
  return result;
}

void lognormalize(global float* logp, int start, int length) {
  float m = max_arr(logp, start, length);
  for (int i = start; i < start + length; i++) {
    logp[hook(17, i)] = powr(exp(1.0f), logp[hook(17, i)] - m);
  }
  float p_sum = sum(logp, start, length);
  for (int i = start; i < start + length; i++) {
    logp[hook(17, i)] = logp[hook(17, i)] / p_sum;
  }
}

unsigned int sample(unsigned int a_size, global unsigned int* a, global float* p, int start, float rand) {
  float total = 0.0f;
  for (int i = start; i < start + a_size; i++) {
    total = total + p[hook(18, i)];
    if (total > rand)
      return a[hook(19, i - start)];
  }
  return a[hook(19, a_size - 1)];
}

kernel void normal_kd_logpost_loopy(global unsigned int* labels, global float* data, global unsigned int* uniq_label, global float* mu, global unsigned int* n, global float* determinants, global float* inverses, unsigned int cluster_num, float alpha, unsigned int dim, float v0, global float* logpost, global float* rand) {
  unsigned int i = get_global_id(0);
  unsigned int data_size = get_global_size(0);
  unsigned int old_label = labels[hook(0, i)];
  unsigned int new_label;
  unsigned int new_size;
  unsigned int original_cluster;
  float t_df;
  unsigned int empty_n = 1;

  for (int c = 0; c < cluster_num; c++) {
    new_label = uniq_label[hook(2, c)];
    new_size = n[hook(4, c)];
    empty_n += (old_label == new_label && new_size == 1);

    t_df = v0 + new_size - dim + 1.0f;
    logpost[hook(11, i * cluster_num + c)] = mvt_logpdf(data, i, dim, t_df, mu, c, determinants[hook(5, c)], inverses);

    original_cluster = old_label == new_label;
    logpost[hook(11, i * cluster_num + c)] += (new_size > original_cluster) ? log((new_size - original_cluster) / (alpha + data_size - 1)) : log(alpha / empty_n / (alpha + data_size - 1));
  }
  lognormalize(logpost, i * cluster_num, cluster_num);

  labels[hook(0, i)] = sample(cluster_num, uniq_label, logpost, i * cluster_num, rand[hook(12, i)]);
}