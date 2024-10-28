//{"K":4,"W":3,"data_info":0,"digest":2,"plain_key":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
unsigned int rotr(unsigned int x, int n) {
  if (n < 32)
    return (x >> n) | (x << (32 - n));
  return x;
}

unsigned int ch(unsigned int x, unsigned int y, unsigned int z) {
  return (x & y) ^ (~x & z);
}

unsigned int maj(unsigned int x, unsigned int y, unsigned int z) {
  return (x & y) ^ (x & z) ^ (y & z);
}

unsigned int sigma0(unsigned int x) {
  return rotr(x, 2) ^ rotr(x, 13) ^ rotr(x, 22);
}

unsigned int sigma1(unsigned int x) {
  return rotr(x, 6) ^ rotr(x, 11) ^ rotr(x, 25);
}

unsigned int gamma0(unsigned int x) {
  return rotr(x, 7) ^ rotr(x, 18) ^ (x >> 3);
}

unsigned int gamma1(unsigned int x) {
  return rotr(x, 17) ^ rotr(x, 19) ^ (x >> 10);
}

kernel void sha256_crypt_kernel(global unsigned int* data_info, global char* plain_key, global unsigned int* digest) {
  int t, gid, msg_pad;
  int stop, mmod;
  unsigned int i, ulen, item, total;
  unsigned int W[80], temp, A, B, C, D, E, F, G, H, T1, float2;
  unsigned int num_keys = data_info[hook(0, 1)];
  int current_pad;

  unsigned int K[64] = {0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5, 0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3, 0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174, 0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da, 0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7, 0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967, 0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13, 0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85, 0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3, 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070, 0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3, 0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208, 0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2};

  msg_pad = 0;

  ulen = data_info[hook(0, 2)];
  total = ulen % 64 >= 56 ? 2 : 1 + ulen / 64;

  digest[hook(2, 0)] = 0x6a09e667;
  digest[hook(2, 1)] = 0xbb67ae85;
  digest[hook(2, 2)] = 0x3c6ef372;
  digest[hook(2, 3)] = 0xa54ff53a;
  digest[hook(2, 4)] = 0x510e527f;
  digest[hook(2, 5)] = 0x9b05688c;
  digest[hook(2, 6)] = 0x1f83d9ab;
  digest[hook(2, 7)] = 0x5be0cd19;
  for (item = 0; item < total; item++) {
    A = digest[hook(2, 0)];
    B = digest[hook(2, 1)];
    C = digest[hook(2, 2)];
    D = digest[hook(2, 3)];
    E = digest[hook(2, 4)];
    F = digest[hook(2, 5)];
    G = digest[hook(2, 6)];
    H = digest[hook(2, 7)];

    for (t = 0; t < 80; t++) {
      W[hook(3, t)] = 0x00000000;
    }
    msg_pad = item * 64;
    if (ulen > msg_pad) {
      current_pad = (ulen - msg_pad) > 64 ? 64 : (ulen - msg_pad);
    } else {
      current_pad = -1;
    }

    if (current_pad > 0) {
      i = current_pad;

      stop = i / 4;

      for (t = 0; t < stop; t++) {
        W[hook(3, t)] = ((uchar)plain_key[hook(1, msg_pad + t * 4)]) << 24;
        W[hook(3, t)] |= ((uchar)plain_key[hook(1, msg_pad + t * 4 + 1)]) << 16;
        W[hook(3, t)] |= ((uchar)plain_key[hook(1, msg_pad + t * 4 + 2)]) << 8;
        W[hook(3, t)] |= (uchar)plain_key[hook(1, msg_pad + t * 4 + 3)];
      }
      mmod = i % 4;
      if (mmod == 3) {
        W[hook(3, t)] = ((uchar)plain_key[hook(1, msg_pad + t * 4)]) << 24;
        W[hook(3, t)] |= ((uchar)plain_key[hook(1, msg_pad + t * 4 + 1)]) << 16;
        W[hook(3, t)] |= ((uchar)plain_key[hook(1, msg_pad + t * 4 + 2)]) << 8;
        W[hook(3, t)] |= ((uchar)0x80);
      } else if (mmod == 2) {
        W[hook(3, t)] = ((uchar)plain_key[hook(1, msg_pad + t * 4)]) << 24;
        W[hook(3, t)] |= ((uchar)plain_key[hook(1, msg_pad + t * 4 + 1)]) << 16;
        W[hook(3, t)] |= 0x8000;
      } else if (mmod == 1) {
        W[hook(3, t)] = ((uchar)plain_key[hook(1, msg_pad + t * 4)]) << 24;
        W[hook(3, t)] |= 0x800000;
      } else {
        W[hook(3, t)] = 0x80000000;
      }

      if (current_pad < 56) {
        W[hook(3, 15)] = ulen * 8;
      }
    } else if (current_pad < 0) {
      if (ulen % 64 == 0)
        W[hook(3, 0)] = 0x80000000;
      W[hook(3, 15)] = ulen * 8;
    }

    for (t = 0; t < 64; t++) {
      if (t >= 16)
        W[hook(3, t)] = gamma1(W[hook(3, t - 2)]) + W[hook(3, t - 7)] + gamma0(W[hook(3, t - 15)]) + W[hook(3, t - 16)];
      T1 = H + sigma1(E) + ch(E, F, G) + K[hook(4, t)] + W[hook(3, t)];
      float2 = sigma0(A) + maj(A, B, C);
      H = G;
      G = F;
      F = E;
      E = D + T1;
      D = C;
      C = B;
      B = A;
      A = T1 + float2;
    }
    digest[hook(2, 0)] += A;
    digest[hook(2, 1)] += B;
    digest[hook(2, 2)] += C;
    digest[hook(2, 3)] += D;
    digest[hook(2, 4)] += E;
    digest[hook(2, 5)] += F;
    digest[hook(2, 6)] += G;
    digest[hook(2, 7)] += H;
  }
}