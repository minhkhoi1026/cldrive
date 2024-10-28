//{"data":2,"in":0,"n":3,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void reduce_min_f(global float4* in, global float* out, local float* data, unsigned int n) {
  unsigned int lXdim = get_local_size(0);
  unsigned int wgXdim = get_num_groups(0);

  unsigned int gX = get_global_id(0);
  unsigned int gY = get_global_id(1);
  unsigned int lX = get_local_id(0);
  unsigned int wgX = get_group_id(0);

  unsigned int idx = gX << 1;
  int4 flag = (uint4)(idx) < (uint4)(n);
  float4 a = select((float4)((__builtin_inff())), in[hook(0, gY * n + idx)], flag);
  flag = (uint4)(idx + 1) < (uint4)(n);
  float4 b = select((float4)((__builtin_inff())), in[hook(0, gY * n + idx + 1)], flag);

  float2 ta = fmin(a.lo, a.hi);
  float2 tb = fmin(b.lo, b.hi);

  data[hook(2, (lX << 1))] = fmin(ta.x, ta.y);
  data[hook(2, (lX << 1) + 1)] = fmin(tb.x, tb.y);

  for (unsigned int d = lXdim; d > 0; d >>= 1) {
    barrier(0x01);
    if (lX < d)
      data[hook(2, lX)] = fmin(data[hook(2, lX)], data[hook(2, lX + d)]);
  }

  if (lX == 0)
    out[hook(1, gY * wgXdim + wgX)] = data[hook(2, 0)];
}