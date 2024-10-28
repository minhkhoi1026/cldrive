//{"dst":0,"src":1,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void DecodeIA4(global ushort* dst, const global uchar* src, int width) {
  int x = get_global_id(0) * 8, y = get_global_id(1) * 4;
  int srcOffset = ((x * 4) + (y * width)) / 8;
  uchar8 val;
  ushort8 res;
  for (int iy = 0; iy < 4; iy++) {
    val = vload8(srcOffset++, src);
    res = upsample(val >> (uchar8)4, val & (uchar8)0xF);
    res |= res << (ushort8)4;
    vstore8(res, 0, dst + y * width + x);
    dst += width;
  }
}