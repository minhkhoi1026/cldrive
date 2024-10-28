//{"Pitch":4,"dst":1,"dstOffset":3,"input":0,"srcOffset":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void CopyImage3dToBufferBytes(read_only image3d_t input, global uchar* dst, int4 srcOffset, int dstOffset, uint2 Pitch) {
  const unsigned int x = get_global_id(0);
  const unsigned int y = get_global_id(1);
  const unsigned int z = get_global_id(2);

  const int4 srcCoord = (int4)(x, y, z, 0) + srcOffset;
  unsigned int DstOffset = dstOffset + (y * Pitch.x) + (z * Pitch.y);

  uint4 c = read_imageui(input, srcCoord);
  *(dst + DstOffset + x) = convert_uchar_sat(c.x);
}