//{"bitsliceKey":1,"buf":7,"dst":5,"input":0,"output":8,"src":6,"tmp0":2,"tmp1":3,"tmp2":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void shiftRows(local uint4* src, local uint4* dst, unsigned int localId) {
  unsigned int new_adrs = ((((localId >> 5) - (localId >> 3)) & 3) << 5) | (localId & 31);
  dst[hook(5, new_adrs)] = src[hook(6, localId)];
}

unsigned int shiftRows1(unsigned int localId) {
  return ((((localId >> 5) - (localId >> 3)) & 3) << 5) | (localId & 31);
}

unsigned int shiftRows2(unsigned int localId) {
  return ((((localId >> 5) + ((localId >> 3) & 3)) & 3) << 5) | (localId & 31);
}

uint4 mixColumns(local uint4* src, unsigned int localId) {
  unsigned int b = localId & 0x1F;
  unsigned int offset = localId & 0xE0;
  uint4 x = src[hook(6, shiftRows2(offset + ((b + 7) & 31)))] ^ src[hook(6, shiftRows2(offset + ((b + 8) & 31)))] ^ src[hook(6, shiftRows2(offset + ((b + 16) & 31)))] ^ src[hook(6, shiftRows2(offset + ((b + 24) & 31)))] ^ src[hook(6, shiftRows2(offset + ((b + 31) & 31)))];
  switch (b & 7) {
    case 0:
      x ^= src[hook(6, shiftRows2(offset + ((b + 15) & 31)))] ^ src[hook(6, shiftRows2(offset + ((b + 31) & 31)))];
      break;
    case 1:
      x ^= src[hook(6, shiftRows2(offset + ((b + 6) & 31)))] ^ src[hook(6, shiftRows2(offset + ((b + 14) & 31)))];
      break;
    case 3:
      x ^= src[hook(6, shiftRows2(offset + ((b + 4) & 31)))] ^ src[hook(6, shiftRows2(offset + ((b + 12) & 31)))];
      break;
    case 4:
      x ^= src[hook(6, shiftRows2(offset + ((b + 3) & 31)))] ^ src[hook(6, shiftRows2(offset + ((b + 11) & 31)))];
      break;
  }
  return x;
}

