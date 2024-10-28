//{"E":2,"V":3,"X.v":8,"ctr_i":1,"in.v":9,"k.v":7,"ks":6,"nrounds":4,"numrandom":5,"random1.v":12,"random2.v":13,"randomnumber":0,"ukey1.v":10,"ukey2.v":11}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
typedef unsigned int uint32_t;
struct r123array4x32 {
  uint32_t v[4];
};

enum r123_enum_threefry32x4 { R_32x4_0_0 = 10, R_32x4_0_1 = 26, R_32x4_1_0 = 11, R_32x4_1_1 = 21, R_32x4_2_0 = 13, R_32x4_2_1 = 27, R_32x4_3_0 = 23, R_32x4_3_1 = 5, R_32x4_4_0 = 6, R_32x4_4_1 = 20, R_32x4_5_0 = 17, R_32x4_5_1 = 11, R_32x4_6_0 = 25, R_32x4_6_1 = 10, R_32x4_7_0 = 18, R_32x4_7_1 = 20 };

inline uint32_t RotL_32(uint32_t x, unsigned int N) {
  return (x << (N & 31)) | (x >> ((32 - N) & 31));
}

typedef struct r123array4x32 threefry4x32_ctr_t;
typedef struct r123array4x32 threefry4x32_key_t;
typedef struct r123array4x32 threefry4x32_ukey_t;

