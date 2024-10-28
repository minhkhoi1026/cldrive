//{"H":1,"K":4,"W":3,"data":0,"stride":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant unsigned int K[] = {
    0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5, 0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3, 0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174, 0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da, 0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7, 0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967, 0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13, 0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85, 0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3, 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070, 0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3, 0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208, 0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2,
};

inline unsigned int CH(unsigned int x, unsigned int y, unsigned int z) {
  return (x & y) ^ (~x & z);
}

inline unsigned int Maj(unsigned int x, unsigned int y, unsigned int z) {
  return (x & y) ^ (x & z) ^ (y & z);
}

inline unsigned int RotR(unsigned int x, uchar shift) {
  return (x >> shift) | (x << (32 - shift));
}

inline unsigned int sigma0(unsigned int x) {
  return RotR(x, 2) ^ RotR(x, 13) ^ RotR(x, 22);
}

inline unsigned int sigma1(unsigned int x) {
  return RotR(x, 6) ^ RotR(x, 11) ^ RotR(x, 25);
}

inline unsigned int smsigma0(unsigned int x) {
  return RotR(x, 7) ^ RotR(x, 18) ^ (x >> 3);
}

inline unsigned int smsigma1(unsigned int x) {
  return RotR(x, 17) ^ RotR(x, 19) ^ (x >> 10);
}
kernel void execute_sha256_cpu(global const unsigned int* data, global unsigned int* H, int stride) {
  unsigned int W[64];
  unsigned int a, b, c, d, e, f, g, h;

  for (int k = 0; k < 1 * 16; k++) {
    for (int i = 0; i < 16; i++)
      W[hook(3, i)] = data[hook(0, k * stride + i)];
    for (int i = 16; i < 64; i++)
      W[hook(3, i)] = smsigma1(W[hook(3, i - 2)]) + W[hook(3, i - 7)] + smsigma0(W[hook(3, i - 15)]) + W[hook(3, i - 16)];

    a = H[hook(1, k * 8 + 0)];
    b = H[hook(1, k * 8 + 1)];
    c = H[hook(1, k * 8 + 2)];
    d = H[hook(1, k * 8 + 3)];
    e = H[hook(1, k * 8 + 4)];
    f = H[hook(1, k * 8 + 5)];
    g = H[hook(1, k * 8 + 6)];
    h = H[hook(1, k * 8 + 7)];

    for (int i = 0; i < 64; i++) {
      unsigned int T1 = h + sigma1(e) + CH(e, f, g) + K[hook(4, i)] + W[hook(3, i)];
      unsigned int float2 = sigma0(a) + Maj(a, b, c);
      h = g;
      g = f;
      f = e;
      e = d + T1;
      d = c;
      c = b;
      b = a;
      a = T1 + float2;
    }

    H[hook(1, k * 8 + 0)] += a;
    H[hook(1, k * 8 + 1)] += b;
    H[hook(1, k * 8 + 2)] += c;
    H[hook(1, k * 8 + 3)] += d;
    H[hook(1, k * 8 + 4)] += e;
    H[hook(1, k * 8 + 5)] += f;
    H[hook(1, k * 8 + 6)] += g;
    H[hook(1, k * 8 + 7)] += h;
  }
}