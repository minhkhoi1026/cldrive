//{"dst":0,"src":1,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void DecodeRGB565_RGBA(global uchar* dst, const global uchar* src, int width) {
  int x = get_global_id(0) * 4, y = get_global_id(1) * 4;
  int srcOffset = x + (y * width) / 4;
  for (int iy = 0; iy < 4; iy++) {
    uchar8 val = vload8(srcOffset++, src);

    uchar16 res;
    res.even.even = bitselect(val.even, val.even >> (uchar4)5, (uchar4)7);
    res.odd.even = bitselect((val.odd >> (uchar4)3) | (val.even << (uchar4)5), val.even >> (uchar4)1, (uchar4)3);
    res.even.odd = bitselect(val.odd << (uchar4)3, val.odd >> (uchar4)2, (uchar4)7);
    res.odd.odd = (uchar4)0xFF;

    vstore16(res, 0, dst + ((y + iy) * width + x) * 4);
  }
}