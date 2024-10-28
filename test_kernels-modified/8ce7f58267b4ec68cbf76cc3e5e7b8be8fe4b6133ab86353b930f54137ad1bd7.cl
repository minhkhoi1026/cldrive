//{"a":0,"cols":2,"rows":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void complex_fftshift(global double2* a, int rows, int cols) {
  unsigned int n = get_global_id(0);
  if (n < rows * cols / 2) {
    int i = n % rows;
    int m;
    if (i < rows / 2) {
      m = n + rows * cols / 2 + rows / 2;
    } else {
      m = n + rows * cols / 2 - rows / 2;
    }
    double2 tmp = a[hook(0, n)];
    a[hook(0, n)] = a[hook(0, m)];
    a[hook(0, m)] = tmp;
  }
}