void subBytes(local uint4* src, local uint4* dst, unsigned int localId) {
  unsigned int bitpos = localId & 7;
  unsigned int baseId = localId & (~7);
  if (bitpos != 0)
    return;

  uint4 x0, x1, x2, x3, x4, x5, x6, x7;
  x0 = src[hook(6, baseId + 0)] ^ src[hook(6, baseId + 1)] ^ src[hook(6, baseId + 6)];
  x1 = src[hook(6, baseId + 1)] ^ src[hook(6, baseId + 4)] ^ src[hook(6, baseId + 6)];
  x2 = src[hook(6, baseId + 1)] ^ src[hook(6, baseId + 2)] ^ src[hook(6, baseId + 3)] ^ src[hook(6, baseId + 4)] ^ src[hook(6, baseId + 7)];
  x3 = src[hook(6, baseId + 1)] ^ src[hook(6, baseId + 2)] ^ src[hook(6, baseId + 6)] ^ src[hook(6, baseId + 7)];
  x4 = src[hook(6, baseId + 1)] ^ src[hook(6, baseId + 2)] ^ src[hook(6, baseId + 3)] ^ src[hook(6, baseId + 5)] ^ src[hook(6, baseId + 7)];
  x5 = src[hook(6, baseId + 2)] ^ src[hook(6, baseId + 3)] ^ src[hook(6, baseId + 5)] ^ src[hook(6, baseId + 7)];
  x6 = src[hook(6, baseId + 1)] ^ src[hook(6, baseId + 2)] ^ src[hook(6, baseId + 3)] ^ src[hook(6, baseId + 4)] ^ src[hook(6, baseId + 6)] ^ src[hook(6, baseId + 7)];
  x7 = src[hook(6, baseId + 5)] ^ src[hook(6, baseId + 7)];

  uint4 a0 = x0 ^ x4;
  uint4 a1 = x1 ^ x5;
  uint4 a2 = x2 ^ x6;
  uint4 a3 = x3 ^ x7;

  uint4 b0, b1, b2, b3;
  b0 = x4 ^ x5 ^ x7;
  b1 = x5 ^ x6;
  b2 = x6 ^ x7;
  b3 = b0 ^ b2;
  b0 = b2;
  b2 = b1 ^ x7 ^ b3;
  b1 = x7;

  {
    uint4 ht = a3 & x3;
    uint4 h0 = (a2 & x2) ^ ht;
    uint4 h1 = ht ^ (a2 & x3) ^ (a3 & x2);
    uint4 lt = a1 & x1;
    uint4 l0 = (a0 & x0) ^ lt;
    uint4 l1 = lt ^ (a0 & x1) ^ (a1 & x0);
    uint4 z0 = a0 ^ a2;
    uint4 z1 = a1 ^ a3;
    uint4 y0 = x0 ^ x2;
    uint4 y1 = x1 ^ x3;
    uint4 mt = z1 & y1;
    x2 = (z0 & y0) ^ mt ^ l0;
    x3 = mt ^ (z0 & y1) ^ (z1 & y0) ^ l1;
    x0 = h1 ^ l0;
    x1 = h0 ^ h1 ^ l1;
  }

  {
    uint4 t0 = b0 ^ x0;
    uint4 t1 = b1 ^ x1;
    uint4 t2 = b2 ^ x2;
    uint4 t3 = b3 ^ x3;
    uint4 and03 = t0 & t3;
    uint4 and12 = t1 & t2;
    uint4 and13 = t1 & t3;
    uint4 and23 = t2 & t3;
    uint4 and012 = t0 & and12;
    uint4 and013 = t0 & and13;
    uint4 and023 = t0 & and23;
    uint4 and123 = t1 & and23;
    uint4 xor12 = t1 ^ t2;
    uint4 xor_and123_and023 = and123 ^ and023;
    uint4 xor_and03_and12 = and03 ^ and12;
    b0 = t0 ^ xor12 ^ xor_and123_and023 ^ and13 ^ and013 ^ xor_and03_and12 ^ and012;
    b1 = xor12 ^ t3 ^ and123 ^ and013 ^ (t0 & t2);
    b2 = t2 ^ xor_and123_and023 ^ xor_and03_and12;
    b3 = t2 ^ t3 ^ and123 ^ and03;
  }

  {
    uint4 z0 = b0 ^ b2;
    uint4 z1 = b1 ^ b3;
    {
      uint4 ht = b3 & x7;
      uint4 h0 = (b2 & x6) ^ ht;
      uint4 h1 = ht ^ (b2 & x7) ^ (b3 & x6);
      uint4 lt = b1 & x5;
      uint4 l0 = (b0 & x4) ^ lt;
      uint4 l1 = lt ^ (b0 & x5) ^ (b1 & x4);
      uint4 y0 = x4 ^ x6;
      uint4 y1 = x5 ^ x7;
      uint4 mt = z1 & y1;
      x4 = h1 ^ l0;
      x5 = h0 ^ h1 ^ l1;
      x6 = (z0 & y0) ^ mt ^ l0;
      x7 = mt ^ (z0 & y1) ^ (z1 & y0) ^ l1;
    }

    {
      uint4 ht = b3 & a3;
      uint4 h0 = (b2 & a2) ^ ht;
      uint4 h1 = ht ^ (b2 & a3) ^ (b3 & a2);
      uint4 lt = b1 & a1;
      uint4 l0 = (b0 & a0) ^ lt;
      uint4 l1 = lt ^ (b0 & a1) ^ (b1 & a0);
      uint4 y0 = a0 ^ a2;
      uint4 y1 = a1 ^ a3;
      uint4 mt = z1 & y1;
      x0 = h1 ^ l0;
      x1 = h0 ^ h1 ^ l1;
      x2 = (z0 & y0) ^ mt ^ l0;
      x3 = mt ^ (z0 & y1) ^ (z1 & y0) ^ l1;
    }
  }

  a0 = x0 ^ x2 ^ x4 ^ x5 ^ x6;
  a1 = x4 ^ x5;
  a2 = x1 ^ x2 ^ x3 ^ x4 ^ x7;
  a3 = x1 ^ x2 ^ x3 ^ x4 ^ x5;
  b0 = x1 ^ x2 ^ x4 ^ x5 ^ x6;
  b1 = x1 ^ x5 ^ x6;
  b2 = x2 ^ x6;
  b3 = x1 ^ x5 ^ x6 ^ x7;

  dst[hook(5, baseId + 0)] = ~(a0 ^ b0 ^ b1 ^ b2 ^ b3);
  dst[hook(5, baseId + 1)] = ~(a0 ^ a1 ^ b1 ^ b2 ^ b3);
  dst[hook(5, baseId + 2)] = a0 ^ a1 ^ a2 ^ b2 ^ b3;
  dst[hook(5, baseId + 3)] = a0 ^ a1 ^ a2 ^ a3 ^ b3;
  dst[hook(5, baseId + 4)] = a0 ^ a1 ^ a2 ^ a3 ^ b0;
  dst[hook(5, baseId + 5)] = ~(a1 ^ a2 ^ a3 ^ b0 ^ b1);
  dst[hook(5, baseId + 6)] = ~(a2 ^ a3 ^ b0 ^ b1 ^ b2);
  dst[hook(5, baseId + 7)] = a3 ^ b0 ^ b1 ^ b2 ^ b3;
}

