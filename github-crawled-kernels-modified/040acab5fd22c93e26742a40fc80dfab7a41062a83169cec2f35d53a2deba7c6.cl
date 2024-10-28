//{"dst":0,"height":3,"src":1,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void median_filter(global uchar* dst, global const uchar* src, const int width, const int height) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);
  const int idx = y * width + x;

  float rx = 0, ri = 255;
  for (int i = ((x - 4) < (0) ? (0) : ((x - 4) > (width) ? (width) : (x - 4))); i < ((x + 4) < (0) ? (0) : ((x + 4) > (width) ? (width) : (x + 4))); i++)
    for (int j = ((y - 4) < (0) ? (0) : ((y - 4) > (height) ? (height) : (y - 4))); j < ((y + 4) < (0) ? (0) : ((y + 4) > (height) ? (height) : (y + 4))); j++) {
      float v = (float)src[hook(1, j * width + i)];
      rx = max((float)rx, v);
      ri = min((float)ri, v);
    }

  dst[hook(0, idx)] = (rx + ri) / 2;
}