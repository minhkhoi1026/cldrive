//{"dst":0,"src":1,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void DecodeIA8(global ushort* dst, const global uchar* src, int width) {
  int x = get_global_id(0) * 4, y = get_global_id(1) * 4;
  int srcOffset = ((x * 4) + (y * width)) / 4;
  for (int iy = 0; iy < 4; iy++) {
    uchar8 val = vload8(srcOffset++, src);
    vstore4(upsample(val.even, val.odd), 0, dst + ((y + iy) * width + x));
  }
}