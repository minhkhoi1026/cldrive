//{"in":0,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_shuffle(const global char16* in, global char16* out) {
  char16 tmp = in[hook(0, 0)];
  char16 tmp1 = in[hook(0, 1)];

  out[hook(1, 0)] = shuffle(tmp, (uchar16)(7, 6, 4, 8, 1, 12, 13, 1, 0, 9, 14, 15, 4, 3, 8, 6));

  out[hook(1, 1)] = shuffle2(tmp, tmp1, (uchar16)(1, 7, 11, 18, 21, 15, 8, 9, 0, 19, 2, 1, 17, 13, 7, 8));

  char16 tmp2 = in[hook(0, 0)];

  tmp2.s5170abc3 = tmp1.s9b7ac3a0;
  out[hook(1, 2)] = tmp2;

  char4 tmp3 = in[hook(0, 0)].xyzw;

  tmp3.wx = tmp1.xy;

  out[hook(1, 3)] = (char16)(tmp3, tmp3, tmp3, tmp3);

  char16 tmp4 = 0;

  tmp4.s43b79acd = (char8)(tmp3, tmp3);
  out[hook(1, 4)] = tmp4;

  out[hook(1, 5)] = shuffle(tmp, (uchar16)(0, 0, 0, 0, 4, 4, 4, 4, 8, 8, 8, 8, 12, 12, 12, 12));

  out[hook(1, 6)] = shuffle2(tmp, tmp1, (uchar16)(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0));

  out[hook(1, 7)] = shuffle(tmp, convert_uchar16(tmp));

  out[hook(1, 8)] = shuffle(tmp, (uchar16)(10, 11, 12, 13, 14, 15, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9));

  out[hook(1, 9)] = shuffle(tmp, (uchar16)(15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0));
}