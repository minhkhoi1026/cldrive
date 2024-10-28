//{"in":0,"ni":2,"nk":4,"out":1,"val":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void write_kernel(volatile global unsigned int* in, volatile global uint4* out, unsigned int ni, unsigned int val, unsigned int nk) {
  if (nk == 0)
    return;

  unsigned int i, idx;
  uint4 pval = (uint4)(val, val, val, val);

  for (int n = 0; n < nk; n++)
    for (i = 0, idx = get_global_id(0); i < ni; i++, idx += get_global_size(0)) {
      out[hook(1, idx)] = pval;
    }
}