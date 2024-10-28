//{"A":0,"a":4,"ncols":2,"x":1,"y":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void matvec(global const float* A, global const float* x, unsigned int ncols, global float* y) {
  size_t i = get_global_id(0);
  global float const* a = &A[hook(0, i * ncols)];
  float sum = 0.f;
  for (size_t j = 0; j < ncols; j++) {
    sum += a[hook(4, j)] * x[hook(1, j)];
  }
  y[hook(3, i)] = sum;
}