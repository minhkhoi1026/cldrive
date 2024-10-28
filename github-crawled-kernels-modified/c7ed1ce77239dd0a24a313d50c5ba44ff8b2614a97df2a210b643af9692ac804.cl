//{"buffV":0,"dancers":6,"dst":3,"shuffled":7,"simd_shuffle":11,"src":4,"temp":14,"valB":1,"valX":12,"valin":9,"valout":10,"x":5,"xval":8,"yWork":13,"yescrypt_N":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void Salsa20_simd_shuffle_1W(unsigned int* dst, unsigned int* src) {
  for (unsigned int cp = 0; cp < 4; cp++)
    dst[hook(3, 0 + cp)] = src[hook(4, cp * 5)];
  for (unsigned int cp = 0; cp < 3; cp++)
    dst[hook(3, 4 + cp)] = src[hook(4, (cp + 1) * 5 - 1)];
  for (unsigned int cp = 0; cp < 3; cp++)
    dst[hook(3, 7 + cp)] = src[hook(4, (cp + 1) * 5 - 2)];
  for (unsigned int cp = 0; cp < 3; cp++)
    dst[hook(3, 10 + cp)] = src[hook(4, (cp + 1) * 5 - 3)];
  for (unsigned int cp = 0; cp < 3; cp++)
    dst[hook(3, 13 + cp)] = src[hook(4, (cp + 1) * 5 - 4)];
}

void Salsa20_simd_unshuffle_1W(unsigned int* dst, unsigned int* src) {
  for (unsigned int cp = 0; cp < 4; cp++)
    dst[hook(3, cp * 4)] = src[hook(4, cp * 4)];
  for (unsigned int cp = 0; cp < 4; cp++)
    dst[hook(3, cp * 4 + 1)] = src[hook(4, (cp * 4 + 1 + 12) % 16)];
  for (unsigned int cp = 0; cp < 4; cp++)
    dst[hook(3, cp * 4 + 2)] = src[hook(4, (cp * 4 + 2 + 8) % 16)];
  for (unsigned int cp = 0; cp < 4; cp++)
    dst[hook(3, cp * 4 + 3)] = src[hook(4, (cp * 4 + 3 + 4) % 16)];
}

unsigned int rotl(unsigned int bits, unsigned int amount) {
  return (bits << amount) | (bits >> (32 - amount));
}

