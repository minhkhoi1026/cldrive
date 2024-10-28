//{"in":0,"ni":2,"nk":4,"out":1,"val":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void read_kernel(volatile global uint4* in, volatile global unsigned int* out, unsigned int ni, unsigned int val, unsigned int nk) {
  if (nk == 0)
    return;

  unsigned int pcount = 0;
  local unsigned int lcount;
  unsigned int i, idx;

  if (get_local_id(0) == 0)
    lcount = 0;

  barrier(0x01);

  for (int n = 0; n < nk; n++)
    for (i = 0, idx = get_global_id(0); i < ni; i++, idx += get_global_size(0)) {
      if (in[hook(0, idx)].x == val)
        pcount++;
      if (in[hook(0, idx)].y == val)
        pcount++;
      if (in[hook(0, idx)].z == val)
        pcount++;
      if (in[hook(0, idx)].w == val)
        pcount++;
    }

  (void)atomic_add(&lcount, pcount);

  barrier(0x01);

  if (get_local_id(0) == 0)
    out[hook(1, get_group_id(0))] = lcount / nk;
}