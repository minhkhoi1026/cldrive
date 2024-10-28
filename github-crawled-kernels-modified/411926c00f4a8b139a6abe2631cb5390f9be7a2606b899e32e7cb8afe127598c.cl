//{"in":0,"nk":4,"np":2,"out":1,"val":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void write_kernel(global unsigned int* in, write_only image2d_t out, unsigned int np, unsigned int val, unsigned int nk) {
  if (nk == 0)
    return;

  uint4 pval;
  unsigned int i, idx;
  int2 coord = (int2)(get_global_id(0), 0);

  pval = (uint4)(val, val, val, val);

  for (int n = 0; n < nk; n++)
    for (i = 0, idx = get_global_id(1); i < np; i++, idx += get_global_size(1)) {
      coord.y = idx;
      write_imageui(out, coord, pval);
    }
}