//{"X":0,"a":5,"b":6,"ncols":4,"nrows":3,"out":2,"theta":1}
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
    linear_sum += (X[hook(0, row_id + j * nrows)] * theta[hook(1, j)]);
  }

  float exponential = pow(2.71828182845904523536028747135266250f, -linear_sum);
  exponential += 1.0f;
  float sig = 1.0f / exponential;
  return sig;
}

kernel void sig(global float* X, global float* theta, global float* out, const int nrows, const int ncols) {
  int gid = get_global_id(0);
  out[hook(2, gid)] = sigmoid(X, theta, gid, nrows, ncols);
}