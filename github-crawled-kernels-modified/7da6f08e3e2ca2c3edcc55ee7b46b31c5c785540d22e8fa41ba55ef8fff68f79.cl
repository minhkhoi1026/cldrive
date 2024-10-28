//{"data":2,"in":0,"n":4,"out":1,"scaling":5,"sums":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void inclusiveScan_f(global float4* in, global float4* out, local float* data, global float* sums, unsigned int n, float scaling) {
  unsigned int lXdim = get_local_size(0);
  unsigned int wgXdim = get_num_groups(0);

  unsigned int gX = get_global_id(0);
  unsigned int gY = get_global_id(1);
  unsigned int lX = get_local_id(0);
  unsigned int wgX = get_group_id(0);

  unsigned int offset = 1;

  int4 flag = (int4)(2 * gX) < (int4)(n);
  float4 a = select((float4)(0.f), in[hook(0, gY * n + 2 * gX)] * scaling, flag);
  flag = (int4)(2 * gX + 1) < (int4)(n);
  float4 b = select((float4)(0.f), in[hook(0, gY * n + 2 * gX + 1)] * scaling, flag);

  a.y += a.x;
  a.z += a.y;
  a.w += a.z;
  b.y += b.x;
  b.z += b.y;
  b.w += b.z;

  data[hook(2, 2 * lX)] = a.w;
  data[hook(2, 2 * lX + 1)] = b.w;

  for (unsigned int d = lXdim; d > 0; d >>= 1) {
    barrier(0x01);
    if (lX < d) {
      unsigned int ai = offset * (2 * lX + 1) - 1;
      unsigned int bi = offset * (2 * lX + 2) - 1;
      data[hook(2, bi)] += data[hook(2, ai)];
    }
    offset <<= 1;
  }

  if ((wgXdim != 1) && (lX == lXdim - 1))
    sums[hook(3, gY * wgXdim + wgX)] = data[hook(2, 2 * lX + 1)];

  if (lX == (lXdim - 1))
    data[hook(2, 2 * lX + 1)] = 0.f;

  for (unsigned int d = 1; d < (2 * lXdim); d <<= 1) {
    offset >>= 1;
    barrier(0x01);
    if (lX < d) {
      unsigned int ai = offset * (2 * lX + 1) - 1;
      unsigned int bi = offset * (2 * lX + 2) - 1;
      float tmp = data[hook(2, ai)];
      data[hook(2, ai)] = data[hook(2, bi)];
      data[hook(2, bi)] += tmp;
    }
  }
  barrier(0x01);

  if ((2 * gX) < n) {
    a += data[hook(2, 2 * lX)];
    out[hook(1, gY * n + 2 * gX)] = a;
  }

  if ((2 * gX + 1) < n) {
    b += data[hook(2, 2 * lX + 1)];
    out[hook(1, gY * n + 2 * gX + 1)] = b;
  }
}