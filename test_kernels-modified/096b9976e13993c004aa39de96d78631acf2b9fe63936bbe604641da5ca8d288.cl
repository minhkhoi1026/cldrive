//{"incx":2,"n":0,"result":3,"x":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Sasum_naive(int n, global float* x, int incx, global float* result) {
  float res = 0.0f;

  for (int i = 0; i < n; ++i) {
    res += fabs(x[hook(1, i * incx)]);
  }

  result[hook(3, 0)] = res;
}