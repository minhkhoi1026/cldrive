//{"in":0,"ni":2,"nk":4,"out":1,"val":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void writeKernel(volatile global unsigned int* in, volatile global uint4* out, unsigned int ni, unsigned int val, unsigned int nk) {
  uint4 pval;
  local unsigned int lval;
  unsigned int i, idx;

  if (get_local_id(0) == 0)
    lval = in[hook(0, get_num_groups(0) + 1)];

  barrier(0x01);

  pval = (uint4)(lval, lval, lval, lval);

  for (int n = 0; n < nk; n++) {
    for (i = 0, idx = get_global_id(0); i < ni; i++, idx += get_global_size(0)) {
      out[hook(1, idx)] = pval;
    }
  }
}