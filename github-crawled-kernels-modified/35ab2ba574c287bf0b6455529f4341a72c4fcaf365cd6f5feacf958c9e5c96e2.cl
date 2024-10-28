//{"a":1,"b":2,"c":0,"width":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void matrixMul(global double* c, global double* a, global double* b, int width) {
  double sum = 0;

  int row = get_global_id(1);
  int col = get_global_id(0);

  if (row < width && col < width) {
    for (int k = 0; k < width; k++)
      sum += a[hook(1, row * width + k)] * b[hook(2, k * width + col)];

    c[hook(0, row * width + col)] = sum;
  }
}