//{"Pitch":4,"dst":1,"dstOffset":3,"input":0,"srcOffset":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void CopyImage3dToBuffer2Bytes(read_only image3d_t input, global uchar* dst, int4 srcOffset, int dstOffset, uint2 Pitch) {
  const unsigned int x = get_global_id(0);
  const unsigned int y = get_global_id(1);
  const unsigned int z = get_global_id(2);

  const int4 srcCoord = (int4)(x, y, z, 0) + srcOffset;
  unsigned int DstOffset = dstOffset + (y * Pitch.x) + (z * Pitch.y);

  uint4 c = read_imageui(input, srcCoord);

  if ((ulong)(dst + dstOffset) & 0x00000001) {
    *((global uchar*)(dst + DstOffset + x * 2 + 1)) = convert_uchar_sat((c.x >> 8) & 0xff);
    *((global uchar*)(dst + DstOffset + x * 2)) = convert_uchar_sat(c.x & 0xff);
  } else {
    *((global ushort*)(dst + DstOffset + x * 2)) = convert_ushort_sat(c.x);
  }
}