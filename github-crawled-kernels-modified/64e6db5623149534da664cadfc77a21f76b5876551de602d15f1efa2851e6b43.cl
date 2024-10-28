//{"(W)":6,"OutputBuf":0,"W":4,"Win":5,"out":3,"output":2,"round":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline unsigned int SWAP32(unsigned int x) {
  return bitselect(rotate(x, 24U), rotate(x, 8U), 0x00FF00FFU);
}
inline void sha1_mblock(unsigned int* Win, unsigned int* out, unsigned int blocks) {
  unsigned int W[16], output[5];
  unsigned int A, B, C, D, E, temp;

  for (temp = 0; temp < 5; temp++)
    output[hook(2, temp)] = out[hook(3, temp)];

  while (blocks--) {
    A = output[hook(2, 0)];
    B = output[hook(2, 1)];
    C = output[hook(2, 2)];
    D = output[hook(2, 3)];
    E = output[hook(2, 4)];

    for (temp = 0; temp < 16; temp++)
      W[hook(4, temp)] = Win[hook(5, temp)];
    {
      E += rotate(A, 5U) + bitselect(D, C, B) + 0x5A827999 + W[hook(4, 0)];
      B = rotate(B, 30U);
    };
    {
      D += rotate(E, 5U) + bitselect(C, B, A) + 0x5A827999 + W[hook(4, 1)];
      A = rotate(A, 30U);
    };
    {
      C += rotate(D, 5U) + bitselect(B, A, E) + 0x5A827999 + W[hook(4, 2)];
      E = rotate(E, 30U);
    };
    {
      B += rotate(C, 5U) + bitselect(A, E, D) + 0x5A827999 + W[hook(4, 3)];
      D = rotate(D, 30U);
    };
    {
      A += rotate(B, 5U) + bitselect(E, D, C) + 0x5A827999 + W[hook(4, 4)];
      C = rotate(C, 30U);
    };
    {
      E += rotate(A, 5U) + bitselect(D, C, B) + 0x5A827999 + W[hook(4, 5)];
      B = rotate(B, 30U);
    };
    {
      D += rotate(E, 5U) + bitselect(C, B, A) + 0x5A827999 + W[hook(4, 6)];
      A = rotate(A, 30U);
    };
    {
      C += rotate(D, 5U) + bitselect(B, A, E) + 0x5A827999 + W[hook(4, 7)];
      E = rotate(E, 30U);
    };
    {
      B += rotate(C, 5U) + bitselect(A, E, D) + 0x5A827999 + W[hook(4, 8)];
      D = rotate(D, 30U);
    };
    {
      A += rotate(B, 5U) + bitselect(E, D, C) + 0x5A827999 + W[hook(4, 9)];
      C = rotate(C, 30U);
    };
    {
      E += rotate(A, 5U) + bitselect(D, C, B) + 0x5A827999 + W[hook(4, 10)];
      B = rotate(B, 30U);
    };
    {
      D += rotate(E, 5U) + bitselect(C, B, A) + 0x5A827999 + W[hook(4, 11)];
      A = rotate(A, 30U);
    };
    {
      C += rotate(D, 5U) + bitselect(B, A, E) + 0x5A827999 + W[hook(4, 12)];
      E = rotate(E, 30U);
    };
    {
      B += rotate(C, 5U) + bitselect(A, E, D) + 0x5A827999 + W[hook(4, 13)];
      D = rotate(D, 30U);
    };
    {
      A += rotate(B, 5U) + bitselect(E, D, C) + 0x5A827999 + W[hook(4, 14)];
      C = rotate(C, 30U);
    };
    {
      E += rotate(A, 5U) + bitselect(D, C, B) + 0x5A827999 + W[hook(4, 15)];
      B = rotate(B, 30U);
    };
    {
      D += rotate(E, 5U) + bitselect(C, B, A) + 0x5A827999 + (temp = W[hook(4, (16 - 3) & 15)] ^ W[hook(4, (16 - 8) & 15)] ^ W[hook(4, (16 - 14) & 15)] ^ W[hook(4, 16 & 15)], (W[hook(4, 16 & 15)] = rotate(temp, 1U)));
      A = rotate(A, 30U);
    };
    {
      C += rotate(D, 5U) + bitselect(B, A, E) + 0x5A827999 + (temp = W[hook(4, (17 - 3) & 15)] ^ W[hook(4, (17 - 8) & 15)] ^ W[hook(4, (17 - 14) & 15)] ^ W[hook(4, 17 & 15)], (W[hook(4, 17 & 15)] = rotate(temp, 1U)));
      E = rotate(E, 30U);
    };
    {
      B += rotate(C, 5U) + bitselect(A, E, D) + 0x5A827999 + (temp = W[hook(4, (18 - 3) & 15)] ^ W[hook(4, (18 - 8) & 15)] ^ W[hook(4, (18 - 14) & 15)] ^ W[hook(4, 18 & 15)], (W[hook(4, 18 & 15)] = rotate(temp, 1U)));
      D = rotate(D, 30U);
    };
    {
      A += rotate(B, 5U) + bitselect(E, D, C) + 0x5A827999 + (temp = W[hook(4, (19 - 3) & 15)] ^ W[hook(4, (19 - 8) & 15)] ^ W[hook(4, (19 - 14) & 15)] ^ W[hook(4, 19 & 15)], (W[hook(4, 19 & 15)] = rotate(temp, 1U)));
      C = rotate(C, 30U);
    };

    {
      E += rotate(A, 5U) + (B ^ C ^ D) + 0x6ED9EBA1 + (temp = W[hook(4, (20 - 3) & 15)] ^ W[hook(4, (20 - 8) & 15)] ^ W[hook(4, (20 - 14) & 15)] ^ W[hook(4, 20 & 15)], (W[hook(4, 20 & 15)] = rotate(temp, 1U)));
      B = rotate(B, 30U);
    };
    {
      D += rotate(E, 5U) + (A ^ B ^ C) + 0x6ED9EBA1 + (temp = W[hook(4, (21 - 3) & 15)] ^ W[hook(4, (21 - 8) & 15)] ^ W[hook(4, (21 - 14) & 15)] ^ W[hook(4, 21 & 15)], (W[hook(4, 21 & 15)] = rotate(temp, 1U)));
      A = rotate(A, 30U);
    };
    {
      C += rotate(D, 5U) + (E ^ A ^ B) + 0x6ED9EBA1 + (temp = W[hook(4, (22 - 3) & 15)] ^ W[hook(4, (22 - 8) & 15)] ^ W[hook(4, (22 - 14) & 15)] ^ W[hook(4, 22 & 15)], (W[hook(4, 22 & 15)] = rotate(temp, 1U)));
      E = rotate(E, 30U);
    };
    {
      B += rotate(C, 5U) + (D ^ E ^ A) + 0x6ED9EBA1 + (temp = W[hook(4, (23 - 3) & 15)] ^ W[hook(4, (23 - 8) & 15)] ^ W[hook(4, (23 - 14) & 15)] ^ W[hook(4, 23 & 15)], (W[hook(4, 23 & 15)] = rotate(temp, 1U)));
      D = rotate(D, 30U);
    };
    {
      A += rotate(B, 5U) + (C ^ D ^ E) + 0x6ED9EBA1 + (temp = W[hook(4, (24 - 3) & 15)] ^ W[hook(4, (24 - 8) & 15)] ^ W[hook(4, (24 - 14) & 15)] ^ W[hook(4, 24 & 15)], (W[hook(4, 24 & 15)] = rotate(temp, 1U)));
      C = rotate(C, 30U);
    };
    {
      E += rotate(A, 5U) + (B ^ C ^ D) + 0x6ED9EBA1 + (temp = W[hook(4, (25 - 3) & 15)] ^ W[hook(4, (25 - 8) & 15)] ^ W[hook(4, (25 - 14) & 15)] ^ W[hook(4, 25 & 15)], (W[hook(4, 25 & 15)] = rotate(temp, 1U)));
      B = rotate(B, 30U);
    };
    {
      D += rotate(E, 5U) + (A ^ B ^ C) + 0x6ED9EBA1 + (temp = W[hook(4, (26 - 3) & 15)] ^ W[hook(4, (26 - 8) & 15)] ^ W[hook(4, (26 - 14) & 15)] ^ W[hook(4, 26 & 15)], (W[hook(4, 26 & 15)] = rotate(temp, 1U)));
      A = rotate(A, 30U);
    };
    {
      C += rotate(D, 5U) + (E ^ A ^ B) + 0x6ED9EBA1 + (temp = W[hook(4, (27 - 3) & 15)] ^ W[hook(4, (27 - 8) & 15)] ^ W[hook(4, (27 - 14) & 15)] ^ W[hook(4, 27 & 15)], (W[hook(4, 27 & 15)] = rotate(temp, 1U)));
      E = rotate(E, 30U);
    };
    {
      B += rotate(C, 5U) + (D ^ E ^ A) + 0x6ED9EBA1 + (temp = W[hook(4, (28 - 3) & 15)] ^ W[hook(4, (28 - 8) & 15)] ^ W[hook(4, (28 - 14) & 15)] ^ W[hook(4, 28 & 15)], (W[hook(4, 28 & 15)] = rotate(temp, 1U)));
      D = rotate(D, 30U);
    };
    {
      A += rotate(B, 5U) + (C ^ D ^ E) + 0x6ED9EBA1 + (temp = W[hook(4, (29 - 3) & 15)] ^ W[hook(4, (29 - 8) & 15)] ^ W[hook(4, (29 - 14) & 15)] ^ W[hook(4, 29 & 15)], (W[hook(4, 29 & 15)] = rotate(temp, 1U)));
      C = rotate(C, 30U);
    };
    {
      E += rotate(A, 5U) + (B ^ C ^ D) + 0x6ED9EBA1 + (temp = W[hook(4, (30 - 3) & 15)] ^ W[hook(4, (30 - 8) & 15)] ^ W[hook(4, (30 - 14) & 15)] ^ W[hook(4, 30 & 15)], (W[hook(4, 30 & 15)] = rotate(temp, 1U)));
      B = rotate(B, 30U);
    };
    {
      D += rotate(E, 5U) + (A ^ B ^ C) + 0x6ED9EBA1 + (temp = W[hook(4, (31 - 3) & 15)] ^ W[hook(4, (31 - 8) & 15)] ^ W[hook(4, (31 - 14) & 15)] ^ W[hook(4, 31 & 15)], (W[hook(4, 31 & 15)] = rotate(temp, 1U)));
      A = rotate(A, 30U);
    };
    {
      C += rotate(D, 5U) + (E ^ A ^ B) + 0x6ED9EBA1 + (temp = W[hook(4, (32 - 3) & 15)] ^ W[hook(4, (32 - 8) & 15)] ^ W[hook(4, (32 - 14) & 15)] ^ W[hook(4, 32 & 15)], (W[hook(4, 32 & 15)] = rotate(temp, 1U)));
      E = rotate(E, 30U);
    };
    {
      B += rotate(C, 5U) + (D ^ E ^ A) + 0x6ED9EBA1 + (temp = W[hook(4, (33 - 3) & 15)] ^ W[hook(4, (33 - 8) & 15)] ^ W[hook(4, (33 - 14) & 15)] ^ W[hook(4, 33 & 15)], (W[hook(4, 33 & 15)] = rotate(temp, 1U)));
      D = rotate(D, 30U);
    };
    {
      A += rotate(B, 5U) + (C ^ D ^ E) + 0x6ED9EBA1 + (temp = W[hook(4, (34 - 3) & 15)] ^ W[hook(4, (34 - 8) & 15)] ^ W[hook(4, (34 - 14) & 15)] ^ W[hook(4, 34 & 15)], (W[hook(4, 34 & 15)] = rotate(temp, 1U)));
      C = rotate(C, 30U);
    };
    {
      E += rotate(A, 5U) + (B ^ C ^ D) + 0x6ED9EBA1 + (temp = W[hook(4, (35 - 3) & 15)] ^ W[hook(4, (35 - 8) & 15)] ^ W[hook(4, (35 - 14) & 15)] ^ W[hook(4, 35 & 15)], (W[hook(4, 35 & 15)] = rotate(temp, 1U)));
      B = rotate(B, 30U);
    };
    {
      D += rotate(E, 5U) + (A ^ B ^ C) + 0x6ED9EBA1 + (temp = W[hook(4, (36 - 3) & 15)] ^ W[hook(4, (36 - 8) & 15)] ^ W[hook(4, (36 - 14) & 15)] ^ W[hook(4, 36 & 15)], (W[hook(4, 36 & 15)] = rotate(temp, 1U)));
      A = rotate(A, 30U);
    };
    {
      C += rotate(D, 5U) + (E ^ A ^ B) + 0x6ED9EBA1 + (temp = W[hook(4, (37 - 3) & 15)] ^ W[hook(4, (37 - 8) & 15)] ^ W[hook(4, (37 - 14) & 15)] ^ W[hook(4, 37 & 15)], (W[hook(4, 37 & 15)] = rotate(temp, 1U)));
      E = rotate(E, 30U);
    };
    {
      B += rotate(C, 5U) + (D ^ E ^ A) + 0x6ED9EBA1 + (temp = W[hook(4, (38 - 3) & 15)] ^ W[hook(4, (38 - 8) & 15)] ^ W[hook(4, (38 - 14) & 15)] ^ W[hook(4, 38 & 15)], (W[hook(4, 38 & 15)] = rotate(temp, 1U)));
      D = rotate(D, 30U);
    };
    {
      A += rotate(B, 5U) + (C ^ D ^ E) + 0x6ED9EBA1 + (temp = W[hook(4, (39 - 3) & 15)] ^ W[hook(4, (39 - 8) & 15)] ^ W[hook(4, (39 - 14) & 15)] ^ W[hook(4, 39 & 15)], (W[hook(4, 39 & 15)] = rotate(temp, 1U)));
      C = rotate(C, 30U);
    };
    {
      E += rotate(A, 5U) + (bitselect(B, C, D) ^ bitselect(B, 0U, C)) + 0x8F1BBCDC + (temp = W[hook(4, (40 - 3) & 15)] ^ W[hook(4, (40 - 8) & 15)] ^ W[hook(4, (40 - 14) & 15)] ^ W[hook(4, 40 & 15)], (W[hook(4, 40 & 15)] = rotate(temp, 1U)));
      B = rotate(B, 30U);
    };
    {
      D += rotate(E, 5U) + (bitselect(A, B, C) ^ bitselect(A, 0U, B)) + 0x8F1BBCDC + (temp = W[hook(4, (41 - 3) & 15)] ^ W[hook(4, (41 - 8) & 15)] ^ W[hook(4, (41 - 14) & 15)] ^ W[hook(4, 41 & 15)], (W[hook(4, 41 & 15)] = rotate(temp, 1U)));
      A = rotate(A, 30U);
    };
    {
      C += rotate(D, 5U) + (bitselect(E, A, B) ^ bitselect(E, 0U, A)) + 0x8F1BBCDC + (temp = W[hook(4, (42 - 3) & 15)] ^ W[hook(4, (42 - 8) & 15)] ^ W[hook(4, (42 - 14) & 15)] ^ W[hook(4, 42 & 15)], (W[hook(4, 42 & 15)] = rotate(temp, 1U)));
      E = rotate(E, 30U);
    };
    {
      B += rotate(C, 5U) + (bitselect(D, E, A) ^ bitselect(D, 0U, E)) + 0x8F1BBCDC + (temp = W[hook(4, (43 - 3) & 15)] ^ W[hook(4, (43 - 8) & 15)] ^ W[hook(4, (43 - 14) & 15)] ^ W[hook(4, 43 & 15)], (W[hook(4, 43 & 15)] = rotate(temp, 1U)));
      D = rotate(D, 30U);
    };
    {
      A += rotate(B, 5U) + (bitselect(C, D, E) ^ bitselect(C, 0U, D)) + 0x8F1BBCDC + (temp = W[hook(4, (44 - 3) & 15)] ^ W[hook(4, (44 - 8) & 15)] ^ W[hook(4, (44 - 14) & 15)] ^ W[hook(4, 44 & 15)], (W[hook(4, 44 & 15)] = rotate(temp, 1U)));
      C = rotate(C, 30U);
    };
    {
      E += rotate(A, 5U) + (bitselect(B, C, D) ^ bitselect(B, 0U, C)) + 0x8F1BBCDC + (temp = W[hook(4, (45 - 3) & 15)] ^ W[hook(4, (45 - 8) & 15)] ^ W[hook(4, (45 - 14) & 15)] ^ W[hook(4, 45 & 15)], (W[hook(4, 45 & 15)] = rotate(temp, 1U)));
      B = rotate(B, 30U);
    };
    {
      D += rotate(E, 5U) + (bitselect(A, B, C) ^ bitselect(A, 0U, B)) + 0x8F1BBCDC + (temp = W[hook(4, (46 - 3) & 15)] ^ W[hook(4, (46 - 8) & 15)] ^ W[hook(4, (46 - 14) & 15)] ^ W[hook(4, 46 & 15)], (W[hook(4, 46 & 15)] = rotate(temp, 1U)));
      A = rotate(A, 30U);
    };
    {
      C += rotate(D, 5U) + (bitselect(E, A, B) ^ bitselect(E, 0U, A)) + 0x8F1BBCDC + (temp = W[hook(4, (47 - 3) & 15)] ^ W[hook(4, (47 - 8) & 15)] ^ W[hook(4, (47 - 14) & 15)] ^ W[hook(4, 47 & 15)], (W[hook(4, 47 & 15)] = rotate(temp, 1U)));
      E = rotate(E, 30U);
    };
    {
      B += rotate(C, 5U) + (bitselect(D, E, A) ^ bitselect(D, 0U, E)) + 0x8F1BBCDC + (temp = W[hook(4, (48 - 3) & 15)] ^ W[hook(4, (48 - 8) & 15)] ^ W[hook(4, (48 - 14) & 15)] ^ W[hook(4, 48 & 15)], (W[hook(4, 48 & 15)] = rotate(temp, 1U)));
      D = rotate(D, 30U);
    };
    {
      A += rotate(B, 5U) + (bitselect(C, D, E) ^ bitselect(C, 0U, D)) + 0x8F1BBCDC + (temp = W[hook(4, (49 - 3) & 15)] ^ W[hook(4, (49 - 8) & 15)] ^ W[hook(4, (49 - 14) & 15)] ^ W[hook(4, 49 & 15)], (W[hook(4, 49 & 15)] = rotate(temp, 1U)));
      C = rotate(C, 30U);
    };
    {
      E += rotate(A, 5U) + (bitselect(B, C, D) ^ bitselect(B, 0U, C)) + 0x8F1BBCDC + (temp = W[hook(4, (50 - 3) & 15)] ^ W[hook(4, (50 - 8) & 15)] ^ W[hook(4, (50 - 14) & 15)] ^ W[hook(4, 50 & 15)], (W[hook(4, 50 & 15)] = rotate(temp, 1U)));
      B = rotate(B, 30U);
    };
    {
      D += rotate(E, 5U) + (bitselect(A, B, C) ^ bitselect(A, 0U, B)) + 0x8F1BBCDC + (temp = W[hook(4, (51 - 3) & 15)] ^ W[hook(4, (51 - 8) & 15)] ^ W[hook(4, (51 - 14) & 15)] ^ W[hook(4, 51 & 15)], (W[hook(4, 51 & 15)] = rotate(temp, 1U)));
      A = rotate(A, 30U);
    };
    {
      C += rotate(D, 5U) + (bitselect(E, A, B) ^ bitselect(E, 0U, A)) + 0x8F1BBCDC + (temp = W[hook(4, (52 - 3) & 15)] ^ W[hook(4, (52 - 8) & 15)] ^ W[hook(4, (52 - 14) & 15)] ^ W[hook(4, 52 & 15)], (W[hook(4, 52 & 15)] = rotate(temp, 1U)));
      E = rotate(E, 30U);
    };
    {
      B += rotate(C, 5U) + (bitselect(D, E, A) ^ bitselect(D, 0U, E)) + 0x8F1BBCDC + (temp = W[hook(4, (53 - 3) & 15)] ^ W[hook(4, (53 - 8) & 15)] ^ W[hook(4, (53 - 14) & 15)] ^ W[hook(4, 53 & 15)], (W[hook(4, 53 & 15)] = rotate(temp, 1U)));
      D = rotate(D, 30U);
    };
    {
      A += rotate(B, 5U) + (bitselect(C, D, E) ^ bitselect(C, 0U, D)) + 0x8F1BBCDC + (temp = W[hook(4, (54 - 3) & 15)] ^ W[hook(4, (54 - 8) & 15)] ^ W[hook(4, (54 - 14) & 15)] ^ W[hook(4, 54 & 15)], (W[hook(4, 54 & 15)] = rotate(temp, 1U)));
      C = rotate(C, 30U);
    };
    {
      E += rotate(A, 5U) + (bitselect(B, C, D) ^ bitselect(B, 0U, C)) + 0x8F1BBCDC + (temp = W[hook(4, (55 - 3) & 15)] ^ W[hook(4, (55 - 8) & 15)] ^ W[hook(4, (55 - 14) & 15)] ^ W[hook(4, 55 & 15)], (W[hook(4, 55 & 15)] = rotate(temp, 1U)));
      B = rotate(B, 30U);
    };
    {
      D += rotate(E, 5U) + (bitselect(A, B, C) ^ bitselect(A, 0U, B)) + 0x8F1BBCDC + (temp = W[hook(4, (56 - 3) & 15)] ^ W[hook(4, (56 - 8) & 15)] ^ W[hook(4, (56 - 14) & 15)] ^ W[hook(4, 56 & 15)], (W[hook(4, 56 & 15)] = rotate(temp, 1U)));
      A = rotate(A, 30U);
    };
    {
      C += rotate(D, 5U) + (bitselect(E, A, B) ^ bitselect(E, 0U, A)) + 0x8F1BBCDC + (temp = W[hook(4, (57 - 3) & 15)] ^ W[hook(4, (57 - 8) & 15)] ^ W[hook(4, (57 - 14) & 15)] ^ W[hook(4, 57 & 15)], (W[hook(4, 57 & 15)] = rotate(temp, 1U)));
      E = rotate(E, 30U);
    };
    {
      B += rotate(C, 5U) + (bitselect(D, E, A) ^ bitselect(D, 0U, E)) + 0x8F1BBCDC + (temp = W[hook(4, (58 - 3) & 15)] ^ W[hook(4, (58 - 8) & 15)] ^ W[hook(4, (58 - 14) & 15)] ^ W[hook(4, 58 & 15)], (W[hook(4, 58 & 15)] = rotate(temp, 1U)));
      D = rotate(D, 30U);
    };
    {
      A += rotate(B, 5U) + (bitselect(C, D, E) ^ bitselect(C, 0U, D)) + 0x8F1BBCDC + (temp = W[hook(4, (59 - 3) & 15)] ^ W[hook(4, (59 - 8) & 15)] ^ W[hook(4, (59 - 14) & 15)] ^ W[hook(4, 59 & 15)], (W[hook(4, 59 & 15)] = rotate(temp, 1U)));
      C = rotate(C, 30U);
    };

    {
      E += rotate(A, 5U) + (B ^ C ^ D) + 0xCA62C1D6 + (temp = W[hook(4, (60 - 3) & 15)] ^ W[hook(4, (60 - 8) & 15)] ^ W[hook(4, (60 - 14) & 15)] ^ W[hook(4, 60 & 15)], (W[hook(4, 60 & 15)] = rotate(temp, 1U)));
      B = rotate(B, 30U);
    };
    {
      D += rotate(E, 5U) + (A ^ B ^ C) + 0xCA62C1D6 + (temp = W[hook(4, (61 - 3) & 15)] ^ W[hook(4, (61 - 8) & 15)] ^ W[hook(4, (61 - 14) & 15)] ^ W[hook(4, 61 & 15)], (W[hook(4, 61 & 15)] = rotate(temp, 1U)));
      A = rotate(A, 30U);
    };
    {
      C += rotate(D, 5U) + (E ^ A ^ B) + 0xCA62C1D6 + (temp = W[hook(4, (62 - 3) & 15)] ^ W[hook(4, (62 - 8) & 15)] ^ W[hook(4, (62 - 14) & 15)] ^ W[hook(4, 62 & 15)], (W[hook(4, 62 & 15)] = rotate(temp, 1U)));
      E = rotate(E, 30U);
    };
    {
      B += rotate(C, 5U) + (D ^ E ^ A) + 0xCA62C1D6 + (temp = W[hook(4, (63 - 3) & 15)] ^ W[hook(4, (63 - 8) & 15)] ^ W[hook(4, (63 - 14) & 15)] ^ W[hook(4, 63 & 15)], (W[hook(4, 63 & 15)] = rotate(temp, 1U)));
      D = rotate(D, 30U);
    };
    {
      A += rotate(B, 5U) + (C ^ D ^ E) + 0xCA62C1D6 + (temp = W[hook(4, (64 - 3) & 15)] ^ W[hook(4, (64 - 8) & 15)] ^ W[hook(4, (64 - 14) & 15)] ^ W[hook(4, 64 & 15)], (W[hook(4, 64 & 15)] = rotate(temp, 1U)));
      C = rotate(C, 30U);
    };
    {
      E += rotate(A, 5U) + (B ^ C ^ D) + 0xCA62C1D6 + (temp = W[hook(4, (65 - 3) & 15)] ^ W[hook(4, (65 - 8) & 15)] ^ W[hook(4, (65 - 14) & 15)] ^ W[hook(4, 65 & 15)], (W[hook(4, 65 & 15)] = rotate(temp, 1U)));
      B = rotate(B, 30U);
    };
    {
      D += rotate(E, 5U) + (A ^ B ^ C) + 0xCA62C1D6 + (temp = W[hook(4, (66 - 3) & 15)] ^ W[hook(4, (66 - 8) & 15)] ^ W[hook(4, (66 - 14) & 15)] ^ W[hook(4, 66 & 15)], (W[hook(4, 66 & 15)] = rotate(temp, 1U)));
      A = rotate(A, 30U);
    };
    {
      C += rotate(D, 5U) + (E ^ A ^ B) + 0xCA62C1D6 + (temp = W[hook(4, (67 - 3) & 15)] ^ W[hook(4, (67 - 8) & 15)] ^ W[hook(4, (67 - 14) & 15)] ^ W[hook(4, 67 & 15)], (W[hook(4, 67 & 15)] = rotate(temp, 1U)));
      E = rotate(E, 30U);
    };
    {
      B += rotate(C, 5U) + (D ^ E ^ A) + 0xCA62C1D6 + (temp = W[hook(4, (68 - 3) & 15)] ^ W[hook(4, (68 - 8) & 15)] ^ W[hook(4, (68 - 14) & 15)] ^ W[hook(4, 68 & 15)], (W[hook(4, 68 & 15)] = rotate(temp, 1U)));
      D = rotate(D, 30U);
    };
    {
      A += rotate(B, 5U) + (C ^ D ^ E) + 0xCA62C1D6 + (temp = W[hook(4, (69 - 3) & 15)] ^ W[hook(4, (69 - 8) & 15)] ^ W[hook(4, (69 - 14) & 15)] ^ W[hook(4, 69 & 15)], (W[hook(4, 69 & 15)] = rotate(temp, 1U)));
      C = rotate(C, 30U);
    };
    {
      E += rotate(A, 5U) + (B ^ C ^ D) + 0xCA62C1D6 + (temp = W[hook(4, (70 - 3) & 15)] ^ W[hook(4, (70 - 8) & 15)] ^ W[hook(4, (70 - 14) & 15)] ^ W[hook(4, 70 & 15)], (W[hook(4, 70 & 15)] = rotate(temp, 1U)));
      B = rotate(B, 30U);
    };
    {
      D += rotate(E, 5U) + (A ^ B ^ C) + 0xCA62C1D6 + (temp = W[hook(4, (71 - 3) & 15)] ^ W[hook(4, (71 - 8) & 15)] ^ W[hook(4, (71 - 14) & 15)] ^ W[hook(4, 71 & 15)], (W[hook(4, 71 & 15)] = rotate(temp, 1U)));
      A = rotate(A, 30U);
    };
    {
      C += rotate(D, 5U) + (E ^ A ^ B) + 0xCA62C1D6 + (temp = W[hook(4, (72 - 3) & 15)] ^ W[hook(4, (72 - 8) & 15)] ^ W[hook(4, (72 - 14) & 15)] ^ W[hook(4, 72 & 15)], (W[hook(4, 72 & 15)] = rotate(temp, 1U)));
      E = rotate(E, 30U);
    };
    {
      B += rotate(C, 5U) + (D ^ E ^ A) + 0xCA62C1D6 + (temp = W[hook(4, (73 - 3) & 15)] ^ W[hook(4, (73 - 8) & 15)] ^ W[hook(4, (73 - 14) & 15)] ^ W[hook(4, 73 & 15)], (W[hook(4, 73 & 15)] = rotate(temp, 1U)));
      D = rotate(D, 30U);
    };
    {
      A += rotate(B, 5U) + (C ^ D ^ E) + 0xCA62C1D6 + (temp = W[hook(4, (74 - 3) & 15)] ^ W[hook(4, (74 - 8) & 15)] ^ W[hook(4, (74 - 14) & 15)] ^ W[hook(4, 74 & 15)], (W[hook(4, 74 & 15)] = rotate(temp, 1U)));
      C = rotate(C, 30U);
    };
    {
      E += rotate(A, 5U) + (B ^ C ^ D) + 0xCA62C1D6 + (temp = W[hook(4, (75 - 3) & 15)] ^ W[hook(4, (75 - 8) & 15)] ^ W[hook(4, (75 - 14) & 15)] ^ W[hook(4, 75 & 15)], (W[hook(4, 75 & 15)] = rotate(temp, 1U)));
      B = rotate(B, 30U);
    };
    {
      D += rotate(E, 5U) + (A ^ B ^ C) + 0xCA62C1D6 + (temp = W[hook(4, (76 - 3) & 15)] ^ W[hook(4, (76 - 8) & 15)] ^ W[hook(4, (76 - 14) & 15)] ^ W[hook(4, 76 & 15)], (W[hook(4, 76 & 15)] = rotate(temp, 1U)));
      A = rotate(A, 30U);
    };
    {
      C += rotate(D, 5U) + (E ^ A ^ B) + 0xCA62C1D6 + (temp = W[hook(4, (77 - 3) & 15)] ^ W[hook(4, (77 - 8) & 15)] ^ W[hook(4, (77 - 14) & 15)] ^ W[hook(4, 77 & 15)], (W[hook(4, 77 & 15)] = rotate(temp, 1U)));
      E = rotate(E, 30U);
    };
    {
      B += rotate(C, 5U) + (D ^ E ^ A) + 0xCA62C1D6 + (temp = W[hook(4, (78 - 3) & 15)] ^ W[hook(4, (78 - 8) & 15)] ^ W[hook(4, (78 - 14) & 15)] ^ W[hook(4, 78 & 15)], (W[hook(4, 78 & 15)] = rotate(temp, 1U)));
      D = rotate(D, 30U);
    };
    {
      A += rotate(B, 5U) + (C ^ D ^ E) + 0xCA62C1D6 + (temp = W[hook(4, (79 - 3) & 15)] ^ W[hook(4, (79 - 8) & 15)] ^ W[hook(4, (79 - 14) & 15)] ^ W[hook(4, 79 & 15)], (W[hook(4, 79 & 15)] = rotate(temp, 1U)));
      C = rotate(C, 30U);
    };

    output[hook(2, 0)] += A;
    output[hook(2, 1)] += B;
    output[hook(2, 2)] += C;
    output[hook(2, 3)] += D;
    output[hook(2, 4)] += E;

    Win += 16;
  }

  for (temp = 0; temp < 5; temp++)
    out[hook(3, temp)] = output[hook(2, temp)];
}

