//{"alpha":0,"n":4,"x":1,"y":2,"z":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void saxpy(float alpha, global float* x, global float* y, global float* z, int n) {
  int i = get_global_id(0);
  int j = get_global_id(1);

  if ((i < n) && (j < n)) {
    z[hook(3, i * n + j)] = alpha * x[hook(1, i * n + j)] + y[hook(2, i * n + j)];
  }
}