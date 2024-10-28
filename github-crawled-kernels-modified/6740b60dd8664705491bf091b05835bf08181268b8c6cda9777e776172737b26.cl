//{"blocklength_e":4,"count":6,"dst":0,"dst_off_e":1,"src":2,"src_off_e":3,"stride_e":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void _XACC_unpack_vector_8(global char* dst, unsigned long dst_off_e, global const char* src, unsigned long src_off_e, unsigned long blocklength_e, unsigned long stride_e, unsigned long count) {
  const size_t c_init = get_global_id(1);
  const size_t c_step = get_global_size(1);
  const size_t b_init = get_global_id(0);
  const size_t b_step = get_global_size(0);
  size_t c, b;
  for (c = c_init; c < count; c += c_step) {
    for (b = b_init; b < blocklength_e; b += b_step) {
      dst[hook(0, dst_off_e + stride_e * c + b)] = src[hook(2, src_off_e + blocklength_e * c + b)];
    }
  }
}