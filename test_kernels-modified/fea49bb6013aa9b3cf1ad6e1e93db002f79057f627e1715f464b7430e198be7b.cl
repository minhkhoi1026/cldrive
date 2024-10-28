//{"X.v":5,"ctr":0,"in.v":6,"k.v":4,"key":1,"ks":3,"offset":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
enum r123_enum_threefry32x2 { R_32x2_0_0 = 13, R_32x2_1_0 = 15, R_32x2_2_0 = 26, R_32x2_3_0 = 6, R_32x2_4_0 = 17, R_32x2_5_0 = 29, R_32x2_6_0 = 16, R_32x2_7_0 = 24 };

unsigned int RotL_32(unsigned int x, unsigned int N) {
  return (x << (N & 31)) | (x >> ((32 - N) & 31));
}

struct r123array2x32 {
  unsigned int v[2];
};

typedef struct r123array2x32 threefry2x32_ctr_t;
typedef struct r123array2x32 threefry2x32_key_t;

threefry2x32_ctr_t threefry2x32_R(unsigned int Nrounds, threefry2x32_ctr_t in, threefry2x32_key_t k) {
  threefry2x32_ctr_t X;
  unsigned int ks[3];
  unsigned int i;
  ks[hook(3, 2)] = 0x1BD11BDA;
  for (i = 0; i < 2; i++) {
    ks[hook(3, i)] = k.v[hook(4, i)];
    X.v[hook(5, i)] = in.v[hook(6, i)];
    ks[hook(3, 2)] ^= k.v[hook(4, i)];
  }
  X.v[hook(5, 0)] += ks[hook(3, 0)];
  X.v[hook(5, 1)] += ks[hook(3, 1)];
  if (Nrounds > 0) {
    X.v[hook(5, 0)] += X.v[hook(5, 1)];
    X.v[hook(5, 1)] = RotL_32(X.v[hook(5, 1)], R_32x2_0_0);
    X.v[hook(5, 1)] ^= X.v[hook(5, 0)];
  }
  if (Nrounds > 1) {
    X.v[hook(5, 0)] += X.v[hook(5, 1)];
    X.v[hook(5, 1)] = RotL_32(X.v[hook(5, 1)], R_32x2_1_0);
    X.v[hook(5, 1)] ^= X.v[hook(5, 0)];
  }
  if (Nrounds > 2) {
    X.v[hook(5, 0)] += X.v[hook(5, 1)];
    X.v[hook(5, 1)] = RotL_32(X.v[hook(5, 1)], R_32x2_2_0);
    X.v[hook(5, 1)] ^= X.v[hook(5, 0)];
  }
  if (Nrounds > 3) {
    X.v[hook(5, 0)] += X.v[hook(5, 1)];
    X.v[hook(5, 1)] = RotL_32(X.v[hook(5, 1)], R_32x2_3_0);
    X.v[hook(5, 1)] ^= X.v[hook(5, 0)];
  }
  if (Nrounds > 3) {
    X.v[hook(5, 0)] += ks[hook(3, 1)];
    X.v[hook(5, 1)] += ks[hook(3, 2)];
    X.v[hook(5, 1)] += 1;
  }
  if (Nrounds > 4) {
    X.v[hook(5, 0)] += X.v[hook(5, 1)];
    X.v[hook(5, 1)] = RotL_32(X.v[hook(5, 1)], R_32x2_4_0);
    X.v[hook(5, 1)] ^= X.v[hook(5, 0)];
  }
  if (Nrounds > 5) {
    X.v[hook(5, 0)] += X.v[hook(5, 1)];
    X.v[hook(5, 1)] = RotL_32(X.v[hook(5, 1)], R_32x2_5_0);
    X.v[hook(5, 1)] ^= X.v[hook(5, 0)];
  }
  if (Nrounds > 6) {
    X.v[hook(5, 0)] += X.v[hook(5, 1)];
    X.v[hook(5, 1)] = RotL_32(X.v[hook(5, 1)], R_32x2_6_0);
    X.v[hook(5, 1)] ^= X.v[hook(5, 0)];
  }
  if (Nrounds > 7) {
    X.v[hook(5, 0)] += X.v[hook(5, 1)];
    X.v[hook(5, 1)] = RotL_32(X.v[hook(5, 1)], R_32x2_7_0);
    X.v[hook(5, 1)] ^= X.v[hook(5, 0)];
  }
  if (Nrounds > 7) {
    X.v[hook(5, 0)] += ks[hook(3, 2)];
    X.v[hook(5, 1)] += ks[hook(3, 0)];
    X.v[hook(5, 1)] += 2;
  }
  if (Nrounds > 8) {
    X.v[hook(5, 0)] += X.v[hook(5, 1)];
    X.v[hook(5, 1)] = RotL_32(X.v[hook(5, 1)], R_32x2_0_0);
    X.v[hook(5, 1)] ^= X.v[hook(5, 0)];
  }
  if (Nrounds > 9) {
    X.v[hook(5, 0)] += X.v[hook(5, 1)];
    X.v[hook(5, 1)] = RotL_32(X.v[hook(5, 1)], R_32x2_1_0);
    X.v[hook(5, 1)] ^= X.v[hook(5, 0)];
  }
  if (Nrounds > 10) {
    X.v[hook(5, 0)] += X.v[hook(5, 1)];
    X.v[hook(5, 1)] = RotL_32(X.v[hook(5, 1)], R_32x2_2_0);
    X.v[hook(5, 1)] ^= X.v[hook(5, 0)];
  }
  if (Nrounds > 11) {
    X.v[hook(5, 0)] += X.v[hook(5, 1)];
    X.v[hook(5, 1)] = RotL_32(X.v[hook(5, 1)], R_32x2_3_0);
    X.v[hook(5, 1)] ^= X.v[hook(5, 0)];
  }
  if (Nrounds > 11) {
    X.v[hook(5, 0)] += ks[hook(3, 0)];
    X.v[hook(5, 1)] += ks[hook(3, 1)];
    X.v[hook(5, 1)] += 3;
  }
  if (Nrounds > 12) {
    X.v[hook(5, 0)] += X.v[hook(5, 1)];
    X.v[hook(5, 1)] = RotL_32(X.v[hook(5, 1)], R_32x2_4_0);
    X.v[hook(5, 1)] ^= X.v[hook(5, 0)];
  }
  if (Nrounds > 13) {
    X.v[hook(5, 0)] += X.v[hook(5, 1)];
    X.v[hook(5, 1)] = RotL_32(X.v[hook(5, 1)], R_32x2_5_0);
    X.v[hook(5, 1)] ^= X.v[hook(5, 0)];
  }
  if (Nrounds > 14) {
    X.v[hook(5, 0)] += X.v[hook(5, 1)];
    X.v[hook(5, 1)] = RotL_32(X.v[hook(5, 1)], R_32x2_6_0);
    X.v[hook(5, 1)] ^= X.v[hook(5, 0)];
  }
  if (Nrounds > 15) {
    X.v[hook(5, 0)] += X.v[hook(5, 1)];
    X.v[hook(5, 1)] = RotL_32(X.v[hook(5, 1)], R_32x2_7_0);
    X.v[hook(5, 1)] ^= X.v[hook(5, 0)];
  }
  if (Nrounds > 15) {
    X.v[hook(5, 0)] += ks[hook(3, 1)];
    X.v[hook(5, 1)] += ks[hook(3, 2)];
    X.v[hook(5, 1)] += 4;
  }
  if (Nrounds > 16) {
    X.v[hook(5, 0)] += X.v[hook(5, 1)];
    X.v[hook(5, 1)] = RotL_32(X.v[hook(5, 1)], R_32x2_0_0);
    X.v[hook(5, 1)] ^= X.v[hook(5, 0)];
  }
  if (Nrounds > 17) {
    X.v[hook(5, 0)] += X.v[hook(5, 1)];
    X.v[hook(5, 1)] = RotL_32(X.v[hook(5, 1)], R_32x2_1_0);
    X.v[hook(5, 1)] ^= X.v[hook(5, 0)];
  }
  if (Nrounds > 18) {
    X.v[hook(5, 0)] += X.v[hook(5, 1)];
    X.v[hook(5, 1)] = RotL_32(X.v[hook(5, 1)], R_32x2_2_0);
    X.v[hook(5, 1)] ^= X.v[hook(5, 0)];
  }
  if (Nrounds > 19) {
    X.v[hook(5, 0)] += X.v[hook(5, 1)];
    X.v[hook(5, 1)] = RotL_32(X.v[hook(5, 1)], R_32x2_3_0);
    X.v[hook(5, 1)] ^= X.v[hook(5, 0)];
  }
  if (Nrounds > 19) {
    X.v[hook(5, 0)] += ks[hook(3, 2)];
    X.v[hook(5, 1)] += ks[hook(3, 0)];
    X.v[hook(5, 1)] += 5;
  }
  if (Nrounds > 20) {
    X.v[hook(5, 0)] += X.v[hook(5, 1)];
    X.v[hook(5, 1)] = RotL_32(X.v[hook(5, 1)], R_32x2_4_0);
    X.v[hook(5, 1)] ^= X.v[hook(5, 0)];
  }
  if (Nrounds > 21) {
    X.v[hook(5, 0)] += X.v[hook(5, 1)];
    X.v[hook(5, 1)] = RotL_32(X.v[hook(5, 1)], R_32x2_5_0);
    X.v[hook(5, 1)] ^= X.v[hook(5, 0)];
  }
  if (Nrounds > 22) {
    X.v[hook(5, 0)] += X.v[hook(5, 1)];
    X.v[hook(5, 1)] = RotL_32(X.v[hook(5, 1)], R_32x2_6_0);
    X.v[hook(5, 1)] ^= X.v[hook(5, 0)];
  }
  if (Nrounds > 23) {
    X.v[hook(5, 0)] += X.v[hook(5, 1)];
    X.v[hook(5, 1)] = RotL_32(X.v[hook(5, 1)], R_32x2_7_0);
    X.v[hook(5, 1)] ^= X.v[hook(5, 0)];
  }
  if (Nrounds > 23) {
    X.v[hook(5, 0)] += ks[hook(3, 0)];
    X.v[hook(5, 1)] += ks[hook(3, 1)];
    X.v[hook(5, 1)] += 6;
  }
  if (Nrounds > 24) {
    X.v[hook(5, 0)] += X.v[hook(5, 1)];
    X.v[hook(5, 1)] = RotL_32(X.v[hook(5, 1)], R_32x2_0_0);
    X.v[hook(5, 1)] ^= X.v[hook(5, 0)];
  }
  if (Nrounds > 25) {
    X.v[hook(5, 0)] += X.v[hook(5, 1)];
    X.v[hook(5, 1)] = RotL_32(X.v[hook(5, 1)], R_32x2_1_0);
    X.v[hook(5, 1)] ^= X.v[hook(5, 0)];
  }
  if (Nrounds > 26) {
    X.v[hook(5, 0)] += X.v[hook(5, 1)];
    X.v[hook(5, 1)] = RotL_32(X.v[hook(5, 1)], R_32x2_2_0);
    X.v[hook(5, 1)] ^= X.v[hook(5, 0)];
  }
  if (Nrounds > 27) {
    X.v[hook(5, 0)] += X.v[hook(5, 1)];
    X.v[hook(5, 1)] = RotL_32(X.v[hook(5, 1)], R_32x2_3_0);
    X.v[hook(5, 1)] ^= X.v[hook(5, 0)];
  }
  if (Nrounds > 27) {
    X.v[hook(5, 0)] += ks[hook(3, 1)];
    X.v[hook(5, 1)] += ks[hook(3, 2)];
    X.v[hook(5, 1)] += 7;
  }
  if (Nrounds > 28) {
    X.v[hook(5, 0)] += X.v[hook(5, 1)];
    X.v[hook(5, 1)] = RotL_32(X.v[hook(5, 1)], R_32x2_4_0);
    X.v[hook(5, 1)] ^= X.v[hook(5, 0)];
  }
  if (Nrounds > 29) {
    X.v[hook(5, 0)] += X.v[hook(5, 1)];
    X.v[hook(5, 1)] = RotL_32(X.v[hook(5, 1)], R_32x2_5_0);
    X.v[hook(5, 1)] ^= X.v[hook(5, 0)];
  }
  if (Nrounds > 30) {
    X.v[hook(5, 0)] += X.v[hook(5, 1)];
    X.v[hook(5, 1)] = RotL_32(X.v[hook(5, 1)], R_32x2_6_0);
    X.v[hook(5, 1)] ^= X.v[hook(5, 0)];
  }
  if (Nrounds > 31) {
    X.v[hook(5, 0)] += X.v[hook(5, 1)];
    X.v[hook(5, 1)] = RotL_32(X.v[hook(5, 1)], R_32x2_7_0);
    X.v[hook(5, 1)] ^= X.v[hook(5, 0)];
  }
  if (Nrounds > 31) {
    X.v[hook(5, 0)] += ks[hook(3, 2)];
    X.v[hook(5, 1)] += ks[hook(3, 0)];
    X.v[hook(5, 1)] += 8;
  }
  return X;
}

kernel void generate_rng(global unsigned int* ctr, global unsigned int* key, const unsigned int offset) {
  threefry2x32_ctr_t in;
  threefry2x32_key_t k;
  const unsigned int i = get_global_id(0);
  in.v[hook(6, 0)] = ctr[hook(0, 2 * (offset + i))];
  in.v[hook(6, 1)] = ctr[hook(0, 2 * (offset + i) + 1)];
  k.v[hook(4, 0)] = key[hook(1, 2 * (offset + i))];
  k.v[hook(4, 1)] = key[hook(1, 2 * (offset + i) + 1)];
  in = threefry2x32_R(20, in, k);
  ctr[hook(0, 2 * (offset + i))] = in.v[hook(6, 0)];
  ctr[hook(0, 2 * (offset + i) + 1)] = in.v[hook(6, 1)];
}