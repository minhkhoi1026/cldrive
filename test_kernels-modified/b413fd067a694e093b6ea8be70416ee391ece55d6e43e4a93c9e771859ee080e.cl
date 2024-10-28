//{"in":1,"lmem":2,"nquarts":3,"out":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void reduce_lmem(global int* restrict out, global const int4* restrict in, local int* restrict lmem, int nquarts) {
  const int gws = get_global_size(0);
  int i = get_global_id(0);
  int acc = 0;
  while (i < nquarts) {
    int4 v0 = in[hook(1, i + 0 * gws)];
    int4 v1 = i < nquarts - 1 * gws ? in[hook(1, i + 1 * gws)] : (int4)(0);
    int4 v2 = i < nquarts - 2 * gws ? in[hook(1, i + 2 * gws)] : (int4)(0);
    int4 v3 = i < nquarts - 3 * gws ? in[hook(1, i + 3 * gws)] : (int4)(0);

    acc += (v0.x + v0.y) + (v0.z + v0.w);
    acc += (v1.x + v1.y) + (v1.z + v1.w);
    acc += (v2.x + v2.y) + (v2.z + v2.w);
    acc += (v3.x + v3.y) + (v3.z + v3.w);
    i += 4 * gws;
  }
  i = get_local_id(0);
  lmem[hook(2, i)] = acc;
  int working = get_local_size(0) >> 1;
  while (working > 0) {
    barrier(0x01);
    if (i < working) {
      acc += lmem[hook(2, i + working)];
      lmem[hook(2, i)] = acc;
    }
    working >>= 1;
  }
  if (i == 0)
    out[hook(0, get_group_id(0))] = acc;
}