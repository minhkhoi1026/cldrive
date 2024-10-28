//{"dst":0,"src":1,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void DecodeRGB565(global ushort* dst, const global ushort* src, int width) {
  int x = get_global_id(0) * 4, y = get_global_id(1) * 4;
  int srcOffset = x + (y * width) / 4;
  dst += width * y + x;
  for (int iy = 0; iy < 4; iy++) {
    ushort4 val = rotate(vload4(srcOffset++, src), (ushort4)4);
    vstore4(rotate(val, (ushort4)4), 0, dst + iy * width);
  }
}