//{"a":0,"b":1,"res_mem":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void add(global float* a, global float* b, global float* res_mem) {
  size_t n = get_global_size(0);
  size_t x = get_global_id(0);
  size_t y = get_global_id(1);

  float sum = 0;
  for (int i = 0; i < n; ++i) {
    sum += a[hook(0, y * n + i)] * b[hook(1, i * n + x)];
  }

  res_mem[hook(2, y * n + x)] = sum;
}