uint4 bitslice(local unsigned int* input, unsigned int localId) {
  unsigned int k = localId >> 5;
  unsigned int j = localId & 0x1F;
  unsigned int x0 = ((input[hook(0, k + 0)] >> j) & 1) | (((input[hook(0, k + 4)] >> j) & 1) << 1) | (((input[hook(0, k + 8)] >> j) & 1) << 2) | (((input[hook(0, k + 12)] >> j) & 1) << 3) | (((input[hook(0, k + 16)] >> j) & 1) << 4) | (((input[hook(0, k + 20)] >> j) & 1) << 5) | (((input[hook(0, k + 24)] >> j) & 1) << 6) | (((input[hook(0, k + 28)] >> j) & 1) << 7) | (((input[hook(0, k + 32)] >> j) & 1) << 8) | (((input[hook(0, k + 36)] >> j) & 1) << 9) | (((input[hook(0, k + 40)] >> j) & 1) << 10) | (((input[hook(0, k + 44)] >> j) & 1) << 11) | (((input[hook(0, k + 48)] >> j) & 1) << 12) | (((input[hook(0, k + 52)] >> j) & 1) << 13) | (((input[hook(0, k + 56)] >> j) & 1) << 14) | (((input[hook(0, k + 60)] >> j) & 1) << 15) | (((input[hook(0, k + 64)] >> j) & 1) << 16) | (((input[hook(0, k + 68)] >> j) & 1) << 17) | (((input[hook(0, k + 72)] >> j) & 1) << 18) | (((input[hook(0, k + 76)] >> j) & 1) << 19) | (((input[hook(0, k + 80)] >> j) & 1) << 20) | (((input[hook(0, k + 84)] >> j) & 1) << 21) | (((input[hook(0, k + 88)] >> j) & 1) << 22) | (((input[hook(0, k + 92)] >> j) & 1) << 23) | (((input[hook(0, k + 96)] >> j) & 1) << 24) | (((input[hook(0, k + 100)] >> j) & 1) << 25) | (((input[hook(0, k + 104)] >> j) & 1) << 26) | (((input[hook(0, k + 108)] >> j) & 1) << 27) | (((input[hook(0, k + 112)] >> j) & 1) << 28) | (((input[hook(0, k + 116)] >> j) & 1) << 29) | (((input[hook(0, k + 120)] >> j) & 1) << 30) | (((input[hook(0, k + 124)] >> j) & 1) << 31);
  unsigned int x1 = ((input[hook(0, k + 128)] >> j) & 1) | (((input[hook(0, k + 132)] >> j) & 1) << 1) | (((input[hook(0, k + 136)] >> j) & 1) << 2) | (((input[hook(0, k + 140)] >> j) & 1) << 3) | (((input[hook(0, k + 144)] >> j) & 1) << 4) | (((input[hook(0, k + 148)] >> j) & 1) << 5) | (((input[hook(0, k + 152)] >> j) & 1) << 6) | (((input[hook(0, k + 156)] >> j) & 1) << 7) | (((input[hook(0, k + 160)] >> j) & 1) << 8) | (((input[hook(0, k + 164)] >> j) & 1) << 9) | (((input[hook(0, k + 168)] >> j) & 1) << 10) | (((input[hook(0, k + 172)] >> j) & 1) << 11) | (((input[hook(0, k + 176)] >> j) & 1) << 12) | (((input[hook(0, k + 180)] >> j) & 1) << 13) | (((input[hook(0, k + 184)] >> j) & 1) << 14) | (((input[hook(0, k + 188)] >> j) & 1) << 15) | (((input[hook(0, k + 192)] >> j) & 1) << 16) | (((input[hook(0, k + 196)] >> j) & 1) << 17) | (((input[hook(0, k + 200)] >> j) & 1) << 18) | (((input[hook(0, k + 204)] >> j) & 1) << 19) | (((input[hook(0, k + 208)] >> j) & 1) << 20) | (((input[hook(0, k + 212)] >> j) & 1) << 21) | (((input[hook(0, k + 216)] >> j) & 1) << 22) | (((input[hook(0, k + 220)] >> j) & 1) << 23) | (((input[hook(0, k + 224)] >> j) & 1) << 24) | (((input[hook(0, k + 228)] >> j) & 1) << 25) | (((input[hook(0, k + 232)] >> j) & 1) << 26) | (((input[hook(0, k + 236)] >> j) & 1) << 27) | (((input[hook(0, k + 240)] >> j) & 1) << 28) | (((input[hook(0, k + 244)] >> j) & 1) << 29) | (((input[hook(0, k + 248)] >> j) & 1) << 30) | (((input[hook(0, k + 252)] >> j) & 1) << 31);
  unsigned int x2 = ((input[hook(0, k + 256)] >> j) & 1) | (((input[hook(0, k + 260)] >> j) & 1) << 1) | (((input[hook(0, k + 264)] >> j) & 1) << 2) | (((input[hook(0, k + 268)] >> j) & 1) << 3) | (((input[hook(0, k + 272)] >> j) & 1) << 4) | (((input[hook(0, k + 276)] >> j) & 1) << 5) | (((input[hook(0, k + 280)] >> j) & 1) << 6) | (((input[hook(0, k + 284)] >> j) & 1) << 7) | (((input[hook(0, k + 288)] >> j) & 1) << 8) | (((input[hook(0, k + 292)] >> j) & 1) << 9) | (((input[hook(0, k + 296)] >> j) & 1) << 10) | (((input[hook(0, k + 300)] >> j) & 1) << 11) | (((input[hook(0, k + 304)] >> j) & 1) << 12) | (((input[hook(0, k + 308)] >> j) & 1) << 13) | (((input[hook(0, k + 312)] >> j) & 1) << 14) | (((input[hook(0, k + 316)] >> j) & 1) << 15) | (((input[hook(0, k + 320)] >> j) & 1) << 16) | (((input[hook(0, k + 324)] >> j) & 1) << 17) | (((input[hook(0, k + 328)] >> j) & 1) << 18) | (((input[hook(0, k + 332)] >> j) & 1) << 19) | (((input[hook(0, k + 336)] >> j) & 1) << 20) | (((input[hook(0, k + 340)] >> j) & 1) << 21) | (((input[hook(0, k + 344)] >> j) & 1) << 22) | (((input[hook(0, k + 348)] >> j) & 1) << 23) | (((input[hook(0, k + 352)] >> j) & 1) << 24) | (((input[hook(0, k + 356)] >> j) & 1) << 25) | (((input[hook(0, k + 360)] >> j) & 1) << 26) | (((input[hook(0, k + 364)] >> j) & 1) << 27) | (((input[hook(0, k + 368)] >> j) & 1) << 28) | (((input[hook(0, k + 372)] >> j) & 1) << 29) | (((input[hook(0, k + 376)] >> j) & 1) << 30) | (((input[hook(0, k + 380)] >> j) & 1) << 31);
  unsigned int x3 = ((input[hook(0, k + 384)] >> j) & 1) | (((input[hook(0, k + 388)] >> j) & 1) << 1) | (((input[hook(0, k + 392)] >> j) & 1) << 2) | (((input[hook(0, k + 396)] >> j) & 1) << 3) | (((input[hook(0, k + 400)] >> j) & 1) << 4) | (((input[hook(0, k + 404)] >> j) & 1) << 5) | (((input[hook(0, k + 408)] >> j) & 1) << 6) | (((input[hook(0, k + 412)] >> j) & 1) << 7) | (((input[hook(0, k + 416)] >> j) & 1) << 8) | (((input[hook(0, k + 420)] >> j) & 1) << 9) | (((input[hook(0, k + 424)] >> j) & 1) << 10) | (((input[hook(0, k + 428)] >> j) & 1) << 11) | (((input[hook(0, k + 432)] >> j) & 1) << 12) | (((input[hook(0, k + 436)] >> j) & 1) << 13) | (((input[hook(0, k + 440)] >> j) & 1) << 14) | (((input[hook(0, k + 444)] >> j) & 1) << 15) | (((input[hook(0, k + 448)] >> j) & 1) << 16) | (((input[hook(0, k + 452)] >> j) & 1) << 17) | (((input[hook(0, k + 456)] >> j) & 1) << 18) | (((input[hook(0, k + 460)] >> j) & 1) << 19) | (((input[hook(0, k + 464)] >> j) & 1) << 20) | (((input[hook(0, k + 468)] >> j) & 1) << 21) | (((input[hook(0, k + 472)] >> j) & 1) << 22) | (((input[hook(0, k + 476)] >> j) & 1) << 23) | (((input[hook(0, k + 480)] >> j) & 1) << 24) | (((input[hook(0, k + 484)] >> j) & 1) << 25) | (((input[hook(0, k + 488)] >> j) & 1) << 26) | (((input[hook(0, k + 492)] >> j) & 1) << 27) | (((input[hook(0, k + 496)] >> j) & 1) << 28) | (((input[hook(0, k + 500)] >> j) & 1) << 29) | (((input[hook(0, k + 504)] >> j) & 1) << 30) | (((input[hook(0, k + 508)] >> j) & 1) << 31);
  return (uint4)(x0, x1, x2, x3);
}

