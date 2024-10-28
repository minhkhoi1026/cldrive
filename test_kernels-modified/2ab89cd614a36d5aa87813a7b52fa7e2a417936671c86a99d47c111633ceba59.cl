//{"nhex":3,"v1":1,"v2":2,"vsum":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vecsum4x4(global int4* restrict vsum, global const int4* restrict v1, global const int4* restrict v2, int nhex) {
  const int i = get_global_id(0);
  const int gws = get_global_size(0);

  if (i >= nhex)
    return;

  int4 a0 = v1[hook(1, i + 0 * gws)];
  int4 a1 = v1[hook(1, i + 1 * gws)];
  int4 a2 = v1[hook(1, i + 2 * gws)];
  int4 a3 = v1[hook(1, i + 3 * gws)];

  int4 b0 = v2[hook(2, i + 0 * gws)];
  int4 b1 = v2[hook(2, i + 1 * gws)];
  int4 b2 = v2[hook(2, i + 2 * gws)];
  int4 b3 = v2[hook(2, i + 3 * gws)];

  a0 += b0;
  a1 += b1;
  a2 += b2;
  a3 += b3;

  vsum[hook(0, i + 0 * gws)] = a0;
  vsum[hook(0, i + 1 * gws)] = a1;
  vsum[hook(0, i + 2 * gws)] = a2;
  vsum[hook(0, i + 3 * gws)] = a3;
}