void Salsa20_8_1W(unsigned int* dancers) {
  unsigned int x[16];
  Salsa20_simd_unshuffle_1W(x, dancers);
  for (unsigned int i = 0; i < 8; i += 2) {
    x[hook(5, 4)] ^= rotl(x[hook(5, 0)] + x[hook(5, 12)], 7);
    x[hook(5, 8)] ^= rotl(x[hook(5, 4)] + x[hook(5, 0)], 9);
    x[hook(5, 12)] ^= rotl(x[hook(5, 8)] + x[hook(5, 4)], 13);
    x[hook(5, 0)] ^= rotl(x[hook(5, 12)] + x[hook(5, 8)], 18);

    x[hook(5, 9)] ^= rotl(x[hook(5, 5)] + x[hook(5, 1)], 7);
    x[hook(5, 13)] ^= rotl(x[hook(5, 9)] + x[hook(5, 5)], 9);
    x[hook(5, 1)] ^= rotl(x[hook(5, 13)] + x[hook(5, 9)], 13);
    x[hook(5, 5)] ^= rotl(x[hook(5, 1)] + x[hook(5, 13)], 18);

    x[hook(5, 14)] ^= rotl(x[hook(5, 10)] + x[hook(5, 6)], 7);
    x[hook(5, 2)] ^= rotl(x[hook(5, 14)] + x[hook(5, 10)], 9);
    x[hook(5, 6)] ^= rotl(x[hook(5, 2)] + x[hook(5, 14)], 13);
    x[hook(5, 10)] ^= rotl(x[hook(5, 6)] + x[hook(5, 2)], 18);

    x[hook(5, 3)] ^= rotl(x[hook(5, 15)] + x[hook(5, 11)], 7);
    x[hook(5, 7)] ^= rotl(x[hook(5, 3)] + x[hook(5, 15)], 9);
    x[hook(5, 11)] ^= rotl(x[hook(5, 7)] + x[hook(5, 3)], 13);
    x[hook(5, 15)] ^= rotl(x[hook(5, 11)] + x[hook(5, 7)], 18);

    x[hook(5, 1)] ^= rotl(x[hook(5, 0)] + x[hook(5, 3)], 7);
    x[hook(5, 2)] ^= rotl(x[hook(5, 1)] + x[hook(5, 0)], 9);
    x[hook(5, 3)] ^= rotl(x[hook(5, 2)] + x[hook(5, 1)], 13);
    x[hook(5, 0)] ^= rotl(x[hook(5, 3)] + x[hook(5, 2)], 18);

    x[hook(5, 6)] ^= rotl(x[hook(5, 5)] + x[hook(5, 4)], 7);
    x[hook(5, 7)] ^= rotl(x[hook(5, 6)] + x[hook(5, 5)], 9);
    x[hook(5, 4)] ^= rotl(x[hook(5, 7)] + x[hook(5, 6)], 13);
    x[hook(5, 5)] ^= rotl(x[hook(5, 4)] + x[hook(5, 7)], 18);

    x[hook(5, 11)] ^= rotl(x[hook(5, 10)] + x[hook(5, 9)], 7);
    x[hook(5, 8)] ^= rotl(x[hook(5, 11)] + x[hook(5, 10)], 9);
    x[hook(5, 9)] ^= rotl(x[hook(5, 8)] + x[hook(5, 11)], 13);
    x[hook(5, 10)] ^= rotl(x[hook(5, 9)] + x[hook(5, 8)], 18);

    x[hook(5, 12)] ^= rotl(x[hook(5, 15)] + x[hook(5, 14)], 7);
    x[hook(5, 13)] ^= rotl(x[hook(5, 12)] + x[hook(5, 15)], 9);
    x[hook(5, 14)] ^= rotl(x[hook(5, 13)] + x[hook(5, 12)], 13);
    x[hook(5, 15)] ^= rotl(x[hook(5, 14)] + x[hook(5, 13)], 18);
  }
  unsigned int shuffled[16];
  Salsa20_simd_shuffle_1W(shuffled, x);
  for (unsigned int i = 0; i < 16; i++)
    dancers[hook(6, i)] += shuffled[hook(7, i)];
}

void BlockMix_Salsa8_1W(unsigned int* valout, unsigned int* valin) {
  unsigned int xval[16];
  for (unsigned int cp = 0; cp < 16; cp++)
    xval[hook(8, cp)] = valin[hook(9, 16 + cp)];
  for (unsigned int cp = 0; cp < 16; cp++)
    xval[hook(8, cp)] ^= valin[hook(9, cp)];
  Salsa20_8_1W(xval);
  for (unsigned int cp = 0; cp < 16; cp++)
    valout[hook(10, cp)] = xval[hook(8, cp)];
  for (unsigned int cp = 0; cp < 16; cp++)
    xval[hook(8, cp)] ^= valin[hook(9, cp + 16)];
  Salsa20_8_1W(xval);
  for (unsigned int cp = 0; cp < 16; cp++)
    valout[hook(10, cp + 16)] = xval[hook(8, cp)];
}

ulong Integerify(unsigned int* block, const unsigned int r) {
  unsigned int* x = block + (2 * r - 1) * 16;
  unsigned int hi = x[hook(5, 0)];
  unsigned int lo = x[hook(5, 13)];
  return ((ulong)lo << 32) | hi;
}

