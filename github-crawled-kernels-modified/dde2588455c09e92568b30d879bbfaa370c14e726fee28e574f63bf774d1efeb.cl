//{"b":12,"h":7,"hashStartOut":2,"headerIn":3,"hi":13,"m":4,"mc":5,"nonceOut":1,"nonceStart":0,"sigma":10,"sigma[i]":9,"u512":11,"v":6,"vBlake_iv":8}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant const uchar sigma[16][16] = {{0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15}, {14, 10, 4, 8, 9, 15, 13, 6, 1, 12, 0, 2, 11, 7, 5, 3}, {11, 8, 12, 0, 5, 2, 15, 13, 10, 14, 3, 6, 7, 1, 9, 4}, {7, 9, 3, 1, 13, 12, 11, 14, 2, 6, 5, 10, 4, 0, 15, 8}, {9, 0, 5, 7, 2, 4, 10, 15, 14, 1, 11, 12, 6, 8, 3, 13}, {2, 12, 6, 10, 0, 11, 8, 3, 4, 13, 7, 5, 15, 14, 1, 9},

                                      {12, 5, 1, 15, 14, 13, 4, 10, 0, 7, 6, 3, 9, 2, 8, 11}, {13, 11, 7, 14, 12, 1, 3, 9, 5, 0, 15, 4, 8, 6, 2, 10}, {6, 15, 14, 9, 11, 3, 0, 8, 12, 2, 13, 7, 1, 4, 10, 5}, {10, 2, 8, 4, 7, 6, 1, 5, 15, 11, 9, 14, 3, 12, 13, 0},

                                      {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15}, {14, 10, 4, 8, 9, 15, 13, 6, 1, 12, 0, 2, 11, 7, 5, 3}, {11, 8, 12, 0, 5, 2, 15, 13, 10, 14, 3, 6, 7, 1, 9, 4}, {7, 9, 3, 1, 13, 12, 11, 14, 2, 6, 5, 10, 4, 0, 15, 8}, {9, 0, 5, 7, 2, 4, 10, 15, 14, 1, 11, 12, 6, 8, 3, 13}, {2, 12, 6, 10, 0, 11, 8, 3, 4, 13, 7, 5, 15, 14, 1, 9}};

constant const unsigned long u512[16] = {0xA51B6A89D489E800UL, 0xD35B2E0E0B723800UL, 0xA47B39A2AE9F9000UL, 0x0C0EFA33E77E6488UL, 0x4F452FEC309911EBUL, 0x3CFCC66F74E1022CUL, 0x4606AD364DC879DDUL, 0xBBA055B53D47C800UL, 0x531655D90C59EB1BUL, 0xD1A00BA6DAE5B800UL, 0x2FE452DA9632463EUL, 0x98A7B5496226F800UL, 0xBAFCD004F92CA000UL, 0x64A39957839525E7UL, 0xD859E6F081AAE000UL, 0x63D980597B560E6BUL};

constant const unsigned long vBlake_iv[8] = {0x4BBF42C1F006AD9Dul, 0x5D11A8C3B5AEB12Eul, 0xA64AB78DC2774652ul, 0xC67595724658F253ul, 0xB8864E79CB891E56ul, 0x12ED593E29FB41A1ul, 0xB1DA3AB63C60BAA8ul, 0x6D20E50C1F954DEDul};

