//{"a":1,"b":2,"c":4,"n":0,"s":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void weighted_sum_kernel(int n, global float* a, global float* b, global float* s, global float* c) {
  int i = get_global_id(2) * get_global_size(0) * get_global_size(1) + get_global_id(1) * get_global_size(0) + get_global_id(0);
  float m = 0.0;
  if (b != 0)
    m = b[hook(2, i)];
  if (i < n) {
    c[hook(4, i)] = s[hook(3, i)] * a[hook(1, i)] + (1 - s[hook(3, i)]) * m;
  }
}