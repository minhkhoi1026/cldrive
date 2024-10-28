//{"W":4,"digest":3,"index":2,"keys":0,"output":6,"salt":1,"salt_s":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void o5logon_kernel(global unsigned int* keys, constant unsigned int* salt, global const unsigned int* index, global unsigned int* digest) {
  unsigned int W[16] = {0}, salt_s[3], output[5];
  unsigned int temp, A, B, C, D, E;
  unsigned int gid = get_global_id(0);
  unsigned int base = index[hook(2, gid)];
  unsigned int len = base & 63;
  unsigned int i;
  unsigned int shift = len % 4;
  unsigned int sr = 8 * shift;
  unsigned int sl = 32 - sr;
  unsigned int sra = (0xffffffff - (1 << sr)) + 1;
  unsigned int sla = 0xffffffff - sra;

  keys += base >> 6;

  for (i = 0; i < (len + 3) / 4; i++)
    W[hook(4, i)] = (__builtin_astype((__builtin_astype((*keys++), uchar4).wzyx), unsigned int));

  salt_s[hook(5, 0)] = (__builtin_astype((__builtin_astype((*salt++), uchar4).wzyx), unsigned int));
  salt_s[hook(5, 1)] = (__builtin_astype((__builtin_astype((*salt++), uchar4).wzyx), unsigned int));
  salt_s[hook(5, 2)] = (__builtin_astype((__builtin_astype((*salt), uchar4).wzyx), unsigned int));

  W[hook(4, len / 4)] |= (salt_s[hook(5, 0)] & sra) >> sr;
  W[hook(4, len / 4 + 1)] = ((salt_s[hook(5, 0)] & sla) << sl) | ((salt_s[hook(5, 1)] & sra) >> sr);
  W[hook(4, len / 4 + 2)] = ((salt_s[hook(5, 1)] & sla) << sl) | ((salt_s[hook(5, 2)] & sra) >> sr);
  W[hook(4, len / 4 + 3)] = (salt_s[hook(5, 2)] & sla) << sl;

  W[hook(4, 15)] = (len + 10) << 3;

  {
    output[hook(6, 0)] = 0x67452301;
    output[hook(6, 1)] = 0xefcdab89;
    output[hook(6, 2)] = 0x98badcfe;
    output[hook(6, 3)] = 0x10325476;
    output[hook(6, 4)] = 0xc3d2e1f0;
  };
  {
    A = output[hook(6, 0)];
    B = output[hook(6, 1)];
    C = output[hook(6, 2)];
    D = output[hook(6, 3)];
    E = output[hook(6, 4)];
    {
      E += rotate((A), (unsigned int)(5)) + (D ^ (B & (C ^ D))) + 0x5a827999 + W[hook(4, 0)];
      B = rotate((B), (unsigned int)(30));
    };
    {
      D += rotate((E), (unsigned int)(5)) + (C ^ (A & (B ^ C))) + 0x5a827999 + W[hook(4, 1)];
      A = rotate((A), (unsigned int)(30));
    };
    {
      C += rotate((D), (unsigned int)(5)) + (B ^ (E & (A ^ B))) + 0x5a827999 + W[hook(4, 2)];
      E = rotate((E), (unsigned int)(30));
    };
    {
      B += rotate((C), (unsigned int)(5)) + (A ^ (D & (E ^ A))) + 0x5a827999 + W[hook(4, 3)];
      D = rotate((D), (unsigned int)(30));
    };
    {
      A += rotate((B), (unsigned int)(5)) + (E ^ (C & (D ^ E))) + 0x5a827999 + W[hook(4, 4)];
      C = rotate((C), (unsigned int)(30));
    };
    {
      E += rotate((A), (unsigned int)(5)) + (D ^ (B & (C ^ D))) + 0x5a827999 + W[hook(4, 5)];
      B = rotate((B), (unsigned int)(30));
    };
    {
      D += rotate((E), (unsigned int)(5)) + (C ^ (A & (B ^ C))) + 0x5a827999 + W[hook(4, 6)];
      A = rotate((A), (unsigned int)(30));
    };
    {
      C += rotate((D), (unsigned int)(5)) + (B ^ (E & (A ^ B))) + 0x5a827999 + W[hook(4, 7)];
      E = rotate((E), (unsigned int)(30));
    };
    {
      B += rotate((C), (unsigned int)(5)) + (A ^ (D & (E ^ A))) + 0x5a827999 + W[hook(4, 8)];
      D = rotate((D), (unsigned int)(30));
    };
    {
      A += rotate((B), (unsigned int)(5)) + (E ^ (C & (D ^ E))) + 0x5a827999 + W[hook(4, 9)];
      C = rotate((C), (unsigned int)(30));
    };
    {
      E += rotate((A), (unsigned int)(5)) + (D ^ (B & (C ^ D))) + 0x5a827999 + W[hook(4, 10)];
      B = rotate((B), (unsigned int)(30));
    };
    {
      D += rotate((E), (unsigned int)(5)) + (C ^ (A & (B ^ C))) + 0x5a827999 + W[hook(4, 11)];
      A = rotate((A), (unsigned int)(30));
    };
    {
      C += rotate((D), (unsigned int)(5)) + (B ^ (E & (A ^ B))) + 0x5a827999 + W[hook(4, 12)];
      E = rotate((E), (unsigned int)(30));
    };
    {
      B += rotate((C), (unsigned int)(5)) + (A ^ (D & (E ^ A))) + 0x5a827999 + W[hook(4, 13)];
      D = rotate((D), (unsigned int)(30));
    };
    {
      A += rotate((B), (unsigned int)(5)) + (E ^ (C & (D ^ E))) + 0x5a827999 + W[hook(4, 14)];
      C = rotate((C), (unsigned int)(30));
    };
    {
      E += rotate((A), (unsigned int)(5)) + (D ^ (B & (C ^ D))) + 0x5a827999 + W[hook(4, 15)];
      B = rotate((B), (unsigned int)(30));
    };
    {
      D += rotate((E), (unsigned int)(5)) + (C ^ (A & (B ^ C))) + 0x5a827999 + (temp = W[hook(4, (16 - 3) & 15)] ^ W[hook(4, (16 - 8) & 15)] ^ W[hook(4, (16 - 14) & 15)] ^ W[hook(4, 16 & 15)], (W[hook(4, 16 & 15)] = rotate((temp), (unsigned int)(1))));
      A = rotate((A), (unsigned int)(30));
    };
    {
      C += rotate((D), (unsigned int)(5)) + (B ^ (E & (A ^ B))) + 0x5a827999 + (temp = W[hook(4, (17 - 3) & 15)] ^ W[hook(4, (17 - 8) & 15)] ^ W[hook(4, (17 - 14) & 15)] ^ W[hook(4, 17 & 15)], (W[hook(4, 17 & 15)] = rotate((temp), (unsigned int)(1))));
      E = rotate((E), (unsigned int)(30));
    };
    {
      B += rotate((C), (unsigned int)(5)) + (A ^ (D & (E ^ A))) + 0x5a827999 + (temp = W[hook(4, (18 - 3) & 15)] ^ W[hook(4, (18 - 8) & 15)] ^ W[hook(4, (18 - 14) & 15)] ^ W[hook(4, 18 & 15)], (W[hook(4, 18 & 15)] = rotate((temp), (unsigned int)(1))));
      D = rotate((D), (unsigned int)(30));
    };
    {
      A += rotate((B), (unsigned int)(5)) + (E ^ (C & (D ^ E))) + 0x5a827999 + (temp = W[hook(4, (19 - 3) & 15)] ^ W[hook(4, (19 - 8) & 15)] ^ W[hook(4, (19 - 14) & 15)] ^ W[hook(4, 19 & 15)], (W[hook(4, 19 & 15)] = rotate((temp), (unsigned int)(1))));
      C = rotate((C), (unsigned int)(30));
    };
    {
      E += rotate((A), (unsigned int)(5)) + (B ^ C ^ D) + 0x6ed9eba1 + (temp = W[hook(4, (20 - 3) & 15)] ^ W[hook(4, (20 - 8) & 15)] ^ W[hook(4, (20 - 14) & 15)] ^ W[hook(4, 20 & 15)], (W[hook(4, 20 & 15)] = rotate((temp), (unsigned int)(1))));
      B = rotate((B), (unsigned int)(30));
    };
    {
      D += rotate((E), (unsigned int)(5)) + (A ^ B ^ C) + 0x6ed9eba1 + (temp = W[hook(4, (21 - 3) & 15)] ^ W[hook(4, (21 - 8) & 15)] ^ W[hook(4, (21 - 14) & 15)] ^ W[hook(4, 21 & 15)], (W[hook(4, 21 & 15)] = rotate((temp), (unsigned int)(1))));
      A = rotate((A), (unsigned int)(30));
    };
    {
      C += rotate((D), (unsigned int)(5)) + (E ^ A ^ B) + 0x6ed9eba1 + (temp = W[hook(4, (22 - 3) & 15)] ^ W[hook(4, (22 - 8) & 15)] ^ W[hook(4, (22 - 14) & 15)] ^ W[hook(4, 22 & 15)], (W[hook(4, 22 & 15)] = rotate((temp), (unsigned int)(1))));
      E = rotate((E), (unsigned int)(30));
    };
    {
      B += rotate((C), (unsigned int)(5)) + (D ^ E ^ A) + 0x6ed9eba1 + (temp = W[hook(4, (23 - 3) & 15)] ^ W[hook(4, (23 - 8) & 15)] ^ W[hook(4, (23 - 14) & 15)] ^ W[hook(4, 23 & 15)], (W[hook(4, 23 & 15)] = rotate((temp), (unsigned int)(1))));
      D = rotate((D), (unsigned int)(30));
    };
    {
      A += rotate((B), (unsigned int)(5)) + (C ^ D ^ E) + 0x6ed9eba1 + (temp = W[hook(4, (24 - 3) & 15)] ^ W[hook(4, (24 - 8) & 15)] ^ W[hook(4, (24 - 14) & 15)] ^ W[hook(4, 24 & 15)], (W[hook(4, 24 & 15)] = rotate((temp), (unsigned int)(1))));
      C = rotate((C), (unsigned int)(30));
    };
    {
      E += rotate((A), (unsigned int)(5)) + (B ^ C ^ D) + 0x6ed9eba1 + (temp = W[hook(4, (25 - 3) & 15)] ^ W[hook(4, (25 - 8) & 15)] ^ W[hook(4, (25 - 14) & 15)] ^ W[hook(4, 25 & 15)], (W[hook(4, 25 & 15)] = rotate((temp), (unsigned int)(1))));
      B = rotate((B), (unsigned int)(30));
    };
    {
      D += rotate((E), (unsigned int)(5)) + (A ^ B ^ C) + 0x6ed9eba1 + (temp = W[hook(4, (26 - 3) & 15)] ^ W[hook(4, (26 - 8) & 15)] ^ W[hook(4, (26 - 14) & 15)] ^ W[hook(4, 26 & 15)], (W[hook(4, 26 & 15)] = rotate((temp), (unsigned int)(1))));
      A = rotate((A), (unsigned int)(30));
    };
    {
      C += rotate((D), (unsigned int)(5)) + (E ^ A ^ B) + 0x6ed9eba1 + (temp = W[hook(4, (27 - 3) & 15)] ^ W[hook(4, (27 - 8) & 15)] ^ W[hook(4, (27 - 14) & 15)] ^ W[hook(4, 27 & 15)], (W[hook(4, 27 & 15)] = rotate((temp), (unsigned int)(1))));
      E = rotate((E), (unsigned int)(30));
    };
    {
      B += rotate((C), (unsigned int)(5)) + (D ^ E ^ A) + 0x6ed9eba1 + (temp = W[hook(4, (28 - 3) & 15)] ^ W[hook(4, (28 - 8) & 15)] ^ W[hook(4, (28 - 14) & 15)] ^ W[hook(4, 28 & 15)], (W[hook(4, 28 & 15)] = rotate((temp), (unsigned int)(1))));
      D = rotate((D), (unsigned int)(30));
    };
    {
      A += rotate((B), (unsigned int)(5)) + (C ^ D ^ E) + 0x6ed9eba1 + (temp = W[hook(4, (29 - 3) & 15)] ^ W[hook(4, (29 - 8) & 15)] ^ W[hook(4, (29 - 14) & 15)] ^ W[hook(4, 29 & 15)], (W[hook(4, 29 & 15)] = rotate((temp), (unsigned int)(1))));
      C = rotate((C), (unsigned int)(30));
    };
    {
      E += rotate((A), (unsigned int)(5)) + (B ^ C ^ D) + 0x6ed9eba1 + (temp = W[hook(4, (30 - 3) & 15)] ^ W[hook(4, (30 - 8) & 15)] ^ W[hook(4, (30 - 14) & 15)] ^ W[hook(4, 30 & 15)], (W[hook(4, 30 & 15)] = rotate((temp), (unsigned int)(1))));
      B = rotate((B), (unsigned int)(30));
    };
    {
      D += rotate((E), (unsigned int)(5)) + (A ^ B ^ C) + 0x6ed9eba1 + (temp = W[hook(4, (31 - 3) & 15)] ^ W[hook(4, (31 - 8) & 15)] ^ W[hook(4, (31 - 14) & 15)] ^ W[hook(4, 31 & 15)], (W[hook(4, 31 & 15)] = rotate((temp), (unsigned int)(1))));
      A = rotate((A), (unsigned int)(30));
    };
    {
      C += rotate((D), (unsigned int)(5)) + (E ^ A ^ B) + 0x6ed9eba1 + (temp = W[hook(4, (32 - 3) & 15)] ^ W[hook(4, (32 - 8) & 15)] ^ W[hook(4, (32 - 14) & 15)] ^ W[hook(4, 32 & 15)], (W[hook(4, 32 & 15)] = rotate((temp), (unsigned int)(1))));
      E = rotate((E), (unsigned int)(30));
    };
    {
      B += rotate((C), (unsigned int)(5)) + (D ^ E ^ A) + 0x6ed9eba1 + (temp = W[hook(4, (33 - 3) & 15)] ^ W[hook(4, (33 - 8) & 15)] ^ W[hook(4, (33 - 14) & 15)] ^ W[hook(4, 33 & 15)], (W[hook(4, 33 & 15)] = rotate((temp), (unsigned int)(1))));
      D = rotate((D), (unsigned int)(30));
    };
    {
      A += rotate((B), (unsigned int)(5)) + (C ^ D ^ E) + 0x6ed9eba1 + (temp = W[hook(4, (34 - 3) & 15)] ^ W[hook(4, (34 - 8) & 15)] ^ W[hook(4, (34 - 14) & 15)] ^ W[hook(4, 34 & 15)], (W[hook(4, 34 & 15)] = rotate((temp), (unsigned int)(1))));
      C = rotate((C), (unsigned int)(30));
    };
    {
      E += rotate((A), (unsigned int)(5)) + (B ^ C ^ D) + 0x6ed9eba1 + (temp = W[hook(4, (35 - 3) & 15)] ^ W[hook(4, (35 - 8) & 15)] ^ W[hook(4, (35 - 14) & 15)] ^ W[hook(4, 35 & 15)], (W[hook(4, 35 & 15)] = rotate((temp), (unsigned int)(1))));
      B = rotate((B), (unsigned int)(30));
    };
    {
      D += rotate((E), (unsigned int)(5)) + (A ^ B ^ C) + 0x6ed9eba1 + (temp = W[hook(4, (36 - 3) & 15)] ^ W[hook(4, (36 - 8) & 15)] ^ W[hook(4, (36 - 14) & 15)] ^ W[hook(4, 36 & 15)], (W[hook(4, 36 & 15)] = rotate((temp), (unsigned int)(1))));
      A = rotate((A), (unsigned int)(30));
    };
    {
      C += rotate((D), (unsigned int)(5)) + (E ^ A ^ B) + 0x6ed9eba1 + (temp = W[hook(4, (37 - 3) & 15)] ^ W[hook(4, (37 - 8) & 15)] ^ W[hook(4, (37 - 14) & 15)] ^ W[hook(4, 37 & 15)], (W[hook(4, 37 & 15)] = rotate((temp), (unsigned int)(1))));
      E = rotate((E), (unsigned int)(30));
    };
    {
      B += rotate((C), (unsigned int)(5)) + (D ^ E ^ A) + 0x6ed9eba1 + (temp = W[hook(4, (38 - 3) & 15)] ^ W[hook(4, (38 - 8) & 15)] ^ W[hook(4, (38 - 14) & 15)] ^ W[hook(4, 38 & 15)], (W[hook(4, 38 & 15)] = rotate((temp), (unsigned int)(1))));
      D = rotate((D), (unsigned int)(30));
    };
    {
      A += rotate((B), (unsigned int)(5)) + (C ^ D ^ E) + 0x6ed9eba1 + (temp = W[hook(4, (39 - 3) & 15)] ^ W[hook(4, (39 - 8) & 15)] ^ W[hook(4, (39 - 14) & 15)] ^ W[hook(4, 39 & 15)], (W[hook(4, 39 & 15)] = rotate((temp), (unsigned int)(1))));
      C = rotate((C), (unsigned int)(30));
    };
    {
      E += rotate((A), (unsigned int)(5)) + ((B & C) | (D & (B | C))) + 0x8f1bbcdc + (temp = W[hook(4, (40 - 3) & 15)] ^ W[hook(4, (40 - 8) & 15)] ^ W[hook(4, (40 - 14) & 15)] ^ W[hook(4, 40 & 15)], (W[hook(4, 40 & 15)] = rotate((temp), (unsigned int)(1))));
      B = rotate((B), (unsigned int)(30));
    };
    {
      D += rotate((E), (unsigned int)(5)) + ((A & B) | (C & (A | B))) + 0x8f1bbcdc + (temp = W[hook(4, (41 - 3) & 15)] ^ W[hook(4, (41 - 8) & 15)] ^ W[hook(4, (41 - 14) & 15)] ^ W[hook(4, 41 & 15)], (W[hook(4, 41 & 15)] = rotate((temp), (unsigned int)(1))));
      A = rotate((A), (unsigned int)(30));
    };
    {
      C += rotate((D), (unsigned int)(5)) + ((E & A) | (B & (E | A))) + 0x8f1bbcdc + (temp = W[hook(4, (42 - 3) & 15)] ^ W[hook(4, (42 - 8) & 15)] ^ W[hook(4, (42 - 14) & 15)] ^ W[hook(4, 42 & 15)], (W[hook(4, 42 & 15)] = rotate((temp), (unsigned int)(1))));
      E = rotate((E), (unsigned int)(30));
    };
    {
      B += rotate((C), (unsigned int)(5)) + ((D & E) | (A & (D | E))) + 0x8f1bbcdc + (temp = W[hook(4, (43 - 3) & 15)] ^ W[hook(4, (43 - 8) & 15)] ^ W[hook(4, (43 - 14) & 15)] ^ W[hook(4, 43 & 15)], (W[hook(4, 43 & 15)] = rotate((temp), (unsigned int)(1))));
      D = rotate((D), (unsigned int)(30));
    };
    {
      A += rotate((B), (unsigned int)(5)) + ((C & D) | (E & (C | D))) + 0x8f1bbcdc + (temp = W[hook(4, (44 - 3) & 15)] ^ W[hook(4, (44 - 8) & 15)] ^ W[hook(4, (44 - 14) & 15)] ^ W[hook(4, 44 & 15)], (W[hook(4, 44 & 15)] = rotate((temp), (unsigned int)(1))));
      C = rotate((C), (unsigned int)(30));
    };
    {
      E += rotate((A), (unsigned int)(5)) + ((B & C) | (D & (B | C))) + 0x8f1bbcdc + (temp = W[hook(4, (45 - 3) & 15)] ^ W[hook(4, (45 - 8) & 15)] ^ W[hook(4, (45 - 14) & 15)] ^ W[hook(4, 45 & 15)], (W[hook(4, 45 & 15)] = rotate((temp), (unsigned int)(1))));
      B = rotate((B), (unsigned int)(30));
    };
    {
      D += rotate((E), (unsigned int)(5)) + ((A & B) | (C & (A | B))) + 0x8f1bbcdc + (temp = W[hook(4, (46 - 3) & 15)] ^ W[hook(4, (46 - 8) & 15)] ^ W[hook(4, (46 - 14) & 15)] ^ W[hook(4, 46 & 15)], (W[hook(4, 46 & 15)] = rotate((temp), (unsigned int)(1))));
      A = rotate((A), (unsigned int)(30));
    };
    {
      C += rotate((D), (unsigned int)(5)) + ((E & A) | (B & (E | A))) + 0x8f1bbcdc + (temp = W[hook(4, (47 - 3) & 15)] ^ W[hook(4, (47 - 8) & 15)] ^ W[hook(4, (47 - 14) & 15)] ^ W[hook(4, 47 & 15)], (W[hook(4, 47 & 15)] = rotate((temp), (unsigned int)(1))));
      E = rotate((E), (unsigned int)(30));
    };
    {
      B += rotate((C), (unsigned int)(5)) + ((D & E) | (A & (D | E))) + 0x8f1bbcdc + (temp = W[hook(4, (48 - 3) & 15)] ^ W[hook(4, (48 - 8) & 15)] ^ W[hook(4, (48 - 14) & 15)] ^ W[hook(4, 48 & 15)], (W[hook(4, 48 & 15)] = rotate((temp), (unsigned int)(1))));
      D = rotate((D), (unsigned int)(30));
    };
    {
      A += rotate((B), (unsigned int)(5)) + ((C & D) | (E & (C | D))) + 0x8f1bbcdc + (temp = W[hook(4, (49 - 3) & 15)] ^ W[hook(4, (49 - 8) & 15)] ^ W[hook(4, (49 - 14) & 15)] ^ W[hook(4, 49 & 15)], (W[hook(4, 49 & 15)] = rotate((temp), (unsigned int)(1))));
      C = rotate((C), (unsigned int)(30));
    };
    {
      E += rotate((A), (unsigned int)(5)) + ((B & C) | (D & (B | C))) + 0x8f1bbcdc + (temp = W[hook(4, (50 - 3) & 15)] ^ W[hook(4, (50 - 8) & 15)] ^ W[hook(4, (50 - 14) & 15)] ^ W[hook(4, 50 & 15)], (W[hook(4, 50 & 15)] = rotate((temp), (unsigned int)(1))));
      B = rotate((B), (unsigned int)(30));
    };
    {
      D += rotate((E), (unsigned int)(5)) + ((A & B) | (C & (A | B))) + 0x8f1bbcdc + (temp = W[hook(4, (51 - 3) & 15)] ^ W[hook(4, (51 - 8) & 15)] ^ W[hook(4, (51 - 14) & 15)] ^ W[hook(4, 51 & 15)], (W[hook(4, 51 & 15)] = rotate((temp), (unsigned int)(1))));
      A = rotate((A), (unsigned int)(30));
    };
    {
      C += rotate((D), (unsigned int)(5)) + ((E & A) | (B & (E | A))) + 0x8f1bbcdc + (temp = W[hook(4, (52 - 3) & 15)] ^ W[hook(4, (52 - 8) & 15)] ^ W[hook(4, (52 - 14) & 15)] ^ W[hook(4, 52 & 15)], (W[hook(4, 52 & 15)] = rotate((temp), (unsigned int)(1))));
      E = rotate((E), (unsigned int)(30));
    };
    {
      B += rotate((C), (unsigned int)(5)) + ((D & E) | (A & (D | E))) + 0x8f1bbcdc + (temp = W[hook(4, (53 - 3) & 15)] ^ W[hook(4, (53 - 8) & 15)] ^ W[hook(4, (53 - 14) & 15)] ^ W[hook(4, 53 & 15)], (W[hook(4, 53 & 15)] = rotate((temp), (unsigned int)(1))));
      D = rotate((D), (unsigned int)(30));
    };
    {
      A += rotate((B), (unsigned int)(5)) + ((C & D) | (E & (C | D))) + 0x8f1bbcdc + (temp = W[hook(4, (54 - 3) & 15)] ^ W[hook(4, (54 - 8) & 15)] ^ W[hook(4, (54 - 14) & 15)] ^ W[hook(4, 54 & 15)], (W[hook(4, 54 & 15)] = rotate((temp), (unsigned int)(1))));
      C = rotate((C), (unsigned int)(30));
    };
    {
      E += rotate((A), (unsigned int)(5)) + ((B & C) | (D & (B | C))) + 0x8f1bbcdc + (temp = W[hook(4, (55 - 3) & 15)] ^ W[hook(4, (55 - 8) & 15)] ^ W[hook(4, (55 - 14) & 15)] ^ W[hook(4, 55 & 15)], (W[hook(4, 55 & 15)] = rotate((temp), (unsigned int)(1))));
      B = rotate((B), (unsigned int)(30));
    };
    {
      D += rotate((E), (unsigned int)(5)) + ((A & B) | (C & (A | B))) + 0x8f1bbcdc + (temp = W[hook(4, (56 - 3) & 15)] ^ W[hook(4, (56 - 8) & 15)] ^ W[hook(4, (56 - 14) & 15)] ^ W[hook(4, 56 & 15)], (W[hook(4, 56 & 15)] = rotate((temp), (unsigned int)(1))));
      A = rotate((A), (unsigned int)(30));
    };
    {
      C += rotate((D), (unsigned int)(5)) + ((E & A) | (B & (E | A))) + 0x8f1bbcdc + (temp = W[hook(4, (57 - 3) & 15)] ^ W[hook(4, (57 - 8) & 15)] ^ W[hook(4, (57 - 14) & 15)] ^ W[hook(4, 57 & 15)], (W[hook(4, 57 & 15)] = rotate((temp), (unsigned int)(1))));
      E = rotate((E), (unsigned int)(30));
    };
    {
      B += rotate((C), (unsigned int)(5)) + ((D & E) | (A & (D | E))) + 0x8f1bbcdc + (temp = W[hook(4, (58 - 3) & 15)] ^ W[hook(4, (58 - 8) & 15)] ^ W[hook(4, (58 - 14) & 15)] ^ W[hook(4, 58 & 15)], (W[hook(4, 58 & 15)] = rotate((temp), (unsigned int)(1))));
      D = rotate((D), (unsigned int)(30));
    };
    {
      A += rotate((B), (unsigned int)(5)) + ((C & D) | (E & (C | D))) + 0x8f1bbcdc + (temp = W[hook(4, (59 - 3) & 15)] ^ W[hook(4, (59 - 8) & 15)] ^ W[hook(4, (59 - 14) & 15)] ^ W[hook(4, 59 & 15)], (W[hook(4, 59 & 15)] = rotate((temp), (unsigned int)(1))));
      C = rotate((C), (unsigned int)(30));
    };
    {
      E += rotate((A), (unsigned int)(5)) + (B ^ C ^ D) + 0xca62c1d6 + (temp = W[hook(4, (60 - 3) & 15)] ^ W[hook(4, (60 - 8) & 15)] ^ W[hook(4, (60 - 14) & 15)] ^ W[hook(4, 60 & 15)], (W[hook(4, 60 & 15)] = rotate((temp), (unsigned int)(1))));
      B = rotate((B), (unsigned int)(30));
    };
    {
      D += rotate((E), (unsigned int)(5)) + (A ^ B ^ C) + 0xca62c1d6 + (temp = W[hook(4, (61 - 3) & 15)] ^ W[hook(4, (61 - 8) & 15)] ^ W[hook(4, (61 - 14) & 15)] ^ W[hook(4, 61 & 15)], (W[hook(4, 61 & 15)] = rotate((temp), (unsigned int)(1))));
      A = rotate((A), (unsigned int)(30));
    };
    {
      C += rotate((D), (unsigned int)(5)) + (E ^ A ^ B) + 0xca62c1d6 + (temp = W[hook(4, (62 - 3) & 15)] ^ W[hook(4, (62 - 8) & 15)] ^ W[hook(4, (62 - 14) & 15)] ^ W[hook(4, 62 & 15)], (W[hook(4, 62 & 15)] = rotate((temp), (unsigned int)(1))));
      E = rotate((E), (unsigned int)(30));
    };
    {
      B += rotate((C), (unsigned int)(5)) + (D ^ E ^ A) + 0xca62c1d6 + (temp = W[hook(4, (63 - 3) & 15)] ^ W[hook(4, (63 - 8) & 15)] ^ W[hook(4, (63 - 14) & 15)] ^ W[hook(4, 63 & 15)], (W[hook(4, 63 & 15)] = rotate((temp), (unsigned int)(1))));
      D = rotate((D), (unsigned int)(30));
    };
    {
      A += rotate((B), (unsigned int)(5)) + (C ^ D ^ E) + 0xca62c1d6 + (temp = W[hook(4, (64 - 3) & 15)] ^ W[hook(4, (64 - 8) & 15)] ^ W[hook(4, (64 - 14) & 15)] ^ W[hook(4, 64 & 15)], (W[hook(4, 64 & 15)] = rotate((temp), (unsigned int)(1))));
      C = rotate((C), (unsigned int)(30));
    };
    {
      E += rotate((A), (unsigned int)(5)) + (B ^ C ^ D) + 0xca62c1d6 + (temp = W[hook(4, (65 - 3) & 15)] ^ W[hook(4, (65 - 8) & 15)] ^ W[hook(4, (65 - 14) & 15)] ^ W[hook(4, 65 & 15)], (W[hook(4, 65 & 15)] = rotate((temp), (unsigned int)(1))));
      B = rotate((B), (unsigned int)(30));
    };
    {
      D += rotate((E), (unsigned int)(5)) + (A ^ B ^ C) + 0xca62c1d6 + (temp = W[hook(4, (66 - 3) & 15)] ^ W[hook(4, (66 - 8) & 15)] ^ W[hook(4, (66 - 14) & 15)] ^ W[hook(4, 66 & 15)], (W[hook(4, 66 & 15)] = rotate((temp), (unsigned int)(1))));
      A = rotate((A), (unsigned int)(30));
    };
    {
      C += rotate((D), (unsigned int)(5)) + (E ^ A ^ B) + 0xca62c1d6 + (temp = W[hook(4, (67 - 3) & 15)] ^ W[hook(4, (67 - 8) & 15)] ^ W[hook(4, (67 - 14) & 15)] ^ W[hook(4, 67 & 15)], (W[hook(4, 67 & 15)] = rotate((temp), (unsigned int)(1))));
      E = rotate((E), (unsigned int)(30));
    };
    {
      B += rotate((C), (unsigned int)(5)) + (D ^ E ^ A) + 0xca62c1d6 + (temp = W[hook(4, (68 - 3) & 15)] ^ W[hook(4, (68 - 8) & 15)] ^ W[hook(4, (68 - 14) & 15)] ^ W[hook(4, 68 & 15)], (W[hook(4, 68 & 15)] = rotate((temp), (unsigned int)(1))));
      D = rotate((D), (unsigned int)(30));
    };
    {
      A += rotate((B), (unsigned int)(5)) + (C ^ D ^ E) + 0xca62c1d6 + (temp = W[hook(4, (69 - 3) & 15)] ^ W[hook(4, (69 - 8) & 15)] ^ W[hook(4, (69 - 14) & 15)] ^ W[hook(4, 69 & 15)], (W[hook(4, 69 & 15)] = rotate((temp), (unsigned int)(1))));
      C = rotate((C), (unsigned int)(30));
    };
    {
      E += rotate((A), (unsigned int)(5)) + (B ^ C ^ D) + 0xca62c1d6 + (temp = W[hook(4, (70 - 3) & 15)] ^ W[hook(4, (70 - 8) & 15)] ^ W[hook(4, (70 - 14) & 15)] ^ W[hook(4, 70 & 15)], (W[hook(4, 70 & 15)] = rotate((temp), (unsigned int)(1))));
      B = rotate((B), (unsigned int)(30));
    };
    {
      D += rotate((E), (unsigned int)(5)) + (A ^ B ^ C) + 0xca62c1d6 + (temp = W[hook(4, (71 - 3) & 15)] ^ W[hook(4, (71 - 8) & 15)] ^ W[hook(4, (71 - 14) & 15)] ^ W[hook(4, 71 & 15)], (W[hook(4, 71 & 15)] = rotate((temp), (unsigned int)(1))));
      A = rotate((A), (unsigned int)(30));
    };
    {
      C += rotate((D), (unsigned int)(5)) + (E ^ A ^ B) + 0xca62c1d6 + (temp = W[hook(4, (72 - 3) & 15)] ^ W[hook(4, (72 - 8) & 15)] ^ W[hook(4, (72 - 14) & 15)] ^ W[hook(4, 72 & 15)], (W[hook(4, 72 & 15)] = rotate((temp), (unsigned int)(1))));
      E = rotate((E), (unsigned int)(30));
    };
    {
      B += rotate((C), (unsigned int)(5)) + (D ^ E ^ A) + 0xca62c1d6 + (temp = W[hook(4, (73 - 3) & 15)] ^ W[hook(4, (73 - 8) & 15)] ^ W[hook(4, (73 - 14) & 15)] ^ W[hook(4, 73 & 15)], (W[hook(4, 73 & 15)] = rotate((temp), (unsigned int)(1))));
      D = rotate((D), (unsigned int)(30));
    };
    {
      A += rotate((B), (unsigned int)(5)) + (C ^ D ^ E) + 0xca62c1d6 + (temp = W[hook(4, (74 - 3) & 15)] ^ W[hook(4, (74 - 8) & 15)] ^ W[hook(4, (74 - 14) & 15)] ^ W[hook(4, 74 & 15)], (W[hook(4, 74 & 15)] = rotate((temp), (unsigned int)(1))));
      C = rotate((C), (unsigned int)(30));
    };
    {
      E += rotate((A), (unsigned int)(5)) + (B ^ C ^ D) + 0xca62c1d6 + (temp = W[hook(4, (75 - 3) & 15)] ^ W[hook(4, (75 - 8) & 15)] ^ W[hook(4, (75 - 14) & 15)] ^ W[hook(4, 75 & 15)], (W[hook(4, 75 & 15)] = rotate((temp), (unsigned int)(1))));
      B = rotate((B), (unsigned int)(30));
    };
    {
      D += rotate((E), (unsigned int)(5)) + (A ^ B ^ C) + 0xca62c1d6 + (temp = W[hook(4, (76 - 3) & 15)] ^ W[hook(4, (76 - 8) & 15)] ^ W[hook(4, (76 - 14) & 15)] ^ W[hook(4, 76 & 15)], (W[hook(4, 76 & 15)] = rotate((temp), (unsigned int)(1))));
      A = rotate((A), (unsigned int)(30));
    };
    {
      C += rotate((D), (unsigned int)(5)) + (E ^ A ^ B) + 0xca62c1d6 + (temp = W[hook(4, (77 - 3) & 15)] ^ W[hook(4, (77 - 8) & 15)] ^ W[hook(4, (77 - 14) & 15)] ^ W[hook(4, 77 & 15)], (W[hook(4, 77 & 15)] = rotate((temp), (unsigned int)(1))));
      E = rotate((E), (unsigned int)(30));
    };
    {
      B += rotate((C), (unsigned int)(5)) + (D ^ E ^ A) + 0xca62c1d6 + (temp = W[hook(4, (78 - 3) & 15)] ^ W[hook(4, (78 - 8) & 15)] ^ W[hook(4, (78 - 14) & 15)] ^ W[hook(4, 78 & 15)], (W[hook(4, 78 & 15)] = rotate((temp), (unsigned int)(1))));
      D = rotate((D), (unsigned int)(30));
    };
    {
      A += rotate((B), (unsigned int)(5)) + (C ^ D ^ E) + 0xca62c1d6 + (temp = W[hook(4, (79 - 3) & 15)] ^ W[hook(4, (79 - 8) & 15)] ^ W[hook(4, (79 - 14) & 15)] ^ W[hook(4, 79 & 15)], (W[hook(4, 79 & 15)] = rotate((temp), (unsigned int)(1))));
      C = rotate((C), (unsigned int)(30));
    };
    ;
    output[hook(6, 0)] += A;
    output[hook(6, 1)] += B;
    output[hook(6, 2)] += C;
    output[hook(6, 3)] += D;
    output[hook(6, 4)] += E;
  };

  digest[hook(3, gid * 5)] = (__builtin_astype((__builtin_astype((output[hook(6, 0)]), uchar4).wzyx), unsigned int));
  digest[hook(3, gid * 5 + 1)] = (__builtin_astype((__builtin_astype((output[hook(6, 1)]), uchar4).wzyx), unsigned int));
  digest[hook(3, gid * 5 + 2)] = (__builtin_astype((__builtin_astype((output[hook(6, 2)]), uchar4).wzyx), unsigned int));
  digest[hook(3, gid * 5 + 3)] = (__builtin_astype((__builtin_astype((output[hook(6, 3)]), uchar4).wzyx), unsigned int));
  digest[hook(3, gid * 5 + 4)] = (__builtin_astype((__builtin_astype((output[hook(6, 4)]), uchar4).wzyx), unsigned int));
}