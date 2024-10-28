//{"dst":0,"src":1,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void DecodeRGBA8(global ushort* dst, const global ushort* src, int width) {
  int x = get_global_id(0) * 4, y = get_global_id(1) * 4;
  int srcOffset = (x * 2) + (y * width) / 2;
  for (int iy = 0; iy < 4; iy++) {
    ushort8 val = (ushort8)(vload4(srcOffset, src), vload4(srcOffset + 4, src));
    ushort8 temp = rotate(val, (ushort8)4);
    ushort8 bgra = rotate(temp, (ushort8)4).s40516273;
    vstore8(bgra, 0, dst + ((y + iy) * width + x) * 2);
    srcOffset++;
  }
}