//{"global_nels":2,"in":3,"lmem":4,"out":0,"tails":1}
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
  int acc = (gi < nels ? in[hook(3, gi)] : 0);

  unsigned int write_mask = 1U;
  unsigned int read_mask = ~0U;

  lmem[hook(4, li)] = acc;
  while (write_mask < lws) {
    barrier(0x01);
    if (li & write_mask) {
      acc += lmem[hook(4, (li & read_mask) - 1)];
      lmem[hook(4, li)] = acc;
    }
    write_mask <<= 1;
    read_mask <<= 1;
  }

  acc += corr;
  if (gi < nels)
    out[hook(0, gi)] = acc;

  barrier(0x01);
  corr += lmem[hook(4, lws - 1)];

  barrier(0x01);
  return corr;
}

kernel void scanN_fixup(global int* restrict out, global const int* restrict tails, unsigned int global_nels) {
  if (get_group_id(0) == 0)
    return;

  const unsigned int lws = get_local_size(0);

  unsigned int local_nels = div_up(global_nels, get_num_groups(0));

  local_nels = round_mul_up(local_nels, lws);

  const unsigned int begin = get_group_id(0) * local_nels;
  const unsigned int end = min(begin + local_nels, global_nels);
  const int corr = tails[hook(1, get_group_id(0) - 1)];

  unsigned int gi = begin + get_local_id(0);
  while (gi < end) {
    out[hook(0, gi)] += corr;
    gi += lws;
  }
}