//{"H":2,"bitmap":0,"bitmap2":1,"k":4,"w":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant unsigned long k[] = {
    0x428a2f98d728ae22UL, 0x7137449123ef65cdUL, 0xb5c0fbcfec4d3b2fUL, 0xe9b5dba58189dbbcUL, 0x3956c25bf348b538UL, 0x59f111f1b605d019UL, 0x923f82a4af194f9bUL, 0xab1c5ed5da6d8118UL, 0xd807aa98a3030242UL, 0x12835b0145706fbeUL, 0x243185be4ee4b28cUL, 0x550c7dc3d5ffb4e2UL, 0x72be5d74f27b896fUL, 0x80deb1fe3b1696b1UL, 0x9bdc06a725c71235UL, 0xc19bf174cf692694UL, 0xe49b69c19ef14ad2UL, 0xefbe4786384f25e3UL, 0x0fc19dc68b8cd5b5UL, 0x240ca1cc77ac9c65UL, 0x2de92c6f592b0275UL, 0x4a7484aa6ea6e483UL, 0x5cb0a9dcbd41fbd4UL, 0x76f988da831153b5UL, 0x983e5152ee66dfabUL, 0xa831c66d2db43210UL, 0xb00327c898fb213fUL, 0xbf597fc7beef0ee4UL, 0xc6e00bf33da88fc2UL, 0xd5a79147930aa725UL, 0x06ca6351e003826fUL, 0x142929670a0e6e70UL, 0x27b70a8546d22ffcUL, 0x2e1b21385c26c926UL, 0x4d2c6dfc5ac42aedUL, 0x53380d139d95b3dfUL, 0x650a73548baf63deUL, 0x766a0abb3c77b2a8UL, 0x81c2c92e47edaee6UL, 0x92722c851482353bUL, 0xa2bfe8a14cf10364UL, 0xa81a664bbc423001UL, 0xc24b8b70d0f89791UL, 0xc76c51a30654be30UL, 0xd192e819d6ef5218UL, 0xd69906245565a910UL, 0xf40e35855771202aUL, 0x106aa07032bbd1b8UL, 0x19a4c116b8d2d0c8UL, 0x1e376c085141ab53UL, 0x2748774cdf8eeb99UL, 0x34b0bcb5e19b48a8UL, 0x391c0cb3c5c95a63UL, 0x4ed8aa4ae3418acbUL, 0x5b9cca4f7763e373UL, 0x682e6ff3d6b2b8a3UL, 0x748f82ee5defb2fcUL, 0x78a5636f43172f60UL, 0x84c87814a1f0ab72UL, 0x8cc702081a6439ecUL, 0x90befffa23631e28UL, 0xa4506cebde82bde9UL, 0xbef9a3f7b2c67915UL, 0xc67178f2e372532bUL, 0xca273eceea26619cUL, 0xd186b8c721c0c207UL, 0xeada7dd6cde0eb1eUL, 0xf57d4f7fee6ed178UL, 0x06f067aa72176fbaUL, 0x0a637dc5a2c898a6UL, 0x113f9804bef90daeUL, 0x1b710b35131c471bUL, 0x28db77f523047d84UL, 0x32caab7b40c72493UL, 0x3c9ebe0a15c9bebcUL, 0x431d67c49c100d4cUL, 0x4cc5d4becb3e42b6UL, 0x597f299cfc657e2aUL, 0x5fcb6fab3ad6faecUL, 0x6c44198c4a475817UL,
};

constant unsigned long H[] = {
    0x6a09e667f3bcc908UL, 0xbb67ae8584caa73bUL, 0x3c6ef372fe94f82bUL, 0xa54ff53a5f1d36f1UL, 0x510e527fade682d1UL, 0x9b05688c2b3e6c1fUL, 0x1f83d9abfb41bd6bUL, 0x5be0cd19137e2179UL,
};

