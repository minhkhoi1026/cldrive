//{"nquarts":2,"s":0,"v":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vecsmooth_v4(global int4* restrict s, global const int4* restrict v, int nquarts) {
  const int i = get_global_id(0);
  if (i >= nquarts)
    return;
  int4 v1 = (int4)(0), v2 = v[hook(1, i)], v3 = (int4)(0);
  int4 c = (int4)(2, 3, 3, 2);

  if (i > 0) {
    v1.s0 = v[hook(1, i - 1)].s3;
    c.s0++;
  }
  if (i < nquarts - 1) {
    v3.s3 = v[hook(1, i + 1)].s0;
    c.s3++;
  }
  v1.s123 = v2.s012;
  v3.s012 = v2.s123;

  s[hook(0, i)] = (v1 + v2 + v3) / c;
}