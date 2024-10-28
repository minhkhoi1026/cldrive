//{"offset_x":2,"stride_x":3,"val":0,"x":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
__attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) kernel void vector_set(const float val, global float* x, const unsigned int offset_x, const unsigned int stride_x) {
  x[hook(1, offset_x + get_global_id(0) * stride_x)] = val;
}