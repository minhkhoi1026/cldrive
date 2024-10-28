//{"X":0,"out":2,"xdims":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void relu2D(global float* X, global int* xdims, global float* out) {
  int i = get_global_id(0);
  int total = xdims[hook(1, 0)] * xdims[hook(1, 1)];
  if (i < total) {
    out[hook(2, i)] = (X[hook(0, i)] < 0) ? 0 : X[hook(0, i)];
  }
}