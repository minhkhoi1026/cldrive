//{"dest":2,"dst_step":5,"source1":0,"source2":1,"src1_step":3,"src2_step":4,"width":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void or_images(global const uchar* source1, global const uchar* source2, global uchar* dest, int src1_step, int src2_step, int dst_step, int width) {
  const int gx = get_global_id(0);
  const int gy = get_global_id(1);
  src1_step /= sizeof(uchar);
  src2_step /= sizeof(uchar);
  dst_step /= sizeof(uchar);
  const uchar8 src1 = *(const global uchar8*)(source1 + gx * 8);
  const uchar8 src2 = *(const global uchar8*)(source2 + gx * 8);
  *(global uchar8*)(dest + gx * 8) = convert_uchar8_sat(((src1 | src2)));
}