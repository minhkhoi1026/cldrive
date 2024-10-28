//{"X.v":6,"c.v":8,"counter":3,"in.v":7,"k.v":5,"key":2,"ks":4,"output":0,"output_size":1,"result.v":9}
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
  ks[hook(4, 2)] = 0x1BD11BDA;
  for (i = 0; i < 2; i++) {
    ks[hook(4, i)] = k.v[hook(5, i)];
    X.v[hook(6, i)] = in.v[hook(7, i)];
    ks[hook(4, 2)] ^= k.v[hook(5, i)];
  }
  X.v[hook(6, 0)] += ks[hook(4, 0)];
  X.v[hook(6, 1)] += ks[hook(4, 1)];
  if (Nrounds > 0) {
    X.v[hook(6, 0)] += X.v[hook(6, 1)];
    X.v[hook(6, 1)] = RotL_32(X.v[hook(6, 1)], R_32x2_0_0);
    X.v[hook(6, 1)] ^= X.v[hook(6, 0)];
  }
  if (Nrounds > 1) {
    X.v[hook(6, 0)] += X.v[hook(6, 1)];
    X.v[hook(6, 1)] = RotL_32(X.v[hook(6, 1)], R_32x2_1_0);
    X.v[hook(6, 1)] ^= X.v[hook(6, 0)];
  }
  if (Nrounds > 2) {
    X.v[hook(6, 0)] += X.v[hook(6, 1)];
    X.v[hook(6, 1)] = RotL_32(X.v[hook(6, 1)], R_32x2_2_0);
    X.v[hook(6, 1)] ^= X.v[hook(6, 0)];
  }
  if (Nrounds > 3) {
    X.v[hook(6, 0)] += X.v[hook(6, 1)];
    X.v[hook(6, 1)] = RotL_32(X.v[hook(6, 1)], R_32x2_3_0);
    X.v[hook(6, 1)] ^= X.v[hook(6, 0)];
  }
  if (Nrounds > 3) {
    X.v[hook(6, 0)] += ks[hook(4, 1)];
    X.v[hook(6, 1)] += ks[hook(4, 2)];
    X.v[hook(6, 1)] += 1;
  }
  if (Nrounds > 4) {
    X.v[hook(6, 0)] += X.v[hook(6, 1)];
    X.v[hook(6, 1)] = RotL_32(X.v[hook(6, 1)], R_32x2_4_0);
    X.v[hook(6, 1)] ^= X.v[hook(6, 0)];
  }
  if (Nrounds > 5) {
    X.v[hook(6, 0)] += X.v[hook(6, 1)];
    X.v[hook(6, 1)] = RotL_32(X.v[hook(6, 1)], R_32x2_5_0);
    X.v[hook(6, 1)] ^= X.v[hook(6, 0)];
  }
  if (Nrounds > 6) {
    X.v[hook(6, 0)] += X.v[hook(6, 1)];
    X.v[hook(6, 1)] = RotL_32(X.v[hook(6, 1)], R_32x2_6_0);
    X.v[hook(6, 1)] ^= X.v[hook(6, 0)];
  }
  if (Nrounds > 7) {
    X.v[hook(6, 0)] += X.v[hook(6, 1)];
    X.v[hook(6, 1)] = RotL_32(X.v[hook(6, 1)], R_32x2_7_0);
    X.v[hook(6, 1)] ^= X.v[hook(6, 0)];
  }
  if (Nrounds > 7) {
    X.v[hook(6, 0)] += ks[hook(4, 2)];
    X.v[hook(6, 1)] += ks[hook(4, 0)];
    X.v[hook(6, 1)] += 2;
  }
  if (Nrounds > 8) {
    X.v[hook(6, 0)] += X.v[hook(6, 1)];
    X.v[hook(6, 1)] = RotL_32(X.v[hook(6, 1)], R_32x2_0_0);
    X.v[hook(6, 1)] ^= X.v[hook(6, 0)];
  }
  if (Nrounds > 9) {
    X.v[hook(6, 0)] += X.v[hook(6, 1)];
    X.v[hook(6, 1)] = RotL_32(X.v[hook(6, 1)], R_32x2_1_0);
    X.v[hook(6, 1)] ^= X.v[hook(6, 0)];
  }
  if (Nrounds > 10) {
    X.v[hook(6, 0)] += X.v[hook(6, 1)];
    X.v[hook(6, 1)] = RotL_32(X.v[hook(6, 1)], R_32x2_2_0);
    X.v[hook(6, 1)] ^= X.v[hook(6, 0)];
  }
  if (Nrounds > 11) {
    X.v[hook(6, 0)] += X.v[hook(6, 1)];
    X.v[hook(6, 1)] = RotL_32(X.v[hook(6, 1)], R_32x2_3_0);
    X.v[hook(6, 1)] ^= X.v[hook(6, 0)];
  }
  if (Nrounds > 11) {
    X.v[hook(6, 0)] += ks[hook(4, 0)];
    X.v[hook(6, 1)] += ks[hook(4, 1)];
    X.v[hook(6, 1)] += 3;
  }
  if (Nrounds > 12) {
    X.v[hook(6, 0)] += X.v[hook(6, 1)];
    X.v[hook(6, 1)] = RotL_32(X.v[hook(6, 1)], R_32x2_4_0);
    X.v[hook(6, 1)] ^= X.v[hook(6, 0)];
  }
  if (Nrounds > 13) {
    X.v[hook(6, 0)] += X.v[hook(6, 1)];
    X.v[hook(6, 1)] = RotL_32(X.v[hook(6, 1)], R_32x2_5_0);
    X.v[hook(6, 1)] ^= X.v[hook(6, 0)];
  }
  if (Nrounds > 14) {
    X.v[hook(6, 0)] += X.v[hook(6, 1)];
    X.v[hook(6, 1)] = RotL_32(X.v[hook(6, 1)], R_32x2_6_0);
    X.v[hook(6, 1)] ^= X.v[hook(6, 0)];
  }
  if (Nrounds > 15) {
    X.v[hook(6, 0)] += X.v[hook(6, 1)];
    X.v[hook(6, 1)] = RotL_32(X.v[hook(6, 1)], R_32x2_7_0);
    X.v[hook(6, 1)] ^= X.v[hook(6, 0)];
  }
  if (Nrounds > 15) {
    X.v[hook(6, 0)] += ks[hook(4, 1)];
    X.v[hook(6, 1)] += ks[hook(4, 2)];
    X.v[hook(6, 1)] += 4;
  }
  if (Nrounds > 16) {
    X.v[hook(6, 0)] += X.v[hook(6, 1)];
    X.v[hook(6, 1)] = RotL_32(X.v[hook(6, 1)], R_32x2_0_0);
    X.v[hook(6, 1)] ^= X.v[hook(6, 0)];
  }
  if (Nrounds > 17) {
    X.v[hook(6, 0)] += X.v[hook(6, 1)];
    X.v[hook(6, 1)] = RotL_32(X.v[hook(6, 1)], R_32x2_1_0);
    X.v[hook(6, 1)] ^= X.v[hook(6, 0)];
  }
  if (Nrounds > 18) {
    X.v[hook(6, 0)] += X.v[hook(6, 1)];
    X.v[hook(6, 1)] = RotL_32(X.v[hook(6, 1)], R_32x2_2_0);
    X.v[hook(6, 1)] ^= X.v[hook(6, 0)];
  }
  if (Nrounds > 19) {
    X.v[hook(6, 0)] += X.v[hook(6, 1)];
    X.v[hook(6, 1)] = RotL_32(X.v[hook(6, 1)], R_32x2_3_0);
    X.v[hook(6, 1)] ^= X.v[hook(6, 0)];
  }
  if (Nrounds > 19) {
    X.v[hook(6, 0)] += ks[hook(4, 2)];
    X.v[hook(6, 1)] += ks[hook(4, 0)];
    X.v[hook(6, 1)] += 5;
  }
  if (Nrounds > 20) {
    X.v[hook(6, 0)] += X.v[hook(6, 1)];
    X.v[hook(6, 1)] = RotL_32(X.v[hook(6, 1)], R_32x2_4_0);
    X.v[hook(6, 1)] ^= X.v[hook(6, 0)];
  }
  if (Nrounds > 21) {
    X.v[hook(6, 0)] += X.v[hook(6, 1)];
    X.v[hook(6, 1)] = RotL_32(X.v[hook(6, 1)], R_32x2_5_0);
    X.v[hook(6, 1)] ^= X.v[hook(6, 0)];
  }
  if (Nrounds > 22) {
    X.v[hook(6, 0)] += X.v[hook(6, 1)];
    X.v[hook(6, 1)] = RotL_32(X.v[hook(6, 1)], R_32x2_6_0);
    X.v[hook(6, 1)] ^= X.v[hook(6, 0)];
  }
  if (Nrounds > 23) {
    X.v[hook(6, 0)] += X.v[hook(6, 1)];
    X.v[hook(6, 1)] = RotL_32(X.v[hook(6, 1)], R_32x2_7_0);
    X.v[hook(6, 1)] ^= X.v[hook(6, 0)];
  }
  if (Nrounds > 23) {
    X.v[hook(6, 0)] += ks[hook(4, 0)];
    X.v[hook(6, 1)] += ks[hook(4, 1)];
    X.v[hook(6, 1)] += 6;
  }
  if (Nrounds > 24) {
    X.v[hook(6, 0)] += X.v[hook(6, 1)];
    X.v[hook(6, 1)] = RotL_32(X.v[hook(6, 1)], R_32x2_0_0);
    X.v[hook(6, 1)] ^= X.v[hook(6, 0)];
  }
  if (Nrounds > 25) {
    X.v[hook(6, 0)] += X.v[hook(6, 1)];
    X.v[hook(6, 1)] = RotL_32(X.v[hook(6, 1)], R_32x2_1_0);
    X.v[hook(6, 1)] ^= X.v[hook(6, 0)];
  }
  if (Nrounds > 26) {
    X.v[hook(6, 0)] += X.v[hook(6, 1)];
    X.v[hook(6, 1)] = RotL_32(X.v[hook(6, 1)], R_32x2_2_0);
    X.v[hook(6, 1)] ^= X.v[hook(6, 0)];
  }
  if (Nrounds > 27) {
    X.v[hook(6, 0)] += X.v[hook(6, 1)];
    X.v[hook(6, 1)] = RotL_32(X.v[hook(6, 1)], R_32x2_3_0);
    X.v[hook(6, 1)] ^= X.v[hook(6, 0)];
  }
  if (Nrounds > 27) {
    X.v[hook(6, 0)] += ks[hook(4, 1)];
    X.v[hook(6, 1)] += ks[hook(4, 2)];
    X.v[hook(6, 1)] += 7;
  }
  if (Nrounds > 28) {
    X.v[hook(6, 0)] += X.v[hook(6, 1)];
    X.v[hook(6, 1)] = RotL_32(X.v[hook(6, 1)], R_32x2_4_0);
    X.v[hook(6, 1)] ^= X.v[hook(6, 0)];
  }
  if (Nrounds > 29) {
    X.v[hook(6, 0)] += X.v[hook(6, 1)];
    X.v[hook(6, 1)] = RotL_32(X.v[hook(6, 1)], R_32x2_5_0);
    X.v[hook(6, 1)] ^= X.v[hook(6, 0)];
  }
  if (Nrounds > 30) {
    X.v[hook(6, 0)] += X.v[hook(6, 1)];
    X.v[hook(6, 1)] = RotL_32(X.v[hook(6, 1)], R_32x2_6_0);
    X.v[hook(6, 1)] ^= X.v[hook(6, 0)];
  }
  if (Nrounds > 31) {
    X.v[hook(6, 0)] += X.v[hook(6, 1)];
    X.v[hook(6, 1)] = RotL_32(X.v[hook(6, 1)], R_32x2_7_0);
    X.v[hook(6, 1)] ^= X.v[hook(6, 0)];
  }
  if (Nrounds > 31) {
    X.v[hook(6, 0)] += ks[hook(4, 2)];
    X.v[hook(6, 1)] += ks[hook(4, 0)];
    X.v[hook(6, 1)] += 8;
  }
  return X;
}
kernel void fill(global unsigned int* output, const unsigned int output_size, const uint2 key, const uint2 counter) {
  unsigned int gid = get_global_id(0);
  threefry2x32_ctr_t c;
  c.v[hook(8, 0)] = counter.x + gid;
  c.v[hook(8, 1)] = counter.y + (c.v[hook(8, 0)] < counter.x ? 1 : 0);

  threefry2x32_key_t k = {{key.x, key.y}};

  threefry2x32_ctr_t result;
  result = threefry2x32_R(20, c, k);

  if (gid < output_size / 2) {
    output[hook(0, 2 * gid)] = result.v[hook(9, 0)];
    output[hook(0, 2 * gid + 1)] = result.v[hook(9, 1)];
  } else if (gid < (output_size + 1) / 2)
    output[hook(0, 2 * gid)] = result.v[hook(9, 0)];
}