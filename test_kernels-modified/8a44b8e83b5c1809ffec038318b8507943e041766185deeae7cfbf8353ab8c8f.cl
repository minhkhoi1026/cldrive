//{"offset_x":1,"offset_y":6,"scalea":3,"shifta":4,"stride_x":2,"stride_y":7,"x":0,"y":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
__attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) kernel void vector_scale_shift(global const float* x, const unsigned int offset_x, const unsigned int stride_x, const float scalea, const float shifta, global float* y, const unsigned int offset_y, const unsigned int stride_y) {
  y[hook(5, offset_y + get_global_id(0) * stride_y)] = scalea * x[hook(0, offset_x + get_global_id(0) * stride_x)] + shifta;
}