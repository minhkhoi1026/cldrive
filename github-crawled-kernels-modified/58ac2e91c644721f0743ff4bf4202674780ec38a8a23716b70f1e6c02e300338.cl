//{"a":0,"b":1,"c":2,"n":3,"p":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Mat_mult(global float* a, global float* b, global float* c, int n, int p) {
  int i = get_global_id(0);
  int j = get_global_id(1);
  int k;
  float sum = 0;

  for (k = 0; k < n; k++)
    sum += a[hook(0, i * n + k)] * b[hook(1, k * p + j)];
  c[hook(2, i * p + j)] = sum;
}