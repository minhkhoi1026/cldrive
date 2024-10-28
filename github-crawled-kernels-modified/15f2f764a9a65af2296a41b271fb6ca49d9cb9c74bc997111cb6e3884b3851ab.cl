//{"((const __private unsigned int *)special_words)":10,"H":12,"TO_HEX":8,"W":9,"chunk":11,"message_size":1,"offset":4,"precision_bits":3,"preprocessed_message":0,"result":6,"special_words":7,"start":5,"target":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sha1_prefix_search(global const uchar* preprocessed_message, const unsigned int message_size, global const unsigned int* target, const unsigned int precision_bits, const unsigned int offset, const ulong start, global ulong* result) {
  unsigned int t;
  unsigned int W[16], temp, A, B, C, D, E;
  unsigned int counter_words;

  const unsigned int gid = get_global_id(0);

  unsigned int H[5] = {0x67452301, 0xEFCDAB89, 0x98BADCFE, 0x10325476, 0xC3D2E1F0};

  const uchar TO_HEX[16] = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'};

  global const unsigned int* chunk = (global const unsigned int*)preprocessed_message;
  global const unsigned int* stop = chunk + (message_size >> 2);
  global const unsigned int* offset_area_start = chunk + (offset >> 2);

  const ulong current = start + gid;

  uchar special_words[20];
  for (t = 0; t < 20; t++) {
    if ((t < (offset & 0x3)) || (t >= ((offset & 0x3) + 16))) {
      special_words[hook(7, t)] = preprocessed_message[hook(0, (offset & (4294967295U << 2)) + t)];
    } else {
      special_words[hook(7, t)] = TO_HEX[hook(8, (current >> (60 - ((t - (offset & 3)) << 2))) & 15)];
    }
  }

  for (chunk = chunk; chunk < stop; chunk += 16) {
    for (t = 0; t < 16; t++) {
      if ((offset_area_start <= (chunk + t)) && ((chunk + t) - offset_area_start <= 4)) {
        W[hook(9, t)] = ((const unsigned int*)special_words)[hook(10, (chunk + t) - offset_area_start)];
      } else {
        W[hook(9, t)] = chunk[hook(11, t)];
      }
      W[hook(9, t)] = (rotate(W[hook(9, t)] & 0x00FF00FF, 24U) | (rotate(W[hook(9, t)], 8U) & 0x00FF00FF));
    }

    A = H[hook(12, 0)];
    B = H[hook(12, 1)];
    C = H[hook(12, 2)];
    D = H[hook(12, 3)];
    E = H[hook(12, 4)];
    {
      E += rotate((int)A, 5) + bitselect(D, C, B) + 0x5A827999 + W[hook(9, 0)];
      B = rotate((int)B, 30);
    };
    {
      D += rotate((int)E, 5) + bitselect(C, B, A) + 0x5A827999 + W[hook(9, 1)];
      A = rotate((int)A, 30);
    };
    {
      C += rotate((int)D, 5) + bitselect(B, A, E) + 0x5A827999 + W[hook(9, 2)];
      E = rotate((int)E, 30);
    };
    {
      B += rotate((int)C, 5) + bitselect(A, E, D) + 0x5A827999 + W[hook(9, 3)];
      D = rotate((int)D, 30);
    };
    {
      A += rotate((int)B, 5) + bitselect(E, D, C) + 0x5A827999 + W[hook(9, 4)];
      C = rotate((int)C, 30);
    };
    {
      E += rotate((int)A, 5) + bitselect(D, C, B) + 0x5A827999 + W[hook(9, 5)];
      B = rotate((int)B, 30);
    };
    {
      D += rotate((int)E, 5) + bitselect(C, B, A) + 0x5A827999 + W[hook(9, 6)];
      A = rotate((int)A, 30);
    };
    {
      C += rotate((int)D, 5) + bitselect(B, A, E) + 0x5A827999 + W[hook(9, 7)];
      E = rotate((int)E, 30);
    };
    {
      B += rotate((int)C, 5) + bitselect(A, E, D) + 0x5A827999 + W[hook(9, 8)];
      D = rotate((int)D, 30);
    };
    {
      A += rotate((int)B, 5) + bitselect(E, D, C) + 0x5A827999 + W[hook(9, 9)];
      C = rotate((int)C, 30);
    };
    {
      E += rotate((int)A, 5) + bitselect(D, C, B) + 0x5A827999 + W[hook(9, 10)];
      B = rotate((int)B, 30);
    };
    {
      D += rotate((int)E, 5) + bitselect(C, B, A) + 0x5A827999 + W[hook(9, 11)];
      A = rotate((int)A, 30);
    };
    {
      C += rotate((int)D, 5) + bitselect(B, A, E) + 0x5A827999 + W[hook(9, 12)];
      E = rotate((int)E, 30);
    };
    {
      B += rotate((int)C, 5) + bitselect(A, E, D) + 0x5A827999 + W[hook(9, 13)];
      D = rotate((int)D, 30);
    };
    {
      A += rotate((int)B, 5) + bitselect(E, D, C) + 0x5A827999 + W[hook(9, 14)];
      C = rotate((int)C, 30);
    };
    {
      E += rotate((int)A, 5) + bitselect(D, C, B) + 0x5A827999 + W[hook(9, 15)];
      B = rotate((int)B, 30);
    };
    {
      D += rotate((int)E, 5) + bitselect(C, B, A) + 0x5A827999 + (temp = W[hook(9, (16 - 3) & 15)] ^ W[hook(9, (16 - 8) & 15)] ^ W[hook(9, (16 - 14) & 15)] ^ W[hook(9, 16 & 15)], (W[hook(9, 16 & 15)] = rotate((int)temp, 1)));
      A = rotate((int)A, 30);
    };
    {
      C += rotate((int)D, 5) + bitselect(B, A, E) + 0x5A827999 + (temp = W[hook(9, (17 - 3) & 15)] ^ W[hook(9, (17 - 8) & 15)] ^ W[hook(9, (17 - 14) & 15)] ^ W[hook(9, 17 & 15)], (W[hook(9, 17 & 15)] = rotate((int)temp, 1)));
      E = rotate((int)E, 30);
    };
    {
      B += rotate((int)C, 5) + bitselect(A, E, D) + 0x5A827999 + (temp = W[hook(9, (18 - 3) & 15)] ^ W[hook(9, (18 - 8) & 15)] ^ W[hook(9, (18 - 14) & 15)] ^ W[hook(9, 18 & 15)], (W[hook(9, 18 & 15)] = rotate((int)temp, 1)));
      D = rotate((int)D, 30);
    };
    {
      A += rotate((int)B, 5) + bitselect(E, D, C) + 0x5A827999 + (temp = W[hook(9, (19 - 3) & 15)] ^ W[hook(9, (19 - 8) & 15)] ^ W[hook(9, (19 - 14) & 15)] ^ W[hook(9, 19 & 15)], (W[hook(9, 19 & 15)] = rotate((int)temp, 1)));
      C = rotate((int)C, 30);
    };

    {
      E += rotate((int)A, 5) + (B ^ C ^ D) + 0x6ED9EBA1 + (temp = W[hook(9, (20 - 3) & 15)] ^ W[hook(9, (20 - 8) & 15)] ^ W[hook(9, (20 - 14) & 15)] ^ W[hook(9, 20 & 15)], (W[hook(9, 20 & 15)] = rotate((int)temp, 1)));
      B = rotate((int)B, 30);
    };
    {
      D += rotate((int)E, 5) + (A ^ B ^ C) + 0x6ED9EBA1 + (temp = W[hook(9, (21 - 3) & 15)] ^ W[hook(9, (21 - 8) & 15)] ^ W[hook(9, (21 - 14) & 15)] ^ W[hook(9, 21 & 15)], (W[hook(9, 21 & 15)] = rotate((int)temp, 1)));
      A = rotate((int)A, 30);
    };
    {
      C += rotate((int)D, 5) + (E ^ A ^ B) + 0x6ED9EBA1 + (temp = W[hook(9, (22 - 3) & 15)] ^ W[hook(9, (22 - 8) & 15)] ^ W[hook(9, (22 - 14) & 15)] ^ W[hook(9, 22 & 15)], (W[hook(9, 22 & 15)] = rotate((int)temp, 1)));
      E = rotate((int)E, 30);
    };
    {
      B += rotate((int)C, 5) + (D ^ E ^ A) + 0x6ED9EBA1 + (temp = W[hook(9, (23 - 3) & 15)] ^ W[hook(9, (23 - 8) & 15)] ^ W[hook(9, (23 - 14) & 15)] ^ W[hook(9, 23 & 15)], (W[hook(9, 23 & 15)] = rotate((int)temp, 1)));
      D = rotate((int)D, 30);
    };
    {
      A += rotate((int)B, 5) + (C ^ D ^ E) + 0x6ED9EBA1 + (temp = W[hook(9, (24 - 3) & 15)] ^ W[hook(9, (24 - 8) & 15)] ^ W[hook(9, (24 - 14) & 15)] ^ W[hook(9, 24 & 15)], (W[hook(9, 24 & 15)] = rotate((int)temp, 1)));
      C = rotate((int)C, 30);
    };
    {
      E += rotate((int)A, 5) + (B ^ C ^ D) + 0x6ED9EBA1 + (temp = W[hook(9, (25 - 3) & 15)] ^ W[hook(9, (25 - 8) & 15)] ^ W[hook(9, (25 - 14) & 15)] ^ W[hook(9, 25 & 15)], (W[hook(9, 25 & 15)] = rotate((int)temp, 1)));
      B = rotate((int)B, 30);
    };
    {
      D += rotate((int)E, 5) + (A ^ B ^ C) + 0x6ED9EBA1 + (temp = W[hook(9, (26 - 3) & 15)] ^ W[hook(9, (26 - 8) & 15)] ^ W[hook(9, (26 - 14) & 15)] ^ W[hook(9, 26 & 15)], (W[hook(9, 26 & 15)] = rotate((int)temp, 1)));
      A = rotate((int)A, 30);
    };
    {
      C += rotate((int)D, 5) + (E ^ A ^ B) + 0x6ED9EBA1 + (temp = W[hook(9, (27 - 3) & 15)] ^ W[hook(9, (27 - 8) & 15)] ^ W[hook(9, (27 - 14) & 15)] ^ W[hook(9, 27 & 15)], (W[hook(9, 27 & 15)] = rotate((int)temp, 1)));
      E = rotate((int)E, 30);
    };
    {
      B += rotate((int)C, 5) + (D ^ E ^ A) + 0x6ED9EBA1 + (temp = W[hook(9, (28 - 3) & 15)] ^ W[hook(9, (28 - 8) & 15)] ^ W[hook(9, (28 - 14) & 15)] ^ W[hook(9, 28 & 15)], (W[hook(9, 28 & 15)] = rotate((int)temp, 1)));
      D = rotate((int)D, 30);
    };
    {
      A += rotate((int)B, 5) + (C ^ D ^ E) + 0x6ED9EBA1 + (temp = W[hook(9, (29 - 3) & 15)] ^ W[hook(9, (29 - 8) & 15)] ^ W[hook(9, (29 - 14) & 15)] ^ W[hook(9, 29 & 15)], (W[hook(9, 29 & 15)] = rotate((int)temp, 1)));
      C = rotate((int)C, 30);
    };
    {
      E += rotate((int)A, 5) + (B ^ C ^ D) + 0x6ED9EBA1 + (temp = W[hook(9, (30 - 3) & 15)] ^ W[hook(9, (30 - 8) & 15)] ^ W[hook(9, (30 - 14) & 15)] ^ W[hook(9, 30 & 15)], (W[hook(9, 30 & 15)] = rotate((int)temp, 1)));
      B = rotate((int)B, 30);
    };
    {
      D += rotate((int)E, 5) + (A ^ B ^ C) + 0x6ED9EBA1 + (temp = W[hook(9, (31 - 3) & 15)] ^ W[hook(9, (31 - 8) & 15)] ^ W[hook(9, (31 - 14) & 15)] ^ W[hook(9, 31 & 15)], (W[hook(9, 31 & 15)] = rotate((int)temp, 1)));
      A = rotate((int)A, 30);
    };
    {
      C += rotate((int)D, 5) + (E ^ A ^ B) + 0x6ED9EBA1 + (temp = W[hook(9, (32 - 3) & 15)] ^ W[hook(9, (32 - 8) & 15)] ^ W[hook(9, (32 - 14) & 15)] ^ W[hook(9, 32 & 15)], (W[hook(9, 32 & 15)] = rotate((int)temp, 1)));
      E = rotate((int)E, 30);
    };
    {
      B += rotate((int)C, 5) + (D ^ E ^ A) + 0x6ED9EBA1 + (temp = W[hook(9, (33 - 3) & 15)] ^ W[hook(9, (33 - 8) & 15)] ^ W[hook(9, (33 - 14) & 15)] ^ W[hook(9, 33 & 15)], (W[hook(9, 33 & 15)] = rotate((int)temp, 1)));
      D = rotate((int)D, 30);
    };
    {
      A += rotate((int)B, 5) + (C ^ D ^ E) + 0x6ED9EBA1 + (temp = W[hook(9, (34 - 3) & 15)] ^ W[hook(9, (34 - 8) & 15)] ^ W[hook(9, (34 - 14) & 15)] ^ W[hook(9, 34 & 15)], (W[hook(9, 34 & 15)] = rotate((int)temp, 1)));
      C = rotate((int)C, 30);
    };
    {
      E += rotate((int)A, 5) + (B ^ C ^ D) + 0x6ED9EBA1 + (temp = W[hook(9, (35 - 3) & 15)] ^ W[hook(9, (35 - 8) & 15)] ^ W[hook(9, (35 - 14) & 15)] ^ W[hook(9, 35 & 15)], (W[hook(9, 35 & 15)] = rotate((int)temp, 1)));
      B = rotate((int)B, 30);
    };
    {
      D += rotate((int)E, 5) + (A ^ B ^ C) + 0x6ED9EBA1 + (temp = W[hook(9, (36 - 3) & 15)] ^ W[hook(9, (36 - 8) & 15)] ^ W[hook(9, (36 - 14) & 15)] ^ W[hook(9, 36 & 15)], (W[hook(9, 36 & 15)] = rotate((int)temp, 1)));
      A = rotate((int)A, 30);
    };
    {
      C += rotate((int)D, 5) + (E ^ A ^ B) + 0x6ED9EBA1 + (temp = W[hook(9, (37 - 3) & 15)] ^ W[hook(9, (37 - 8) & 15)] ^ W[hook(9, (37 - 14) & 15)] ^ W[hook(9, 37 & 15)], (W[hook(9, 37 & 15)] = rotate((int)temp, 1)));
      E = rotate((int)E, 30);
    };
    {
      B += rotate((int)C, 5) + (D ^ E ^ A) + 0x6ED9EBA1 + (temp = W[hook(9, (38 - 3) & 15)] ^ W[hook(9, (38 - 8) & 15)] ^ W[hook(9, (38 - 14) & 15)] ^ W[hook(9, 38 & 15)], (W[hook(9, 38 & 15)] = rotate((int)temp, 1)));
      D = rotate((int)D, 30);
    };
    {
      A += rotate((int)B, 5) + (C ^ D ^ E) + 0x6ED9EBA1 + (temp = W[hook(9, (39 - 3) & 15)] ^ W[hook(9, (39 - 8) & 15)] ^ W[hook(9, (39 - 14) & 15)] ^ W[hook(9, 39 & 15)], (W[hook(9, 39 & 15)] = rotate((int)temp, 1)));
      C = rotate((int)C, 30);
    };
    {
      E += rotate((int)A, 5) + (bitselect(B, C, D) ^ bitselect(B, 0U, C)) + 0x8F1BBCDC + (temp = W[hook(9, (40 - 3) & 15)] ^ W[hook(9, (40 - 8) & 15)] ^ W[hook(9, (40 - 14) & 15)] ^ W[hook(9, 40 & 15)], (W[hook(9, 40 & 15)] = rotate((int)temp, 1)));
      B = rotate((int)B, 30);
    };
    {
      D += rotate((int)E, 5) + (bitselect(A, B, C) ^ bitselect(A, 0U, B)) + 0x8F1BBCDC + (temp = W[hook(9, (41 - 3) & 15)] ^ W[hook(9, (41 - 8) & 15)] ^ W[hook(9, (41 - 14) & 15)] ^ W[hook(9, 41 & 15)], (W[hook(9, 41 & 15)] = rotate((int)temp, 1)));
      A = rotate((int)A, 30);
    };
    {
      C += rotate((int)D, 5) + (bitselect(E, A, B) ^ bitselect(E, 0U, A)) + 0x8F1BBCDC + (temp = W[hook(9, (42 - 3) & 15)] ^ W[hook(9, (42 - 8) & 15)] ^ W[hook(9, (42 - 14) & 15)] ^ W[hook(9, 42 & 15)], (W[hook(9, 42 & 15)] = rotate((int)temp, 1)));
      E = rotate((int)E, 30);
    };
    {
      B += rotate((int)C, 5) + (bitselect(D, E, A) ^ bitselect(D, 0U, E)) + 0x8F1BBCDC + (temp = W[hook(9, (43 - 3) & 15)] ^ W[hook(9, (43 - 8) & 15)] ^ W[hook(9, (43 - 14) & 15)] ^ W[hook(9, 43 & 15)], (W[hook(9, 43 & 15)] = rotate((int)temp, 1)));
      D = rotate((int)D, 30);
    };
    {
      A += rotate((int)B, 5) + (bitselect(C, D, E) ^ bitselect(C, 0U, D)) + 0x8F1BBCDC + (temp = W[hook(9, (44 - 3) & 15)] ^ W[hook(9, (44 - 8) & 15)] ^ W[hook(9, (44 - 14) & 15)] ^ W[hook(9, 44 & 15)], (W[hook(9, 44 & 15)] = rotate((int)temp, 1)));
      C = rotate((int)C, 30);
    };
    {
      E += rotate((int)A, 5) + (bitselect(B, C, D) ^ bitselect(B, 0U, C)) + 0x8F1BBCDC + (temp = W[hook(9, (45 - 3) & 15)] ^ W[hook(9, (45 - 8) & 15)] ^ W[hook(9, (45 - 14) & 15)] ^ W[hook(9, 45 & 15)], (W[hook(9, 45 & 15)] = rotate((int)temp, 1)));
      B = rotate((int)B, 30);
    };
    {
      D += rotate((int)E, 5) + (bitselect(A, B, C) ^ bitselect(A, 0U, B)) + 0x8F1BBCDC + (temp = W[hook(9, (46 - 3) & 15)] ^ W[hook(9, (46 - 8) & 15)] ^ W[hook(9, (46 - 14) & 15)] ^ W[hook(9, 46 & 15)], (W[hook(9, 46 & 15)] = rotate((int)temp, 1)));
      A = rotate((int)A, 30);
    };
    {
      C += rotate((int)D, 5) + (bitselect(E, A, B) ^ bitselect(E, 0U, A)) + 0x8F1BBCDC + (temp = W[hook(9, (47 - 3) & 15)] ^ W[hook(9, (47 - 8) & 15)] ^ W[hook(9, (47 - 14) & 15)] ^ W[hook(9, 47 & 15)], (W[hook(9, 47 & 15)] = rotate((int)temp, 1)));
      E = rotate((int)E, 30);
    };
    {
      B += rotate((int)C, 5) + (bitselect(D, E, A) ^ bitselect(D, 0U, E)) + 0x8F1BBCDC + (temp = W[hook(9, (48 - 3) & 15)] ^ W[hook(9, (48 - 8) & 15)] ^ W[hook(9, (48 - 14) & 15)] ^ W[hook(9, 48 & 15)], (W[hook(9, 48 & 15)] = rotate((int)temp, 1)));
      D = rotate((int)D, 30);
    };
    {
      A += rotate((int)B, 5) + (bitselect(C, D, E) ^ bitselect(C, 0U, D)) + 0x8F1BBCDC + (temp = W[hook(9, (49 - 3) & 15)] ^ W[hook(9, (49 - 8) & 15)] ^ W[hook(9, (49 - 14) & 15)] ^ W[hook(9, 49 & 15)], (W[hook(9, 49 & 15)] = rotate((int)temp, 1)));
      C = rotate((int)C, 30);
    };
    {
      E += rotate((int)A, 5) + (bitselect(B, C, D) ^ bitselect(B, 0U, C)) + 0x8F1BBCDC + (temp = W[hook(9, (50 - 3) & 15)] ^ W[hook(9, (50 - 8) & 15)] ^ W[hook(9, (50 - 14) & 15)] ^ W[hook(9, 50 & 15)], (W[hook(9, 50 & 15)] = rotate((int)temp, 1)));
      B = rotate((int)B, 30);
    };
    {
      D += rotate((int)E, 5) + (bitselect(A, B, C) ^ bitselect(A, 0U, B)) + 0x8F1BBCDC + (temp = W[hook(9, (51 - 3) & 15)] ^ W[hook(9, (51 - 8) & 15)] ^ W[hook(9, (51 - 14) & 15)] ^ W[hook(9, 51 & 15)], (W[hook(9, 51 & 15)] = rotate((int)temp, 1)));
      A = rotate((int)A, 30);
    };
    {
      C += rotate((int)D, 5) + (bitselect(E, A, B) ^ bitselect(E, 0U, A)) + 0x8F1BBCDC + (temp = W[hook(9, (52 - 3) & 15)] ^ W[hook(9, (52 - 8) & 15)] ^ W[hook(9, (52 - 14) & 15)] ^ W[hook(9, 52 & 15)], (W[hook(9, 52 & 15)] = rotate((int)temp, 1)));
      E = rotate((int)E, 30);
    };
    {
      B += rotate((int)C, 5) + (bitselect(D, E, A) ^ bitselect(D, 0U, E)) + 0x8F1BBCDC + (temp = W[hook(9, (53 - 3) & 15)] ^ W[hook(9, (53 - 8) & 15)] ^ W[hook(9, (53 - 14) & 15)] ^ W[hook(9, 53 & 15)], (W[hook(9, 53 & 15)] = rotate((int)temp, 1)));
      D = rotate((int)D, 30);
    };
    {
      A += rotate((int)B, 5) + (bitselect(C, D, E) ^ bitselect(C, 0U, D)) + 0x8F1BBCDC + (temp = W[hook(9, (54 - 3) & 15)] ^ W[hook(9, (54 - 8) & 15)] ^ W[hook(9, (54 - 14) & 15)] ^ W[hook(9, 54 & 15)], (W[hook(9, 54 & 15)] = rotate((int)temp, 1)));
      C = rotate((int)C, 30);
    };
    {
      E += rotate((int)A, 5) + (bitselect(B, C, D) ^ bitselect(B, 0U, C)) + 0x8F1BBCDC + (temp = W[hook(9, (55 - 3) & 15)] ^ W[hook(9, (55 - 8) & 15)] ^ W[hook(9, (55 - 14) & 15)] ^ W[hook(9, 55 & 15)], (W[hook(9, 55 & 15)] = rotate((int)temp, 1)));
      B = rotate((int)B, 30);
    };
    {
      D += rotate((int)E, 5) + (bitselect(A, B, C) ^ bitselect(A, 0U, B)) + 0x8F1BBCDC + (temp = W[hook(9, (56 - 3) & 15)] ^ W[hook(9, (56 - 8) & 15)] ^ W[hook(9, (56 - 14) & 15)] ^ W[hook(9, 56 & 15)], (W[hook(9, 56 & 15)] = rotate((int)temp, 1)));
      A = rotate((int)A, 30);
    };
    {
      C += rotate((int)D, 5) + (bitselect(E, A, B) ^ bitselect(E, 0U, A)) + 0x8F1BBCDC + (temp = W[hook(9, (57 - 3) & 15)] ^ W[hook(9, (57 - 8) & 15)] ^ W[hook(9, (57 - 14) & 15)] ^ W[hook(9, 57 & 15)], (W[hook(9, 57 & 15)] = rotate((int)temp, 1)));
      E = rotate((int)E, 30);
    };
    {
      B += rotate((int)C, 5) + (bitselect(D, E, A) ^ bitselect(D, 0U, E)) + 0x8F1BBCDC + (temp = W[hook(9, (58 - 3) & 15)] ^ W[hook(9, (58 - 8) & 15)] ^ W[hook(9, (58 - 14) & 15)] ^ W[hook(9, 58 & 15)], (W[hook(9, 58 & 15)] = rotate((int)temp, 1)));
      D = rotate((int)D, 30);
    };
    {
      A += rotate((int)B, 5) + (bitselect(C, D, E) ^ bitselect(C, 0U, D)) + 0x8F1BBCDC + (temp = W[hook(9, (59 - 3) & 15)] ^ W[hook(9, (59 - 8) & 15)] ^ W[hook(9, (59 - 14) & 15)] ^ W[hook(9, 59 & 15)], (W[hook(9, 59 & 15)] = rotate((int)temp, 1)));
      C = rotate((int)C, 30);
    };

    {
      E += rotate((int)A, 5) + (B ^ C ^ D) + 0xCA62C1D6 + (temp = W[hook(9, (60 - 3) & 15)] ^ W[hook(9, (60 - 8) & 15)] ^ W[hook(9, (60 - 14) & 15)] ^ W[hook(9, 60 & 15)], (W[hook(9, 60 & 15)] = rotate((int)temp, 1)));
      B = rotate((int)B, 30);
    };
    {
      D += rotate((int)E, 5) + (A ^ B ^ C) + 0xCA62C1D6 + (temp = W[hook(9, (61 - 3) & 15)] ^ W[hook(9, (61 - 8) & 15)] ^ W[hook(9, (61 - 14) & 15)] ^ W[hook(9, 61 & 15)], (W[hook(9, 61 & 15)] = rotate((int)temp, 1)));
      A = rotate((int)A, 30);
    };
    {
      C += rotate((int)D, 5) + (E ^ A ^ B) + 0xCA62C1D6 + (temp = W[hook(9, (62 - 3) & 15)] ^ W[hook(9, (62 - 8) & 15)] ^ W[hook(9, (62 - 14) & 15)] ^ W[hook(9, 62 & 15)], (W[hook(9, 62 & 15)] = rotate((int)temp, 1)));
      E = rotate((int)E, 30);
    };
    {
      B += rotate((int)C, 5) + (D ^ E ^ A) + 0xCA62C1D6 + (temp = W[hook(9, (63 - 3) & 15)] ^ W[hook(9, (63 - 8) & 15)] ^ W[hook(9, (63 - 14) & 15)] ^ W[hook(9, 63 & 15)], (W[hook(9, 63 & 15)] = rotate((int)temp, 1)));
      D = rotate((int)D, 30);
    };
    {
      A += rotate((int)B, 5) + (C ^ D ^ E) + 0xCA62C1D6 + (temp = W[hook(9, (64 - 3) & 15)] ^ W[hook(9, (64 - 8) & 15)] ^ W[hook(9, (64 - 14) & 15)] ^ W[hook(9, 64 & 15)], (W[hook(9, 64 & 15)] = rotate((int)temp, 1)));
      C = rotate((int)C, 30);
    };
    {
      E += rotate((int)A, 5) + (B ^ C ^ D) + 0xCA62C1D6 + (temp = W[hook(9, (65 - 3) & 15)] ^ W[hook(9, (65 - 8) & 15)] ^ W[hook(9, (65 - 14) & 15)] ^ W[hook(9, 65 & 15)], (W[hook(9, 65 & 15)] = rotate((int)temp, 1)));
      B = rotate((int)B, 30);
    };
    {
      D += rotate((int)E, 5) + (A ^ B ^ C) + 0xCA62C1D6 + (temp = W[hook(9, (66 - 3) & 15)] ^ W[hook(9, (66 - 8) & 15)] ^ W[hook(9, (66 - 14) & 15)] ^ W[hook(9, 66 & 15)], (W[hook(9, 66 & 15)] = rotate((int)temp, 1)));
      A = rotate((int)A, 30);
    };
    {
      C += rotate((int)D, 5) + (E ^ A ^ B) + 0xCA62C1D6 + (temp = W[hook(9, (67 - 3) & 15)] ^ W[hook(9, (67 - 8) & 15)] ^ W[hook(9, (67 - 14) & 15)] ^ W[hook(9, 67 & 15)], (W[hook(9, 67 & 15)] = rotate((int)temp, 1)));
      E = rotate((int)E, 30);
    };
    {
      B += rotate((int)C, 5) + (D ^ E ^ A) + 0xCA62C1D6 + (temp = W[hook(9, (68 - 3) & 15)] ^ W[hook(9, (68 - 8) & 15)] ^ W[hook(9, (68 - 14) & 15)] ^ W[hook(9, 68 & 15)], (W[hook(9, 68 & 15)] = rotate((int)temp, 1)));
      D = rotate((int)D, 30);
    };
    {
      A += rotate((int)B, 5) + (C ^ D ^ E) + 0xCA62C1D6 + (temp = W[hook(9, (69 - 3) & 15)] ^ W[hook(9, (69 - 8) & 15)] ^ W[hook(9, (69 - 14) & 15)] ^ W[hook(9, 69 & 15)], (W[hook(9, 69 & 15)] = rotate((int)temp, 1)));
      C = rotate((int)C, 30);
    };
    {
      E += rotate((int)A, 5) + (B ^ C ^ D) + 0xCA62C1D6 + (temp = W[hook(9, (70 - 3) & 15)] ^ W[hook(9, (70 - 8) & 15)] ^ W[hook(9, (70 - 14) & 15)] ^ W[hook(9, 70 & 15)], (W[hook(9, 70 & 15)] = rotate((int)temp, 1)));
      B = rotate((int)B, 30);
    };
    {
      D += rotate((int)E, 5) + (A ^ B ^ C) + 0xCA62C1D6 + (temp = W[hook(9, (71 - 3) & 15)] ^ W[hook(9, (71 - 8) & 15)] ^ W[hook(9, (71 - 14) & 15)] ^ W[hook(9, 71 & 15)], (W[hook(9, 71 & 15)] = rotate((int)temp, 1)));
      A = rotate((int)A, 30);
    };
    {
      C += rotate((int)D, 5) + (E ^ A ^ B) + 0xCA62C1D6 + (temp = W[hook(9, (72 - 3) & 15)] ^ W[hook(9, (72 - 8) & 15)] ^ W[hook(9, (72 - 14) & 15)] ^ W[hook(9, 72 & 15)], (W[hook(9, 72 & 15)] = rotate((int)temp, 1)));
      E = rotate((int)E, 30);
    };
    {
      B += rotate((int)C, 5) + (D ^ E ^ A) + 0xCA62C1D6 + (temp = W[hook(9, (73 - 3) & 15)] ^ W[hook(9, (73 - 8) & 15)] ^ W[hook(9, (73 - 14) & 15)] ^ W[hook(9, 73 & 15)], (W[hook(9, 73 & 15)] = rotate((int)temp, 1)));
      D = rotate((int)D, 30);
    };
    {
      A += rotate((int)B, 5) + (C ^ D ^ E) + 0xCA62C1D6 + (temp = W[hook(9, (74 - 3) & 15)] ^ W[hook(9, (74 - 8) & 15)] ^ W[hook(9, (74 - 14) & 15)] ^ W[hook(9, 74 & 15)], (W[hook(9, 74 & 15)] = rotate((int)temp, 1)));
      C = rotate((int)C, 30);
    };
    {
      E += rotate((int)A, 5) + (B ^ C ^ D) + 0xCA62C1D6 + (temp = W[hook(9, (75 - 3) & 15)] ^ W[hook(9, (75 - 8) & 15)] ^ W[hook(9, (75 - 14) & 15)] ^ W[hook(9, 75 & 15)], (W[hook(9, 75 & 15)] = rotate((int)temp, 1)));
      B = rotate((int)B, 30);
    };
    {
      D += rotate((int)E, 5) + (A ^ B ^ C) + 0xCA62C1D6 + (temp = W[hook(9, (76 - 3) & 15)] ^ W[hook(9, (76 - 8) & 15)] ^ W[hook(9, (76 - 14) & 15)] ^ W[hook(9, 76 & 15)], (W[hook(9, 76 & 15)] = rotate((int)temp, 1)));
      A = rotate((int)A, 30);
    };
    {
      C += rotate((int)D, 5) + (E ^ A ^ B) + 0xCA62C1D6 + (temp = W[hook(9, (77 - 3) & 15)] ^ W[hook(9, (77 - 8) & 15)] ^ W[hook(9, (77 - 14) & 15)] ^ W[hook(9, 77 & 15)], (W[hook(9, 77 & 15)] = rotate((int)temp, 1)));
      E = rotate((int)E, 30);
    };
    {
      B += rotate((int)C, 5) + (D ^ E ^ A) + 0xCA62C1D6 + (temp = W[hook(9, (78 - 3) & 15)] ^ W[hook(9, (78 - 8) & 15)] ^ W[hook(9, (78 - 14) & 15)] ^ W[hook(9, 78 & 15)], (W[hook(9, 78 & 15)] = rotate((int)temp, 1)));
      D = rotate((int)D, 30);
    };
    {
      A += rotate((int)B, 5) + (C ^ D ^ E) + 0xCA62C1D6 + (temp = W[hook(9, (79 - 3) & 15)] ^ W[hook(9, (79 - 8) & 15)] ^ W[hook(9, (79 - 14) & 15)] ^ W[hook(9, 79 & 15)], (W[hook(9, 79 & 15)] = rotate((int)temp, 1)));
      C = rotate((int)C, 30);
    };

    H[hook(12, 0)] = A + H[hook(12, 0)];
    H[hook(12, 1)] = B + H[hook(12, 1)];
    H[hook(12, 2)] = C + H[hook(12, 2)];
    H[hook(12, 3)] = D + H[hook(12, 3)];
    H[hook(12, 4)] = E + H[hook(12, 4)];
  }

  counter_words = precision_bits / 32;
  for (t = 0; t < counter_words; t++) {
    if (target[hook(2, t)] != H[hook(12, t)]) {
      return;
    }
  }
  if (counter_words < 5 && (precision_bits % 32)) {
    if (target[hook(2, counter_words)] != (H[hook(12, counter_words)] & (0xFFFFFFFF << ((counter_words + 1) * 32 - precision_bits)))) {
      return;
    }
  }

  if (!result[hook(6, 0)]) {
    result[hook(6, 0)] = 1;
    result[hook(6, 1)] = current;
  }
}