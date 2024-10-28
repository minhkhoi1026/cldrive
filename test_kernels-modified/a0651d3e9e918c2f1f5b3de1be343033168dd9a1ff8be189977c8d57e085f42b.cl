//{"X":7,"a":5,"b":6,"in":0,"ncols":4,"nrows":3,"out":1,"scratch":2,"theta":8}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline float dotproduct(global float* a, global float* b, const int size) {
  float out = 0.0f;
  for (int i = 0; i < size; i++) {
    out += a[hook(5, i)] * b[hook(6, i)];
  }
  return out;
}

inline float sigmoid(global float* X, global float* theta, int row_id, int nrows, int ncols) {
  float linear_sum = 0.0f;
  for (int j = 0; j < ncols; j++) {
    linear_sum += (X[hook(7, row_id + j * nrows)] * theta[hook(8, j)]);
  }

  float exponential = pow(2.71828182845904523536028747135266250f, -linear_sum);
  exponential += 1.0f;
  float sig = 1.0f / exponential;
  return sig;
}

kernel void matrix_row_mean(global float* in, global float* out, local float* scratch, const int nrows, const int ncols) {
  int gid = get_global_id(0);
  int lid = get_local_id(0);
  int global_size = get_global_size(0);

  for (int j = 0; j < ncols; j++) {
    float accum = 0.0f;
    while (gid < nrows) {
      accum += in[hook(0, gid * ncols + j)];
      gid += global_size;
    }
    scratch[hook(2, lid * ncols + j)] = accum;
  }

  barrier(0x01);
  for (int i = get_local_size(0) / 2; i > 0; i >>= 1) {
    if (lid < i) {
      for (int j = 0; j < ncols; j++) {
        scratch[hook(2, lid * ncols + j)] = scratch[hook(2, lid * ncols + i * ncols + j)];
      }
    }
    barrier(0x01);
  }

  if (lid == 0) {
    for (int j = 0; j < ncols; j++) {
      out[hook(1, get_group_id(0) * ncols + j)] = scratch[hook(2, 0 * ncols + j)];
    }
  }
}