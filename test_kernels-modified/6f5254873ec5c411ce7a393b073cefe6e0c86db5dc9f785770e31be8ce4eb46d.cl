//{"cols":3,"dst":2,"src":1,"t":4,"wall":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
__attribute__((max_global_work_dim(0))) kernel void dynproc_kernel(global int* restrict wall, global int* restrict src, global int* restrict dst, int cols, int t) {
  for (int n = 0; n < cols; n++) {
    int min = src[hook(1, n)];

    int right = src[hook(1, n + 1)];
    int left = src[hook(1, n - 1)];

    if (n > 0) {
      min = ((min) <= (left) ? (min) : (left));
    }
    if (n < cols - 1) {
      min = ((min) <= (right) ? (min) : (right));
    }
    dst[hook(2, n)] = wall[hook(0, (t + 1) * cols + n)] + min;
  }
}