//{"a":4,"b":5,"in":0,"nrows":3,"out":1,"partial_sums":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline float mydot(global float* a, global float* b, const int size) {
  float out = 0.0f;
  for (int i = 0; i < size; i++) {
    out += a[hook(4, i)] * b[hook(5, i)];
  }
  return out;
}

inline float dotproduct(global float* a, global float* b, const int size) {
  float out = 0.0f;
  for (int i = 0; i < size; i++) {
    out += a[hook(4, i)] * b[hook(5, i)];
  }
  return out;
}

inline float sigmoid(global float* X, global float* theta, const int size) {
  float linear_sum = dotproduct(X, theta, size);
  float exponential = pow(2.71828182845904523536028747135266250f, -linear_sum);
  float sig = pow(1.0f + exponential, -1.0f);
  return sig;
}

kernel void test_reduction_avg_global(global float* in, global float* out, global float* partial_sums, const int nrows) {
  int gid = get_global_id(0);
  int global_size = get_global_size(0);
  float nrowsf = (float)nrows;

  partial_sums[hook(2, gid)] = in[hook(0, gid)];
  barrier(0x02);

  for (int i = global_size / 2; i > 0; i >>= 1) {
    if (gid < i) {
      partial_sums[hook(2, gid)] += partial_sums[hook(2, gid + i)];
    }
    barrier(0x02);
  }

  out[hook(1, gid)] = partial_sums[hook(2, gid)];
}