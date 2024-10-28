//{"L":0,"n":1,"x":2,"y":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void solver(global float* restrict L, int n, global float* restrict x, global float* restrict y) {
  int i, j;

  for (i = 0; i < n; i++) {
    y[hook(3, i)] = 1.0;
    for (j = 0; j < i; j++) {
      y[hook(3, i)] -= L[hook(0, i * n + j)] * y[hook(3, j)];
    }
    y[hook(3, i)] /= L[hook(0, i * n + i)];
  }

  for (i = n - 1; i >= 0; i--) {
    x[hook(2, i)] = y[hook(3, i)];
    for (j = i + 1; j < n; j++) {
      x[hook(2, i)] -= L[hook(0, j * n + i)] * x[hook(2, j)];
    }
    x[hook(2, i)] /= L[hook(0, i * n + i)];
  }
}