inline void sha1_block(unsigned int* W, unsigned int* output) {
  unsigned int A, B, C, D, E, temp;

  A = output[hook(2, 0)];
  B = output[hook(2, 1)];
  C = output[hook(2, 2)];
  D = output[hook(2, 3)];
  E = output[hook(2, 4)];
  {
    E += rotate(A, 5U) + bitselect(D, C, B) + 0x5A827999 + W[hook(4, 0)];
    B = rotate(B, 30U);
  };
  {
    D += rotate(E, 5U) + bitselect(C, B, A) + 0x5A827999 + W[hook(4, 1)];
    A = rotate(A, 30U);
  };
  {
    C += rotate(D, 5U) + bitselect(B, A, E) + 0x5A827999 + W[hook(4, 2)];
    E = rotate(E, 30U);
  };
  {
    B += rotate(C, 5U) + bitselect(A, E, D) + 0x5A827999 + W[hook(4, 3)];
    D = rotate(D, 30U);
  };
  {
    A += rotate(B, 5U) + bitselect(E, D, C) + 0x5A827999 + W[hook(4, 4)];
    C = rotate(C, 30U);
  };
  {
    E += rotate(A, 5U) + bitselect(D, C, B) + 0x5A827999 + W[hook(4, 5)];
    B = rotate(B, 30U);
  };
  {
    D += rotate(E, 5U) + bitselect(C, B, A) + 0x5A827999 + W[hook(4, 6)];
    A = rotate(A, 30U);
  };
  {
    C += rotate(D, 5U) + bitselect(B, A, E) + 0x5A827999 + W[hook(4, 7)];
    E = rotate(E, 30U);
  };
  {
    B += rotate(C, 5U) + bitselect(A, E, D) + 0x5A827999 + W[hook(4, 8)];
    D = rotate(D, 30U);
  };
  {
    A += rotate(B, 5U) + bitselect(E, D, C) + 0x5A827999 + W[hook(4, 9)];
    C = rotate(C, 30U);
  };
  {
    E += rotate(A, 5U) + bitselect(D, C, B) + 0x5A827999 + W[hook(4, 10)];
    B = rotate(B, 30U);
  };
  {
    D += rotate(E, 5U) + bitselect(C, B, A) + 0x5A827999 + W[hook(4, 11)];
    A = rotate(A, 30U);
  };
  {
    C += rotate(D, 5U) + bitselect(B, A, E) + 0x5A827999 + W[hook(4, 12)];
    E = rotate(E, 30U);
  };
  {
    B += rotate(C, 5U) + bitselect(A, E, D) + 0x5A827999 + W[hook(4, 13)];
    D = rotate(D, 30U);
  };
  {
    A += rotate(B, 5U) + bitselect(E, D, C) + 0x5A827999 + W[hook(4, 14)];
    C = rotate(C, 30U);
  };
  {
    E += rotate(A, 5U) + bitselect(D, C, B) + 0x5A827999 + W[hook(4, 15)];
    B = rotate(B, 30U);
  };
  {
    D += rotate(E, 5U) + bitselect(C, B, A) + 0x5A827999 + (temp = W[hook(4, (16 - 3) & 15)] ^ W[hook(4, (16 - 8) & 15)] ^ W[hook(4, (16 - 14) & 15)] ^ W[hook(4, 16 & 15)], (W[hook(4, 16 & 15)] = rotate(temp, 1U)));
    A = rotate(A, 30U);
  };
  {
    C += rotate(D, 5U) + bitselect(B, A, E) + 0x5A827999 + (temp = W[hook(4, (17 - 3) & 15)] ^ W[hook(4, (17 - 8) & 15)] ^ W[hook(4, (17 - 14) & 15)] ^ W[hook(4, 17 & 15)], (W[hook(4, 17 & 15)] = rotate(temp, 1U)));
    E = rotate(E, 30U);
  };
  {
    B += rotate(C, 5U) + bitselect(A, E, D) + 0x5A827999 + (temp = W[hook(4, (18 - 3) & 15)] ^ W[hook(4, (18 - 8) & 15)] ^ W[hook(4, (18 - 14) & 15)] ^ W[hook(4, 18 & 15)], (W[hook(4, 18 & 15)] = rotate(temp, 1U)));
    D = rotate(D, 30U);
  };
  {
    A += rotate(B, 5U) + bitselect(E, D, C) + 0x5A827999 + (temp = W[hook(4, (19 - 3) & 15)] ^ W[hook(4, (19 - 8) & 15)] ^ W[hook(4, (19 - 14) & 15)] ^ W[hook(4, 19 & 15)], (W[hook(4, 19 & 15)] = rotate(temp, 1U)));
    C = rotate(C, 30U);
  };

  {
    E += rotate(A, 5U) + (B ^ C ^ D) + 0x6ED9EBA1 + (temp = W[hook(4, (20 - 3) & 15)] ^ W[hook(4, (20 - 8) & 15)] ^ W[hook(4, (20 - 14) & 15)] ^ W[hook(4, 20 & 15)], (W[hook(4, 20 & 15)] = rotate(temp, 1U)));
    B = rotate(B, 30U);
  };
  {
    D += rotate(E, 5U) + (A ^ B ^ C) + 0x6ED9EBA1 + (temp = W[hook(4, (21 - 3) & 15)] ^ W[hook(4, (21 - 8) & 15)] ^ W[hook(4, (21 - 14) & 15)] ^ W[hook(4, 21 & 15)], (W[hook(4, 21 & 15)] = rotate(temp, 1U)));
    A = rotate(A, 30U);
  };
  {
    C += rotate(D, 5U) + (E ^ A ^ B) + 0x6ED9EBA1 + (temp = W[hook(4, (22 - 3) & 15)] ^ W[hook(4, (22 - 8) & 15)] ^ W[hook(4, (22 - 14) & 15)] ^ W[hook(4, 22 & 15)], (W[hook(4, 22 & 15)] = rotate(temp, 1U)));
    E = rotate(E, 30U);
  };
  {
    B += rotate(C, 5U) + (D ^ E ^ A) + 0x6ED9EBA1 + (temp = W[hook(4, (23 - 3) & 15)] ^ W[hook(4, (23 - 8) & 15)] ^ W[hook(4, (23 - 14) & 15)] ^ W[hook(4, 23 & 15)], (W[hook(4, 23 & 15)] = rotate(temp, 1U)));
    D = rotate(D, 30U);
  };
  {
    A += rotate(B, 5U) + (C ^ D ^ E) + 0x6ED9EBA1 + (temp = W[hook(4, (24 - 3) & 15)] ^ W[hook(4, (24 - 8) & 15)] ^ W[hook(4, (24 - 14) & 15)] ^ W[hook(4, 24 & 15)], (W[hook(4, 24 & 15)] = rotate(temp, 1U)));
    C = rotate(C, 30U);
  };
  {
    E += rotate(A, 5U) + (B ^ C ^ D) + 0x6ED9EBA1 + (temp = W[hook(4, (25 - 3) & 15)] ^ W[hook(4, (25 - 8) & 15)] ^ W[hook(4, (25 - 14) & 15)] ^ W[hook(4, 25 & 15)], (W[hook(4, 25 & 15)] = rotate(temp, 1U)));
    B = rotate(B, 30U);
  };
  {
    D += rotate(E, 5U) + (A ^ B ^ C) + 0x6ED9EBA1 + (temp = W[hook(4, (26 - 3) & 15)] ^ W[hook(4, (26 - 8) & 15)] ^ W[hook(4, (26 - 14) & 15)] ^ W[hook(4, 26 & 15)], (W[hook(4, 26 & 15)] = rotate(temp, 1U)));
    A = rotate(A, 30U);
  };
  {
    C += rotate(D, 5U) + (E ^ A ^ B) + 0x6ED9EBA1 + (temp = W[hook(4, (27 - 3) & 15)] ^ W[hook(4, (27 - 8) & 15)] ^ W[hook(4, (27 - 14) & 15)] ^ W[hook(4, 27 & 15)], (W[hook(4, 27 & 15)] = rotate(temp, 1U)));
    E = rotate(E, 30U);
  };
  {
    B += rotate(C, 5U) + (D ^ E ^ A) + 0x6ED9EBA1 + (temp = W[hook(4, (28 - 3) & 15)] ^ W[hook(4, (28 - 8) & 15)] ^ W[hook(4, (28 - 14) & 15)] ^ W[hook(4, 28 & 15)], (W[hook(4, 28 & 15)] = rotate(temp, 1U)));
    D = rotate(D, 30U);
  };
  {
    A += rotate(B, 5U) + (C ^ D ^ E) + 0x6ED9EBA1 + (temp = W[hook(4, (29 - 3) & 15)] ^ W[hook(4, (29 - 8) & 15)] ^ W[hook(4, (29 - 14) & 15)] ^ W[hook(4, 29 & 15)], (W[hook(4, 29 & 15)] = rotate(temp, 1U)));
    C = rotate(C, 30U);
  };
  {
    E += rotate(A, 5U) + (B ^ C ^ D) + 0x6ED9EBA1 + (temp = W[hook(4, (30 - 3) & 15)] ^ W[hook(4, (30 - 8) & 15)] ^ W[hook(4, (30 - 14) & 15)] ^ W[hook(4, 30 & 15)], (W[hook(4, 30 & 15)] = rotate(temp, 1U)));
    B = rotate(B, 30U);
  };
  {
    D += rotate(E, 5U) + (A ^ B ^ C) + 0x6ED9EBA1 + (temp = W[hook(4, (31 - 3) & 15)] ^ W[hook(4, (31 - 8) & 15)] ^ W[hook(4, (31 - 14) & 15)] ^ W[hook(4, 31 & 15)], (W[hook(4, 31 & 15)] = rotate(temp, 1U)));
    A = rotate(A, 30U);
  };
  {
    C += rotate(D, 5U) + (E ^ A ^ B) + 0x6ED9EBA1 + (temp = W[hook(4, (32 - 3) & 15)] ^ W[hook(4, (32 - 8) & 15)] ^ W[hook(4, (32 - 14) & 15)] ^ W[hook(4, 32 & 15)], (W[hook(4, 32 & 15)] = rotate(temp, 1U)));
    E = rotate(E, 30U);
  };
  {
    B += rotate(C, 5U) + (D ^ E ^ A) + 0x6ED9EBA1 + (temp = W[hook(4, (33 - 3) & 15)] ^ W[hook(4, (33 - 8) & 15)] ^ W[hook(4, (33 - 14) & 15)] ^ W[hook(4, 33 & 15)], (W[hook(4, 33 & 15)] = rotate(temp, 1U)));
    D = rotate(D, 30U);
  };
  {
    A += rotate(B, 5U) + (C ^ D ^ E) + 0x6ED9EBA1 + (temp = W[hook(4, (34 - 3) & 15)] ^ W[hook(4, (34 - 8) & 15)] ^ W[hook(4, (34 - 14) & 15)] ^ W[hook(4, 34 & 15)], (W[hook(4, 34 & 15)] = rotate(temp, 1U)));
    C = rotate(C, 30U);
  };
  {
    E += rotate(A, 5U) + (B ^ C ^ D) + 0x6ED9EBA1 + (temp = W[hook(4, (35 - 3) & 15)] ^ W[hook(4, (35 - 8) & 15)] ^ W[hook(4, (35 - 14) & 15)] ^ W[hook(4, 35 & 15)], (W[hook(4, 35 & 15)] = rotate(temp, 1U)));
    B = rotate(B, 30U);
  };
  {
    D += rotate(E, 5U) + (A ^ B ^ C) + 0x6ED9EBA1 + (temp = W[hook(4, (36 - 3) & 15)] ^ W[hook(4, (36 - 8) & 15)] ^ W[hook(4, (36 - 14) & 15)] ^ W[hook(4, 36 & 15)], (W[hook(4, 36 & 15)] = rotate(temp, 1U)));
    A = rotate(A, 30U);
  };
  {
    C += rotate(D, 5U) + (E ^ A ^ B) + 0x6ED9EBA1 + (temp = W[hook(4, (37 - 3) & 15)] ^ W[hook(4, (37 - 8) & 15)] ^ W[hook(4, (37 - 14) & 15)] ^ W[hook(4, 37 & 15)], (W[hook(4, 37 & 15)] = rotate(temp, 1U)));
    E = rotate(E, 30U);
  };
  {
    B += rotate(C, 5U) + (D ^ E ^ A) + 0x6ED9EBA1 + (temp = W[hook(4, (38 - 3) & 15)] ^ W[hook(4, (38 - 8) & 15)] ^ W[hook(4, (38 - 14) & 15)] ^ W[hook(4, 38 & 15)], (W[hook(4, 38 & 15)] = rotate(temp, 1U)));
    D = rotate(D, 30U);
  };
  {
    A += rotate(B, 5U) + (C ^ D ^ E) + 0x6ED9EBA1 + (temp = W[hook(4, (39 - 3) & 15)] ^ W[hook(4, (39 - 8) & 15)] ^ W[hook(4, (39 - 14) & 15)] ^ W[hook(4, 39 & 15)], (W[hook(4, 39 & 15)] = rotate(temp, 1U)));
    C = rotate(C, 30U);
  };
  {
    E += rotate(A, 5U) + (bitselect(B, C, D) ^ bitselect(B, 0U, C)) + 0x8F1BBCDC + (temp = W[hook(4, (40 - 3) & 15)] ^ W[hook(4, (40 - 8) & 15)] ^ W[hook(4, (40 - 14) & 15)] ^ W[hook(4, 40 & 15)], (W[hook(4, 40 & 15)] = rotate(temp, 1U)));
    B = rotate(B, 30U);
  };
  {
    D += rotate(E, 5U) + (bitselect(A, B, C) ^ bitselect(A, 0U, B)) + 0x8F1BBCDC + (temp = W[hook(4, (41 - 3) & 15)] ^ W[hook(4, (41 - 8) & 15)] ^ W[hook(4, (41 - 14) & 15)] ^ W[hook(4, 41 & 15)], (W[hook(4, 41 & 15)] = rotate(temp, 1U)));
    A = rotate(A, 30U);
  };
  {
    C += rotate(D, 5U) + (bitselect(E, A, B) ^ bitselect(E, 0U, A)) + 0x8F1BBCDC + (temp = W[hook(4, (42 - 3) & 15)] ^ W[hook(4, (42 - 8) & 15)] ^ W[hook(4, (42 - 14) & 15)] ^ W[hook(4, 42 & 15)], (W[hook(4, 42 & 15)] = rotate(temp, 1U)));
    E = rotate(E, 30U);
  };
  {
    B += rotate(C, 5U) + (bitselect(D, E, A) ^ bitselect(D, 0U, E)) + 0x8F1BBCDC + (temp = W[hook(4, (43 - 3) & 15)] ^ W[hook(4, (43 - 8) & 15)] ^ W[hook(4, (43 - 14) & 15)] ^ W[hook(4, 43 & 15)], (W[hook(4, 43 & 15)] = rotate(temp, 1U)));
    D = rotate(D, 30U);
  };
  {
    A += rotate(B, 5U) + (bitselect(C, D, E) ^ bitselect(C, 0U, D)) + 0x8F1BBCDC + (temp = W[hook(4, (44 - 3) & 15)] ^ W[hook(4, (44 - 8) & 15)] ^ W[hook(4, (44 - 14) & 15)] ^ W[hook(4, 44 & 15)], (W[hook(4, 44 & 15)] = rotate(temp, 1U)));
    C = rotate(C, 30U);
  };
  {
    E += rotate(A, 5U) + (bitselect(B, C, D) ^ bitselect(B, 0U, C)) + 0x8F1BBCDC + (temp = W[hook(4, (45 - 3) & 15)] ^ W[hook(4, (45 - 8) & 15)] ^ W[hook(4, (45 - 14) & 15)] ^ W[hook(4, 45 & 15)], (W[hook(4, 45 & 15)] = rotate(temp, 1U)));
    B = rotate(B, 30U);
  };
  {
    D += rotate(E, 5U) + (bitselect(A, B, C) ^ bitselect(A, 0U, B)) + 0x8F1BBCDC + (temp = W[hook(4, (46 - 3) & 15)] ^ W[hook(4, (46 - 8) & 15)] ^ W[hook(4, (46 - 14) & 15)] ^ W[hook(4, 46 & 15)], (W[hook(4, 46 & 15)] = rotate(temp, 1U)));
    A = rotate(A, 30U);
  };
  {
    C += rotate(D, 5U) + (bitselect(E, A, B) ^ bitselect(E, 0U, A)) + 0x8F1BBCDC + (temp = W[hook(4, (47 - 3) & 15)] ^ W[hook(4, (47 - 8) & 15)] ^ W[hook(4, (47 - 14) & 15)] ^ W[hook(4, 47 & 15)], (W[hook(4, 47 & 15)] = rotate(temp, 1U)));
    E = rotate(E, 30U);
  };
  {
    B += rotate(C, 5U) + (bitselect(D, E, A) ^ bitselect(D, 0U, E)) + 0x8F1BBCDC + (temp = W[hook(4, (48 - 3) & 15)] ^ W[hook(4, (48 - 8) & 15)] ^ W[hook(4, (48 - 14) & 15)] ^ W[hook(4, 48 & 15)], (W[hook(4, 48 & 15)] = rotate(temp, 1U)));
    D = rotate(D, 30U);
  };
  {
    A += rotate(B, 5U) + (bitselect(C, D, E) ^ bitselect(C, 0U, D)) + 0x8F1BBCDC + (temp = W[hook(4, (49 - 3) & 15)] ^ W[hook(4, (49 - 8) & 15)] ^ W[hook(4, (49 - 14) & 15)] ^ W[hook(4, 49 & 15)], (W[hook(4, 49 & 15)] = rotate(temp, 1U)));
    C = rotate(C, 30U);
  };
  {
    E += rotate(A, 5U) + (bitselect(B, C, D) ^ bitselect(B, 0U, C)) + 0x8F1BBCDC + (temp = W[hook(4, (50 - 3) & 15)] ^ W[hook(4, (50 - 8) & 15)] ^ W[hook(4, (50 - 14) & 15)] ^ W[hook(4, 50 & 15)], (W[hook(4, 50 & 15)] = rotate(temp, 1U)));
    B = rotate(B, 30U);
  };
  {
    D += rotate(E, 5U) + (bitselect(A, B, C) ^ bitselect(A, 0U, B)) + 0x8F1BBCDC + (temp = W[hook(4, (51 - 3) & 15)] ^ W[hook(4, (51 - 8) & 15)] ^ W[hook(4, (51 - 14) & 15)] ^ W[hook(4, 51 & 15)], (W[hook(4, 51 & 15)] = rotate(temp, 1U)));
    A = rotate(A, 30U);
  };
  {
    C += rotate(D, 5U) + (bitselect(E, A, B) ^ bitselect(E, 0U, A)) + 0x8F1BBCDC + (temp = W[hook(4, (52 - 3) & 15)] ^ W[hook(4, (52 - 8) & 15)] ^ W[hook(4, (52 - 14) & 15)] ^ W[hook(4, 52 & 15)], (W[hook(4, 52 & 15)] = rotate(temp, 1U)));
    E = rotate(E, 30U);
  };
  {
    B += rotate(C, 5U) + (bitselect(D, E, A) ^ bitselect(D, 0U, E)) + 0x8F1BBCDC + (temp = W[hook(4, (53 - 3) & 15)] ^ W[hook(4, (53 - 8) & 15)] ^ W[hook(4, (53 - 14) & 15)] ^ W[hook(4, 53 & 15)], (W[hook(4, 53 & 15)] = rotate(temp, 1U)));
    D = rotate(D, 30U);
  };
  {
    A += rotate(B, 5U) + (bitselect(C, D, E) ^ bitselect(C, 0U, D)) + 0x8F1BBCDC + (temp = W[hook(4, (54 - 3) & 15)] ^ W[hook(4, (54 - 8) & 15)] ^ W[hook(4, (54 - 14) & 15)] ^ W[hook(4, 54 & 15)], (W[hook(4, 54 & 15)] = rotate(temp, 1U)));
    C = rotate(C, 30U);
  };
  {
    E += rotate(A, 5U) + (bitselect(B, C, D) ^ bitselect(B, 0U, C)) + 0x8F1BBCDC + (temp = W[hook(4, (55 - 3) & 15)] ^ W[hook(4, (55 - 8) & 15)] ^ W[hook(4, (55 - 14) & 15)] ^ W[hook(4, 55 & 15)], (W[hook(4, 55 & 15)] = rotate(temp, 1U)));
    B = rotate(B, 30U);
  };
  {
    D += rotate(E, 5U) + (bitselect(A, B, C) ^ bitselect(A, 0U, B)) + 0x8F1BBCDC + (temp = W[hook(4, (56 - 3) & 15)] ^ W[hook(4, (56 - 8) & 15)] ^ W[hook(4, (56 - 14) & 15)] ^ W[hook(4, 56 & 15)], (W[hook(4, 56 & 15)] = rotate(temp, 1U)));
    A = rotate(A, 30U);
  };
  {
    C += rotate(D, 5U) + (bitselect(E, A, B) ^ bitselect(E, 0U, A)) + 0x8F1BBCDC + (temp = W[hook(4, (57 - 3) & 15)] ^ W[hook(4, (57 - 8) & 15)] ^ W[hook(4, (57 - 14) & 15)] ^ W[hook(4, 57 & 15)], (W[hook(4, 57 & 15)] = rotate(temp, 1U)));
    E = rotate(E, 30U);
  };
  {
    B += rotate(C, 5U) + (bitselect(D, E, A) ^ bitselect(D, 0U, E)) + 0x8F1BBCDC + (temp = W[hook(4, (58 - 3) & 15)] ^ W[hook(4, (58 - 8) & 15)] ^ W[hook(4, (58 - 14) & 15)] ^ W[hook(4, 58 & 15)], (W[hook(4, 58 & 15)] = rotate(temp, 1U)));
    D = rotate(D, 30U);
  };
  {
    A += rotate(B, 5U) + (bitselect(C, D, E) ^ bitselect(C, 0U, D)) + 0x8F1BBCDC + (temp = W[hook(4, (59 - 3) & 15)] ^ W[hook(4, (59 - 8) & 15)] ^ W[hook(4, (59 - 14) & 15)] ^ W[hook(4, 59 & 15)], (W[hook(4, 59 & 15)] = rotate(temp, 1U)));
    C = rotate(C, 30U);
  };

  {
    E += rotate(A, 5U) + (B ^ C ^ D) + 0xCA62C1D6 + (temp = W[hook(4, (60 - 3) & 15)] ^ W[hook(4, (60 - 8) & 15)] ^ W[hook(4, (60 - 14) & 15)] ^ W[hook(4, 60 & 15)], (W[hook(4, 60 & 15)] = rotate(temp, 1U)));
    B = rotate(B, 30U);
  };
  {
    D += rotate(E, 5U) + (A ^ B ^ C) + 0xCA62C1D6 + (temp = W[hook(4, (61 - 3) & 15)] ^ W[hook(4, (61 - 8) & 15)] ^ W[hook(4, (61 - 14) & 15)] ^ W[hook(4, 61 & 15)], (W[hook(4, 61 & 15)] = rotate(temp, 1U)));
    A = rotate(A, 30U);
  };
  {
    C += rotate(D, 5U) + (E ^ A ^ B) + 0xCA62C1D6 + (temp = W[hook(4, (62 - 3) & 15)] ^ W[hook(4, (62 - 8) & 15)] ^ W[hook(4, (62 - 14) & 15)] ^ W[hook(4, 62 & 15)], (W[hook(4, 62 & 15)] = rotate(temp, 1U)));
    E = rotate(E, 30U);
  };
  {
    B += rotate(C, 5U) + (D ^ E ^ A) + 0xCA62C1D6 + (temp = W[hook(4, (63 - 3) & 15)] ^ W[hook(4, (63 - 8) & 15)] ^ W[hook(4, (63 - 14) & 15)] ^ W[hook(4, 63 & 15)], (W[hook(4, 63 & 15)] = rotate(temp, 1U)));
    D = rotate(D, 30U);
  };
  {
    A += rotate(B, 5U) + (C ^ D ^ E) + 0xCA62C1D6 + (temp = W[hook(4, (64 - 3) & 15)] ^ W[hook(4, (64 - 8) & 15)] ^ W[hook(4, (64 - 14) & 15)] ^ W[hook(4, 64 & 15)], (W[hook(4, 64 & 15)] = rotate(temp, 1U)));
    C = rotate(C, 30U);
  };
  {
    E += rotate(A, 5U) + (B ^ C ^ D) + 0xCA62C1D6 + (temp = W[hook(4, (65 - 3) & 15)] ^ W[hook(4, (65 - 8) & 15)] ^ W[hook(4, (65 - 14) & 15)] ^ W[hook(4, 65 & 15)], (W[hook(4, 65 & 15)] = rotate(temp, 1U)));
    B = rotate(B, 30U);
  };
  {
    D += rotate(E, 5U) + (A ^ B ^ C) + 0xCA62C1D6 + (temp = W[hook(4, (66 - 3) & 15)] ^ W[hook(4, (66 - 8) & 15)] ^ W[hook(4, (66 - 14) & 15)] ^ W[hook(4, 66 & 15)], (W[hook(4, 66 & 15)] = rotate(temp, 1U)));
    A = rotate(A, 30U);
  };
  {
    C += rotate(D, 5U) + (E ^ A ^ B) + 0xCA62C1D6 + (temp = W[hook(4, (67 - 3) & 15)] ^ W[hook(4, (67 - 8) & 15)] ^ W[hook(4, (67 - 14) & 15)] ^ W[hook(4, 67 & 15)], (W[hook(4, 67 & 15)] = rotate(temp, 1U)));
    E = rotate(E, 30U);
  };
  {
    B += rotate(C, 5U) + (D ^ E ^ A) + 0xCA62C1D6 + (temp = W[hook(4, (68 - 3) & 15)] ^ W[hook(4, (68 - 8) & 15)] ^ W[hook(4, (68 - 14) & 15)] ^ W[hook(4, 68 & 15)], (W[hook(4, 68 & 15)] = rotate(temp, 1U)));
    D = rotate(D, 30U);
  };
  {
    A += rotate(B, 5U) + (C ^ D ^ E) + 0xCA62C1D6 + (temp = W[hook(4, (69 - 3) & 15)] ^ W[hook(4, (69 - 8) & 15)] ^ W[hook(4, (69 - 14) & 15)] ^ W[hook(4, 69 & 15)], (W[hook(4, 69 & 15)] = rotate(temp, 1U)));
    C = rotate(C, 30U);
  };
  {
    E += rotate(A, 5U) + (B ^ C ^ D) + 0xCA62C1D6 + (temp = W[hook(4, (70 - 3) & 15)] ^ W[hook(4, (70 - 8) & 15)] ^ W[hook(4, (70 - 14) & 15)] ^ W[hook(4, 70 & 15)], (W[hook(4, 70 & 15)] = rotate(temp, 1U)));
    B = rotate(B, 30U);
  };
  {
    D += rotate(E, 5U) + (A ^ B ^ C) + 0xCA62C1D6 + (temp = W[hook(4, (71 - 3) & 15)] ^ W[hook(4, (71 - 8) & 15)] ^ W[hook(4, (71 - 14) & 15)] ^ W[hook(4, 71 & 15)], (W[hook(4, 71 & 15)] = rotate(temp, 1U)));
    A = rotate(A, 30U);
  };
  {
    C += rotate(D, 5U) + (E ^ A ^ B) + 0xCA62C1D6 + (temp = W[hook(4, (72 - 3) & 15)] ^ W[hook(4, (72 - 8) & 15)] ^ W[hook(4, (72 - 14) & 15)] ^ W[hook(4, 72 & 15)], (W[hook(4, 72 & 15)] = rotate(temp, 1U)));
    E = rotate(E, 30U);
  };
  {
    B += rotate(C, 5U) + (D ^ E ^ A) + 0xCA62C1D6 + (temp = W[hook(4, (73 - 3) & 15)] ^ W[hook(4, (73 - 8) & 15)] ^ W[hook(4, (73 - 14) & 15)] ^ W[hook(4, 73 & 15)], (W[hook(4, 73 & 15)] = rotate(temp, 1U)));
    D = rotate(D, 30U);
  };
  {
    A += rotate(B, 5U) + (C ^ D ^ E) + 0xCA62C1D6 + (temp = W[hook(4, (74 - 3) & 15)] ^ W[hook(4, (74 - 8) & 15)] ^ W[hook(4, (74 - 14) & 15)] ^ W[hook(4, 74 & 15)], (W[hook(4, 74 & 15)] = rotate(temp, 1U)));
    C = rotate(C, 30U);
  };
  {
    E += rotate(A, 5U) + (B ^ C ^ D) + 0xCA62C1D6 + (temp = W[hook(4, (75 - 3) & 15)] ^ W[hook(4, (75 - 8) & 15)] ^ W[hook(4, (75 - 14) & 15)] ^ W[hook(4, 75 & 15)], (W[hook(4, 75 & 15)] = rotate(temp, 1U)));
    B = rotate(B, 30U);
  };
  {
    D += rotate(E, 5U) + (A ^ B ^ C) + 0xCA62C1D6 + (temp = W[hook(4, (76 - 3) & 15)] ^ W[hook(4, (76 - 8) & 15)] ^ W[hook(4, (76 - 14) & 15)] ^ W[hook(4, 76 & 15)], (W[hook(4, 76 & 15)] = rotate(temp, 1U)));
    A = rotate(A, 30U);
  };
  {
    C += rotate(D, 5U) + (E ^ A ^ B) + 0xCA62C1D6 + (temp = W[hook(4, (77 - 3) & 15)] ^ W[hook(4, (77 - 8) & 15)] ^ W[hook(4, (77 - 14) & 15)] ^ W[hook(4, 77 & 15)], (W[hook(4, 77 & 15)] = rotate(temp, 1U)));
    E = rotate(E, 30U);
  };
  {
    B += rotate(C, 5U) + (D ^ E ^ A) + 0xCA62C1D6 + (temp = W[hook(4, (78 - 3) & 15)] ^ W[hook(4, (78 - 8) & 15)] ^ W[hook(4, (78 - 14) & 15)] ^ W[hook(4, 78 & 15)], (W[hook(4, 78 & 15)] = rotate(temp, 1U)));
    D = rotate(D, 30U);
  };
  {
    A += rotate(B, 5U) + (C ^ D ^ E) + 0xCA62C1D6 + (temp = W[hook(4, (79 - 3) & 15)] ^ W[hook(4, (79 - 8) & 15)] ^ W[hook(4, (79 - 14) & 15)] ^ W[hook(4, 79 & 15)], (W[hook(4, 79 & 15)] = rotate(temp, 1U)));
    C = rotate(C, 30U);
  };

  output[hook(2, 0)] += A;
  output[hook(2, 1)] += B;
  output[hook(2, 2)] += C;
  output[hook(2, 3)] += D;
  output[hook(2, 4)] += E;
}
inline void sha1_final(unsigned int* W, unsigned int* output, const unsigned int tot_len) {
  unsigned int len = ((tot_len & 63) >> 2) + 1;

  (W)[hook(6, (tot_len & 63) >> 2)] = ((W)[hook(6, (tot_len & 63) >> 2)] & (0xffffff00U << ((((tot_len & 63) & 3) ^ 3) << 3))) + ((0x80) << ((((tot_len & 63) & 3) ^ 3) << 3));

  while (len < 15)
    W[hook(4, len++)] = 0;
  W[hook(4, 15)] = tot_len << 3;
  sha1_block(W, output);
}

kernel void RarInit(global unsigned int* OutputBuf, global unsigned int* round) {
  unsigned int gid = get_global_id(0);
  unsigned int gws = get_global_size(0);
  unsigned int i, output[5];

  round[hook(1, gid)] = 0;
  {
    output[hook(2, 0)] = 0x67452301;
    output[hook(2, 1)] = 0xEFCDAB89;
    output[hook(2, 2)] = 0x98BADCFE;
    output[hook(2, 3)] = 0x10325476;
    output[hook(2, 4)] = 0xC3D2E1F0;
  };

  for (i = 0; i < 5; i++)
    OutputBuf[hook(0, i * gws + gid)] = output[hook(2, i)];
}