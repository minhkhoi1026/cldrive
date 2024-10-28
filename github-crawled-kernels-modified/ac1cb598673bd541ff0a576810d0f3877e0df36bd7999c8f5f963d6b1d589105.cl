//{"in":0,"nk":4,"np":2,"out":1,"val":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void read_kernel(read_only image2d_t in, global unsigned int* out, unsigned int np, unsigned int val, unsigned int nk) {
  if (nk == 0)
    return;

  sampler_t sampler = 0 | 2 | 0x10;

  unsigned int pcount = 0;
  local unsigned int lcount;
  unsigned int i, idx;
  uint4 pix;
  int2 coord = (int2)(get_global_id(0), 0);

  if (get_local_id(0) == 0 && get_local_id(1) == 0)
    lcount = 0;

  barrier(0x01);

  for (int n = 0; n < nk; n++)
    for (i = 0, idx = get_global_id(1); i < np; i++, idx += get_global_size(1)) {
      coord.y = idx;
      pix = read_imageui(in, sampler, coord);

      if (pix.x == val)
        pcount++;
      if (pix.y == val)
        pcount++;
      if (pix.z == val)
        pcount++;
      if (pix.w == val)
        pcount++;
    }

  (void)atomic_add(&lcount, pcount);

  barrier(0x01);

  unsigned int gid1D = get_group_id(1) * get_num_groups(0) + get_group_id(0);

  if (get_local_id(0) == 0 && get_local_id(1) == 0)
    out[hook(1, gid1D)] = lcount / nk;
}