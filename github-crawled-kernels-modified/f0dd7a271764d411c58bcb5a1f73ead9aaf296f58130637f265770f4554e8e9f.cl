//{"dest":1,"dst_step":3,"source":0,"src_step":2,"thresh_arg":5,"value_arg":6,"width":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void threshold_EQ(global const uchar* source, global uchar* dest, int src_step, int dst_step, int width, float thresh_arg, float value_arg) {
  const int gx = get_global_id(0);
  const int gy = get_global_id(1);
  src_step /= sizeof(uchar);
  dst_step /= sizeof(uchar);
  uchar value = value_arg;
  uchar thresh = thresh_arg;
  const uchar8 src = *(const global uchar8*)(source + gx * 8);
  *(global uchar8*)(dest + gx * 8) = convert_uchar8_sat((((src == thresh ? value : src))));
}