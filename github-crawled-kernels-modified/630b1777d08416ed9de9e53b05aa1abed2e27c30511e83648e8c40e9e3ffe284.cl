//{"a":1,"b":2,"c":3,"n":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mult_add_into_kernel(int n, global float* a, global float* b, global float* c) {
  int i = get_global_id(2) * get_global_size(0) * get_global_size(1) + get_global_id(1) * get_global_size(0) + get_global_id(0);
  if (i < n) {
    c[hook(3, i)] += a[hook(1, i)] * b[hook(2, i)];
  }
}