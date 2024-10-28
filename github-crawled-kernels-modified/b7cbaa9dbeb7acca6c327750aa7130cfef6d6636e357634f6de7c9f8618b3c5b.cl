//{"dst":0,"src":1,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void DecodeIA4_RGBA(global unsigned int* dst, const global uchar* src, int width) {
  int x = get_global_id(0) * 8, y = get_global_id(1) * 4;
  int srcOffset = ((x * 4) + (y * width)) / 8;
  uchar8 val;
  uint8 res;
  for (int iy = 0; iy < 4; iy++) {
    val = vload8(srcOffset++, src);
    uchar8 a = val >> (uchar8)4;
    uchar8 l = val & (uchar8)0xF;
    res = upsample(upsample(a, l), upsample(l, l));
    res |= res << (uint8)4;
    vstore8(res, 0, dst + y * width + x);
    dst += width;
  }
}