void unbitslice(local uint4* buf, global unsigned int* output, unsigned int offset, unsigned int localId) {
  unsigned int k = localId >> 5;
  unsigned int j = localId & 0x1F;
  unsigned int x0 = 0, x1 = 0, x2 = 0, x3 = 0;
  switch (k) {
    case 0:
      for (int i = 0; i < 32; i++)
        x0 |= ((buf[hook(7, i)].s0 >> j) & 1) << i;
      for (int i = 0; i < 32; i++)
        x1 |= ((buf[hook(7, i + 32)].s0 >> j) & 1) << i;
      for (int i = 0; i < 32; i++)
        x2 |= ((buf[hook(7, i + 64)].s0 >> j) & 1) << i;
      for (int i = 0; i < 32; i++)
        x3 |= ((buf[hook(7, i + 96)].s0 >> j) & 1) << i;
      break;
    case 1:
      for (int i = 0; i < 32; i++)
        x0 |= ((buf[hook(7, i)].s1 >> j) & 1) << i;
      for (int i = 0; i < 32; i++)
        x1 |= ((buf[hook(7, i + 32)].s1 >> j) & 1) << i;
      for (int i = 0; i < 32; i++)
        x2 |= ((buf[hook(7, i + 64)].s1 >> j) & 1) << i;
      for (int i = 0; i < 32; i++)
        x3 |= ((buf[hook(7, i + 96)].s1 >> j) & 1) << i;
      break;
    case 2:
      for (int i = 0; i < 32; i++)
        x0 |= ((buf[hook(7, i)].s2 >> j) & 1) << i;
      for (int i = 0; i < 32; i++)
        x1 |= ((buf[hook(7, i + 32)].s2 >> j) & 1) << i;
      for (int i = 0; i < 32; i++)
        x2 |= ((buf[hook(7, i + 64)].s2 >> j) & 1) << i;
      for (int i = 0; i < 32; i++)
        x3 |= ((buf[hook(7, i + 96)].s2 >> j) & 1) << i;
      break;
    case 3:
      for (int i = 0; i < 32; i++)
        x0 |= ((buf[hook(7, i)].s3 >> j) & 1) << i;
      for (int i = 0; i < 32; i++)
        x1 |= ((buf[hook(7, i + 32)].s3 >> j) & 1) << i;
      for (int i = 0; i < 32; i++)
        x2 |= ((buf[hook(7, i + 64)].s3 >> j) & 1) << i;
      for (int i = 0; i < 32; i++)
        x3 |= ((buf[hook(7, i + 96)].s3 >> j) & 1) << i;
      break;
  }
  output[hook(8, (offset + localId) * 4)] = x0;
  output[hook(8, (offset + localId) * 4 + 1)] = x1;
  output[hook(8, (offset + localId) * 4 + 2)] = x2;
  output[hook(8, (offset + localId) * 4 + 3)] = x3;
}

