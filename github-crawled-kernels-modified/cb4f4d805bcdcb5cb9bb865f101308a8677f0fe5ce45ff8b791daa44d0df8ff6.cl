//{"offset_x":1,"offset_y":4,"stride_x":2,"stride_y":5,"x":0,"y":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mul(global float* x, const unsigned int offset_x, const unsigned int stride_x, global const float* y, const unsigned int offset_y, const unsigned int stride_y) {
  const unsigned int ix = offset_x + get_global_id(0) + get_global_id(1) * stride_x;
  const unsigned int iy = offset_y + get_global_id(0) + get_global_id(1) * stride_y;
  x[hook(0, ix)] = x[hook(0, ix)] * y[hook(3, iy)];
}