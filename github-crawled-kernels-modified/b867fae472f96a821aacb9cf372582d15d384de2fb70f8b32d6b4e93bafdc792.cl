//{"dest":1,"dst_step":3,"source":0,"src_step":2,"value_arg":5,"width":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mean_constant(global const uchar* source, global uchar* dest, int src_step, int dst_step, int width, float value_arg) {
  const int gx = get_global_id(0);
  const int gy = get_global_id(1);
  src_step /= sizeof(uchar);
  dst_step /= sizeof(uchar);
  float value = value_arg;
  const float8 src = convert_float8(*(const global uchar8*)(source + gx * 8));
  *(global uchar8*)(dest + gx * 8) = convert_uchar8_sat((((src + value) * .5f)));
}