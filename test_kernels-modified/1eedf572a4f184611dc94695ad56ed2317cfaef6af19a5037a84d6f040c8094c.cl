//{"offset_x":1,"offset_y":4,"offset_z":7,"stride_x":2,"stride_y":5,"stride_z":8,"x":0,"y":3,"z":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
__attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) kernel void vector_pow(global const float* x, const unsigned int offset_x, const unsigned int stride_x, global const float* y, const unsigned int offset_y, const unsigned int stride_y, global float* z, const unsigned int offset_z, const unsigned int stride_z) {
  z[hook(6, offset_z + get_global_id(0) * stride_z)] = pow(x[hook(0, offset_x + get_global_id(0) * stride_x)], y[hook(3, offset_y + get_global_id(0) * stride_y)]);
}