//{"data":1,"key_start":0,"keys":10,"mapping":3,"output":2,"sbox":6,"sbox[s_selector]":5,"sbox[s_selector][r_selector.w]":9,"sbox[s_selector][r_selector.x]":4,"sbox[s_selector][r_selector.y]":7,"sbox[s_selector][r_selector.z]":8}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant unsigned int sbox[8][4][16] = {

    {{0xe, 0x4, 0xd, 0x1, 0x2, 0xf, 0xb, 0x8, 0x3, 0xa, 0x6, 0xc, 0x5, 0x9, 0x0, 0x7}, {0x0, 0xf, 0x7, 0x4, 0xe, 0x2, 0xd, 0x1, 0xa, 0x6, 0xc, 0xb, 0x9, 0x5, 0x3, 0x8}, {0x4, 0x1, 0xe, 0x8, 0xd, 0x6, 0x2, 0xb, 0xf, 0xc, 0x9, 0x7, 0x3, 0xa, 0x5, 0x0}, {0xf, 0xc, 0x8, 0x2, 0x4, 0x9, 0x1, 0x7, 0x5, 0xb, 0x3, 0xe, 0xa, 0x0, 0x6, 0xd}},

    {{0xf, 0x1, 0x8, 0xe, 0x6, 0xb, 0x3, 0x4, 0x9, 0x7, 0x2, 0xd, 0xc, 0x0, 0x5, 0xa}, {0x3, 0xd, 0x4, 0x7, 0xf, 0x2, 0x8, 0xe, 0xc, 0x0, 0x1, 0xa, 0x6, 0x9, 0xb, 0x5}, {0x0, 0xe, 0x7, 0xb, 0xa, 0x4, 0xd, 0x1, 0x5, 0x8, 0xc, 0x6, 0x9, 0x3, 0x2, 0xf}, {0xd, 0x8, 0xa, 0x1, 0x3, 0xf, 0x4, 0x2, 0xb, 0x6, 0x7, 0xc, 0x0, 0x5, 0xe, 0x9}},

    {{0xa, 0x0, 0x9, 0xe, 0x6, 0x3, 0xf, 0x5, 0x1, 0xd, 0xc, 0x7, 0xb, 0x4, 0x2, 0x8}, {0xd, 0x7, 0x0, 0x9, 0x3, 0x4, 0x6, 0xa, 0x2, 0x8, 0x5, 0xe, 0xc, 0xb, 0xf, 0x1}, {0xd, 0x6, 0x4, 0x9, 0x8, 0xf, 0x3, 0x0, 0xb, 0x1, 0x2, 0xc, 0x5, 0xa, 0xe, 0x7}, {0x1, 0xa, 0xd, 0x0, 0x6, 0x9, 0x8, 0x7, 0x4, 0xf, 0xe, 0x3, 0xb, 0x5, 0x2, 0xc}},

    {{0x7, 0xd, 0xe, 0x3, 0x0, 0x6, 0x9, 0xa, 0x1, 0x2, 0x8, 0x5, 0xb, 0xc, 0x4, 0xf}, {0xd, 0x8, 0xb, 0x5, 0x6, 0xf, 0x0, 0x3, 0x4, 0x7, 0x2, 0xc, 0x1, 0xa, 0xe, 0x9}, {0xa, 0x6, 0x9, 0x0, 0xc, 0xb, 0x7, 0xd, 0xf, 0x1, 0x3, 0xe, 0x5, 0x2, 0x8, 0x4}, {0x3, 0xf, 0x0, 0x6, 0xa, 0x1, 0xd, 0x8, 0x9, 0x4, 0x5, 0xb, 0xc, 0x7, 0x2, 0xe}},

    {{0x2, 0xc, 0x4, 0x1, 0x7, 0xa, 0xb, 0x6, 0x8, 0x5, 0x3, 0xf, 0xd, 0x0, 0xe, 0x9}, {0xe, 0xb, 0x2, 0xc, 0x4, 0x7, 0xd, 0x1, 0x5, 0x0, 0xf, 0xa, 0x3, 0x9, 0x8, 0x6}, {0x4, 0x2, 0x1, 0xb, 0xa, 0xd, 0x7, 0x8, 0xf, 0x9, 0xc, 0x5, 0x6, 0x3, 0x0, 0xe}, {0xb, 0x8, 0xc, 0x7, 0x1, 0xe, 0x2, 0xd, 0x6, 0xf, 0x0, 0x9, 0xa, 0x4, 0x5, 0x3}},

    {{0xc, 0x1, 0xa, 0xf, 0x9, 0x2, 0x6, 0x8, 0x0, 0xd, 0x3, 0x4, 0xe, 0x7, 0x5, 0xb}, {0xa, 0xf, 0x4, 0x2, 0x7, 0xc, 0x9, 0x5, 0x6, 0x1, 0xd, 0xe, 0x0, 0xb, 0x3, 0x8}, {0x9, 0xe, 0xf, 0x5, 0x2, 0x8, 0xc, 0x3, 0x7, 0x0, 0x4, 0xa, 0x1, 0xd, 0xb, 0x6}, {0x4, 0x3, 0x2, 0xc, 0x9, 0x5, 0xf, 0xa, 0xb, 0xe, 0x1, 0x7, 0x6, 0x0, 0x8, 0xd}},

    {{0x4, 0xb, 0x2, 0xe, 0xf, 0x0, 0x8, 0xd, 0x3, 0xc, 0x9, 0x7, 0x5, 0xa, 0x6, 0x1}, {0xd, 0x0, 0xb, 0x7, 0x4, 0x9, 0x1, 0xa, 0xe, 0x3, 0x5, 0xc, 0x2, 0xf, 0x8, 0x6}, {0x1, 0x4, 0xb, 0xd, 0xc, 0x3, 0x7, 0xe, 0xa, 0xf, 0x6, 0x8, 0x0, 0x5, 0x9, 0x2}, {0x6, 0xb, 0xd, 0x8, 0x1, 0x4, 0xa, 0x7, 0x9, 0x5, 0x0, 0xf, 0xe, 0x2, 0x3, 0xc}},

    {{0xd, 0x2, 0x8, 0x4, 0x6, 0xf, 0xb, 0x1, 0xa, 0x9, 0x3, 0xe, 0x5, 0x0, 0xc, 0x7}, {0x1, 0xf, 0xd, 0x8, 0xa, 0x3, 0x7, 0x4, 0xc, 0x5, 0x6, 0xb, 0x0, 0xe, 0x9, 0x2}, {0x7, 0xb, 0x4, 0x1, 0x9, 0xc, 0xe, 0x2, 0x0, 0x6, 0xa, 0xd, 0xf, 0x3, 0x5, 0x8}, {0x2, 0x1, 0xe, 0x7, 0x4, 0xa, 0x8, 0xd, 0xf, 0xc, 0x9, 0x0, 0x3, 0x5, 0x6, 0xb}}};

