//{"isums":0,"lmem":2,"n":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline unsigned int scanLocalMem(unsigned int val, local unsigned int* lmem, int exclusive) {
  int idx = get_local_id(0);
  lmem[hook(2, idx)] = 0;

  idx += get_local_size(0);
  lmem[hook(2, idx)] = val;
  barrier(0x01);

  unsigned int t;
  for (int i = 1; i < get_local_size(0); i *= 2) {
    t = lmem[hook(2, idx - i)];
    barrier(0x01);
    lmem[hook(2, idx)] += t;
    barrier(0x01);
  }
  return lmem[hook(2, idx - exclusive)];
}

kernel void top_scan(global unsigned int* isums, const int n, local unsigned int* lmem) {
  local int s_seed;
  s_seed = 0;
  barrier(0x01);

  int last_thread = (get_local_id(0) < n && (get_local_id(0) + 1) == n) ? 1 : 0;

  for (int d = 0; d < 16; d++) {
    unsigned int val = 0;

    if (get_local_id(0) < n) {
      val = isums[hook(0, (n * d) + get_local_id(0))];
    }

    unsigned int res = scanLocalMem(val, lmem, 1);

    if (get_local_id(0) < n) {
      isums[hook(0, (n * d) + get_local_id(0))] = res + s_seed;
    }
    barrier(0x01);

    if (last_thread) {
      s_seed += res + val;
    }
    barrier(0x01);
  }
}