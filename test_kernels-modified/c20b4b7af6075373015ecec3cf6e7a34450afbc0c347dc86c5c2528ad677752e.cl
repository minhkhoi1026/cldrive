//{"SHAvite3_512_IV":12,"SHAvite3_512_IV[init]":11,"SHAvite3_512_precomputedPadding":14,"aes_round_luts":2,"hashOut":1,"hashing":10,"input":0,"lut0":4,"lut1":5,"lut2":6,"lut3":7,"p":13,"rk":9,"roundCount":3,"vals":8}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
uint4 AESR(uint4 val, uint4 k, local unsigned int* lut0, local unsigned int* lut1, local unsigned int* lut2, local unsigned int* lut3) {
  uint4 result;
  result.s0 = lut0[hook(4, val.s0 & 255)] ^ (lut1 != 0 ? lut1[hook(5, (val.s1 >> (8 * 1)) & 255)] : rotate(lut0[hook(4, (val.s1 >> (8 * 1)) & 255)], (8u * 1u))) ^ (lut2 != 0 ? lut2[hook(6, (val.s2 >> (8 * 2)) & 255)] : rotate(lut0[hook(4, (val.s2 >> (8 * 2)) & 255)], (8u * 2u))) ^ (lut3 != 0 ? lut3[hook(7, (val.s3 >> (8 * 3)) & 255)] : rotate(lut0[hook(4, (val.s3 >> (8 * 3)) & 255)], (8u * 3u))) ^ k.s0;
  result.s1 = lut0[hook(4, val.s1 & 255)] ^ (lut1 != 0 ? lut1[hook(5, (val.s2 >> (8 * 1)) & 255)] : rotate(lut0[hook(4, (val.s2 >> (8 * 1)) & 255)], (8u * 1u))) ^ (lut2 != 0 ? lut2[hook(6, (val.s3 >> (8 * 2)) & 255)] : rotate(lut0[hook(4, (val.s3 >> (8 * 2)) & 255)], (8u * 2u))) ^ (lut3 != 0 ? lut3[hook(7, (val.s0 >> (8 * 3)) & 255)] : rotate(lut0[hook(4, (val.s0 >> (8 * 3)) & 255)], (8u * 3u))) ^ k.s1;
  result.s2 = lut0[hook(4, val.s2 & 255)] ^ (lut1 != 0 ? lut1[hook(5, (val.s3 >> (8 * 1)) & 255)] : rotate(lut0[hook(4, (val.s3 >> (8 * 1)) & 255)], (8u * 1u))) ^ (lut2 != 0 ? lut2[hook(6, (val.s0 >> (8 * 2)) & 255)] : rotate(lut0[hook(4, (val.s0 >> (8 * 2)) & 255)], (8u * 2u))) ^ (lut3 != 0 ? lut3[hook(7, (val.s1 >> (8 * 3)) & 255)] : rotate(lut0[hook(4, (val.s1 >> (8 * 3)) & 255)], (8u * 3u))) ^ k.s2;
  result.s3 = lut0[hook(4, val.s3 & 255)] ^ (lut1 != 0 ? lut1[hook(5, (val.s0 >> (8 * 1)) & 255)] : rotate(lut0[hook(4, (val.s0 >> (8 * 1)) & 255)], (8u * 1u))) ^ (lut2 != 0 ? lut2[hook(6, (val.s1 >> (8 * 2)) & 255)] : rotate(lut0[hook(4, (val.s1 >> (8 * 2)) & 255)], (8u * 2u))) ^ (lut3 != 0 ? lut3[hook(7, (val.s2 >> (8 * 3)) & 255)] : rotate(lut0[hook(4, (val.s2 >> (8 * 3)) & 255)], (8u * 3u))) ^ k.s3;

  return result;
}

uint4 AESRNK(uint4 val, local unsigned int* lut0, local unsigned int* lut1, local unsigned int* lut2, local unsigned int* lut3) {
  return AESR(val, (uint4)(0, 0, 0, 0), lut0, lut1, lut2, lut3);
}

constant unsigned int SHAvite3_512_IV[4][4] = {{0x72FCCDD8u, 0x79CA4727u, 0x128A077Bu, 0x40D55AECu}, {0xD1901A06u, 0x430AE307u, 0xB29F5CD1u, 0xDF07FBFCu}, {0x8E45D73Du, 0x681AB538u, 0xBDE86578u, 0xDD577E47u}, {0xE275EADEu, 0x502D9FCDu, 0xB9357178u, 0x022A4B9Au}};

