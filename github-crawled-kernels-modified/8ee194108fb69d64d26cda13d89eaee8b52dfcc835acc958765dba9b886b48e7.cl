//{"((__private uchar *)(W))":4,"W":3,"digest":2,"index":1,"keys":0,"output":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sha1_crypt_kernel(global unsigned int* keys, global const unsigned int* index, global unsigned int* digest) {
  unsigned int W[16] = {0}, output[5];
  unsigned int temp, A, B, C, D, E;
  unsigned int gid = get_global_id(0);
  unsigned int num_keys = get_global_size(0);
  unsigned int base = index[hook(1, gid)];
  unsigned int len = base & 63;
  unsigned int i;

  keys += base >> 6;

  for (i = 0; i < (len + 3) / 4; i++)
    W[hook(3, i)] = (__builtin_astype((__builtin_astype((*keys++), uchar4).wzyx), unsigned int));

  ((uchar*)(W))[hook(4, (len) ^ 3)] = (0x80);
  W[hook(3, 15)] = len << 3;

  {
    output[hook(5, 0)] = 0x67452301;
    output[hook(5, 1)] = 0xefcdab89;
    output[hook(5, 2)] = 0x98badcfe;
    output[hook(5, 3)] = 0x10325476;
    output[hook(5, 4)] = 0xc3d2e1f0;
  };
  {
    A = output[hook(5, 0)];
    B = output[hook(5, 1)];
    C = output[hook(5, 2)];
    D = output[hook(5, 3)];
    E = output[hook(5, 4)];
    {
      E += rotate((A), (unsigned int)(5)) + (D ^ (B & (C ^ D))) + 0x5a827999 + W[hook(3, 0)];
      B = rotate((B), (unsigned int)(30));
    };
    {
      D += rotate((E), (unsigned int)(5)) + (C ^ (A & (B ^ C))) + 0x5a827999 + W[hook(3, 1)];
      A = rotate((A), (unsigned int)(30));
    };
    {
      C += rotate((D), (unsigned int)(5)) + (B ^ (E & (A ^ B))) + 0x5a827999 + W[hook(3, 2)];
      E = rotate((E), (unsigned int)(30));
    };
    {
      B += rotate((C), (unsigned int)(5)) + (A ^ (D & (E ^ A))) + 0x5a827999 + W[hook(3, 3)];
      D = rotate((D), (unsigned int)(30));
    };
    {
      A += rotate((B), (unsigned int)(5)) + (E ^ (C & (D ^ E))) + 0x5a827999 + W[hook(3, 4)];
      C = rotate((C), (unsigned int)(30));
    };
    {
      E += rotate((A), (unsigned int)(5)) + (D ^ (B & (C ^ D))) + 0x5a827999 + W[hook(3, 5)];
      B = rotate((B), (unsigned int)(30));
    };
    {
      D += rotate((E), (unsigned int)(5)) + (C ^ (A & (B ^ C))) + 0x5a827999 + W[hook(3, 6)];
      A = rotate((A), (unsigned int)(30));
    };
    {
      C += rotate((D), (unsigned int)(5)) + (B ^ (E & (A ^ B))) + 0x5a827999 + W[hook(3, 7)];
      E = rotate((E), (unsigned int)(30));
    };
    {
      B += rotate((C), (unsigned int)(5)) + (A ^ (D & (E ^ A))) + 0x5a827999 + W[hook(3, 8)];
      D = rotate((D), (unsigned int)(30));
    };
    {
      A += rotate((B), (unsigned int)(5)) + (E ^ (C & (D ^ E))) + 0x5a827999 + W[hook(3, 9)];
      C = rotate((C), (unsigned int)(30));
    };
    {
      E += rotate((A), (unsigned int)(5)) + (D ^ (B & (C ^ D))) + 0x5a827999 + W[hook(3, 10)];
      B = rotate((B), (unsigned int)(30));
    };
    {
      D += rotate((E), (unsigned int)(5)) + (C ^ (A & (B ^ C))) + 0x5a827999 + W[hook(3, 11)];
      A = rotate((A), (unsigned int)(30));
    };
    {
      C += rotate((D), (unsigned int)(5)) + (B ^ (E & (A ^ B))) + 0x5a827999 + W[hook(3, 12)];
      E = rotate((E), (unsigned int)(30));
    };
    {
      B += rotate((C), (unsigned int)(5)) + (A ^ (D & (E ^ A))) + 0x5a827999 + W[hook(3, 13)];
      D = rotate((D), (unsigned int)(30));
    };
    {
      A += rotate((B), (unsigned int)(5)) + (E ^ (C & (D ^ E))) + 0x5a827999 + W[hook(3, 14)];
      C = rotate((C), (unsigned int)(30));
    };
    {
      E += rotate((A), (unsigned int)(5)) + (D ^ (B & (C ^ D))) + 0x5a827999 + W[hook(3, 15)];
      B = rotate((B), (unsigned int)(30));
    };
    {
      D += rotate((E), (unsigned int)(5)) + (C ^ (A & (B ^ C))) + 0x5a827999 + (temp = W[hook(3, (16 - 3) & 15)] ^ W[hook(3, (16 - 8) & 15)] ^ W[hook(3, (16 - 14) & 15)] ^ W[hook(3, 16 & 15)], (W[hook(3, 16 & 15)] = rotate((temp), (unsigned int)(1))));
      A = rotate((A), (unsigned int)(30));
    };
    {
      C += rotate((D), (unsigned int)(5)) + (B ^ (E & (A ^ B))) + 0x5a827999 + (temp = W[hook(3, (17 - 3) & 15)] ^ W[hook(3, (17 - 8) & 15)] ^ W[hook(3, (17 - 14) & 15)] ^ W[hook(3, 17 & 15)], (W[hook(3, 17 & 15)] = rotate((temp), (unsigned int)(1))));
      E = rotate((E), (unsigned int)(30));
    };
    {
      B += rotate((C), (unsigned int)(5)) + (A ^ (D & (E ^ A))) + 0x5a827999 + (temp = W[hook(3, (18 - 3) & 15)] ^ W[hook(3, (18 - 8) & 15)] ^ W[hook(3, (18 - 14) & 15)] ^ W[hook(3, 18 & 15)], (W[hook(3, 18 & 15)] = rotate((temp), (unsigned int)(1))));
      D = rotate((D), (unsigned int)(30));
    };
    {
      A += rotate((B), (unsigned int)(5)) + (E ^ (C & (D ^ E))) + 0x5a827999 + (temp = W[hook(3, (19 - 3) & 15)] ^ W[hook(3, (19 - 8) & 15)] ^ W[hook(3, (19 - 14) & 15)] ^ W[hook(3, 19 & 15)], (W[hook(3, 19 & 15)] = rotate((temp), (unsigned int)(1))));
      C = rotate((C), (unsigned int)(30));
    };
    {
      E += rotate((A), (unsigned int)(5)) + (B ^ C ^ D) + 0x6ed9eba1 + (temp = W[hook(3, (20 - 3) & 15)] ^ W[hook(3, (20 - 8) & 15)] ^ W[hook(3, (20 - 14) & 15)] ^ W[hook(3, 20 & 15)], (W[hook(3, 20 & 15)] = rotate((temp), (unsigned int)(1))));
      B = rotate((B), (unsigned int)(30));
    };
    {
      D += rotate((E), (unsigned int)(5)) + (A ^ B ^ C) + 0x6ed9eba1 + (temp = W[hook(3, (21 - 3) & 15)] ^ W[hook(3, (21 - 8) & 15)] ^ W[hook(3, (21 - 14) & 15)] ^ W[hook(3, 21 & 15)], (W[hook(3, 21 & 15)] = rotate((temp), (unsigned int)(1))));
      A = rotate((A), (unsigned int)(30));
    };
    {
      C += rotate((D), (unsigned int)(5)) + (E ^ A ^ B) + 0x6ed9eba1 + (temp = W[hook(3, (22 - 3) & 15)] ^ W[hook(3, (22 - 8) & 15)] ^ W[hook(3, (22 - 14) & 15)] ^ W[hook(3, 22 & 15)], (W[hook(3, 22 & 15)] = rotate((temp), (unsigned int)(1))));
      E = rotate((E), (unsigned int)(30));
    };
    {
      B += rotate((C), (unsigned int)(5)) + (D ^ E ^ A) + 0x6ed9eba1 + (temp = W[hook(3, (23 - 3) & 15)] ^ W[hook(3, (23 - 8) & 15)] ^ W[hook(3, (23 - 14) & 15)] ^ W[hook(3, 23 & 15)], (W[hook(3, 23 & 15)] = rotate((temp), (unsigned int)(1))));
      D = rotate((D), (unsigned int)(30));
    };
    {
      A += rotate((B), (unsigned int)(5)) + (C ^ D ^ E) + 0x6ed9eba1 + (temp = W[hook(3, (24 - 3) & 15)] ^ W[hook(3, (24 - 8) & 15)] ^ W[hook(3, (24 - 14) & 15)] ^ W[hook(3, 24 & 15)], (W[hook(3, 24 & 15)] = rotate((temp), (unsigned int)(1))));
      C = rotate((C), (unsigned int)(30));
    };
    {
      E += rotate((A), (unsigned int)(5)) + (B ^ C ^ D) + 0x6ed9eba1 + (temp = W[hook(3, (25 - 3) & 15)] ^ W[hook(3, (25 - 8) & 15)] ^ W[hook(3, (25 - 14) & 15)] ^ W[hook(3, 25 & 15)], (W[hook(3, 25 & 15)] = rotate((temp), (unsigned int)(1))));
      B = rotate((B), (unsigned int)(30));
    };
    {
      D += rotate((E), (unsigned int)(5)) + (A ^ B ^ C) + 0x6ed9eba1 + (temp = W[hook(3, (26 - 3) & 15)] ^ W[hook(3, (26 - 8) & 15)] ^ W[hook(3, (26 - 14) & 15)] ^ W[hook(3, 26 & 15)], (W[hook(3, 26 & 15)] = rotate((temp), (unsigned int)(1))));
      A = rotate((A), (unsigned int)(30));
    };
    {
      C += rotate((D), (unsigned int)(5)) + (E ^ A ^ B) + 0x6ed9eba1 + (temp = W[hook(3, (27 - 3) & 15)] ^ W[hook(3, (27 - 8) & 15)] ^ W[hook(3, (27 - 14) & 15)] ^ W[hook(3, 27 & 15)], (W[hook(3, 27 & 15)] = rotate((temp), (unsigned int)(1))));
      E = rotate((E), (unsigned int)(30));
    };
    {
      B += rotate((C), (unsigned int)(5)) + (D ^ E ^ A) + 0x6ed9eba1 + (temp = W[hook(3, (28 - 3) & 15)] ^ W[hook(3, (28 - 8) & 15)] ^ W[hook(3, (28 - 14) & 15)] ^ W[hook(3, 28 & 15)], (W[hook(3, 28 & 15)] = rotate((temp), (unsigned int)(1))));
      D = rotate((D), (unsigned int)(30));
    };
    {
      A += rotate((B), (unsigned int)(5)) + (C ^ D ^ E) + 0x6ed9eba1 + (temp = W[hook(3, (29 - 3) & 15)] ^ W[hook(3, (29 - 8) & 15)] ^ W[hook(3, (29 - 14) & 15)] ^ W[hook(3, 29 & 15)], (W[hook(3, 29 & 15)] = rotate((temp), (unsigned int)(1))));
      C = rotate((C), (unsigned int)(30));
    };
    {
      E += rotate((A), (unsigned int)(5)) + (B ^ C ^ D) + 0x6ed9eba1 + (temp = W[hook(3, (30 - 3) & 15)] ^ W[hook(3, (30 - 8) & 15)] ^ W[hook(3, (30 - 14) & 15)] ^ W[hook(3, 30 & 15)], (W[hook(3, 30 & 15)] = rotate((temp), (unsigned int)(1))));
      B = rotate((B), (unsigned int)(30));
    };
    {
      D += rotate((E), (unsigned int)(5)) + (A ^ B ^ C) + 0x6ed9eba1 + (temp = W[hook(3, (31 - 3) & 15)] ^ W[hook(3, (31 - 8) & 15)] ^ W[hook(3, (31 - 14) & 15)] ^ W[hook(3, 31 & 15)], (W[hook(3, 31 & 15)] = rotate((temp), (unsigned int)(1))));
      A = rotate((A), (unsigned int)(30));
    };
    {
      C += rotate((D), (unsigned int)(5)) + (E ^ A ^ B) + 0x6ed9eba1 + (temp = W[hook(3, (32 - 3) & 15)] ^ W[hook(3, (32 - 8) & 15)] ^ W[hook(3, (32 - 14) & 15)] ^ W[hook(3, 32 & 15)], (W[hook(3, 32 & 15)] = rotate((temp), (unsigned int)(1))));
      E = rotate((E), (unsigned int)(30));
    };
    {
      B += rotate((C), (unsigned int)(5)) + (D ^ E ^ A) + 0x6ed9eba1 + (temp = W[hook(3, (33 - 3) & 15)] ^ W[hook(3, (33 - 8) & 15)] ^ W[hook(3, (33 - 14) & 15)] ^ W[hook(3, 33 & 15)], (W[hook(3, 33 & 15)] = rotate((temp), (unsigned int)(1))));
      D = rotate((D), (unsigned int)(30));
    };
    {
      A += rotate((B), (unsigned int)(5)) + (C ^ D ^ E) + 0x6ed9eba1 + (temp = W[hook(3, (34 - 3) & 15)] ^ W[hook(3, (34 - 8) & 15)] ^ W[hook(3, (34 - 14) & 15)] ^ W[hook(3, 34 & 15)], (W[hook(3, 34 & 15)] = rotate((temp), (unsigned int)(1))));
      C = rotate((C), (unsigned int)(30));
    };
    {
      E += rotate((A), (unsigned int)(5)) + (B ^ C ^ D) + 0x6ed9eba1 + (temp = W[hook(3, (35 - 3) & 15)] ^ W[hook(3, (35 - 8) & 15)] ^ W[hook(3, (35 - 14) & 15)] ^ W[hook(3, 35 & 15)], (W[hook(3, 35 & 15)] = rotate((temp), (unsigned int)(1))));
      B = rotate((B), (unsigned int)(30));
    };
    {
      D += rotate((E), (unsigned int)(5)) + (A ^ B ^ C) + 0x6ed9eba1 + (temp = W[hook(3, (36 - 3) & 15)] ^ W[hook(3, (36 - 8) & 15)] ^ W[hook(3, (36 - 14) & 15)] ^ W[hook(3, 36 & 15)], (W[hook(3, 36 & 15)] = rotate((temp), (unsigned int)(1))));
      A = rotate((A), (unsigned int)(30));
    };
    {
      C += rotate((D), (unsigned int)(5)) + (E ^ A ^ B) + 0x6ed9eba1 + (temp = W[hook(3, (37 - 3) & 15)] ^ W[hook(3, (37 - 8) & 15)] ^ W[hook(3, (37 - 14) & 15)] ^ W[hook(3, 37 & 15)], (W[hook(3, 37 & 15)] = rotate((temp), (unsigned int)(1))));
      E = rotate((E), (unsigned int)(30));
    };
    {
      B += rotate((C), (unsigned int)(5)) + (D ^ E ^ A) + 0x6ed9eba1 + (temp = W[hook(3, (38 - 3) & 15)] ^ W[hook(3, (38 - 8) & 15)] ^ W[hook(3, (38 - 14) & 15)] ^ W[hook(3, 38 & 15)], (W[hook(3, 38 & 15)] = rotate((temp), (unsigned int)(1))));
      D = rotate((D), (unsigned int)(30));
    };
    {
      A += rotate((B), (unsigned int)(5)) + (C ^ D ^ E) + 0x6ed9eba1 + (temp = W[hook(3, (39 - 3) & 15)] ^ W[hook(3, (39 - 8) & 15)] ^ W[hook(3, (39 - 14) & 15)] ^ W[hook(3, 39 & 15)], (W[hook(3, 39 & 15)] = rotate((temp), (unsigned int)(1))));
      C = rotate((C), (unsigned int)(30));
    };
    {
      E += rotate((A), (unsigned int)(5)) + ((B & C) | (D & (B | C))) + 0x8f1bbcdc + (temp = W[hook(3, (40 - 3) & 15)] ^ W[hook(3, (40 - 8) & 15)] ^ W[hook(3, (40 - 14) & 15)] ^ W[hook(3, 40 & 15)], (W[hook(3, 40 & 15)] = rotate((temp), (unsigned int)(1))));
      B = rotate((B), (unsigned int)(30));
    };
    {
      D += rotate((E), (unsigned int)(5)) + ((A & B) | (C & (A | B))) + 0x8f1bbcdc + (temp = W[hook(3, (41 - 3) & 15)] ^ W[hook(3, (41 - 8) & 15)] ^ W[hook(3, (41 - 14) & 15)] ^ W[hook(3, 41 & 15)], (W[hook(3, 41 & 15)] = rotate((temp), (unsigned int)(1))));
      A = rotate((A), (unsigned int)(30));
    };
    {
      C += rotate((D), (unsigned int)(5)) + ((E & A) | (B & (E | A))) + 0x8f1bbcdc + (temp = W[hook(3, (42 - 3) & 15)] ^ W[hook(3, (42 - 8) & 15)] ^ W[hook(3, (42 - 14) & 15)] ^ W[hook(3, 42 & 15)], (W[hook(3, 42 & 15)] = rotate((temp), (unsigned int)(1))));
      E = rotate((E), (unsigned int)(30));
    };
    {
      B += rotate((C), (unsigned int)(5)) + ((D & E) | (A & (D | E))) + 0x8f1bbcdc + (temp = W[hook(3, (43 - 3) & 15)] ^ W[hook(3, (43 - 8) & 15)] ^ W[hook(3, (43 - 14) & 15)] ^ W[hook(3, 43 & 15)], (W[hook(3, 43 & 15)] = rotate((temp), (unsigned int)(1))));
      D = rotate((D), (unsigned int)(30));
    };
    {
      A += rotate((B), (unsigned int)(5)) + ((C & D) | (E & (C | D))) + 0x8f1bbcdc + (temp = W[hook(3, (44 - 3) & 15)] ^ W[hook(3, (44 - 8) & 15)] ^ W[hook(3, (44 - 14) & 15)] ^ W[hook(3, 44 & 15)], (W[hook(3, 44 & 15)] = rotate((temp), (unsigned int)(1))));
      C = rotate((C), (unsigned int)(30));
    };
    {
      E += rotate((A), (unsigned int)(5)) + ((B & C) | (D & (B | C))) + 0x8f1bbcdc + (temp = W[hook(3, (45 - 3) & 15)] ^ W[hook(3, (45 - 8) & 15)] ^ W[hook(3, (45 - 14) & 15)] ^ W[hook(3, 45 & 15)], (W[hook(3, 45 & 15)] = rotate((temp), (unsigned int)(1))));
      B = rotate((B), (unsigned int)(30));
    };
    {
      D += rotate((E), (unsigned int)(5)) + ((A & B) | (C & (A | B))) + 0x8f1bbcdc + (temp = W[hook(3, (46 - 3) & 15)] ^ W[hook(3, (46 - 8) & 15)] ^ W[hook(3, (46 - 14) & 15)] ^ W[hook(3, 46 & 15)], (W[hook(3, 46 & 15)] = rotate((temp), (unsigned int)(1))));
      A = rotate((A), (unsigned int)(30));
    };
    {
      C += rotate((D), (unsigned int)(5)) + ((E & A) | (B & (E | A))) + 0x8f1bbcdc + (temp = W[hook(3, (47 - 3) & 15)] ^ W[hook(3, (47 - 8) & 15)] ^ W[hook(3, (47 - 14) & 15)] ^ W[hook(3, 47 & 15)], (W[hook(3, 47 & 15)] = rotate((temp), (unsigned int)(1))));
      E = rotate((E), (unsigned int)(30));
    };
    {
      B += rotate((C), (unsigned int)(5)) + ((D & E) | (A & (D | E))) + 0x8f1bbcdc + (temp = W[hook(3, (48 - 3) & 15)] ^ W[hook(3, (48 - 8) & 15)] ^ W[hook(3, (48 - 14) & 15)] ^ W[hook(3, 48 & 15)], (W[hook(3, 48 & 15)] = rotate((temp), (unsigned int)(1))));
      D = rotate((D), (unsigned int)(30));
    };
    {
      A += rotate((B), (unsigned int)(5)) + ((C & D) | (E & (C | D))) + 0x8f1bbcdc + (temp = W[hook(3, (49 - 3) & 15)] ^ W[hook(3, (49 - 8) & 15)] ^ W[hook(3, (49 - 14) & 15)] ^ W[hook(3, 49 & 15)], (W[hook(3, 49 & 15)] = rotate((temp), (unsigned int)(1))));
      C = rotate((C), (unsigned int)(30));
    };
    {
      E += rotate((A), (unsigned int)(5)) + ((B & C) | (D & (B | C))) + 0x8f1bbcdc + (temp = W[hook(3, (50 - 3) & 15)] ^ W[hook(3, (50 - 8) & 15)] ^ W[hook(3, (50 - 14) & 15)] ^ W[hook(3, 50 & 15)], (W[hook(3, 50 & 15)] = rotate((temp), (unsigned int)(1))));
      B = rotate((B), (unsigned int)(30));
    };
    {
      D += rotate((E), (unsigned int)(5)) + ((A & B) | (C & (A | B))) + 0x8f1bbcdc + (temp = W[hook(3, (51 - 3) & 15)] ^ W[hook(3, (51 - 8) & 15)] ^ W[hook(3, (51 - 14) & 15)] ^ W[hook(3, 51 & 15)], (W[hook(3, 51 & 15)] = rotate((temp), (unsigned int)(1))));
      A = rotate((A), (unsigned int)(30));
    };
    {
      C += rotate((D), (unsigned int)(5)) + ((E & A) | (B & (E | A))) + 0x8f1bbcdc + (temp = W[hook(3, (52 - 3) & 15)] ^ W[hook(3, (52 - 8) & 15)] ^ W[hook(3, (52 - 14) & 15)] ^ W[hook(3, 52 & 15)], (W[hook(3, 52 & 15)] = rotate((temp), (unsigned int)(1))));
      E = rotate((E), (unsigned int)(30));
    };
    {
      B += rotate((C), (unsigned int)(5)) + ((D & E) | (A & (D | E))) + 0x8f1bbcdc + (temp = W[hook(3, (53 - 3) & 15)] ^ W[hook(3, (53 - 8) & 15)] ^ W[hook(3, (53 - 14) & 15)] ^ W[hook(3, 53 & 15)], (W[hook(3, 53 & 15)] = rotate((temp), (unsigned int)(1))));
      D = rotate((D), (unsigned int)(30));
    };
    {
      A += rotate((B), (unsigned int)(5)) + ((C & D) | (E & (C | D))) + 0x8f1bbcdc + (temp = W[hook(3, (54 - 3) & 15)] ^ W[hook(3, (54 - 8) & 15)] ^ W[hook(3, (54 - 14) & 15)] ^ W[hook(3, 54 & 15)], (W[hook(3, 54 & 15)] = rotate((temp), (unsigned int)(1))));
      C = rotate((C), (unsigned int)(30));
    };
    {
      E += rotate((A), (unsigned int)(5)) + ((B & C) | (D & (B | C))) + 0x8f1bbcdc + (temp = W[hook(3, (55 - 3) & 15)] ^ W[hook(3, (55 - 8) & 15)] ^ W[hook(3, (55 - 14) & 15)] ^ W[hook(3, 55 & 15)], (W[hook(3, 55 & 15)] = rotate((temp), (unsigned int)(1))));
      B = rotate((B), (unsigned int)(30));
    };
    {
      D += rotate((E), (unsigned int)(5)) + ((A & B) | (C & (A | B))) + 0x8f1bbcdc + (temp = W[hook(3, (56 - 3) & 15)] ^ W[hook(3, (56 - 8) & 15)] ^ W[hook(3, (56 - 14) & 15)] ^ W[hook(3, 56 & 15)], (W[hook(3, 56 & 15)] = rotate((temp), (unsigned int)(1))));
      A = rotate((A), (unsigned int)(30));
    };
    {
      C += rotate((D), (unsigned int)(5)) + ((E & A) | (B & (E | A))) + 0x8f1bbcdc + (temp = W[hook(3, (57 - 3) & 15)] ^ W[hook(3, (57 - 8) & 15)] ^ W[hook(3, (57 - 14) & 15)] ^ W[hook(3, 57 & 15)], (W[hook(3, 57 & 15)] = rotate((temp), (unsigned int)(1))));
      E = rotate((E), (unsigned int)(30));
    };
    {
      B += rotate((C), (unsigned int)(5)) + ((D & E) | (A & (D | E))) + 0x8f1bbcdc + (temp = W[hook(3, (58 - 3) & 15)] ^ W[hook(3, (58 - 8) & 15)] ^ W[hook(3, (58 - 14) & 15)] ^ W[hook(3, 58 & 15)], (W[hook(3, 58 & 15)] = rotate((temp), (unsigned int)(1))));
      D = rotate((D), (unsigned int)(30));
    };
    {
      A += rotate((B), (unsigned int)(5)) + ((C & D) | (E & (C | D))) + 0x8f1bbcdc + (temp = W[hook(3, (59 - 3) & 15)] ^ W[hook(3, (59 - 8) & 15)] ^ W[hook(3, (59 - 14) & 15)] ^ W[hook(3, 59 & 15)], (W[hook(3, 59 & 15)] = rotate((temp), (unsigned int)(1))));
      C = rotate((C), (unsigned int)(30));
    };
    {
      E += rotate((A), (unsigned int)(5)) + (B ^ C ^ D) + 0xca62c1d6 + (temp = W[hook(3, (60 - 3) & 15)] ^ W[hook(3, (60 - 8) & 15)] ^ W[hook(3, (60 - 14) & 15)] ^ W[hook(3, 60 & 15)], (W[hook(3, 60 & 15)] = rotate((temp), (unsigned int)(1))));
      B = rotate((B), (unsigned int)(30));
    };
    {
      D += rotate((E), (unsigned int)(5)) + (A ^ B ^ C) + 0xca62c1d6 + (temp = W[hook(3, (61 - 3) & 15)] ^ W[hook(3, (61 - 8) & 15)] ^ W[hook(3, (61 - 14) & 15)] ^ W[hook(3, 61 & 15)], (W[hook(3, 61 & 15)] = rotate((temp), (unsigned int)(1))));
      A = rotate((A), (unsigned int)(30));
    };
    {
      C += rotate((D), (unsigned int)(5)) + (E ^ A ^ B) + 0xca62c1d6 + (temp = W[hook(3, (62 - 3) & 15)] ^ W[hook(3, (62 - 8) & 15)] ^ W[hook(3, (62 - 14) & 15)] ^ W[hook(3, 62 & 15)], (W[hook(3, 62 & 15)] = rotate((temp), (unsigned int)(1))));
      E = rotate((E), (unsigned int)(30));
    };
    {
      B += rotate((C), (unsigned int)(5)) + (D ^ E ^ A) + 0xca62c1d6 + (temp = W[hook(3, (63 - 3) & 15)] ^ W[hook(3, (63 - 8) & 15)] ^ W[hook(3, (63 - 14) & 15)] ^ W[hook(3, 63 & 15)], (W[hook(3, 63 & 15)] = rotate((temp), (unsigned int)(1))));
      D = rotate((D), (unsigned int)(30));
    };
    {
      A += rotate((B), (unsigned int)(5)) + (C ^ D ^ E) + 0xca62c1d6 + (temp = W[hook(3, (64 - 3) & 15)] ^ W[hook(3, (64 - 8) & 15)] ^ W[hook(3, (64 - 14) & 15)] ^ W[hook(3, 64 & 15)], (W[hook(3, 64 & 15)] = rotate((temp), (unsigned int)(1))));
      C = rotate((C), (unsigned int)(30));
    };
    {
      E += rotate((A), (unsigned int)(5)) + (B ^ C ^ D) + 0xca62c1d6 + (temp = W[hook(3, (65 - 3) & 15)] ^ W[hook(3, (65 - 8) & 15)] ^ W[hook(3, (65 - 14) & 15)] ^ W[hook(3, 65 & 15)], (W[hook(3, 65 & 15)] = rotate((temp), (unsigned int)(1))));
      B = rotate((B), (unsigned int)(30));
    };
    {
      D += rotate((E), (unsigned int)(5)) + (A ^ B ^ C) + 0xca62c1d6 + (temp = W[hook(3, (66 - 3) & 15)] ^ W[hook(3, (66 - 8) & 15)] ^ W[hook(3, (66 - 14) & 15)] ^ W[hook(3, 66 & 15)], (W[hook(3, 66 & 15)] = rotate((temp), (unsigned int)(1))));
      A = rotate((A), (unsigned int)(30));
    };
    {
      C += rotate((D), (unsigned int)(5)) + (E ^ A ^ B) + 0xca62c1d6 + (temp = W[hook(3, (67 - 3) & 15)] ^ W[hook(3, (67 - 8) & 15)] ^ W[hook(3, (67 - 14) & 15)] ^ W[hook(3, 67 & 15)], (W[hook(3, 67 & 15)] = rotate((temp), (unsigned int)(1))));
      E = rotate((E), (unsigned int)(30));
    };
    {
      B += rotate((C), (unsigned int)(5)) + (D ^ E ^ A) + 0xca62c1d6 + (temp = W[hook(3, (68 - 3) & 15)] ^ W[hook(3, (68 - 8) & 15)] ^ W[hook(3, (68 - 14) & 15)] ^ W[hook(3, 68 & 15)], (W[hook(3, 68 & 15)] = rotate((temp), (unsigned int)(1))));
      D = rotate((D), (unsigned int)(30));
    };
    {
      A += rotate((B), (unsigned int)(5)) + (C ^ D ^ E) + 0xca62c1d6 + (temp = W[hook(3, (69 - 3) & 15)] ^ W[hook(3, (69 - 8) & 15)] ^ W[hook(3, (69 - 14) & 15)] ^ W[hook(3, 69 & 15)], (W[hook(3, 69 & 15)] = rotate((temp), (unsigned int)(1))));
      C = rotate((C), (unsigned int)(30));
    };
    {
      E += rotate((A), (unsigned int)(5)) + (B ^ C ^ D) + 0xca62c1d6 + (temp = W[hook(3, (70 - 3) & 15)] ^ W[hook(3, (70 - 8) & 15)] ^ W[hook(3, (70 - 14) & 15)] ^ W[hook(3, 70 & 15)], (W[hook(3, 70 & 15)] = rotate((temp), (unsigned int)(1))));
      B = rotate((B), (unsigned int)(30));
    };
    {
      D += rotate((E), (unsigned int)(5)) + (A ^ B ^ C) + 0xca62c1d6 + (temp = W[hook(3, (71 - 3) & 15)] ^ W[hook(3, (71 - 8) & 15)] ^ W[hook(3, (71 - 14) & 15)] ^ W[hook(3, 71 & 15)], (W[hook(3, 71 & 15)] = rotate((temp), (unsigned int)(1))));
      A = rotate((A), (unsigned int)(30));
    };
    {
      C += rotate((D), (unsigned int)(5)) + (E ^ A ^ B) + 0xca62c1d6 + (temp = W[hook(3, (72 - 3) & 15)] ^ W[hook(3, (72 - 8) & 15)] ^ W[hook(3, (72 - 14) & 15)] ^ W[hook(3, 72 & 15)], (W[hook(3, 72 & 15)] = rotate((temp), (unsigned int)(1))));
      E = rotate((E), (unsigned int)(30));
    };
    {
      B += rotate((C), (unsigned int)(5)) + (D ^ E ^ A) + 0xca62c1d6 + (temp = W[hook(3, (73 - 3) & 15)] ^ W[hook(3, (73 - 8) & 15)] ^ W[hook(3, (73 - 14) & 15)] ^ W[hook(3, 73 & 15)], (W[hook(3, 73 & 15)] = rotate((temp), (unsigned int)(1))));
      D = rotate((D), (unsigned int)(30));
    };
    {
      A += rotate((B), (unsigned int)(5)) + (C ^ D ^ E) + 0xca62c1d6 + (temp = W[hook(3, (74 - 3) & 15)] ^ W[hook(3, (74 - 8) & 15)] ^ W[hook(3, (74 - 14) & 15)] ^ W[hook(3, 74 & 15)], (W[hook(3, 74 & 15)] = rotate((temp), (unsigned int)(1))));
      C = rotate((C), (unsigned int)(30));
    };
    {
      E += rotate((A), (unsigned int)(5)) + (B ^ C ^ D) + 0xca62c1d6 + (temp = W[hook(3, (75 - 3) & 15)] ^ W[hook(3, (75 - 8) & 15)] ^ W[hook(3, (75 - 14) & 15)] ^ W[hook(3, 75 & 15)], (W[hook(3, 75 & 15)] = rotate((temp), (unsigned int)(1))));
      B = rotate((B), (unsigned int)(30));
    };
    {
      D += rotate((E), (unsigned int)(5)) + (A ^ B ^ C) + 0xca62c1d6 + (temp = W[hook(3, (76 - 3) & 15)] ^ W[hook(3, (76 - 8) & 15)] ^ W[hook(3, (76 - 14) & 15)] ^ W[hook(3, 76 & 15)], (W[hook(3, 76 & 15)] = rotate((temp), (unsigned int)(1))));
      A = rotate((A), (unsigned int)(30));
    };
    {
      C += rotate((D), (unsigned int)(5)) + (E ^ A ^ B) + 0xca62c1d6 + (temp = W[hook(3, (77 - 3) & 15)] ^ W[hook(3, (77 - 8) & 15)] ^ W[hook(3, (77 - 14) & 15)] ^ W[hook(3, 77 & 15)], (W[hook(3, 77 & 15)] = rotate((temp), (unsigned int)(1))));
      E = rotate((E), (unsigned int)(30));
    };
    {
      B += rotate((C), (unsigned int)(5)) + (D ^ E ^ A) + 0xca62c1d6 + (temp = W[hook(3, (78 - 3) & 15)] ^ W[hook(3, (78 - 8) & 15)] ^ W[hook(3, (78 - 14) & 15)] ^ W[hook(3, 78 & 15)], (W[hook(3, 78 & 15)] = rotate((temp), (unsigned int)(1))));
      D = rotate((D), (unsigned int)(30));
    };
    {
      A += rotate((B), (unsigned int)(5)) + (C ^ D ^ E) + 0xca62c1d6 + (temp = W[hook(3, (79 - 3) & 15)] ^ W[hook(3, (79 - 8) & 15)] ^ W[hook(3, (79 - 14) & 15)] ^ W[hook(3, 79 & 15)], (W[hook(3, 79 & 15)] = rotate((temp), (unsigned int)(1))));
      C = rotate((C), (unsigned int)(30));
    };
    ;
    output[hook(5, 0)] += A;
    output[hook(5, 1)] += B;
    output[hook(5, 2)] += C;
    output[hook(5, 3)] += D;
    output[hook(5, 4)] += E;
  };

  digest[hook(2, gid + 0 * num_keys)] = (__builtin_astype((__builtin_astype((output[hook(5, 0)]), uchar4).wzyx), unsigned int));
  digest[hook(2, gid + 1 * num_keys)] = (__builtin_astype((__builtin_astype((output[hook(5, 1)]), uchar4).wzyx), unsigned int));
  digest[hook(2, gid + 2 * num_keys)] = (__builtin_astype((__builtin_astype((output[hook(5, 2)]), uchar4).wzyx), unsigned int));
  digest[hook(2, gid + 3 * num_keys)] = (__builtin_astype((__builtin_astype((output[hook(5, 3)]), uchar4).wzyx), unsigned int));
  digest[hook(2, gid + 4 * num_keys)] = (__builtin_astype((__builtin_astype((output[hook(5, 4)]), uchar4).wzyx), unsigned int));
}