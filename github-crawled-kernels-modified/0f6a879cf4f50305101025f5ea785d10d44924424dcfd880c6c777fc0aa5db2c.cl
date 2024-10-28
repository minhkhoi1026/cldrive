//{"N":1,"base":0,"iters":6,"modulus":5,"pattern1":3,"pattern2":4,"shift":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
unsigned __popc(unsigned int x) {
  if (x == 0)
    return 0;
  if ((x &= x - 1) == 0)
    return 1;
  if ((x &= x - 1) == 0)
    return 2;
  if ((x &= x - 1) == 0)
    return 3;
  if ((x &= x - 1) == 0)
    return 4;
  if ((x &= x - 1) == 0)
    return 5;
  if ((x &= x - 1) == 0)
    return 6;
  if ((x &= x - 1) == 0)
    return 7;
  if ((x &= x - 1) == 0)
    return 8;
  if ((x &= x - 1) == 0)
    return 9;
  if ((x &= x - 1) == 0)
    return 10;
  if ((x &= x - 1) == 0)
    return 11;
  if ((x &= x - 1) == 0)
    return 12;
  if ((x &= x - 1) == 0)
    return 13;
  if ((x &= x - 1) == 0)
    return 14;
  if ((x &= x - 1) == 0)
    return 15;
  if ((x &= x - 1) == 0)
    return 16;
  if ((x &= x - 1) == 0)
    return 17;
  if ((x &= x - 1) == 0)
    return 18;
  if ((x &= x - 1) == 0)
    return 19;
  if ((x &= x - 1) == 0)
    return 20;
  if ((x &= x - 1) == 0)
    return 21;
  if ((x &= x - 1) == 0)
    return 22;
  if ((x &= x - 1) == 0)
    return 23;
  if ((x &= x - 1) == 0)
    return 24;
  if ((x &= x - 1) == 0)
    return 25;
  if ((x &= x - 1) == 0)
    return 26;
  if ((x &= x - 1) == 0)
    return 27;
  if ((x &= x - 1) == 0)
    return 28;
  if ((x &= x - 1) == 0)
    return 29;
  if ((x &= x - 1) == 0)
    return 30;
  if ((x &= x - 1) == 0)
    return 31;
  return 32;
}

void deviceMul3131(unsigned int v1, unsigned int v2, unsigned int* LO, unsigned int* HI) {
  *LO = v1 * v2;
  *HI = mul_hi(v1, v2);
  *HI <<= 1;
  *HI |= ((*LO) & 0x80000000) >> 31;
  *LO &= 0x7FFFFFFF;
}

unsigned int deviceModMP31(unsigned int LO, unsigned int HI) {
  unsigned int sum = LO + HI;
  if (sum >= 0x80000000) {
    return sum - 0x80000000 + 1;
  } else {
    return sum;
  }
}
unsigned int deviceMulMP31(unsigned int a, unsigned int b) {
  unsigned int LO, HI;
  deviceMul3131(a, b, &LO, &HI);
  return deviceModMP31(LO, HI);
}

unsigned int deviceExpoModMP31(unsigned int base, unsigned int exponent) {
  unsigned int result = 1;
  while (exponent > 0) {
    if (exponent & 1) {
      result = deviceMulMP31(result, base);
    }
    exponent >>= 1;
    base = deviceMulMP31(base, base);
  }
  return result;
}

unsigned int deviceRan0p(int seed, int n) {
  unsigned int an = deviceExpoModMP31(16807, n + 1);
  return deviceMulMP31(an, seed);
}

int deviceIrbit2(unsigned int* seed) {
  const unsigned int IB1 = 1;
  const unsigned int IB2 = 2;
  const unsigned int IB5 = 16;
  const unsigned int IB18 = 131072;
  const unsigned int MASK = IB1 + IB2 + IB5;
  if ((*seed) & IB18) {
    *seed = (((*seed) ^ MASK) << 1) | IB1;
    return 1;
  } else {
    *seed <<= 1;
    return 0;
  }
}
int deviceIrbit2_local(local unsigned int* seed) {
  const unsigned int IB1 = 1;
  const unsigned int IB2 = 2;
  const unsigned int IB5 = 16;
  const unsigned int IB18 = 131072;
  const unsigned int MASK = IB1 + IB2 + IB5;
  if ((*seed) & IB18) {
    *seed = (((*seed) ^ MASK) << 1) | IB1;
    return 1;
  } else {
    *seed <<= 1;
    return 0;
  }
}

kernel void deviceWritePairedModulo(global unsigned int* base, const unsigned int N, const unsigned int shift, const unsigned int pattern1, const unsigned int pattern2, const unsigned int modulus, const unsigned int iters) {
  const unsigned int startoff = (get_group_id(0) * N * get_local_size(0) + get_local_id(0));
  const unsigned int startrow = startoff / modulus;
  const unsigned int startcol = startoff - (startrow * modulus);
  const unsigned int row_per_workgroup = get_local_size(0) / modulus;
  const unsigned int col_per_workgroup = get_local_size(0) - (modulus * row_per_workgroup);
  unsigned int offset;
  unsigned int row, col;
  row = startrow;
  col = startcol;
  for (unsigned int i = 0; i < N; i++) {
    offset = row * modulus + col;
    if (col == shift)
      *(base + offset) = pattern1;
    row += row_per_workgroup;
    col += col_per_workgroup;
    if (col >= modulus) {
      col -= modulus;
      row++;
    }
  }
  barrier(0x01 | 0x02);
  for (unsigned int j = 0; j < iters; j++) {
    row = startrow;
    col = startcol;
    for (unsigned int i = 0; i < N; i++) {
      offset = row * modulus + col;
      if (col != shift)
        *(base + offset) = pattern2;
      row += row_per_workgroup;
      col += col_per_workgroup;
      if (col >= modulus) {
        col -= modulus;
        row++;
      }
    }
  }
}