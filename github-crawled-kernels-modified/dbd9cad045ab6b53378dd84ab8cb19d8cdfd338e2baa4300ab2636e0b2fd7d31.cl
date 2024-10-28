//{"((__global unsigned int *)big_bit_array_dev)":9,"((__global unsigned int *)pinfo_dev)":8,"((__global ushort *)pinfo_dev)":4,"((__local uchar *)locsieve)":3,"((__local ulong *)locsieve)":6,"((__local unsigned int *)locsieve)":5,"big_bit_array_dev":0,"locsieve":7,"maxp":2,"pinfo_dev":1}
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
  ((local uchar*)locsieve)[hook(3, bclr >> 3)] |= 1 << (bclr & 7);
}

__inline void bitOrSometimesIffy(local uchar* locsieve, unsigned int bclr) {
  unsigned int bytenum = bclr >> 3;
  uchar mask = 1 << (bclr & 7);
  uchar val = ((local uchar*)locsieve)[hook(3, bytenum)];
  if (!(val & mask))
    ((local uchar*)locsieve)[hook(3, bytenum)] = val | mask;
}
kernel void __attribute__((reqd_work_group_size(256, 1, 1))) SegSieve(global uchar* big_bit_array_dev, global uchar* pinfo_dev, unsigned int maxp) {
  local uchar locsieve[8192];
  unsigned int block_start = get_group_id(0) * block_size;
  unsigned int i, j, p, pinv, bclr;
  unsigned int thread_start = block_start + get_local_id(0) * block_size / 256;
  {
    unsigned int mask, mask2, mask3, mask4, i11 = 0xfffffff, i13, i17, i19, i23, i29, i31, i37, i41, i43, i47, i53, i59, i61;

    if (4 == 4) {
      i11 = mod_const_p(((global ushort*)pinfo_dev)[hook(4, 4)] - thread_start, 11);
      i13 = mod_const_p(((global ushort*)pinfo_dev)[hook(4, 5)] - thread_start, 13);
      i17 = mod_const_p(((global ushort*)pinfo_dev)[hook(4, 6)] - thread_start, 17);
    }
    if (4 == 5) {
      i13 = mod_const_p(((global ushort*)pinfo_dev)[hook(4, 5)] - thread_start, 13);
      i17 = mod_const_p(((global ushort*)pinfo_dev)[hook(4, 6)] - thread_start, 17);
    }
    if (4 == 6) {
      i17 = mod_const_p(((global ushort*)pinfo_dev)[hook(4, 6)] - thread_start, 17);
    }
    i19 = mod_const_p(((global ushort*)pinfo_dev)[hook(4, 7)] - thread_start, 19);
    i23 = mod_const_p(((global ushort*)pinfo_dev)[hook(4, 8)] - thread_start, 23);
    i29 = mod_const_p(((global ushort*)pinfo_dev)[hook(4, 9)] - thread_start, 29);
    i31 = mod_const_p(((global ushort*)pinfo_dev)[hook(4, 10)] - thread_start, 31);

    if (4 == 4) {
      mask = ((1 | (1 << 11) | (1 << 22)) << i11) | ((1 | (1 << 13) | (1 << 26)) << i13) | ((1 | (1 << 17)) << i17);
    }
    if (4 == 5) {
      mask = ((1 | (1 << 13) | (1 << 26)) << i13) | ((1 | (1 << 17)) << i17);
    }
    if (4 == 6) {
      mask = (1 | (1 << 17)) << i17;
    }
    mask |= ((1 | (1 << 19)) << i19) | ((1 | (1 << 23)) << i23);
    mask |= ((1 | (1 << 29)) << i29) | ((1 | (1 << 31)) << i31);

    if (4 == 4) {
      i11 = bump_mod_p(i11, -32, 11);
      i13 = bump_mod_p(i13, -32, 13);
      i17 = bump_mod_p(i17, -32, 17);
    }
    if (4 == 5) {
      i13 = bump_mod_p(i13, -32, 13);
      i17 = bump_mod_p(i17, -32, 17);
    }
    if (4 == 6) {
      i17 = bump_mod_p(i17, -32, 17);
    }
    i19 = bump_mod_p(i19, -32, 19);
    i23 = bump_mod_p(i23, -32, 23);
    i29 = bump_mod_p(i29, -32, 29);
    i31 = bump_mod_p(i31, -32, 31);

    if (4 == 4) {
      mask2 = ((1 | (1 << 11) | (1 << 22)) << i11) | ((1 | (1 << 13) | (1 << 26)) << i13) | ((1 | (1 << 17)) << i17);
    }
    if (4 == 5) {
      mask2 = ((1 | (1 << 13) | (1 << 26)) << i13) | ((1 | (1 << 17)) << i17);
    }
    if (4 == 6) {
      mask2 = (1 | (1 << 17)) << i17;
    }
    mask2 |= ((1 | (1 << 19)) << i19) | ((1 | (1 << 23)) << i23);
    mask2 |= ((1 | (1 << 29)) << i29) | ((1 | (1 << 31)) << i31);

    if (4 == 4) {
      i11 = bump_mod_p(i11, -32, 11);
      i13 = bump_mod_p(i13, -32, 13);
      i17 = bump_mod_p(i17, -32, 17);
    }
    if (4 == 5) {
      i13 = bump_mod_p(i13, -32, 13);
      i17 = bump_mod_p(i17, -32, 17);
    }
    if (4 == 6) {
      i17 = bump_mod_p(i17, -32, 17);
    }
    i19 = bump_mod_p(i19, -32, 19);
    i23 = bump_mod_p(i23, -32, 23);
    i29 = bump_mod_p(i29, -32, 29);
    i31 = bump_mod_p(i31, -32, 31);

    if (4 == 4) {
      mask3 = ((1 | (1 << 11) | (1 << 22)) << i11) | ((1 | (1 << 13) | (1 << 26)) << i13) | ((1 | (1 << 17)) << i17);
    }
    if (4 == 5) {
      mask3 = ((1 | (1 << 13) | (1 << 26)) << i13) | ((1 | (1 << 17)) << i17);
    }
    if (4 == 6) {
      mask3 = (1 | (1 << 17)) << i17;
    }
    mask3 |= ((1 | (1 << 19)) << i19) | ((1 | (1 << 23)) << i23);
    mask3 |= ((1 | (1 << 29)) << i29) | ((1 | (1 << 31)) << i31);

    if (4 == 4) {
      i11 = bump_mod_p(i11, -32, 11);
      i13 = bump_mod_p(i13, -32, 13);
      i17 = bump_mod_p(i17, -32, 17);
    }
    if (4 == 5) {
      i13 = bump_mod_p(i13, -32, 13);
      i17 = bump_mod_p(i17, -32, 17);
    }
    if (4 == 6) {
      i17 = bump_mod_p(i17, -32, 17);
    }
    i19 = bump_mod_p(i19, -32, 19);
    i23 = bump_mod_p(i23, -32, 23);
    i29 = bump_mod_p(i29, -32, 29);
    i31 = bump_mod_p(i31, -32, 31);

    if (4 == 4) {
      mask4 = ((1 | (1 << 11) | (1 << 22)) << i11) | ((1 | (1 << 13) | (1 << 26)) << i13) | ((1 | (1 << 17)) << i17);
    }
    if (4 == 5) {
      mask4 = ((1 | (1 << 13) | (1 << 26)) << i13) | ((1 | (1 << 17)) << i17);
    }
    if (4 == 6) {
      mask4 = (1 | (1 << 17)) << i17;
    }
    mask4 |= ((1 | (1 << 19)) << i19) | ((1 | (1 << 23)) << i23);
    mask4 |= ((1 | (1 << 29)) << i29) | ((1 | (1 << 31)) << i31);

    if (4 == 4) {
      i11 = bump_mod_p(i11, -32, 11);
      i13 = bump_mod_p(i13, -32, 13);
      i17 = bump_mod_p(i17, -32, 17);
    }
    if (4 == 5) {
      i13 = bump_mod_p(i13, -32, 13);
      i17 = bump_mod_p(i17, -32, 17);
    }
    if (4 == 6) {
      i17 = bump_mod_p(i17, -32, 17);
    }
    i19 = bump_mod_p(i19, -32, 19);
    i23 = bump_mod_p(i23, -32, 23);
    i29 = bump_mod_p(i29, -32, 29);
    i31 = bump_mod_p(i31, -32, 31);

    ((local unsigned int*)locsieve)[hook(5, get_local_id(0) * block_size / 256 / 32 + 0)] = mask;
    ((local unsigned int*)locsieve)[hook(5, get_local_id(0) * block_size / 256 / 32 + 1)] = mask2;
    ((local unsigned int*)locsieve)[hook(5, get_local_id(0) * block_size / 256 / 32 + 2)] = mask3;
    ((local unsigned int*)locsieve)[hook(5, get_local_id(0) * block_size / 256 / 32 + 3)] = mask4;

    if (4 == 4) {
      mask = ((1 | (1 << 11) | (1 << 22)) << i11) | ((1 | (1 << 13) | (1 << 26)) << i13) | ((1 | (1 << 17)) << i17);
    }
    if (4 == 5) {
      mask = ((1 | (1 << 13) | (1 << 26)) << i13) | ((1 | (1 << 17)) << i17);
    }
    if (4 == 6) {
      mask = (1 | (1 << 17)) << i17;
    }
    mask |= ((1 | (1 << 19)) << i19) | ((1 | (1 << 23)) << i23);
    mask |= ((1 | (1 << 29)) << i29) | ((1 | (1 << 31)) << i31);

    if (4 == 4) {
      i11 = bump_mod_p(i11, -32, 11);
      i13 = bump_mod_p(i13, -32, 13);
      i17 = bump_mod_p(i17, -32, 17);
    }
    if (4 == 5) {
      i13 = bump_mod_p(i13, -32, 13);
      i17 = bump_mod_p(i17, -32, 17);
    }
    if (4 == 6) {
      i17 = bump_mod_p(i17, -32, 17);
    }
    i19 = bump_mod_p(i19, -32, 19);
    i23 = bump_mod_p(i23, -32, 23);
    i29 = bump_mod_p(i29, -32, 29);
    i31 = bump_mod_p(i31, -32, 31);

    if (4 == 4) {
      mask2 = ((1 | (1 << 11) | (1 << 22)) << i11) | ((1 | (1 << 13) | (1 << 26)) << i13) | ((1 | (1 << 17)) << i17);
    }
    if (4 == 5) {
      mask2 = ((1 | (1 << 13) | (1 << 26)) << i13) | ((1 | (1 << 17)) << i17);
    }
    if (4 == 6) {
      mask2 = (1 | (1 << 17)) << i17;
    }
    mask2 |= ((1 | (1 << 19)) << i19) | ((1 | (1 << 23)) << i23);
    mask2 |= ((1 | (1 << 29)) << i29) | ((1 | (1 << 31)) << i31);

    if (4 == 4) {
      i11 = bump_mod_p(i11, -32, 11);
      i13 = bump_mod_p(i13, -32, 13);
      i17 = bump_mod_p(i17, -32, 17);
    }
    if (4 == 5) {
      i13 = bump_mod_p(i13, -32, 13);
      i17 = bump_mod_p(i17, -32, 17);
    }
    if (4 == 6) {
      i17 = bump_mod_p(i17, -32, 17);
    }
    i19 = bump_mod_p(i19, -32, 19);
    i23 = bump_mod_p(i23, -32, 23);
    i29 = bump_mod_p(i29, -32, 29);
    i31 = bump_mod_p(i31, -32, 31);

    if (4 == 4) {
      mask3 = ((1 | (1 << 11) | (1 << 22)) << i11) | ((1 | (1 << 13) | (1 << 26)) << i13) | ((1 | (1 << 17)) << i17);
    }
    if (4 == 5) {
      mask3 = ((1 | (1 << 13) | (1 << 26)) << i13) | ((1 | (1 << 17)) << i17);
    }
    if (4 == 6) {
      mask3 = (1 | (1 << 17)) << i17;
    }
    mask3 |= ((1 | (1 << 19)) << i19) | ((1 | (1 << 23)) << i23);
    mask3 |= ((1 | (1 << 29)) << i29) | ((1 | (1 << 31)) << i31);

    if (4 == 4) {
      i11 = bump_mod_p(i11, -32, 11);
      i13 = bump_mod_p(i13, -32, 13);
      i17 = bump_mod_p(i17, -32, 17);
    }
    if (4 == 5) {
      i13 = bump_mod_p(i13, -32, 13);
      i17 = bump_mod_p(i17, -32, 17);
    }
    if (4 == 6) {
      i17 = bump_mod_p(i17, -32, 17);
    }
    i19 = bump_mod_p(i19, -32, 19);
    i23 = bump_mod_p(i23, -32, 23);
    i29 = bump_mod_p(i29, -32, 29);
    i31 = bump_mod_p(i31, -32, 31);

    if (4 == 4) {
      mask4 = ((1 | (1 << 11) | (1 << 22)) << i11) | ((1 | (1 << 13) | (1 << 26)) << i13) | ((1 | (1 << 17)) << i17);
    }
    if (4 == 5) {
      mask4 = ((1 | (1 << 13) | (1 << 26)) << i13) | ((1 | (1 << 17)) << i17);
    }
    if (4 == 6) {
      mask4 = (1 | (1 << 17)) << i17;
    }
    mask4 |= ((1 | (1 << 19)) << i19) | ((1 | (1 << 23)) << i23);
    mask4 |= ((1 | (1 << 29)) << i29) | ((1 | (1 << 31)) << i31);

    ((local unsigned int*)locsieve)[hook(5, get_local_id(0) * block_size / 256 / 32 + 4)] = mask;
    ((local unsigned int*)locsieve)[hook(5, get_local_id(0) * block_size / 256 / 32 + 5)] = mask2;
    ((local unsigned int*)locsieve)[hook(5, get_local_id(0) * block_size / 256 / 32 + 6)] = mask3;
    ((local unsigned int*)locsieve)[hook(5, get_local_id(0) * block_size / 256 / 32 + 7)] = mask4;
    i37 = mod_const_p(((global ushort*)pinfo_dev)[hook(4, 11)] - thread_start, 37);
    i41 = mod_const_p(((global ushort*)pinfo_dev)[hook(4, 12)] - thread_start, 41);
    i43 = mod_const_p(((global ushort*)pinfo_dev)[hook(4, 13)] - thread_start, 43);
    i47 = mod_const_p(((global ushort*)pinfo_dev)[hook(4, 14)] - thread_start, 47);
    i53 = mod_const_p(((global ushort*)pinfo_dev)[hook(4, 15)] - thread_start, 53);
    i59 = mod_const_p(((global ushort*)pinfo_dev)[hook(4, 16)] - thread_start, 59);
    i61 = mod_const_p(((global ushort*)pinfo_dev)[hook(4, 17)] - thread_start, 61);

    for (j = 0;;) {
      mask = i37 > 31 ? 0 : (1 << i37);
      mask |= (i41 > 31 ? 0 : (1 << i41)) | (i43 > 31 ? 0 : (1 << i43));
      mask |= (i47 > 31 ? 0 : (1 << i47)) | (i53 > 31 ? 0 : (1 << i53));
      mask |= (i59 > 31 ? 0 : (1 << i59)) | (i61 > 31 ? 0 : (1 << i61));

      ((local unsigned int*)locsieve)[hook(5, get_local_id(0) * block_size / 256 / 32 + j)] |= mask;

      j++;
      if (j >= block_size / 256 / 32)
        break;

      i37 = bump_mod_p(i37, -32, 37);
      i41 = bump_mod_p(i41, -32, 41);
      i43 = bump_mod_p(i43, -32, 43);
      i47 = bump_mod_p(i47, -32, 47);
      i53 = bump_mod_p(i53, -32, 53);
      i59 = bump_mod_p(i59, -32, 59);
      i61 = bump_mod_p(i61, -32, 61);
    }
  }
  if (4 + 50 > 18) {
    unsigned int i67, i71, i73, i79, i83, i89, i97, i101, i103, i107, i109, i113, i127;
    ulong mask;

    i67 = mod_const_p(((global ushort*)pinfo_dev)[hook(4, 18)] - thread_start, 67);
    i71 = mod_const_p(((global ushort*)pinfo_dev)[hook(4, 19)] - thread_start, 71);
    i73 = mod_const_p(((global ushort*)pinfo_dev)[hook(4, 20)] - thread_start, 73);
    i79 = mod_const_p(((global ushort*)pinfo_dev)[hook(4, 21)] - thread_start, 79);
    i83 = mod_const_p(((global ushort*)pinfo_dev)[hook(4, 22)] - thread_start, 83);
    i89 = mod_const_p(((global ushort*)pinfo_dev)[hook(4, 23)] - thread_start, 89);
    i97 = mod_const_p(((global ushort*)pinfo_dev)[hook(4, 24)] - thread_start, 97);

    for (j = 0;;) {
      mask = i67 > 63 ? 0 : ((ulong)1 << i67);
      mask |= (i71 > 63 ? 0 : ((ulong)1 << i71));
      mask |= (i73 > 63 ? 0 : ((ulong)1 << i73));
      mask |= (i79 > 63 ? 0 : ((ulong)1 << i79));
      mask |= (i83 > 63 ? 0 : ((ulong)1 << i83));
      mask |= (i89 > 63 ? 0 : ((ulong)1 << i89));
      mask |= (i97 > 63 ? 0 : ((ulong)1 << i97));

      ((local ulong*)locsieve)[hook(6, get_local_id(0) * block_size / 256 / 64 + j)] |= mask;

      j++;
      if (j >= block_size / 256 / 64)
        break;

      i67 = bump_mod_p(i67, -64, 67);
      i71 = bump_mod_p(i71, -64, 71);
      i73 = bump_mod_p(i73, -64, 73);
      i79 = bump_mod_p(i79, -64, 79);
      i83 = bump_mod_p(i83, -64, 83);
      i89 = bump_mod_p(i89, -64, 89);
      i97 = bump_mod_p(i97, -64, 97);
    }

    i101 = mod_const_p(((global ushort*)pinfo_dev)[hook(4, 25)] - thread_start, 101);
    i103 = mod_const_p(((global ushort*)pinfo_dev)[hook(4, 26)] - thread_start, 103);
    i107 = mod_const_p(((global ushort*)pinfo_dev)[hook(4, 27)] - thread_start, 107);
    i109 = mod_const_p(((global ushort*)pinfo_dev)[hook(4, 28)] - thread_start, 109);
    i113 = mod_const_p(((global ushort*)pinfo_dev)[hook(4, 29)] - thread_start, 113);
    i127 = mod_const_p(((global ushort*)pinfo_dev)[hook(4, 30)] - thread_start, 127);

    for (j = 0;;) {
      mask = i101 > 63 ? 0 : ((ulong)1 << i101);
      mask |= (i103 > 63 ? 0 : ((ulong)1 << i103)) | (i107 > 63 ? 0 : ((ulong)1 << i107));
      mask |= (i109 > 63 ? 0 : ((ulong)1 << i109)) | (i113 > 63 ? 0 : ((ulong)1 << i113));
      mask |= i127 > 63 ? 0 : ((ulong)1 << i127);

      ((local ulong*)locsieve)[hook(6, get_local_id(0) * block_size / 256 / 64 + j)] |= mask;

      j++;
      if (j >= block_size / 256 / 64)
        break;

      i101 = bump_mod_p(i101, -64, 101);
      i103 = bump_mod_p(i103, -64, 103);
      i107 = bump_mod_p(i107, -64, 107);
      i109 = bump_mod_p(i109, -64, 109);
      i113 = bump_mod_p(i113, -64, 113);
      i127 = bump_mod_p(i127, -64, 127);
    }
  }
  if (4 + 50 > 31) {
    unsigned int i131, i137, i139, i149, i151, i157, i163, i167, i173, i179, i181, i191;
    unsigned int i193, i197, i199, i211, i223, i227, i229, i233, i239, i241, i251;
    ulong mask1, mask2;

    i131 = mod_const_p(((global ushort*)pinfo_dev)[hook(4, 31)] - thread_start, 131);
    i137 = mod_const_p(((global ushort*)pinfo_dev)[hook(4, 32)] - thread_start, 137);
    i139 = mod_const_p(((global ushort*)pinfo_dev)[hook(4, 33)] - thread_start, 139);
    i149 = mod_const_p(((global ushort*)pinfo_dev)[hook(4, 34)] - thread_start, 149);
    i151 = mod_const_p(((global ushort*)pinfo_dev)[hook(4, 35)] - thread_start, 151);
    i157 = mod_const_p(((global ushort*)pinfo_dev)[hook(4, 36)] - thread_start, 157);

    for (j = 0;;) {
      mask1 = (i131 > 63 ? 0 : ((ulong)1 << i131)) | (i137 > 63 ? 0 : ((ulong)1 << i137));
      mask1 |= (i139 > 63 ? 0 : ((ulong)1 << i139)) | (i149 > 63 ? 0 : ((ulong)1 << i149));
      mask1 |= (i151 > 63 ? 0 : ((ulong)1 << i151)) | (i157 > 63 ? 0 : ((ulong)1 << i157));

      mask2 = ((i131 - 64) > 63 ? 0 : ((ulong)1 << (i131 - 64))) | ((i137 - 64) > 63 ? 0 : ((ulong)1 << (i137 - 64)));
      mask2 |= ((i139 - 64) > 63 ? 0 : ((ulong)1 << (i139 - 64))) | ((i149 - 64) > 63 ? 0 : ((ulong)1 << (i149 - 64)));
      mask2 |= ((i151 - 64) > 63 ? 0 : ((ulong)1 << (i151 - 64))) | ((i157 - 64) > 63 ? 0 : ((ulong)1 << (i157 - 64)));

      ((local ulong*)locsieve)[hook(6, get_local_id(0) * block_size / 256 / 64 + j * 2)] |= mask1;
      ((local ulong*)locsieve)[hook(6, get_local_id(0) * block_size / 256 / 64 + j * 2 + 1)] |= mask2;

      j++;
      if (j >= block_size / 256 / 128)
        break;

      i131 = bump_mod_p(i131, -128, 131);
      i137 = bump_mod_p(i137, -128, 137);
      i139 = bump_mod_p(i139, -128, 139);
      i149 = bump_mod_p(i149, -128, 149);
      i151 = bump_mod_p(i151, -128, 151);
      i157 = bump_mod_p(i157, -128, 157);
    }

    i163 = mod_const_p(((global ushort*)pinfo_dev)[hook(4, 37)] - thread_start, 163);
    i167 = mod_const_p(((global ushort*)pinfo_dev)[hook(4, 38)] - thread_start, 167);
    i173 = mod_const_p(((global ushort*)pinfo_dev)[hook(4, 39)] - thread_start, 173);
    i179 = mod_const_p(((global ushort*)pinfo_dev)[hook(4, 40)] - thread_start, 179);
    i181 = mod_const_p(((global ushort*)pinfo_dev)[hook(4, 41)] - thread_start, 181);
    i191 = mod_const_p(((global ushort*)pinfo_dev)[hook(4, 42)] - thread_start, 191);

    for (j = 0;;) {
      mask1 = (i163 > 63 ? 0 : ((ulong)1 << i163)) | (i167 > 63 ? 0 : ((ulong)1 << i167));
      mask1 |= (i173 > 63 ? 0 : ((ulong)1 << i173)) | (i179 > 63 ? 0 : ((ulong)1 << i179));
      mask1 |= (i181 > 63 ? 0 : ((ulong)1 << i181)) | (i191 > 63 ? 0 : ((ulong)1 << i191));
      mask2 = (i163 - 64 > 63 ? 0 : ((ulong)1 << (i163 - 64))) | (i167 - 64 > 63 ? 0 : ((ulong)1 << (i167 - 64)));
      mask2 |= (i173 - 64 > 63 ? 0 : ((ulong)1 << (i173 - 64))) | (i179 - 64 > 63 ? 0 : ((ulong)1 << (i179 - 64)));
      mask2 |= (i181 - 64 > 63 ? 0 : ((ulong)1 << (i181 - 64))) | (i191 - 64 > 63 ? 0 : ((ulong)1 << (i191 - 64)));

      ((local ulong*)locsieve)[hook(6, get_local_id(0) * block_size / 256 / 64 + j * 2)] |= mask1;
      ((local ulong*)locsieve)[hook(6, get_local_id(0) * block_size / 256 / 64 + j * 2 + 1)] |= mask2;

      j++;
      if (j >= block_size / 256 / 128)
        break;

      i163 = bump_mod_p(i163, -128, 163);
      i167 = bump_mod_p(i167, -128, 167);
      i173 = bump_mod_p(i173, -128, 173);
      i179 = bump_mod_p(i179, -128, 179);
      i181 = bump_mod_p(i181, -128, 181);
      i191 = bump_mod_p(i191, -128, 191);
    }

    i193 = mod_const_p(((global ushort*)pinfo_dev)[hook(4, 43)] - thread_start, 193);
    i197 = mod_const_p(((global ushort*)pinfo_dev)[hook(4, 44)] - thread_start, 197);
    i199 = mod_const_p(((global ushort*)pinfo_dev)[hook(4, 45)] - thread_start, 199);
    i211 = mod_const_p(((global ushort*)pinfo_dev)[hook(4, 46)] - thread_start, 211);
    i223 = mod_const_p(((global ushort*)pinfo_dev)[hook(4, 47)] - thread_start, 223);
    i227 = mod_const_p(((global ushort*)pinfo_dev)[hook(4, 48)] - thread_start, 227);

    for (j = 0;;) {
      mask1 = (i193 > 63 ? 0 : ((ulong)1 << i193)) | (i197 > 63 ? 0 : ((ulong)1 << i197));
      mask1 |= (i199 > 63 ? 0 : ((ulong)1 << i199)) | (i211 > 63 ? 0 : ((ulong)1 << i211));
      mask1 |= (i223 > 63 ? 0 : ((ulong)1 << i223)) | (i227 > 63 ? 0 : ((ulong)1 << i227));
      mask2 = (i193 - 64 > 63 ? 0 : ((ulong)1 << (i193 - 64))) | (i197 - 64 > 63 ? 0 : ((ulong)1 << (i197 - 64)));
      mask2 |= (i199 - 64 > 63 ? 0 : ((ulong)1 << (i199 - 64))) | (i211 - 64 > 63 ? 0 : ((ulong)1 << (i211 - 64)));
      mask2 |= (i223 - 64 > 63 ? 0 : ((ulong)1 << (i223 - 64))) | (i227 - 64 > 63 ? 0 : ((ulong)1 << (i227 - 64)));

      ((local ulong*)locsieve)[hook(6, get_local_id(0) * block_size / 256 / 64 + j * 2)] |= mask1;
      ((local ulong*)locsieve)[hook(6, get_local_id(0) * block_size / 256 / 64 + j * 2 + 1)] |= mask2;

      j++;
      if (j >= block_size / 256 / 128)
        break;

      i193 = bump_mod_p(i193, -128, 193);
      i197 = bump_mod_p(i197, -128, 197);
      i199 = bump_mod_p(i199, -128, 199);
      i211 = bump_mod_p(i211, -128, 211);
      i223 = bump_mod_p(i223, -128, 223);
      i227 = bump_mod_p(i227, -128, 227);
    }

    i229 = mod_const_p(((global ushort*)pinfo_dev)[hook(4, 49)] - thread_start, 229);
    i233 = mod_const_p(((global ushort*)pinfo_dev)[hook(4, 50)] - thread_start, 233);
    i239 = mod_const_p(((global ushort*)pinfo_dev)[hook(4, 51)] - thread_start, 239);
    i241 = mod_const_p(((global ushort*)pinfo_dev)[hook(4, 52)] - thread_start, 241);
    i251 = mod_const_p(((global ushort*)pinfo_dev)[hook(4, 53)] - thread_start, 251);

    for (j = 0;;) {
      mask1 = i229 > 63 ? 0 : ((ulong)1 << i229);
      mask1 |= (i233 > 63 ? 0 : ((ulong)1 << i233)) | (i239 > 63 ? 0 : ((ulong)1 << i239));
      mask1 |= (i241 > 63 ? 0 : ((ulong)1 << i241)) | (i251 > 63 ? 0 : ((ulong)1 << i251));
      mask2 = i229 - 64 > 63 ? 0 : ((ulong)1 << (i229 - 64));
      mask2 |= (i233 - 64 > 63 ? 0 : ((ulong)1 << (i233 - 64))) | (i239 - 64 > 63 ? 0 : ((ulong)1 << (i239 - 64)));
      mask2 |= (i241 - 64 > 63 ? 0 : ((ulong)1 << (i241 - 64)));
      mask2 |= (i251 - 64 > 63 ? 0 : ((ulong)1 << (i251 - 64)));

      ((local ulong*)locsieve)[hook(6, get_local_id(0) * block_size / 256 / 64 + j * 2)] |= mask1;
      ((local ulong*)locsieve)[hook(6, get_local_id(0) * block_size / 256 / 64 + j * 2 + 1)] |= mask2;

      j++;
      if (j >= block_size / 256 / 128)
        break;

      i229 = bump_mod_p(i229, -128, 229);
      i233 = bump_mod_p(i233, -128, 233);
      i239 = bump_mod_p(i239, -128, 239);
      i241 = bump_mod_p(i241, -128, 241);
      i251 = bump_mod_p(i251, -128, 251);
    }
  }
  if (4 + 50 > 54)
    for (j = 0; j < block_size / (256 * 256); j++) {
      i = mod_const_p(((global ushort*)pinfo_dev)[hook(4, 54)] - thread_start, 257);
      if (i < 256)
        locsieve[hook(7, j * 256 * 32 + get_local_id(0) * 32 + (i >> 3))] |= 1 << (i & 7);
      ;
      i = mod_const_p(((global ushort*)pinfo_dev)[hook(4, 55)] - thread_start, 263);
      if (i < 256)
        locsieve[hook(7, j * 256 * 32 + get_local_id(0) * 32 + (i >> 3))] |= 1 << (i & 7);
      ;
      i = mod_const_p(((global ushort*)pinfo_dev)[hook(4, 56)] - thread_start, 269);
      if (i < 256)
        locsieve[hook(7, j * 256 * 32 + get_local_id(0) * 32 + (i >> 3))] |= 1 << (i & 7);
      ;
      i = mod_const_p(((global ushort*)pinfo_dev)[hook(4, 57)] - thread_start, 271);
      if (i < 256)
        locsieve[hook(7, j * 256 * 32 + get_local_id(0) * 32 + (i >> 3))] |= 1 << (i & 7);
      ;
      i = mod_const_p(((global ushort*)pinfo_dev)[hook(4, 58)] - thread_start, 277);
      if (i < 256)
        locsieve[hook(7, j * 256 * 32 + get_local_id(0) * 32 + (i >> 3))] |= 1 << (i & 7);
      ;
      i = mod_const_p(((global ushort*)pinfo_dev)[hook(4, 59)] - thread_start, 281);
      if (i < 256)
        locsieve[hook(7, j * 256 * 32 + get_local_id(0) * 32 + (i >> 3))] |= 1 << (i & 7);
      ;
      i = mod_const_p(((global ushort*)pinfo_dev)[hook(4, 60)] - thread_start, 283);
      if (i < 256)
        locsieve[hook(7, j * 256 * 32 + get_local_id(0) * 32 + (i >> 3))] |= 1 << (i & 7);
      ;
      i = mod_const_p(((global ushort*)pinfo_dev)[hook(4, 61)] - thread_start, 293);
      if (i < 256)
        locsieve[hook(7, j * 256 * 32 + get_local_id(0) * 32 + (i >> 3))] |= 1 << (i & 7);
      ;
      i = mod_const_p(((global ushort*)pinfo_dev)[hook(4, 62)] - thread_start, 307);
      if (i < 256)
        locsieve[hook(7, j * 256 * 32 + get_local_id(0) * 32 + (i >> 3))] |= 1 << (i & 7);
      ;
      i = mod_const_p(((global ushort*)pinfo_dev)[hook(4, 63)] - thread_start, 311);
      if (i < 256)
        locsieve[hook(7, j * 256 * 32 + get_local_id(0) * 32 + (i >> 3))] |= 1 << (i & 7);
      ;
      i = mod_const_p(((global ushort*)pinfo_dev)[hook(4, 64)] - thread_start, 313);
      if (i < 256)
        locsieve[hook(7, j * 256 * 32 + get_local_id(0) * 32 + (i >> 3))] |= 1 << (i & 7);
      ;
      i = mod_const_p(((global ushort*)pinfo_dev)[hook(4, 65)] - thread_start, 317);
      if (i < 256)
        locsieve[hook(7, j * 256 * 32 + get_local_id(0) * 32 + (i >> 3))] |= 1 << (i & 7);
      ;
      i = mod_const_p(((global ushort*)pinfo_dev)[hook(4, 66)] - thread_start, 331);
      if (i < 256)
        locsieve[hook(7, j * 256 * 32 + get_local_id(0) * 32 + (i >> 3))] |= 1 << (i & 7);
      ;
      i = mod_const_p(((global ushort*)pinfo_dev)[hook(4, 67)] - thread_start, 337);
      if (i < 256)
        locsieve[hook(7, j * 256 * 32 + get_local_id(0) * 32 + (i >> 3))] |= 1 << (i & 7);
      ;
      i = mod_const_p(((global ushort*)pinfo_dev)[hook(4, 68)] - thread_start, 347);
      if (i < 256)
        locsieve[hook(7, j * 256 * 32 + get_local_id(0) * 32 + (i >> 3))] |= 1 << (i & 7);
      ;
      i = mod_const_p(((global ushort*)pinfo_dev)[hook(4, 69)] - thread_start, 349);
      if (i < 256)
        locsieve[hook(7, j * 256 * 32 + get_local_id(0) * 32 + (i >> 3))] |= 1 << (i & 7);
      ;
      i = mod_const_p(((global ushort*)pinfo_dev)[hook(4, 70)] - thread_start, 353);
      if (i < 256)
        locsieve[hook(7, j * 256 * 32 + get_local_id(0) * 32 + (i >> 3))] |= 1 << (i & 7);
      ;
      i = mod_const_p(((global ushort*)pinfo_dev)[hook(4, 71)] - thread_start, 359);
      if (i < 256)
        locsieve[hook(7, j * 256 * 32 + get_local_id(0) * 32 + (i >> 3))] |= 1 << (i & 7);
      ;
      i = mod_const_p(((global ushort*)pinfo_dev)[hook(4, 72)] - thread_start, 367);
      if (i < 256)
        locsieve[hook(7, j * 256 * 32 + get_local_id(0) * 32 + (i >> 3))] |= 1 << (i & 7);
      ;
      i = mod_const_p(((global ushort*)pinfo_dev)[hook(4, 73)] - thread_start, 373);
      if (i < 256)
        locsieve[hook(7, j * 256 * 32 + get_local_id(0) * 32 + (i >> 3))] |= 1 << (i & 7);
      ;
      i = mod_const_p(((global ushort*)pinfo_dev)[hook(4, 74)] - thread_start, 379);
      if (i < 256)
        locsieve[hook(7, j * 256 * 32 + get_local_id(0) * 32 + (i >> 3))] |= 1 << (i & 7);
      ;
      i = mod_const_p(((global ushort*)pinfo_dev)[hook(4, 75)] - thread_start, 383);
      if (i < 256)
        locsieve[hook(7, j * 256 * 32 + get_local_id(0) * 32 + (i >> 3))] |= 1 << (i & 7);
      ;
      i = mod_const_p(((global ushort*)pinfo_dev)[hook(4, 76)] - thread_start, 389);
      if (i < 256)
        locsieve[hook(7, j * 256 * 32 + get_local_id(0) * 32 + (i >> 3))] |= 1 << (i & 7);
      ;
      i = mod_const_p(((global ushort*)pinfo_dev)[hook(4, 77)] - thread_start, 397);
      if (i < 256)
        locsieve[hook(7, j * 256 * 32 + get_local_id(0) * 32 + (i >> 3))] |= 1 << (i & 7);
      ;
      i = mod_const_p(((global ushort*)pinfo_dev)[hook(4, 78)] - thread_start, 401);
      if (i < 256)
        locsieve[hook(7, j * 256 * 32 + get_local_id(0) * 32 + (i >> 3))] |= 1 << (i & 7);
      ;
      i = mod_const_p(((global ushort*)pinfo_dev)[hook(4, 79)] - thread_start, 409);
      if (i < 256)
        locsieve[hook(7, j * 256 * 32 + get_local_id(0) * 32 + (i >> 3))] |= 1 << (i & 7);
      ;
      i = mod_const_p(((global ushort*)pinfo_dev)[hook(4, 80)] - thread_start, 419);
      if (i < 256)
        locsieve[hook(7, j * 256 * 32 + get_local_id(0) * 32 + (i >> 3))] |= 1 << (i & 7);
      ;
      i = mod_const_p(((global ushort*)pinfo_dev)[hook(4, 81)] - thread_start, 421);
      if (i < 256)
        locsieve[hook(7, j * 256 * 32 + get_local_id(0) * 32 + (i >> 3))] |= 1 << (i & 7);
      ;
      i = mod_const_p(((global ushort*)pinfo_dev)[hook(4, 82)] - thread_start, 431);
      if (i < 256)
        locsieve[hook(7, j * 256 * 32 + get_local_id(0) * 32 + (i >> 3))] |= 1 << (i & 7);
      ;
      i = mod_const_p(((global ushort*)pinfo_dev)[hook(4, 83)] - thread_start, 433);
      if (i < 256)
        locsieve[hook(7, j * 256 * 32 + get_local_id(0) * 32 + (i >> 3))] |= 1 << (i & 7);
      ;
      i = mod_const_p(((global ushort*)pinfo_dev)[hook(4, 84)] - thread_start, 439);
      if (i < 256)
        locsieve[hook(7, j * 256 * 32 + get_local_id(0) * 32 + (i >> 3))] |= 1 << (i & 7);
      ;
      i = mod_const_p(((global ushort*)pinfo_dev)[hook(4, 85)] - thread_start, 443);
      if (i < 256)
        locsieve[hook(7, j * 256 * 32 + get_local_id(0) * 32 + (i >> 3))] |= 1 << (i & 7);
      ;
      i = mod_const_p(((global ushort*)pinfo_dev)[hook(4, 86)] - thread_start, 449);
      if (i < 256)
        locsieve[hook(7, j * 256 * 32 + get_local_id(0) * 32 + (i >> 3))] |= 1 << (i & 7);
      ;
      i = mod_const_p(((global ushort*)pinfo_dev)[hook(4, 87)] - thread_start, 457);
      if (i < 256)
        locsieve[hook(7, j * 256 * 32 + get_local_id(0) * 32 + (i >> 3))] |= 1 << (i & 7);
      ;
      i = mod_const_p(((global ushort*)pinfo_dev)[hook(4, 88)] - thread_start, 461);
      if (i < 256)
        locsieve[hook(7, j * 256 * 32 + get_local_id(0) * 32 + (i >> 3))] |= 1 << (i & 7);
      ;
      i = mod_const_p(((global ushort*)pinfo_dev)[hook(4, 89)] - thread_start, 463);
      if (i < 256)
        locsieve[hook(7, j * 256 * 32 + get_local_id(0) * 32 + (i >> 3))] |= 1 << (i & 7);
      ;
      i = mod_const_p(((global ushort*)pinfo_dev)[hook(4, 90)] - thread_start, 467);
      if (i < 256)
        locsieve[hook(7, j * 256 * 32 + get_local_id(0) * 32 + (i >> 3))] |= 1 << (i & 7);
      ;
      i = mod_const_p(((global ushort*)pinfo_dev)[hook(4, 91)] - thread_start, 479);
      if (i < 256)
        locsieve[hook(7, j * 256 * 32 + get_local_id(0) * 32 + (i >> 3))] |= 1 << (i & 7);
      ;
      i = mod_const_p(((global ushort*)pinfo_dev)[hook(4, 92)] - thread_start, 487);
      if (i < 256)
        locsieve[hook(7, j * 256 * 32 + get_local_id(0) * 32 + (i >> 3))] |= 1 << (i & 7);
      ;
      i = mod_const_p(((global ushort*)pinfo_dev)[hook(4, 93)] - thread_start, 491);
      if (i < 256)
        locsieve[hook(7, j * 256 * 32 + get_local_id(0) * 32 + (i >> 3))] |= 1 << (i & 7);
      ;
      i = mod_const_p(((global ushort*)pinfo_dev)[hook(4, 94)] - thread_start, 499);
      if (i < 256)
        locsieve[hook(7, j * 256 * 32 + get_local_id(0) * 32 + (i >> 3))] |= 1 << (i & 7);
      ;
      i = mod_const_p(((global ushort*)pinfo_dev)[hook(4, 95)] - thread_start, 503);
      if (i < 256)
        locsieve[hook(7, j * 256 * 32 + get_local_id(0) * 32 + (i >> 3))] |= 1 << (i & 7);
      ;
      i = mod_const_p(((global ushort*)pinfo_dev)[hook(4, 96)] - thread_start, 509);
      if (i < 256)
        locsieve[hook(7, j * 256 * 32 + get_local_id(0) * 32 + (i >> 3))] |= 1 << (i & 7);
      ;
    }

  barrier(0x01);

  pinfo_dev += 1024;
  i = 0;
  for (; i < 1 && i < maxp; i++, pinfo_dev += 256 * 8) {
    for (j = 0; j < 8; j++) {
      uchar mask;

      bclr = ((global unsigned int*)pinfo_dev)[hook(8, j * 256 / 8 + get_local_id(0) / 8)];
      p = bclr >> 16;
      bclr &= 0xFFFF;
      pinv = ((global unsigned int*)pinfo_dev)[hook(8, 256 + j * 256 / 8 + get_local_id(0) / 8)];
      ;

      bclr = mod_p(bclr - block_start, p, pinv) + (get_local_id(0) & 7) * p;
      mask = 1 << (bclr & 7);
      bclr = bclr >> 3;

      do {
        uchar val = ((local uchar*)locsieve)[hook(3, bclr)];
        if (!(val & mask))
          ((local uchar*)locsieve)[hook(3, bclr)] = val | mask;
        bclr += p;
      } while (bclr < 8192);
    }
  }
  for (; i < sieving64KCrossover && i < maxp; i += 3, pinfo_dev += 256 * 24) {
    unsigned int p3, pinv3, bclr3, p2, pinv2, bclr2;

    bclr3 = ((global unsigned int*)pinfo_dev)[hook(8, get_local_id(0))];
    bclr2 = ((global unsigned int*)pinfo_dev)[hook(8, 256 * 2 + get_local_id(0))];
    bclr = ((global unsigned int*)pinfo_dev)[hook(8, 256 * 4 + get_local_id(0))];

    p3 = bclr3 >> 16;
    p2 = bclr2 >> 16;
    p = bclr >> 16;

    bclr3 &= 0xFFFF;
    bclr2 &= 0xFFFF;
    bclr &= 0xFFFF;

    ;
    ;
    ;

    pinv3 = ((global unsigned int*)pinfo_dev)[hook(8, 256 + get_local_id(0))];
    pinv2 = ((global unsigned int*)pinfo_dev)[hook(8, 256 * 3 + get_local_id(0))];
    pinv = ((global unsigned int*)pinfo_dev)[hook(8, 256 * 5 + get_local_id(0))];

    bclr3 = mod_p(bclr3 - block_start, p3, pinv3);
    bclr2 = mod_p(bclr2 - block_start, p2, pinv2);
    bclr = mod_p(bclr - block_start, p, pinv);

    do {
      bitOrSometimesIffy(locsieve, bclr3);
      bclr3 += p3;
    } while (bclr3 < block_size);
    do {
      bitOrSometimesIffy(locsieve, bclr2);
      bclr2 += p2;
    } while (bclr2 < block_size);
    do {
      bitOrSometimesIffy(locsieve, bclr);
      bclr += p;
    } while (bclr < block_size);
  }
  if (i < maxp) {
    unsigned int bclr2, pinv2, p2;

    bclr2 = ((global unsigned int*)pinfo_dev)[hook(8, get_local_id(0))];
    pinv2 = ((global unsigned int*)pinfo_dev)[hook(8, 256 + get_local_id(0))];
    p2 = ((global unsigned int*)pinfo_dev)[hook(8, 256 * 2 + get_local_id(0))];
    ;

    bclr2 = mod_p(bclr2 - block_start, p2, pinv2);

    if (bclr2 < block_size) {
      bitOr(locsieve, bclr2);
      bclr2 += p2;
      if (bclr2 < block_size)
        bitOr(locsieve, bclr2);
    }

    bclr = ((global unsigned int*)pinfo_dev)[hook(8, 256 * 3 + get_local_id(0))];
    pinv = ((global unsigned int*)pinfo_dev)[hook(8, 256 * 4 + get_local_id(0))];
    p = ((global unsigned int*)pinfo_dev)[hook(8, 256 * 5 + get_local_id(0))];
    ;

    bclr = mod_p(bclr - block_start, p, pinv);

    if (bclr < block_size)
      bitOr(locsieve, bclr);
    i += 2, pinfo_dev += 256 * 24;
  }
  for (; i < sieving128KCrossover + 1 && i < maxp; i += 3, pinfo_dev += 256 * 12) {
    unsigned int tmp3 = ((global unsigned int*)pinfo_dev)[hook(8, get_local_id(0))];
    unsigned int tmp2 = ((global unsigned int*)pinfo_dev)[hook(8, 256 + get_local_id(0))];
    unsigned int tmp = ((global unsigned int*)pinfo_dev)[hook(8, 256 * 2 + get_local_id(0))];
    unsigned int bclr3, p3, pinv3, bclr2, p2, pinv2;

    bclr3 = tmp3 & 0x0003FFFF;
    bclr2 = tmp2 & 0x0003FFFF;
    bclr = tmp & 0x0003FFFF;

    pinv3 = pinv - (tmp3 >> 25);
    pinv2 = pinv - (tmp2 >> 25);
    pinv -= tmp >> 25;

    p3 = p + ((tmp3 & 0x01FC0000) >> 17);
    p2 = p + ((tmp2 & 0x01FC0000) >> 17);
    p += (tmp & 0x01FC0000) >> 17;

    ;
    ;
    ;

    bclr3 = mod_p(bclr3 - block_start, p3, pinv3);
    bclr2 = mod_p(bclr2 - block_start, p2, pinv2);
    bclr = mod_p(bclr - block_start, p, pinv);

    if (bclr3 < block_size)
      bitOr(locsieve, bclr3);
    if (bclr2 < block_size)
      bitOr(locsieve, bclr2);
    if (bclr < block_size)
      bitOr(locsieve, bclr);
  }
  if (i < maxp) {
    bclr = ((global unsigned int*)pinfo_dev)[hook(8, get_local_id(0))];
    pinv = ((global unsigned int*)pinfo_dev)[hook(8, 256 + get_local_id(0))];
    p = ((global unsigned int*)pinfo_dev)[hook(8, 256 * 2 + get_local_id(0))];
    ;

    bclr = sloppy_mod_p(bclr - block_start, p, pinv);

    if (bclr < block_size)
      bitOr(locsieve, bclr);
    i++, pinfo_dev += 256 * 12;
  }
  for (; i < sieving1MCrossover && i < maxp; i += 4, pinfo_dev += 256 * 16) {
    unsigned int tmp4 = ((global unsigned int*)pinfo_dev)[hook(8, get_local_id(0))];
    unsigned int tmp3 = ((global unsigned int*)pinfo_dev)[hook(8, 256 + get_local_id(0))];
    unsigned int tmp2 = ((global unsigned int*)pinfo_dev)[hook(8, 256 * 2 + get_local_id(0))];
    unsigned int tmp = ((global unsigned int*)pinfo_dev)[hook(8, 256 * 3 + get_local_id(0))];
    unsigned int bclr4, p4, pinv4, bclr3, p3, pinv3, bclr2, p2, pinv2;

    bclr4 = tmp4 & 0x000FFFFF;
    bclr3 = tmp3 & 0x000FFFFF;
    bclr2 = tmp2 & 0x000FFFFF;
    bclr = tmp & 0x000FFFFF;

    pinv4 = pinv - (tmp4 >> 27);
    pinv3 = pinv - (tmp3 >> 27);
    pinv2 = pinv - (tmp2 >> 27);
    pinv -= tmp >> 27;

    p4 = p + ((tmp4 & 0x07F00000) >> 19);
    p3 = p + ((tmp3 & 0x07F00000) >> 19);
    p2 = p + ((tmp2 & 0x07F00000) >> 19);
    p += (tmp & 0x07F00000) >> 19;

    ;
    ;
    ;
    ;

    bclr4 = sloppy_mod_p(bclr4 - block_start, p4, pinv4);
    bclr3 = sloppy_mod_p(bclr3 - block_start, p3, pinv3);
    bclr2 = sloppy_mod_p(bclr2 - block_start, p2, pinv2);
    bclr = sloppy_mod_p(bclr - block_start, p, pinv);

    if (bclr4 < block_size)
      bitOr(locsieve, bclr4);
    if (bclr3 < block_size)
      bitOr(locsieve, bclr3);
    if (bclr2 < block_size)
      bitOr(locsieve, bclr2);
    if (bclr < block_size)
      bitOr(locsieve, bclr);
  }
  if (i < maxp) {
    bclr = ((global unsigned int*)pinfo_dev)[hook(8, get_local_id(0))];
    pinv = ((global unsigned int*)pinfo_dev)[hook(8, 256 + get_local_id(0))];
    p = ((global unsigned int*)pinfo_dev)[hook(8, 256 * 2 + get_local_id(0))];
    ;

    bclr = sloppy_mod_p(bclr - block_start, p, pinv);

    if (bclr < block_size)
      bitOr(locsieve, bclr);
    i++, pinfo_dev += 256 * 12;
  }
  for (; i < maxp; i += 4, pinfo_dev += 256 * 16) {
    unsigned int tmp4 = ((global unsigned int*)pinfo_dev)[hook(8, get_local_id(0))];
    unsigned int tmp3 = ((global unsigned int*)pinfo_dev)[hook(8, 256 + get_local_id(0))];
    unsigned int tmp2 = ((global unsigned int*)pinfo_dev)[hook(8, 256 * 2 + get_local_id(0))];
    unsigned int tmp = ((global unsigned int*)pinfo_dev)[hook(8, 256 * 3 + get_local_id(0))];
    unsigned int bclr4, p4, pinv4, bclr3, p3, pinv3, bclr2, p2, pinv2;

    bclr4 = tmp4 & 0x00FFFFFF;
    bclr3 = tmp3 & 0x00FFFFFF;
    bclr2 = tmp2 & 0x00FFFFFF;
    bclr = tmp & 0x00FFFFFF;

    pinv4 = pinv - (tmp4 >> 31);
    pinv3 = pinv - (tmp3 >> 31);
    pinv2 = pinv - (tmp2 >> 31);
    pinv -= tmp >> 31;

    p4 = p + ((tmp4 & 0x7F000000) >> 23);
    p3 = p + ((tmp3 & 0x7F000000) >> 23);
    p2 = p + ((tmp2 & 0x7F000000) >> 23);
    p += (tmp & 0x7F000000) >> 23;

    ;
    ;
    ;
    ;

    bclr4 = sloppy_mod_p(bclr4 - block_start, p4, pinv4);
    bclr3 = sloppy_mod_p(bclr3 - block_start, p3, pinv3);
    bclr2 = sloppy_mod_p(bclr2 - block_start, p2, pinv2);
    bclr = sloppy_mod_p(bclr - block_start, p, pinv);

    if (bclr4 < block_size)
      bitOr(locsieve, bclr4);
    if (bclr3 < block_size)
      bitOr(locsieve, bclr3);
    if (bclr2 < block_size)
      bitOr(locsieve, bclr2);
    if (bclr < block_size)
      bitOr(locsieve, bclr);
  }

  barrier(0x01);
  big_bit_array_dev += get_group_id(0) * 8192;

  for (j = 0; j < block_size / (256 * 32); j++)
    ((global unsigned int*)big_bit_array_dev)[hook(9, j * 256 + get_local_id(0))] = ~((local unsigned int*)locsieve)[hook(5, j * 256 + get_local_id(0))];
}