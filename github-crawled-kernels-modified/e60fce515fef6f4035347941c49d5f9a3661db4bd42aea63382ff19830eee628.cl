//{"Pitch":4,"dst":1,"dstOffset":3,"input":0,"srcOffset":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void CopyImage3dToBuffer8Bytes(read_only image3d_t input, global uchar* dst, int4 srcOffset, int dstOffset, uint2 Pitch) {
  const unsigned int x = get_global_id(0);
  const unsigned int y = get_global_id(1);
  const unsigned int z = get_global_id(2);

  const int4 srcCoord = (int4)(x, y, z, 0) + srcOffset;
  unsigned int DstOffset = dstOffset + (y * Pitch.x) + (z * Pitch.y);

  uint4 c = read_imageui(input, srcCoord);

  if ((ulong)(dst + dstOffset) & 0x00000007) {
    *((global uchar*)(dst + DstOffset + x * 8 + 3)) = convert_uchar_sat((c.x >> 24) & 0xff);
    *((global uchar*)(dst + DstOffset + x * 8 + 2)) = convert_uchar_sat((c.x >> 16) & 0xff);
    *((global uchar*)(dst + DstOffset + x * 8 + 1)) = convert_uchar_sat((c.x >> 8) & 0xff);
    *((global uchar*)(dst + DstOffset + x * 8)) = convert_uchar_sat(c.x & 0xff);
    *((global uchar*)(dst + DstOffset + x * 8 + 7)) = convert_uchar_sat((c.y >> 24) & 0xff);
    *((global uchar*)(dst + DstOffset + x * 8 + 6)) = convert_uchar_sat((c.y >> 16) & 0xff);
    *((global uchar*)(dst + DstOffset + x * 8 + 5)) = convert_uchar_sat((c.y >> 8) & 0xff);
    *((global uchar*)(dst + DstOffset + x * 8 + 4)) = convert_uchar_sat(c.y & 0xff);
  } else {
    uint2 d = (uint2)(c.x, c.y);
    *((global uint2*)(dst + DstOffset + x * 8)) = d;
  }
}