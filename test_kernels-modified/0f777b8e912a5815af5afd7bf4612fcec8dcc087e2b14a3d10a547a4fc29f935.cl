//{"a":5,"b":6,"in_mat":0,"mat":7,"ncols":4,"nrows":3,"out":8,"out_vec":1,"partial_sums":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline float mydot(global float* a, global float* b, const int size) {
  float out = 0.0f;
  for (int i = 0; i < size; i++) {
    out += a[hook(5, i)] * b[hook(6, i)];
  }
  return out;
}

inline float dotproduct(global float* a, global float* b, const int size) {
  float out = 0.0f;
  for (int i = 0; i < size; i++) {
    out += a[hook(5, i)] * b[hook(6, i)];
  }
  return out;
}

inline float sigmoid(global float* X, global float* theta, const int size) {
  float linear_sum = dotproduct(X, theta, size);
  float exponential = pow(2.71828182845904523536028747135266250f, -linear_sum);
  float sig = pow(1.0f + exponential, -1.0f);
  return sig;
}

inline void matrix_row_avg(global float* mat, global float* out, local float* partial_sums, const int nrows, const int ncols) {
  int lid = get_local_id(0);
  int gid = get_global_id(0);
  float nrowsf = (float)nrows;

  for (int j = 0; j < ncols; j++) {
    partial_sums[hook(2, lid * ncols + j)] = mat[hook(7, gid * ncols + j)];
  }

  barrier(0x01);
  for (int i = nrows / 2; i > 0; i >>= 1) {
    if (lid < i) {
      for (int j = 0; j < ncols; j++) {
        partial_sums[hook(2, lid * ncols + j)] += partial_sums[hook(2, lid * ncols + i * ncols + j)];
      }
    }
    barrier(0x01);
  }

  if (lid == 0) {
    for (int j = 0; j < ncols; j++) {
      out[hook(8, get_group_id(0) + j)] = partial_sums[hook(2, 0 + j)] / nrowsf;
    }
  }
}

kernel void test_reduction_avg_matrix(global float* in_mat, global float* out_vec, local float* partial_sums, const int nrows, const int ncols) {
  matrix_row_avg(in_mat, out_vec, partial_sums, nrows, ncols);
}