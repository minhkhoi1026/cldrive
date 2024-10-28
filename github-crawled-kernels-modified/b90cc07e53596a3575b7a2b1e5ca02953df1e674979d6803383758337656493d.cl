//{"data":0,"increments":1,"len":2,"tmp":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void es_phase_2(global unsigned int* restrict data, global unsigned int* restrict increments, unsigned int len) {
  local unsigned int tmp[2048];
  unsigned int thread = get_local_id(0);
  unsigned int offset = 1;
  const unsigned int n = 2048;

  tmp[hook(3, 2 * thread)] = (2 * thread < len) ? increments[hook(1, 2 * thread)] : 0;
  tmp[hook(3, 2 * thread + 1)] = (2 * thread + 1 < len) ? increments[hook(1, 2 * thread + 1)] : 0;

  for (unsigned int d = n >> 1; d > 0; d >>= 1) {
    barrier(0x01);
    if (thread < d) {
      int ai = offset * (2 * thread + 1) - 1;
      int bi = offset * (2 * thread + 2) - 1;
      tmp[hook(3, bi)] += tmp[hook(3, ai)];
    }
    offset *= 2;
  }

  if (thread == 0)
    tmp[hook(3, n - 1)] = 0;

  for (unsigned int d = 1; d < n; d *= 2) {
    offset >>= 1;
    barrier(0x01);
    if (thread < d) {
      int ai = offset * (2 * thread + 1) - 1;
      int bi = offset * (2 * thread + 2) - 1;
      unsigned int t = tmp[hook(3, ai)];
      tmp[hook(3, ai)] = tmp[hook(3, bi)];
      tmp[hook(3, bi)] += t;
    }
  }
  barrier(0x01);

  if (2 * thread < len)
    increments[hook(1, 2 * thread)] = tmp[hook(3, 2 * thread)];
  if (2 * thread + 1 < len)
    increments[hook(1, 2 * thread + 1)] = tmp[hook(3, 2 * thread + 1)];
}