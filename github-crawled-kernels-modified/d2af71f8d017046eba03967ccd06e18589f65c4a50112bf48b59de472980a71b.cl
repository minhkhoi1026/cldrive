//{"A":0,"nx":3,"ny":4,"p":1,"q":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void bicgKernel1(global float* A, global float* p, global float* q, int nx, int ny) {
  int i = get_global_id(0);

  if (i < nx) {
    q[hook(2, i)] = 0.0;

    int j;
    for (j = 0; j < ny; j++) {
      q[hook(2, i)] += A[hook(0, i * ny + j)] * p[hook(1, j)];
    }
  }
}