//{"incx":2,"incy":4,"n":0,"result":5,"x":1,"y":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Sdot_naive(int n, global float* x, int incx, global float* y, int incy, global float* result) {
  float acc = 0.f;
  for (int i = 0; i < n; ++i) {
    acc += x[hook(1, i * incx)] * y[hook(3, i * incy)];
    ;
  }

  result[hook(5, 0)] = acc;
}