constant const uchar simd_shuffle[2 * 8] = {0, 13, 10, 7, 4, 1, 14, 11, 8, 5, 2, 15, 12, 9, 6, 3};
kernel void firstSmix1(global unsigned int* buffV, global unsigned int* valB, const unsigned int yescrypt_N) {
  const unsigned int yescrypt_r = 1;

  const unsigned int yescrypt_s = 16 * 2;

  const unsigned int slot = get_global_id(0) - get_global_offset(0);
  valB += slot * 256;
  buffV += slot * 2048;

  unsigned int valX[32];
  for (unsigned int loop = 0; loop < 2 * yescrypt_r; loop++) {
    global unsigned int* src = valB + loop * 16;
    unsigned int* dst = valX + loop * 16;
    for (unsigned int cp = 0; cp < 16; cp++)
      dst[hook(3, simd_shuffle[chook(11, cp))] = __builtin_astype((__builtin_astype((src[hook(4, cp)]), uchar4).wzyx), unsigned int);

    for (unsigned int cp = 0; cp < 16; cp++)
      buffV[hook(0, cp + loop * 16)] = dst[hook(3, cp)];
  }

  for (unsigned int loop = 0; loop < 16; loop++)
    valX[hook(12, loop)] ^= valX[hook(12, loop + 16)];
  Salsa20_8_1W(valX + 0);
  for (unsigned int loop = 0; loop < 16; loop++)
    buffV[hook(0, loop + 2 * 16)] = valX[hook(12, loop)];
  for (unsigned int loop = 0; loop < 16; loop++)
    valX[hook(12, loop)] ^= valX[hook(12, loop + 16)];
  Salsa20_8_1W(valX + 0);
  for (unsigned int loop = 0; loop < 16; loop++)
    buffV[hook(0, loop + 3 * 16)] = valX[hook(12, loop)];

  barrier(0x02);
  for (unsigned int loop = 0; loop < 16; loop++)
    valX[hook(12, loop)] ^= buffV[hook(0, loop + 16 * 2)];
  Salsa20_8_1W(valX);
  for (unsigned int loop = 0; loop < 16; loop++)
    valX[hook(12, loop + 16)] = valX[hook(12, loop)] ^ buffV[hook(0, loop + 16 * 3)];
  Salsa20_8_1W(valX + 16);

  for (unsigned int n = 1, loop = 2; loop < yescrypt_N; loop += 2) {
    for (unsigned int cp = 0; cp < yescrypt_s; cp++)
      buffV[hook(0, loop * yescrypt_s + cp)] = valX[hook(12, cp)];
    if (1) {
      unsigned int prev = loop - 1;
      n = n << (loop & prev ? 0 : 1);
      ulong j = Integerify(valX, yescrypt_r) & (n - 1);
      j += loop - n;

      barrier(0x02);
      for (unsigned int cp = 0; cp < yescrypt_s; cp++)
        valX[hook(12, cp)] ^= buffV[hook(0, j * yescrypt_s + cp)];
    }

    unsigned int yWork[32];
    BlockMix_Salsa8_1W(yWork, valX);
    for (unsigned int cp = 0; cp < yescrypt_s; cp++)
      buffV[hook(0, (loop + 1) * yescrypt_s + cp)] = yWork[hook(13, cp)];
    if (1) {
      ulong j = Integerify(yWork, yescrypt_r) & (n - 1);
      j += (loop + 1) - n;
      barrier(0x02);
      for (unsigned int cp = 0; cp < yescrypt_s; cp++)
        yWork[hook(13, cp)] ^= buffV[hook(0, j * yescrypt_s + cp)];
    }

    BlockMix_Salsa8_1W(valX, yWork);
  }

  for (unsigned int loop = 0; loop < 2; loop++) {
    unsigned int* src = valX + loop * 16;
    unsigned int temp[16];
    Salsa20_simd_unshuffle_1W(temp, src);
    for (unsigned int cp = 0; cp < 16; cp++)
      valB[hook(1, loop * 16 + cp)] = __builtin_astype((__builtin_astype((temp[hook(14, cp)]), uchar4).wzyx), unsigned int);
  }
}