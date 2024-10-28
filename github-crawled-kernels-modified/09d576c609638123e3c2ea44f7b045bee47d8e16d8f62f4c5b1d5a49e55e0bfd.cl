//{"a":0,"b":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void array_negate_f32(global float* a, global float* b) {
  unsigned int i = get_global_id(0);
  b[hook(1, i)] = -a[hook(0, i)];
}