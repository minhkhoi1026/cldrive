//{"a":0,"b":1,"c":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vector_add(const global float* a, const global float* b, global float* c) {
  c[hook(2, get_global_id(0))] = a[hook(0, get_global_id(0))] + b[hook(1, get_global_id(0))];
}