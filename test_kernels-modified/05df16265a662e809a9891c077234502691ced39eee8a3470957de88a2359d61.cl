//{"((__global ulong *)registers)":8,"((__local ulong *)R)":7,"((__local unsigned int *)(R + 16))":9,"((__local unsigned int *)(R + 17))":10,"((__local unsigned int *)(R + 19))":11,"E":15,"F":14,"R":12,"batch_size":5,"dataset":0,"fe":13,"programs":4,"registers":2,"rounding_modes":3,"rx_parameters":6,"scratchpad":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
double load_F_E_groups(int value, ulong andMask, ulong orMask) {
  ulong x = __builtin_astype((convert_double_rte(value)), ulong);
  x &= andMask;
  x |= orMask;
  return __builtin_astype((x), double);
}

__attribute__((reqd_work_group_size(32, 1, 1))) kernel void randomx_run(global const uchar* dataset, global uchar* scratchpad, global ulong* registers, global unsigned int* rounding_modes, global unsigned int* programs, unsigned int batch_size, unsigned int rx_parameters) {
  local ulong2 R_buf[(256 / 8) / 2];

  const unsigned int idx = get_group_id(0);
  const unsigned int sub = get_local_id(0);

  const unsigned int program_iterations = 1U << (rx_parameters >> 15);
  const unsigned int ScratchpadL3Size = 1U << ((rx_parameters >> 10) & 31);
  const unsigned int ScratchpadL3Mask64 = ScratchpadL3Size - 64;

  local ulong* R = (local ulong*)(R_buf);

  local double* F = (local double*)(R + 8);
  local double* E = (local double*)(R + 16);

  registers += idx * (256 / 8);
  scratchpad += idx * (ulong)(ScratchpadL3Size + 64);
  rounding_modes += idx;
  programs += get_group_id(0) * (10048 / sizeof(unsigned int));

  ((local ulong*)R)[hook(7, sub)] = ((global ulong*)registers)[hook(8, sub)];
  barrier(0x01);

  if (sub >= 8)
    return;

  unsigned int mx = ((local unsigned int*)(R + 16))[hook(9, 1)];
  unsigned int ma = ((local unsigned int*)(R + 16))[hook(9, 0)];

  const unsigned int readReg0 = ((local unsigned int*)(R + 17))[hook(10, 0)];
  const unsigned int readReg1 = ((local unsigned int*)(R + 17))[hook(10, 1)];
  const unsigned int readReg2 = ((local unsigned int*)(R + 17))[hook(10, 2)];
  const unsigned int readReg3 = ((local unsigned int*)(R + 17))[hook(10, 3)];

  const unsigned int datasetOffset = ((local unsigned int*)(R + 19))[hook(11, 0)];
  dataset += datasetOffset;

  unsigned int spAddr0 = mx;
  unsigned int spAddr1 = ma;

  const bool f_group = (sub < 4);
  local double* fe = f_group ? (F + sub * 2) : (E + (sub - 4) * 2);

  const ulong andMask = f_group ? (ulong)(-1) : ((1UL << (52 + 4)) - 1);
  const ulong orMask1 = f_group ? 0 : R[hook(12, 20)];
  const ulong orMask2 = f_group ? 0 : R[hook(12, 21)];

  for (unsigned int ic = 0; ic < program_iterations; ++ic) {
    const uint2 spMix = __builtin_astype((R[hook(12, readReg0)] ^ R[hook(12, readReg1)]), uint2);
    spAddr0 ^= spMix.x;
    spAddr0 &= ScratchpadL3Mask64;
    spAddr1 ^= spMix.y;
    spAddr1 &= ScratchpadL3Mask64;

    global ulong* p0 = (global ulong*)(scratchpad + (spAddr0 + sub * 8));
    global ulong* p1 = (global ulong*)(scratchpad + (spAddr1 + sub * 8));

    R[hook(12, sub)] ^= *p0;

    const int2 q = __builtin_astype((*p1), int2);
    fe[hook(13, 0)] = load_F_E_groups(q.x, andMask, orMask1);
    fe[hook(13, 1)] = load_F_E_groups(q.y, andMask, orMask2);

    barrier(0x01);
    atomic_inc(programs);

    mx ^= R[hook(12, readReg2)] ^ R[hook(12, readReg3)];
    mx &= ((1U << 31) - 1) & ~(64U - 1);

    const ulong data = *(global const ulong*)(dataset + ma + sub * 8);

    const ulong next_r = R[hook(12, sub)] ^ data;
    R[hook(12, sub)] = next_r;

    *p1 = next_r;
    *p0 = __builtin_astype((F[hook(14, sub)]), ulong) ^ __builtin_astype((E[hook(15, sub)]), ulong);

    unsigned int tmp = ma;
    ma = mx;
    mx = tmp;

    spAddr0 = 0;
    spAddr1 = 0;
  }

  registers[hook(2, sub)] = R[hook(12, sub)];
  registers[hook(2, sub + 8)] = __builtin_astype((F[hook(14, sub)]), ulong) ^ __builtin_astype((E[hook(15, sub)]), ulong);
  registers[hook(2, sub + 16)] = __builtin_astype((E[hook(15, sub)]), ulong);
}