void sha512_block(ulong* w) {
  ulong a = H[hook(2, 0)];
  ulong b = H[hook(2, 1)];
  ulong c = H[hook(2, 2)];
  ulong d = H[hook(2, 3)];
  ulong e = H[hook(2, 4)];
  ulong f = H[hook(2, 5)];
  ulong g = H[hook(2, 6)];
  ulong h = H[hook(2, 7)];
  ulong t1, t2;

  for (int i = 0; i < 80; i++) {
    if (i > 15) {
      w[hook(3, i & 15)] = ((rotate(w[hook(3, (i - 2) & 15)], (unsigned long)64 - 19)) ^ (rotate(w[hook(3, (i - 2) & 15)], (unsigned long)64 - 61)) ^ (w[hook(3, (i - 2) & 15)] >> 6)) + ((rotate(w[hook(3, (i - 15) & 15)], (unsigned long)64 - 1)) ^ (rotate(w[hook(3, (i - 15) & 15)], (unsigned long)64 - 8)) ^ (w[hook(3, (i - 15) & 15)] >> 7)) + w[hook(3, (i - 16) & 15)] + w[hook(3, (i - 7) & 15)];
    }
    t1 = k[hook(4, i)] + w[hook(3, i & 15)] + h + ((rotate(e, (unsigned long)64 - 14)) ^ (rotate(e, (unsigned long)64 - 18)) ^ (rotate(e, (unsigned long)64 - 41))) + bitselect(g, f, e);
    t2 = bitselect(a, b, c ^ a) + ((rotate(a, (unsigned long)64 - 28)) ^ (rotate(a, (unsigned long)64 - 34)) ^ (rotate(a, (unsigned long)64 - 39)));
    h = g;
    g = f;
    f = e;
    e = d + t1;
    d = c;
    c = b;
    b = a;
    a = t1 + t2;
  }

  w[hook(3, 0)] = (((H[hook(2, 0)] + a) << 56) | (((H[hook(2, 0)] + a) & 0xff00) << 40) | (((H[hook(2, 0)] + a) & 0xff0000) << 24) | (((H[hook(2, 0)] + a) & 0xff000000) << 8) | (((H[hook(2, 0)] + a) >> 8) & 0xff000000) | (((H[hook(2, 0)] + a) >> 24) & 0xff0000) | (((H[hook(2, 0)] + a) >> 40) & 0xff00) | ((H[hook(2, 0)] + a) >> 56));
  w[hook(3, 1)] = (((H[hook(2, 1)] + b) << 56) | (((H[hook(2, 1)] + b) & 0xff00) << 40) | (((H[hook(2, 1)] + b) & 0xff0000) << 24) | (((H[hook(2, 1)] + b) & 0xff000000) << 8) | (((H[hook(2, 1)] + b) >> 8) & 0xff000000) | (((H[hook(2, 1)] + b) >> 24) & 0xff0000) | (((H[hook(2, 1)] + b) >> 40) & 0xff00) | ((H[hook(2, 1)] + b) >> 56));
  w[hook(3, 2)] = (((H[hook(2, 2)] + c) << 56) | (((H[hook(2, 2)] + c) & 0xff00) << 40) | (((H[hook(2, 2)] + c) & 0xff0000) << 24) | (((H[hook(2, 2)] + c) & 0xff000000) << 8) | (((H[hook(2, 2)] + c) >> 8) & 0xff000000) | (((H[hook(2, 2)] + c) >> 24) & 0xff0000) | (((H[hook(2, 2)] + c) >> 40) & 0xff00) | ((H[hook(2, 2)] + c) >> 56));
  w[hook(3, 3)] = (((H[hook(2, 3)] + d) << 56) | (((H[hook(2, 3)] + d) & 0xff00) << 40) | (((H[hook(2, 3)] + d) & 0xff0000) << 24) | (((H[hook(2, 3)] + d) & 0xff000000) << 8) | (((H[hook(2, 3)] + d) >> 8) & 0xff000000) | (((H[hook(2, 3)] + d) >> 24) & 0xff0000) | (((H[hook(2, 3)] + d) >> 40) & 0xff00) | ((H[hook(2, 3)] + d) >> 56));
  w[hook(3, 4)] = (((H[hook(2, 4)] + e) << 56) | (((H[hook(2, 4)] + e) & 0xff00) << 40) | (((H[hook(2, 4)] + e) & 0xff0000) << 24) | (((H[hook(2, 4)] + e) & 0xff000000) << 8) | (((H[hook(2, 4)] + e) >> 8) & 0xff000000) | (((H[hook(2, 4)] + e) >> 24) & 0xff0000) | (((H[hook(2, 4)] + e) >> 40) & 0xff00) | ((H[hook(2, 4)] + e) >> 56));
  w[hook(3, 5)] = (((H[hook(2, 5)] + f) << 56) | (((H[hook(2, 5)] + f) & 0xff00) << 40) | (((H[hook(2, 5)] + f) & 0xff0000) << 24) | (((H[hook(2, 5)] + f) & 0xff000000) << 8) | (((H[hook(2, 5)] + f) >> 8) & 0xff000000) | (((H[hook(2, 5)] + f) >> 24) & 0xff0000) | (((H[hook(2, 5)] + f) >> 40) & 0xff00) | ((H[hook(2, 5)] + f) >> 56));
  w[hook(3, 6)] = (((H[hook(2, 6)] + g) << 56) | (((H[hook(2, 6)] + g) & 0xff00) << 40) | (((H[hook(2, 6)] + g) & 0xff0000) << 24) | (((H[hook(2, 6)] + g) & 0xff000000) << 8) | (((H[hook(2, 6)] + g) >> 8) & 0xff000000) | (((H[hook(2, 6)] + g) >> 24) & 0xff0000) | (((H[hook(2, 6)] + g) >> 40) & 0xff00) | ((H[hook(2, 6)] + g) >> 56));
  w[hook(3, 7)] = (((H[hook(2, 7)] + h) << 56) | (((H[hook(2, 7)] + h) & 0xff00) << 40) | (((H[hook(2, 7)] + h) & 0xff0000) << 24) | (((H[hook(2, 7)] + h) & 0xff000000) << 8) | (((H[hook(2, 7)] + h) >> 8) & 0xff000000) | (((H[hook(2, 7)] + h) >> 24) & 0xff0000) | (((H[hook(2, 7)] + h) >> 40) & 0xff00) | ((H[hook(2, 7)] + h) >> 56));
}
void sha512_block2(ulong2* w) {
  ulong2 a = H[hook(2, 0)];
  ulong2 b = H[hook(2, 1)];
  ulong2 c = H[hook(2, 2)];
  ulong2 d = H[hook(2, 3)];
  ulong2 e = H[hook(2, 4)];
  ulong2 f = H[hook(2, 5)];
  ulong2 g = H[hook(2, 6)];
  ulong2 h = H[hook(2, 7)];
  ulong2 t1, t2;

  for (int i = 0; i < 80; i++) {
    if (i > 15) {
      w[hook(3, i & 15)] = ((rotate(w[hook(3, (i - 2) & 15)], (unsigned long)64 - 19)) ^ (rotate(w[hook(3, (i - 2) & 15)], (unsigned long)64 - 61)) ^ (w[hook(3, (i - 2) & 15)] >> 6)) + ((rotate(w[hook(3, (i - 15) & 15)], (unsigned long)64 - 1)) ^ (rotate(w[hook(3, (i - 15) & 15)], (unsigned long)64 - 8)) ^ (w[hook(3, (i - 15) & 15)] >> 7)) + w[hook(3, (i - 16) & 15)] + w[hook(3, (i - 7) & 15)];
    }
    t1 = k[hook(4, i)] + w[hook(3, i & 15)] + h + ((rotate(e, (unsigned long)64 - 14)) ^ (rotate(e, (unsigned long)64 - 18)) ^ (rotate(e, (unsigned long)64 - 41))) + bitselect(g, f, e);
    t2 = bitselect(a, b, c ^ a) + ((rotate(a, (unsigned long)64 - 28)) ^ (rotate(a, (unsigned long)64 - 34)) ^ (rotate(a, (unsigned long)64 - 39)));
    h = g;
    g = f;
    f = e;
    e = d + t1;
    d = c;
    c = b;
    b = a;
    a = t1 + t2;
  }

  w[hook(3, 0)] = (((H[hook(2, 0)] + a) << 56) | (((H[hook(2, 0)] + a) & 0xff00) << 40) | (((H[hook(2, 0)] + a) & 0xff0000) << 24) | (((H[hook(2, 0)] + a) & 0xff000000) << 8) | (((H[hook(2, 0)] + a) >> 8) & 0xff000000) | (((H[hook(2, 0)] + a) >> 24) & 0xff0000) | (((H[hook(2, 0)] + a) >> 40) & 0xff00) | ((H[hook(2, 0)] + a) >> 56));
  w[hook(3, 1)] = (((H[hook(2, 1)] + b) << 56) | (((H[hook(2, 1)] + b) & 0xff00) << 40) | (((H[hook(2, 1)] + b) & 0xff0000) << 24) | (((H[hook(2, 1)] + b) & 0xff000000) << 8) | (((H[hook(2, 1)] + b) >> 8) & 0xff000000) | (((H[hook(2, 1)] + b) >> 24) & 0xff0000) | (((H[hook(2, 1)] + b) >> 40) & 0xff00) | ((H[hook(2, 1)] + b) >> 56));
  w[hook(3, 2)] = (((H[hook(2, 2)] + c) << 56) | (((H[hook(2, 2)] + c) & 0xff00) << 40) | (((H[hook(2, 2)] + c) & 0xff0000) << 24) | (((H[hook(2, 2)] + c) & 0xff000000) << 8) | (((H[hook(2, 2)] + c) >> 8) & 0xff000000) | (((H[hook(2, 2)] + c) >> 24) & 0xff0000) | (((H[hook(2, 2)] + c) >> 40) & 0xff00) | ((H[hook(2, 2)] + c) >> 56));
  w[hook(3, 3)] = (((H[hook(2, 3)] + d) << 56) | (((H[hook(2, 3)] + d) & 0xff00) << 40) | (((H[hook(2, 3)] + d) & 0xff0000) << 24) | (((H[hook(2, 3)] + d) & 0xff000000) << 8) | (((H[hook(2, 3)] + d) >> 8) & 0xff000000) | (((H[hook(2, 3)] + d) >> 24) & 0xff0000) | (((H[hook(2, 3)] + d) >> 40) & 0xff00) | ((H[hook(2, 3)] + d) >> 56));
  w[hook(3, 4)] = (((H[hook(2, 4)] + e) << 56) | (((H[hook(2, 4)] + e) & 0xff00) << 40) | (((H[hook(2, 4)] + e) & 0xff0000) << 24) | (((H[hook(2, 4)] + e) & 0xff000000) << 8) | (((H[hook(2, 4)] + e) >> 8) & 0xff000000) | (((H[hook(2, 4)] + e) >> 24) & 0xff0000) | (((H[hook(2, 4)] + e) >> 40) & 0xff00) | ((H[hook(2, 4)] + e) >> 56));
  w[hook(3, 5)] = (((H[hook(2, 5)] + f) << 56) | (((H[hook(2, 5)] + f) & 0xff00) << 40) | (((H[hook(2, 5)] + f) & 0xff0000) << 24) | (((H[hook(2, 5)] + f) & 0xff000000) << 8) | (((H[hook(2, 5)] + f) >> 8) & 0xff000000) | (((H[hook(2, 5)] + f) >> 24) & 0xff0000) | (((H[hook(2, 5)] + f) >> 40) & 0xff00) | ((H[hook(2, 5)] + f) >> 56));
  w[hook(3, 6)] = (((H[hook(2, 6)] + g) << 56) | (((H[hook(2, 6)] + g) & 0xff00) << 40) | (((H[hook(2, 6)] + g) & 0xff0000) << 24) | (((H[hook(2, 6)] + g) & 0xff000000) << 8) | (((H[hook(2, 6)] + g) >> 8) & 0xff000000) | (((H[hook(2, 6)] + g) >> 24) & 0xff0000) | (((H[hook(2, 6)] + g) >> 40) & 0xff00) | ((H[hook(2, 6)] + g) >> 56));
  w[hook(3, 7)] = (((H[hook(2, 7)] + h) << 56) | (((H[hook(2, 7)] + h) & 0xff00) << 40) | (((H[hook(2, 7)] + h) & 0xff0000) << 24) | (((H[hook(2, 7)] + h) & 0xff000000) << 8) | (((H[hook(2, 7)] + h) >> 8) & 0xff000000) | (((H[hook(2, 7)] + h) >> 24) & 0xff0000) | (((H[hook(2, 7)] + h) >> 40) & 0xff00) | ((H[hook(2, 7)] + h) >> 56));
}
inline unsigned int _50BitRor(unsigned long value, unsigned int n) {
  return (unsigned int)((value >> n) | (value << (50 - n)));
}
kernel void _2buf_zeroBitmap(global float8* bitmap, global float8* bitmap2) {
  const unsigned int i = get_global_id(0);
  bitmap[hook(0, i)] = 0;
  bitmap2[hook(1, i)] = 0;
}