//{"A":3,"b":5,"m":1,"n":0,"x":4,"y":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void simpleMV(const int n, const int m, global float* y, global float* A, global float* x, global float* b) {
  int i = get_global_id(0);
  if (i < n) {
    float yi = b[hook(5, i)];
    for (int j = 0; j < m; ++j) {
      yi += A[hook(3, j + i * m)] * x[hook(4, j)];
    }
    y[hook(2, i)] = yi;
  }
}