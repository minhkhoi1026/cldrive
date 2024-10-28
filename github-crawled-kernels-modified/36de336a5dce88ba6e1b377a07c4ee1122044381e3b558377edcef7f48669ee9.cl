//{"d":4,"data":0,"f":6,"flag":2,"len":3,"p":5,"part":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void block_scan(global unsigned int* restrict data, global unsigned int* restrict part, global unsigned int* restrict flag, unsigned int len) {
  local unsigned int d[1024];
  local unsigned int p[1024];
  local unsigned int f[1024];
  const unsigned int thread = get_local_id(0);
  const unsigned int threads_per_block = get_local_size(0);
  const unsigned int elements_per_block = 2 * threads_per_block;
  const unsigned int n = elements_per_block;
  const unsigned int e = 2 * thread;
  const unsigned int o = 2 * thread + 1;
  d[hook(4, e)] = (e < len) ? data[hook(0, e)] : 0;
  d[hook(4, o)] = (o < len) ? data[hook(0, o)] : 0;
  p[hook(5, e)] = (e < len) ? part[hook(1, e)] : 0;
  p[hook(5, o)] = (o < len) ? part[hook(1, o)] : 0;
  f[hook(6, e)] = (e < len) ? flag[hook(2, e)] : 0;
  f[hook(6, o)] = (o < len) ? flag[hook(2, o)] : 0;

  unsigned int offset = 1;
  for (unsigned int i = n >> 1; i > 0; i >>= 1) {
    barrier(0x01);
    if (thread < i) {
      const int ai = offset * (e + 1) - 1;
      const int bi = offset * (o + 1) - 1;
      d[hook(4, bi)] += (p[hook(5, bi)] == 0) ? d[hook(4, ai)] : 0;
      p[hook(5, bi)] |= p[hook(5, ai)];
    }
    offset <<= 1;
  }
  if (thread == 0)
    d[hook(4, n - 1)] = 0;

  for (unsigned int i = 1; i < n; i <<= 1) {
    offset >>= 1;
    barrier(0x01);
    if (thread < i) {
      const unsigned int ai = offset * (e + 1) - 1;
      const unsigned int bi = offset * (o + 1) - 1;
      const unsigned int tmp = d[hook(4, ai)];
      d[hook(4, ai)] = d[hook(4, bi)];
      if (f[hook(6, ai + 1)] == 1)
        d[hook(4, bi)] = 0;
      else if (p[hook(5, ai)] == 1)
        d[hook(4, bi)] = tmp;
      else
        d[hook(4, bi)] += tmp;
      p[hook(5, ai)] = 0;
    }
  }
  barrier(0x01);
  if (e < len) {
    data[hook(0, e)] = d[hook(4, e)];
    part[hook(1, e)] = p[hook(5, e)];
  }
  if (o < len) {
    data[hook(0, o)] = d[hook(4, o)];
    part[hook(1, o)] = p[hook(5, o)];
  }
}