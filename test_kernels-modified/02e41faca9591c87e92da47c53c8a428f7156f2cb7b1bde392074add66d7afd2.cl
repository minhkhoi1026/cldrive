//{"W":6,"data_info":0,"dest":5,"digest":3,"plain_key":2,"s":4,"salt":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void prepare_msg(global uchar* s, char* dest, global uchar* salt, int blocksize) {
  int i, k;
  unsigned int ulen;

  for (i = 0; i < blocksize && s[hook(4, i)] != 0x80; i++)
    dest[hook(5, i)] = s[hook(4, i)];

  for (k = 0; k < 8; k++)
    dest[hook(5, i + k)] = salt[hook(1, k)];

  i = i + k;
  ulen = (i * 8) & 0xFFFFFFFF;
  dest[hook(5, i)] = (char)0x80;

  i = i + 1;
  for (; i < 60; i++)
    dest[hook(5, i)] = (char)0;
  dest[hook(5, 60)] = ulen >> 24;
  dest[hook(5, 61)] = ulen >> 16;
  dest[hook(5, 62)] = ulen >> 8;
  dest[hook(5, 63)] = ulen;

  return;
}

kernel void sha1_crypt_kernel(global unsigned int* data_info, global uchar* salt, global char* plain_key, global unsigned int* digest) {
  int t, gid, msg_pad;
  int i, stop, mmod;
  unsigned int ulen;
  unsigned int W[80], temp, A, B, C, D, E;
  unsigned int num_keys = data_info[hook(0, 1)];

  gid = get_global_id(0);
  msg_pad = gid * data_info[hook(0, 0)];

  A = 0x67452301;
  B = 0xEFCDAB89;
  C = 0x98BADCFE;
  D = 0x10325476;
  E = 0xC3D2E1F0;
  for (t = 2; t < 15; t++) {
    W[hook(6, t)] = 0x00000000;
  }
  for (i = 0; i < data_info[hook(0, 0)] && ((uchar)plain_key[hook(2, msg_pad + i)]) != 0x80; i++) {
  }

  stop = i / 4;
  for (t = 0; t < stop; t++) {
    W[hook(6, t)] = ((uchar)plain_key[hook(2, msg_pad + t * 4)]) << 24;
    W[hook(6, t)] |= ((uchar)plain_key[hook(2, msg_pad + t * 4 + 1)]) << 16;
    W[hook(6, t)] |= ((uchar)plain_key[hook(2, msg_pad + t * 4 + 2)]) << 8;
    W[hook(6, t)] |= (uchar)plain_key[hook(2, msg_pad + t * 4 + 3)];
  }
  mmod = i % 4;
  if (mmod == 3) {
    W[hook(6, t)] = ((uchar)plain_key[hook(2, msg_pad + t * 4)]) << 24;
    W[hook(6, t)] |= ((uchar)plain_key[hook(2, msg_pad + t * 4 + 1)]) << 16;
    W[hook(6, t)] |= ((uchar)plain_key[hook(2, msg_pad + t * 4 + 2)]) << 8;
    W[hook(6, t)] |= (uchar)salt[hook(1, 0)];
    W[hook(6, t + 2)] = ((uchar)salt[hook(1, 5)]) << 24;
    W[hook(6, t + 2)] |= ((uchar)salt[hook(1, 6)]) << 16;
    W[hook(6, t + 2)] |= ((uchar)salt[hook(1, 7)]) << 8;
    W[hook(6, t + 2)] |= ((uchar)0x80);
    mmod = 4 - mmod;
  } else if (mmod == 2) {
    W[hook(6, t)] = ((uchar)plain_key[hook(2, msg_pad + t * 4)]) << 24;
    W[hook(6, t)] |= ((uchar)plain_key[hook(2, msg_pad + t * 4 + 1)]) << 16;
    W[hook(6, t)] |= ((uchar)salt[hook(1, 0)]) << 8;
    W[hook(6, t)] |= (uchar)salt[hook(1, 1)];
    W[hook(6, t + 2)] = ((uchar)salt[hook(1, 6)]) << 24;
    W[hook(6, t + 2)] |= ((uchar)salt[hook(1, 7)]) << 16;
    W[hook(6, t + 2)] |= 0x8000;
    mmod = 4 - mmod;
  } else if (mmod == 1) {
    W[hook(6, t)] = ((uchar)plain_key[hook(2, msg_pad + t * 4)]) << 24;
    W[hook(6, t)] |= ((uchar)salt[hook(1, 0)]) << 16;
    W[hook(6, t)] |= ((uchar)salt[hook(1, 1)]) << 8;
    W[hook(6, t)] |= (uchar)salt[hook(1, 2)];
    W[hook(6, t + 2)] = ((uchar)salt[hook(1, 7)]) << 24;
    W[hook(6, t + 2)] |= 0x800000;
    mmod = 4 - mmod;
  } else if (mmod == 0) {
    W[hook(6, t + 2)] = 0x80000000;
    t = t - 1;
  }
  t = t + 1;
  for (; t < (stop + 2) && mmod < 8; t++) {
    W[hook(6, t)] = ((uchar)salt[hook(1, mmod)]) << 24;
    W[hook(6, t)] |= ((uchar)salt[hook(1, mmod + 1)]) << 16;
    W[hook(6, t)] |= ((uchar)salt[hook(1, mmod + 2)]) << 8;
    W[hook(6, t)] |= ((uchar)salt[hook(1, mmod + 3)]);
    mmod = mmod + 4;
  }

  i = i + 8;
  ulen = (i * 8) & 0xFFFFFFFF;
  W[hook(6, 15)] = ulen;
  {
    E += rotate((int)A, 5) + (D ^ (B & (C ^ D))) + 0x5A827999 + W[hook(6, 0)];
    B = rotate((int)B, 30);
  };
  {
    D += rotate((int)E, 5) + (C ^ (A & (B ^ C))) + 0x5A827999 + W[hook(6, 1)];
    A = rotate((int)A, 30);
  };
  {
    C += rotate((int)D, 5) + (B ^ (E & (A ^ B))) + 0x5A827999 + W[hook(6, 2)];
    E = rotate((int)E, 30);
  };
  {
    B += rotate((int)C, 5) + (A ^ (D & (E ^ A))) + 0x5A827999 + W[hook(6, 3)];
    D = rotate((int)D, 30);
  };
  {
    A += rotate((int)B, 5) + (E ^ (C & (D ^ E))) + 0x5A827999 + W[hook(6, 4)];
    C = rotate((int)C, 30);
  };
  {
    E += rotate((int)A, 5) + (D ^ (B & (C ^ D))) + 0x5A827999 + W[hook(6, 5)];
    B = rotate((int)B, 30);
  };
  {
    D += rotate((int)E, 5) + (C ^ (A & (B ^ C))) + 0x5A827999 + W[hook(6, 6)];
    A = rotate((int)A, 30);
  };
  {
    C += rotate((int)D, 5) + (B ^ (E & (A ^ B))) + 0x5A827999 + W[hook(6, 7)];
    E = rotate((int)E, 30);
  };
  {
    B += rotate((int)C, 5) + (A ^ (D & (E ^ A))) + 0x5A827999 + W[hook(6, 8)];
    D = rotate((int)D, 30);
  };
  {
    A += rotate((int)B, 5) + (E ^ (C & (D ^ E))) + 0x5A827999 + W[hook(6, 9)];
    C = rotate((int)C, 30);
  };
  {
    E += rotate((int)A, 5) + (D ^ (B & (C ^ D))) + 0x5A827999 + W[hook(6, 10)];
    B = rotate((int)B, 30);
  };
  {
    D += rotate((int)E, 5) + (C ^ (A & (B ^ C))) + 0x5A827999 + W[hook(6, 11)];
    A = rotate((int)A, 30);
  };
  {
    C += rotate((int)D, 5) + (B ^ (E & (A ^ B))) + 0x5A827999 + W[hook(6, 12)];
    E = rotate((int)E, 30);
  };
  {
    B += rotate((int)C, 5) + (A ^ (D & (E ^ A))) + 0x5A827999 + W[hook(6, 13)];
    D = rotate((int)D, 30);
  };
  {
    A += rotate((int)B, 5) + (E ^ (C & (D ^ E))) + 0x5A827999 + W[hook(6, 14)];
    C = rotate((int)C, 30);
  };
  {
    E += rotate((int)A, 5) + (D ^ (B & (C ^ D))) + 0x5A827999 + W[hook(6, 15)];
    B = rotate((int)B, 30);
  };
  {
    D += rotate((int)E, 5) + (C ^ (A & (B ^ C))) + 0x5A827999 + (temp = W[hook(6, (16 - 3) & 15)] ^ W[hook(6, (16 - 8) & 15)] ^ W[hook(6, (16 - 14) & 15)] ^ W[hook(6, 16 & 15)], (W[hook(6, 16 & 15)] = rotate((int)temp, 1)));
    A = rotate((int)A, 30);
  };
  {
    C += rotate((int)D, 5) + (B ^ (E & (A ^ B))) + 0x5A827999 + (temp = W[hook(6, (17 - 3) & 15)] ^ W[hook(6, (17 - 8) & 15)] ^ W[hook(6, (17 - 14) & 15)] ^ W[hook(6, 17 & 15)], (W[hook(6, 17 & 15)] = rotate((int)temp, 1)));
    E = rotate((int)E, 30);
  };
  {
    B += rotate((int)C, 5) + (A ^ (D & (E ^ A))) + 0x5A827999 + (temp = W[hook(6, (18 - 3) & 15)] ^ W[hook(6, (18 - 8) & 15)] ^ W[hook(6, (18 - 14) & 15)] ^ W[hook(6, 18 & 15)], (W[hook(6, 18 & 15)] = rotate((int)temp, 1)));
    D = rotate((int)D, 30);
  };
  {
    A += rotate((int)B, 5) + (E ^ (C & (D ^ E))) + 0x5A827999 + (temp = W[hook(6, (19 - 3) & 15)] ^ W[hook(6, (19 - 8) & 15)] ^ W[hook(6, (19 - 14) & 15)] ^ W[hook(6, 19 & 15)], (W[hook(6, 19 & 15)] = rotate((int)temp, 1)));
    C = rotate((int)C, 30);
  };

  {
    E += rotate((int)A, 5) + (B ^ C ^ D) + 0x6ED9EBA1 + (temp = W[hook(6, (20 - 3) & 15)] ^ W[hook(6, (20 - 8) & 15)] ^ W[hook(6, (20 - 14) & 15)] ^ W[hook(6, 20 & 15)], (W[hook(6, 20 & 15)] = rotate((int)temp, 1)));
    B = rotate((int)B, 30);
  };
  {
    D += rotate((int)E, 5) + (A ^ B ^ C) + 0x6ED9EBA1 + (temp = W[hook(6, (21 - 3) & 15)] ^ W[hook(6, (21 - 8) & 15)] ^ W[hook(6, (21 - 14) & 15)] ^ W[hook(6, 21 & 15)], (W[hook(6, 21 & 15)] = rotate((int)temp, 1)));
    A = rotate((int)A, 30);
  };
  {
    C += rotate((int)D, 5) + (E ^ A ^ B) + 0x6ED9EBA1 + (temp = W[hook(6, (22 - 3) & 15)] ^ W[hook(6, (22 - 8) & 15)] ^ W[hook(6, (22 - 14) & 15)] ^ W[hook(6, 22 & 15)], (W[hook(6, 22 & 15)] = rotate((int)temp, 1)));
    E = rotate((int)E, 30);
  };
  {
    B += rotate((int)C, 5) + (D ^ E ^ A) + 0x6ED9EBA1 + (temp = W[hook(6, (23 - 3) & 15)] ^ W[hook(6, (23 - 8) & 15)] ^ W[hook(6, (23 - 14) & 15)] ^ W[hook(6, 23 & 15)], (W[hook(6, 23 & 15)] = rotate((int)temp, 1)));
    D = rotate((int)D, 30);
  };
  {
    A += rotate((int)B, 5) + (C ^ D ^ E) + 0x6ED9EBA1 + (temp = W[hook(6, (24 - 3) & 15)] ^ W[hook(6, (24 - 8) & 15)] ^ W[hook(6, (24 - 14) & 15)] ^ W[hook(6, 24 & 15)], (W[hook(6, 24 & 15)] = rotate((int)temp, 1)));
    C = rotate((int)C, 30);
  };
  {
    E += rotate((int)A, 5) + (B ^ C ^ D) + 0x6ED9EBA1 + (temp = W[hook(6, (25 - 3) & 15)] ^ W[hook(6, (25 - 8) & 15)] ^ W[hook(6, (25 - 14) & 15)] ^ W[hook(6, 25 & 15)], (W[hook(6, 25 & 15)] = rotate((int)temp, 1)));
    B = rotate((int)B, 30);
  };
  {
    D += rotate((int)E, 5) + (A ^ B ^ C) + 0x6ED9EBA1 + (temp = W[hook(6, (26 - 3) & 15)] ^ W[hook(6, (26 - 8) & 15)] ^ W[hook(6, (26 - 14) & 15)] ^ W[hook(6, 26 & 15)], (W[hook(6, 26 & 15)] = rotate((int)temp, 1)));
    A = rotate((int)A, 30);
  };
  {
    C += rotate((int)D, 5) + (E ^ A ^ B) + 0x6ED9EBA1 + (temp = W[hook(6, (27 - 3) & 15)] ^ W[hook(6, (27 - 8) & 15)] ^ W[hook(6, (27 - 14) & 15)] ^ W[hook(6, 27 & 15)], (W[hook(6, 27 & 15)] = rotate((int)temp, 1)));
    E = rotate((int)E, 30);
  };
  {
    B += rotate((int)C, 5) + (D ^ E ^ A) + 0x6ED9EBA1 + (temp = W[hook(6, (28 - 3) & 15)] ^ W[hook(6, (28 - 8) & 15)] ^ W[hook(6, (28 - 14) & 15)] ^ W[hook(6, 28 & 15)], (W[hook(6, 28 & 15)] = rotate((int)temp, 1)));
    D = rotate((int)D, 30);
  };
  {
    A += rotate((int)B, 5) + (C ^ D ^ E) + 0x6ED9EBA1 + (temp = W[hook(6, (29 - 3) & 15)] ^ W[hook(6, (29 - 8) & 15)] ^ W[hook(6, (29 - 14) & 15)] ^ W[hook(6, 29 & 15)], (W[hook(6, 29 & 15)] = rotate((int)temp, 1)));
    C = rotate((int)C, 30);
  };
  {
    E += rotate((int)A, 5) + (B ^ C ^ D) + 0x6ED9EBA1 + (temp = W[hook(6, (30 - 3) & 15)] ^ W[hook(6, (30 - 8) & 15)] ^ W[hook(6, (30 - 14) & 15)] ^ W[hook(6, 30 & 15)], (W[hook(6, 30 & 15)] = rotate((int)temp, 1)));
    B = rotate((int)B, 30);
  };
  {
    D += rotate((int)E, 5) + (A ^ B ^ C) + 0x6ED9EBA1 + (temp = W[hook(6, (31 - 3) & 15)] ^ W[hook(6, (31 - 8) & 15)] ^ W[hook(6, (31 - 14) & 15)] ^ W[hook(6, 31 & 15)], (W[hook(6, 31 & 15)] = rotate((int)temp, 1)));
    A = rotate((int)A, 30);
  };
  {
    C += rotate((int)D, 5) + (E ^ A ^ B) + 0x6ED9EBA1 + (temp = W[hook(6, (32 - 3) & 15)] ^ W[hook(6, (32 - 8) & 15)] ^ W[hook(6, (32 - 14) & 15)] ^ W[hook(6, 32 & 15)], (W[hook(6, 32 & 15)] = rotate((int)temp, 1)));
    E = rotate((int)E, 30);
  };
  {
    B += rotate((int)C, 5) + (D ^ E ^ A) + 0x6ED9EBA1 + (temp = W[hook(6, (33 - 3) & 15)] ^ W[hook(6, (33 - 8) & 15)] ^ W[hook(6, (33 - 14) & 15)] ^ W[hook(6, 33 & 15)], (W[hook(6, 33 & 15)] = rotate((int)temp, 1)));
    D = rotate((int)D, 30);
  };
  {
    A += rotate((int)B, 5) + (C ^ D ^ E) + 0x6ED9EBA1 + (temp = W[hook(6, (34 - 3) & 15)] ^ W[hook(6, (34 - 8) & 15)] ^ W[hook(6, (34 - 14) & 15)] ^ W[hook(6, 34 & 15)], (W[hook(6, 34 & 15)] = rotate((int)temp, 1)));
    C = rotate((int)C, 30);
  };
  {
    E += rotate((int)A, 5) + (B ^ C ^ D) + 0x6ED9EBA1 + (temp = W[hook(6, (35 - 3) & 15)] ^ W[hook(6, (35 - 8) & 15)] ^ W[hook(6, (35 - 14) & 15)] ^ W[hook(6, 35 & 15)], (W[hook(6, 35 & 15)] = rotate((int)temp, 1)));
    B = rotate((int)B, 30);
  };
  {
    D += rotate((int)E, 5) + (A ^ B ^ C) + 0x6ED9EBA1 + (temp = W[hook(6, (36 - 3) & 15)] ^ W[hook(6, (36 - 8) & 15)] ^ W[hook(6, (36 - 14) & 15)] ^ W[hook(6, 36 & 15)], (W[hook(6, 36 & 15)] = rotate((int)temp, 1)));
    A = rotate((int)A, 30);
  };
  {
    C += rotate((int)D, 5) + (E ^ A ^ B) + 0x6ED9EBA1 + (temp = W[hook(6, (37 - 3) & 15)] ^ W[hook(6, (37 - 8) & 15)] ^ W[hook(6, (37 - 14) & 15)] ^ W[hook(6, 37 & 15)], (W[hook(6, 37 & 15)] = rotate((int)temp, 1)));
    E = rotate((int)E, 30);
  };
  {
    B += rotate((int)C, 5) + (D ^ E ^ A) + 0x6ED9EBA1 + (temp = W[hook(6, (38 - 3) & 15)] ^ W[hook(6, (38 - 8) & 15)] ^ W[hook(6, (38 - 14) & 15)] ^ W[hook(6, 38 & 15)], (W[hook(6, 38 & 15)] = rotate((int)temp, 1)));
    D = rotate((int)D, 30);
  };
  {
    A += rotate((int)B, 5) + (C ^ D ^ E) + 0x6ED9EBA1 + (temp = W[hook(6, (39 - 3) & 15)] ^ W[hook(6, (39 - 8) & 15)] ^ W[hook(6, (39 - 14) & 15)] ^ W[hook(6, 39 & 15)], (W[hook(6, 39 & 15)] = rotate((int)temp, 1)));
    C = rotate((int)C, 30);
  };

  {
    E += rotate((int)A, 5) + ((B & C) | (D & (B | C))) + 0x8F1BBCDC + (temp = W[hook(6, (40 - 3) & 15)] ^ W[hook(6, (40 - 8) & 15)] ^ W[hook(6, (40 - 14) & 15)] ^ W[hook(6, 40 & 15)], (W[hook(6, 40 & 15)] = rotate((int)temp, 1)));
    B = rotate((int)B, 30);
  };
  {
    D += rotate((int)E, 5) + ((A & B) | (C & (A | B))) + 0x8F1BBCDC + (temp = W[hook(6, (41 - 3) & 15)] ^ W[hook(6, (41 - 8) & 15)] ^ W[hook(6, (41 - 14) & 15)] ^ W[hook(6, 41 & 15)], (W[hook(6, 41 & 15)] = rotate((int)temp, 1)));
    A = rotate((int)A, 30);
  };
  {
    C += rotate((int)D, 5) + ((E & A) | (B & (E | A))) + 0x8F1BBCDC + (temp = W[hook(6, (42 - 3) & 15)] ^ W[hook(6, (42 - 8) & 15)] ^ W[hook(6, (42 - 14) & 15)] ^ W[hook(6, 42 & 15)], (W[hook(6, 42 & 15)] = rotate((int)temp, 1)));
    E = rotate((int)E, 30);
  };
  {
    B += rotate((int)C, 5) + ((D & E) | (A & (D | E))) + 0x8F1BBCDC + (temp = W[hook(6, (43 - 3) & 15)] ^ W[hook(6, (43 - 8) & 15)] ^ W[hook(6, (43 - 14) & 15)] ^ W[hook(6, 43 & 15)], (W[hook(6, 43 & 15)] = rotate((int)temp, 1)));
    D = rotate((int)D, 30);
  };
  {
    A += rotate((int)B, 5) + ((C & D) | (E & (C | D))) + 0x8F1BBCDC + (temp = W[hook(6, (44 - 3) & 15)] ^ W[hook(6, (44 - 8) & 15)] ^ W[hook(6, (44 - 14) & 15)] ^ W[hook(6, 44 & 15)], (W[hook(6, 44 & 15)] = rotate((int)temp, 1)));
    C = rotate((int)C, 30);
  };
  {
    E += rotate((int)A, 5) + ((B & C) | (D & (B | C))) + 0x8F1BBCDC + (temp = W[hook(6, (45 - 3) & 15)] ^ W[hook(6, (45 - 8) & 15)] ^ W[hook(6, (45 - 14) & 15)] ^ W[hook(6, 45 & 15)], (W[hook(6, 45 & 15)] = rotate((int)temp, 1)));
    B = rotate((int)B, 30);
  };
  {
    D += rotate((int)E, 5) + ((A & B) | (C & (A | B))) + 0x8F1BBCDC + (temp = W[hook(6, (46 - 3) & 15)] ^ W[hook(6, (46 - 8) & 15)] ^ W[hook(6, (46 - 14) & 15)] ^ W[hook(6, 46 & 15)], (W[hook(6, 46 & 15)] = rotate((int)temp, 1)));
    A = rotate((int)A, 30);
  };
  {
    C += rotate((int)D, 5) + ((E & A) | (B & (E | A))) + 0x8F1BBCDC + (temp = W[hook(6, (47 - 3) & 15)] ^ W[hook(6, (47 - 8) & 15)] ^ W[hook(6, (47 - 14) & 15)] ^ W[hook(6, 47 & 15)], (W[hook(6, 47 & 15)] = rotate((int)temp, 1)));
    E = rotate((int)E, 30);
  };
  {
    B += rotate((int)C, 5) + ((D & E) | (A & (D | E))) + 0x8F1BBCDC + (temp = W[hook(6, (48 - 3) & 15)] ^ W[hook(6, (48 - 8) & 15)] ^ W[hook(6, (48 - 14) & 15)] ^ W[hook(6, 48 & 15)], (W[hook(6, 48 & 15)] = rotate((int)temp, 1)));
    D = rotate((int)D, 30);
  };
  {
    A += rotate((int)B, 5) + ((C & D) | (E & (C | D))) + 0x8F1BBCDC + (temp = W[hook(6, (49 - 3) & 15)] ^ W[hook(6, (49 - 8) & 15)] ^ W[hook(6, (49 - 14) & 15)] ^ W[hook(6, 49 & 15)], (W[hook(6, 49 & 15)] = rotate((int)temp, 1)));
    C = rotate((int)C, 30);
  };
  {
    E += rotate((int)A, 5) + ((B & C) | (D & (B | C))) + 0x8F1BBCDC + (temp = W[hook(6, (50 - 3) & 15)] ^ W[hook(6, (50 - 8) & 15)] ^ W[hook(6, (50 - 14) & 15)] ^ W[hook(6, 50 & 15)], (W[hook(6, 50 & 15)] = rotate((int)temp, 1)));
    B = rotate((int)B, 30);
  };
  {
    D += rotate((int)E, 5) + ((A & B) | (C & (A | B))) + 0x8F1BBCDC + (temp = W[hook(6, (51 - 3) & 15)] ^ W[hook(6, (51 - 8) & 15)] ^ W[hook(6, (51 - 14) & 15)] ^ W[hook(6, 51 & 15)], (W[hook(6, 51 & 15)] = rotate((int)temp, 1)));
    A = rotate((int)A, 30);
  };
  {
    C += rotate((int)D, 5) + ((E & A) | (B & (E | A))) + 0x8F1BBCDC + (temp = W[hook(6, (52 - 3) & 15)] ^ W[hook(6, (52 - 8) & 15)] ^ W[hook(6, (52 - 14) & 15)] ^ W[hook(6, 52 & 15)], (W[hook(6, 52 & 15)] = rotate((int)temp, 1)));
    E = rotate((int)E, 30);
  };
  {
    B += rotate((int)C, 5) + ((D & E) | (A & (D | E))) + 0x8F1BBCDC + (temp = W[hook(6, (53 - 3) & 15)] ^ W[hook(6, (53 - 8) & 15)] ^ W[hook(6, (53 - 14) & 15)] ^ W[hook(6, 53 & 15)], (W[hook(6, 53 & 15)] = rotate((int)temp, 1)));
    D = rotate((int)D, 30);
  };
  {
    A += rotate((int)B, 5) + ((C & D) | (E & (C | D))) + 0x8F1BBCDC + (temp = W[hook(6, (54 - 3) & 15)] ^ W[hook(6, (54 - 8) & 15)] ^ W[hook(6, (54 - 14) & 15)] ^ W[hook(6, 54 & 15)], (W[hook(6, 54 & 15)] = rotate((int)temp, 1)));
    C = rotate((int)C, 30);
  };
  {
    E += rotate((int)A, 5) + ((B & C) | (D & (B | C))) + 0x8F1BBCDC + (temp = W[hook(6, (55 - 3) & 15)] ^ W[hook(6, (55 - 8) & 15)] ^ W[hook(6, (55 - 14) & 15)] ^ W[hook(6, 55 & 15)], (W[hook(6, 55 & 15)] = rotate((int)temp, 1)));
    B = rotate((int)B, 30);
  };
  {
    D += rotate((int)E, 5) + ((A & B) | (C & (A | B))) + 0x8F1BBCDC + (temp = W[hook(6, (56 - 3) & 15)] ^ W[hook(6, (56 - 8) & 15)] ^ W[hook(6, (56 - 14) & 15)] ^ W[hook(6, 56 & 15)], (W[hook(6, 56 & 15)] = rotate((int)temp, 1)));
    A = rotate((int)A, 30);
  };
  {
    C += rotate((int)D, 5) + ((E & A) | (B & (E | A))) + 0x8F1BBCDC + (temp = W[hook(6, (57 - 3) & 15)] ^ W[hook(6, (57 - 8) & 15)] ^ W[hook(6, (57 - 14) & 15)] ^ W[hook(6, 57 & 15)], (W[hook(6, 57 & 15)] = rotate((int)temp, 1)));
    E = rotate((int)E, 30);
  };
  {
    B += rotate((int)C, 5) + ((D & E) | (A & (D | E))) + 0x8F1BBCDC + (temp = W[hook(6, (58 - 3) & 15)] ^ W[hook(6, (58 - 8) & 15)] ^ W[hook(6, (58 - 14) & 15)] ^ W[hook(6, 58 & 15)], (W[hook(6, 58 & 15)] = rotate((int)temp, 1)));
    D = rotate((int)D, 30);
  };
  {
    A += rotate((int)B, 5) + ((C & D) | (E & (C | D))) + 0x8F1BBCDC + (temp = W[hook(6, (59 - 3) & 15)] ^ W[hook(6, (59 - 8) & 15)] ^ W[hook(6, (59 - 14) & 15)] ^ W[hook(6, 59 & 15)], (W[hook(6, 59 & 15)] = rotate((int)temp, 1)));
    C = rotate((int)C, 30);
  };

  {
    E += rotate((int)A, 5) + (B ^ C ^ D) + 0xCA62C1D6 + (temp = W[hook(6, (60 - 3) & 15)] ^ W[hook(6, (60 - 8) & 15)] ^ W[hook(6, (60 - 14) & 15)] ^ W[hook(6, 60 & 15)], (W[hook(6, 60 & 15)] = rotate((int)temp, 1)));
    B = rotate((int)B, 30);
  };
  {
    D += rotate((int)E, 5) + (A ^ B ^ C) + 0xCA62C1D6 + (temp = W[hook(6, (61 - 3) & 15)] ^ W[hook(6, (61 - 8) & 15)] ^ W[hook(6, (61 - 14) & 15)] ^ W[hook(6, 61 & 15)], (W[hook(6, 61 & 15)] = rotate((int)temp, 1)));
    A = rotate((int)A, 30);
  };
  {
    C += rotate((int)D, 5) + (E ^ A ^ B) + 0xCA62C1D6 + (temp = W[hook(6, (62 - 3) & 15)] ^ W[hook(6, (62 - 8) & 15)] ^ W[hook(6, (62 - 14) & 15)] ^ W[hook(6, 62 & 15)], (W[hook(6, 62 & 15)] = rotate((int)temp, 1)));
    E = rotate((int)E, 30);
  };
  {
    B += rotate((int)C, 5) + (D ^ E ^ A) + 0xCA62C1D6 + (temp = W[hook(6, (63 - 3) & 15)] ^ W[hook(6, (63 - 8) & 15)] ^ W[hook(6, (63 - 14) & 15)] ^ W[hook(6, 63 & 15)], (W[hook(6, 63 & 15)] = rotate((int)temp, 1)));
    D = rotate((int)D, 30);
  };
  {
    A += rotate((int)B, 5) + (C ^ D ^ E) + 0xCA62C1D6 + (temp = W[hook(6, (64 - 3) & 15)] ^ W[hook(6, (64 - 8) & 15)] ^ W[hook(6, (64 - 14) & 15)] ^ W[hook(6, 64 & 15)], (W[hook(6, 64 & 15)] = rotate((int)temp, 1)));
    C = rotate((int)C, 30);
  };
  {
    E += rotate((int)A, 5) + (B ^ C ^ D) + 0xCA62C1D6 + (temp = W[hook(6, (65 - 3) & 15)] ^ W[hook(6, (65 - 8) & 15)] ^ W[hook(6, (65 - 14) & 15)] ^ W[hook(6, 65 & 15)], (W[hook(6, 65 & 15)] = rotate((int)temp, 1)));
    B = rotate((int)B, 30);
  };
  {
    D += rotate((int)E, 5) + (A ^ B ^ C) + 0xCA62C1D6 + (temp = W[hook(6, (66 - 3) & 15)] ^ W[hook(6, (66 - 8) & 15)] ^ W[hook(6, (66 - 14) & 15)] ^ W[hook(6, 66 & 15)], (W[hook(6, 66 & 15)] = rotate((int)temp, 1)));
    A = rotate((int)A, 30);
  };
  {
    C += rotate((int)D, 5) + (E ^ A ^ B) + 0xCA62C1D6 + (temp = W[hook(6, (67 - 3) & 15)] ^ W[hook(6, (67 - 8) & 15)] ^ W[hook(6, (67 - 14) & 15)] ^ W[hook(6, 67 & 15)], (W[hook(6, 67 & 15)] = rotate((int)temp, 1)));
    E = rotate((int)E, 30);
  };
  {
    B += rotate((int)C, 5) + (D ^ E ^ A) + 0xCA62C1D6 + (temp = W[hook(6, (68 - 3) & 15)] ^ W[hook(6, (68 - 8) & 15)] ^ W[hook(6, (68 - 14) & 15)] ^ W[hook(6, 68 & 15)], (W[hook(6, 68 & 15)] = rotate((int)temp, 1)));
    D = rotate((int)D, 30);
  };
  {
    A += rotate((int)B, 5) + (C ^ D ^ E) + 0xCA62C1D6 + (temp = W[hook(6, (69 - 3) & 15)] ^ W[hook(6, (69 - 8) & 15)] ^ W[hook(6, (69 - 14) & 15)] ^ W[hook(6, 69 & 15)], (W[hook(6, 69 & 15)] = rotate((int)temp, 1)));
    C = rotate((int)C, 30);
  };
  {
    E += rotate((int)A, 5) + (B ^ C ^ D) + 0xCA62C1D6 + (temp = W[hook(6, (70 - 3) & 15)] ^ W[hook(6, (70 - 8) & 15)] ^ W[hook(6, (70 - 14) & 15)] ^ W[hook(6, 70 & 15)], (W[hook(6, 70 & 15)] = rotate((int)temp, 1)));
    B = rotate((int)B, 30);
  };
  {
    D += rotate((int)E, 5) + (A ^ B ^ C) + 0xCA62C1D6 + (temp = W[hook(6, (71 - 3) & 15)] ^ W[hook(6, (71 - 8) & 15)] ^ W[hook(6, (71 - 14) & 15)] ^ W[hook(6, 71 & 15)], (W[hook(6, 71 & 15)] = rotate((int)temp, 1)));
    A = rotate((int)A, 30);
  };
  {
    C += rotate((int)D, 5) + (E ^ A ^ B) + 0xCA62C1D6 + (temp = W[hook(6, (72 - 3) & 15)] ^ W[hook(6, (72 - 8) & 15)] ^ W[hook(6, (72 - 14) & 15)] ^ W[hook(6, 72 & 15)], (W[hook(6, 72 & 15)] = rotate((int)temp, 1)));
    E = rotate((int)E, 30);
  };
  {
    B += rotate((int)C, 5) + (D ^ E ^ A) + 0xCA62C1D6 + (temp = W[hook(6, (73 - 3) & 15)] ^ W[hook(6, (73 - 8) & 15)] ^ W[hook(6, (73 - 14) & 15)] ^ W[hook(6, 73 & 15)], (W[hook(6, 73 & 15)] = rotate((int)temp, 1)));
    D = rotate((int)D, 30);
  };
  {
    A += rotate((int)B, 5) + (C ^ D ^ E) + 0xCA62C1D6 + (temp = W[hook(6, (74 - 3) & 15)] ^ W[hook(6, (74 - 8) & 15)] ^ W[hook(6, (74 - 14) & 15)] ^ W[hook(6, 74 & 15)], (W[hook(6, 74 & 15)] = rotate((int)temp, 1)));
    C = rotate((int)C, 30);
  };
  {
    E += rotate((int)A, 5) + (B ^ C ^ D) + 0xCA62C1D6 + (temp = W[hook(6, (75 - 3) & 15)] ^ W[hook(6, (75 - 8) & 15)] ^ W[hook(6, (75 - 14) & 15)] ^ W[hook(6, 75 & 15)], (W[hook(6, 75 & 15)] = rotate((int)temp, 1)));
    B = rotate((int)B, 30);
  };
  {
    D += rotate((int)E, 5) + (A ^ B ^ C) + 0xCA62C1D6 + (temp = W[hook(6, (76 - 3) & 15)] ^ W[hook(6, (76 - 8) & 15)] ^ W[hook(6, (76 - 14) & 15)] ^ W[hook(6, 76 & 15)], (W[hook(6, 76 & 15)] = rotate((int)temp, 1)));
    A = rotate((int)A, 30);
  };
  {
    C += rotate((int)D, 5) + (E ^ A ^ B) + 0xCA62C1D6 + (temp = W[hook(6, (77 - 3) & 15)] ^ W[hook(6, (77 - 8) & 15)] ^ W[hook(6, (77 - 14) & 15)] ^ W[hook(6, 77 & 15)], (W[hook(6, 77 & 15)] = rotate((int)temp, 1)));
    E = rotate((int)E, 30);
  };
  {
    B += rotate((int)C, 5) + (D ^ E ^ A) + 0xCA62C1D6 + (temp = W[hook(6, (78 - 3) & 15)] ^ W[hook(6, (78 - 8) & 15)] ^ W[hook(6, (78 - 14) & 15)] ^ W[hook(6, 78 & 15)], (W[hook(6, 78 & 15)] = rotate((int)temp, 1)));
    D = rotate((int)D, 30);
  };
  {
    A += rotate((int)B, 5) + (C ^ D ^ E) + 0xCA62C1D6 + (temp = W[hook(6, (79 - 3) & 15)] ^ W[hook(6, (79 - 8) & 15)] ^ W[hook(6, (79 - 14) & 15)] ^ W[hook(6, 79 & 15)], (W[hook(6, 79 & 15)] = rotate((int)temp, 1)));
    C = rotate((int)C, 30);
  };

  digest[hook(3, gid)] = __builtin_astype((__builtin_astype((A + 0x67452301), uchar4).wzyx), unsigned int);
  digest[hook(3, gid + 1 * num_keys)] = __builtin_astype((__builtin_astype((B + 0xEFCDAB89), uchar4).wzyx), unsigned int);
  digest[hook(3, gid + 2 * num_keys)] = __builtin_astype((__builtin_astype((C + 0x98BADCFE), uchar4).wzyx), unsigned int);
  digest[hook(3, gid + 3 * num_keys)] = __builtin_astype((__builtin_astype((D + 0x10325476), uchar4).wzyx), unsigned int);
  digest[hook(3, gid + 4 * num_keys)] = __builtin_astype((__builtin_astype((E + 0xC3D2E1F0), uchar4).wzyx), unsigned int);
}