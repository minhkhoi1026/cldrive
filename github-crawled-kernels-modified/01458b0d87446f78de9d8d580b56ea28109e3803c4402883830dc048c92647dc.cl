//{"a":0,"b":1,"c":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void outerprod_kern(global float* a, global float* b, global float* c) {
  int i = get_global_id(0);
  c[hook(2, i)] = 1 * a[hook(0, i)] * b[hook(1, i)];
}