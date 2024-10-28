//{"block":4,"buffer":3,"k":5,"midstate":2,"midstateIn":0,"nonceOut":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline unsigned int rotr64(const ulong w, const unsigned c) {
  return (w >> c) | (w << (64 - c));
}
inline unsigned int ROTRIGHT(const unsigned int w, const unsigned c) {
  return (w >> c) | (w << (32 - c));
}
inline unsigned int ror(const unsigned int w, const unsigned c) {
  return (w >> c) | (w << (32 - c));
}
inline unsigned int SIG0(const unsigned int x) {
  return ROTRIGHT(x, 7) ^ ROTRIGHT(x, 18) ^ ((x) >> 3);
}
inline unsigned int SIG1(const unsigned int x) {
  return ROTRIGHT(x, 17) ^ ROTRIGHT(x, 19) ^ ((x) >> 10);
}
inline unsigned int SIG0c(const unsigned int x) {
  return ROTRIGHT(x, 7) ^ ROTRIGHT(x, 18) ^ ((x) >> 3);
}
inline unsigned int SIG1c(const unsigned int x) {
  return ROTRIGHT(x, 17) ^ ROTRIGHT(x, 19) ^ ((x) >> 10);
}

constant const unsigned int k[64] = {0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5, 0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3, 0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174, 0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da, 0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7, 0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967, 0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13, 0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85, 0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3, 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070, 0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3, 0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208, 0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2};

kernel void microcoin(global unsigned int* midstateIn, global int* nonceOut) {
  unsigned int buffer[16];
  unsigned int midstate[8];

  unsigned int nonce = (midstateIn[hook(0, 25)] << 24) + (unsigned int)get_global_id(0);

  unsigned int whereToSavenOnce = (midstateIn[hook(0, 24)]);

  unsigned int maskTargetH0 = (midstateIn[hook(0, 26)]);
  unsigned int maskTargetH1 = (midstateIn[hook(0, 27)]);
  unsigned int maskTargetH2 = (midstateIn[hook(0, 28)]);

  midstate[hook(2, 0)] = midstateIn[hook(0, 16)];
  midstate[hook(2, 1)] = midstateIn[hook(0, 17)];
  midstate[hook(2, 2)] = midstateIn[hook(0, 18)];
  midstate[hook(2, 3)] = midstateIn[hook(0, 19)];
  midstate[hook(2, 4)] = midstateIn[hook(0, 20)];
  midstate[hook(2, 5)] = midstateIn[hook(0, 21)];
  midstate[hook(2, 6)] = midstateIn[hook(0, 22)];
  midstate[hook(2, 7)] = midstateIn[hook(0, 23)];

  int j = 0;

  for (j = 0; j < 16; j++) {
    buffer[hook(3, j)] = midstateIn[hook(0, j)];
  }

  unsigned int block[64];

  unsigned int temp1;
  unsigned int temp2;
  unsigned int S0;
  unsigned int S1;

  unsigned int h0, h1, h2, h3, h4, h5, h6, h7;

  unsigned int a, b, c, d, e, f, g, h;

  h0 = midstate[hook(2, 0)];
  h1 = midstate[hook(2, 1)];
  h2 = midstate[hook(2, 2)];
  h3 = midstate[hook(2, 3)];
  h4 = midstate[hook(2, 4)];
  h5 = midstate[hook(2, 5)];
  h6 = midstate[hook(2, 6)];
  h7 = midstate[hook(2, 7)];

  a = h0;
  b = h1;
  c = h2;
  d = h3;
  e = h4;
  f = h5;
  g = h6;
  h = h7;

  buffer[hook(3, whereToSavenOnce)] = nonce;

  for (j = 0; j < 16; j++) {
    block[hook(4, j)] = buffer[hook(3, j)];
  }

  for (j = 16; j < 64; j++) {
    block[hook(4, j)] = block[hook(4, j - 16)] + block[hook(4, j - 7)] + SIG1c(block[hook(4, j - 2)]) + SIG0c(block[hook(4, j - 15)]);
  }

  for (j = 0; j < 64; j++) {
    S1 = (ror(e, 6)) ^ (ror(e, 11)) ^ (ror(e, 25));
    temp1 = h + S1 + ((e & f) ^ ((~e) & g)) + k[hook(5, j)] + block[hook(4, j)];
    S0 = (ror(a, 2)) ^ (ror(a, 13)) ^ (ror(a, 22));
    temp2 = S0 + (((a & b) ^ (a & c) ^ (b & c)));

    h = g;
    g = f;
    f = e;
    e = d + temp1;
    d = c;
    c = b;
    b = a;
    a = temp1 + temp2;
  }

  h0 += a;
  h1 += b;
  h2 += c;
  h3 += d;
  h4 += e;
  h5 += f;
  h6 += g;
  h7 += h;

  block[hook(4, 0)] = h0;
  block[hook(4, 1)] = h1;
  block[hook(4, 2)] = h2;
  block[hook(4, 3)] = h3;
  block[hook(4, 4)] = h4;
  block[hook(4, 5)] = h5;
  block[hook(4, 6)] = h6;
  block[hook(4, 7)] = h7;
  block[hook(4, 8)] = 0x80000000;
  block[hook(4, 9)] = 0x00000000;
  block[hook(4, 10)] = 0x00000000;
  block[hook(4, 11)] = 0x00000000;
  block[hook(4, 12)] = 0x00000000;
  block[hook(4, 13)] = 0x00000000;
  block[hook(4, 14)] = 0x00000000;
  block[hook(4, 15)] = 0x00000100;

  h0 = a = 0x6a09e667;
  h1 = b = 0xbb67ae85;
  h2 = c = 0x3c6ef372;
  h3 = d = 0xa54ff53a;
  h4 = e = 0x510e527f;
  h5 = f = 0x9b05688c;
  h6 = g = 0x1f83d9ab;
  h7 = h = 0x5be0cd19;

  for (j = 16; j < 64; j++) {
    block[hook(4, j)] = block[hook(4, j - 16)] + block[hook(4, j - 7)] + SIG1c(block[hook(4, j - 2)]) + SIG0c(block[hook(4, j - 15)]);
  }

  for (j = 0; j < 64; j++) {
    S1 = (ror(e, 6)) ^ (ror(e, 11)) ^ (ror(e, 25));
    temp1 = h + S1 + ((e & f) ^ ((~e) & g)) + k[hook(5, j)] + block[hook(4, j)];
    S0 = (ror(a, 2)) ^ (ror(a, 13)) ^ (ror(a, 22));
    temp2 = S0 + (((a & b) ^ (a & c) ^ (b & c)));

    h = g;
    g = f;
    f = e;
    e = d + temp1;
    d = c;
    c = b;
    b = a;
    a = temp1 + temp2;
  }

  h0 += a;
  h1 += b;
  h2 += c;
  h3 += d;
  h4 += e;
  h5 += f;
  h6 += g;
  h7 += h;

  unsigned int target0 = h0 & maskTargetH0;
  unsigned int target1 = h1 & maskTargetH1;
  unsigned int target2 = h2 & maskTargetH2;
  if (target0 == 0 && target1 == 0 && target2 == 0) {
    *nonceOut = nonce;
  }
}