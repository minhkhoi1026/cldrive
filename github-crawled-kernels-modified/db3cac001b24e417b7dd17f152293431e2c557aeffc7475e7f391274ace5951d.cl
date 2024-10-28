//{"dst":0,"height":3,"src":1,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mean_filter(global uchar* dst, global const uchar* src, const int width, const int height) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);
  const int idx = y * width + x;

  float r = 0;
  float n = 0;
  for (int i = ((x - 2) < (0) ? (0) : ((x - 2) > (width) ? (width) : (x - 2))); i < ((x + 2) < (0) ? (0) : ((x + 2) > (width) ? (width) : (x + 2))); i++)
    for (int j = ((y - 2) < (0) ? (0) : ((y - 2) > (height) ? (height) : (y - 2))); j < ((y + 2) < (0) ? (0) : ((y + 2) > (height) ? (height) : (y + 2))); j++) {
      r += src[hook(1, j * width + i)];
      n += 1;
    }

  dst[hook(0, idx)] = r / n;
}