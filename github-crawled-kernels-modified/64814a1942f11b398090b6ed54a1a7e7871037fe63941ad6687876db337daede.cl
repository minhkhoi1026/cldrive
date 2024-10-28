//{"data":5,"difficultyMask":3,"hashedPrehash":0,"k":7,"m":4,"padded":8,"result":1,"startNonce":2,"state":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant const unsigned int k[64] = {0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5, 0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3, 0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174, 0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da, 0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7, 0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967, 0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13, 0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85, 0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3, 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070, 0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3, 0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208, 0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2};

char ito10(ulong num, uchar* buf) {
  char r;
  char s;
  char n = 0;

  uchar* cpy = buf;

  if (num == 0) {
    *buf++ = '0';
    n = 1;
  }
  while (num) {
    r = num % 10;
    s = '0' + r;
    num /= 10;
    *buf++ = s;
    n++;
  }
  while (cpy < buf) {
    s = *(--buf);
    *buf = *cpy;
    *cpy++ = s;
  }
  return n;
}

void sha256round(uchar* data, unsigned int* state) {
  unsigned int a, b, c, d, e, f, g, h, i, j, t1, t2, m[64];

  for (i = 0, j = 0; i < 16; ++i, j += 4)
    m[hook(4, i)] = (data[hook(5, j)] << 24) | (data[hook(5, j + 1)] << 16) | (data[hook(5, j + 2)] << 8) | (data[hook(5, j + 3)]);
  for (; i < 64; ++i)
    m[hook(4, i)] = (((m[hook(4, i - 2)] >> 17) | (m[hook(4, i - 2)] << (32 - 17))) ^ ((m[hook(4, i - 2)] >> 19) | (m[hook(4, i - 2)] << (32 - 19))) ^ (m[hook(4, i - 2)] >> 10)) + m[hook(4, i - 7)] + (((m[hook(4, i - 15)] >> 7) | (m[hook(4, i - 15)] << (32 - 7))) ^ ((m[hook(4, i - 15)] >> 18) | (m[hook(4, i - 15)] << (32 - 18))) ^ (m[hook(4, i - 15)] >> 3)) + m[hook(4, i - 16)];

  a = state[hook(6, 0)];
  b = state[hook(6, 1)];
  c = state[hook(6, 2)];
  d = state[hook(6, 3)];
  e = state[hook(6, 4)];
  f = state[hook(6, 5)];
  g = state[hook(6, 6)];
  h = state[hook(6, 7)];

  for (i = 0; i < 64; ++i) {
    t1 = h + (((e >> 6) | (e << (32 - 6))) ^ ((e >> 11) | (e << (32 - 11))) ^ ((e >> 25) | (e << (32 - 25)))) + ((e & f) ^ (~e & g)) + k[hook(7, i)] + m[hook(4, i)];
    t2 = (((a >> 2) | (a << (32 - 2))) ^ ((a >> 13) | (a << (32 - 13))) ^ ((a >> 22) | (a << (32 - 22)))) + ((a & b) ^ (a & c) ^ (b & c));
    h = g;
    g = f;
    f = e;
    e = d + t1;
    d = c;
    c = b;
    b = a;
    a = t1 + t2;
  }

  state[hook(6, 0)] += a;
  state[hook(6, 1)] += b;
  state[hook(6, 2)] += c;
  state[hook(6, 3)] += d;
  state[hook(6, 4)] += e;
  state[hook(6, 5)] += f;
  state[hook(6, 6)] += g;
  state[hook(6, 7)] += h;
}

kernel void sha256(global unsigned int* hashedPrehash, global uchar* result, const ulong startNonce, const unsigned int difficultyMask) {
  const int id = get_global_id(0) + get_global_id(1) * get_global_size(0) + get_global_id(2) * get_global_size(0) * get_global_size(1);
  const ulong nonce = id + startNonce;
  uchar padded[64];
  unsigned int state[8];

  result[hook(1, id)] = 0;
  state[hook(6, 0)] = hashedPrehash[hook(0, 0)];
  state[hook(6, 1)] = hashedPrehash[hook(0, 1)];
  state[hook(6, 2)] = hashedPrehash[hook(0, 2)];
  state[hook(6, 3)] = hashedPrehash[hook(0, 3)];
  state[hook(6, 4)] = hashedPrehash[hook(0, 4)];
  state[hook(6, 5)] = hashedPrehash[hook(0, 5)];
  state[hook(6, 6)] = hashedPrehash[hook(0, 6)];
  state[hook(6, 7)] = hashedPrehash[hook(0, 7)];

  padded[hook(8, 0)] = ',';
  char n = ito10(nonce, padded + 1);
  padded[hook(8, n + 1)] = 0x80;
  for (int i = n + 2; i < 62; i++) {
    padded[hook(8, i)] = 0;
  }

  unsigned int bitlen = (65 + n) * 8;
  padded[hook(8, 63)] = bitlen;
  padded[hook(8, 62)] = bitlen >> 8;

  sha256round(padded, state);
  if ((state[hook(6, 0)] & difficultyMask) == 0)
    result[hook(1, id)] = 1;
}