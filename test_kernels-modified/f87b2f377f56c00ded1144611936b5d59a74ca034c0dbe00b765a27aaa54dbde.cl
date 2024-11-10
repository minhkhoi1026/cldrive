//{"K":6,"input":0,"m":5,"offset":2,"solution":3,"text":4,"work":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant unsigned int K[64] = {0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5, 0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3, 0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174, 0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da, 0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7, 0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967, 0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13, 0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85, 0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3, 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070, 0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3, 0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208, 0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2};

kernel void mine(constant const uchar* input, const ulong work, const ulong offset, global uchar* solution) {
  uchar text[64] = {0};

  for (int i = 0; i < 22; i++)
    text[hook(4, i)] = input[hook(0, i)];

  ulong id = get_global_id(0) + offset;

  for (int i = 0; i < 11; i++) {
    text[hook(4, i + 22)] = ((id >> (i * 6)) & 0x3f) + 32;
  }

  text[hook(4, 33)] = 0x80;
  text[hook(4, 62)] = ((33 * 8) >> 8) & 0xff;
  text[hook(4, 63)] = (33 * 8) & 0xff;

  unsigned int a, b, c, d, e, f, g, h, t1, t2, m[64];

  for (int i = 0; i < 16; i++) {
    m[hook(5, i)] = text[hook(4, i * 4)] << 24 | text[hook(4, i * 4 + 1)] << 16 | text[hook(4, i * 4 + 2)] << 8 | text[hook(4, i * 4 + 3)];
  }

  for (int i = 16; i < 64; i++) {
    m[hook(5, i)] = (rotate((unsigned int)((m[hook(5, i - 2)])), -(unsigned int)(17)) ^ rotate((unsigned int)((m[hook(5, i - 2)])), -(unsigned int)(19)) ^ ((m[hook(5, i - 2)]) >> 10)) + m[hook(5, i - 7)] + (rotate((unsigned int)((m[hook(5, i - 15)])), -(unsigned int)(7)) ^ rotate((unsigned int)((m[hook(5, i - 15)])), -(unsigned int)(18)) ^ ((m[hook(5, i - 15)]) >> 3)) + m[hook(5, i - 16)];
  }

  a = 0x6a09e667;
  b = 0xbb67ae85;
  c = 0x3c6ef372;
  d = 0xa54ff53a;
  e = 0x510e527f;
  f = 0x9b05688c;
  g = 0x1f83d9ab;
  h = 0x5be0cd19;

  for (int i = 0; i < 64; i++) {
    t1 = h + (rotate((unsigned int)((e)), -(unsigned int)(6)) ^ rotate((unsigned int)((e)), -(unsigned int)(11)) ^ rotate((unsigned int)((e)), -(unsigned int)(25))) + bitselect((g), (f), (e)) + K[hook(6, i)] + m[hook(5, i)];
    t2 = (rotate((unsigned int)((a)), -(unsigned int)(2)) ^ rotate((unsigned int)((a)), -(unsigned int)(13)) ^ rotate((unsigned int)((a)), -(unsigned int)(22))) + bitselect((a), (b), (c) ^ (a));
    h = g;
    g = f;
    f = e;
    e = d + t1;
    d = c;
    c = b;
    b = a;
    a = t1 + t2;
  }

  a += 0x6a09e667;
  b += 0xbb67ae85;

  ulong score = (((ulong)(a >> 24)) & 0xff) << 40 | (((ulong)(a >> 16)) & 0xff) << 32 | (((ulong)(a >> 8)) & 0xff) << 24 | (((ulong)(a)) & 0xff) << 16 | (((ulong)(b >> 24)) & 0xff) << 8 | (((ulong)(b >> 16)) & 0xff);

  if (score <= work) {
    for (int i = 0; i < 11; i++) {
      solution[hook(3, i)] = text[hook(4, i + 22)];
    }
  }
}