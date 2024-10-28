//{"offset_x":1,"offset_y":4,"offset_z":11,"scalea":6,"scaleb":8,"shifta":7,"shiftb":9,"stride_x":2,"stride_y":5,"stride_z":12,"x":0,"y":3,"z":10}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
__attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) kernel void vector_linear_frac(global const float* x, const unsigned int offset_x, const unsigned int stride_x, global const float* y, const unsigned int offset_y, const unsigned int stride_y, const float scalea, const float shifta, const float scaleb, const float shiftb, global float* z, const unsigned int offset_z, const unsigned int stride_z) {
  z[hook(10, offset_z + get_global_id(0) * stride_z)] = (scalea * x[hook(0, offset_x + get_global_id(0) * stride_x)] + shifta) / (scaleb * y[hook(3, offset_y + get_global_id(0) * stride_y)] + shiftb);
}