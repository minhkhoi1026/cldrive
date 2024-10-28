//{"blocklength":4,"count":6,"dst":0,"dst_off":1,"src":2,"src_off":3,"stride":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void _XACC_pack_vector(global char* dst, unsigned long dst_off, global const char* src, unsigned long src_off, unsigned long blocklength, unsigned long stride, unsigned long count) {
  const size_t c_init = get_global_id(1);
  const size_t c_step = get_global_size(1);
  const size_t b_init = get_global_id(0);
  const size_t b_step = get_global_size(0);
  size_t c, b;
  for (c = c_init; c < count; c += c_step) {
    for (b = b_init; b < blocklength; b += b_step) {
      dst[hook(0, dst_off + blocklength * c + b)] = src[hook(2, src_off + stride * c + b)];
    }
  }
}