//{"Pitch":4,"dst":1,"dstOffset":3,"input":0,"srcOffset":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void CopyImage3dToBuffer16Bytes(read_only image3d_t input, global uchar* dst, int4 srcOffset, int dstOffset, uint2 Pitch) {
  const unsigned int x = get_global_id(0);
  const unsigned int y = get_global_id(1);
  const unsigned int z = get_global_id(2);

  const int4 srcCoord = (int4)(x, y, z, 0) + srcOffset;
  unsigned int DstOffset = dstOffset + (y * Pitch.x) + (z * Pitch.y);

  const uint4 c = read_imageui(input, srcCoord);

  if ((ulong)(dst + dstOffset) & 0x0000000f) {
    *((global uchar*)(dst + DstOffset + x * 16 + 3)) = convert_uchar_sat((c.x >> 24) & 0xff);
    *((global uchar*)(dst + DstOffset + x * 16 + 2)) = convert_uchar_sat((c.x >> 16) & 0xff);
    *((global uchar*)(dst + DstOffset + x * 16 + 1)) = convert_uchar_sat((c.x >> 8) & 0xff);
    *((global uchar*)(dst + DstOffset + x * 16)) = convert_uchar_sat(c.x & 0xff);
    *((global uchar*)(dst + DstOffset + x * 16 + 7)) = convert_uchar_sat((c.y >> 24) & 0xff);
    *((global uchar*)(dst + DstOffset + x * 16 + 6)) = convert_uchar_sat((c.y >> 16) & 0xff);
    *((global uchar*)(dst + DstOffset + x * 16 + 5)) = convert_uchar_sat((c.y >> 8) & 0xff);
    *((global uchar*)(dst + DstOffset + x * 16 + 4)) = convert_uchar_sat(c.y & 0xff);
    *((global uchar*)(dst + DstOffset + x * 16 + 11)) = convert_uchar_sat((c.z >> 24) & 0xff);
    *((global uchar*)(dst + DstOffset + x * 16 + 10)) = convert_uchar_sat((c.z >> 16) & 0xff);
    *((global uchar*)(dst + DstOffset + x * 16 + 9)) = convert_uchar_sat((c.z >> 8) & 0xff);
    *((global uchar*)(dst + DstOffset + x * 16 + 8)) = convert_uchar_sat(c.z & 0xff);
    *((global uchar*)(dst + DstOffset + x * 16 + 15)) = convert_uchar_sat((c.w >> 24) & 0xff);
    *((global uchar*)(dst + DstOffset + x * 16 + 14)) = convert_uchar_sat((c.w >> 16) & 0xff);
    *((global uchar*)(dst + DstOffset + x * 16 + 13)) = convert_uchar_sat((c.w >> 8) & 0xff);
    *((global uchar*)(dst + DstOffset + x * 16 + 12)) = convert_uchar_sat(c.w & 0xff);
  } else {
    *(global uint4*)(dst + DstOffset + x * 16) = c;
  }
}