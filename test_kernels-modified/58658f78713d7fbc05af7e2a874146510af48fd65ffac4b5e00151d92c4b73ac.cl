//{"cols":3,"dst":2,"src":1,"t":4,"wall":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void dynproc_kernel(global int* restrict wall, global int* restrict src, global int* restrict dst, int cols, int t) {
  for (int n = 0; n < cols; n++) {
    int min = src[hook(1, n)];
    if (n > 0) {
      min = ((min) <= (src[hook(1, n - 1)]) ? (min) : (src[hook(1, n - 1)]));
    }
    if (n < cols - 1) {
      min = ((min) <= (src[hook(1, n + 1)]) ? (min) : (src[hook(1, n + 1)]));
    }
    dst[hook(2, n)] = wall[hook(0, (t + 1) * cols + n)] + min;
  }
}