inline threefry4x32_ctr_t threefry4x32_R(unsigned int Nrounds, threefry4x32_ctr_t in, threefry4x32_key_t k) {
  threefry4x32_ctr_t X;
  uint32_t ks[4 + 1];
  int i;
  ks[hook(6, 4)] = 0x1BD11BDA;

  {
    ks[hook(6, 0)] = k.v[hook(7, 0)];
    X.v[hook(8, 0)] = in.v[hook(9, 0)];
    ks[hook(6, 4)] ^= k.v[hook(7, 0)];

    ks[hook(6, 1)] = k.v[hook(7, 1)];
    X.v[hook(8, 1)] = in.v[hook(9, 1)];
    ks[hook(6, 4)] ^= k.v[hook(7, 1)];

    ks[hook(6, 2)] = k.v[hook(7, 2)];
    X.v[hook(8, 2)] = in.v[hook(9, 2)];
    ks[hook(6, 4)] ^= k.v[hook(7, 2)];

    ks[hook(6, 3)] = k.v[hook(7, 3)];
    X.v[hook(8, 3)] = in.v[hook(9, 3)];
    ks[hook(6, 4)] ^= k.v[hook(7, 3)];
  }

  X.v[hook(8, 0)] += ks[hook(6, 0)];
  X.v[hook(8, 1)] += ks[hook(6, 1)];
  X.v[hook(8, 2)] += ks[hook(6, 2)];
  X.v[hook(8, 3)] += ks[hook(6, 3)];

  if (Nrounds > 0) {
    X.v[hook(8, 0)] += X.v[hook(8, 1)];
    X.v[hook(8, 1)] = RotL_32(X.v[hook(8, 1)], R_32x4_0_0);
    X.v[hook(8, 1)] ^= X.v[hook(8, 0)];
    X.v[hook(8, 2)] += X.v[hook(8, 3)];
    X.v[hook(8, 3)] = RotL_32(X.v[hook(8, 3)], R_32x4_0_1);
    X.v[hook(8, 3)] ^= X.v[hook(8, 2)];
  }

  if (Nrounds > 1) {
    X.v[hook(8, 0)] += X.v[hook(8, 3)];
    X.v[hook(8, 3)] = RotL_32(X.v[hook(8, 3)], R_32x4_1_0);
    X.v[hook(8, 3)] ^= X.v[hook(8, 0)];
    X.v[hook(8, 2)] += X.v[hook(8, 1)];
    X.v[hook(8, 1)] = RotL_32(X.v[hook(8, 1)], R_32x4_1_1);
    X.v[hook(8, 1)] ^= X.v[hook(8, 2)];
  }

  if (Nrounds > 2) {
    X.v[hook(8, 0)] += X.v[hook(8, 1)];
    X.v[hook(8, 1)] = RotL_32(X.v[hook(8, 1)], R_32x4_2_0);
    X.v[hook(8, 1)] ^= X.v[hook(8, 0)];
    X.v[hook(8, 2)] += X.v[hook(8, 3)];
    X.v[hook(8, 3)] = RotL_32(X.v[hook(8, 3)], R_32x4_2_1);
    X.v[hook(8, 3)] ^= X.v[hook(8, 2)];
  }

  if (Nrounds > 3) {
    X.v[hook(8, 0)] += X.v[hook(8, 3)];
    X.v[hook(8, 3)] = RotL_32(X.v[hook(8, 3)], R_32x4_3_0);
    X.v[hook(8, 3)] ^= X.v[hook(8, 0)];
    X.v[hook(8, 2)] += X.v[hook(8, 1)];
    X.v[hook(8, 1)] = RotL_32(X.v[hook(8, 1)], R_32x4_3_1);
    X.v[hook(8, 1)] ^= X.v[hook(8, 2)];
  }

  if (Nrounds > 3) {
    X.v[hook(8, 0)] += ks[hook(6, 1)];
    X.v[hook(8, 1)] += ks[hook(6, 2)];
    X.v[hook(8, 2)] += ks[hook(6, 3)];
    X.v[hook(8, 3)] += ks[hook(6, 4)];
    X.v[hook(8, 4 - 1)] += 1;
  }

  if (Nrounds > 4) {
    X.v[hook(8, 0)] += X.v[hook(8, 1)];
    X.v[hook(8, 1)] = RotL_32(X.v[hook(8, 1)], R_32x4_4_0);
    X.v[hook(8, 1)] ^= X.v[hook(8, 0)];
    X.v[hook(8, 2)] += X.v[hook(8, 3)];
    X.v[hook(8, 3)] = RotL_32(X.v[hook(8, 3)], R_32x4_4_1);
    X.v[hook(8, 3)] ^= X.v[hook(8, 2)];
  }

  if (Nrounds > 5) {
    X.v[hook(8, 0)] += X.v[hook(8, 3)];
    X.v[hook(8, 3)] = RotL_32(X.v[hook(8, 3)], R_32x4_5_0);
    X.v[hook(8, 3)] ^= X.v[hook(8, 0)];
    X.v[hook(8, 2)] += X.v[hook(8, 1)];
    X.v[hook(8, 1)] = RotL_32(X.v[hook(8, 1)], R_32x4_5_1);
    X.v[hook(8, 1)] ^= X.v[hook(8, 2)];
  }

  if (Nrounds > 6) {
    X.v[hook(8, 0)] += X.v[hook(8, 1)];
    X.v[hook(8, 1)] = RotL_32(X.v[hook(8, 1)], R_32x4_6_0);
    X.v[hook(8, 1)] ^= X.v[hook(8, 0)];
    X.v[hook(8, 2)] += X.v[hook(8, 3)];
    X.v[hook(8, 3)] = RotL_32(X.v[hook(8, 3)], R_32x4_6_1);
    X.v[hook(8, 3)] ^= X.v[hook(8, 2)];
  }

  if (Nrounds > 7) {
    X.v[hook(8, 0)] += X.v[hook(8, 3)];
    X.v[hook(8, 3)] = RotL_32(X.v[hook(8, 3)], R_32x4_7_0);
    X.v[hook(8, 3)] ^= X.v[hook(8, 0)];
    X.v[hook(8, 2)] += X.v[hook(8, 1)];
    X.v[hook(8, 1)] = RotL_32(X.v[hook(8, 1)], R_32x4_7_1);
    X.v[hook(8, 1)] ^= X.v[hook(8, 2)];
  }

  if (Nrounds > 7) {
    X.v[hook(8, 0)] += ks[hook(6, 2)];
    X.v[hook(8, 1)] += ks[hook(6, 3)];
    X.v[hook(8, 2)] += ks[hook(6, 4)];
    X.v[hook(8, 3)] += ks[hook(6, 0)];
    X.v[hook(8, 4 - 1)] += 2;
  }

  if (Nrounds > 8) {
    X.v[hook(8, 0)] += X.v[hook(8, 1)];
    X.v[hook(8, 1)] = RotL_32(X.v[hook(8, 1)], R_32x4_0_0);
    X.v[hook(8, 1)] ^= X.v[hook(8, 0)];
    X.v[hook(8, 2)] += X.v[hook(8, 3)];
    X.v[hook(8, 3)] = RotL_32(X.v[hook(8, 3)], R_32x4_0_1);
    X.v[hook(8, 3)] ^= X.v[hook(8, 2)];
  }

  if (Nrounds > 9) {
    X.v[hook(8, 0)] += X.v[hook(8, 3)];
    X.v[hook(8, 3)] = RotL_32(X.v[hook(8, 3)], R_32x4_1_0);
    X.v[hook(8, 3)] ^= X.v[hook(8, 0)];
    X.v[hook(8, 2)] += X.v[hook(8, 1)];
    X.v[hook(8, 1)] = RotL_32(X.v[hook(8, 1)], R_32x4_1_1);
    X.v[hook(8, 1)] ^= X.v[hook(8, 2)];
  }

  if (Nrounds > 10) {
    X.v[hook(8, 0)] += X.v[hook(8, 1)];
    X.v[hook(8, 1)] = RotL_32(X.v[hook(8, 1)], R_32x4_2_0);
    X.v[hook(8, 1)] ^= X.v[hook(8, 0)];
    X.v[hook(8, 2)] += X.v[hook(8, 3)];
    X.v[hook(8, 3)] = RotL_32(X.v[hook(8, 3)], R_32x4_2_1);
    X.v[hook(8, 3)] ^= X.v[hook(8, 2)];
  }

  if (Nrounds > 11) {
    X.v[hook(8, 0)] += X.v[hook(8, 3)];
    X.v[hook(8, 3)] = RotL_32(X.v[hook(8, 3)], R_32x4_3_0);
    X.v[hook(8, 3)] ^= X.v[hook(8, 0)];
    X.v[hook(8, 2)] += X.v[hook(8, 1)];
    X.v[hook(8, 1)] = RotL_32(X.v[hook(8, 1)], R_32x4_3_1);
    X.v[hook(8, 1)] ^= X.v[hook(8, 2)];
  }

  if (Nrounds > 11) {
    X.v[hook(8, 0)] += ks[hook(6, 3)];
    X.v[hook(8, 1)] += ks[hook(6, 4)];
    X.v[hook(8, 2)] += ks[hook(6, 0)];
    X.v[hook(8, 3)] += ks[hook(6, 1)];
    X.v[hook(8, 4 - 1)] += 3;
  }

  if (Nrounds > 12) {
    X.v[hook(8, 0)] += X.v[hook(8, 1)];
    X.v[hook(8, 1)] = RotL_32(X.v[hook(8, 1)], R_32x4_4_0);
    X.v[hook(8, 1)] ^= X.v[hook(8, 0)];
    X.v[hook(8, 2)] += X.v[hook(8, 3)];
    X.v[hook(8, 3)] = RotL_32(X.v[hook(8, 3)], R_32x4_4_1);
    X.v[hook(8, 3)] ^= X.v[hook(8, 2)];
  }

  if (Nrounds > 13) {
    X.v[hook(8, 0)] += X.v[hook(8, 3)];
    X.v[hook(8, 3)] = RotL_32(X.v[hook(8, 3)], R_32x4_5_0);
    X.v[hook(8, 3)] ^= X.v[hook(8, 0)];
    X.v[hook(8, 2)] += X.v[hook(8, 1)];
    X.v[hook(8, 1)] = RotL_32(X.v[hook(8, 1)], R_32x4_5_1);
    X.v[hook(8, 1)] ^= X.v[hook(8, 2)];
  }

  if (Nrounds > 14) {
    X.v[hook(8, 0)] += X.v[hook(8, 1)];
    X.v[hook(8, 1)] = RotL_32(X.v[hook(8, 1)], R_32x4_6_0);
    X.v[hook(8, 1)] ^= X.v[hook(8, 0)];
    X.v[hook(8, 2)] += X.v[hook(8, 3)];
    X.v[hook(8, 3)] = RotL_32(X.v[hook(8, 3)], R_32x4_6_1);
    X.v[hook(8, 3)] ^= X.v[hook(8, 2)];
  }

  if (Nrounds > 15) {
    X.v[hook(8, 0)] += X.v[hook(8, 3)];
    X.v[hook(8, 3)] = RotL_32(X.v[hook(8, 3)], R_32x4_7_0);
    X.v[hook(8, 3)] ^= X.v[hook(8, 0)];
    X.v[hook(8, 2)] += X.v[hook(8, 1)];
    X.v[hook(8, 1)] = RotL_32(X.v[hook(8, 1)], R_32x4_7_1);
    X.v[hook(8, 1)] ^= X.v[hook(8, 2)];
  }

  if (Nrounds > 15) {
    X.v[hook(8, 0)] += ks[hook(6, 4)];
    X.v[hook(8, 1)] += ks[hook(6, 0)];
    X.v[hook(8, 2)] += ks[hook(6, 1)];
    X.v[hook(8, 3)] += ks[hook(6, 2)];
    X.v[hook(8, 4 - 1)] += 4;
  }

  if (Nrounds > 16) {
    X.v[hook(8, 0)] += X.v[hook(8, 1)];
    X.v[hook(8, 1)] = RotL_32(X.v[hook(8, 1)], R_32x4_0_0);
    X.v[hook(8, 1)] ^= X.v[hook(8, 0)];
    X.v[hook(8, 2)] += X.v[hook(8, 3)];
    X.v[hook(8, 3)] = RotL_32(X.v[hook(8, 3)], R_32x4_0_1);
    X.v[hook(8, 3)] ^= X.v[hook(8, 2)];
  }

  if (Nrounds > 17) {
    X.v[hook(8, 0)] += X.v[hook(8, 3)];
    X.v[hook(8, 3)] = RotL_32(X.v[hook(8, 3)], R_32x4_1_0);
    X.v[hook(8, 3)] ^= X.v[hook(8, 0)];
    X.v[hook(8, 2)] += X.v[hook(8, 1)];
    X.v[hook(8, 1)] = RotL_32(X.v[hook(8, 1)], R_32x4_1_1);
    X.v[hook(8, 1)] ^= X.v[hook(8, 2)];
  }

  if (Nrounds > 18) {
    X.v[hook(8, 0)] += X.v[hook(8, 1)];
    X.v[hook(8, 1)] = RotL_32(X.v[hook(8, 1)], R_32x4_2_0);
    X.v[hook(8, 1)] ^= X.v[hook(8, 0)];
    X.v[hook(8, 2)] += X.v[hook(8, 3)];
    X.v[hook(8, 3)] = RotL_32(X.v[hook(8, 3)], R_32x4_2_1);
    X.v[hook(8, 3)] ^= X.v[hook(8, 2)];
  }

  if (Nrounds > 19) {
    X.v[hook(8, 0)] += X.v[hook(8, 3)];
    X.v[hook(8, 3)] = RotL_32(X.v[hook(8, 3)], R_32x4_3_0);
    X.v[hook(8, 3)] ^= X.v[hook(8, 0)];
    X.v[hook(8, 2)] += X.v[hook(8, 1)];
    X.v[hook(8, 1)] = RotL_32(X.v[hook(8, 1)], R_32x4_3_1);
    X.v[hook(8, 1)] ^= X.v[hook(8, 2)];
  }

  if (Nrounds > 19) {
    X.v[hook(8, 0)] += ks[hook(6, 0)];
    X.v[hook(8, 1)] += ks[hook(6, 1)];
    X.v[hook(8, 2)] += ks[hook(6, 2)];
    X.v[hook(8, 3)] += ks[hook(6, 3)];
    X.v[hook(8, 4 - 1)] += 5;
  }

  if (Nrounds > 20) {
    X.v[hook(8, 0)] += X.v[hook(8, 1)];
    X.v[hook(8, 1)] = RotL_32(X.v[hook(8, 1)], R_32x4_4_0);
    X.v[hook(8, 1)] ^= X.v[hook(8, 0)];
    X.v[hook(8, 2)] += X.v[hook(8, 3)];
    X.v[hook(8, 3)] = RotL_32(X.v[hook(8, 3)], R_32x4_4_1);
    X.v[hook(8, 3)] ^= X.v[hook(8, 2)];
  }

  if (Nrounds > 21) {
    X.v[hook(8, 0)] += X.v[hook(8, 3)];
    X.v[hook(8, 3)] = RotL_32(X.v[hook(8, 3)], R_32x4_5_0);
    X.v[hook(8, 3)] ^= X.v[hook(8, 0)];
    X.v[hook(8, 2)] += X.v[hook(8, 1)];
    X.v[hook(8, 1)] = RotL_32(X.v[hook(8, 1)], R_32x4_5_1);
    X.v[hook(8, 1)] ^= X.v[hook(8, 2)];
  }

  if (Nrounds > 22) {
    X.v[hook(8, 0)] += X.v[hook(8, 1)];
    X.v[hook(8, 1)] = RotL_32(X.v[hook(8, 1)], R_32x4_6_0);
    X.v[hook(8, 1)] ^= X.v[hook(8, 0)];
    X.v[hook(8, 2)] += X.v[hook(8, 3)];
    X.v[hook(8, 3)] = RotL_32(X.v[hook(8, 3)], R_32x4_6_1);
    X.v[hook(8, 3)] ^= X.v[hook(8, 2)];
  }

  if (Nrounds > 23) {
    X.v[hook(8, 0)] += X.v[hook(8, 3)];
    X.v[hook(8, 3)] = RotL_32(X.v[hook(8, 3)], R_32x4_7_0);
    X.v[hook(8, 3)] ^= X.v[hook(8, 0)];
    X.v[hook(8, 2)] += X.v[hook(8, 1)];
    X.v[hook(8, 1)] = RotL_32(X.v[hook(8, 1)], R_32x4_7_1);
    X.v[hook(8, 1)] ^= X.v[hook(8, 2)];
  }

  if (Nrounds > 23) {
    X.v[hook(8, 0)] += ks[hook(6, 1)];
    X.v[hook(8, 1)] += ks[hook(6, 2)];
    X.v[hook(8, 2)] += ks[hook(6, 3)];
    X.v[hook(8, 3)] += ks[hook(6, 4)];
    X.v[hook(8, 4 - 1)] += 6;
  }

  if (Nrounds > 24) {
    X.v[hook(8, 0)] += X.v[hook(8, 1)];
    X.v[hook(8, 1)] = RotL_32(X.v[hook(8, 1)], R_32x4_0_0);
    X.v[hook(8, 1)] ^= X.v[hook(8, 0)];
    X.v[hook(8, 2)] += X.v[hook(8, 3)];
    X.v[hook(8, 3)] = RotL_32(X.v[hook(8, 3)], R_32x4_0_1);
    X.v[hook(8, 3)] ^= X.v[hook(8, 2)];
  }

  if (Nrounds > 25) {
    X.v[hook(8, 0)] += X.v[hook(8, 3)];
    X.v[hook(8, 3)] = RotL_32(X.v[hook(8, 3)], R_32x4_1_0);
    X.v[hook(8, 3)] ^= X.v[hook(8, 0)];
    X.v[hook(8, 2)] += X.v[hook(8, 1)];
    X.v[hook(8, 1)] = RotL_32(X.v[hook(8, 1)], R_32x4_1_1);
    X.v[hook(8, 1)] ^= X.v[hook(8, 2)];
  }

  if (Nrounds > 26) {
    X.v[hook(8, 0)] += X.v[hook(8, 1)];
    X.v[hook(8, 1)] = RotL_32(X.v[hook(8, 1)], R_32x4_2_0);
    X.v[hook(8, 1)] ^= X.v[hook(8, 0)];
    X.v[hook(8, 2)] += X.v[hook(8, 3)];
    X.v[hook(8, 3)] = RotL_32(X.v[hook(8, 3)], R_32x4_2_1);
    X.v[hook(8, 3)] ^= X.v[hook(8, 2)];
  }

  if (Nrounds > 27) {
    X.v[hook(8, 0)] += X.v[hook(8, 3)];
    X.v[hook(8, 3)] = RotL_32(X.v[hook(8, 3)], R_32x4_3_0);
    X.v[hook(8, 3)] ^= X.v[hook(8, 0)];
    X.v[hook(8, 2)] += X.v[hook(8, 1)];
    X.v[hook(8, 1)] = RotL_32(X.v[hook(8, 1)], R_32x4_3_1);
    X.v[hook(8, 1)] ^= X.v[hook(8, 2)];
  }

  if (Nrounds > 27) {
    X.v[hook(8, 0)] += ks[hook(6, 2)];
    X.v[hook(8, 1)] += ks[hook(6, 3)];
    X.v[hook(8, 2)] += ks[hook(6, 4)];
    X.v[hook(8, 3)] += ks[hook(6, 0)];
    X.v[hook(8, 4 - 1)] += 7;
  }

  if (Nrounds > 28) {
    X.v[hook(8, 0)] += X.v[hook(8, 1)];
    X.v[hook(8, 1)] = RotL_32(X.v[hook(8, 1)], R_32x4_4_0);
    X.v[hook(8, 1)] ^= X.v[hook(8, 0)];
    X.v[hook(8, 2)] += X.v[hook(8, 3)];
    X.v[hook(8, 3)] = RotL_32(X.v[hook(8, 3)], R_32x4_4_1);
    X.v[hook(8, 3)] ^= X.v[hook(8, 2)];
  }

  if (Nrounds > 29) {
    X.v[hook(8, 0)] += X.v[hook(8, 3)];
    X.v[hook(8, 3)] = RotL_32(X.v[hook(8, 3)], R_32x4_5_0);
    X.v[hook(8, 3)] ^= X.v[hook(8, 0)];
    X.v[hook(8, 2)] += X.v[hook(8, 1)];
    X.v[hook(8, 1)] = RotL_32(X.v[hook(8, 1)], R_32x4_5_1);
    X.v[hook(8, 1)] ^= X.v[hook(8, 2)];
  }

  if (Nrounds > 30) {
    X.v[hook(8, 0)] += X.v[hook(8, 1)];
    X.v[hook(8, 1)] = RotL_32(X.v[hook(8, 1)], R_32x4_6_0);
    X.v[hook(8, 1)] ^= X.v[hook(8, 0)];
    X.v[hook(8, 2)] += X.v[hook(8, 3)];
    X.v[hook(8, 3)] = RotL_32(X.v[hook(8, 3)], R_32x4_6_1);
    X.v[hook(8, 3)] ^= X.v[hook(8, 2)];
  }

  if (Nrounds > 31) {
    X.v[hook(8, 0)] += X.v[hook(8, 3)];
    X.v[hook(8, 3)] = RotL_32(X.v[hook(8, 3)], R_32x4_7_0);
    X.v[hook(8, 3)] ^= X.v[hook(8, 0)];
    X.v[hook(8, 2)] += X.v[hook(8, 1)];
    X.v[hook(8, 1)] = RotL_32(X.v[hook(8, 1)], R_32x4_7_1);
    X.v[hook(8, 1)] ^= X.v[hook(8, 2)];
  }

  if (Nrounds > 31) {
    X.v[hook(8, 0)] += ks[hook(6, 3)];
    X.v[hook(8, 1)] += ks[hook(6, 4)];
    X.v[hook(8, 2)] += ks[hook(6, 0)];
    X.v[hook(8, 3)] += ks[hook(6, 1)];
    X.v[hook(8, 4 - 1)] += 8;
  }

  if (Nrounds > 32) {
    X.v[hook(8, 0)] += X.v[hook(8, 1)];
    X.v[hook(8, 1)] = RotL_32(X.v[hook(8, 1)], R_32x4_0_0);
    X.v[hook(8, 1)] ^= X.v[hook(8, 0)];
    X.v[hook(8, 2)] += X.v[hook(8, 3)];
    X.v[hook(8, 3)] = RotL_32(X.v[hook(8, 3)], R_32x4_0_1);
    X.v[hook(8, 3)] ^= X.v[hook(8, 2)];
  }

  if (Nrounds > 33) {
    X.v[hook(8, 0)] += X.v[hook(8, 3)];
    X.v[hook(8, 3)] = RotL_32(X.v[hook(8, 3)], R_32x4_1_0);
    X.v[hook(8, 3)] ^= X.v[hook(8, 0)];
    X.v[hook(8, 2)] += X.v[hook(8, 1)];
    X.v[hook(8, 1)] = RotL_32(X.v[hook(8, 1)], R_32x4_1_1);
    X.v[hook(8, 1)] ^= X.v[hook(8, 2)];
  }

  if (Nrounds > 34) {
    X.v[hook(8, 0)] += X.v[hook(8, 1)];
    X.v[hook(8, 1)] = RotL_32(X.v[hook(8, 1)], R_32x4_2_0);
    X.v[hook(8, 1)] ^= X.v[hook(8, 0)];
    X.v[hook(8, 2)] += X.v[hook(8, 3)];
    X.v[hook(8, 3)] = RotL_32(X.v[hook(8, 3)], R_32x4_2_1);
    X.v[hook(8, 3)] ^= X.v[hook(8, 2)];
  }

  if (Nrounds > 35) {
    X.v[hook(8, 0)] += X.v[hook(8, 3)];
    X.v[hook(8, 3)] = RotL_32(X.v[hook(8, 3)], R_32x4_3_0);
    X.v[hook(8, 3)] ^= X.v[hook(8, 0)];
    X.v[hook(8, 2)] += X.v[hook(8, 1)];
    X.v[hook(8, 1)] = RotL_32(X.v[hook(8, 1)], R_32x4_3_1);
    X.v[hook(8, 1)] ^= X.v[hook(8, 2)];
  }

  if (Nrounds > 35) {
    X.v[hook(8, 0)] += ks[hook(6, 4)];
    X.v[hook(8, 1)] += ks[hook(6, 0)];
    X.v[hook(8, 2)] += ks[hook(6, 1)];
    X.v[hook(8, 3)] += ks[hook(6, 2)];
    X.v[hook(8, 4 - 1)] += 9;
  }

  if (Nrounds > 36) {
    X.v[hook(8, 0)] += X.v[hook(8, 1)];
    X.v[hook(8, 1)] = RotL_32(X.v[hook(8, 1)], R_32x4_4_0);
    X.v[hook(8, 1)] ^= X.v[hook(8, 0)];
    X.v[hook(8, 2)] += X.v[hook(8, 3)];
    X.v[hook(8, 3)] = RotL_32(X.v[hook(8, 3)], R_32x4_4_1);
    X.v[hook(8, 3)] ^= X.v[hook(8, 2)];
  }

  if (Nrounds > 37) {
    X.v[hook(8, 0)] += X.v[hook(8, 3)];
    X.v[hook(8, 3)] = RotL_32(X.v[hook(8, 3)], R_32x4_5_0);
    X.v[hook(8, 3)] ^= X.v[hook(8, 0)];
    X.v[hook(8, 2)] += X.v[hook(8, 1)];
    X.v[hook(8, 1)] = RotL_32(X.v[hook(8, 1)], R_32x4_5_1);
    X.v[hook(8, 1)] ^= X.v[hook(8, 2)];
  }

  if (Nrounds > 38) {
    X.v[hook(8, 0)] += X.v[hook(8, 1)];
    X.v[hook(8, 1)] = RotL_32(X.v[hook(8, 1)], R_32x4_6_0);
    X.v[hook(8, 1)] ^= X.v[hook(8, 0)];
    X.v[hook(8, 2)] += X.v[hook(8, 3)];
    X.v[hook(8, 3)] = RotL_32(X.v[hook(8, 3)], R_32x4_6_1);
    X.v[hook(8, 3)] ^= X.v[hook(8, 2)];
  }

  if (Nrounds > 39) {
    X.v[hook(8, 0)] += X.v[hook(8, 3)];
    X.v[hook(8, 3)] = RotL_32(X.v[hook(8, 3)], R_32x4_7_0);
    X.v[hook(8, 3)] ^= X.v[hook(8, 0)];
    X.v[hook(8, 2)] += X.v[hook(8, 1)];
    X.v[hook(8, 1)] = RotL_32(X.v[hook(8, 1)], R_32x4_7_1);
    X.v[hook(8, 1)] ^= X.v[hook(8, 2)];
  }

  if (Nrounds > 39) {
    X.v[hook(8, 0)] += ks[hook(6, 0)];
    X.v[hook(8, 1)] += ks[hook(6, 1)];
    X.v[hook(8, 2)] += ks[hook(6, 2)];
    X.v[hook(8, 3)] += ks[hook(6, 3)];
    X.v[hook(8, 4 - 1)] += 10;
  }

  if (Nrounds > 40) {
    X.v[hook(8, 0)] += X.v[hook(8, 1)];
    X.v[hook(8, 1)] = RotL_32(X.v[hook(8, 1)], R_32x4_0_0);
    X.v[hook(8, 1)] ^= X.v[hook(8, 0)];
    X.v[hook(8, 2)] += X.v[hook(8, 3)];
    X.v[hook(8, 3)] = RotL_32(X.v[hook(8, 3)], R_32x4_0_1);
    X.v[hook(8, 3)] ^= X.v[hook(8, 2)];
  }

  if (Nrounds > 41) {
    X.v[hook(8, 0)] += X.v[hook(8, 3)];
    X.v[hook(8, 3)] = RotL_32(X.v[hook(8, 3)], R_32x4_1_0);
    X.v[hook(8, 3)] ^= X.v[hook(8, 0)];
    X.v[hook(8, 2)] += X.v[hook(8, 1)];
    X.v[hook(8, 1)] = RotL_32(X.v[hook(8, 1)], R_32x4_1_1);
    X.v[hook(8, 1)] ^= X.v[hook(8, 2)];
  }
  if (Nrounds > 42) {
    X.v[hook(8, 0)] += X.v[hook(8, 1)];
    X.v[hook(8, 1)] = RotL_32(X.v[hook(8, 1)], R_32x4_2_0);
    X.v[hook(8, 1)] ^= X.v[hook(8, 0)];
    X.v[hook(8, 2)] += X.v[hook(8, 3)];
    X.v[hook(8, 3)] = RotL_32(X.v[hook(8, 3)], R_32x4_2_1);
    X.v[hook(8, 3)] ^= X.v[hook(8, 2)];
  }

  if (Nrounds > 43) {
    X.v[hook(8, 0)] += X.v[hook(8, 3)];
    X.v[hook(8, 3)] = RotL_32(X.v[hook(8, 3)], R_32x4_3_0);
    X.v[hook(8, 3)] ^= X.v[hook(8, 0)];
    X.v[hook(8, 2)] += X.v[hook(8, 1)];
    X.v[hook(8, 1)] = RotL_32(X.v[hook(8, 1)], R_32x4_3_1);
    X.v[hook(8, 1)] ^= X.v[hook(8, 2)];
  }

  if (Nrounds > 43) {
    X.v[hook(8, 0)] += ks[hook(6, 1)];
    X.v[hook(8, 1)] += ks[hook(6, 2)];
    X.v[hook(8, 2)] += ks[hook(6, 3)];
    X.v[hook(8, 3)] += ks[hook(6, 4)];
    X.v[hook(8, 4 - 1)] += 11;
  }

  if (Nrounds > 44) {
    X.v[hook(8, 0)] += X.v[hook(8, 1)];
    X.v[hook(8, 1)] = RotL_32(X.v[hook(8, 1)], R_32x4_4_0);
    X.v[hook(8, 1)] ^= X.v[hook(8, 0)];
    X.v[hook(8, 2)] += X.v[hook(8, 3)];
    X.v[hook(8, 3)] = RotL_32(X.v[hook(8, 3)], R_32x4_4_1);
    X.v[hook(8, 3)] ^= X.v[hook(8, 2)];
  }

  if (Nrounds > 45) {
    X.v[hook(8, 0)] += X.v[hook(8, 3)];
    X.v[hook(8, 3)] = RotL_32(X.v[hook(8, 3)], R_32x4_5_0);
    X.v[hook(8, 3)] ^= X.v[hook(8, 0)];
    X.v[hook(8, 2)] += X.v[hook(8, 1)];
    X.v[hook(8, 1)] = RotL_32(X.v[hook(8, 1)], R_32x4_5_1);
    X.v[hook(8, 1)] ^= X.v[hook(8, 2)];
  }

  if (Nrounds > 46) {
    X.v[hook(8, 0)] += X.v[hook(8, 1)];
    X.v[hook(8, 1)] = RotL_32(X.v[hook(8, 1)], R_32x4_6_0);
    X.v[hook(8, 1)] ^= X.v[hook(8, 0)];
    X.v[hook(8, 2)] += X.v[hook(8, 3)];
    X.v[hook(8, 3)] = RotL_32(X.v[hook(8, 3)], R_32x4_6_1);
    X.v[hook(8, 3)] ^= X.v[hook(8, 2)];
  }

  if (Nrounds > 47) {
    X.v[hook(8, 0)] += X.v[hook(8, 3)];
    X.v[hook(8, 3)] = RotL_32(X.v[hook(8, 3)], R_32x4_7_0);
    X.v[hook(8, 3)] ^= X.v[hook(8, 0)];
    X.v[hook(8, 2)] += X.v[hook(8, 1)];
    X.v[hook(8, 1)] = RotL_32(X.v[hook(8, 1)], R_32x4_7_1);
    X.v[hook(8, 1)] ^= X.v[hook(8, 2)];
  }

  if (Nrounds > 47) {
    X.v[hook(8, 0)] += ks[hook(6, 2)];
    X.v[hook(8, 1)] += ks[hook(6, 3)];
    X.v[hook(8, 2)] += ks[hook(6, 4)];
    X.v[hook(8, 3)] += ks[hook(6, 0)];
    X.v[hook(8, 4 - 1)] += 12;
  }

  if (Nrounds > 48) {
    X.v[hook(8, 0)] += X.v[hook(8, 1)];
    X.v[hook(8, 1)] = RotL_32(X.v[hook(8, 1)], R_32x4_0_0);
    X.v[hook(8, 1)] ^= X.v[hook(8, 0)];
    X.v[hook(8, 2)] += X.v[hook(8, 3)];
    X.v[hook(8, 3)] = RotL_32(X.v[hook(8, 3)], R_32x4_0_1);
    X.v[hook(8, 3)] ^= X.v[hook(8, 2)];
  }

  if (Nrounds > 49) {
    X.v[hook(8, 0)] += X.v[hook(8, 3)];
    X.v[hook(8, 3)] = RotL_32(X.v[hook(8, 3)], R_32x4_1_0);
    X.v[hook(8, 3)] ^= X.v[hook(8, 0)];
    X.v[hook(8, 2)] += X.v[hook(8, 1)];
    X.v[hook(8, 1)] = RotL_32(X.v[hook(8, 1)], R_32x4_1_1);
    X.v[hook(8, 1)] ^= X.v[hook(8, 2)];
  }

  if (Nrounds > 50) {
    X.v[hook(8, 0)] += X.v[hook(8, 1)];
    X.v[hook(8, 1)] = RotL_32(X.v[hook(8, 1)], R_32x4_2_0);
    X.v[hook(8, 1)] ^= X.v[hook(8, 0)];
    X.v[hook(8, 2)] += X.v[hook(8, 3)];
    X.v[hook(8, 3)] = RotL_32(X.v[hook(8, 3)], R_32x4_2_1);
    X.v[hook(8, 3)] ^= X.v[hook(8, 2)];
  }

  if (Nrounds > 51) {
    X.v[hook(8, 0)] += X.v[hook(8, 3)];
    X.v[hook(8, 3)] = RotL_32(X.v[hook(8, 3)], R_32x4_3_0);
    X.v[hook(8, 3)] ^= X.v[hook(8, 0)];
    X.v[hook(8, 2)] += X.v[hook(8, 1)];
    X.v[hook(8, 1)] = RotL_32(X.v[hook(8, 1)], R_32x4_3_1);
    X.v[hook(8, 1)] ^= X.v[hook(8, 2)];
  }

  if (Nrounds > 51) {
    X.v[hook(8, 0)] += ks[hook(6, 3)];
    X.v[hook(8, 1)] += ks[hook(6, 4)];
    X.v[hook(8, 2)] += ks[hook(6, 0)];
    X.v[hook(8, 3)] += ks[hook(6, 1)];
    X.v[hook(8, 4 - 1)] += 13;
  }

  if (Nrounds > 52) {
    X.v[hook(8, 0)] += X.v[hook(8, 1)];
    X.v[hook(8, 1)] = RotL_32(X.v[hook(8, 1)], R_32x4_4_0);
    X.v[hook(8, 1)] ^= X.v[hook(8, 0)];
    X.v[hook(8, 2)] += X.v[hook(8, 3)];
    X.v[hook(8, 3)] = RotL_32(X.v[hook(8, 3)], R_32x4_4_1);
    X.v[hook(8, 3)] ^= X.v[hook(8, 2)];
  }

  if (Nrounds > 53) {
    X.v[hook(8, 0)] += X.v[hook(8, 3)];
    X.v[hook(8, 3)] = RotL_32(X.v[hook(8, 3)], R_32x4_5_0);
    X.v[hook(8, 3)] ^= X.v[hook(8, 0)];
    X.v[hook(8, 2)] += X.v[hook(8, 1)];
    X.v[hook(8, 1)] = RotL_32(X.v[hook(8, 1)], R_32x4_5_1);
    X.v[hook(8, 1)] ^= X.v[hook(8, 2)];
  }

  if (Nrounds > 54) {
    X.v[hook(8, 0)] += X.v[hook(8, 1)];
    X.v[hook(8, 1)] = RotL_32(X.v[hook(8, 1)], R_32x4_6_0);
    X.v[hook(8, 1)] ^= X.v[hook(8, 0)];
    X.v[hook(8, 2)] += X.v[hook(8, 3)];
    X.v[hook(8, 3)] = RotL_32(X.v[hook(8, 3)], R_32x4_6_1);
    X.v[hook(8, 3)] ^= X.v[hook(8, 2)];
  }

  if (Nrounds > 55) {
    X.v[hook(8, 0)] += X.v[hook(8, 3)];
    X.v[hook(8, 3)] = RotL_32(X.v[hook(8, 3)], R_32x4_7_0);
    X.v[hook(8, 3)] ^= X.v[hook(8, 0)];
    X.v[hook(8, 2)] += X.v[hook(8, 1)];
    X.v[hook(8, 1)] = RotL_32(X.v[hook(8, 1)], R_32x4_7_1);
    X.v[hook(8, 1)] ^= X.v[hook(8, 2)];
  }

  if (Nrounds > 55) {
    X.v[hook(8, 0)] += ks[hook(6, 4)];
    X.v[hook(8, 1)] += ks[hook(6, 0)];
    X.v[hook(8, 2)] += ks[hook(6, 1)];
    X.v[hook(8, 3)] += ks[hook(6, 2)];
    X.v[hook(8, 4 - 1)] += 14;
  }

  if (Nrounds > 56) {
    X.v[hook(8, 0)] += X.v[hook(8, 1)];
    X.v[hook(8, 1)] = RotL_32(X.v[hook(8, 1)], R_32x4_0_0);
    X.v[hook(8, 1)] ^= X.v[hook(8, 0)];
    X.v[hook(8, 2)] += X.v[hook(8, 3)];
    X.v[hook(8, 3)] = RotL_32(X.v[hook(8, 3)], R_32x4_0_1);
    X.v[hook(8, 3)] ^= X.v[hook(8, 2)];
  }

  if (Nrounds > 57) {
    X.v[hook(8, 0)] += X.v[hook(8, 3)];
    X.v[hook(8, 3)] = RotL_32(X.v[hook(8, 3)], R_32x4_1_0);
    X.v[hook(8, 3)] ^= X.v[hook(8, 0)];
    X.v[hook(8, 2)] += X.v[hook(8, 1)];
    X.v[hook(8, 1)] = RotL_32(X.v[hook(8, 1)], R_32x4_1_1);
    X.v[hook(8, 1)] ^= X.v[hook(8, 2)];
  }

  if (Nrounds > 58) {
    X.v[hook(8, 0)] += X.v[hook(8, 1)];
    X.v[hook(8, 1)] = RotL_32(X.v[hook(8, 1)], R_32x4_2_0);
    X.v[hook(8, 1)] ^= X.v[hook(8, 0)];
    X.v[hook(8, 2)] += X.v[hook(8, 3)];
    X.v[hook(8, 3)] = RotL_32(X.v[hook(8, 3)], R_32x4_2_1);
    X.v[hook(8, 3)] ^= X.v[hook(8, 2)];
  }

  if (Nrounds > 59) {
    X.v[hook(8, 0)] += X.v[hook(8, 3)];
    X.v[hook(8, 3)] = RotL_32(X.v[hook(8, 3)], R_32x4_3_0);
    X.v[hook(8, 3)] ^= X.v[hook(8, 0)];
    X.v[hook(8, 2)] += X.v[hook(8, 1)];
    X.v[hook(8, 1)] = RotL_32(X.v[hook(8, 1)], R_32x4_3_1);
    X.v[hook(8, 1)] ^= X.v[hook(8, 2)];
  }

  if (Nrounds > 59) {
    X.v[hook(8, 0)] += ks[hook(6, 0)];
    X.v[hook(8, 1)] += ks[hook(6, 1)];
    X.v[hook(8, 2)] += ks[hook(6, 2)];
    X.v[hook(8, 3)] += ks[hook(6, 3)];
    X.v[hook(8, 4 - 1)] += 15;
  }

  if (Nrounds > 60) {
    X.v[hook(8, 0)] += X.v[hook(8, 1)];
    X.v[hook(8, 1)] = RotL_32(X.v[hook(8, 1)], R_32x4_4_0);
    X.v[hook(8, 1)] ^= X.v[hook(8, 0)];
    X.v[hook(8, 2)] += X.v[hook(8, 3)];
    X.v[hook(8, 3)] = RotL_32(X.v[hook(8, 3)], R_32x4_4_1);
    X.v[hook(8, 3)] ^= X.v[hook(8, 2)];
  }

  if (Nrounds > 61) {
    X.v[hook(8, 0)] += X.v[hook(8, 3)];
    X.v[hook(8, 3)] = RotL_32(X.v[hook(8, 3)], R_32x4_5_0);
    X.v[hook(8, 3)] ^= X.v[hook(8, 0)];
    X.v[hook(8, 2)] += X.v[hook(8, 1)];
    X.v[hook(8, 1)] = RotL_32(X.v[hook(8, 1)], R_32x4_5_1);
    X.v[hook(8, 1)] ^= X.v[hook(8, 2)];
  }

  if (Nrounds > 62) {
    X.v[hook(8, 0)] += X.v[hook(8, 1)];
    X.v[hook(8, 1)] = RotL_32(X.v[hook(8, 1)], R_32x4_6_0);
    X.v[hook(8, 1)] ^= X.v[hook(8, 0)];
    X.v[hook(8, 2)] += X.v[hook(8, 3)];
    X.v[hook(8, 3)] = RotL_32(X.v[hook(8, 3)], R_32x4_6_1);
    X.v[hook(8, 3)] ^= X.v[hook(8, 2)];
  }

  if (Nrounds > 63) {
    X.v[hook(8, 0)] += X.v[hook(8, 3)];
    X.v[hook(8, 3)] = RotL_32(X.v[hook(8, 3)], R_32x4_7_0);
    X.v[hook(8, 3)] ^= X.v[hook(8, 0)];
    X.v[hook(8, 2)] += X.v[hook(8, 1)];
    X.v[hook(8, 1)] = RotL_32(X.v[hook(8, 1)], R_32x4_7_1);
    X.v[hook(8, 1)] ^= X.v[hook(8, 2)];
  }

  if (Nrounds > 63) {
    X.v[hook(8, 0)] += ks[hook(6, 1)];
    X.v[hook(8, 1)] += ks[hook(6, 2)];
    X.v[hook(8, 2)] += ks[hook(6, 3)];
    X.v[hook(8, 3)] += ks[hook(6, 4)];
    X.v[hook(8, 4 - 1)] += 16;
  }

  if (Nrounds > 64) {
    X.v[hook(8, 0)] += X.v[hook(8, 1)];
    X.v[hook(8, 1)] = RotL_32(X.v[hook(8, 1)], R_32x4_0_0);
    X.v[hook(8, 1)] ^= X.v[hook(8, 0)];
    X.v[hook(8, 2)] += X.v[hook(8, 3)];
    X.v[hook(8, 3)] = RotL_32(X.v[hook(8, 3)], R_32x4_0_1);
    X.v[hook(8, 3)] ^= X.v[hook(8, 2)];
  }

  if (Nrounds > 65) {
    X.v[hook(8, 0)] += X.v[hook(8, 3)];
    X.v[hook(8, 3)] = RotL_32(X.v[hook(8, 3)], R_32x4_1_0);
    X.v[hook(8, 3)] ^= X.v[hook(8, 0)];
    X.v[hook(8, 2)] += X.v[hook(8, 1)];
    X.v[hook(8, 1)] = RotL_32(X.v[hook(8, 1)], R_32x4_1_1);
    X.v[hook(8, 1)] ^= X.v[hook(8, 2)];
  }

  if (Nrounds > 66) {
    X.v[hook(8, 0)] += X.v[hook(8, 1)];
    X.v[hook(8, 1)] = RotL_32(X.v[hook(8, 1)], R_32x4_2_0);
    X.v[hook(8, 1)] ^= X.v[hook(8, 0)];
    X.v[hook(8, 2)] += X.v[hook(8, 3)];
    X.v[hook(8, 3)] = RotL_32(X.v[hook(8, 3)], R_32x4_2_1);
    X.v[hook(8, 3)] ^= X.v[hook(8, 2)];
  }

  if (Nrounds > 67) {
    X.v[hook(8, 0)] += X.v[hook(8, 3)];
    X.v[hook(8, 3)] = RotL_32(X.v[hook(8, 3)], R_32x4_3_0);
    X.v[hook(8, 3)] ^= X.v[hook(8, 0)];
    X.v[hook(8, 2)] += X.v[hook(8, 1)];
    X.v[hook(8, 1)] = RotL_32(X.v[hook(8, 1)], R_32x4_3_1);
    X.v[hook(8, 1)] ^= X.v[hook(8, 2)];
  }

  if (Nrounds > 67) {
    X.v[hook(8, 0)] += ks[hook(6, 2)];
    X.v[hook(8, 1)] += ks[hook(6, 3)];
    X.v[hook(8, 2)] += ks[hook(6, 4)];
    X.v[hook(8, 3)] += ks[hook(6, 0)];
    X.v[hook(8, 4 - 1)] += 17;
  }

  if (Nrounds > 68) {
    X.v[hook(8, 0)] += X.v[hook(8, 1)];
    X.v[hook(8, 1)] = RotL_32(X.v[hook(8, 1)], R_32x4_4_0);
    X.v[hook(8, 1)] ^= X.v[hook(8, 0)];
    X.v[hook(8, 2)] += X.v[hook(8, 3)];
    X.v[hook(8, 3)] = RotL_32(X.v[hook(8, 3)], R_32x4_4_1);
    X.v[hook(8, 3)] ^= X.v[hook(8, 2)];
  }

  if (Nrounds > 69) {
    X.v[hook(8, 0)] += X.v[hook(8, 3)];
    X.v[hook(8, 3)] = RotL_32(X.v[hook(8, 3)], R_32x4_5_0);
    X.v[hook(8, 3)] ^= X.v[hook(8, 0)];
    X.v[hook(8, 2)] += X.v[hook(8, 1)];
    X.v[hook(8, 1)] = RotL_32(X.v[hook(8, 1)], R_32x4_5_1);
    X.v[hook(8, 1)] ^= X.v[hook(8, 2)];
  }

  if (Nrounds > 70) {
    X.v[hook(8, 0)] += X.v[hook(8, 1)];
    X.v[hook(8, 1)] = RotL_32(X.v[hook(8, 1)], R_32x4_6_0);
    X.v[hook(8, 1)] ^= X.v[hook(8, 0)];
    X.v[hook(8, 2)] += X.v[hook(8, 3)];
    X.v[hook(8, 3)] = RotL_32(X.v[hook(8, 3)], R_32x4_6_1);
    X.v[hook(8, 3)] ^= X.v[hook(8, 2)];
  }

  if (Nrounds > 71) {
    X.v[hook(8, 0)] += X.v[hook(8, 3)];
    X.v[hook(8, 3)] = RotL_32(X.v[hook(8, 3)], R_32x4_7_0);
    X.v[hook(8, 3)] ^= X.v[hook(8, 0)];
    X.v[hook(8, 2)] += X.v[hook(8, 1)];
    X.v[hook(8, 1)] = RotL_32(X.v[hook(8, 1)], R_32x4_7_1);
    X.v[hook(8, 1)] ^= X.v[hook(8, 2)];
  }

  if (Nrounds > 71) {
    X.v[hook(8, 0)] += ks[hook(6, 3)];
    X.v[hook(8, 1)] += ks[hook(6, 4)];
    X.v[hook(8, 2)] += ks[hook(6, 0)];
    X.v[hook(8, 3)] += ks[hook(6, 1)];
    X.v[hook(8, 4 - 1)] += 18;
  }
  return X;
}