constant unsigned int ip_i = 64;
constant unsigned int ip_o = 64;
constant unsigned int ip[] = {58, 50, 42, 34, 26, 18, 10, 2, 60, 52, 44, 36, 28, 20, 12, 4, 62, 54, 46, 38, 30, 22, 14, 6, 64, 56, 48, 40, 32, 24, 16, 8, 57, 49, 41, 33, 25, 17, 9, 1, 59, 51, 43, 35, 27, 19, 11, 3, 61, 53, 45, 37, 29, 21, 13, 5, 63, 55, 47, 39, 31, 23, 15, 7};

constant unsigned int ikp_i = 64;
constant unsigned int ikp_o = 56;
constant unsigned int ikp[] = {57, 49, 41, 33, 25, 17, 9, 1, 58, 50, 42, 34, 26, 18, 10, 2, 59, 51, 43, 35, 27, 19, 11, 3, 60, 52, 44, 36, 63, 55, 47, 39, 31, 23, 15, 7, 62, 54, 46, 38, 30, 22, 14, 6, 61, 53, 45, 37, 29, 21, 13, 5, 28, 20, 12, 4};

constant unsigned int rkp_i = 56;
constant unsigned int rkp_o = 48;
constant unsigned int rkp[] = {14, 17, 11, 24, 1, 5, 3, 28, 15, 6, 21, 10, 23, 19, 12, 4, 26, 8, 16, 7, 27, 20, 13, 2, 41, 52, 31, 37, 47, 55, 30, 40, 51, 45, 33, 48, 44, 49, 39, 56, 34, 53, 46, 42, 50, 36, 29, 32};

