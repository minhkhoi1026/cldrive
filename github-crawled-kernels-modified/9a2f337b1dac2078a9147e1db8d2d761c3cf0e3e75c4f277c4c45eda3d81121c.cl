//{"(W)":7,"OutputBuf":1,"W":5,"Win":6,"aes_key":2,"out":4,"output":3,"pw_len":0}
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
    output[hook(3, temp)] = out[hook(4, temp)];

  while (blocks--) {
    A = output[hook(3, 0)];
    B = output[hook(3, 1)];
    C = output[hook(3, 2)];
    D = output[hook(3, 3)];
    E = output[hook(3, 4)];

    for (temp = 0; temp < 16; temp++)
      W[hook(5, temp)] = Win[hook(6, temp)];
    {
      E += rotate(A, 5U) + bitselect(D, C, B) + 0x5A827999 + W[hook(5, 0)];
      B = rotate(B, 30U);
    };
    {
      D += rotate(E, 5U) + bitselect(C, B, A) + 0x5A827999 + W[hook(5, 1)];
      A = rotate(A, 30U);
    };
    {
      C += rotate(D, 5U) + bitselect(B, A, E) + 0x5A827999 + W[hook(5, 2)];
      E = rotate(E, 30U);
    };
    {
      B += rotate(C, 5U) + bitselect(A, E, D) + 0x5A827999 + W[hook(5, 3)];
      D = rotate(D, 30U);
    };
    {
      A += rotate(B, 5U) + bitselect(E, D, C) + 0x5A827999 + W[hook(5, 4)];
      C = rotate(C, 30U);
    };
    {
      E += rotate(A, 5U) + bitselect(D, C, B) + 0x5A827999 + W[hook(5, 5)];
      B = rotate(B, 30U);
    };
    {
      D += rotate(E, 5U) + bitselect(C, B, A) + 0x5A827999 + W[hook(5, 6)];
      A = rotate(A, 30U);
    };
    {
      C += rotate(D, 5U) + bitselect(B, A, E) + 0x5A827999 + W[hook(5, 7)];
      E = rotate(E, 30U);
    };
    {
      B += rotate(C, 5U) + bitselect(A, E, D) + 0x5A827999 + W[hook(5, 8)];
      D = rotate(D, 30U);
    };
    {
      A += rotate(B, 5U) + bitselect(E, D, C) + 0x5A827999 + W[hook(5, 9)];
      C = rotate(C, 30U);
    };
    {
      E += rotate(A, 5U) + bitselect(D, C, B) + 0x5A827999 + W[hook(5, 10)];
      B = rotate(B, 30U);
    };
    {
      D += rotate(E, 5U) + bitselect(C, B, A) + 0x5A827999 + W[hook(5, 11)];
      A = rotate(A, 30U);
    };
    {
      C += rotate(D, 5U) + bitselect(B, A, E) + 0x5A827999 + W[hook(5, 12)];
      E = rotate(E, 30U);
    };
    {
      B += rotate(C, 5U) + bitselect(A, E, D) + 0x5A827999 + W[hook(5, 13)];
      D = rotate(D, 30U);
    };
    {
      A += rotate(B, 5U) + bitselect(E, D, C) + 0x5A827999 + W[hook(5, 14)];
      C = rotate(C, 30U);
    };
    {
      E += rotate(A, 5U) + bitselect(D, C, B) + 0x5A827999 + W[hook(5, 15)];
      B = rotate(B, 30U);
    };
    {
      D += rotate(E, 5U) + bitselect(C, B, A) + 0x5A827999 + (temp = W[hook(5, (16 - 3) & 15)] ^ W[hook(5, (16 - 8) & 15)] ^ W[hook(5, (16 - 14) & 15)] ^ W[hook(5, 16 & 15)], (W[hook(5, 16 & 15)] = rotate(temp, 1U)));
      A = rotate(A, 30U);
    };
    {
      C += rotate(D, 5U) + bitselect(B, A, E) + 0x5A827999 + (temp = W[hook(5, (17 - 3) & 15)] ^ W[hook(5, (17 - 8) & 15)] ^ W[hook(5, (17 - 14) & 15)] ^ W[hook(5, 17 & 15)], (W[hook(5, 17 & 15)] = rotate(temp, 1U)));
      E = rotate(E, 30U);
    };
    {
      B += rotate(C, 5U) + bitselect(A, E, D) + 0x5A827999 + (temp = W[hook(5, (18 - 3) & 15)] ^ W[hook(5, (18 - 8) & 15)] ^ W[hook(5, (18 - 14) & 15)] ^ W[hook(5, 18 & 15)], (W[hook(5, 18 & 15)] = rotate(temp, 1U)));
      D = rotate(D, 30U);
    };
    {
      A += rotate(B, 5U) + bitselect(E, D, C) + 0x5A827999 + (temp = W[hook(5, (19 - 3) & 15)] ^ W[hook(5, (19 - 8) & 15)] ^ W[hook(5, (19 - 14) & 15)] ^ W[hook(5, 19 & 15)], (W[hook(5, 19 & 15)] = rotate(temp, 1U)));
      C = rotate(C, 30U);
    };

    {
      E += rotate(A, 5U) + (B ^ C ^ D) + 0x6ED9EBA1 + (temp = W[hook(5, (20 - 3) & 15)] ^ W[hook(5, (20 - 8) & 15)] ^ W[hook(5, (20 - 14) & 15)] ^ W[hook(5, 20 & 15)], (W[hook(5, 20 & 15)] = rotate(temp, 1U)));
      B = rotate(B, 30U);
    };
    {
      D += rotate(E, 5U) + (A ^ B ^ C) + 0x6ED9EBA1 + (temp = W[hook(5, (21 - 3) & 15)] ^ W[hook(5, (21 - 8) & 15)] ^ W[hook(5, (21 - 14) & 15)] ^ W[hook(5, 21 & 15)], (W[hook(5, 21 & 15)] = rotate(temp, 1U)));
      A = rotate(A, 30U);
    };
    {
      C += rotate(D, 5U) + (E ^ A ^ B) + 0x6ED9EBA1 + (temp = W[hook(5, (22 - 3) & 15)] ^ W[hook(5, (22 - 8) & 15)] ^ W[hook(5, (22 - 14) & 15)] ^ W[hook(5, 22 & 15)], (W[hook(5, 22 & 15)] = rotate(temp, 1U)));
      E = rotate(E, 30U);
    };
    {
      B += rotate(C, 5U) + (D ^ E ^ A) + 0x6ED9EBA1 + (temp = W[hook(5, (23 - 3) & 15)] ^ W[hook(5, (23 - 8) & 15)] ^ W[hook(5, (23 - 14) & 15)] ^ W[hook(5, 23 & 15)], (W[hook(5, 23 & 15)] = rotate(temp, 1U)));
      D = rotate(D, 30U);
    };
    {
      A += rotate(B, 5U) + (C ^ D ^ E) + 0x6ED9EBA1 + (temp = W[hook(5, (24 - 3) & 15)] ^ W[hook(5, (24 - 8) & 15)] ^ W[hook(5, (24 - 14) & 15)] ^ W[hook(5, 24 & 15)], (W[hook(5, 24 & 15)] = rotate(temp, 1U)));
      C = rotate(C, 30U);
    };
    {
      E += rotate(A, 5U) + (B ^ C ^ D) + 0x6ED9EBA1 + (temp = W[hook(5, (25 - 3) & 15)] ^ W[hook(5, (25 - 8) & 15)] ^ W[hook(5, (25 - 14) & 15)] ^ W[hook(5, 25 & 15)], (W[hook(5, 25 & 15)] = rotate(temp, 1U)));
      B = rotate(B, 30U);
    };
    {
      D += rotate(E, 5U) + (A ^ B ^ C) + 0x6ED9EBA1 + (temp = W[hook(5, (26 - 3) & 15)] ^ W[hook(5, (26 - 8) & 15)] ^ W[hook(5, (26 - 14) & 15)] ^ W[hook(5, 26 & 15)], (W[hook(5, 26 & 15)] = rotate(temp, 1U)));
      A = rotate(A, 30U);
    };
    {
      C += rotate(D, 5U) + (E ^ A ^ B) + 0x6ED9EBA1 + (temp = W[hook(5, (27 - 3) & 15)] ^ W[hook(5, (27 - 8) & 15)] ^ W[hook(5, (27 - 14) & 15)] ^ W[hook(5, 27 & 15)], (W[hook(5, 27 & 15)] = rotate(temp, 1U)));
      E = rotate(E, 30U);
    };
    {
      B += rotate(C, 5U) + (D ^ E ^ A) + 0x6ED9EBA1 + (temp = W[hook(5, (28 - 3) & 15)] ^ W[hook(5, (28 - 8) & 15)] ^ W[hook(5, (28 - 14) & 15)] ^ W[hook(5, 28 & 15)], (W[hook(5, 28 & 15)] = rotate(temp, 1U)));
      D = rotate(D, 30U);
    };
    {
      A += rotate(B, 5U) + (C ^ D ^ E) + 0x6ED9EBA1 + (temp = W[hook(5, (29 - 3) & 15)] ^ W[hook(5, (29 - 8) & 15)] ^ W[hook(5, (29 - 14) & 15)] ^ W[hook(5, 29 & 15)], (W[hook(5, 29 & 15)] = rotate(temp, 1U)));
      C = rotate(C, 30U);
    };
    {
      E += rotate(A, 5U) + (B ^ C ^ D) + 0x6ED9EBA1 + (temp = W[hook(5, (30 - 3) & 15)] ^ W[hook(5, (30 - 8) & 15)] ^ W[hook(5, (30 - 14) & 15)] ^ W[hook(5, 30 & 15)], (W[hook(5, 30 & 15)] = rotate(temp, 1U)));
      B = rotate(B, 30U);
    };
    {
      D += rotate(E, 5U) + (A ^ B ^ C) + 0x6ED9EBA1 + (temp = W[hook(5, (31 - 3) & 15)] ^ W[hook(5, (31 - 8) & 15)] ^ W[hook(5, (31 - 14) & 15)] ^ W[hook(5, 31 & 15)], (W[hook(5, 31 & 15)] = rotate(temp, 1U)));
      A = rotate(A, 30U);
    };
    {
      C += rotate(D, 5U) + (E ^ A ^ B) + 0x6ED9EBA1 + (temp = W[hook(5, (32 - 3) & 15)] ^ W[hook(5, (32 - 8) & 15)] ^ W[hook(5, (32 - 14) & 15)] ^ W[hook(5, 32 & 15)], (W[hook(5, 32 & 15)] = rotate(temp, 1U)));
      E = rotate(E, 30U);
    };
    {
      B += rotate(C, 5U) + (D ^ E ^ A) + 0x6ED9EBA1 + (temp = W[hook(5, (33 - 3) & 15)] ^ W[hook(5, (33 - 8) & 15)] ^ W[hook(5, (33 - 14) & 15)] ^ W[hook(5, 33 & 15)], (W[hook(5, 33 & 15)] = rotate(temp, 1U)));
      D = rotate(D, 30U);
    };
    {
      A += rotate(B, 5U) + (C ^ D ^ E) + 0x6ED9EBA1 + (temp = W[hook(5, (34 - 3) & 15)] ^ W[hook(5, (34 - 8) & 15)] ^ W[hook(5, (34 - 14) & 15)] ^ W[hook(5, 34 & 15)], (W[hook(5, 34 & 15)] = rotate(temp, 1U)));
      C = rotate(C, 30U);
    };
    {
      E += rotate(A, 5U) + (B ^ C ^ D) + 0x6ED9EBA1 + (temp = W[hook(5, (35 - 3) & 15)] ^ W[hook(5, (35 - 8) & 15)] ^ W[hook(5, (35 - 14) & 15)] ^ W[hook(5, 35 & 15)], (W[hook(5, 35 & 15)] = rotate(temp, 1U)));
      B = rotate(B, 30U);
    };
    {
      D += rotate(E, 5U) + (A ^ B ^ C) + 0x6ED9EBA1 + (temp = W[hook(5, (36 - 3) & 15)] ^ W[hook(5, (36 - 8) & 15)] ^ W[hook(5, (36 - 14) & 15)] ^ W[hook(5, 36 & 15)], (W[hook(5, 36 & 15)] = rotate(temp, 1U)));
      A = rotate(A, 30U);
    };
    {
      C += rotate(D, 5U) + (E ^ A ^ B) + 0x6ED9EBA1 + (temp = W[hook(5, (37 - 3) & 15)] ^ W[hook(5, (37 - 8) & 15)] ^ W[hook(5, (37 - 14) & 15)] ^ W[hook(5, 37 & 15)], (W[hook(5, 37 & 15)] = rotate(temp, 1U)));
      E = rotate(E, 30U);
    };
    {
      B += rotate(C, 5U) + (D ^ E ^ A) + 0x6ED9EBA1 + (temp = W[hook(5, (38 - 3) & 15)] ^ W[hook(5, (38 - 8) & 15)] ^ W[hook(5, (38 - 14) & 15)] ^ W[hook(5, 38 & 15)], (W[hook(5, 38 & 15)] = rotate(temp, 1U)));
      D = rotate(D, 30U);
    };
    {
      A += rotate(B, 5U) + (C ^ D ^ E) + 0x6ED9EBA1 + (temp = W[hook(5, (39 - 3) & 15)] ^ W[hook(5, (39 - 8) & 15)] ^ W[hook(5, (39 - 14) & 15)] ^ W[hook(5, 39 & 15)], (W[hook(5, 39 & 15)] = rotate(temp, 1U)));
      C = rotate(C, 30U);
    };
    {
      E += rotate(A, 5U) + (bitselect(B, C, D) ^ bitselect(B, 0U, C)) + 0x8F1BBCDC + (temp = W[hook(5, (40 - 3) & 15)] ^ W[hook(5, (40 - 8) & 15)] ^ W[hook(5, (40 - 14) & 15)] ^ W[hook(5, 40 & 15)], (W[hook(5, 40 & 15)] = rotate(temp, 1U)));
      B = rotate(B, 30U);
    };
    {
      D += rotate(E, 5U) + (bitselect(A, B, C) ^ bitselect(A, 0U, B)) + 0x8F1BBCDC + (temp = W[hook(5, (41 - 3) & 15)] ^ W[hook(5, (41 - 8) & 15)] ^ W[hook(5, (41 - 14) & 15)] ^ W[hook(5, 41 & 15)], (W[hook(5, 41 & 15)] = rotate(temp, 1U)));
      A = rotate(A, 30U);
    };
    {
      C += rotate(D, 5U) + (bitselect(E, A, B) ^ bitselect(E, 0U, A)) + 0x8F1BBCDC + (temp = W[hook(5, (42 - 3) & 15)] ^ W[hook(5, (42 - 8) & 15)] ^ W[hook(5, (42 - 14) & 15)] ^ W[hook(5, 42 & 15)], (W[hook(5, 42 & 15)] = rotate(temp, 1U)));
      E = rotate(E, 30U);
    };
    {
      B += rotate(C, 5U) + (bitselect(D, E, A) ^ bitselect(D, 0U, E)) + 0x8F1BBCDC + (temp = W[hook(5, (43 - 3) & 15)] ^ W[hook(5, (43 - 8) & 15)] ^ W[hook(5, (43 - 14) & 15)] ^ W[hook(5, 43 & 15)], (W[hook(5, 43 & 15)] = rotate(temp, 1U)));
      D = rotate(D, 30U);
    };
    {
      A += rotate(B, 5U) + (bitselect(C, D, E) ^ bitselect(C, 0U, D)) + 0x8F1BBCDC + (temp = W[hook(5, (44 - 3) & 15)] ^ W[hook(5, (44 - 8) & 15)] ^ W[hook(5, (44 - 14) & 15)] ^ W[hook(5, 44 & 15)], (W[hook(5, 44 & 15)] = rotate(temp, 1U)));
      C = rotate(C, 30U);
    };
    {
      E += rotate(A, 5U) + (bitselect(B, C, D) ^ bitselect(B, 0U, C)) + 0x8F1BBCDC + (temp = W[hook(5, (45 - 3) & 15)] ^ W[hook(5, (45 - 8) & 15)] ^ W[hook(5, (45 - 14) & 15)] ^ W[hook(5, 45 & 15)], (W[hook(5, 45 & 15)] = rotate(temp, 1U)));
      B = rotate(B, 30U);
    };
    {
      D += rotate(E, 5U) + (bitselect(A, B, C) ^ bitselect(A, 0U, B)) + 0x8F1BBCDC + (temp = W[hook(5, (46 - 3) & 15)] ^ W[hook(5, (46 - 8) & 15)] ^ W[hook(5, (46 - 14) & 15)] ^ W[hook(5, 46 & 15)], (W[hook(5, 46 & 15)] = rotate(temp, 1U)));
      A = rotate(A, 30U);
    };
    {
      C += rotate(D, 5U) + (bitselect(E, A, B) ^ bitselect(E, 0U, A)) + 0x8F1BBCDC + (temp = W[hook(5, (47 - 3) & 15)] ^ W[hook(5, (47 - 8) & 15)] ^ W[hook(5, (47 - 14) & 15)] ^ W[hook(5, 47 & 15)], (W[hook(5, 47 & 15)] = rotate(temp, 1U)));
      E = rotate(E, 30U);
    };
    {
      B += rotate(C, 5U) + (bitselect(D, E, A) ^ bitselect(D, 0U, E)) + 0x8F1BBCDC + (temp = W[hook(5, (48 - 3) & 15)] ^ W[hook(5, (48 - 8) & 15)] ^ W[hook(5, (48 - 14) & 15)] ^ W[hook(5, 48 & 15)], (W[hook(5, 48 & 15)] = rotate(temp, 1U)));
      D = rotate(D, 30U);
    };
    {
      A += rotate(B, 5U) + (bitselect(C, D, E) ^ bitselect(C, 0U, D)) + 0x8F1BBCDC + (temp = W[hook(5, (49 - 3) & 15)] ^ W[hook(5, (49 - 8) & 15)] ^ W[hook(5, (49 - 14) & 15)] ^ W[hook(5, 49 & 15)], (W[hook(5, 49 & 15)] = rotate(temp, 1U)));
      C = rotate(C, 30U);
    };
    {
      E += rotate(A, 5U) + (bitselect(B, C, D) ^ bitselect(B, 0U, C)) + 0x8F1BBCDC + (temp = W[hook(5, (50 - 3) & 15)] ^ W[hook(5, (50 - 8) & 15)] ^ W[hook(5, (50 - 14) & 15)] ^ W[hook(5, 50 & 15)], (W[hook(5, 50 & 15)] = rotate(temp, 1U)));
      B = rotate(B, 30U);
    };
    {
      D += rotate(E, 5U) + (bitselect(A, B, C) ^ bitselect(A, 0U, B)) + 0x8F1BBCDC + (temp = W[hook(5, (51 - 3) & 15)] ^ W[hook(5, (51 - 8) & 15)] ^ W[hook(5, (51 - 14) & 15)] ^ W[hook(5, 51 & 15)], (W[hook(5, 51 & 15)] = rotate(temp, 1U)));
      A = rotate(A, 30U);
    };
    {
      C += rotate(D, 5U) + (bitselect(E, A, B) ^ bitselect(E, 0U, A)) + 0x8F1BBCDC + (temp = W[hook(5, (52 - 3) & 15)] ^ W[hook(5, (52 - 8) & 15)] ^ W[hook(5, (52 - 14) & 15)] ^ W[hook(5, 52 & 15)], (W[hook(5, 52 & 15)] = rotate(temp, 1U)));
      E = rotate(E, 30U);
    };
    {
      B += rotate(C, 5U) + (bitselect(D, E, A) ^ bitselect(D, 0U, E)) + 0x8F1BBCDC + (temp = W[hook(5, (53 - 3) & 15)] ^ W[hook(5, (53 - 8) & 15)] ^ W[hook(5, (53 - 14) & 15)] ^ W[hook(5, 53 & 15)], (W[hook(5, 53 & 15)] = rotate(temp, 1U)));
      D = rotate(D, 30U);
    };
    {
      A += rotate(B, 5U) + (bitselect(C, D, E) ^ bitselect(C, 0U, D)) + 0x8F1BBCDC + (temp = W[hook(5, (54 - 3) & 15)] ^ W[hook(5, (54 - 8) & 15)] ^ W[hook(5, (54 - 14) & 15)] ^ W[hook(5, 54 & 15)], (W[hook(5, 54 & 15)] = rotate(temp, 1U)));
      C = rotate(C, 30U);
    };
    {
      E += rotate(A, 5U) + (bitselect(B, C, D) ^ bitselect(B, 0U, C)) + 0x8F1BBCDC + (temp = W[hook(5, (55 - 3) & 15)] ^ W[hook(5, (55 - 8) & 15)] ^ W[hook(5, (55 - 14) & 15)] ^ W[hook(5, 55 & 15)], (W[hook(5, 55 & 15)] = rotate(temp, 1U)));
      B = rotate(B, 30U);
    };
    {
      D += rotate(E, 5U) + (bitselect(A, B, C) ^ bitselect(A, 0U, B)) + 0x8F1BBCDC + (temp = W[hook(5, (56 - 3) & 15)] ^ W[hook(5, (56 - 8) & 15)] ^ W[hook(5, (56 - 14) & 15)] ^ W[hook(5, 56 & 15)], (W[hook(5, 56 & 15)] = rotate(temp, 1U)));
      A = rotate(A, 30U);
    };
    {
      C += rotate(D, 5U) + (bitselect(E, A, B) ^ bitselect(E, 0U, A)) + 0x8F1BBCDC + (temp = W[hook(5, (57 - 3) & 15)] ^ W[hook(5, (57 - 8) & 15)] ^ W[hook(5, (57 - 14) & 15)] ^ W[hook(5, 57 & 15)], (W[hook(5, 57 & 15)] = rotate(temp, 1U)));
      E = rotate(E, 30U);
    };
    {
      B += rotate(C, 5U) + (bitselect(D, E, A) ^ bitselect(D, 0U, E)) + 0x8F1BBCDC + (temp = W[hook(5, (58 - 3) & 15)] ^ W[hook(5, (58 - 8) & 15)] ^ W[hook(5, (58 - 14) & 15)] ^ W[hook(5, 58 & 15)], (W[hook(5, 58 & 15)] = rotate(temp, 1U)));
      D = rotate(D, 30U);
    };
    {
      A += rotate(B, 5U) + (bitselect(C, D, E) ^ bitselect(C, 0U, D)) + 0x8F1BBCDC + (temp = W[hook(5, (59 - 3) & 15)] ^ W[hook(5, (59 - 8) & 15)] ^ W[hook(5, (59 - 14) & 15)] ^ W[hook(5, 59 & 15)], (W[hook(5, 59 & 15)] = rotate(temp, 1U)));
      C = rotate(C, 30U);
    };

    {
      E += rotate(A, 5U) + (B ^ C ^ D) + 0xCA62C1D6 + (temp = W[hook(5, (60 - 3) & 15)] ^ W[hook(5, (60 - 8) & 15)] ^ W[hook(5, (60 - 14) & 15)] ^ W[hook(5, 60 & 15)], (W[hook(5, 60 & 15)] = rotate(temp, 1U)));
      B = rotate(B, 30U);
    };
    {
      D += rotate(E, 5U) + (A ^ B ^ C) + 0xCA62C1D6 + (temp = W[hook(5, (61 - 3) & 15)] ^ W[hook(5, (61 - 8) & 15)] ^ W[hook(5, (61 - 14) & 15)] ^ W[hook(5, 61 & 15)], (W[hook(5, 61 & 15)] = rotate(temp, 1U)));
      A = rotate(A, 30U);
    };
    {
      C += rotate(D, 5U) + (E ^ A ^ B) + 0xCA62C1D6 + (temp = W[hook(5, (62 - 3) & 15)] ^ W[hook(5, (62 - 8) & 15)] ^ W[hook(5, (62 - 14) & 15)] ^ W[hook(5, 62 & 15)], (W[hook(5, 62 & 15)] = rotate(temp, 1U)));
      E = rotate(E, 30U);
    };
    {
      B += rotate(C, 5U) + (D ^ E ^ A) + 0xCA62C1D6 + (temp = W[hook(5, (63 - 3) & 15)] ^ W[hook(5, (63 - 8) & 15)] ^ W[hook(5, (63 - 14) & 15)] ^ W[hook(5, 63 & 15)], (W[hook(5, 63 & 15)] = rotate(temp, 1U)));
      D = rotate(D, 30U);
    };
    {
      A += rotate(B, 5U) + (C ^ D ^ E) + 0xCA62C1D6 + (temp = W[hook(5, (64 - 3) & 15)] ^ W[hook(5, (64 - 8) & 15)] ^ W[hook(5, (64 - 14) & 15)] ^ W[hook(5, 64 & 15)], (W[hook(5, 64 & 15)] = rotate(temp, 1U)));
      C = rotate(C, 30U);
    };
    {
      E += rotate(A, 5U) + (B ^ C ^ D) + 0xCA62C1D6 + (temp = W[hook(5, (65 - 3) & 15)] ^ W[hook(5, (65 - 8) & 15)] ^ W[hook(5, (65 - 14) & 15)] ^ W[hook(5, 65 & 15)], (W[hook(5, 65 & 15)] = rotate(temp, 1U)));
      B = rotate(B, 30U);
    };
    {
      D += rotate(E, 5U) + (A ^ B ^ C) + 0xCA62C1D6 + (temp = W[hook(5, (66 - 3) & 15)] ^ W[hook(5, (66 - 8) & 15)] ^ W[hook(5, (66 - 14) & 15)] ^ W[hook(5, 66 & 15)], (W[hook(5, 66 & 15)] = rotate(temp, 1U)));
      A = rotate(A, 30U);
    };
    {
      C += rotate(D, 5U) + (E ^ A ^ B) + 0xCA62C1D6 + (temp = W[hook(5, (67 - 3) & 15)] ^ W[hook(5, (67 - 8) & 15)] ^ W[hook(5, (67 - 14) & 15)] ^ W[hook(5, 67 & 15)], (W[hook(5, 67 & 15)] = rotate(temp, 1U)));
      E = rotate(E, 30U);
    };
    {
      B += rotate(C, 5U) + (D ^ E ^ A) + 0xCA62C1D6 + (temp = W[hook(5, (68 - 3) & 15)] ^ W[hook(5, (68 - 8) & 15)] ^ W[hook(5, (68 - 14) & 15)] ^ W[hook(5, 68 & 15)], (W[hook(5, 68 & 15)] = rotate(temp, 1U)));
      D = rotate(D, 30U);
    };
    {
      A += rotate(B, 5U) + (C ^ D ^ E) + 0xCA62C1D6 + (temp = W[hook(5, (69 - 3) & 15)] ^ W[hook(5, (69 - 8) & 15)] ^ W[hook(5, (69 - 14) & 15)] ^ W[hook(5, 69 & 15)], (W[hook(5, 69 & 15)] = rotate(temp, 1U)));
      C = rotate(C, 30U);
    };
    {
      E += rotate(A, 5U) + (B ^ C ^ D) + 0xCA62C1D6 + (temp = W[hook(5, (70 - 3) & 15)] ^ W[hook(5, (70 - 8) & 15)] ^ W[hook(5, (70 - 14) & 15)] ^ W[hook(5, 70 & 15)], (W[hook(5, 70 & 15)] = rotate(temp, 1U)));
      B = rotate(B, 30U);
    };
    {
      D += rotate(E, 5U) + (A ^ B ^ C) + 0xCA62C1D6 + (temp = W[hook(5, (71 - 3) & 15)] ^ W[hook(5, (71 - 8) & 15)] ^ W[hook(5, (71 - 14) & 15)] ^ W[hook(5, 71 & 15)], (W[hook(5, 71 & 15)] = rotate(temp, 1U)));
      A = rotate(A, 30U);
    };
    {
      C += rotate(D, 5U) + (E ^ A ^ B) + 0xCA62C1D6 + (temp = W[hook(5, (72 - 3) & 15)] ^ W[hook(5, (72 - 8) & 15)] ^ W[hook(5, (72 - 14) & 15)] ^ W[hook(5, 72 & 15)], (W[hook(5, 72 & 15)] = rotate(temp, 1U)));
      E = rotate(E, 30U);
    };
    {
      B += rotate(C, 5U) + (D ^ E ^ A) + 0xCA62C1D6 + (temp = W[hook(5, (73 - 3) & 15)] ^ W[hook(5, (73 - 8) & 15)] ^ W[hook(5, (73 - 14) & 15)] ^ W[hook(5, 73 & 15)], (W[hook(5, 73 & 15)] = rotate(temp, 1U)));
      D = rotate(D, 30U);
    };
    {
      A += rotate(B, 5U) + (C ^ D ^ E) + 0xCA62C1D6 + (temp = W[hook(5, (74 - 3) & 15)] ^ W[hook(5, (74 - 8) & 15)] ^ W[hook(5, (74 - 14) & 15)] ^ W[hook(5, 74 & 15)], (W[hook(5, 74 & 15)] = rotate(temp, 1U)));
      C = rotate(C, 30U);
    };
    {
      E += rotate(A, 5U) + (B ^ C ^ D) + 0xCA62C1D6 + (temp = W[hook(5, (75 - 3) & 15)] ^ W[hook(5, (75 - 8) & 15)] ^ W[hook(5, (75 - 14) & 15)] ^ W[hook(5, 75 & 15)], (W[hook(5, 75 & 15)] = rotate(temp, 1U)));
      B = rotate(B, 30U);
    };
    {
      D += rotate(E, 5U) + (A ^ B ^ C) + 0xCA62C1D6 + (temp = W[hook(5, (76 - 3) & 15)] ^ W[hook(5, (76 - 8) & 15)] ^ W[hook(5, (76 - 14) & 15)] ^ W[hook(5, 76 & 15)], (W[hook(5, 76 & 15)] = rotate(temp, 1U)));
      A = rotate(A, 30U);
    };
    {
      C += rotate(D, 5U) + (E ^ A ^ B) + 0xCA62C1D6 + (temp = W[hook(5, (77 - 3) & 15)] ^ W[hook(5, (77 - 8) & 15)] ^ W[hook(5, (77 - 14) & 15)] ^ W[hook(5, 77 & 15)], (W[hook(5, 77 & 15)] = rotate(temp, 1U)));
      E = rotate(E, 30U);
    };
    {
      B += rotate(C, 5U) + (D ^ E ^ A) + 0xCA62C1D6 + (temp = W[hook(5, (78 - 3) & 15)] ^ W[hook(5, (78 - 8) & 15)] ^ W[hook(5, (78 - 14) & 15)] ^ W[hook(5, 78 & 15)], (W[hook(5, 78 & 15)] = rotate(temp, 1U)));
      D = rotate(D, 30U);
    };
    {
      A += rotate(B, 5U) + (C ^ D ^ E) + 0xCA62C1D6 + (temp = W[hook(5, (79 - 3) & 15)] ^ W[hook(5, (79 - 8) & 15)] ^ W[hook(5, (79 - 14) & 15)] ^ W[hook(5, 79 & 15)], (W[hook(5, 79 & 15)] = rotate(temp, 1U)));
      C = rotate(C, 30U);
    };

    output[hook(3, 0)] += A;
    output[hook(3, 1)] += B;
    output[hook(3, 2)] += C;
    output[hook(3, 3)] += D;
    output[hook(3, 4)] += E;

    Win += 16;
  }

  for (temp = 0; temp < 5; temp++)
    out[hook(4, temp)] = output[hook(3, temp)];
}

