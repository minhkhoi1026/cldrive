//{"in":1,"lmem":2,"nels":3,"out":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
unsigned int div_up(unsigned int a, unsigned int b) {
  return (a + b - 1) / b;
}

unsigned int round_mul_up(unsigned int a, unsigned int b) {
  return div_up(a, b) * b;
}

int scan_pass(int gi, int nels, global int* restrict out, global const int* restrict in, local int* restrict lmem, int corr) {
  const unsigned int li = get_local_id(0);
  const unsigned int lws = get_local_size(0);
  int acc = (gi < nels ? in[hook(1, gi)] : 0);

  unsigned int write_mask = 1U;
  unsigned int read_mask = ~0U;

  lmem[hook(2, li)] = acc;
  while (write_mask < lws) {
    barrier(0x01);
    if (li & write_mask) {
      acc += lmem[hook(2, (li & read_mask) - 1)];
      lmem[hook(2, li)] = acc;
    }
    write_mask <<= 1;
    read_mask <<= 1;
  }

  acc += corr;
  if (gi < nels)
    out[hook(0, gi)] = acc;

  barrier(0x01);
  corr += lmem[hook(2, lws - 1)];

  barrier(0x01);
  return corr;
}

kernel void scan1_lmem(global int* restrict out, global const int* restrict in, local int* restrict lmem, unsigned int nels) {
  const unsigned int gws = get_global_size(0);
  const unsigned int lws = get_local_size(0);
  const unsigned int li = get_local_id(0);

  const unsigned int limit = round_mul_up(nels, lws);

  unsigned int gi = get_global_id(0);
  int corr = 0;

  while (gi < limit) {
    corr = scan_pass(gi, nels, out, in, lmem, corr);
    gi += get_local_size(0);
  }
}