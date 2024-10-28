//{"W":5,"b64t":7,"hash":4,"input":0,"output":1,"str":6,"target":2,"trip_target":3,"tripkey":8}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant const char b64t[] = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '/'};

__attribute__((reqd_work_group_size(128, 1, 1))) kernel void search(global unsigned char* input, volatile global unsigned int* output, const ulong target, const unsigned int trip_target) {
  unsigned int hash[5];
  unsigned char str[38], *tripkey;
  unsigned int hash3 = 0, hash4 = 0;
  unsigned int W[16];
  unsigned int a, b, c, d, e;

  unsigned int gid = get_global_id(0);

  hash[hook(4, 0)] = 0x67452301;
  hash[hook(4, 1)] = 0xEFCDAB89;
  hash[hook(4, 2)] = 0x98BADCFE;
  hash[hook(4, 3)] = 0x10325476;
  hash[hook(4, 4)] = 0xC3D2E1F0;

  a = hash[hook(4, 0)];
  b = hash[hook(4, 1)];
  c = hash[hook(4, 2)];
  d = hash[hook(4, 3)];
  e = hash[hook(4, 4)];

  W[hook(5, 0)] = __builtin_astype((__builtin_astype((*(const global unsigned int*)(input)), uchar4).wzyx), unsigned int);
  W[hook(5, 1)] = __builtin_astype((__builtin_astype((*(const global unsigned int*)(input + 4)), uchar4).wzyx), unsigned int);
  W[hook(5, 2)] = __builtin_astype((__builtin_astype((*(const global unsigned int*)(input + 8)), uchar4).wzyx), unsigned int);
  W[hook(5, 3)] = __builtin_astype((__builtin_astype((*(const global unsigned int*)(input + 12)), uchar4).wzyx), unsigned int);
  W[hook(5, 4)] = __builtin_astype((__builtin_astype((*(const global unsigned int*)(input + 16)), uchar4).wzyx), unsigned int);
  W[hook(5, 5)] = __builtin_astype((__builtin_astype((*(const global unsigned int*)(input + 20)), uchar4).wzyx), unsigned int);
  W[hook(5, 6)] = __builtin_astype((__builtin_astype((*(const global unsigned int*)(input + 24)), uchar4).wzyx), unsigned int);
  W[hook(5, 7)] = __builtin_astype((__builtin_astype((*(const global unsigned int*)(input + 28)), uchar4).wzyx), unsigned int);
  W[hook(5, 8)] = __builtin_astype((__builtin_astype((*(const global unsigned int*)(input + 32)), uchar4).wzyx), unsigned int);
  W[hook(5, 9)] = __builtin_astype((__builtin_astype((*(const global unsigned int*)(input + 36)), uchar4).wzyx), unsigned int);
  W[hook(5, 10)] = __builtin_astype((__builtin_astype((*(const global unsigned int*)(input + 40)), uchar4).wzyx), unsigned int);
  W[hook(5, 11)] = __builtin_astype((__builtin_astype((*(const global unsigned int*)(input + 44)), uchar4).wzyx), unsigned int);
  W[hook(5, 12)] = __builtin_astype((__builtin_astype((*(const global unsigned int*)(input + 48)), uchar4).wzyx), unsigned int);
  W[hook(5, 13)] = __builtin_astype((__builtin_astype((*(const global unsigned int*)(input + 52)), uchar4).wzyx), unsigned int);
  W[hook(5, 14)] = __builtin_astype((__builtin_astype((*(const global unsigned int*)(input + 56)), uchar4).wzyx), unsigned int);
  W[hook(5, 15)] = __builtin_astype((__builtin_astype((*(const global unsigned int*)(input + 60)), uchar4).wzyx), unsigned int);

  {
    e += bitselect(d, c, b) + W[hook(5, 0)] + 0x5A827999 + rotate(a, (unsigned int)5);
    b = rotate(b, (unsigned int)30);
  };
  {
    d += bitselect(c, b, a) + W[hook(5, 1)] + 0x5A827999 + rotate(e, (unsigned int)5);
    a = rotate(a, (unsigned int)30);
  };
  {
    c += bitselect(b, a, e) + W[hook(5, 2)] + 0x5A827999 + rotate(d, (unsigned int)5);
    e = rotate(e, (unsigned int)30);
  };
  {
    b += bitselect(a, e, d) + W[hook(5, 3)] + 0x5A827999 + rotate(c, (unsigned int)5);
    d = rotate(d, (unsigned int)30);
  };
  {
    a += bitselect(e, d, c) + W[hook(5, 4)] + 0x5A827999 + rotate(b, (unsigned int)5);
    c = rotate(c, (unsigned int)30);
  };
  {
    e += bitselect(d, c, b) + W[hook(5, 5)] + 0x5A827999 + rotate(a, (unsigned int)5);
    b = rotate(b, (unsigned int)30);
  };
  {
    d += bitselect(c, b, a) + W[hook(5, 6)] + 0x5A827999 + rotate(e, (unsigned int)5);
    a = rotate(a, (unsigned int)30);
  };
  {
    c += bitselect(b, a, e) + W[hook(5, 7)] + 0x5A827999 + rotate(d, (unsigned int)5);
    e = rotate(e, (unsigned int)30);
  };
  {
    b += bitselect(a, e, d) + W[hook(5, 8)] + 0x5A827999 + rotate(c, (unsigned int)5);
    d = rotate(d, (unsigned int)30);
  };
  {
    a += bitselect(e, d, c) + W[hook(5, 9)] + 0x5A827999 + rotate(b, (unsigned int)5);
    c = rotate(c, (unsigned int)30);
  };
  {
    e += bitselect(d, c, b) + W[hook(5, 10)] + 0x5A827999 + rotate(a, (unsigned int)5);
    b = rotate(b, (unsigned int)30);
  };
  {
    d += bitselect(c, b, a) + W[hook(5, 11)] + 0x5A827999 + rotate(e, (unsigned int)5);
    a = rotate(a, (unsigned int)30);
  };
  {
    c += bitselect(b, a, e) + W[hook(5, 12)] + 0x5A827999 + rotate(d, (unsigned int)5);
    e = rotate(e, (unsigned int)30);
  };
  {
    b += bitselect(a, e, d) + W[hook(5, 13)] + 0x5A827999 + rotate(c, (unsigned int)5);
    d = rotate(d, (unsigned int)30);
  };
  {
    a += bitselect(e, d, c) + W[hook(5, 14)] + 0x5A827999 + rotate(b, (unsigned int)5);
    c = rotate(c, (unsigned int)30);
  };
  {
    e += bitselect(d, c, b) + W[hook(5, 15)] + 0x5A827999 + rotate(a, (unsigned int)5);
    b = rotate(b, (unsigned int)30);
  };

  {
    d += bitselect(c, b, a) + (W[hook(5, 16 & 15)] = rotate(W[hook(5, (16 + 13) & 15)] ^ W[hook(5, (16 + 8) & 15)] ^ W[hook(5, (16 + 2) & 15)] ^ W[hook(5, 16 & 15)], (unsigned int)1)) + 0x5A827999 + rotate(e, (unsigned int)5);
    a = rotate(a, (unsigned int)30);
  };
  {
    c += bitselect(b, a, e) + (W[hook(5, 17 & 15)] = rotate(W[hook(5, (17 + 13) & 15)] ^ W[hook(5, (17 + 8) & 15)] ^ W[hook(5, (17 + 2) & 15)] ^ W[hook(5, 17 & 15)], (unsigned int)1)) + 0x5A827999 + rotate(d, (unsigned int)5);
    e = rotate(e, (unsigned int)30);
  };
  {
    b += bitselect(a, e, d) + (W[hook(5, 18 & 15)] = rotate(W[hook(5, (18 + 13) & 15)] ^ W[hook(5, (18 + 8) & 15)] ^ W[hook(5, (18 + 2) & 15)] ^ W[hook(5, 18 & 15)], (unsigned int)1)) + 0x5A827999 + rotate(c, (unsigned int)5);
    d = rotate(d, (unsigned int)30);
  };
  {
    a += bitselect(e, d, c) + (W[hook(5, 19 & 15)] = rotate(W[hook(5, (19 + 13) & 15)] ^ W[hook(5, (19 + 8) & 15)] ^ W[hook(5, (19 + 2) & 15)] ^ W[hook(5, 19 & 15)], (unsigned int)1)) + 0x5A827999 + rotate(b, (unsigned int)5);
    c = rotate(c, (unsigned int)30);
  };

  {
    e += (b ^ c ^ d) + (W[hook(5, 20 & 15)] = rotate(W[hook(5, (20 + 13) & 15)] ^ W[hook(5, (20 + 8) & 15)] ^ W[hook(5, (20 + 2) & 15)] ^ W[hook(5, 20 & 15)], (unsigned int)1)) + 0x6ED9EBA1 + rotate(a, (unsigned int)5);
    b = rotate(b, (unsigned int)30);
  };
  {
    d += (a ^ b ^ c) + (W[hook(5, 21 & 15)] = rotate(W[hook(5, (21 + 13) & 15)] ^ W[hook(5, (21 + 8) & 15)] ^ W[hook(5, (21 + 2) & 15)] ^ W[hook(5, 21 & 15)], (unsigned int)1)) + 0x6ED9EBA1 + rotate(e, (unsigned int)5);
    a = rotate(a, (unsigned int)30);
  };
  {
    c += (e ^ a ^ b) + (W[hook(5, 22 & 15)] = rotate(W[hook(5, (22 + 13) & 15)] ^ W[hook(5, (22 + 8) & 15)] ^ W[hook(5, (22 + 2) & 15)] ^ W[hook(5, 22 & 15)], (unsigned int)1)) + 0x6ED9EBA1 + rotate(d, (unsigned int)5);
    e = rotate(e, (unsigned int)30);
  };
  {
    b += (d ^ e ^ a) + (W[hook(5, 23 & 15)] = rotate(W[hook(5, (23 + 13) & 15)] ^ W[hook(5, (23 + 8) & 15)] ^ W[hook(5, (23 + 2) & 15)] ^ W[hook(5, 23 & 15)], (unsigned int)1)) + 0x6ED9EBA1 + rotate(c, (unsigned int)5);
    d = rotate(d, (unsigned int)30);
  };
  {
    a += (c ^ d ^ e) + (W[hook(5, 24 & 15)] = rotate(W[hook(5, (24 + 13) & 15)] ^ W[hook(5, (24 + 8) & 15)] ^ W[hook(5, (24 + 2) & 15)] ^ W[hook(5, 24 & 15)], (unsigned int)1)) + 0x6ED9EBA1 + rotate(b, (unsigned int)5);
    c = rotate(c, (unsigned int)30);
  };
  {
    e += (b ^ c ^ d) + (W[hook(5, 25 & 15)] = rotate(W[hook(5, (25 + 13) & 15)] ^ W[hook(5, (25 + 8) & 15)] ^ W[hook(5, (25 + 2) & 15)] ^ W[hook(5, 25 & 15)], (unsigned int)1)) + 0x6ED9EBA1 + rotate(a, (unsigned int)5);
    b = rotate(b, (unsigned int)30);
  };
  {
    d += (a ^ b ^ c) + (W[hook(5, 26 & 15)] = rotate(W[hook(5, (26 + 13) & 15)] ^ W[hook(5, (26 + 8) & 15)] ^ W[hook(5, (26 + 2) & 15)] ^ W[hook(5, 26 & 15)], (unsigned int)1)) + 0x6ED9EBA1 + rotate(e, (unsigned int)5);
    a = rotate(a, (unsigned int)30);
  };
  {
    c += (e ^ a ^ b) + (W[hook(5, 27 & 15)] = rotate(W[hook(5, (27 + 13) & 15)] ^ W[hook(5, (27 + 8) & 15)] ^ W[hook(5, (27 + 2) & 15)] ^ W[hook(5, 27 & 15)], (unsigned int)1)) + 0x6ED9EBA1 + rotate(d, (unsigned int)5);
    e = rotate(e, (unsigned int)30);
  };
  {
    b += (d ^ e ^ a) + (W[hook(5, 28 & 15)] = rotate(W[hook(5, (28 + 13) & 15)] ^ W[hook(5, (28 + 8) & 15)] ^ W[hook(5, (28 + 2) & 15)] ^ W[hook(5, 28 & 15)], (unsigned int)1)) + 0x6ED9EBA1 + rotate(c, (unsigned int)5);
    d = rotate(d, (unsigned int)30);
  };
  {
    a += (c ^ d ^ e) + (W[hook(5, 29 & 15)] = rotate(W[hook(5, (29 + 13) & 15)] ^ W[hook(5, (29 + 8) & 15)] ^ W[hook(5, (29 + 2) & 15)] ^ W[hook(5, 29 & 15)], (unsigned int)1)) + 0x6ED9EBA1 + rotate(b, (unsigned int)5);
    c = rotate(c, (unsigned int)30);
  };
  {
    e += (b ^ c ^ d) + (W[hook(5, 30 & 15)] = rotate(W[hook(5, (30 + 13) & 15)] ^ W[hook(5, (30 + 8) & 15)] ^ W[hook(5, (30 + 2) & 15)] ^ W[hook(5, 30 & 15)], (unsigned int)1)) + 0x6ED9EBA1 + rotate(a, (unsigned int)5);
    b = rotate(b, (unsigned int)30);
  };
  {
    d += (a ^ b ^ c) + (W[hook(5, 31 & 15)] = rotate(W[hook(5, (31 + 13) & 15)] ^ W[hook(5, (31 + 8) & 15)] ^ W[hook(5, (31 + 2) & 15)] ^ W[hook(5, 31 & 15)], (unsigned int)1)) + 0x6ED9EBA1 + rotate(e, (unsigned int)5);
    a = rotate(a, (unsigned int)30);
  };
  {
    c += (e ^ a ^ b) + (W[hook(5, 32 & 15)] = rotate(W[hook(5, (32 + 13) & 15)] ^ W[hook(5, (32 + 8) & 15)] ^ W[hook(5, (32 + 2) & 15)] ^ W[hook(5, 32 & 15)], (unsigned int)1)) + 0x6ED9EBA1 + rotate(d, (unsigned int)5);
    e = rotate(e, (unsigned int)30);
  };
  {
    b += (d ^ e ^ a) + (W[hook(5, 33 & 15)] = rotate(W[hook(5, (33 + 13) & 15)] ^ W[hook(5, (33 + 8) & 15)] ^ W[hook(5, (33 + 2) & 15)] ^ W[hook(5, 33 & 15)], (unsigned int)1)) + 0x6ED9EBA1 + rotate(c, (unsigned int)5);
    d = rotate(d, (unsigned int)30);
  };
  {
    a += (c ^ d ^ e) + (W[hook(5, 34 & 15)] = rotate(W[hook(5, (34 + 13) & 15)] ^ W[hook(5, (34 + 8) & 15)] ^ W[hook(5, (34 + 2) & 15)] ^ W[hook(5, 34 & 15)], (unsigned int)1)) + 0x6ED9EBA1 + rotate(b, (unsigned int)5);
    c = rotate(c, (unsigned int)30);
  };
  {
    e += (b ^ c ^ d) + (W[hook(5, 35 & 15)] = rotate(W[hook(5, (35 + 13) & 15)] ^ W[hook(5, (35 + 8) & 15)] ^ W[hook(5, (35 + 2) & 15)] ^ W[hook(5, 35 & 15)], (unsigned int)1)) + 0x6ED9EBA1 + rotate(a, (unsigned int)5);
    b = rotate(b, (unsigned int)30);
  };
  {
    d += (a ^ b ^ c) + (W[hook(5, 36 & 15)] = rotate(W[hook(5, (36 + 13) & 15)] ^ W[hook(5, (36 + 8) & 15)] ^ W[hook(5, (36 + 2) & 15)] ^ W[hook(5, 36 & 15)], (unsigned int)1)) + 0x6ED9EBA1 + rotate(e, (unsigned int)5);
    a = rotate(a, (unsigned int)30);
  };
  {
    c += (e ^ a ^ b) + (W[hook(5, 37 & 15)] = rotate(W[hook(5, (37 + 13) & 15)] ^ W[hook(5, (37 + 8) & 15)] ^ W[hook(5, (37 + 2) & 15)] ^ W[hook(5, 37 & 15)], (unsigned int)1)) + 0x6ED9EBA1 + rotate(d, (unsigned int)5);
    e = rotate(e, (unsigned int)30);
  };
  {
    b += (d ^ e ^ a) + (W[hook(5, 38 & 15)] = rotate(W[hook(5, (38 + 13) & 15)] ^ W[hook(5, (38 + 8) & 15)] ^ W[hook(5, (38 + 2) & 15)] ^ W[hook(5, 38 & 15)], (unsigned int)1)) + 0x6ED9EBA1 + rotate(c, (unsigned int)5);
    d = rotate(d, (unsigned int)30);
  };
  {
    a += (c ^ d ^ e) + (W[hook(5, 39 & 15)] = rotate(W[hook(5, (39 + 13) & 15)] ^ W[hook(5, (39 + 8) & 15)] ^ W[hook(5, (39 + 2) & 15)] ^ W[hook(5, 39 & 15)], (unsigned int)1)) + 0x6ED9EBA1 + rotate(b, (unsigned int)5);
    c = rotate(c, (unsigned int)30);
  };

  {
    e += bitselect(d, c, (b ^ d)) + (W[hook(5, 40 & 15)] = rotate(W[hook(5, (40 + 13) & 15)] ^ W[hook(5, (40 + 8) & 15)] ^ W[hook(5, (40 + 2) & 15)] ^ W[hook(5, 40 & 15)], (unsigned int)1)) + 0x8F1BBCDC + rotate(a, (unsigned int)5);
    b = rotate(b, (unsigned int)30);
  };
  {
    d += bitselect(c, b, (a ^ c)) + (W[hook(5, 41 & 15)] = rotate(W[hook(5, (41 + 13) & 15)] ^ W[hook(5, (41 + 8) & 15)] ^ W[hook(5, (41 + 2) & 15)] ^ W[hook(5, 41 & 15)], (unsigned int)1)) + 0x8F1BBCDC + rotate(e, (unsigned int)5);
    a = rotate(a, (unsigned int)30);
  };
  {
    c += bitselect(b, a, (e ^ b)) + (W[hook(5, 42 & 15)] = rotate(W[hook(5, (42 + 13) & 15)] ^ W[hook(5, (42 + 8) & 15)] ^ W[hook(5, (42 + 2) & 15)] ^ W[hook(5, 42 & 15)], (unsigned int)1)) + 0x8F1BBCDC + rotate(d, (unsigned int)5);
    e = rotate(e, (unsigned int)30);
  };
  {
    b += bitselect(a, e, (d ^ a)) + (W[hook(5, 43 & 15)] = rotate(W[hook(5, (43 + 13) & 15)] ^ W[hook(5, (43 + 8) & 15)] ^ W[hook(5, (43 + 2) & 15)] ^ W[hook(5, 43 & 15)], (unsigned int)1)) + 0x8F1BBCDC + rotate(c, (unsigned int)5);
    d = rotate(d, (unsigned int)30);
  };
  {
    a += bitselect(e, d, (c ^ e)) + (W[hook(5, 44 & 15)] = rotate(W[hook(5, (44 + 13) & 15)] ^ W[hook(5, (44 + 8) & 15)] ^ W[hook(5, (44 + 2) & 15)] ^ W[hook(5, 44 & 15)], (unsigned int)1)) + 0x8F1BBCDC + rotate(b, (unsigned int)5);
    c = rotate(c, (unsigned int)30);
  };
  {
    e += bitselect(d, c, (b ^ d)) + (W[hook(5, 45 & 15)] = rotate(W[hook(5, (45 + 13) & 15)] ^ W[hook(5, (45 + 8) & 15)] ^ W[hook(5, (45 + 2) & 15)] ^ W[hook(5, 45 & 15)], (unsigned int)1)) + 0x8F1BBCDC + rotate(a, (unsigned int)5);
    b = rotate(b, (unsigned int)30);
  };
  {
    d += bitselect(c, b, (a ^ c)) + (W[hook(5, 46 & 15)] = rotate(W[hook(5, (46 + 13) & 15)] ^ W[hook(5, (46 + 8) & 15)] ^ W[hook(5, (46 + 2) & 15)] ^ W[hook(5, 46 & 15)], (unsigned int)1)) + 0x8F1BBCDC + rotate(e, (unsigned int)5);
    a = rotate(a, (unsigned int)30);
  };
  {
    c += bitselect(b, a, (e ^ b)) + (W[hook(5, 47 & 15)] = rotate(W[hook(5, (47 + 13) & 15)] ^ W[hook(5, (47 + 8) & 15)] ^ W[hook(5, (47 + 2) & 15)] ^ W[hook(5, 47 & 15)], (unsigned int)1)) + 0x8F1BBCDC + rotate(d, (unsigned int)5);
    e = rotate(e, (unsigned int)30);
  };
  {
    b += bitselect(a, e, (d ^ a)) + (W[hook(5, 48 & 15)] = rotate(W[hook(5, (48 + 13) & 15)] ^ W[hook(5, (48 + 8) & 15)] ^ W[hook(5, (48 + 2) & 15)] ^ W[hook(5, 48 & 15)], (unsigned int)1)) + 0x8F1BBCDC + rotate(c, (unsigned int)5);
    d = rotate(d, (unsigned int)30);
  };
  {
    a += bitselect(e, d, (c ^ e)) + (W[hook(5, 49 & 15)] = rotate(W[hook(5, (49 + 13) & 15)] ^ W[hook(5, (49 + 8) & 15)] ^ W[hook(5, (49 + 2) & 15)] ^ W[hook(5, 49 & 15)], (unsigned int)1)) + 0x8F1BBCDC + rotate(b, (unsigned int)5);
    c = rotate(c, (unsigned int)30);
  };
  {
    e += bitselect(d, c, (b ^ d)) + (W[hook(5, 50 & 15)] = rotate(W[hook(5, (50 + 13) & 15)] ^ W[hook(5, (50 + 8) & 15)] ^ W[hook(5, (50 + 2) & 15)] ^ W[hook(5, 50 & 15)], (unsigned int)1)) + 0x8F1BBCDC + rotate(a, (unsigned int)5);
    b = rotate(b, (unsigned int)30);
  };
  {
    d += bitselect(c, b, (a ^ c)) + (W[hook(5, 51 & 15)] = rotate(W[hook(5, (51 + 13) & 15)] ^ W[hook(5, (51 + 8) & 15)] ^ W[hook(5, (51 + 2) & 15)] ^ W[hook(5, 51 & 15)], (unsigned int)1)) + 0x8F1BBCDC + rotate(e, (unsigned int)5);
    a = rotate(a, (unsigned int)30);
  };
  {
    c += bitselect(b, a, (e ^ b)) + (W[hook(5, 52 & 15)] = rotate(W[hook(5, (52 + 13) & 15)] ^ W[hook(5, (52 + 8) & 15)] ^ W[hook(5, (52 + 2) & 15)] ^ W[hook(5, 52 & 15)], (unsigned int)1)) + 0x8F1BBCDC + rotate(d, (unsigned int)5);
    e = rotate(e, (unsigned int)30);
  };
  {
    b += bitselect(a, e, (d ^ a)) + (W[hook(5, 53 & 15)] = rotate(W[hook(5, (53 + 13) & 15)] ^ W[hook(5, (53 + 8) & 15)] ^ W[hook(5, (53 + 2) & 15)] ^ W[hook(5, 53 & 15)], (unsigned int)1)) + 0x8F1BBCDC + rotate(c, (unsigned int)5);
    d = rotate(d, (unsigned int)30);
  };
  {
    a += bitselect(e, d, (c ^ e)) + (W[hook(5, 54 & 15)] = rotate(W[hook(5, (54 + 13) & 15)] ^ W[hook(5, (54 + 8) & 15)] ^ W[hook(5, (54 + 2) & 15)] ^ W[hook(5, 54 & 15)], (unsigned int)1)) + 0x8F1BBCDC + rotate(b, (unsigned int)5);
    c = rotate(c, (unsigned int)30);
  };
  {
    e += bitselect(d, c, (b ^ d)) + (W[hook(5, 55 & 15)] = rotate(W[hook(5, (55 + 13) & 15)] ^ W[hook(5, (55 + 8) & 15)] ^ W[hook(5, (55 + 2) & 15)] ^ W[hook(5, 55 & 15)], (unsigned int)1)) + 0x8F1BBCDC + rotate(a, (unsigned int)5);
    b = rotate(b, (unsigned int)30);
  };
  {
    d += bitselect(c, b, (a ^ c)) + (W[hook(5, 56 & 15)] = rotate(W[hook(5, (56 + 13) & 15)] ^ W[hook(5, (56 + 8) & 15)] ^ W[hook(5, (56 + 2) & 15)] ^ W[hook(5, 56 & 15)], (unsigned int)1)) + 0x8F1BBCDC + rotate(e, (unsigned int)5);
    a = rotate(a, (unsigned int)30);
  };
  {
    c += bitselect(b, a, (e ^ b)) + (W[hook(5, 57 & 15)] = rotate(W[hook(5, (57 + 13) & 15)] ^ W[hook(5, (57 + 8) & 15)] ^ W[hook(5, (57 + 2) & 15)] ^ W[hook(5, 57 & 15)], (unsigned int)1)) + 0x8F1BBCDC + rotate(d, (unsigned int)5);
    e = rotate(e, (unsigned int)30);
  };
  {
    b += bitselect(a, e, (d ^ a)) + (W[hook(5, 58 & 15)] = rotate(W[hook(5, (58 + 13) & 15)] ^ W[hook(5, (58 + 8) & 15)] ^ W[hook(5, (58 + 2) & 15)] ^ W[hook(5, 58 & 15)], (unsigned int)1)) + 0x8F1BBCDC + rotate(c, (unsigned int)5);
    d = rotate(d, (unsigned int)30);
  };
  {
    a += bitselect(e, d, (c ^ e)) + (W[hook(5, 59 & 15)] = rotate(W[hook(5, (59 + 13) & 15)] ^ W[hook(5, (59 + 8) & 15)] ^ W[hook(5, (59 + 2) & 15)] ^ W[hook(5, 59 & 15)], (unsigned int)1)) + 0x8F1BBCDC + rotate(b, (unsigned int)5);
    c = rotate(c, (unsigned int)30);
  };

  {
    e += (b ^ c ^ d) + (W[hook(5, 60 & 15)] = rotate(W[hook(5, (60 + 13) & 15)] ^ W[hook(5, (60 + 8) & 15)] ^ W[hook(5, (60 + 2) & 15)] ^ W[hook(5, 60 & 15)], (unsigned int)1)) + 0xCA62C1D6 + rotate(a, (unsigned int)5);
    b = rotate(b, (unsigned int)30);
  };
  {
    d += (a ^ b ^ c) + (W[hook(5, 61 & 15)] = rotate(W[hook(5, (61 + 13) & 15)] ^ W[hook(5, (61 + 8) & 15)] ^ W[hook(5, (61 + 2) & 15)] ^ W[hook(5, 61 & 15)], (unsigned int)1)) + 0xCA62C1D6 + rotate(e, (unsigned int)5);
    a = rotate(a, (unsigned int)30);
  };
  {
    c += (e ^ a ^ b) + (W[hook(5, 62 & 15)] = rotate(W[hook(5, (62 + 13) & 15)] ^ W[hook(5, (62 + 8) & 15)] ^ W[hook(5, (62 + 2) & 15)] ^ W[hook(5, 62 & 15)], (unsigned int)1)) + 0xCA62C1D6 + rotate(d, (unsigned int)5);
    e = rotate(e, (unsigned int)30);
  };
  {
    b += (d ^ e ^ a) + (W[hook(5, 63 & 15)] = rotate(W[hook(5, (63 + 13) & 15)] ^ W[hook(5, (63 + 8) & 15)] ^ W[hook(5, (63 + 2) & 15)] ^ W[hook(5, 63 & 15)], (unsigned int)1)) + 0xCA62C1D6 + rotate(c, (unsigned int)5);
    d = rotate(d, (unsigned int)30);
  };
  {
    a += (c ^ d ^ e) + (W[hook(5, 64 & 15)] = rotate(W[hook(5, (64 + 13) & 15)] ^ W[hook(5, (64 + 8) & 15)] ^ W[hook(5, (64 + 2) & 15)] ^ W[hook(5, 64 & 15)], (unsigned int)1)) + 0xCA62C1D6 + rotate(b, (unsigned int)5);
    c = rotate(c, (unsigned int)30);
  };
  {
    e += (b ^ c ^ d) + (W[hook(5, 65 & 15)] = rotate(W[hook(5, (65 + 13) & 15)] ^ W[hook(5, (65 + 8) & 15)] ^ W[hook(5, (65 + 2) & 15)] ^ W[hook(5, 65 & 15)], (unsigned int)1)) + 0xCA62C1D6 + rotate(a, (unsigned int)5);
    b = rotate(b, (unsigned int)30);
  };
  {
    d += (a ^ b ^ c) + (W[hook(5, 66 & 15)] = rotate(W[hook(5, (66 + 13) & 15)] ^ W[hook(5, (66 + 8) & 15)] ^ W[hook(5, (66 + 2) & 15)] ^ W[hook(5, 66 & 15)], (unsigned int)1)) + 0xCA62C1D6 + rotate(e, (unsigned int)5);
    a = rotate(a, (unsigned int)30);
  };
  {
    c += (e ^ a ^ b) + (W[hook(5, 67 & 15)] = rotate(W[hook(5, (67 + 13) & 15)] ^ W[hook(5, (67 + 8) & 15)] ^ W[hook(5, (67 + 2) & 15)] ^ W[hook(5, 67 & 15)], (unsigned int)1)) + 0xCA62C1D6 + rotate(d, (unsigned int)5);
    e = rotate(e, (unsigned int)30);
  };
  {
    b += (d ^ e ^ a) + (W[hook(5, 68 & 15)] = rotate(W[hook(5, (68 + 13) & 15)] ^ W[hook(5, (68 + 8) & 15)] ^ W[hook(5, (68 + 2) & 15)] ^ W[hook(5, 68 & 15)], (unsigned int)1)) + 0xCA62C1D6 + rotate(c, (unsigned int)5);
    d = rotate(d, (unsigned int)30);
  };
  {
    a += (c ^ d ^ e) + (W[hook(5, 69 & 15)] = rotate(W[hook(5, (69 + 13) & 15)] ^ W[hook(5, (69 + 8) & 15)] ^ W[hook(5, (69 + 2) & 15)] ^ W[hook(5, 69 & 15)], (unsigned int)1)) + 0xCA62C1D6 + rotate(b, (unsigned int)5);
    c = rotate(c, (unsigned int)30);
  };
  {
    e += (b ^ c ^ d) + (W[hook(5, 70 & 15)] = rotate(W[hook(5, (70 + 13) & 15)] ^ W[hook(5, (70 + 8) & 15)] ^ W[hook(5, (70 + 2) & 15)] ^ W[hook(5, 70 & 15)], (unsigned int)1)) + 0xCA62C1D6 + rotate(a, (unsigned int)5);
    b = rotate(b, (unsigned int)30);
  };
  {
    d += (a ^ b ^ c) + (W[hook(5, 71 & 15)] = rotate(W[hook(5, (71 + 13) & 15)] ^ W[hook(5, (71 + 8) & 15)] ^ W[hook(5, (71 + 2) & 15)] ^ W[hook(5, 71 & 15)], (unsigned int)1)) + 0xCA62C1D6 + rotate(e, (unsigned int)5);
    a = rotate(a, (unsigned int)30);
  };
  {
    c += (e ^ a ^ b) + (W[hook(5, 72 & 15)] = rotate(W[hook(5, (72 + 13) & 15)] ^ W[hook(5, (72 + 8) & 15)] ^ W[hook(5, (72 + 2) & 15)] ^ W[hook(5, 72 & 15)], (unsigned int)1)) + 0xCA62C1D6 + rotate(d, (unsigned int)5);
    e = rotate(e, (unsigned int)30);
  };
  {
    b += (d ^ e ^ a) + (W[hook(5, 73 & 15)] = rotate(W[hook(5, (73 + 13) & 15)] ^ W[hook(5, (73 + 8) & 15)] ^ W[hook(5, (73 + 2) & 15)] ^ W[hook(5, 73 & 15)], (unsigned int)1)) + 0xCA62C1D6 + rotate(c, (unsigned int)5);
    d = rotate(d, (unsigned int)30);
  };
  {
    a += (c ^ d ^ e) + (W[hook(5, 74 & 15)] = rotate(W[hook(5, (74 + 13) & 15)] ^ W[hook(5, (74 + 8) & 15)] ^ W[hook(5, (74 + 2) & 15)] ^ W[hook(5, 74 & 15)], (unsigned int)1)) + 0xCA62C1D6 + rotate(b, (unsigned int)5);
    c = rotate(c, (unsigned int)30);
  };
  {
    e += (b ^ c ^ d) + (W[hook(5, 75 & 15)] = rotate(W[hook(5, (75 + 13) & 15)] ^ W[hook(5, (75 + 8) & 15)] ^ W[hook(5, (75 + 2) & 15)] ^ W[hook(5, 75 & 15)], (unsigned int)1)) + 0xCA62C1D6 + rotate(a, (unsigned int)5);
    b = rotate(b, (unsigned int)30);
  };
  {
    d += (a ^ b ^ c) + (W[hook(5, 76 & 15)] = rotate(W[hook(5, (76 + 13) & 15)] ^ W[hook(5, (76 + 8) & 15)] ^ W[hook(5, (76 + 2) & 15)] ^ W[hook(5, 76 & 15)], (unsigned int)1)) + 0xCA62C1D6 + rotate(e, (unsigned int)5);
    a = rotate(a, (unsigned int)30);
  };
  {
    c += (e ^ a ^ b) + (W[hook(5, 77 & 15)] = rotate(W[hook(5, (77 + 13) & 15)] ^ W[hook(5, (77 + 8) & 15)] ^ W[hook(5, (77 + 2) & 15)] ^ W[hook(5, 77 & 15)], (unsigned int)1)) + 0xCA62C1D6 + rotate(d, (unsigned int)5);
    e = rotate(e, (unsigned int)30);
  };
  {
    b += (d ^ e ^ a) + (W[hook(5, 78 & 15)] = rotate(W[hook(5, (78 + 13) & 15)] ^ W[hook(5, (78 + 8) & 15)] ^ W[hook(5, (78 + 2) & 15)] ^ W[hook(5, 78 & 15)], (unsigned int)1)) + 0xCA62C1D6 + rotate(c, (unsigned int)5);
    d = rotate(d, (unsigned int)30);
  };
  {
    a += (c ^ d ^ e) + (W[hook(5, 79 & 15)] = rotate(W[hook(5, (79 + 13) & 15)] ^ W[hook(5, (79 + 8) & 15)] ^ W[hook(5, (79 + 2) & 15)] ^ W[hook(5, 79 & 15)], (unsigned int)1)) + 0xCA62C1D6 + rotate(b, (unsigned int)5);
    c = rotate(c, (unsigned int)30);
  };

  hash[hook(4, 0)] += a;
  hash[hook(4, 1)] += b;
  hash[hook(4, 2)] += c;
  hash[hook(4, 3)] += d;
  hash[hook(4, 4)] += e;

  a = hash[hook(4, 0)];
  b = hash[hook(4, 1)];
  c = hash[hook(4, 2)];
  d = hash[hook(4, 3)];
  e = hash[hook(4, 4)];

  W[hook(5, 0)] = __builtin_astype((__builtin_astype((*(const global unsigned int*)(input + 64)), uchar4).wzyx), unsigned int);
  W[hook(5, 1)] = __builtin_astype((__builtin_astype((*(const global unsigned int*)(input + 68)), uchar4).wzyx), unsigned int);
  W[hook(5, 2)] = __builtin_astype((__builtin_astype((*(const global unsigned int*)(input + 72)), uchar4).wzyx), unsigned int);

  W[hook(5, 3)] = __builtin_astype((__builtin_astype((gid), uchar4).wzyx), unsigned int);
  W[hook(5, 4)] = 0x80000000;

  W[hook(5, 15)] = 640;

  {
    e += bitselect(d, c, b) + W[hook(5, 0)] + 0x5A827999 + rotate(a, (unsigned int)5);
    b = rotate(b, (unsigned int)30);
  };
  {
    d += bitselect(c, b, a) + W[hook(5, 1)] + 0x5A827999 + rotate(e, (unsigned int)5);
    a = rotate(a, (unsigned int)30);
  };
  {
    c += bitselect(b, a, e) + W[hook(5, 2)] + 0x5A827999 + rotate(d, (unsigned int)5);
    e = rotate(e, (unsigned int)30);
  };
  {
    b += bitselect(a, e, d) + W[hook(5, 3)] + 0x5A827999 + rotate(c, (unsigned int)5);
    d = rotate(d, (unsigned int)30);
  };
  {
    a += bitselect(e, d, c) + W[hook(5, 4)] + 0x5A827999 + rotate(b, (unsigned int)5);
    c = rotate(c, (unsigned int)30);
  };
  {
    e += bitselect(d, c, b) + 0x5A827999 + rotate(a, (unsigned int)5);
    b = rotate(b, (unsigned int)30);
  };
  {
    d += bitselect(c, b, a) + 0x5A827999 + rotate(e, (unsigned int)5);
    a = rotate(a, (unsigned int)30);
  };
  {
    c += bitselect(b, a, e) + 0x5A827999 + rotate(d, (unsigned int)5);
    e = rotate(e, (unsigned int)30);
  };
  {
    b += bitselect(a, e, d) + 0x5A827999 + rotate(c, (unsigned int)5);
    d = rotate(d, (unsigned int)30);
  };
  {
    a += bitselect(e, d, c) + 0x5A827999 + rotate(b, (unsigned int)5);
    c = rotate(c, (unsigned int)30);
  };
  {
    e += bitselect(d, c, b) + 0x5A827999 + rotate(a, (unsigned int)5);
    b = rotate(b, (unsigned int)30);
  };
  {
    d += bitselect(c, b, a) + 0x5A827999 + rotate(e, (unsigned int)5);
    a = rotate(a, (unsigned int)30);
  };
  {
    c += bitselect(b, a, e) + 0x5A827999 + rotate(d, (unsigned int)5);
    e = rotate(e, (unsigned int)30);
  };
  {
    b += bitselect(a, e, d) + 0x5A827999 + rotate(c, (unsigned int)5);
    d = rotate(d, (unsigned int)30);
  };
  {
    a += bitselect(e, d, c) + 0x5A827999 + rotate(b, (unsigned int)5);
    c = rotate(c, (unsigned int)30);
  };
  {
    e += bitselect(d, c, b) + W[hook(5, 15)] + 0x5A827999 + rotate(a, (unsigned int)5);
    b = rotate(b, (unsigned int)30);
  };

  W[hook(5, 0)] = rotate(W[hook(5, 2)] ^ W[hook(5, 0)], (unsigned int)1);
  {
    d += bitselect(c, b, a) + W[hook(5, 0)] + 0x5A827999 + rotate(e, (unsigned int)5);
    a = rotate(a, (unsigned int)30);
  };

  W[hook(5, 1)] = rotate(W[hook(5, 3)] ^ W[hook(5, 1)], (unsigned int)1);
  {
    c += bitselect(b, a, e) + W[hook(5, 1)] + 0x5A827999 + rotate(d, (unsigned int)5);
    e = rotate(e, (unsigned int)30);
  };

  W[hook(5, 2)] = rotate(W[hook(5, 15)] ^ W[hook(5, 4)] ^ W[hook(5, 2)], (unsigned int)1);
  {
    b += bitselect(a, e, d) + W[hook(5, 2)] + 0x5A827999 + rotate(c, (unsigned int)5);
    d = rotate(d, (unsigned int)30);
  };

  W[hook(5, 3)] = rotate(W[hook(5, 0)] ^ W[hook(5, 3)], (unsigned int)1);
  {
    a += bitselect(e, d, c) + W[hook(5, 3)] + 0x5A827999 + rotate(b, (unsigned int)5);
    c = rotate(c, (unsigned int)30);
  };

  W[hook(5, 4)] = rotate(W[hook(5, 1)] ^ W[hook(5, 4)], (unsigned int)1);
  {
    e += (b ^ c ^ d) + W[hook(5, 4)] + 0x6ED9EBA1 + rotate(a, (unsigned int)5);
    b = rotate(b, (unsigned int)30);
  };

  W[hook(5, 5)] = rotate(W[hook(5, 2)], (unsigned int)1);
  {
    d += (a ^ b ^ c) + W[hook(5, 5)] + 0x6ED9EBA1 + rotate(e, (unsigned int)5);
    a = rotate(a, (unsigned int)30);
  };

  W[hook(5, 6)] = rotate(W[hook(5, 3)], (unsigned int)1);
  {
    c += (e ^ a ^ b) + W[hook(5, 6)] + 0x6ED9EBA1 + rotate(d, (unsigned int)5);
    e = rotate(e, (unsigned int)30);
  };

  W[hook(5, 7)] = rotate(W[hook(5, 4)] ^ W[hook(5, 15)], (unsigned int)1);
  {
    b += (d ^ e ^ a) + W[hook(5, 7)] + 0x6ED9EBA1 + rotate(c, (unsigned int)5);
    d = rotate(d, (unsigned int)30);
  };

  W[hook(5, 8)] = rotate(W[hook(5, 5)] ^ W[hook(5, 0)], (unsigned int)1);
  {
    a += (c ^ d ^ e) + W[hook(5, 8)] + 0x6ED9EBA1 + rotate(b, (unsigned int)5);
    c = rotate(c, (unsigned int)30);
  };

  W[hook(5, 9)] = rotate(W[hook(5, 6)] ^ W[hook(5, 1)], (unsigned int)1);
  {
    e += (b ^ c ^ d) + W[hook(5, 9)] + 0x6ED9EBA1 + rotate(a, (unsigned int)5);
    b = rotate(b, (unsigned int)30);
  };

  W[hook(5, 10)] = rotate(W[hook(5, 7)] ^ W[hook(5, 2)], (unsigned int)1);
  {
    d += (a ^ b ^ c) + W[hook(5, 10)] + 0x6ED9EBA1 + rotate(e, (unsigned int)5);
    a = rotate(a, (unsigned int)30);
  };

  W[hook(5, 11)] = rotate(W[hook(5, 8)] ^ W[hook(5, 3)], (unsigned int)1);
  {
    c += (e ^ a ^ b) + W[hook(5, 11)] + 0x6ED9EBA1 + rotate(d, (unsigned int)5);
    e = rotate(e, (unsigned int)30);
  };

  W[hook(5, 12)] = rotate(W[hook(5, 9)] ^ W[hook(5, 4)], (unsigned int)1);
  {
    b += (d ^ e ^ a) + W[hook(5, 12)] + 0x6ED9EBA1 + rotate(c, (unsigned int)5);
    d = rotate(d, (unsigned int)30);
  };

  W[hook(5, 13)] = rotate(W[hook(5, 10)] ^ W[hook(5, 5)] ^ W[hook(5, 15)], (unsigned int)1);
  {
    a += (c ^ d ^ e) + W[hook(5, 13)] + 0x6ED9EBA1 + rotate(b, (unsigned int)5);
    c = rotate(c, (unsigned int)30);
  };

  W[hook(5, 14)] = rotate(W[hook(5, 11)] ^ W[hook(5, 6)] ^ W[hook(5, 0)], (unsigned int)1);
  {
    e += (b ^ c ^ d) + W[hook(5, 14)] + 0x6ED9EBA1 + rotate(a, (unsigned int)5);
    b = rotate(b, (unsigned int)30);
  };

  W[hook(5, 15)] = rotate(W[hook(5, 12)] ^ W[hook(5, 7)] ^ W[hook(5, 1)] ^ W[hook(5, 15)], (unsigned int)1);
  {
    d += (a ^ b ^ c) + W[hook(5, 15)] + 0x6ED9EBA1 + rotate(e, (unsigned int)5);
    a = rotate(a, (unsigned int)30);
  };

  {
    c += (e ^ a ^ b) + (W[hook(5, 32 & 15)] = rotate(W[hook(5, (32 + 13) & 15)] ^ W[hook(5, (32 + 8) & 15)] ^ W[hook(5, (32 + 2) & 15)] ^ W[hook(5, 32 & 15)], (unsigned int)1)) + 0x6ED9EBA1 + rotate(d, (unsigned int)5);
    e = rotate(e, (unsigned int)30);
  };
  {
    b += (d ^ e ^ a) + (W[hook(5, 33 & 15)] = rotate(W[hook(5, (33 + 13) & 15)] ^ W[hook(5, (33 + 8) & 15)] ^ W[hook(5, (33 + 2) & 15)] ^ W[hook(5, 33 & 15)], (unsigned int)1)) + 0x6ED9EBA1 + rotate(c, (unsigned int)5);
    d = rotate(d, (unsigned int)30);
  };
  {
    a += (c ^ d ^ e) + (W[hook(5, 34 & 15)] = rotate(W[hook(5, (34 + 13) & 15)] ^ W[hook(5, (34 + 8) & 15)] ^ W[hook(5, (34 + 2) & 15)] ^ W[hook(5, 34 & 15)], (unsigned int)1)) + 0x6ED9EBA1 + rotate(b, (unsigned int)5);
    c = rotate(c, (unsigned int)30);
  };
  {
    e += (b ^ c ^ d) + (W[hook(5, 35 & 15)] = rotate(W[hook(5, (35 + 13) & 15)] ^ W[hook(5, (35 + 8) & 15)] ^ W[hook(5, (35 + 2) & 15)] ^ W[hook(5, 35 & 15)], (unsigned int)1)) + 0x6ED9EBA1 + rotate(a, (unsigned int)5);
    b = rotate(b, (unsigned int)30);
  };
  {
    d += (a ^ b ^ c) + (W[hook(5, 36 & 15)] = rotate(W[hook(5, (36 + 13) & 15)] ^ W[hook(5, (36 + 8) & 15)] ^ W[hook(5, (36 + 2) & 15)] ^ W[hook(5, 36 & 15)], (unsigned int)1)) + 0x6ED9EBA1 + rotate(e, (unsigned int)5);
    a = rotate(a, (unsigned int)30);
  };
  {
    c += (e ^ a ^ b) + (W[hook(5, 37 & 15)] = rotate(W[hook(5, (37 + 13) & 15)] ^ W[hook(5, (37 + 8) & 15)] ^ W[hook(5, (37 + 2) & 15)] ^ W[hook(5, 37 & 15)], (unsigned int)1)) + 0x6ED9EBA1 + rotate(d, (unsigned int)5);
    e = rotate(e, (unsigned int)30);
  };
  {
    b += (d ^ e ^ a) + (W[hook(5, 38 & 15)] = rotate(W[hook(5, (38 + 13) & 15)] ^ W[hook(5, (38 + 8) & 15)] ^ W[hook(5, (38 + 2) & 15)] ^ W[hook(5, 38 & 15)], (unsigned int)1)) + 0x6ED9EBA1 + rotate(c, (unsigned int)5);
    d = rotate(d, (unsigned int)30);
  };
  {
    a += (c ^ d ^ e) + (W[hook(5, 39 & 15)] = rotate(W[hook(5, (39 + 13) & 15)] ^ W[hook(5, (39 + 8) & 15)] ^ W[hook(5, (39 + 2) & 15)] ^ W[hook(5, 39 & 15)], (unsigned int)1)) + 0x6ED9EBA1 + rotate(b, (unsigned int)5);
    c = rotate(c, (unsigned int)30);
  };

  {
    e += bitselect(d, c, (b ^ d)) + (W[hook(5, 40 & 15)] = rotate(W[hook(5, (40 + 13) & 15)] ^ W[hook(5, (40 + 8) & 15)] ^ W[hook(5, (40 + 2) & 15)] ^ W[hook(5, 40 & 15)], (unsigned int)1)) + 0x8F1BBCDC + rotate(a, (unsigned int)5);
    b = rotate(b, (unsigned int)30);
  };
  {
    d += bitselect(c, b, (a ^ c)) + (W[hook(5, 41 & 15)] = rotate(W[hook(5, (41 + 13) & 15)] ^ W[hook(5, (41 + 8) & 15)] ^ W[hook(5, (41 + 2) & 15)] ^ W[hook(5, 41 & 15)], (unsigned int)1)) + 0x8F1BBCDC + rotate(e, (unsigned int)5);
    a = rotate(a, (unsigned int)30);
  };
  {
    c += bitselect(b, a, (e ^ b)) + (W[hook(5, 42 & 15)] = rotate(W[hook(5, (42 + 13) & 15)] ^ W[hook(5, (42 + 8) & 15)] ^ W[hook(5, (42 + 2) & 15)] ^ W[hook(5, 42 & 15)], (unsigned int)1)) + 0x8F1BBCDC + rotate(d, (unsigned int)5);
    e = rotate(e, (unsigned int)30);
  };
  {
    b += bitselect(a, e, (d ^ a)) + (W[hook(5, 43 & 15)] = rotate(W[hook(5, (43 + 13) & 15)] ^ W[hook(5, (43 + 8) & 15)] ^ W[hook(5, (43 + 2) & 15)] ^ W[hook(5, 43 & 15)], (unsigned int)1)) + 0x8F1BBCDC + rotate(c, (unsigned int)5);
    d = rotate(d, (unsigned int)30);
  };
  {
    a += bitselect(e, d, (c ^ e)) + (W[hook(5, 44 & 15)] = rotate(W[hook(5, (44 + 13) & 15)] ^ W[hook(5, (44 + 8) & 15)] ^ W[hook(5, (44 + 2) & 15)] ^ W[hook(5, 44 & 15)], (unsigned int)1)) + 0x8F1BBCDC + rotate(b, (unsigned int)5);
    c = rotate(c, (unsigned int)30);
  };
  {
    e += bitselect(d, c, (b ^ d)) + (W[hook(5, 45 & 15)] = rotate(W[hook(5, (45 + 13) & 15)] ^ W[hook(5, (45 + 8) & 15)] ^ W[hook(5, (45 + 2) & 15)] ^ W[hook(5, 45 & 15)], (unsigned int)1)) + 0x8F1BBCDC + rotate(a, (unsigned int)5);
    b = rotate(b, (unsigned int)30);
  };
  {
    d += bitselect(c, b, (a ^ c)) + (W[hook(5, 46 & 15)] = rotate(W[hook(5, (46 + 13) & 15)] ^ W[hook(5, (46 + 8) & 15)] ^ W[hook(5, (46 + 2) & 15)] ^ W[hook(5, 46 & 15)], (unsigned int)1)) + 0x8F1BBCDC + rotate(e, (unsigned int)5);
    a = rotate(a, (unsigned int)30);
  };
  {
    c += bitselect(b, a, (e ^ b)) + (W[hook(5, 47 & 15)] = rotate(W[hook(5, (47 + 13) & 15)] ^ W[hook(5, (47 + 8) & 15)] ^ W[hook(5, (47 + 2) & 15)] ^ W[hook(5, 47 & 15)], (unsigned int)1)) + 0x8F1BBCDC + rotate(d, (unsigned int)5);
    e = rotate(e, (unsigned int)30);
  };
  {
    b += bitselect(a, e, (d ^ a)) + (W[hook(5, 48 & 15)] = rotate(W[hook(5, (48 + 13) & 15)] ^ W[hook(5, (48 + 8) & 15)] ^ W[hook(5, (48 + 2) & 15)] ^ W[hook(5, 48 & 15)], (unsigned int)1)) + 0x8F1BBCDC + rotate(c, (unsigned int)5);
    d = rotate(d, (unsigned int)30);
  };
  {
    a += bitselect(e, d, (c ^ e)) + (W[hook(5, 49 & 15)] = rotate(W[hook(5, (49 + 13) & 15)] ^ W[hook(5, (49 + 8) & 15)] ^ W[hook(5, (49 + 2) & 15)] ^ W[hook(5, 49 & 15)], (unsigned int)1)) + 0x8F1BBCDC + rotate(b, (unsigned int)5);
    c = rotate(c, (unsigned int)30);
  };
  {
    e += bitselect(d, c, (b ^ d)) + (W[hook(5, 50 & 15)] = rotate(W[hook(5, (50 + 13) & 15)] ^ W[hook(5, (50 + 8) & 15)] ^ W[hook(5, (50 + 2) & 15)] ^ W[hook(5, 50 & 15)], (unsigned int)1)) + 0x8F1BBCDC + rotate(a, (unsigned int)5);
    b = rotate(b, (unsigned int)30);
  };
  {
    d += bitselect(c, b, (a ^ c)) + (W[hook(5, 51 & 15)] = rotate(W[hook(5, (51 + 13) & 15)] ^ W[hook(5, (51 + 8) & 15)] ^ W[hook(5, (51 + 2) & 15)] ^ W[hook(5, 51 & 15)], (unsigned int)1)) + 0x8F1BBCDC + rotate(e, (unsigned int)5);
    a = rotate(a, (unsigned int)30);
  };
  {
    c += bitselect(b, a, (e ^ b)) + (W[hook(5, 52 & 15)] = rotate(W[hook(5, (52 + 13) & 15)] ^ W[hook(5, (52 + 8) & 15)] ^ W[hook(5, (52 + 2) & 15)] ^ W[hook(5, 52 & 15)], (unsigned int)1)) + 0x8F1BBCDC + rotate(d, (unsigned int)5);
    e = rotate(e, (unsigned int)30);
  };
  {
    b += bitselect(a, e, (d ^ a)) + (W[hook(5, 53 & 15)] = rotate(W[hook(5, (53 + 13) & 15)] ^ W[hook(5, (53 + 8) & 15)] ^ W[hook(5, (53 + 2) & 15)] ^ W[hook(5, 53 & 15)], (unsigned int)1)) + 0x8F1BBCDC + rotate(c, (unsigned int)5);
    d = rotate(d, (unsigned int)30);
  };
  {
    a += bitselect(e, d, (c ^ e)) + (W[hook(5, 54 & 15)] = rotate(W[hook(5, (54 + 13) & 15)] ^ W[hook(5, (54 + 8) & 15)] ^ W[hook(5, (54 + 2) & 15)] ^ W[hook(5, 54 & 15)], (unsigned int)1)) + 0x8F1BBCDC + rotate(b, (unsigned int)5);
    c = rotate(c, (unsigned int)30);
  };
  {
    e += bitselect(d, c, (b ^ d)) + (W[hook(5, 55 & 15)] = rotate(W[hook(5, (55 + 13) & 15)] ^ W[hook(5, (55 + 8) & 15)] ^ W[hook(5, (55 + 2) & 15)] ^ W[hook(5, 55 & 15)], (unsigned int)1)) + 0x8F1BBCDC + rotate(a, (unsigned int)5);
    b = rotate(b, (unsigned int)30);
  };
  {
    d += bitselect(c, b, (a ^ c)) + (W[hook(5, 56 & 15)] = rotate(W[hook(5, (56 + 13) & 15)] ^ W[hook(5, (56 + 8) & 15)] ^ W[hook(5, (56 + 2) & 15)] ^ W[hook(5, 56 & 15)], (unsigned int)1)) + 0x8F1BBCDC + rotate(e, (unsigned int)5);
    a = rotate(a, (unsigned int)30);
  };
  {
    c += bitselect(b, a, (e ^ b)) + (W[hook(5, 57 & 15)] = rotate(W[hook(5, (57 + 13) & 15)] ^ W[hook(5, (57 + 8) & 15)] ^ W[hook(5, (57 + 2) & 15)] ^ W[hook(5, 57 & 15)], (unsigned int)1)) + 0x8F1BBCDC + rotate(d, (unsigned int)5);
    e = rotate(e, (unsigned int)30);
  };
  {
    b += bitselect(a, e, (d ^ a)) + (W[hook(5, 58 & 15)] = rotate(W[hook(5, (58 + 13) & 15)] ^ W[hook(5, (58 + 8) & 15)] ^ W[hook(5, (58 + 2) & 15)] ^ W[hook(5, 58 & 15)], (unsigned int)1)) + 0x8F1BBCDC + rotate(c, (unsigned int)5);
    d = rotate(d, (unsigned int)30);
  };
  {
    a += bitselect(e, d, (c ^ e)) + (W[hook(5, 59 & 15)] = rotate(W[hook(5, (59 + 13) & 15)] ^ W[hook(5, (59 + 8) & 15)] ^ W[hook(5, (59 + 2) & 15)] ^ W[hook(5, 59 & 15)], (unsigned int)1)) + 0x8F1BBCDC + rotate(b, (unsigned int)5);
    c = rotate(c, (unsigned int)30);
  };

  {
    e += (b ^ c ^ d) + (W[hook(5, 60 & 15)] = rotate(W[hook(5, (60 + 13) & 15)] ^ W[hook(5, (60 + 8) & 15)] ^ W[hook(5, (60 + 2) & 15)] ^ W[hook(5, 60 & 15)], (unsigned int)1)) + 0xCA62C1D6 + rotate(a, (unsigned int)5);
    b = rotate(b, (unsigned int)30);
  };
  {
    d += (a ^ b ^ c) + (W[hook(5, 61 & 15)] = rotate(W[hook(5, (61 + 13) & 15)] ^ W[hook(5, (61 + 8) & 15)] ^ W[hook(5, (61 + 2) & 15)] ^ W[hook(5, 61 & 15)], (unsigned int)1)) + 0xCA62C1D6 + rotate(e, (unsigned int)5);
    a = rotate(a, (unsigned int)30);
  };
  {
    c += (e ^ a ^ b) + (W[hook(5, 62 & 15)] = rotate(W[hook(5, (62 + 13) & 15)] ^ W[hook(5, (62 + 8) & 15)] ^ W[hook(5, (62 + 2) & 15)] ^ W[hook(5, 62 & 15)], (unsigned int)1)) + 0xCA62C1D6 + rotate(d, (unsigned int)5);
    e = rotate(e, (unsigned int)30);
  };
  {
    b += (d ^ e ^ a) + (W[hook(5, 63 & 15)] = rotate(W[hook(5, (63 + 13) & 15)] ^ W[hook(5, (63 + 8) & 15)] ^ W[hook(5, (63 + 2) & 15)] ^ W[hook(5, 63 & 15)], (unsigned int)1)) + 0xCA62C1D6 + rotate(c, (unsigned int)5);
    d = rotate(d, (unsigned int)30);
  };
  {
    a += (c ^ d ^ e) + (W[hook(5, 64 & 15)] = rotate(W[hook(5, (64 + 13) & 15)] ^ W[hook(5, (64 + 8) & 15)] ^ W[hook(5, (64 + 2) & 15)] ^ W[hook(5, 64 & 15)], (unsigned int)1)) + 0xCA62C1D6 + rotate(b, (unsigned int)5);
    c = rotate(c, (unsigned int)30);
  };
  {
    e += (b ^ c ^ d) + (W[hook(5, 65 & 15)] = rotate(W[hook(5, (65 + 13) & 15)] ^ W[hook(5, (65 + 8) & 15)] ^ W[hook(5, (65 + 2) & 15)] ^ W[hook(5, 65 & 15)], (unsigned int)1)) + 0xCA62C1D6 + rotate(a, (unsigned int)5);
    b = rotate(b, (unsigned int)30);
  };
  {
    d += (a ^ b ^ c) + (W[hook(5, 66 & 15)] = rotate(W[hook(5, (66 + 13) & 15)] ^ W[hook(5, (66 + 8) & 15)] ^ W[hook(5, (66 + 2) & 15)] ^ W[hook(5, 66 & 15)], (unsigned int)1)) + 0xCA62C1D6 + rotate(e, (unsigned int)5);
    a = rotate(a, (unsigned int)30);
  };
  {
    c += (e ^ a ^ b) + (W[hook(5, 67 & 15)] = rotate(W[hook(5, (67 + 13) & 15)] ^ W[hook(5, (67 + 8) & 15)] ^ W[hook(5, (67 + 2) & 15)] ^ W[hook(5, 67 & 15)], (unsigned int)1)) + 0xCA62C1D6 + rotate(d, (unsigned int)5);
    e = rotate(e, (unsigned int)30);
  };
  {
    b += (d ^ e ^ a) + (W[hook(5, 68 & 15)] = rotate(W[hook(5, (68 + 13) & 15)] ^ W[hook(5, (68 + 8) & 15)] ^ W[hook(5, (68 + 2) & 15)] ^ W[hook(5, 68 & 15)], (unsigned int)1)) + 0xCA62C1D6 + rotate(c, (unsigned int)5);
    d = rotate(d, (unsigned int)30);
  };
  {
    a += (c ^ d ^ e) + (W[hook(5, 69 & 15)] = rotate(W[hook(5, (69 + 13) & 15)] ^ W[hook(5, (69 + 8) & 15)] ^ W[hook(5, (69 + 2) & 15)] ^ W[hook(5, 69 & 15)], (unsigned int)1)) + 0xCA62C1D6 + rotate(b, (unsigned int)5);
    c = rotate(c, (unsigned int)30);
  };
  {
    e += (b ^ c ^ d) + (W[hook(5, 70 & 15)] = rotate(W[hook(5, (70 + 13) & 15)] ^ W[hook(5, (70 + 8) & 15)] ^ W[hook(5, (70 + 2) & 15)] ^ W[hook(5, 70 & 15)], (unsigned int)1)) + 0xCA62C1D6 + rotate(a, (unsigned int)5);
    b = rotate(b, (unsigned int)30);
  };
  {
    d += (a ^ b ^ c) + (W[hook(5, 71 & 15)] = rotate(W[hook(5, (71 + 13) & 15)] ^ W[hook(5, (71 + 8) & 15)] ^ W[hook(5, (71 + 2) & 15)] ^ W[hook(5, 71 & 15)], (unsigned int)1)) + 0xCA62C1D6 + rotate(e, (unsigned int)5);
    a = rotate(a, (unsigned int)30);
  };
  {
    c += (e ^ a ^ b) + (W[hook(5, 72 & 15)] = rotate(W[hook(5, (72 + 13) & 15)] ^ W[hook(5, (72 + 8) & 15)] ^ W[hook(5, (72 + 2) & 15)] ^ W[hook(5, 72 & 15)], (unsigned int)1)) + 0xCA62C1D6 + rotate(d, (unsigned int)5);
    e = rotate(e, (unsigned int)30);
  };
  {
    b += (d ^ e ^ a) + (W[hook(5, 73 & 15)] = rotate(W[hook(5, (73 + 13) & 15)] ^ W[hook(5, (73 + 8) & 15)] ^ W[hook(5, (73 + 2) & 15)] ^ W[hook(5, 73 & 15)], (unsigned int)1)) + 0xCA62C1D6 + rotate(c, (unsigned int)5);
    d = rotate(d, (unsigned int)30);
  };
  {
    a += (c ^ d ^ e) + (W[hook(5, 74 & 15)] = rotate(W[hook(5, (74 + 13) & 15)] ^ W[hook(5, (74 + 8) & 15)] ^ W[hook(5, (74 + 2) & 15)] ^ W[hook(5, 74 & 15)], (unsigned int)1)) + 0xCA62C1D6 + rotate(b, (unsigned int)5);
    c = rotate(c, (unsigned int)30);
  };
  {
    e += (b ^ c ^ d) + (W[hook(5, 75 & 15)] = rotate(W[hook(5, (75 + 13) & 15)] ^ W[hook(5, (75 + 8) & 15)] ^ W[hook(5, (75 + 2) & 15)] ^ W[hook(5, 75 & 15)], (unsigned int)1)) + 0xCA62C1D6 + rotate(a, (unsigned int)5);
    b = rotate(b, (unsigned int)30);
  };
  {
    d += (a ^ b ^ c) + (W[hook(5, 76 & 15)] = rotate(W[hook(5, (76 + 13) & 15)] ^ W[hook(5, (76 + 8) & 15)] ^ W[hook(5, (76 + 2) & 15)] ^ W[hook(5, 76 & 15)], (unsigned int)1)) + 0xCA62C1D6 + rotate(e, (unsigned int)5);
    a = rotate(a, (unsigned int)30);
  };
  {
    c += (e ^ a ^ b) + (W[hook(5, 77 & 15)] = rotate(W[hook(5, (77 + 13) & 15)] ^ W[hook(5, (77 + 8) & 15)] ^ W[hook(5, (77 + 2) & 15)] ^ W[hook(5, 77 & 15)], (unsigned int)1)) + 0xCA62C1D6 + rotate(d, (unsigned int)5);
    e = rotate(e, (unsigned int)30);
  };
  {
    b += (d ^ e ^ a) + (W[hook(5, 78 & 15)] = rotate(W[hook(5, (78 + 13) & 15)] ^ W[hook(5, (78 + 8) & 15)] ^ W[hook(5, (78 + 2) & 15)] ^ W[hook(5, 78 & 15)], (unsigned int)1)) + 0xCA62C1D6 + rotate(c, (unsigned int)5);
    d = rotate(d, (unsigned int)30);
  };
  {
    a += (c ^ d ^ e) + (W[hook(5, 79 & 15)] = rotate(W[hook(5, (79 + 13) & 15)] ^ W[hook(5, (79 + 8) & 15)] ^ W[hook(5, (79 + 2) & 15)] ^ W[hook(5, 79 & 15)], (unsigned int)1)) + 0xCA62C1D6 + rotate(b, (unsigned int)5);
    c = rotate(c, (unsigned int)30);
  };

  hash[hook(4, 0)] += a;
  hash[hook(4, 1)] += b;
  hash[hook(4, 2)] += c;
  hash[hook(4, 3)] += d;
  hash[hook(4, 4)] += e;

  str[hook(6, 0)] = b64t[hook(7, hash[0hook(4, 0) >> 26)];
  str[hook(6, 1)] = b64t[hook(7, (hash[0hook(4, 0) >> 20) & 63)];
  str[hook(6, 2)] = b64t[hook(7, (hash[0hook(4, 0) >> 14) & 63)];
  str[hook(6, 3)] = b64t[hook(7, (hash[0hook(4, 0) >> 8) & 63)];
  str[hook(6, 4)] = b64t[hook(7, (hash[0hook(4, 0) >> 2) & 63)];
  str[hook(6, 5)] = b64t[hook(7, (hash[0hook(4, 0) << 4 | hash[1hook(4, 1) >> 28) & 63)];
  str[hook(6, 6)] = b64t[hook(7, (hash[1hook(4, 1) >> 22) & 63)];
  str[hook(6, 7)] = b64t[hook(7, (hash[1hook(4, 1) >> 16) & 63)];
  str[hook(6, 8)] = b64t[hook(7, (hash[1hook(4, 1) >> 10) & 63)];
  str[hook(6, 9)] = b64t[hook(7, (hash[1hook(4, 1) >> 4) & 63)];
  str[hook(6, 10)] = b64t[hook(7, (hash[1hook(4, 1) << 2 | hash[2hook(4, 2) >> 30) & 63)];
  str[hook(6, 11)] = b64t[hook(7, (hash[2hook(4, 2) >> 24) & 63)];
  str[hook(6, 12)] = b64t[hook(7, (hash[2hook(4, 2) >> 18) & 63)];
  str[hook(6, 13)] = b64t[hook(7, (hash[2hook(4, 2) >> 12) & 63)];
  str[hook(6, 14)] = b64t[hook(7, (hash[2hook(4, 2) >> 6) & 63)];
  str[hook(6, 15)] = b64t[hook(7, hash[2hook(4, 2) & 63)];
  str[hook(6, 16)] = b64t[hook(7, hash[3hook(4, 3) >> 26)];
  str[hook(6, 17)] = b64t[hook(7, (hash[3hook(4, 3) >> 20) & 63)];
  str[hook(6, 18)] = b64t[hook(7, (hash[3hook(4, 3) >> 14) & 63)];
  str[hook(6, 19)] = b64t[hook(7, (hash[3hook(4, 3) >> 8) & 63)];
  str[hook(6, 20)] = b64t[hook(7, (hash[3hook(4, 3) >> 2) & 63)];
  str[hook(6, 21)] = b64t[hook(7, (hash[3hook(4, 3) << 4 | hash[4hook(4, 4) >> 28) & 63)];
  str[hook(6, 22)] = b64t[hook(7, (hash[4hook(4, 4) >> 22) & 63)];
  str[hook(6, 23)] = b64t[hook(7, (hash[4hook(4, 4) >> 16) & 63)];
  str[hook(6, 24)] = b64t[hook(7, (hash[4hook(4, 4) >> 10) & 63)];
  str[hook(6, 25)] = b64t[hook(7, (hash[4hook(4, 4) >> 4) & 63)];
  str[hook(6, 26)] = str[hook(6, 0)];
  str[hook(6, 27)] = str[hook(6, 1)];
  str[hook(6, 28)] = str[hook(6, 2)];
  str[hook(6, 29)] = str[hook(6, 3)];
  str[hook(6, 30)] = str[hook(6, 4)];
  str[hook(6, 31)] = str[hook(6, 5)];
  str[hook(6, 32)] = str[hook(6, 6)];
  str[hook(6, 33)] = str[hook(6, 7)];
  str[hook(6, 34)] = str[hook(6, 8)];
  str[hook(6, 35)] = str[hook(6, 9)];
  str[hook(6, 36)] = str[hook(6, 10)];
  str[hook(6, 37)] = 0;

  for (int k = 0; k < 26; k++) {
    tripkey = str + k;

    hash[hook(4, 0)] = 0x67452301;
    hash[hook(4, 1)] = 0xEFCDAB89;
    hash[hook(4, 2)] = 0x98BADCFE;
    hash[hook(4, 3)] = 0x10325476;
    hash[hook(4, 4)] = 0xC3D2E1F0;

    a = hash[hook(4, 0)];
    b = hash[hook(4, 1)];
    c = hash[hook(4, 2)];
    d = hash[hook(4, 3)];
    e = hash[hook(4, 4)];

    W[hook(5, 0)] = tripkey[hook(8, 0)] << 24 | tripkey[hook(8, 1)] << 16 | tripkey[hook(8, 2)] << 8 | tripkey[hook(8, 3)];
    W[hook(5, 1)] = tripkey[hook(8, 4)] << 24 | tripkey[hook(8, 5)] << 16 | tripkey[hook(8, 6)] << 8 | tripkey[hook(8, 7)];
    W[hook(5, 2)] = tripkey[hook(8, 8)] << 24 | tripkey[hook(8, 9)] << 16 | tripkey[hook(8, 10)] << 8 | tripkey[hook(8, 11)];

    W[hook(5, 3)] = 0x80000000;

    W[hook(5, 15)] = 96;

    {
      e += bitselect(d, c, b) + W[hook(5, 0)] + 0x5A827999 + rotate(a, (unsigned int)5);
      b = rotate(b, (unsigned int)30);
    };
    {
      d += bitselect(c, b, a) + W[hook(5, 1)] + 0x5A827999 + rotate(e, (unsigned int)5);
      a = rotate(a, (unsigned int)30);
    };
    {
      c += bitselect(b, a, e) + W[hook(5, 2)] + 0x5A827999 + rotate(d, (unsigned int)5);
      e = rotate(e, (unsigned int)30);
    };
    {
      b += bitselect(a, e, d) + W[hook(5, 3)] + 0x5A827999 + rotate(c, (unsigned int)5);
      d = rotate(d, (unsigned int)30);
    };
    {
      a += bitselect(e, d, c) + 0x5A827999 + rotate(b, (unsigned int)5);
      c = rotate(c, (unsigned int)30);
    };
    {
      e += bitselect(d, c, b) + 0x5A827999 + rotate(a, (unsigned int)5);
      b = rotate(b, (unsigned int)30);
    };
    {
      d += bitselect(c, b, a) + 0x5A827999 + rotate(e, (unsigned int)5);
      a = rotate(a, (unsigned int)30);
    };
    {
      c += bitselect(b, a, e) + 0x5A827999 + rotate(d, (unsigned int)5);
      e = rotate(e, (unsigned int)30);
    };
    {
      b += bitselect(a, e, d) + 0x5A827999 + rotate(c, (unsigned int)5);
      d = rotate(d, (unsigned int)30);
    };
    {
      a += bitselect(e, d, c) + 0x5A827999 + rotate(b, (unsigned int)5);
      c = rotate(c, (unsigned int)30);
    };
    {
      e += bitselect(d, c, b) + 0x5A827999 + rotate(a, (unsigned int)5);
      b = rotate(b, (unsigned int)30);
    };
    {
      d += bitselect(c, b, a) + 0x5A827999 + rotate(e, (unsigned int)5);
      a = rotate(a, (unsigned int)30);
    };
    {
      c += bitselect(b, a, e) + 0x5A827999 + rotate(d, (unsigned int)5);
      e = rotate(e, (unsigned int)30);
    };
    {
      b += bitselect(a, e, d) + 0x5A827999 + rotate(c, (unsigned int)5);
      d = rotate(d, (unsigned int)30);
    };
    {
      a += bitselect(e, d, c) + 0x5A827999 + rotate(b, (unsigned int)5);
      c = rotate(c, (unsigned int)30);
    };
    {
      e += bitselect(d, c, b) + W[hook(5, 15)] + 0x5A827999 + rotate(a, (unsigned int)5);
      b = rotate(b, (unsigned int)30);
    };

    W[hook(5, 0)] = rotate(W[hook(5, 2)] ^ W[hook(5, 0)], (unsigned int)1);
    {
      d += bitselect(c, b, a) + W[hook(5, 0)] + 0x5A827999 + rotate(e, (unsigned int)5);
      a = rotate(a, (unsigned int)30);
    };

    W[hook(5, 1)] = rotate(W[hook(5, 3)] ^ W[hook(5, 1)], (unsigned int)1);
    {
      c += bitselect(b, a, e) + W[hook(5, 1)] + 0x5A827999 + rotate(d, (unsigned int)5);
      e = rotate(e, (unsigned int)30);
    };

    W[hook(5, 2)] = rotate(W[hook(5, 15)] ^ W[hook(5, 2)], (unsigned int)1);
    {
      b += bitselect(a, e, d) + W[hook(5, 2)] + 0x5A827999 + rotate(c, (unsigned int)5);
      d = rotate(d, (unsigned int)30);
    };

    W[hook(5, 3)] = rotate(W[hook(5, 0)] ^ W[hook(5, 3)], (unsigned int)1);
    {
      a += bitselect(e, d, c) + W[hook(5, 3)] + 0x5A827999 + rotate(b, (unsigned int)5);
      c = rotate(c, (unsigned int)30);
    };

    W[hook(5, 4)] = rotate(W[hook(5, 1)], (unsigned int)1);
    {
      e += (b ^ c ^ d) + W[hook(5, 4)] + 0x6ED9EBA1 + rotate(a, (unsigned int)5);
      b = rotate(b, (unsigned int)30);
    };

    W[hook(5, 5)] = rotate(W[hook(5, 2)], (unsigned int)1);
    {
      d += (a ^ b ^ c) + W[hook(5, 5)] + 0x6ED9EBA1 + rotate(e, (unsigned int)5);
      a = rotate(a, (unsigned int)30);
    };

    W[hook(5, 6)] = rotate(W[hook(5, 3)], (unsigned int)1);
    {
      c += (e ^ a ^ b) + W[hook(5, 6)] + 0x6ED9EBA1 + rotate(d, (unsigned int)5);
      e = rotate(e, (unsigned int)30);
    };

    W[hook(5, 7)] = rotate(W[hook(5, 4)] ^ W[hook(5, 15)], (unsigned int)1);
    {
      b += (d ^ e ^ a) + W[hook(5, 7)] + 0x6ED9EBA1 + rotate(c, (unsigned int)5);
      d = rotate(d, (unsigned int)30);
    };

    W[hook(5, 8)] = rotate(W[hook(5, 5)] ^ W[hook(5, 0)], (unsigned int)1);
    {
      a += (c ^ d ^ e) + W[hook(5, 8)] + 0x6ED9EBA1 + rotate(b, (unsigned int)5);
      c = rotate(c, (unsigned int)30);
    };

    W[hook(5, 9)] = rotate(W[hook(5, 6)] ^ W[hook(5, 1)], (unsigned int)1);
    {
      e += (b ^ c ^ d) + W[hook(5, 9)] + 0x6ED9EBA1 + rotate(a, (unsigned int)5);
      b = rotate(b, (unsigned int)30);
    };

    W[hook(5, 10)] = rotate(W[hook(5, 7)] ^ W[hook(5, 2)], (unsigned int)1);
    {
      d += (a ^ b ^ c) + W[hook(5, 10)] + 0x6ED9EBA1 + rotate(e, (unsigned int)5);
      a = rotate(a, (unsigned int)30);
    };

    W[hook(5, 11)] = rotate(W[hook(5, 8)] ^ W[hook(5, 3)], (unsigned int)1);
    {
      c += (e ^ a ^ b) + W[hook(5, 11)] + 0x6ED9EBA1 + rotate(d, (unsigned int)5);
      e = rotate(e, (unsigned int)30);
    };

    W[hook(5, 12)] = rotate(W[hook(5, 9)] ^ W[hook(5, 4)], (unsigned int)1);
    {
      b += (d ^ e ^ a) + W[hook(5, 12)] + 0x6ED9EBA1 + rotate(c, (unsigned int)5);
      d = rotate(d, (unsigned int)30);
    };

    W[hook(5, 13)] = rotate(W[hook(5, 10)] ^ W[hook(5, 5)] ^ W[hook(5, 15)], (unsigned int)1);
    {
      a += (c ^ d ^ e) + W[hook(5, 13)] + 0x6ED9EBA1 + rotate(b, (unsigned int)5);
      c = rotate(c, (unsigned int)30);
    };

    W[hook(5, 14)] = rotate(W[hook(5, 11)] ^ W[hook(5, 6)] ^ W[hook(5, 0)], (unsigned int)1);
    {
      e += (b ^ c ^ d) + W[hook(5, 14)] + 0x6ED9EBA1 + rotate(a, (unsigned int)5);
      b = rotate(b, (unsigned int)30);
    };

    W[hook(5, 15)] = rotate(W[hook(5, 12)] ^ W[hook(5, 7)] ^ W[hook(5, 1)] ^ W[hook(5, 15)], (unsigned int)1);
    {
      d += (a ^ b ^ c) + W[hook(5, 15)] + 0x6ED9EBA1 + rotate(e, (unsigned int)5);
      a = rotate(a, (unsigned int)30);
    };

    {
      c += (e ^ a ^ b) + (W[hook(5, 32 & 15)] = rotate(W[hook(5, (32 + 13) & 15)] ^ W[hook(5, (32 + 8) & 15)] ^ W[hook(5, (32 + 2) & 15)] ^ W[hook(5, 32 & 15)], (unsigned int)1)) + 0x6ED9EBA1 + rotate(d, (unsigned int)5);
      e = rotate(e, (unsigned int)30);
    };
    {
      b += (d ^ e ^ a) + (W[hook(5, 33 & 15)] = rotate(W[hook(5, (33 + 13) & 15)] ^ W[hook(5, (33 + 8) & 15)] ^ W[hook(5, (33 + 2) & 15)] ^ W[hook(5, 33 & 15)], (unsigned int)1)) + 0x6ED9EBA1 + rotate(c, (unsigned int)5);
      d = rotate(d, (unsigned int)30);
    };
    {
      a += (c ^ d ^ e) + (W[hook(5, 34 & 15)] = rotate(W[hook(5, (34 + 13) & 15)] ^ W[hook(5, (34 + 8) & 15)] ^ W[hook(5, (34 + 2) & 15)] ^ W[hook(5, 34 & 15)], (unsigned int)1)) + 0x6ED9EBA1 + rotate(b, (unsigned int)5);
      c = rotate(c, (unsigned int)30);
    };
    {
      e += (b ^ c ^ d) + (W[hook(5, 35 & 15)] = rotate(W[hook(5, (35 + 13) & 15)] ^ W[hook(5, (35 + 8) & 15)] ^ W[hook(5, (35 + 2) & 15)] ^ W[hook(5, 35 & 15)], (unsigned int)1)) + 0x6ED9EBA1 + rotate(a, (unsigned int)5);
      b = rotate(b, (unsigned int)30);
    };
    {
      d += (a ^ b ^ c) + (W[hook(5, 36 & 15)] = rotate(W[hook(5, (36 + 13) & 15)] ^ W[hook(5, (36 + 8) & 15)] ^ W[hook(5, (36 + 2) & 15)] ^ W[hook(5, 36 & 15)], (unsigned int)1)) + 0x6ED9EBA1 + rotate(e, (unsigned int)5);
      a = rotate(a, (unsigned int)30);
    };
    {
      c += (e ^ a ^ b) + (W[hook(5, 37 & 15)] = rotate(W[hook(5, (37 + 13) & 15)] ^ W[hook(5, (37 + 8) & 15)] ^ W[hook(5, (37 + 2) & 15)] ^ W[hook(5, 37 & 15)], (unsigned int)1)) + 0x6ED9EBA1 + rotate(d, (unsigned int)5);
      e = rotate(e, (unsigned int)30);
    };
    {
      b += (d ^ e ^ a) + (W[hook(5, 38 & 15)] = rotate(W[hook(5, (38 + 13) & 15)] ^ W[hook(5, (38 + 8) & 15)] ^ W[hook(5, (38 + 2) & 15)] ^ W[hook(5, 38 & 15)], (unsigned int)1)) + 0x6ED9EBA1 + rotate(c, (unsigned int)5);
      d = rotate(d, (unsigned int)30);
    };
    {
      a += (c ^ d ^ e) + (W[hook(5, 39 & 15)] = rotate(W[hook(5, (39 + 13) & 15)] ^ W[hook(5, (39 + 8) & 15)] ^ W[hook(5, (39 + 2) & 15)] ^ W[hook(5, 39 & 15)], (unsigned int)1)) + 0x6ED9EBA1 + rotate(b, (unsigned int)5);
      c = rotate(c, (unsigned int)30);
    };

    {
      e += bitselect(d, c, (b ^ d)) + (W[hook(5, 40 & 15)] = rotate(W[hook(5, (40 + 13) & 15)] ^ W[hook(5, (40 + 8) & 15)] ^ W[hook(5, (40 + 2) & 15)] ^ W[hook(5, 40 & 15)], (unsigned int)1)) + 0x8F1BBCDC + rotate(a, (unsigned int)5);
      b = rotate(b, (unsigned int)30);
    };
    {
      d += bitselect(c, b, (a ^ c)) + (W[hook(5, 41 & 15)] = rotate(W[hook(5, (41 + 13) & 15)] ^ W[hook(5, (41 + 8) & 15)] ^ W[hook(5, (41 + 2) & 15)] ^ W[hook(5, 41 & 15)], (unsigned int)1)) + 0x8F1BBCDC + rotate(e, (unsigned int)5);
      a = rotate(a, (unsigned int)30);
    };
    {
      c += bitselect(b, a, (e ^ b)) + (W[hook(5, 42 & 15)] = rotate(W[hook(5, (42 + 13) & 15)] ^ W[hook(5, (42 + 8) & 15)] ^ W[hook(5, (42 + 2) & 15)] ^ W[hook(5, 42 & 15)], (unsigned int)1)) + 0x8F1BBCDC + rotate(d, (unsigned int)5);
      e = rotate(e, (unsigned int)30);
    };
    {
      b += bitselect(a, e, (d ^ a)) + (W[hook(5, 43 & 15)] = rotate(W[hook(5, (43 + 13) & 15)] ^ W[hook(5, (43 + 8) & 15)] ^ W[hook(5, (43 + 2) & 15)] ^ W[hook(5, 43 & 15)], (unsigned int)1)) + 0x8F1BBCDC + rotate(c, (unsigned int)5);
      d = rotate(d, (unsigned int)30);
    };
    {
      a += bitselect(e, d, (c ^ e)) + (W[hook(5, 44 & 15)] = rotate(W[hook(5, (44 + 13) & 15)] ^ W[hook(5, (44 + 8) & 15)] ^ W[hook(5, (44 + 2) & 15)] ^ W[hook(5, 44 & 15)], (unsigned int)1)) + 0x8F1BBCDC + rotate(b, (unsigned int)5);
      c = rotate(c, (unsigned int)30);
    };
    {
      e += bitselect(d, c, (b ^ d)) + (W[hook(5, 45 & 15)] = rotate(W[hook(5, (45 + 13) & 15)] ^ W[hook(5, (45 + 8) & 15)] ^ W[hook(5, (45 + 2) & 15)] ^ W[hook(5, 45 & 15)], (unsigned int)1)) + 0x8F1BBCDC + rotate(a, (unsigned int)5);
      b = rotate(b, (unsigned int)30);
    };
    {
      d += bitselect(c, b, (a ^ c)) + (W[hook(5, 46 & 15)] = rotate(W[hook(5, (46 + 13) & 15)] ^ W[hook(5, (46 + 8) & 15)] ^ W[hook(5, (46 + 2) & 15)] ^ W[hook(5, 46 & 15)], (unsigned int)1)) + 0x8F1BBCDC + rotate(e, (unsigned int)5);
      a = rotate(a, (unsigned int)30);
    };
    {
      c += bitselect(b, a, (e ^ b)) + (W[hook(5, 47 & 15)] = rotate(W[hook(5, (47 + 13) & 15)] ^ W[hook(5, (47 + 8) & 15)] ^ W[hook(5, (47 + 2) & 15)] ^ W[hook(5, 47 & 15)], (unsigned int)1)) + 0x8F1BBCDC + rotate(d, (unsigned int)5);
      e = rotate(e, (unsigned int)30);
    };
    {
      b += bitselect(a, e, (d ^ a)) + (W[hook(5, 48 & 15)] = rotate(W[hook(5, (48 + 13) & 15)] ^ W[hook(5, (48 + 8) & 15)] ^ W[hook(5, (48 + 2) & 15)] ^ W[hook(5, 48 & 15)], (unsigned int)1)) + 0x8F1BBCDC + rotate(c, (unsigned int)5);
      d = rotate(d, (unsigned int)30);
    };
    {
      a += bitselect(e, d, (c ^ e)) + (W[hook(5, 49 & 15)] = rotate(W[hook(5, (49 + 13) & 15)] ^ W[hook(5, (49 + 8) & 15)] ^ W[hook(5, (49 + 2) & 15)] ^ W[hook(5, 49 & 15)], (unsigned int)1)) + 0x8F1BBCDC + rotate(b, (unsigned int)5);
      c = rotate(c, (unsigned int)30);
    };
    {
      e += bitselect(d, c, (b ^ d)) + (W[hook(5, 50 & 15)] = rotate(W[hook(5, (50 + 13) & 15)] ^ W[hook(5, (50 + 8) & 15)] ^ W[hook(5, (50 + 2) & 15)] ^ W[hook(5, 50 & 15)], (unsigned int)1)) + 0x8F1BBCDC + rotate(a, (unsigned int)5);
      b = rotate(b, (unsigned int)30);
    };
    {
      d += bitselect(c, b, (a ^ c)) + (W[hook(5, 51 & 15)] = rotate(W[hook(5, (51 + 13) & 15)] ^ W[hook(5, (51 + 8) & 15)] ^ W[hook(5, (51 + 2) & 15)] ^ W[hook(5, 51 & 15)], (unsigned int)1)) + 0x8F1BBCDC + rotate(e, (unsigned int)5);
      a = rotate(a, (unsigned int)30);
    };
    {
      c += bitselect(b, a, (e ^ b)) + (W[hook(5, 52 & 15)] = rotate(W[hook(5, (52 + 13) & 15)] ^ W[hook(5, (52 + 8) & 15)] ^ W[hook(5, (52 + 2) & 15)] ^ W[hook(5, 52 & 15)], (unsigned int)1)) + 0x8F1BBCDC + rotate(d, (unsigned int)5);
      e = rotate(e, (unsigned int)30);
    };
    {
      b += bitselect(a, e, (d ^ a)) + (W[hook(5, 53 & 15)] = rotate(W[hook(5, (53 + 13) & 15)] ^ W[hook(5, (53 + 8) & 15)] ^ W[hook(5, (53 + 2) & 15)] ^ W[hook(5, 53 & 15)], (unsigned int)1)) + 0x8F1BBCDC + rotate(c, (unsigned int)5);
      d = rotate(d, (unsigned int)30);
    };
    {
      a += bitselect(e, d, (c ^ e)) + (W[hook(5, 54 & 15)] = rotate(W[hook(5, (54 + 13) & 15)] ^ W[hook(5, (54 + 8) & 15)] ^ W[hook(5, (54 + 2) & 15)] ^ W[hook(5, 54 & 15)], (unsigned int)1)) + 0x8F1BBCDC + rotate(b, (unsigned int)5);
      c = rotate(c, (unsigned int)30);
    };
    {
      e += bitselect(d, c, (b ^ d)) + (W[hook(5, 55 & 15)] = rotate(W[hook(5, (55 + 13) & 15)] ^ W[hook(5, (55 + 8) & 15)] ^ W[hook(5, (55 + 2) & 15)] ^ W[hook(5, 55 & 15)], (unsigned int)1)) + 0x8F1BBCDC + rotate(a, (unsigned int)5);
      b = rotate(b, (unsigned int)30);
    };
    {
      d += bitselect(c, b, (a ^ c)) + (W[hook(5, 56 & 15)] = rotate(W[hook(5, (56 + 13) & 15)] ^ W[hook(5, (56 + 8) & 15)] ^ W[hook(5, (56 + 2) & 15)] ^ W[hook(5, 56 & 15)], (unsigned int)1)) + 0x8F1BBCDC + rotate(e, (unsigned int)5);
      a = rotate(a, (unsigned int)30);
    };
    {
      c += bitselect(b, a, (e ^ b)) + (W[hook(5, 57 & 15)] = rotate(W[hook(5, (57 + 13) & 15)] ^ W[hook(5, (57 + 8) & 15)] ^ W[hook(5, (57 + 2) & 15)] ^ W[hook(5, 57 & 15)], (unsigned int)1)) + 0x8F1BBCDC + rotate(d, (unsigned int)5);
      e = rotate(e, (unsigned int)30);
    };
    {
      b += bitselect(a, e, (d ^ a)) + (W[hook(5, 58 & 15)] = rotate(W[hook(5, (58 + 13) & 15)] ^ W[hook(5, (58 + 8) & 15)] ^ W[hook(5, (58 + 2) & 15)] ^ W[hook(5, 58 & 15)], (unsigned int)1)) + 0x8F1BBCDC + rotate(c, (unsigned int)5);
      d = rotate(d, (unsigned int)30);
    };
    {
      a += bitselect(e, d, (c ^ e)) + (W[hook(5, 59 & 15)] = rotate(W[hook(5, (59 + 13) & 15)] ^ W[hook(5, (59 + 8) & 15)] ^ W[hook(5, (59 + 2) & 15)] ^ W[hook(5, 59 & 15)], (unsigned int)1)) + 0x8F1BBCDC + rotate(b, (unsigned int)5);
      c = rotate(c, (unsigned int)30);
    };

    {
      e += (b ^ c ^ d) + (W[hook(5, 60 & 15)] = rotate(W[hook(5, (60 + 13) & 15)] ^ W[hook(5, (60 + 8) & 15)] ^ W[hook(5, (60 + 2) & 15)] ^ W[hook(5, 60 & 15)], (unsigned int)1)) + 0xCA62C1D6 + rotate(a, (unsigned int)5);
      b = rotate(b, (unsigned int)30);
    };
    {
      d += (a ^ b ^ c) + (W[hook(5, 61 & 15)] = rotate(W[hook(5, (61 + 13) & 15)] ^ W[hook(5, (61 + 8) & 15)] ^ W[hook(5, (61 + 2) & 15)] ^ W[hook(5, 61 & 15)], (unsigned int)1)) + 0xCA62C1D6 + rotate(e, (unsigned int)5);
      a = rotate(a, (unsigned int)30);
    };
    {
      c += (e ^ a ^ b) + (W[hook(5, 62 & 15)] = rotate(W[hook(5, (62 + 13) & 15)] ^ W[hook(5, (62 + 8) & 15)] ^ W[hook(5, (62 + 2) & 15)] ^ W[hook(5, 62 & 15)], (unsigned int)1)) + 0xCA62C1D6 + rotate(d, (unsigned int)5);
      e = rotate(e, (unsigned int)30);
    };
    {
      b += (d ^ e ^ a) + (W[hook(5, 63 & 15)] = rotate(W[hook(5, (63 + 13) & 15)] ^ W[hook(5, (63 + 8) & 15)] ^ W[hook(5, (63 + 2) & 15)] ^ W[hook(5, 63 & 15)], (unsigned int)1)) + 0xCA62C1D6 + rotate(c, (unsigned int)5);
      d = rotate(d, (unsigned int)30);
    };
    {
      a += (c ^ d ^ e) + (W[hook(5, 64 & 15)] = rotate(W[hook(5, (64 + 13) & 15)] ^ W[hook(5, (64 + 8) & 15)] ^ W[hook(5, (64 + 2) & 15)] ^ W[hook(5, 64 & 15)], (unsigned int)1)) + 0xCA62C1D6 + rotate(b, (unsigned int)5);
      c = rotate(c, (unsigned int)30);
    };
    {
      e += (b ^ c ^ d) + (W[hook(5, 65 & 15)] = rotate(W[hook(5, (65 + 13) & 15)] ^ W[hook(5, (65 + 8) & 15)] ^ W[hook(5, (65 + 2) & 15)] ^ W[hook(5, 65 & 15)], (unsigned int)1)) + 0xCA62C1D6 + rotate(a, (unsigned int)5);
      b = rotate(b, (unsigned int)30);
    };
    {
      d += (a ^ b ^ c) + (W[hook(5, 66 & 15)] = rotate(W[hook(5, (66 + 13) & 15)] ^ W[hook(5, (66 + 8) & 15)] ^ W[hook(5, (66 + 2) & 15)] ^ W[hook(5, 66 & 15)], (unsigned int)1)) + 0xCA62C1D6 + rotate(e, (unsigned int)5);
      a = rotate(a, (unsigned int)30);
    };
    {
      c += (e ^ a ^ b) + (W[hook(5, 67 & 15)] = rotate(W[hook(5, (67 + 13) & 15)] ^ W[hook(5, (67 + 8) & 15)] ^ W[hook(5, (67 + 2) & 15)] ^ W[hook(5, 67 & 15)], (unsigned int)1)) + 0xCA62C1D6 + rotate(d, (unsigned int)5);
      e = rotate(e, (unsigned int)30);
    };
    {
      b += (d ^ e ^ a) + (W[hook(5, 68 & 15)] = rotate(W[hook(5, (68 + 13) & 15)] ^ W[hook(5, (68 + 8) & 15)] ^ W[hook(5, (68 + 2) & 15)] ^ W[hook(5, 68 & 15)], (unsigned int)1)) + 0xCA62C1D6 + rotate(c, (unsigned int)5);
      d = rotate(d, (unsigned int)30);
    };
    {
      a += (c ^ d ^ e) + (W[hook(5, 69 & 15)] = rotate(W[hook(5, (69 + 13) & 15)] ^ W[hook(5, (69 + 8) & 15)] ^ W[hook(5, (69 + 2) & 15)] ^ W[hook(5, 69 & 15)], (unsigned int)1)) + 0xCA62C1D6 + rotate(b, (unsigned int)5);
      c = rotate(c, (unsigned int)30);
    };
    {
      e += (b ^ c ^ d) + (W[hook(5, 70 & 15)] = rotate(W[hook(5, (70 + 13) & 15)] ^ W[hook(5, (70 + 8) & 15)] ^ W[hook(5, (70 + 2) & 15)] ^ W[hook(5, 70 & 15)], (unsigned int)1)) + 0xCA62C1D6 + rotate(a, (unsigned int)5);
      b = rotate(b, (unsigned int)30);
    };
    {
      d += (a ^ b ^ c) + (W[hook(5, 71 & 15)] = rotate(W[hook(5, (71 + 13) & 15)] ^ W[hook(5, (71 + 8) & 15)] ^ W[hook(5, (71 + 2) & 15)] ^ W[hook(5, 71 & 15)], (unsigned int)1)) + 0xCA62C1D6 + rotate(e, (unsigned int)5);
      a = rotate(a, (unsigned int)30);
    };
    {
      c += (e ^ a ^ b) + (W[hook(5, 72 & 15)] = rotate(W[hook(5, (72 + 13) & 15)] ^ W[hook(5, (72 + 8) & 15)] ^ W[hook(5, (72 + 2) & 15)] ^ W[hook(5, 72 & 15)], (unsigned int)1)) + 0xCA62C1D6 + rotate(d, (unsigned int)5);
      e = rotate(e, (unsigned int)30);
    };
    {
      b += (d ^ e ^ a) + (W[hook(5, 73 & 15)] = rotate(W[hook(5, (73 + 13) & 15)] ^ W[hook(5, (73 + 8) & 15)] ^ W[hook(5, (73 + 2) & 15)] ^ W[hook(5, 73 & 15)], (unsigned int)1)) + 0xCA62C1D6 + rotate(c, (unsigned int)5);
      d = rotate(d, (unsigned int)30);
    };
    {
      a += (c ^ d ^ e) + (W[hook(5, 74 & 15)] = rotate(W[hook(5, (74 + 13) & 15)] ^ W[hook(5, (74 + 8) & 15)] ^ W[hook(5, (74 + 2) & 15)] ^ W[hook(5, 74 & 15)], (unsigned int)1)) + 0xCA62C1D6 + rotate(b, (unsigned int)5);
      c = rotate(c, (unsigned int)30);
    };
    {
      e += (b ^ c ^ d) + (W[hook(5, 75 & 15)] = rotate(W[hook(5, (75 + 13) & 15)] ^ W[hook(5, (75 + 8) & 15)] ^ W[hook(5, (75 + 2) & 15)] ^ W[hook(5, 75 & 15)], (unsigned int)1)) + 0xCA62C1D6 + rotate(a, (unsigned int)5);
      b = rotate(b, (unsigned int)30);
    };
    {
      d += (a ^ b ^ c) + (W[hook(5, 76 & 15)] = rotate(W[hook(5, (76 + 13) & 15)] ^ W[hook(5, (76 + 8) & 15)] ^ W[hook(5, (76 + 2) & 15)] ^ W[hook(5, 76 & 15)], (unsigned int)1)) + 0xCA62C1D6 + rotate(e, (unsigned int)5);
      a = rotate(a, (unsigned int)30);
    };
    {
      c += (e ^ a ^ b) + (W[hook(5, 77 & 15)] = rotate(W[hook(5, (77 + 13) & 15)] ^ W[hook(5, (77 + 8) & 15)] ^ W[hook(5, (77 + 2) & 15)] ^ W[hook(5, 77 & 15)], (unsigned int)1)) + 0xCA62C1D6 + rotate(d, (unsigned int)5);
      e = rotate(e, (unsigned int)30);
    };
    {
      b += (d ^ e ^ a) + (W[hook(5, 78 & 15)] = rotate(W[hook(5, (78 + 13) & 15)] ^ W[hook(5, (78 + 8) & 15)] ^ W[hook(5, (78 + 2) & 15)] ^ W[hook(5, 78 & 15)], (unsigned int)1)) + 0xCA62C1D6 + rotate(c, (unsigned int)5);
      d = rotate(d, (unsigned int)30);
    };
    {
      a += (c ^ d ^ e) + (W[hook(5, 79 & 15)] = rotate(W[hook(5, (79 + 13) & 15)] ^ W[hook(5, (79 + 8) & 15)] ^ W[hook(5, (79 + 2) & 15)] ^ W[hook(5, 79 & 15)], (unsigned int)1)) + 0xCA62C1D6 + rotate(b, (unsigned int)5);
      c = rotate(c, (unsigned int)30);
    };

    hash[hook(4, 0)] += a;

    if (hash[hook(4, 0)] >> 2 == trip_target) {
      output[hook(1, output[hook(1, 255)++)] = __builtin_astype((__builtin_astype((gid), uchar4).wzyx), unsigned int);
      return;
    }

    hash[hook(4, 3)] += d;
    hash[hook(4, 4)] += e;

    hash3 ^= hash[hook(4, 3)];
    hash4 ^= hash[hook(4, 4)];
  }

  bool result = ((((ulong)__builtin_astype((__builtin_astype((hash4), uchar4).wzyx), unsigned int) << 32) | __builtin_astype((__builtin_astype((hash3), uchar4).wzyx), unsigned int)) <= target);

  if (result) {
    output[hook(1, output[hook(1, 255)++)] = __builtin_astype((__builtin_astype((gid), uchar4).wzyx), unsigned int);
  }
}