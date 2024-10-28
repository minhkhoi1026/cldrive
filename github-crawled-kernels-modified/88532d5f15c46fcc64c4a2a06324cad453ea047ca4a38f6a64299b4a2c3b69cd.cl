//{"dst":2,"offsets":1,"src":0,"w":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void my_test(global int2* src, global int* offsets, global uint2* dst, int w) {
  int i, index, j;
  uint2 out;
  unsigned int a, b, c, d;
  int2 rle;
  int gid = get_global_id(0);
  index = offsets[hook(1, gid)];
  int i0 = 0;
  rle = src[hook(0, index)];
  for (i = 0; i < w; i++, i0 += 8) {
    if (i0 + 0 >= rle.x) {
      index++;
      rle = src[hook(0, index)];
    }
    a = rle.y;
    if (i0 + 1 >= rle.x) {
      index++;
      rle = src[hook(0, index)];
    }
    b = rle.y;
    if (i0 + 2 >= rle.x) {
      index++;
      rle = src[hook(0, index)];
    }
    c = rle.y;
    if (i0 + 3 >= rle.x) {
      index++;
      rle = src[hook(0, index)];
    }
    d = rle.y;
    out.x = (d << 24) | (c << 16) | (b << 8) | (a);
    if (i0 + 4 >= rle.x) {
      index++;
      rle = src[hook(0, index)];
    }
    a = rle.y;
    if (i0 + 5 >= rle.x) {
      index++;
      rle = src[hook(0, index)];
    }
    b = rle.y;
    if (i0 + 6 >= rle.x) {
      index++;
      rle = src[hook(0, index)];
    }
    c = rle.y;
    if (i0 + 7 >= rle.x) {
      index++;
      rle = src[hook(0, index)];
    }
    d = rle.y;
    out.y = (d << 24) | (c << 16) | (b << 8) | (a);

    dst[hook(2, gid * w + i)] = out;
  }
}