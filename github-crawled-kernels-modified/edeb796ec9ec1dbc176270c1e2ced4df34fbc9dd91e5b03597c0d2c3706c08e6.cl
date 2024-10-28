//{"a":0,"b":1,"c":2,"result":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void fma_test(global float* a, global float* b, global float* c, global float* result) {
  size_t id = get_global_id(0);
  result[hook(3, get_global_id(0))] = fma(a[hook(0, id)], b[hook(1, id)], c[hook(2, id)]);
}