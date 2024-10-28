//{"ctrl":3,"rounds":2,"state_g":0,"states":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline ulong shiftLFSRs(ulong reg) {
  ulong reg_new = reg << 1;

  unsigned int fbA = (popcount(reg & 0xE001000000000000) & 1);
  unsigned int fbB = (popcount(reg & 0x0000018000000000) & 1);
  unsigned int fbC = (popcount(reg & 0x0000000000070080) & 1);

  reg_new = fbA ? reg_new | 0x0000020000000000 : reg_new & ~0x0000020000000000;
  reg_new = fbB ? reg_new | 0x0000000000010000 : reg_new & ~0x0000000000010000;
  reg_new = fbC ? reg_new | 0x0000000000000001 : reg_new & ~0x0000000000000001;

  unsigned int clkAB = (popcount(reg & 0x0008000020000000) & 1);
  unsigned int clkBC = (popcount(reg & 0x0000000020000400) & 1);
  unsigned int clkAC = (popcount(reg & 0x0008000000000400) & 1);

  unsigned int clockA = ~(clkAB & clkAC);
  unsigned int clockB = ~(clkAB & clkBC);
  unsigned int clockC = ~(clkBC & clkAC);

  ulong mask = (clockA ? 0xFFFFFE0000000000 : 0) | (clockB ? 0x000001FFFFF10000 : 0) | (clockC ? 0x000000000007FFFF : 0);
  return (reg_new & mask) | (reg & ~mask);
}

kernel void krak(global ulong* state_g, unsigned int states, unsigned int rounds, unsigned int ctrl) {
 private
  size_t my = (get_global_id(0) + get_global_size(0) * (get_global_id(1) + get_global_size(1) * get_global_id(2))) * 2;

 private
  ulong state, state_out, reg;

  if (my + 1 < states) {
    state = state_g[hook(0, my + 1)];
    state_out = state_g[hook(0, my)];
  }

  for (unsigned int i = 0; i < rounds; i++) {
    reg = state ^ state_out;

    unsigned int inactive = (!(reg & 0xFFF0000000000000));

    for (unsigned int j = 0; j < 99; j++) {
      reg = shiftLFSRs(reg);
    }

    for (ulong j = 0x8000000000000000; j > 0; j >>= 1) {
      reg = shiftLFSRs(reg);

      unsigned int result = (popcount(reg & 0x8000010000040000) & 1);

      state_out = inactive ? state_out : (state_out & ~j);
    }
  }

  if (my + 1 < states) {
    state_g[hook(0, my)] = state_out;
    state_g[hook(0, my + 1)] = my;
  }
}