//{"lstate":4,"ltbl":3,"seed":2,"state":0,"tbl":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mersenneInitState(global unsigned int* state, global unsigned int* tbl, ulong seed) {
  int tid = get_local_id(0);
  int nthreads = get_local_size(0);
  int gid = get_group_id(0);
  local unsigned int lstate[351];
  const global unsigned int* ltbl = tbl + (16 * gid);
  unsigned int hidden_seed = ltbl[hook(3, 4)] ^ (ltbl[hook(3, 8)] << 16);
  unsigned int tmp = hidden_seed;
  tmp += tmp >> 16;
  tmp += tmp >> 8;
  tmp &= 0xff;
  tmp |= tmp << 8;
  tmp |= tmp << 16;

  for (int id = tid; id < 351; id += nthreads) {
    lstate[hook(4, id)] = tmp;
  }
  barrier(0x01);

  if (tid == 0) {
    lstate[hook(4, 0)] = seed;
    lstate[hook(4, 1)] = hidden_seed;
    for (int i = 1; i < 351; ++i) {
      lstate[hook(4, i)] ^= (unsigned int)(1812433253) * (lstate[hook(4, i - 1)] ^ (lstate[hook(4, i - 1)] >> 30)) + i;
    }
  }
  barrier(0x01);

  for (int id = tid; id < 351; id += nthreads) {
    state[hook(0, 351 * gid + id)] = lstate[hook(4, id)];
  }
}