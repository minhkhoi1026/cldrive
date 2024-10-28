//{"dst":0,"src":1,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
uint16 unpack(uchar b) {
  return (uint16)((uint4)(b >> 3 & 0x18), (uint4)(b >> 1 & 0x18), (uint4)(b << 1 & 0x18), (uint4)(b << 3 & 0x18));
}

kernel void decodeCMPRBlock(global uchar* dst, const global uchar* src, int width) {
  int x = get_global_id(0) * 4, y = get_global_id(1) * 4;
  uchar8 val = vload8(0, src);

  uchar2 colora565 = (uchar2)(val.s1, val.s3);
  uchar2 colorb565 = (uchar2)(val.s0, val.s2);
  uchar8 color32 = (uchar8)(bitselect(colora565 << (uchar2)3, colora565 >> (uchar2)2, (uchar2)7), bitselect((colora565 >> (uchar2)3) | (colorb565 << (uchar2)5), colorb565 >> (uchar2)1, (uchar2)3), bitselect(colorb565, colorb565 >> (uchar2)5, (uchar2)7), (uchar2)0xFF);

  ushort4 frac2 = convert_ushort4(color32.even) - convert_ushort4(color32.odd);
  uchar4 frac = convert_uchar4((frac2 * (ushort4)3) / (ushort4)8);

  ushort4 colorAlpha = upsample((uchar4)(color32.even.s0, color32.even.s1, color32.even.s2, 0), rhadd(color32.odd, color32.even));
  colorAlpha.s3 = 0xFF;
  ushort4 colorNoAlpha = upsample(color32.odd + frac, color32.even - frac);

  uint4 colors = upsample((upsample(val.s0, val.s1) > upsample(val.s2, val.s3)) ? colorNoAlpha : colorAlpha, upsample(color32.odd, color32.even));

  uint16 colorsFull = (uint16)(colors, colors, colors, colors);

  vstore16(convert_uchar16(colorsFull >> unpack(val.s4)), 0, dst);
  vstore16(convert_uchar16(colorsFull >> unpack(val.s5)), 0, dst += width * 4);
  vstore16(convert_uchar16(colorsFull >> unpack(val.s6)), 0, dst += width * 4);
  vstore16(convert_uchar16(colorsFull >> unpack(val.s7)), 0, dst += width * 4);
}