inline void sha1_block(unsigned int* W, unsigned int* output) {
  unsigned int A, B, C, D, E, temp;

  A = output[hook(3, 0)];
  B = output[hook(3, 1)];
  C = output[hook(3, 2)];
  D = output[hook(3, 3)];
  E = output[hook(3, 4)];
  {
    E += rotate(A, 5U) + bitselect(D, C, B) + 0x5A827999 + W[hook(5, 0)];
    B = rotate(B, 30U);
  };
  {
    D += rotate(E, 5U) + bitselect(C, B, A) + 0x5A827999 + W[hook(5, 1)];
    A = rotate(A, 30U);
  };
  {
    C += rotate(D, 5U) + bitselect(B, A, E) + 0x5A827999 + W[hook(5, 2)];
    E = rotate(E, 30U);
  };
  {
    B += rotate(C, 5U) + bitselect(A, E, D) + 0x5A827999 + W[hook(5, 3)];
    D = rotate(D, 30U);
  };
  {
    A += rotate(B, 5U) + bitselect(E, D, C) + 0x5A827999 + W[hook(5, 4)];
    C = rotate(C, 30U);
  };
  {
    E += rotate(A, 5U) + bitselect(D, C, B) + 0x5A827999 + W[hook(5, 5)];
    B = rotate(B, 30U);
  };
  {
    D += rotate(E, 5U) + bitselect(C, B, A) + 0x5A827999 + W[hook(5, 6)];
    A = rotate(A, 30U);
  };
  {
    C += rotate(D, 5U) + bitselect(B, A, E) + 0x5A827999 + W[hook(5, 7)];
    E = rotate(E, 30U);
  };
  {
    B += rotate(C, 5U) + bitselect(A, E, D) + 0x5A827999 + W[hook(5, 8)];
    D = rotate(D, 30U);
  };
  {
    A += rotate(B, 5U) + bitselect(E, D, C) + 0x5A827999 + W[hook(5, 9)];
    C = rotate(C, 30U);
  };
  {
    E += rotate(A, 5U) + bitselect(D, C, B) + 0x5A827999 + W[hook(5, 10)];
    B = rotate(B, 30U);
  };
  {
    D += rotate(E, 5U) + bitselect(C, B, A) + 0x5A827999 + W[hook(5, 11)];
    A = rotate(A, 30U);
  };
  {
    C += rotate(D, 5U) + bitselect(B, A, E) + 0x5A827999 + W[hook(5, 12)];
    E = rotate(E, 30U);
  };
  {
    B += rotate(C, 5U) + bitselect(A, E, D) + 0x5A827999 + W[hook(5, 13)];
    D = rotate(D, 30U);
  };
  {
    A += rotate(B, 5U) + bitselect(E, D, C) + 0x5A827999 + W[hook(5, 14)];
    C = rotate(C, 30U);
  };
  {
    E += rotate(A, 5U) + bitselect(D, C, B) + 0x5A827999 + W[hook(5, 15)];
    B = rotate(B, 30U);
  };
  {
    D += rotate(E, 5U) + bitselect(C, B, A) + 0x5A827999 + (temp = W[hook(5, (16 - 3) & 15)] ^ W[hook(5, (16 - 8) & 15)] ^ W[hook(5, (16 - 14) & 15)] ^ W[hook(5, 16 & 15)], (W[hook(5, 16 & 15)] = rotate(temp, 1U)));
    A = rotate(A, 30U);
  };
  {
    C += rotate(D, 5U) + bitselect(B, A, E) + 0x5A827999 + (temp = W[hook(5, (17 - 3) & 15)] ^ W[hook(5, (17 - 8) & 15)] ^ W[hook(5, (17 - 14) & 15)] ^ W[hook(5, 17 & 15)], (W[hook(5, 17 & 15)] = rotate(temp, 1U)));
    E = rotate(E, 30U);
  };
  {
    B += rotate(C, 5U) + bitselect(A, E, D) + 0x5A827999 + (temp = W[hook(5, (18 - 3) & 15)] ^ W[hook(5, (18 - 8) & 15)] ^ W[hook(5, (18 - 14) & 15)] ^ W[hook(5, 18 & 15)], (W[hook(5, 18 & 15)] = rotate(temp, 1U)));
    D = rotate(D, 30U);
  };
  {
    A += rotate(B, 5U) + bitselect(E, D, C) + 0x5A827999 + (temp = W[hook(5, (19 - 3) & 15)] ^ W[hook(5, (19 - 8) & 15)] ^ W[hook(5, (19 - 14) & 15)] ^ W[hook(5, 19 & 15)], (W[hook(5, 19 & 15)] = rotate(temp, 1U)));
    C = rotate(C, 30U);
  };

  {
    E += rotate(A, 5U) + (B ^ C ^ D) + 0x6ED9EBA1 + (temp = W[hook(5, (20 - 3) & 15)] ^ W[hook(5, (20 - 8) & 15)] ^ W[hook(5, (20 - 14) & 15)] ^ W[hook(5, 20 & 15)], (W[hook(5, 20 & 15)] = rotate(temp, 1U)));
    B = rotate(B, 30U);
  };
  {
    D += rotate(E, 5U) + (A ^ B ^ C) + 0x6ED9EBA1 + (temp = W[hook(5, (21 - 3) & 15)] ^ W[hook(5, (21 - 8) & 15)] ^ W[hook(5, (21 - 14) & 15)] ^ W[hook(5, 21 & 15)], (W[hook(5, 21 & 15)] = rotate(temp, 1U)));
    A = rotate(A, 30U);
  };
  {
    C += rotate(D, 5U) + (E ^ A ^ B) + 0x6ED9EBA1 + (temp = W[hook(5, (22 - 3) & 15)] ^ W[hook(5, (22 - 8) & 15)] ^ W[hook(5, (22 - 14) & 15)] ^ W[hook(5, 22 & 15)], (W[hook(5, 22 & 15)] = rotate(temp, 1U)));
    E = rotate(E, 30U);
  };
  {
    B += rotate(C, 5U) + (D ^ E ^ A) + 0x6ED9EBA1 + (temp = W[hook(5, (23 - 3) & 15)] ^ W[hook(5, (23 - 8) & 15)] ^ W[hook(5, (23 - 14) & 15)] ^ W[hook(5, 23 & 15)], (W[hook(5, 23 & 15)] = rotate(temp, 1U)));
    D = rotate(D, 30U);
  };
  {
    A += rotate(B, 5U) + (C ^ D ^ E) + 0x6ED9EBA1 + (temp = W[hook(5, (24 - 3) & 15)] ^ W[hook(5, (24 - 8) & 15)] ^ W[hook(5, (24 - 14) & 15)] ^ W[hook(5, 24 & 15)], (W[hook(5, 24 & 15)] = rotate(temp, 1U)));
    C = rotate(C, 30U);
  };
  {
    E += rotate(A, 5U) + (B ^ C ^ D) + 0x6ED9EBA1 + (temp = W[hook(5, (25 - 3) & 15)] ^ W[hook(5, (25 - 8) & 15)] ^ W[hook(5, (25 - 14) & 15)] ^ W[hook(5, 25 & 15)], (W[hook(5, 25 & 15)] = rotate(temp, 1U)));
    B = rotate(B, 30U);
  };
  {
    D += rotate(E, 5U) + (A ^ B ^ C) + 0x6ED9EBA1 + (temp = W[hook(5, (26 - 3) & 15)] ^ W[hook(5, (26 - 8) & 15)] ^ W[hook(5, (26 - 14) & 15)] ^ W[hook(5, 26 & 15)], (W[hook(5, 26 & 15)] = rotate(temp, 1U)));
    A = rotate(A, 30U);
  };
  {
    C += rotate(D, 5U) + (E ^ A ^ B) + 0x6ED9EBA1 + (temp = W[hook(5, (27 - 3) & 15)] ^ W[hook(5, (27 - 8) & 15)] ^ W[hook(5, (27 - 14) & 15)] ^ W[hook(5, 27 & 15)], (W[hook(5, 27 & 15)] = rotate(temp, 1U)));
    E = rotate(E, 30U);
  };
  {
    B += rotate(C, 5U) + (D ^ E ^ A) + 0x6ED9EBA1 + (temp = W[hook(5, (28 - 3) & 15)] ^ W[hook(5, (28 - 8) & 15)] ^ W[hook(5, (28 - 14) & 15)] ^ W[hook(5, 28 & 15)], (W[hook(5, 28 & 15)] = rotate(temp, 1U)));
    D = rotate(D, 30U);
  };
  {
    A += rotate(B, 5U) + (C ^ D ^ E) + 0x6ED9EBA1 + (temp = W[hook(5, (29 - 3) & 15)] ^ W[hook(5, (29 - 8) & 15)] ^ W[hook(5, (29 - 14) & 15)] ^ W[hook(5, 29 & 15)], (W[hook(5, 29 & 15)] = rotate(temp, 1U)));
    C = rotate(C, 30U);
  };
  {
    E += rotate(A, 5U) + (B ^ C ^ D) + 0x6ED9EBA1 + (temp = W[hook(5, (30 - 3) & 15)] ^ W[hook(5, (30 - 8) & 15)] ^ W[hook(5, (30 - 14) & 15)] ^ W[hook(5, 30 & 15)], (W[hook(5, 30 & 15)] = rotate(temp, 1U)));
    B = rotate(B, 30U);
  };
  {
    D += rotate(E, 5U) + (A ^ B ^ C) + 0x6ED9EBA1 + (temp = W[hook(5, (31 - 3) & 15)] ^ W[hook(5, (31 - 8) & 15)] ^ W[hook(5, (31 - 14) & 15)] ^ W[hook(5, 31 & 15)], (W[hook(5, 31 & 15)] = rotate(temp, 1U)));
    A = rotate(A, 30U);
  };
  {
    C += rotate(D, 5U) + (E ^ A ^ B) + 0x6ED9EBA1 + (temp = W[hook(5, (32 - 3) & 15)] ^ W[hook(5, (32 - 8) & 15)] ^ W[hook(5, (32 - 14) & 15)] ^ W[hook(5, 32 & 15)], (W[hook(5, 32 & 15)] = rotate(temp, 1U)));
    E = rotate(E, 30U);
  };
  {
    B += rotate(C, 5U) + (D ^ E ^ A) + 0x6ED9EBA1 + (temp = W[hook(5, (33 - 3) & 15)] ^ W[hook(5, (33 - 8) & 15)] ^ W[hook(5, (33 - 14) & 15)] ^ W[hook(5, 33 & 15)], (W[hook(5, 33 & 15)] = rotate(temp, 1U)));
    D = rotate(D, 30U);
  };
  {
    A += rotate(B, 5U) + (C ^ D ^ E) + 0x6ED9EBA1 + (temp = W[hook(5, (34 - 3) & 15)] ^ W[hook(5, (34 - 8) & 15)] ^ W[hook(5, (34 - 14) & 15)] ^ W[hook(5, 34 & 15)], (W[hook(5, 34 & 15)] = rotate(temp, 1U)));
    C = rotate(C, 30U);
  };
  {
    E += rotate(A, 5U) + (B ^ C ^ D) + 0x6ED9EBA1 + (temp = W[hook(5, (35 - 3) & 15)] ^ W[hook(5, (35 - 8) & 15)] ^ W[hook(5, (35 - 14) & 15)] ^ W[hook(5, 35 & 15)], (W[hook(5, 35 & 15)] = rotate(temp, 1U)));
    B = rotate(B, 30U);
  };
  {
    D += rotate(E, 5U) + (A ^ B ^ C) + 0x6ED9EBA1 + (temp = W[hook(5, (36 - 3) & 15)] ^ W[hook(5, (36 - 8) & 15)] ^ W[hook(5, (36 - 14) & 15)] ^ W[hook(5, 36 & 15)], (W[hook(5, 36 & 15)] = rotate(temp, 1U)));
    A = rotate(A, 30U);
  };
  {
    C += rotate(D, 5U) + (E ^ A ^ B) + 0x6ED9EBA1 + (temp = W[hook(5, (37 - 3) & 15)] ^ W[hook(5, (37 - 8) & 15)] ^ W[hook(5, (37 - 14) & 15)] ^ W[hook(5, 37 & 15)], (W[hook(5, 37 & 15)] = rotate(temp, 1U)));
    E = rotate(E, 30U);
  };
  {
    B += rotate(C, 5U) + (D ^ E ^ A) + 0x6ED9EBA1 + (temp = W[hook(5, (38 - 3) & 15)] ^ W[hook(5, (38 - 8) & 15)] ^ W[hook(5, (38 - 14) & 15)] ^ W[hook(5, 38 & 15)], (W[hook(5, 38 & 15)] = rotate(temp, 1U)));
    D = rotate(D, 30U);
  };
  {
    A += rotate(B, 5U) + (C ^ D ^ E) + 0x6ED9EBA1 + (temp = W[hook(5, (39 - 3) & 15)] ^ W[hook(5, (39 - 8) & 15)] ^ W[hook(5, (39 - 14) & 15)] ^ W[hook(5, 39 & 15)], (W[hook(5, 39 & 15)] = rotate(temp, 1U)));
    C = rotate(C, 30U);
  };
  {
    E += rotate(A, 5U) + (bitselect(B, C, D) ^ bitselect(B, 0U, C)) + 0x8F1BBCDC + (temp = W[hook(5, (40 - 3) & 15)] ^ W[hook(5, (40 - 8) & 15)] ^ W[hook(5, (40 - 14) & 15)] ^ W[hook(5, 40 & 15)], (W[hook(5, 40 & 15)] = rotate(temp, 1U)));
    B = rotate(B, 30U);
  };
  {
    D += rotate(E, 5U) + (bitselect(A, B, C) ^ bitselect(A, 0U, B)) + 0x8F1BBCDC + (temp = W[hook(5, (41 - 3) & 15)] ^ W[hook(5, (41 - 8) & 15)] ^ W[hook(5, (41 - 14) & 15)] ^ W[hook(5, 41 & 15)], (W[hook(5, 41 & 15)] = rotate(temp, 1U)));
    A = rotate(A, 30U);
  };
  {
    C += rotate(D, 5U) + (bitselect(E, A, B) ^ bitselect(E, 0U, A)) + 0x8F1BBCDC + (temp = W[hook(5, (42 - 3) & 15)] ^ W[hook(5, (42 - 8) & 15)] ^ W[hook(5, (42 - 14) & 15)] ^ W[hook(5, 42 & 15)], (W[hook(5, 42 & 15)] = rotate(temp, 1U)));
    E = rotate(E, 30U);
  };
  {
    B += rotate(C, 5U) + (bitselect(D, E, A) ^ bitselect(D, 0U, E)) + 0x8F1BBCDC + (temp = W[hook(5, (43 - 3) & 15)] ^ W[hook(5, (43 - 8) & 15)] ^ W[hook(5, (43 - 14) & 15)] ^ W[hook(5, 43 & 15)], (W[hook(5, 43 & 15)] = rotate(temp, 1U)));
    D = rotate(D, 30U);
  };
  {
    A += rotate(B, 5U) + (bitselect(C, D, E) ^ bitselect(C, 0U, D)) + 0x8F1BBCDC + (temp = W[hook(5, (44 - 3) & 15)] ^ W[hook(5, (44 - 8) & 15)] ^ W[hook(5, (44 - 14) & 15)] ^ W[hook(5, 44 & 15)], (W[hook(5, 44 & 15)] = rotate(temp, 1U)));
    C = rotate(C, 30U);
  };
  {
    E += rotate(A, 5U) + (bitselect(B, C, D) ^ bitselect(B, 0U, C)) + 0x8F1BBCDC + (temp = W[hook(5, (45 - 3) & 15)] ^ W[hook(5, (45 - 8) & 15)] ^ W[hook(5, (45 - 14) & 15)] ^ W[hook(5, 45 & 15)], (W[hook(5, 45 & 15)] = rotate(temp, 1U)));
    B = rotate(B, 30U);
  };
  {
    D += rotate(E, 5U) + (bitselect(A, B, C) ^ bitselect(A, 0U, B)) + 0x8F1BBCDC + (temp = W[hook(5, (46 - 3) & 15)] ^ W[hook(5, (46 - 8) & 15)] ^ W[hook(5, (46 - 14) & 15)] ^ W[hook(5, 46 & 15)], (W[hook(5, 46 & 15)] = rotate(temp, 1U)));
    A = rotate(A, 30U);
  };
  {
    C += rotate(D, 5U) + (bitselect(E, A, B) ^ bitselect(E, 0U, A)) + 0x8F1BBCDC + (temp = W[hook(5, (47 - 3) & 15)] ^ W[hook(5, (47 - 8) & 15)] ^ W[hook(5, (47 - 14) & 15)] ^ W[hook(5, 47 & 15)], (W[hook(5, 47 & 15)] = rotate(temp, 1U)));
    E = rotate(E, 30U);
  };
  {
    B += rotate(C, 5U) + (bitselect(D, E, A) ^ bitselect(D, 0U, E)) + 0x8F1BBCDC + (temp = W[hook(5, (48 - 3) & 15)] ^ W[hook(5, (48 - 8) & 15)] ^ W[hook(5, (48 - 14) & 15)] ^ W[hook(5, 48 & 15)], (W[hook(5, 48 & 15)] = rotate(temp, 1U)));
    D = rotate(D, 30U);
  };
  {
    A += rotate(B, 5U) + (bitselect(C, D, E) ^ bitselect(C, 0U, D)) + 0x8F1BBCDC + (temp = W[hook(5, (49 - 3) & 15)] ^ W[hook(5, (49 - 8) & 15)] ^ W[hook(5, (49 - 14) & 15)] ^ W[hook(5, 49 & 15)], (W[hook(5, 49 & 15)] = rotate(temp, 1U)));
    C = rotate(C, 30U);
  };
  {
    E += rotate(A, 5U) + (bitselect(B, C, D) ^ bitselect(B, 0U, C)) + 0x8F1BBCDC + (temp = W[hook(5, (50 - 3) & 15)] ^ W[hook(5, (50 - 8) & 15)] ^ W[hook(5, (50 - 14) & 15)] ^ W[hook(5, 50 & 15)], (W[hook(5, 50 & 15)] = rotate(temp, 1U)));
    B = rotate(B, 30U);
  };
  {
    D += rotate(E, 5U) + (bitselect(A, B, C) ^ bitselect(A, 0U, B)) + 0x8F1BBCDC + (temp = W[hook(5, (51 - 3) & 15)] ^ W[hook(5, (51 - 8) & 15)] ^ W[hook(5, (51 - 14) & 15)] ^ W[hook(5, 51 & 15)], (W[hook(5, 51 & 15)] = rotate(temp, 1U)));
    A = rotate(A, 30U);
  };
  {
    C += rotate(D, 5U) + (bitselect(E, A, B) ^ bitselect(E, 0U, A)) + 0x8F1BBCDC + (temp = W[hook(5, (52 - 3) & 15)] ^ W[hook(5, (52 - 8) & 15)] ^ W[hook(5, (52 - 14) & 15)] ^ W[hook(5, 52 & 15)], (W[hook(5, 52 & 15)] = rotate(temp, 1U)));
    E = rotate(E, 30U);
  };
  {
    B += rotate(C, 5U) + (bitselect(D, E, A) ^ bitselect(D, 0U, E)) + 0x8F1BBCDC + (temp = W[hook(5, (53 - 3) & 15)] ^ W[hook(5, (53 - 8) & 15)] ^ W[hook(5, (53 - 14) & 15)] ^ W[hook(5, 53 & 15)], (W[hook(5, 53 & 15)] = rotate(temp, 1U)));
    D = rotate(D, 30U);
  };
  {
    A += rotate(B, 5U) + (bitselect(C, D, E) ^ bitselect(C, 0U, D)) + 0x8F1BBCDC + (temp = W[hook(5, (54 - 3) & 15)] ^ W[hook(5, (54 - 8) & 15)] ^ W[hook(5, (54 - 14) & 15)] ^ W[hook(5, 54 & 15)], (W[hook(5, 54 & 15)] = rotate(temp, 1U)));
    C = rotate(C, 30U);
  };
  {
    E += rotate(A, 5U) + (bitselect(B, C, D) ^ bitselect(B, 0U, C)) + 0x8F1BBCDC + (temp = W[hook(5, (55 - 3) & 15)] ^ W[hook(5, (55 - 8) & 15)] ^ W[hook(5, (55 - 14) & 15)] ^ W[hook(5, 55 & 15)], (W[hook(5, 55 & 15)] = rotate(temp, 1U)));
    B = rotate(B, 30U);
  };
  {
    D += rotate(E, 5U) + (bitselect(A, B, C) ^ bitselect(A, 0U, B)) + 0x8F1BBCDC + (temp = W[hook(5, (56 - 3) & 15)] ^ W[hook(5, (56 - 8) & 15)] ^ W[hook(5, (56 - 14) & 15)] ^ W[hook(5, 56 & 15)], (W[hook(5, 56 & 15)] = rotate(temp, 1U)));
    A = rotate(A, 30U);
  };
  {
    C += rotate(D, 5U) + (bitselect(E, A, B) ^ bitselect(E, 0U, A)) + 0x8F1BBCDC + (temp = W[hook(5, (57 - 3) & 15)] ^ W[hook(5, (57 - 8) & 15)] ^ W[hook(5, (57 - 14) & 15)] ^ W[hook(5, 57 & 15)], (W[hook(5, 57 & 15)] = rotate(temp, 1U)));
    E = rotate(E, 30U);
  };
  {
    B += rotate(C, 5U) + (bitselect(D, E, A) ^ bitselect(D, 0U, E)) + 0x8F1BBCDC + (temp = W[hook(5, (58 - 3) & 15)] ^ W[hook(5, (58 - 8) & 15)] ^ W[hook(5, (58 - 14) & 15)] ^ W[hook(5, 58 & 15)], (W[hook(5, 58 & 15)] = rotate(temp, 1U)));
    D = rotate(D, 30U);
  };
  {
    A += rotate(B, 5U) + (bitselect(C, D, E) ^ bitselect(C, 0U, D)) + 0x8F1BBCDC + (temp = W[hook(5, (59 - 3) & 15)] ^ W[hook(5, (59 - 8) & 15)] ^ W[hook(5, (59 - 14) & 15)] ^ W[hook(5, 59 & 15)], (W[hook(5, 59 & 15)] = rotate(temp, 1U)));
    C = rotate(C, 30U);
  };

  {
    E += rotate(A, 5U) + (B ^ C ^ D) + 0xCA62C1D6 + (temp = W[hook(5, (60 - 3) & 15)] ^ W[hook(5, (60 - 8) & 15)] ^ W[hook(5, (60 - 14) & 15)] ^ W[hook(5, 60 & 15)], (W[hook(5, 60 & 15)] = rotate(temp, 1U)));
    B = rotate(B, 30U);
  };
  {
    D += rotate(E, 5U) + (A ^ B ^ C) + 0xCA62C1D6 + (temp = W[hook(5, (61 - 3) & 15)] ^ W[hook(5, (61 - 8) & 15)] ^ W[hook(5, (61 - 14) & 15)] ^ W[hook(5, 61 & 15)], (W[hook(5, 61 & 15)] = rotate(temp, 1U)));
    A = rotate(A, 30U);
  };
  {
    C += rotate(D, 5U) + (E ^ A ^ B) + 0xCA62C1D6 + (temp = W[hook(5, (62 - 3) & 15)] ^ W[hook(5, (62 - 8) & 15)] ^ W[hook(5, (62 - 14) & 15)] ^ W[hook(5, 62 & 15)], (W[hook(5, 62 & 15)] = rotate(temp, 1U)));
    E = rotate(E, 30U);
  };
  {
    B += rotate(C, 5U) + (D ^ E ^ A) + 0xCA62C1D6 + (temp = W[hook(5, (63 - 3) & 15)] ^ W[hook(5, (63 - 8) & 15)] ^ W[hook(5, (63 - 14) & 15)] ^ W[hook(5, 63 & 15)], (W[hook(5, 63 & 15)] = rotate(temp, 1U)));
    D = rotate(D, 30U);
  };
  {
    A += rotate(B, 5U) + (C ^ D ^ E) + 0xCA62C1D6 + (temp = W[hook(5, (64 - 3) & 15)] ^ W[hook(5, (64 - 8) & 15)] ^ W[hook(5, (64 - 14) & 15)] ^ W[hook(5, 64 & 15)], (W[hook(5, 64 & 15)] = rotate(temp, 1U)));
    C = rotate(C, 30U);
  };
  {
    E += rotate(A, 5U) + (B ^ C ^ D) + 0xCA62C1D6 + (temp = W[hook(5, (65 - 3) & 15)] ^ W[hook(5, (65 - 8) & 15)] ^ W[hook(5, (65 - 14) & 15)] ^ W[hook(5, 65 & 15)], (W[hook(5, 65 & 15)] = rotate(temp, 1U)));
    B = rotate(B, 30U);
  };
  {
    D += rotate(E, 5U) + (A ^ B ^ C) + 0xCA62C1D6 + (temp = W[hook(5, (66 - 3) & 15)] ^ W[hook(5, (66 - 8) & 15)] ^ W[hook(5, (66 - 14) & 15)] ^ W[hook(5, 66 & 15)], (W[hook(5, 66 & 15)] = rotate(temp, 1U)));
    A = rotate(A, 30U);
  };
  {
    C += rotate(D, 5U) + (E ^ A ^ B) + 0xCA62C1D6 + (temp = W[hook(5, (67 - 3) & 15)] ^ W[hook(5, (67 - 8) & 15)] ^ W[hook(5, (67 - 14) & 15)] ^ W[hook(5, 67 & 15)], (W[hook(5, 67 & 15)] = rotate(temp, 1U)));
    E = rotate(E, 30U);
  };
  {
    B += rotate(C, 5U) + (D ^ E ^ A) + 0xCA62C1D6 + (temp = W[hook(5, (68 - 3) & 15)] ^ W[hook(5, (68 - 8) & 15)] ^ W[hook(5, (68 - 14) & 15)] ^ W[hook(5, 68 & 15)], (W[hook(5, 68 & 15)] = rotate(temp, 1U)));
    D = rotate(D, 30U);
  };
  {
    A += rotate(B, 5U) + (C ^ D ^ E) + 0xCA62C1D6 + (temp = W[hook(5, (69 - 3) & 15)] ^ W[hook(5, (69 - 8) & 15)] ^ W[hook(5, (69 - 14) & 15)] ^ W[hook(5, 69 & 15)], (W[hook(5, 69 & 15)] = rotate(temp, 1U)));
    C = rotate(C, 30U);
  };
  {
    E += rotate(A, 5U) + (B ^ C ^ D) + 0xCA62C1D6 + (temp = W[hook(5, (70 - 3) & 15)] ^ W[hook(5, (70 - 8) & 15)] ^ W[hook(5, (70 - 14) & 15)] ^ W[hook(5, 70 & 15)], (W[hook(5, 70 & 15)] = rotate(temp, 1U)));
    B = rotate(B, 30U);
  };
  {
    D += rotate(E, 5U) + (A ^ B ^ C) + 0xCA62C1D6 + (temp = W[hook(5, (71 - 3) & 15)] ^ W[hook(5, (71 - 8) & 15)] ^ W[hook(5, (71 - 14) & 15)] ^ W[hook(5, 71 & 15)], (W[hook(5, 71 & 15)] = rotate(temp, 1U)));
    A = rotate(A, 30U);
  };
  {
    C += rotate(D, 5U) + (E ^ A ^ B) + 0xCA62C1D6 + (temp = W[hook(5, (72 - 3) & 15)] ^ W[hook(5, (72 - 8) & 15)] ^ W[hook(5, (72 - 14) & 15)] ^ W[hook(5, 72 & 15)], (W[hook(5, 72 & 15)] = rotate(temp, 1U)));
    E = rotate(E, 30U);
  };
  {
    B += rotate(C, 5U) + (D ^ E ^ A) + 0xCA62C1D6 + (temp = W[hook(5, (73 - 3) & 15)] ^ W[hook(5, (73 - 8) & 15)] ^ W[hook(5, (73 - 14) & 15)] ^ W[hook(5, 73 & 15)], (W[hook(5, 73 & 15)] = rotate(temp, 1U)));
    D = rotate(D, 30U);
  };
  {
    A += rotate(B, 5U) + (C ^ D ^ E) + 0xCA62C1D6 + (temp = W[hook(5, (74 - 3) & 15)] ^ W[hook(5, (74 - 8) & 15)] ^ W[hook(5, (74 - 14) & 15)] ^ W[hook(5, 74 & 15)], (W[hook(5, 74 & 15)] = rotate(temp, 1U)));
    C = rotate(C, 30U);
  };
  {
    E += rotate(A, 5U) + (B ^ C ^ D) + 0xCA62C1D6 + (temp = W[hook(5, (75 - 3) & 15)] ^ W[hook(5, (75 - 8) & 15)] ^ W[hook(5, (75 - 14) & 15)] ^ W[hook(5, 75 & 15)], (W[hook(5, 75 & 15)] = rotate(temp, 1U)));
    B = rotate(B, 30U);
  };
  {
    D += rotate(E, 5U) + (A ^ B ^ C) + 0xCA62C1D6 + (temp = W[hook(5, (76 - 3) & 15)] ^ W[hook(5, (76 - 8) & 15)] ^ W[hook(5, (76 - 14) & 15)] ^ W[hook(5, 76 & 15)], (W[hook(5, 76 & 15)] = rotate(temp, 1U)));
    A = rotate(A, 30U);
  };
  {
    C += rotate(D, 5U) + (E ^ A ^ B) + 0xCA62C1D6 + (temp = W[hook(5, (77 - 3) & 15)] ^ W[hook(5, (77 - 8) & 15)] ^ W[hook(5, (77 - 14) & 15)] ^ W[hook(5, 77 & 15)], (W[hook(5, 77 & 15)] = rotate(temp, 1U)));
    E = rotate(E, 30U);
  };
  {
    B += rotate(C, 5U) + (D ^ E ^ A) + 0xCA62C1D6 + (temp = W[hook(5, (78 - 3) & 15)] ^ W[hook(5, (78 - 8) & 15)] ^ W[hook(5, (78 - 14) & 15)] ^ W[hook(5, 78 & 15)], (W[hook(5, 78 & 15)] = rotate(temp, 1U)));
    D = rotate(D, 30U);
  };
  {
    A += rotate(B, 5U) + (C ^ D ^ E) + 0xCA62C1D6 + (temp = W[hook(5, (79 - 3) & 15)] ^ W[hook(5, (79 - 8) & 15)] ^ W[hook(5, (79 - 14) & 15)] ^ W[hook(5, 79 & 15)], (W[hook(5, 79 & 15)] = rotate(temp, 1U)));
    C = rotate(C, 30U);
  };

  output[hook(3, 0)] += A;
  output[hook(3, 1)] += B;
  output[hook(3, 2)] += C;
  output[hook(3, 3)] += D;
  output[hook(3, 4)] += E;
}
inline void sha1_final(unsigned int* W, unsigned int* output, const unsigned int tot_len) {
  unsigned int len = ((tot_len & 63) >> 2) + 1;

  (W)[hook(7, (tot_len & 63) >> 2)] = ((W)[hook(7, (tot_len & 63) >> 2)] & (0xffffff00U << ((((tot_len & 63) & 3) ^ 3) << 3))) + ((0x80) << ((((tot_len & 63) & 3) ^ 3) << 3));

  while (len < 15)
    W[hook(5, len++)] = 0;
  W[hook(5, 15)] = tot_len << 3;
  sha1_block(W, output);
}

kernel void RarFinal(const global unsigned int* pw_len, global unsigned int* OutputBuf, global unsigned int* aes_key) {
  unsigned int gid = get_global_id(0);
  unsigned int gws = get_global_size(0);
  unsigned int block[16], output[5];
  unsigned int i;

  for (i = 0; i < 5; i++)
    output[hook(3, i)] = OutputBuf[hook(1, i * gws + gid)];

  sha1_final(block, output, (pw_len[hook(0, gid)] + 8 + 3) * 0x40000);

  for (i = 0; i < 4; i++)
    aes_key[hook(2, gid * 4 + i)] = output[hook(3, i)];
}