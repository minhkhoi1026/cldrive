//{"eq_flag":0,"offset_x":2,"offset_y":5,"stride_x":3,"stride_y":6,"x":1,"y":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void equals_vector(global unsigned int* eq_flag, global const float* x, const unsigned int offset_x, const unsigned int stride_x, global const float* y, const unsigned int offset_y, const unsigned int stride_y) {
  unsigned int ix = offset_x + get_global_id(0) * stride_x;
  unsigned int iy = offset_y + get_global_id(0) * stride_y;
  if ((x[hook(1, ix)] != y[hook(4, iy)])) {
    eq_flag[hook(0, 0)]++;
  }
}