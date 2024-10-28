//{"a":0,"c":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void multiply_float_const(global float* restrict a, global float* restrict c) {
  size_t index = get_global_id(0);
  c[hook(1, index)] = a[hook(0, index)] * 3.0;
}