//{"noct":3,"v1":1,"v2":2,"vsum":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vecsum4x2(global int4* restrict vsum, global const int4* restrict v1, global const int4* restrict v2, int noct) {
  const int i = get_global_id(0);
  const int gws = get_global_size(0);

  if (i >= noct)
    return;

  int4 a0 = v1[hook(1, i + 0 * gws)];
  int4 a1 = v1[hook(1, i + 1 * gws)];

  int4 b0 = v2[hook(2, i + 0 * gws)];
  int4 b1 = v2[hook(2, i + 1 * gws)];

  a0 += b0;
  a1 += b1;

  vsum[hook(0, i + 0 * gws)] = a0;
  vsum[hook(0, i + 1 * gws)] = a1;
}