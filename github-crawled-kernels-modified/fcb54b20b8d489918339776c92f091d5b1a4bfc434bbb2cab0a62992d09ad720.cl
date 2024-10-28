//{"A":0,"nx":3,"ny":4,"r":1,"s":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void bicgKernel2(global float* A, global float* r, global float* s, int nx, int ny) {
  int j = get_global_id(0);

  if (j < ny) {
    s[hook(2, j)] = 0.0;

    int i;
    for (i = 0; i < nx; i++) {
      s[hook(2, j)] += A[hook(0, i * ny + j)] * r[hook(1, i)];
    }
  }
}