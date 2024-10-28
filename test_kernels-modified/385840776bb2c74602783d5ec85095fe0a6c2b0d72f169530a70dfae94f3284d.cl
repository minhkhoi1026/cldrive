//{"X":0,"out":2,"xdims":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void argmax(global float* X, global int* xdims, global int* out) {
  int i = get_global_id(0);
  int xdims0 = xdims[hook(1, 0)];
  int xdims1 = xdims[hook(1, 1)];

  if (i < xdims0) {
    int max_idx = 0;
    float max = X[hook(0, i * xdims1)];
    for (int j = 0; j < xdims1; j++) {
      float elem = X[hook(0, (i * xdims1) + j)];
      if (elem > max) {
        max_idx = j;
        max = elem;
      }
    }
    out[hook(2, i)] = max_idx;
  }
}