constant uint4 SHAvite3_512_precomputedPadding[4] = {(uint4)(0x00000080, 0x00000000, 0x00000000, 0x00000000), (uint4)(0x00000000, 0x00000000, 0x00000000, 0x00000000), (uint4)(0x00000000, 0x00000000, 0x00000000, 0x02000000), (uint4)(0x00000000, 0x00000000, 0x00000000, 0x02000000)};

uint4 OffOne(uint4* vals, unsigned int start) {
  unsigned int meh = start + 1;
  meh %= 8;
  meh = vals[hook(8, meh)].x;
  return (uint4)(vals[hook(8, start)].y, vals[hook(8, start)].z, vals[hook(8, start)].w, meh);
}

__attribute__((reqd_work_group_size(64, 1, 1))) kernel void SHAvite3_1way(global unsigned int* input, global unsigned int* hashOut, global unsigned int* aes_round_luts, const unsigned int roundCount) {
  input += (get_global_id(0) - get_global_offset(0)) * 16;

  hashOut += (get_global_id(0) - get_global_offset(0)) * 16;

  local unsigned int TBL0[256], TBL1[256], TBL2[256], TBL3[256];

  event_t ldsReady = async_work_group_copy(TBL0, aes_round_luts + 256 * 0, 256, 0);
  async_work_group_copy(TBL1, aes_round_luts + 256 * 1, 256, ldsReady);
  async_work_group_copy(TBL2, aes_round_luts + 256 * 2, 256, ldsReady);
  async_work_group_copy(TBL3, aes_round_luts + 256 * 3, 256, ldsReady);

  uint4 rk[4 + 4], hashing[4], p[4];
  for (unsigned int init = 0; init < 4; init++) {
    rk[hook(9, 0 + init)].s0 = input[hook(0, init * 4 + 0)];
    rk[hook(9, 0 + init)].s1 = input[hook(0, init * 4 + 1)];
    rk[hook(9, 0 + init)].s2 = input[hook(0, init * 4 + 2)];
    rk[hook(9, 0 + init)].s3 = input[hook(0, init * 4 + 3)];
    hashing[hook(10, init)].s0 = SHAvite3_512_IV[hook(12, init)][hook(11, 0)];
    hashing[hook(10, init)].s1 = SHAvite3_512_IV[hook(12, init)][hook(11, 1)];
    hashing[hook(10, init)].s2 = SHAvite3_512_IV[hook(12, init)][hook(11, 2)];
    hashing[hook(10, init)].s3 = SHAvite3_512_IV[hook(12, init)][hook(11, 3)];
    p[hook(13, init)] = hashing[hook(10, init)];

    rk[hook(9, 4 + init)] = SHAvite3_512_precomputedPadding[hook(14, init)];
  }
  wait_group_events(1, &ldsReady);
  {
    uint4 temp;
    temp = AESRNK(p[hook(13, 1)] ^ rk[hook(9, 0 + 0)], TBL0, TBL1, TBL2, TBL3);
    temp = AESRNK(temp ^ rk[hook(9, 0 + 1)], TBL0, TBL1, TBL2, TBL3);
    temp = AESRNK(temp ^ rk[hook(9, 0 + 2)], TBL0, TBL1, TBL2, TBL3);
    temp = AESRNK(temp ^ rk[hook(9, 0 + 3)], TBL0, TBL1, TBL2, TBL3);
    p[hook(13, 0)] ^= temp;
    temp = AESRNK(p[hook(13, 3)] ^ rk[hook(9, 4 + 0)], TBL0, TBL1, TBL2, TBL3);
    temp = AESRNK(temp ^ rk[hook(9, 4 + 1)], TBL0, TBL1, TBL2, TBL3);
    temp = AESRNK(temp ^ rk[hook(9, 4 + 2)], TBL0, TBL1, TBL2, TBL3);
    temp = AESRNK(temp ^ rk[hook(9, 4 + 3)], TBL0, TBL1, TBL2, TBL3);
    p[hook(13, 2)] ^= temp;
  }
  uint4 counter = 0;

  counter.x = 16 * 4 * 8;

  for (unsigned int round = 1; round < roundCount - 1;) {
    uint4 temp;

    rk[hook(9, 0 + 0)] = AESRNK(rk[hook(9, 0 + 0)], TBL0, TBL1, TBL2, TBL3).yzwx ^ rk[hook(9, 4 + 3)];
    if (round == 1)
      rk[hook(9, 0 + 0)] ^= (uint4)(counter.s0, counter.s1, counter.s2, ~counter.s3);
    temp = AESRNK(p[hook(13, 0)] ^ rk[hook(9, 0 + 0)], TBL0, TBL1, TBL2, TBL3);
    rk[hook(9, 0 + 1)] = AESRNK(rk[hook(9, 0 + 1)], TBL0, TBL1, TBL2, TBL3).yzwx ^ rk[hook(9, 0 + 0)];
    if (round == 5)
      rk[hook(9, 0 + 1)] ^= (uint4)(counter.s3, counter.s2, counter.s1, ~counter.s0);
    temp = AESRNK(temp ^ rk[hook(9, 0 + 1)], TBL0, TBL1, TBL2, TBL3);
    rk[hook(9, 0 + 2)] = AESRNK(rk[hook(9, 0 + 2)], TBL0, TBL1, TBL2, TBL3).yzwx ^ rk[hook(9, 0 + 1)];
    temp = AESRNK(temp ^ rk[hook(9, 0 + 2)], TBL0, TBL1, TBL2, TBL3);
    rk[hook(9, 0 + 3)] = AESRNK(rk[hook(9, 0 + 3)], TBL0, TBL1, TBL2, TBL3).yzwx ^ rk[hook(9, 0 + 2)];
    temp = AESRNK(temp ^ rk[hook(9, 0 + 3)], TBL0, TBL1, TBL2, TBL3);
    p[hook(13, 3)] ^= temp;
    rk[hook(9, 4 + 0)] = AESRNK(rk[hook(9, 4 + 0)], TBL0, TBL1, TBL2, TBL3).yzwx ^ rk[hook(9, 0 + 3)];
    temp = AESRNK(p[hook(13, 2)] ^ rk[hook(9, 4 + 0)], TBL0, TBL1, TBL2, TBL3);
    rk[hook(9, 4 + 1)] = AESRNK(rk[hook(9, 4 + 1)], TBL0, TBL1, TBL2, TBL3).yzwx ^ rk[hook(9, 4 + 0)];
    temp = AESRNK(temp ^ rk[hook(9, 4 + 1)], TBL0, TBL1, TBL2, TBL3);
    rk[hook(9, 4 + 2)] = AESRNK(rk[hook(9, 4 + 2)], TBL0, TBL1, TBL2, TBL3).yzwx ^ rk[hook(9, 4 + 1)];
    temp = AESRNK(temp ^ rk[hook(9, 4 + 2)], TBL0, TBL1, TBL2, TBL3);
    rk[hook(9, 4 + 3)] = AESRNK(rk[hook(9, 4 + 3)], TBL0, TBL1, TBL2, TBL3).yzwx ^ rk[hook(9, 4 + 2)];
    if (round == 9)
      rk[hook(9, 4 + 3)] ^= (uint4)(counter.s2, counter.s3, counter.s0, ~counter.s1);
    temp = AESRNK(temp ^ rk[hook(9, 4 + 3)], TBL0, TBL1, TBL2, TBL3);
    p[hook(13, 1)] ^= temp;
    round++;

    rk[hook(9, 0 + 0)] ^= OffOne(rk, 4 + 2);
    temp = AESRNK(p[hook(13, 3)] ^ rk[hook(9, 0 + 0)], TBL0, TBL1, TBL2, TBL3);
    rk[hook(9, 0 + 1)] ^= OffOne(rk, 4 + 3);
    temp = AESRNK(temp ^ rk[hook(9, 0 + 1)], TBL0, TBL1, TBL2, TBL3);
    rk[hook(9, 0 + 2)] ^= OffOne(rk, 0 + 0);
    temp = AESRNK(temp ^ rk[hook(9, 0 + 2)], TBL0, TBL1, TBL2, TBL3);
    rk[hook(9, 0 + 3)] ^= OffOne(rk, 0 + 1);
    temp = AESRNK(temp ^ rk[hook(9, 0 + 3)], TBL0, TBL1, TBL2, TBL3);
    p[hook(13, 2)] ^= temp;
    rk[hook(9, 4 + 0)] ^= OffOne(rk, 0 + 2);
    temp = AESRNK(p[hook(13, 1)] ^ rk[hook(9, 4 + 0)], TBL0, TBL1, TBL2, TBL3);
    rk[hook(9, 4 + 1)] ^= OffOne(rk, 0 + 3);
    temp = AESRNK(temp ^ rk[hook(9, 4 + 1)], TBL0, TBL1, TBL2, TBL3);
    rk[hook(9, 4 + 2)] ^= OffOne(rk, 4 + 0);
    temp = AESRNK(temp ^ rk[hook(9, 4 + 2)], TBL0, TBL1, TBL2, TBL3);
    rk[hook(9, 4 + 3)] ^= OffOne(rk, 4 + 1);
    temp = AESRNK(temp ^ rk[hook(9, 4 + 3)], TBL0, TBL1, TBL2, TBL3);
    p[hook(13, 0)] ^= temp;
    round++;

    rk[hook(9, 0 + 0)] = AESRNK(rk[hook(9, 0 + 0)], TBL0, TBL1, TBL2, TBL3).yzwx ^ rk[hook(9, 4 + 3)];
    temp = AESRNK(p[hook(13, 2)] ^ rk[hook(9, 0 + 0)], TBL0, TBL1, TBL2, TBL3);
    rk[hook(9, 0 + 1)] = AESRNK(rk[hook(9, 0 + 1)], TBL0, TBL1, TBL2, TBL3).yzwx ^ rk[hook(9, 0 + 0)];
    temp = AESRNK(temp ^ rk[hook(9, 0 + 1)], TBL0, TBL1, TBL2, TBL3);
    rk[hook(9, 0 + 2)] = AESRNK(rk[hook(9, 0 + 2)], TBL0, TBL1, TBL2, TBL3).yzwx ^ rk[hook(9, 0 + 1)];
    temp = AESRNK(temp ^ rk[hook(9, 0 + 2)], TBL0, TBL1, TBL2, TBL3);
    rk[hook(9, 0 + 3)] = AESRNK(rk[hook(9, 0 + 3)], TBL0, TBL1, TBL2, TBL3).yzwx ^ rk[hook(9, 0 + 2)];
    temp = AESRNK(temp ^ rk[hook(9, 0 + 3)], TBL0, TBL1, TBL2, TBL3);
    p[hook(13, 1)] ^= temp;
    rk[hook(9, 4 + 0)] = AESRNK(rk[hook(9, 4 + 0)], TBL0, TBL1, TBL2, TBL3).yzwx ^ rk[hook(9, 0 + 3)];
    temp = AESRNK(p[hook(13, 0)] ^ rk[hook(9, 4 + 0)], TBL0, TBL1, TBL2, TBL3);
    rk[hook(9, 4 + 1)] = AESRNK(rk[hook(9, 4 + 1)], TBL0, TBL1, TBL2, TBL3).yzwx ^ rk[hook(9, 4 + 0)];
    temp = AESRNK(temp ^ rk[hook(9, 4 + 1)], TBL0, TBL1, TBL2, TBL3);
    rk[hook(9, 4 + 2)] = AESRNK(rk[hook(9, 4 + 2)], TBL0, TBL1, TBL2, TBL3).yzwx ^ rk[hook(9, 4 + 1)];
    temp = AESRNK(temp ^ rk[hook(9, 4 + 2)], TBL0, TBL1, TBL2, TBL3);
    rk[hook(9, 4 + 3)] = AESRNK(rk[hook(9, 4 + 3)], TBL0, TBL1, TBL2, TBL3).yzwx ^ rk[hook(9, 4 + 2)];
    temp = AESRNK(temp ^ rk[hook(9, 4 + 3)], TBL0, TBL1, TBL2, TBL3);
    p[hook(13, 3)] ^= temp;
    round++;

    rk[hook(9, 0 + 0)] ^= OffOne(rk, 4 + 2);
    temp = AESRNK(p[hook(13, 1)] ^ rk[hook(9, 0 + 0)], TBL0, TBL1, TBL2, TBL3);
    rk[hook(9, 0 + 1)] ^= OffOne(rk, 4 + 3);
    temp = AESRNK(temp ^ rk[hook(9, 0 + 1)], TBL0, TBL1, TBL2, TBL3);
    rk[hook(9, 0 + 2)] ^= OffOne(rk, 0 + 0);
    temp = AESRNK(temp ^ rk[hook(9, 0 + 2)], TBL0, TBL1, TBL2, TBL3);
    rk[hook(9, 0 + 3)] ^= OffOne(rk, 0 + 1);
    temp = AESRNK(temp ^ rk[hook(9, 0 + 3)], TBL0, TBL1, TBL2, TBL3);
    p[hook(13, 0)] ^= temp;
    rk[hook(9, 4 + 0)] ^= OffOne(rk, 0 + 2);
    temp = AESRNK(p[hook(13, 3)] ^ rk[hook(9, 4 + 0)], TBL0, TBL1, TBL2, TBL3);
    rk[hook(9, 4 + 1)] ^= OffOne(rk, 0 + 3);
    temp = AESRNK(temp ^ rk[hook(9, 4 + 1)], TBL0, TBL1, TBL2, TBL3);
    rk[hook(9, 4 + 2)] ^= OffOne(rk, 4 + 0);
    temp = AESRNK(temp ^ rk[hook(9, 4 + 2)], TBL0, TBL1, TBL2, TBL3);
    rk[hook(9, 4 + 3)] ^= OffOne(rk, 4 + 1);
    temp = AESRNK(temp ^ rk[hook(9, 4 + 3)], TBL0, TBL1, TBL2, TBL3);
    p[hook(13, 2)] ^= temp;
    round++;
  }
  {
    uint4 temp;
    rk[hook(9, 0 + 0)] = AESRNK(rk[hook(9, 0 + 0)], TBL0, TBL1, TBL2, TBL3).yzwx ^ rk[hook(9, 4 + 3)];
    temp = AESRNK(p[hook(13, 0)] ^ rk[hook(9, 0 + 0)], TBL0, TBL1, TBL2, TBL3);
    rk[hook(9, 0 + 1)] = AESRNK(rk[hook(9, 0 + 1)], TBL0, TBL1, TBL2, TBL3).yzwx ^ rk[hook(9, 0 + 0)];
    temp = AESRNK(temp ^ rk[hook(9, 0 + 1)], TBL0, TBL1, TBL2, TBL3);
    rk[hook(9, 0 + 2)] = AESRNK(rk[hook(9, 0 + 2)], TBL0, TBL1, TBL2, TBL3).yzwx ^ rk[hook(9, 0 + 1)];
    temp = AESRNK(temp ^ rk[hook(9, 0 + 2)], TBL0, TBL1, TBL2, TBL3);
    rk[hook(9, 0 + 3)] = AESRNK(rk[hook(9, 0 + 3)], TBL0, TBL1, TBL2, TBL3).yzwx ^ rk[hook(9, 0 + 2)];
    temp = AESRNK(temp ^ rk[hook(9, 0 + 3)], TBL0, TBL1, TBL2, TBL3);
    p[hook(13, 3)] ^= temp;
    rk[hook(9, 4 + 0)] = AESRNK(rk[hook(9, 4 + 0)], TBL0, TBL1, TBL2, TBL3).yzwx ^ rk[hook(9, 0 + 3)];
    temp = AESRNK(p[hook(13, 2)] ^ rk[hook(9, 4 + 0)], TBL0, TBL1, TBL2, TBL3);
    rk[hook(9, 4 + 1)] = AESRNK(rk[hook(9, 4 + 1)], TBL0, TBL1, TBL2, TBL3).yzwx ^ rk[hook(9, 4 + 0)];
    temp = AESRNK(temp ^ rk[hook(9, 4 + 1)], TBL0, TBL1, TBL2, TBL3);
    rk[hook(9, 4 + 2)] = AESRNK(rk[hook(9, 4 + 2)], TBL0, TBL1, TBL2, TBL3).yzwx ^ rk[hook(9, 4 + 1)] ^ (uint4)(counter.s1, counter.s0, counter.s3, ~counter.s2);
    temp = AESRNK(temp ^ rk[hook(9, 4 + 2)], TBL0, TBL1, TBL2, TBL3);
    rk[hook(9, 4 + 3)] = AESRNK(rk[hook(9, 4 + 3)], TBL0, TBL1, TBL2, TBL3).yzwx ^ rk[hook(9, 4 + 2)];
    temp = AESRNK(temp ^ rk[hook(9, 4 + 3)], TBL0, TBL1, TBL2, TBL3);
    p[hook(13, 1)] ^= temp;
  }
  hashing[hook(10, 0)] ^= p[hook(13, 2)];
  hashing[hook(10, 1)] ^= p[hook(13, 3)];
  hashing[hook(10, 2)] ^= p[hook(13, 0)];
  hashing[hook(10, 3)] ^= p[hook(13, 1)];
  for (unsigned int i = 0; i < 4; i++) {
    hashOut[hook(1, i * 4 + 0)] = hashing[hook(10, i)].x;
    hashOut[hook(1, i * 4 + 1)] = hashing[hook(10, i)].y;
    hashOut[hook(1, i * 4 + 2)] = hashing[hook(10, i)].z;
    hashOut[hook(1, i * 4 + 3)] = hashing[hook(10, i)].w;
  }
}