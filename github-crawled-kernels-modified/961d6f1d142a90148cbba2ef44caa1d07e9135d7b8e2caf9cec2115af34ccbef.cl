//{"a":0,"b":1,"out":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline float mydot(global float* a, global float* b, const int size) {
  float out = 0.0f;
  for (int i = 0; i < size; i++) {
    out += a[hook(0, i)] * b[hook(1, i)];
  }
  return out;
}

inline float dotproduct(global float* a, global float* b, const int size) {
  float out = 0.0f;
  for (int i = 0; i < size; i++) {
    out += a[hook(0, i)] * b[hook(1, i)];
  }
  return out;
}

inline float sigmoid(global float* X, global float* theta, const int size) {
  float linear_sum = dotproduct(X, theta, size);
  float exponential = pow(2.71828182845904523536028747135266250f, -linear_sum);
  float sig = pow(1.0f + exponential, -1.0f);
  return sig;
}

kernel void powtest(global float* a, global float* b, global float* out) {
  int gid = get_global_id(0);
  out[hook(2, gid)] = pow(a[hook(0, gid)], b[hook(1, gid)]);
}