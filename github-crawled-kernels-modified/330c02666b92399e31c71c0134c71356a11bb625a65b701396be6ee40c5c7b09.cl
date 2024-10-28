//{"d":6,"data":0,"flag":2,"last_data":3,"last_flag":5,"last_part":4,"len":8,"p":7,"part":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void upsweep(global unsigned int* restrict data, global unsigned int* restrict part, global unsigned int* restrict flag, global unsigned int* restrict last_data, global unsigned int* restrict last_part, global unsigned int* restrict last_flag, local unsigned int* d, local unsigned int* p, unsigned int len) {
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
  p[hook(7, e)] = (ge < len) ? part[hook(1, ge)] : 0;
  p[hook(7, o)] = (go < len) ? part[hook(1, go)] : 0;
  unsigned int offset = 1;
  for (unsigned int i = n >> 1; i > 0; i >>= 1) {
    barrier(0x01);
    if (thread < i) {
      const unsigned int ai = offset * (e + 1) - 1;
      const unsigned int bi = offset * (o + 1) - 1;
      d[hook(6, bi)] += (p[hook(7, bi)] == 0) ? d[hook(6, ai)] : 0;
      p[hook(7, bi)] |= p[hook(7, ai)];
    }
    offset <<= 1;
  }
  barrier(0x01);
  if (thread == 0)
    last_flag[hook(5, block)] = flag[hook(2, ge)];

  if (thread == threads_per_block - 1) {
    last_data[hook(3, block)] = d[hook(6, n - 1)];
    last_part[hook(4, block)] = p[hook(7, n - 1)];
  }
  if (ge < len) {
    data[hook(0, ge)] = d[hook(6, e)];
    part[hook(1, ge)] = p[hook(7, e)];
  }
  if (go < len) {
    data[hook(0, go)] = d[hook(6, o)];
    part[hook(1, go)] = p[hook(7, o)];
  }
}