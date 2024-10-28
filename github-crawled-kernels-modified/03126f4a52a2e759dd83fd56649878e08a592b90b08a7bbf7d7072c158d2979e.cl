//{"A":3,"alpha":2,"beta":5,"m":0,"n":1,"out":6,"v":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void clkernel_gemv(const int m, const int n, const float alpha, global const float* A, global const float* v, const float beta, global float* out) {
  const int i = get_global_id(0);
  float sum = 0.0f;
  for (int k = 0; k < n; k++) {
    sum += fma(beta, out[hook(6, i + m * k)], alpha * A[hook(3, i + m * k)] * v[hook(4, k)]);
  }
  out[hook(6, i)] = sum;
}