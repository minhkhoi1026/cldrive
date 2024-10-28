//{"in":1,"lmem":2,"nels":3,"out":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void scan1(global int* restrict out, global const int* restrict in, local int* restrict lmem, unsigned int nels) {
  const unsigned int gws = get_global_size(0);
  const unsigned int lws = get_local_size(0);
  const unsigned int li = get_local_id(0);
  unsigned int gi = get_global_id(0);
  int corr = 0;

  unsigned int limit = ((nels + lws - 1) / lws) * lws;

  while (gi < limit) {
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
    gi += get_local_size(0);

    barrier(0x01);
  }
}