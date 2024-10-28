//{"rft":2,"state_g":0,"states":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
ulong a51(ulong start, int steps, char retstream) {
  unsigned int lfsr1 = start & 0x7ffff;
  unsigned int lfsr2 = (start >> 19) & 0x3fffff;
  unsigned int lfsr3 = (start >> 41) & 0x7fffff;

  ulong stream = 0;

  for (int i = 0; i < steps; i++) {
    int count = ((lfsr1 >> 8) & 0x01);
    count += ((lfsr2 >> 10) & 0x01);
    count += ((lfsr3 >> 10) & 0x01);
    count = count >> 1;

    unsigned int bit = ((lfsr1 >> 18) ^ (lfsr2 >> 21) ^ (lfsr3 >> 22)) & 0x01;
    stream = (stream << 1) | bit;

    if (((lfsr1 >> 8) & 0x01) == count) {
      unsigned int val = (lfsr1 & 0x52000) * 0x4a000;
      val ^= lfsr1 << (31 - 17);
      lfsr1 = 2 * lfsr1 | (val >> 31);
    }
    if (((lfsr2 >> 10) & 0x01) == count) {
      unsigned int val = (lfsr2 & 0x300000) * 0xc00;
      lfsr2 = 2 * lfsr2 | (val >> 31);
    }
    if (((lfsr3 >> 10) & 0x01) == count) {
      unsigned int val = (lfsr3 & 0x500080) * 0x1000a00;
      val ^= lfsr3 << (31 - 21);
      lfsr3 = 2 * lfsr3 | (val >> 31);
    }
  }

  if (retstream) {
    return stream;
  } else {
    lfsr1 = lfsr1 & 0x7ffff;
    lfsr2 = lfsr2 & 0x3fffff;
    lfsr3 = lfsr3 & 0x7fffff;

    ulong res = (ulong)lfsr1 | ((ulong)lfsr2 << 19) | ((ulong)lfsr3 << 41);

    return res;
  }
}

ulong rev(ulong r) {
  ulong r1 = r;
  ulong r2 = 0;
  for (int j = 0; j < 64; j++) {
    r2 = (r2 << 1) | (r1 & 0x01);
    r1 = r1 >> 1;
  }
  return r2;
}
kernel void krak(global ulong* state_g, unsigned int states) {
 private
  size_t my = get_global_id(0);

 private
  size_t myptr = my * 12;

 private
  ulong state, reg;

 private
  ulong rft[8];

 private
  ulong c_color, s_color, challenge;

 private
  ulong prevlink;

 private
  unsigned int gotit = 0;

 private
  unsigned int i;

  if (myptr < states) {
    state = state_g[hook(0, myptr)];
    for (i = 0; i < 8; i++) {
      rft[hook(2, i)] = state_g[hook(0, myptr + i + 1)];
    }
    c_color = state_g[hook(0, myptr + 9)] & 0x0f;
    s_color = state_g[hook(0, myptr + 10)] & 0x0f;
    challenge = state_g[hook(0, myptr + 11)];

    reg = state;
    for (i = 0; i < 40000; i++) {
      reg = rft[hook(2, c_color)] ^ reg;

      if (reg >> 52 == 0) {
        c_color++;
        if (c_color > s_color) {
          state_g[hook(0, myptr + 9)] = c_color | 0x8000000000000000ULL;
          state_g[hook(0, myptr)] = rev(reg);
          gotit = 1;
          break;
        }
      }

      prevlink = reg;
      reg = a51(reg, 100, 0);
      reg = a51(reg, 64, 1);

      if (challenge && (challenge == reg)) {
        state_g[hook(0, myptr)] = rev(prevlink);
        state_g[hook(0, myptr + 9)] = c_color | 0xC000000000000000ULL;
        gotit = 1;
        break;
      }
    }

    if (!gotit) {
      state_g[hook(0, myptr)] = reg;
      state_g[hook(0, myptr + 9)] = c_color | (state_g[hook(0, myptr + 9)] & 0xF000000000000000ULL);
    }
  }
}