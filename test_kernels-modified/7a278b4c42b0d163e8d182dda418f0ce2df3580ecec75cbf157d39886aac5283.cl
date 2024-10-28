//{"((__local uchar *)locsieve)":4,"calc_info":2,"exponent":0,"k_base":1,"pinfo_dev":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant unsigned int block_size = 8192 * 8;
constant unsigned int sieving64KCrossover = (6542 - 4 - 50) / 256;
constant unsigned int sieving128KCrossover = (12251 - 4 - 50) / 256;
constant unsigned int sieving1MCrossover = (82025 - 4 - 50) / 256 - 3;
constant unsigned int two_pow_n_32[] = {1 << 0, 1 << 1, 1 << 2, 1 << 3, 1 << 4, 1 << 5, 1 << 6, 1 << 7, 1 << 8, 1 << 9, 1 << 10, 1 << 11, 1 << 12, 1 << 13, 1 << 14, 1 << 15, 1 << 16, 1 << 17, 1 << 18, 1 << 19, 1 << 20, 1 << 21, 1 << 22, 1 << 23, 1 << 24, 1 << 25, 1 << 26, 1 << 27, 1 << 28, 1 << 29, 1 << 30, 1 << 31, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
__inline int mod_p(int x, const int p, const int pinv) {
  int r;

  r = mul_hi(x, pinv);
  x = x - p * r;

  r = x - p;
  r = (r >= 0) ? r : x;
  return r;
}

__inline int mod_const_p(int x, int p) {
  return mod_p(x, p, (0xFFFFFFFF / (p) + 1));
}
__inline int sloppy_mod_p(int x, int p, int pinv) {
  int q, r;

  q = mul_hi(x, pinv);
  r = x - q * p;
  return r;
}

__inline int bump_mod_p(int i, int inc, int p) {
  int x, j;
  i = i + inc % p;
  j = i + p;
  x = (i >= 0) ? i : j;

  return x;
}

__inline void bitOr(local uchar* locsieve, unsigned int bclr) {
  ((local uchar*)locsieve)[hook(4, bclr >> 3)] |= 1 << (bclr & 7);
}

__inline void bitOrSometimesIffy(local uchar* locsieve, unsigned int bclr) {
  unsigned int bytenum = bclr >> 3;
  uchar mask = 1 << (bclr & 7);
  uchar val = ((local uchar*)locsieve)[hook(4, bytenum)];
  if (!(val & mask))
    ((local uchar*)locsieve)[hook(4, bytenum)] = val | mask;
}
unsigned int modularinverse(unsigned int n, unsigned int orig_d) {
  unsigned int d = orig_d;
  int x, lastx, q, t;
  x = 0;
  lastx = 1;
  while (d != 0) {
    q = n / d;
    t = d;
    d = n - q * d;
    n = t;
    t = x;
    x = lastx - q * x;
    lastx = t;
  }
  return (lastx < 0) ? (lastx + orig_d) : lastx;
}

kernel void __attribute__((reqd_work_group_size(256, 1, 1))) CalcBitToClear(unsigned int exponent, ulong k_base, global int* calc_info, global uchar* pinfo_dev) {
  unsigned int index;
  unsigned int mask;
  unsigned int prime;
  unsigned int modinv;
  unsigned int bit_to_clear;

  if (get_group_id(0) == 0) {
    if (get_local_id(0) < 4 || get_local_id(0) >= 4 + 50)
      return;
    pinfo_dev += get_local_id(0) * 2;
    index = get_local_id(0);
  }

  else {
    pinfo_dev += calc_info[hook(2, (get_group_id(0) - 1))];

    pinfo_dev += get_local_id(0) * 4;

    index = calc_info[hook(2, 4224 + (get_group_id(0) - 1))];

    index += get_local_id(0) * calc_info[hook(2, 4224 * 2 + (get_group_id(0) - 1))];

    mask = calc_info[hook(2, 4224 * 3 + (get_group_id(0) - 1))];
  }

  prime = calc_info[hook(2, 4224 * 4 + index * 2)];
  modinv = calc_info[hook(2, 4224 * 4 + index * 2 + 1)];

  ulong k_mod_p;
  ulong factor_mod_p;

  k_mod_p = k_base % prime;
  factor_mod_p = (2 * k_mod_p * exponent + 1) % prime;
  bit_to_clear = ((ulong)prime - factor_mod_p) * modinv % prime;
  if (get_group_id(0) == 0) {
    *((global ushort*)pinfo_dev) = bit_to_clear;
  }

  else {
    *((global unsigned int*)pinfo_dev) = (*((global unsigned int*)pinfo_dev) & mask) + bit_to_clear;
  }
}