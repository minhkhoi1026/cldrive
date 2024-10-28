//{"dst":0,"src":1,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void DecodeI4(global uchar* dst, const global uchar* src, int width) {
  int x = get_global_id(0) * 8, y = get_global_id(1) * 8;
  int srcOffset = x + y * width / 8;
  for (int iy = 0; iy < 8; iy++) {
    uchar4 val = vload4(srcOffset, src);
    uchar8 res;
    res.even = (val >> (uchar4)4) & (uchar4)0x0F;
    res.odd = val & (uchar4)0x0F;
    res |= res << (uchar8)4;
    vstore8(res, 0, dst + ((y + iy) * width + x));
    srcOffset++;
  }
}