constant unsigned int rp_i = 32;
constant unsigned int rp_o = 32;
constant unsigned int rp[] = {16, 7, 20, 21, 29, 12, 28, 17, 1, 15, 23, 26, 5, 18, 31, 10, 2, 8, 24, 14, 32, 27, 3, 9, 19, 13, 30, 6, 22, 11, 4, 25};
inline ulong4 extractBit(ulong4 input, int src, int dst, int s_size, int d_size) {
  dst = (d_size - dst);
  src = (s_size - src);
  ulong4 bit = (ulong4)0x1 << (src);
  ulong4 output;
  if (src >= dst)
    output = (input & bit) >> (src - dst);
  else
    output = (input & bit) << (dst - src);
  return output;
}

ulong4 doPermute(ulong4 input, constant unsigned int* mapping, unsigned int s_size, unsigned int d_size) {
  ulong4 output = (ulong4)(0, 0, 0, 0);
  for (int i = 1; i <= d_size; i++) {
    output |= extractBit(input, mapping[hook(3, i - 1)], i, s_size, d_size);
  }
  return output;
}

ulong4 doInversePermute(ulong4 input, constant unsigned int* mapping, unsigned int s_size, unsigned int d_size) {
  ulong4 output = (ulong4)(0, 0, 0, 0);
  for (int i = 1; i <= s_size; i++) {
    output |= extractBit(input, i, mapping[hook(3, i - 1)], s_size, d_size);
  }
  return output;
}

uint4 doSBoxSub(int s_selector, uint4 input) {
  uint4 left = (input & 0x20) >> 4;
  uint4 right = input & 0x1;
  uint4 r_selector = left | right;
  uint4 c_selector = (input & 0x1E) >> 1;
  uint4 toret;
  toret.x = sbox[hook(6, s_selector)][hook(5, r_selector.x)][hook(4, c_selector.x)];
  toret.y = sbox[hook(6, s_selector)][hook(5, r_selector.y)][hook(7, c_selector.y)];
  toret.z = sbox[hook(6, s_selector)][hook(5, r_selector.z)][hook(8, c_selector.z)];
  toret.w = sbox[hook(6, s_selector)][hook(5, r_selector.w)][hook(9, c_selector.w)];
  return toret;
}

ulong4 initialPermutation(ulong4 input) {
  ulong4 output = doPermute(input, ip, ip_i, ip_o);
  return output;
}

ulong4 finalPermutation(ulong4 input) {
  ulong4 output = doInversePermute(input, ip, ip_i, ip_o);
  return output;
}

ulong4 generateCD(ulong4 input) {
  ulong4 output = doPermute(input, ikp, ikp_i, ikp_o);
  return output;
}

ulong4 generatePerRoundKey(ulong4 CD) {
  ulong4 output = doPermute(CD, rkp, rkp_i, rkp_o);
  return output;
}

ulong4 rotateCD(int round_num, ulong4 CD) {
  int rotation = 2;
  if (round_num == 0 || round_num == 1 || round_num == 8 || round_num == 15)
    rotation = 1;
  ulong4 C = (ulong4)(0, 0, 0, 0);
  ulong4 D = (ulong4)(0, 0, 0, 0);
  ulong4 tmpC = CD >> 28;
  ulong4 tmpD = CD & 0xFFFFFFF;
  C = tmpC >> (28 - rotation);
  C = (C | (tmpC << rotation)) & 0xFFFFFFF;
  D = tmpD >> (28 - rotation);
  D = (D | (tmpD << rotation)) & 0xFFFFFFF;
  CD = (C << 28) | D;
  return CD;
}

