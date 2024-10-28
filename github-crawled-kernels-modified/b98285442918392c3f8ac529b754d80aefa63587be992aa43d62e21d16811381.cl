//{"inout1":0,"inout2":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_vpm_read(global int4* inout1, global int4* inout2) {
  int4 a, b, c, d, e, f, g, h, i, j;

  int easyStride = 3;
  a = inout2[hook(1, 0 * easyStride)];
  b = inout2[hook(1, 1 * easyStride)];
  c = inout2[hook(1, 2 * easyStride)];
  d = inout2[hook(1, 3 * easyStride)];
  e = inout2[hook(1, 4 * easyStride)];
  f = inout2[hook(1, 5 * easyStride)];
  g = inout2[hook(1, 6 * easyStride)];
  h = inout2[hook(1, 7 * easyStride)];
  i = inout2[hook(1, 8 * easyStride)];
  j = inout2[hook(1, 9 * easyStride)];

  inout1[hook(0, 0)] = (a);
  inout1[hook(0, 1)] = (b);
  inout1[hook(0, 2)] = (c);
  inout1[hook(0, 3)] = (d);
  inout1[hook(0, 4)] = (e);
  inout1[hook(0, 5)] = (f);
  inout1[hook(0, 6)] = (g);
  inout1[hook(0, 7)] = (h);
  inout1[hook(0, 8)] = (i);
  inout1[hook(0, 9)] = (j);

  a = (inout1[hook(0, 0)]);
  b = (inout1[hook(0, 1)]);
  c = (inout1[hook(0, 2)]);
  d = (inout1[hook(0, 3)]);
  e = (inout1[hook(0, 4)]);
  f = (inout1[hook(0, 5)]);
  g = (inout1[hook(0, 6)]);
  h = (inout1[hook(0, 7)]);
  i = (inout1[hook(0, 8)]);
  j = (inout1[hook(0, 9)]);

  inout2[hook(1, 0)] = a;
  inout2[hook(1, 1)] = b;
  inout2[hook(1, 2)] = c;
  inout2[hook(1, 3)] = d;
  inout2[hook(1, 4)] = e;
  inout2[hook(1, 5)] = f;
  inout2[hook(1, 6)] = g;
  inout2[hook(1, 7)] = h;
  inout2[hook(1, 8)] = i;
  inout2[hook(1, 9)] = j;
}