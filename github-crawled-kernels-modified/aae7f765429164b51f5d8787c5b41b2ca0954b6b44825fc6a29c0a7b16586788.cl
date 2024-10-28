//{"blk":0,"offset":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void _idctrow(global int* blk, const int offset) {
 private
  int8 x;
 private
  int8 y;
 private
  int x8;

  x.s01234567 = vload8(offset, blk).s04621753;
  x.s01 <<= 11;
  x.s0 += 128;

  x8 = 565 * (x.s4 + x.s5);
  x.s4 = x8 + (2841 - 565) * x.s4;
  x.s5 = x8 - (2841 + 565) * x.s5;
  x8 = 2408 * (x.s6 + x.s7);
  x.s6 = x8 - (2408 - 1609) * x.s6;
  x.s7 = x8 - (2408 + 1609) * x.s7;

  x8 = x.s0 + x.s1;
  x.s0 -= x.s1;
  x.s1 = 1108 * (x.s3 + x.s2);
  x.s2 = x.s1 - (2676 + 1108) * x.s2;
  x.s3 = x.s1 + (2676 - 1108) * x.s3;
  x.s1 = x.s4 + x.s6;
  x.s4 -= x.s6;
  x.s6 = x.s5 + x.s7;
  x.s5 -= x.s7;

  x.s7 = x8 + x.s3;
  x8 -= x.s3;
  x.s3 = x.s0 + x.s2;
  x.s0 -= x.s2;
  x.s2 = (181 * (x.s4 + x.s5) + 128) >> 8;
  x.s4 = (181 * (x.s4 - x.s5) + 128) >> 8;

  y.s0 = (x.s7 + x.s1);
  y.s1 = (x.s3 + x.s2);
  y.s2 = (x.s0 + x.s4);
  y.s3 = (x8 + x.s6);
  y.s4 = (x8 - x.s6);
  y.s5 = (x.s0 - x.s4);
  y.s6 = (x.s3 - x.s2);
  y.s7 = (x.s7 - x.s1);
  y.s01234567 >>= 8;

  vstore8(y, offset, blk);
}