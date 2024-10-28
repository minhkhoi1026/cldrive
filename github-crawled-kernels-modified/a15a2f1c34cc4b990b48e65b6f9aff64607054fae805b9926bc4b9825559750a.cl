//{"buf":0,"height":2,"width":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test3(global float* buf, int width, int height) {
  int gidx = get_global_id(0);
  int gidy = get_global_id(1);

  int ofs = gidy * width + gidx * 8;
  int8 idx = (int8){0, 1, 2, 3, 4, 5, 6, 7};
  idx += ofs;
  vstore8(log(convert_float8(idx)), 0, buf + ofs);
}