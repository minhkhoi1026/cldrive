//{"dst":0,"src":1,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void DecodeRGBA8_RGBA(global uchar* dst, const global uchar* src, int width) {
  int x = get_global_id(0) * 4, y = get_global_id(1) * 4;
  int srcOffset = (x * 2) + (y * width) / 2;
  for (int iy = 0; iy < 4; iy++) {
    uchar8 ar = vload8(srcOffset, src);
    uchar8 gb = vload8(srcOffset + 4, src);
    uchar16 res;
    res.even.even = ar.odd;
    res.even.odd = gb.odd;
    res.odd.even = gb.even;
    res.odd.odd = ar.even;
    vstore16(res, 0, dst + ((y + iy) * width + x) * 4);
    srcOffset++;
  }
}