kernel void encrypt(global unsigned int* input, const global unsigned int* bitsliceKey, local uint4* tmp0, local uint4* tmp1, local unsigned int* tmp2) {
  unsigned int groupId = get_group_id(0);
  unsigned int localId = get_local_id(0);
  unsigned int offset = groupId * 128;

  tmp2[hook(4, localId * 4 + 0)] = input[hook(0, (offset + localId) * 4 + 0)];
  tmp2[hook(4, localId * 4 + 1)] = input[hook(0, (offset + localId) * 4 + 1)];
  tmp2[hook(4, localId * 4 + 2)] = input[hook(0, (offset + localId) * 4 + 2)];
  tmp2[hook(4, localId * 4 + 3)] = input[hook(0, (offset + localId) * 4 + 3)];
  barrier(0x01);
  tmp0[hook(2, localId)] = bitslice(tmp2, localId) ^ bitsliceKey[hook(1, localId)];
  barrier(0x01);

  for (unsigned int i = 1; i < 10; i++) {
    subBytes(tmp0, tmp1, localId);
    barrier(0x01);
    tmp0[hook(2, localId)] = mixColumns(tmp1, localId) ^ bitsliceKey[hook(1, i * 128 + localId)];
    barrier(0x01);
  }
  subBytes(tmp0, tmp1, localId);
  barrier(0x01);
  unsigned int newId = shiftRows1(localId);
  tmp0[hook(2, newId)] = tmp1[hook(3, localId)] ^ bitsliceKey[hook(1, 10 * 128 + newId)];
  barrier(0x01);
  unbitslice(tmp0, input, offset, localId);
}