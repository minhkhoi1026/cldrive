//{"blk":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void _idctcol(global int* blk) {
 private
  int8 x;
 private
  int8 y;
 private
  int x8;

  x.s0 = (blk[hook(0, 8 * 0)] << 8) + 8192;
  x.s1 = (blk[hook(0, 8 * 4)] << 8);
  x.s2 = blk[hook(0, 8 * 6)];
  x.s3 = blk[hook(0, 8 * 2)];
  x.s4 = blk[hook(0, 8 * 1)];
  x.s5 = blk[hook(0, 8 * 7)];
  x.s6 = blk[hook(0, 8 * 5)];
  x.s7 = blk[hook(0, 8 * 3)];

  x8 = 565 * (x.s4 + x.s5) + 4;
  x.s4 = (x8 + (2841 - 565) * x.s4);
  x.s5 = (x8 - (2841 + 565) * x.s5);
  x8 = 2408 * (x.s6 + x.s7) + 4;
  x.s6 = (x8 - (2408 - 1609) * x.s6);
  x.s7 = (x8 - (2408 + 1609) * x.s7);
  x.s4567 >>= 3;

  x8 = x.s0 + x.s1;
  x.s0 -= x.s1;
  x.s1 = 1108 * (x.s3 + x.s2) + 4;
  x.s2 = (x.s1 - (2676 + 1108) * x.s2) >> 3;
  x.s3 = (x.s1 + (2676 - 1108) * x.s3) >> 3;
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
  y >>= 14;
  y = clamp(y, -256, 256);
  blk[hook(0, 8 * 0)] = y.s0;
  blk[hook(0, 8 * 1)] = y.s1;
  blk[hook(0, 8 * 2)] = y.s2;
  blk[hook(0, 8 * 3)] = y.s3;
  blk[hook(0, 8 * 4)] = y.s4;
  blk[hook(0, 8 * 5)] = y.s5;
  blk[hook(0, 8 * 6)] = y.s6;
  blk[hook(0, 8 * 7)] = y.s7;
}