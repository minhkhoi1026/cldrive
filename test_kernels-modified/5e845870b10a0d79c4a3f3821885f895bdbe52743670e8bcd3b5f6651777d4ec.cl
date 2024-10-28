//{"data":0,"increments":1,"len":3,"tmp":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void es_phase_1(global unsigned int* restrict data, global unsigned int* restrict increments, local unsigned int* tmp, unsigned int len) {
  const unsigned int thread = get_local_id(0);
  const unsigned int block = get_group_id(0);
  const unsigned int threads_per_block = get_local_size(0);
  const unsigned int elements_per_block = threads_per_block * 2;
  const unsigned int global_offset = block * elements_per_block;
  const unsigned int n = elements_per_block;

  unsigned int offset = 1;

  tmp[hook(2, 2 * thread)] = (global_offset + (2 * thread) < len) ? data[hook(0, global_offset + (2 * thread))] : 0;
  tmp[hook(2, 2 * thread + 1)] = (global_offset + (2 * thread + 1) < len) ? data[hook(0, global_offset + (2 * thread + 1))] : 0;

  for (unsigned int d = n >> 1; d > 0; d >>= 1) {
    barrier(0x01);
    if (thread < d) {
      int ai = offset * (2 * thread + 1) - 1;
      int bi = offset * (2 * thread + 2) - 1;
      tmp[hook(2, bi)] += tmp[hook(2, ai)];
    }
    offset *= 2;
  }

  if (thread == 0) {
    increments[hook(1, block)] = tmp[hook(2, n - 1)];
    tmp[hook(2, n - 1)] = 0;
  }

  for (unsigned int d = 1; d < n; d *= 2) {
    offset >>= 1;
    barrier(0x01);
    if (thread < d) {
      int ai = offset * (2 * thread + 1) - 1;
      int bi = offset * (2 * thread + 2) - 1;
      unsigned int t = tmp[hook(2, ai)];
      tmp[hook(2, ai)] = tmp[hook(2, bi)];
      tmp[hook(2, bi)] += t;
    }
  }
  barrier(0x01);

  if (global_offset + (2 * thread) < len)
    data[hook(0, global_offset + (2 * thread))] = tmp[hook(2, 2 * thread)];
  if (global_offset + (2 * thread + 1) < len)
    data[hook(0, global_offset + (2 * thread + 1))] = tmp[hook(2, 2 * thread + 1)];
}