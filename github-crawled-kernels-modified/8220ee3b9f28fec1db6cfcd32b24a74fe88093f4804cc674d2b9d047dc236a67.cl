//{"dst_data":1,"new_wd":3,"old_wd":2,"scale_x":4,"scale_y":5,"src_data":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void image_resize_uint32(global const unsigned int* src_data, global unsigned int* dst_data, const int old_wd, const int new_wd, const double scale_x, const double scale_y) {
  const int ix = get_global_id(1);
  const int iy = get_global_id(0);

  int new_idx = iy * new_wd + ix;
  int old_idx = convert_int_rtz(iy * (1.0 / scale_y)) * old_wd + convert_int_rtz(ix * (1.0 / scale_x));

  dst_data[hook(1, new_idx)] = src_data[hook(0, old_idx)];
}