uint4 manglerFunction(ulong4 key, uint4 R) {
  uint4 output = (uint4)(0, 0, 0, 0);
  uint4 mask = (uint4)(0x3F, 0x3f, 0x3f, 0x3f);
  uint4 block_r;
  uint4 block_k;
  for (int i = 0; i < 8; i++) {
    if (i == 0) {
      block_r = ((R & 0x1F) << 1);
    } else {
      block_r = (R & (mask << ((i * 4) - 1))) >> ((i * 4) - 1);
    }
    if (i == 0) {
      block_r = block_r | ((R & 0x80000000) >> 31);
    }
    if (i == 7) {
      block_r = block_r | ((R & 1) << 5);
    }
    block_k = convert_uint4((((ulong4)(0x3F, 0x3f, 0x3f, 0x3f) << (i * 6)) & key) >> (i * 6));
    uint4 block = block_r ^ block_k;
    output |= ((doSBoxSub(7 - i, block)) << (i * 4));
  }
  uint4 perm = convert_uint4(doPermute(convert_ulong4(output), rp, rp_i, rp_o));
  return perm;
}

ulong4 expandParity(ulong4 key) {
  ulong4 output = (ulong4)(0, 0, 0, 0);
  uint4 mask = (uint4)(0x7FFF, 0x7FFF, 0x7FFF, 0x7FFF);
  for (int i = 0; i < 8; i++) {
    output |= (key & (0x7F << i * 7)) << ((i * 8) - (i * 7));
  }
  return output;
}

ulong4 computeEncryptionRound(int round_num, ulong4 input, ulong4 key) {
  uint4 R = convert_uint4(input);
  uint4 L = convert_uint4(input >> 32);
  ulong4 output = convert_ulong4(R) << 32;
  uint4 mangle = manglerFunction(key, R);
  output = output | convert_ulong4(mangle ^ L);
  return output;
}

ulong4 computeDecryptionRound(int round_num, ulong4 input, ulong4 key) {
  uint4 R = convert_uint4(input);
  uint4 L = convert_uint4(input >> 32);
  ulong4 output = convert_ulong4(L);
  output |= convert_ulong4(manglerFunction(key, L) ^ R) << 32;
  return output;
}

ulong4 DESEncrypt(ulong4 input, ulong4 key) {
  input = initialPermutation(input);
  ulong4 keys[16];
  ulong4 CD = generateCD(key);
  for (int i = 0; i < 16; i++) {
    CD = rotateCD(i, CD);
    keys[hook(10, i)] = generatePerRoundKey(CD);
  }
  for (int round_num = 0; round_num < 16; round_num++) {
    input = computeEncryptionRound(round_num, input, keys[hook(10, round_num)]);
  }

  input = (input >> 32) | (input << 32);
  ulong4 output = finalPermutation(input);
  return output;
}

ulong4 DESDecrypt(ulong4 input, ulong4 key) {
  input = initialPermutation(input);
  input = (input >> 32) | (input << 32);
  ulong4 keys[16];
  ulong4 CD = generateCD(key);
  for (int i = 0; i < 16; i++) {
    CD = rotateCD(i, CD);
    keys[hook(10, i)] = generatePerRoundKey(CD);
  }
  for (int round_num = 15; round_num >= 0; round_num--) {
    input = computeDecryptionRound(round_num, input, keys[hook(10, round_num)]);
  }
  return finalPermutation(input);
}

kernel void des_decrypt_kern(ulong key_start, ulong data, global ulong4* output) {
  int gti = get_global_id(0);
  int ti = get_local_id(0);

  int n = get_global_size(0);
  int nt = get_local_size(0);
  ulong c_key = key_start + gti * 4;
  output[hook(2, gti)] = DESDecrypt((ulong4)(data, data, data, data), (ulong4)(c_key, c_key + 1, c_key + 2, c_key + 3));
}