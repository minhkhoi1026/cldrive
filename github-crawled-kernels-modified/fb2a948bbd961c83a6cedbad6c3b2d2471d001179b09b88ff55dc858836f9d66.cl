//{"a":0,"b":1,"c":2,"n":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void MultNaive(global float* a, global float* b, global float* c, unsigned int n) {
  unsigned int col = get_global_id(0);
  unsigned int row = get_global_id(1);

  if (row >= n || col >= n)
    return;

  float sum = 0.0f;
  for (unsigned int i = 0; i < n; i++)
    sum += a[hook(0, row * n + i)] * b[hook(1, i * n + col)];

  c[hook(2, row * n + col)] = sum;
}