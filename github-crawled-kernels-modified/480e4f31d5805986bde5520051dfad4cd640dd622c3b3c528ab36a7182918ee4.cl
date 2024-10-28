//{"height":2,"pIn":0,"pOut":3,"row":5,"row[r]":4,"width":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void BoxFilter_32F(global const float* pIn, const int width, const int height, global float* pOut) {
  int load_rows = 9;

  const int x = get_global_id(0) * 16;
  const int y = get_global_id(1);
  const int d = get_global_id(2);

  const int offset = (((d * height) + y) * width) + x;

  float16 row[9][9];
  float16 res;

  for (int r = 0; r < load_rows; r++) {
    row[hook(5, r)][hook(4, 0)] = vload16(0, pIn + offset + width * r);
    row[hook(5, r)][hook(4, 8)] = vload16(0, pIn + offset + width * r + 8);
    row[hook(5, r)][hook(4, 1)] = (float16)(row[hook(5, r)][hook(4, 0)].s12345678, row[hook(5, r)][hook(4, 8)].s12345678);
    row[hook(5, r)][hook(4, 2)] = (float16)(row[hook(5, r)][hook(4, 0)].s23456789, row[hook(5, r)][hook(4, 8)].s23456789);
    row[hook(5, r)][hook(4, 3)] = (float16)(row[hook(5, r)][hook(4, 0)].s3456789a, row[hook(5, r)][hook(4, 8)].s3456789a);
    row[hook(5, r)][hook(4, 4)] = (float16)(row[hook(5, r)][hook(4, 0)].s456789ab, row[hook(5, r)][hook(4, 8)].s456789ab);
    row[hook(5, r)][hook(4, 5)] = (float16)(row[hook(5, r)][hook(4, 0)].s56789abc, row[hook(5, r)][hook(4, 8)].s56789abc);
    row[hook(5, r)][hook(4, 6)] = (float16)(row[hook(5, r)][hook(4, 0)].s6789abcd, row[hook(5, r)][hook(4, 8)].s6789abcd);
    row[hook(5, r)][hook(4, 7)] = (float16)(row[hook(5, r)][hook(4, 0)].s789abcde, row[hook(5, r)][hook(4, 8)].s789abcde);
  }

  for (int r = 0; r < 9; r++) {
    for (int c = 0; c < 9; c++) {
      res += row[hook(5, r)][hook(4, c)];
    }
  }

  vstore16(res / 81, 0, pOut + offset + 4);
}