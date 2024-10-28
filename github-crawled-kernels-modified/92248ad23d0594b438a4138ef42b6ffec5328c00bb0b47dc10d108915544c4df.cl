//{"incx":3,"n":1,"result":0,"x":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Snrm2_naive(global float* result, int n, global float* x, int incx) {
  float sum = 0.f;
  for (int i = 0; i < n; i++) {
    sum += x[hook(2, i * incx)] * x[hook(2, i * incx)];
  }
  *result = sqrt(sum);
}