void vblake512_compress(unsigned long* h, unsigned long* mc) {
  unsigned long v[16];
  unsigned long m[16] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};

  for (int i = 0; i < 8; i++)
    m[hook(4, i)] = mc[hook(5, i)];

  for (int i = 0; i < 8; i++) {
    v[hook(6, i)] = h[hook(7, i)];
    v[hook(6, i + 8)] = vBlake_iv[hook(8, i)];
  }
  v[hook(6, 12)] ^= 64;
  v[hook(6, 14)] ^= (ulong)(0xfffffffffffffffful);

  for (int i = 0; i < 16; i++) {
    {
      v[hook(6, 0)] += v[hook(6, 4)] + (m[hook(4, sigma[ihook(10, i)[1hook(9, 1))] ^ u512[hook(11, sigma[ihook(10, i)[1hook(9, 1))]);
      v[hook(6, 12)] ^= v[hook(6, 0)];
      v[hook(6, 12)] = (((v[hook(6, 12)]) >> (60)) | ((v[hook(6, 12)]) << (64 - (60))));
      v[hook(6, 8)] += v[hook(6, 12)];
      v[hook(6, 4)] = (((v[hook(6, 4)] ^ v[hook(6, 8)]) >> (43)) | ((v[hook(6, 4)] ^ v[hook(6, 8)]) << (64 - (43))));
      v[hook(6, 0)] += v[hook(6, 4)] + (m[hook(4, sigma[ihook(10, i)[0hook(9, 0))] ^ u512[hook(11, sigma[ihook(10, i)[0hook(9, 0))]);
      v[hook(6, 12)] = (((v[hook(6, 12)] ^ v[hook(6, 0)]) >> (5)) | ((v[hook(6, 12)] ^ v[hook(6, 0)]) << (64 - (5))));
      v[hook(6, 8)] += v[hook(6, 12)];
      v[hook(6, 4)] = (((v[hook(6, 4)] ^ v[hook(6, 8)]) >> (18)) | ((v[hook(6, 4)] ^ v[hook(6, 8)]) << (64 - (18))));
      v[hook(6, 12)] ^= (~v[hook(6, 0)] & ~v[hook(6, 4)] & ~v[hook(6, 8)]) | (~v[hook(6, 0)] & v[hook(6, 4)] & v[hook(6, 8)]) | (v[hook(6, 0)] & ~v[hook(6, 4)] & v[hook(6, 8)]) | (v[hook(6, 0)] & v[hook(6, 4)] & ~v[hook(6, 8)]);
      v[hook(6, 12)] ^= (~v[hook(6, 0)] & ~v[hook(6, 4)] & v[hook(6, 8)]) | (~v[hook(6, 0)] & v[hook(6, 4)] & ~v[hook(6, 8)]) | (v[hook(6, 0)] & ~v[hook(6, 4)] & ~v[hook(6, 8)]) | (v[hook(6, 0)] & v[hook(6, 4)] & v[hook(6, 8)]);
    };

    {
      v[hook(6, 1)] += v[hook(6, 5)] + (m[hook(4, sigma[ihook(10, i)[3hook(9, 3))] ^ u512[hook(11, sigma[ihook(10, i)[3hook(9, 3))]);
      v[hook(6, 13)] ^= v[hook(6, 1)];
      v[hook(6, 13)] = (((v[hook(6, 13)]) >> (60)) | ((v[hook(6, 13)]) << (64 - (60))));
      v[hook(6, 9)] += v[hook(6, 13)];
      v[hook(6, 5)] = (((v[hook(6, 5)] ^ v[hook(6, 9)]) >> (43)) | ((v[hook(6, 5)] ^ v[hook(6, 9)]) << (64 - (43))));
      v[hook(6, 1)] += v[hook(6, 5)] + (m[hook(4, sigma[ihook(10, i)[2hook(9, 2))] ^ u512[hook(11, sigma[ihook(10, i)[2hook(9, 2))]);
      v[hook(6, 13)] = (((v[hook(6, 13)] ^ v[hook(6, 1)]) >> (5)) | ((v[hook(6, 13)] ^ v[hook(6, 1)]) << (64 - (5))));
      v[hook(6, 9)] += v[hook(6, 13)];
      v[hook(6, 5)] = (((v[hook(6, 5)] ^ v[hook(6, 9)]) >> (18)) | ((v[hook(6, 5)] ^ v[hook(6, 9)]) << (64 - (18))));
      v[hook(6, 13)] ^= (~v[hook(6, 1)] & ~v[hook(6, 5)] & ~v[hook(6, 9)]) | (~v[hook(6, 1)] & v[hook(6, 5)] & v[hook(6, 9)]) | (v[hook(6, 1)] & ~v[hook(6, 5)] & v[hook(6, 9)]) | (v[hook(6, 1)] & v[hook(6, 5)] & ~v[hook(6, 9)]);
      v[hook(6, 13)] ^= (~v[hook(6, 1)] & ~v[hook(6, 5)] & v[hook(6, 9)]) | (~v[hook(6, 1)] & v[hook(6, 5)] & ~v[hook(6, 9)]) | (v[hook(6, 1)] & ~v[hook(6, 5)] & ~v[hook(6, 9)]) | (v[hook(6, 1)] & v[hook(6, 5)] & v[hook(6, 9)]);
    };

    {
      v[hook(6, 2)] += v[hook(6, 6)] + (m[hook(4, sigma[ihook(10, i)[5hook(9, 5))] ^ u512[hook(11, sigma[ihook(10, i)[5hook(9, 5))]);
      v[hook(6, 14)] ^= v[hook(6, 2)];
      v[hook(6, 14)] = (((v[hook(6, 14)]) >> (60)) | ((v[hook(6, 14)]) << (64 - (60))));
      v[hook(6, 10)] += v[hook(6, 14)];
      v[hook(6, 6)] = (((v[hook(6, 6)] ^ v[hook(6, 10)]) >> (43)) | ((v[hook(6, 6)] ^ v[hook(6, 10)]) << (64 - (43))));
      v[hook(6, 2)] += v[hook(6, 6)] + (m[hook(4, sigma[ihook(10, i)[4hook(9, 4))] ^ u512[hook(11, sigma[ihook(10, i)[4hook(9, 4))]);
      v[hook(6, 14)] = (((v[hook(6, 14)] ^ v[hook(6, 2)]) >> (5)) | ((v[hook(6, 14)] ^ v[hook(6, 2)]) << (64 - (5))));
      v[hook(6, 10)] += v[hook(6, 14)];
      v[hook(6, 6)] = (((v[hook(6, 6)] ^ v[hook(6, 10)]) >> (18)) | ((v[hook(6, 6)] ^ v[hook(6, 10)]) << (64 - (18))));
      v[hook(6, 14)] ^= (~v[hook(6, 2)] & ~v[hook(6, 6)] & ~v[hook(6, 10)]) | (~v[hook(6, 2)] & v[hook(6, 6)] & v[hook(6, 10)]) | (v[hook(6, 2)] & ~v[hook(6, 6)] & v[hook(6, 10)]) | (v[hook(6, 2)] & v[hook(6, 6)] & ~v[hook(6, 10)]);
      v[hook(6, 14)] ^= (~v[hook(6, 2)] & ~v[hook(6, 6)] & v[hook(6, 10)]) | (~v[hook(6, 2)] & v[hook(6, 6)] & ~v[hook(6, 10)]) | (v[hook(6, 2)] & ~v[hook(6, 6)] & ~v[hook(6, 10)]) | (v[hook(6, 2)] & v[hook(6, 6)] & v[hook(6, 10)]);
    };

    {
      v[hook(6, 3)] += v[hook(6, 7)] + (m[hook(4, sigma[ihook(10, i)[7hook(9, 7))] ^ u512[hook(11, sigma[ihook(10, i)[7hook(9, 7))]);
      v[hook(6, 15)] ^= v[hook(6, 3)];
      v[hook(6, 15)] = (((v[hook(6, 15)]) >> (60)) | ((v[hook(6, 15)]) << (64 - (60))));
      v[hook(6, 11)] += v[hook(6, 15)];
      v[hook(6, 7)] = (((v[hook(6, 7)] ^ v[hook(6, 11)]) >> (43)) | ((v[hook(6, 7)] ^ v[hook(6, 11)]) << (64 - (43))));
      v[hook(6, 3)] += v[hook(6, 7)] + (m[hook(4, sigma[ihook(10, i)[6hook(9, 6))] ^ u512[hook(11, sigma[ihook(10, i)[6hook(9, 6))]);
      v[hook(6, 15)] = (((v[hook(6, 15)] ^ v[hook(6, 3)]) >> (5)) | ((v[hook(6, 15)] ^ v[hook(6, 3)]) << (64 - (5))));
      v[hook(6, 11)] += v[hook(6, 15)];
      v[hook(6, 7)] = (((v[hook(6, 7)] ^ v[hook(6, 11)]) >> (18)) | ((v[hook(6, 7)] ^ v[hook(6, 11)]) << (64 - (18))));
      v[hook(6, 15)] ^= (~v[hook(6, 3)] & ~v[hook(6, 7)] & ~v[hook(6, 11)]) | (~v[hook(6, 3)] & v[hook(6, 7)] & v[hook(6, 11)]) | (v[hook(6, 3)] & ~v[hook(6, 7)] & v[hook(6, 11)]) | (v[hook(6, 3)] & v[hook(6, 7)] & ~v[hook(6, 11)]);
      v[hook(6, 15)] ^= (~v[hook(6, 3)] & ~v[hook(6, 7)] & v[hook(6, 11)]) | (~v[hook(6, 3)] & v[hook(6, 7)] & ~v[hook(6, 11)]) | (v[hook(6, 3)] & ~v[hook(6, 7)] & ~v[hook(6, 11)]) | (v[hook(6, 3)] & v[hook(6, 7)] & v[hook(6, 11)]);
    };

    {
      v[hook(6, 0)] += v[hook(6, 5)] + (m[hook(4, sigma[ihook(10, i)[9hook(9, 9))] ^ u512[hook(11, sigma[ihook(10, i)[9hook(9, 9))]);
      v[hook(6, 15)] ^= v[hook(6, 0)];
      v[hook(6, 15)] = (((v[hook(6, 15)]) >> (60)) | ((v[hook(6, 15)]) << (64 - (60))));
      v[hook(6, 10)] += v[hook(6, 15)];
      v[hook(6, 5)] = (((v[hook(6, 5)] ^ v[hook(6, 10)]) >> (43)) | ((v[hook(6, 5)] ^ v[hook(6, 10)]) << (64 - (43))));
      v[hook(6, 0)] += v[hook(6, 5)] + (m[hook(4, sigma[ihook(10, i)[8hook(9, 8))] ^ u512[hook(11, sigma[ihook(10, i)[8hook(9, 8))]);
      v[hook(6, 15)] = (((v[hook(6, 15)] ^ v[hook(6, 0)]) >> (5)) | ((v[hook(6, 15)] ^ v[hook(6, 0)]) << (64 - (5))));
      v[hook(6, 10)] += v[hook(6, 15)];
      v[hook(6, 5)] = (((v[hook(6, 5)] ^ v[hook(6, 10)]) >> (18)) | ((v[hook(6, 5)] ^ v[hook(6, 10)]) << (64 - (18))));
      v[hook(6, 15)] ^= (~v[hook(6, 0)] & ~v[hook(6, 5)] & ~v[hook(6, 10)]) | (~v[hook(6, 0)] & v[hook(6, 5)] & v[hook(6, 10)]) | (v[hook(6, 0)] & ~v[hook(6, 5)] & v[hook(6, 10)]) | (v[hook(6, 0)] & v[hook(6, 5)] & ~v[hook(6, 10)]);
      v[hook(6, 15)] ^= (~v[hook(6, 0)] & ~v[hook(6, 5)] & v[hook(6, 10)]) | (~v[hook(6, 0)] & v[hook(6, 5)] & ~v[hook(6, 10)]) | (v[hook(6, 0)] & ~v[hook(6, 5)] & ~v[hook(6, 10)]) | (v[hook(6, 0)] & v[hook(6, 5)] & v[hook(6, 10)]);
    };

    {
      v[hook(6, 1)] += v[hook(6, 6)] + (m[hook(4, sigma[ihook(10, i)[1hook(9, 11))] ^ u512[hook(11, sigma[ihook(10, i)[1hook(9, 11))]);
      v[hook(6, 12)] ^= v[hook(6, 1)];
      v[hook(6, 12)] = (((v[hook(6, 12)]) >> (60)) | ((v[hook(6, 12)]) << (64 - (60))));
      v[hook(6, 11)] += v[hook(6, 12)];
      v[hook(6, 6)] = (((v[hook(6, 6)] ^ v[hook(6, 11)]) >> (43)) | ((v[hook(6, 6)] ^ v[hook(6, 11)]) << (64 - (43))));
      v[hook(6, 1)] += v[hook(6, 6)] + (m[hook(4, sigma[ihook(10, i)[1hook(9, 10))] ^ u512[hook(11, sigma[ihook(10, i)[1hook(9, 10))]);
      v[hook(6, 12)] = (((v[hook(6, 12)] ^ v[hook(6, 1)]) >> (5)) | ((v[hook(6, 12)] ^ v[hook(6, 1)]) << (64 - (5))));
      v[hook(6, 11)] += v[hook(6, 12)];
      v[hook(6, 6)] = (((v[hook(6, 6)] ^ v[hook(6, 11)]) >> (18)) | ((v[hook(6, 6)] ^ v[hook(6, 11)]) << (64 - (18))));
      v[hook(6, 12)] ^= (~v[hook(6, 1)] & ~v[hook(6, 6)] & ~v[hook(6, 11)]) | (~v[hook(6, 1)] & v[hook(6, 6)] & v[hook(6, 11)]) | (v[hook(6, 1)] & ~v[hook(6, 6)] & v[hook(6, 11)]) | (v[hook(6, 1)] & v[hook(6, 6)] & ~v[hook(6, 11)]);
      v[hook(6, 12)] ^= (~v[hook(6, 1)] & ~v[hook(6, 6)] & v[hook(6, 11)]) | (~v[hook(6, 1)] & v[hook(6, 6)] & ~v[hook(6, 11)]) | (v[hook(6, 1)] & ~v[hook(6, 6)] & ~v[hook(6, 11)]) | (v[hook(6, 1)] & v[hook(6, 6)] & v[hook(6, 11)]);
    };

    {
      v[hook(6, 2)] += v[hook(6, 7)] + (m[hook(4, sigma[ihook(10, i)[1hook(9, 13))] ^ u512[hook(11, sigma[ihook(10, i)[1hook(9, 13))]);
      v[hook(6, 13)] ^= v[hook(6, 2)];
      v[hook(6, 13)] = (((v[hook(6, 13)]) >> (60)) | ((v[hook(6, 13)]) << (64 - (60))));
      v[hook(6, 8)] += v[hook(6, 13)];
      v[hook(6, 7)] = (((v[hook(6, 7)] ^ v[hook(6, 8)]) >> (43)) | ((v[hook(6, 7)] ^ v[hook(6, 8)]) << (64 - (43))));
      v[hook(6, 2)] += v[hook(6, 7)] + (m[hook(4, sigma[ihook(10, i)[1hook(9, 12))] ^ u512[hook(11, sigma[ihook(10, i)[1hook(9, 12))]);
      v[hook(6, 13)] = (((v[hook(6, 13)] ^ v[hook(6, 2)]) >> (5)) | ((v[hook(6, 13)] ^ v[hook(6, 2)]) << (64 - (5))));
      v[hook(6, 8)] += v[hook(6, 13)];
      v[hook(6, 7)] = (((v[hook(6, 7)] ^ v[hook(6, 8)]) >> (18)) | ((v[hook(6, 7)] ^ v[hook(6, 8)]) << (64 - (18))));
      v[hook(6, 13)] ^= (~v[hook(6, 2)] & ~v[hook(6, 7)] & ~v[hook(6, 8)]) | (~v[hook(6, 2)] & v[hook(6, 7)] & v[hook(6, 8)]) | (v[hook(6, 2)] & ~v[hook(6, 7)] & v[hook(6, 8)]) | (v[hook(6, 2)] & v[hook(6, 7)] & ~v[hook(6, 8)]);
      v[hook(6, 13)] ^= (~v[hook(6, 2)] & ~v[hook(6, 7)] & v[hook(6, 8)]) | (~v[hook(6, 2)] & v[hook(6, 7)] & ~v[hook(6, 8)]) | (v[hook(6, 2)] & ~v[hook(6, 7)] & ~v[hook(6, 8)]) | (v[hook(6, 2)] & v[hook(6, 7)] & v[hook(6, 8)]);
    };

    {
      v[hook(6, 3)] += v[hook(6, 4)] + (m[hook(4, sigma[ihook(10, i)[1hook(9, 15))] ^ u512[hook(11, sigma[ihook(10, i)[1hook(9, 15))]);
      v[hook(6, 14)] ^= v[hook(6, 3)];
      v[hook(6, 14)] = (((v[hook(6, 14)]) >> (60)) | ((v[hook(6, 14)]) << (64 - (60))));
      v[hook(6, 9)] += v[hook(6, 14)];
      v[hook(6, 4)] = (((v[hook(6, 4)] ^ v[hook(6, 9)]) >> (43)) | ((v[hook(6, 4)] ^ v[hook(6, 9)]) << (64 - (43))));
      v[hook(6, 3)] += v[hook(6, 4)] + (m[hook(4, sigma[ihook(10, i)[1hook(9, 14))] ^ u512[hook(11, sigma[ihook(10, i)[1hook(9, 14))]);
      v[hook(6, 14)] = (((v[hook(6, 14)] ^ v[hook(6, 3)]) >> (5)) | ((v[hook(6, 14)] ^ v[hook(6, 3)]) << (64 - (5))));
      v[hook(6, 9)] += v[hook(6, 14)];
      v[hook(6, 4)] = (((v[hook(6, 4)] ^ v[hook(6, 9)]) >> (18)) | ((v[hook(6, 4)] ^ v[hook(6, 9)]) << (64 - (18))));
      v[hook(6, 14)] ^= (~v[hook(6, 3)] & ~v[hook(6, 4)] & ~v[hook(6, 9)]) | (~v[hook(6, 3)] & v[hook(6, 4)] & v[hook(6, 9)]) | (v[hook(6, 3)] & ~v[hook(6, 4)] & v[hook(6, 9)]) | (v[hook(6, 3)] & v[hook(6, 4)] & ~v[hook(6, 9)]);
      v[hook(6, 14)] ^= (~v[hook(6, 3)] & ~v[hook(6, 4)] & v[hook(6, 9)]) | (~v[hook(6, 3)] & v[hook(6, 4)] & ~v[hook(6, 9)]) | (v[hook(6, 3)] & ~v[hook(6, 4)] & ~v[hook(6, 9)]) | (v[hook(6, 3)] & v[hook(6, 4)] & v[hook(6, 9)]);
    };
  }

  h[hook(7, 0)] ^= v[hook(6, 0)] ^ v[hook(6, 8)];

  h[hook(7, 3)] ^= v[hook(6, 3)] ^ v[hook(6, 11)];

  h[hook(7, 6)] ^= v[hook(6, 6)] ^ v[hook(6, 14)];

  h[hook(7, 0)] ^= h[hook(7, 3)] ^ h[hook(7, 6)];
}

unsigned long vBlake2(global ulong* hi, ulong h7) {
  unsigned long b[8];
  unsigned long h[8];

  for (int i = 0; i < 8; i++) {
    h[hook(7, i)] = vBlake_iv[hook(8, i)];
    b[hook(12, i)] = hi[hook(13, i)];
  }
  h[hook(7, 0)] ^= (ulong)(0x01010000 ^ 0x18);

  b[hook(12, 7)] = h7;

  vblake512_compress(h, b);

  return h[hook(7, 0)];
}

kernel void kernel_vblake(global unsigned int* nonceStart, global unsigned int* nonceOut, global unsigned long* hashStartOut, global unsigned long* headerIn) {
  unsigned int nonce = ((unsigned int)get_global_id(0) & 0xffffffffu) + nonceStart[hook(0, 0)];

  unsigned long nonceHeaderSection = headerIn[hook(3, 7)];

  nonceHeaderSection &= 0x00000000FFFFFFFFu;
  nonceHeaderSection |= (((unsigned long)nonce) << 32);

  unsigned long hashStart = vBlake2(headerIn, nonceHeaderSection);

  if ((hashStart & 0x00000000FFFFFFFFu) == 0) {
    if (hashStartOut[hook(2, 0)] > hashStart || hashStartOut[hook(2, 0)] == 0) {
      nonceOut[hook(1, 0)] = nonce;
      hashStartOut[hook(2, 0)] = hashStart;
    }
  }
}