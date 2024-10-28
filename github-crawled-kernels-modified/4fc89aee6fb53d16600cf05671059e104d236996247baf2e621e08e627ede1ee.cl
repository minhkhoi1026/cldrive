//{"L":0,"x":1,"y":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void solver(global float* restrict L, global float* restrict x, global float* restrict y) {
  int i, j;

  for (i = 0; i < 20; i++) {
    y[hook(2, i)] = 1.0;
    for (j = 0; j < i; j++) {
      y[hook(2, i)] -= L[hook(0, i * 20 + j)] * y[hook(2, j)];
    }
    y[hook(2, i)] /= L[hook(0, i * 20 + i)];
  }

  for (i = 20 - 1; i >= 0; i--) {
    x[hook(1, i)] = y[hook(2, i)];
    for (j = i + 1; j < 20; j++) {
      x[hook(1, i)] -= L[hook(0, j * 20 + i)] * x[hook(1, j)];
    }
    x[hook(1, i)] /= L[hook(0, i * 20 + i)];
  }
}