kernel void PRNG_threefry4x32_gaussian(global float4* randomnumber, threefry4x32_ctr_t ctr_i, float E, float V, unsigned int nrounds, unsigned int numrandom) {
  size_t gdx = get_global_id(0);

  unsigned int maxUint = 0;
  maxUint--;
  float r = (float)maxUint;

  threefry4x32_ctr_t ctr = ctr_i;
  threefry4x32_ukey_t ukey1, ukey2;

  ukey1.v[hook(10, 0)] = ukey2.v[hook(11, 1)] = ukey1.v[hook(10, 2)] = ukey2.v[hook(11, 3)] = gdx;
  ukey2.v[hook(11, 0)] = ukey1.v[hook(10, 1)] = ukey2.v[hook(11, 2)] = ukey1.v[hook(10, 3)] = 0;

  threefry4x32_ctr_t random1, random2;

  if (gdx < numrandom) {
    random1 = threefry4x32_R(nrounds, ctr, ukey1);
    random2 = threefry4x32_R(nrounds, ctr, ukey2);
    float4 frnd1;

    float r1 = (((float)random1.v[hook(12, 0)]) / r);
    float r2 = (((float)random2.v[hook(13, 0)]) / r);
    float r3 = (((float)random1.v[hook(12, 1)]) / r);
    float r4 = (((float)random2.v[hook(13, 1)]) / r);
    float r5 = (((float)random1.v[hook(12, 2)]) / r);
    float r6 = (((float)random2.v[hook(13, 2)]) / r);
    float r7 = (((float)random1.v[hook(12, 3)]) / r);
    float r8 = (((float)random2.v[hook(13, 3)]) / r);

    if (r2 == 0 || r4 == 0 || r6 == 0 || r8 == 0) {
      r2 += 0.0001;
      r4 += 0.0001;
      r6 += 0.0001;
      r8 += 0.0001;
    }

    frnd1.x = cos(2 * 3.14159265358979323846f * r1) * sqrt(-2.0 * log(r2)) * V + E;

    frnd1.y = cos(2 * 3.14159265358979323846f * r3) * sqrt(-2.0 * log(r4)) * V + E;

    frnd1.z = cos(2 * 3.14159265358979323846f * r5) * sqrt(-2.0 * log(r6)) * V + E;

    frnd1.w = cos(2 * 3.14159265358979323846f * r7) * sqrt(-2.0 * log(r8)) * V + E;

    randomnumber[hook(0, gdx)] = frnd1;
  }
}