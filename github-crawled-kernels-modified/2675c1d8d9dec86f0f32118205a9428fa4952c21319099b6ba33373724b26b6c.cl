//{"d":6,"data":0,"f":8,"flag":2,"last_data":3,"last_part":4,"len":9,"original":5,"p":7,"part":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void downsweep_inc(global unsigned int* restrict data, global unsigned int* restrict part, global unsigned int* restrict flag, global unsigned int* restrict last_data, global unsigned int* restrict last_part, global unsigned int* restrict original, local unsigned int* d, local unsigned int* p, local unsigned int* f, unsigned int len) {
  const unsigned int x = get_global_id(0);
  const unsigned int thread = get_local_id(0);
  const unsigned int block = get_group_id(0);
  const unsigned int threads_per_block = get_local_size(0);
  const unsigned int elements_per_block = threads_per_block * 2;
  const unsigned int n = elements_per_block;
  const unsigned int e = 2 * thread;
  const unsigned int o = 2 * thread + 1;
  const unsigned int ge = 2 * x;
  const unsigned int go = 2 * x + 1;

  d[hook(6, e)] = (ge < len) ? data[hook(0, ge)] : 0;
  d[hook(6, o)] = (go < len) ? data[hook(0, go)] : 0;
  p[hook(7, e)] = (ge < len) ? part[hook(1, ge)] : 1;
  p[hook(7, o)] = (go < len) ? part[hook(1, go)] : 1;
  f[hook(8, e)] = (ge < len) ? flag[hook(2, ge)] : 0;
  f[hook(8, o)] = (go < len) ? flag[hook(2, go)] : 0;

  if (thread == threads_per_block - 1) {
    d[hook(6, n - 1)] = last_data[hook(3, block)];
    p[hook(7, n - 1)] = last_part[hook(4, block)];
  }

  unsigned int offset = 1;
  for (unsigned int i = n >> 1; i > 0; i >>= 1)
    offset <<= 1;
  for (unsigned int i = 1; i < n; i *= 2) {
    offset >>= 1;
    barrier(0x01);
    if (thread < i) {
      const int ai = offset * (e + 1) - 1;
      const int bi = offset * (o + 1) - 1;
      const unsigned int tmp = d[hook(6, ai)];
      d[hook(6, ai)] = d[hook(6, bi)];
      if (f[hook(8, ai + 1)] == 1)
        d[hook(6, bi)] = 0;
      else if (p[hook(7, ai)] == 1)
        d[hook(6, bi)] = tmp;
      else
        d[hook(6, bi)] += tmp;
      p[hook(7, ai)] = 0;
    }
  }
  barrier(0x01);

  if (ge < len)
    data[hook(0, ge)] = d[hook(6, e)] + original[hook(5, ge)];
  if (go < len)
    data[hook(0, go)] = d[hook(6, o)] + original[hook(5, go)];
}