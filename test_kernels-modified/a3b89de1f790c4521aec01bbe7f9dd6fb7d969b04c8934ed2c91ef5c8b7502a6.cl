//{"alpha":0,"beta":4,"offset_x":2,"offset_y":6,"stride_x":3,"stride_y":7,"x":1,"y":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
__attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) kernel void vector_axpby(float alpha, global const float* x, const unsigned int offset_x, const unsigned int stride_x, float beta, global float* y, const unsigned int offset_y, const unsigned int stride_y) {
  const unsigned int ix = offset_x + get_global_id(0) * stride_x;
  const unsigned int iy = offset_y + get_global_id(0) * stride_y;
  y[hook(5, iy)] = alpha * x[hook(1, ix)] + beta * y[hook(5, iy)];
}