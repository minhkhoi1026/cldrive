//{"input":2,"output":3,"s":1,"state":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void subBytes3(local uint4* state) {
  uint4 x0, x1, x2, x3, x4, x5, x6, x7, t0, t1, t2, t3, t4, t5, t6, m0, m1, m2, m3, m4, m5, m6, m7, m8, m9, m10, m11, m12;
  for (int i = 0; i < 32; i += 8) {
    x0 = state[hook(0, i + 0)];
    x1 = state[hook(0, i + 1)];
    x2 = state[hook(0, i + 2)];
    x3 = state[hook(0, i + 3)];
    x4 = state[hook(0, i + 4)];
    x5 = state[hook(0, i + 5)];
    x6 = state[hook(0, i + 6)];
    x7 = state[hook(0, i + 7)];
    x5 ^= x0 ^ x6;
    t0 = x1 ^ x7;
    x6 ^= x0 ^ x1 ^ x2 ^ x3;
    x7 ^= x5;
    x1 ^= x5;
    x3 ^= x0 ^ x4 ^ t0;
    x4 ^= x5;
    x2 ^= t0 ^ x5;
    t1 = x4 ^ x7;
    t2 = x1 ^ x2;
    m1 = t1;
    t5 = x0;
    m0 = t2;
    t5 ^= x6;
    t6 = x3 ^ x5;
    m3 = t5;
    t4 = t1 ^ t2;
    t1 &= t5;
    m2 = t6;
    t2 &= t6;
    m4 = t4;
    t5 ^= t6;
    t2 ^= t1;
    t4 &= t5;
    m5 = t5;
    t6 = x2;
    t1 ^= t4;
    t6 &= x3;
    m6 = t1;
    t0 = x3;
    t1 = x2;
    t0 ^= x0;
    t1 ^= x4;
    t5 = x4;
    m7 = t1;
    t3 = x7;
    t1 &= t0;
    t3 &= x6;
    m8 = t0;
    t5 &= x0;
    t6 ^= t1;
    t5 ^= t1;
    m11 = x6;
    t1 = x1;
    t0 = x5;
    t1 ^= x7;
    t0 ^= x6;
    m9 = t1;
    t5 ^= t2;
    t4 = x1;
    m12 = x5;
    t1 &= t0;
    t4 &= x5;
    x6 ^= x7;
    m10 = t0;
    t4 ^= t1;
    t3 ^= t1;
    x5 ^= x1;
    t1 = m6;
    t3 ^= t2;
    t5 ^= x5;
    t3 ^= x6;
    t5 ^= x2;
    t1 ^= x6;
    t6 ^= x0;
    t4 ^= t1;
    t6 ^= t1;
    t4 ^= x5;
    t6 ^= x4;
    t2 = t4;
    t5 ^= x3;
    t2 ^= t3;
    x6 = t5;
    t0 = t5;
    x6 ^= t6;
    t0 &= t3;
    x5 = t2;
    t0 ^= t3;
    x5 &= x6;
    t0 ^= t5;
    x5 ^= t6;
    t1 = t6;
    x5 ^= t4;
    t1 &= t4;
    t0 ^= x5;
    t1 ^= x5;
    t6 &= t0;
    t4 &= t0;
    x5 = m12;
    t5 &= t1;
    t0 ^= t1;
    t3 &= t1;
    x6 &= t0;
    t2 &= t0;
    t6 ^= x6;
    t4 ^= t2;
    t5 ^= x6;
    t3 ^= t2;
    t1 = t6;
    x6 = m11;
    x3 &= t4;
    t1 ^= t4;
    t2 = m2;
    x2 &= t4;
    m0 &= t1;
    x5 &= t6;
    t4 ^= t3;
    x1 &= t6;
    m7 &= t4;
    x0 &= t3;
    t6 ^= t5;
    t4 &= m8;
    x4 &= t3;
    m9 &= t6;
    x7 &= t5;
    t3 ^= t5;
    t6 &= m10;
    x6 &= t5;
    t2 &= t1;
    m1 &= t3;
    x5 ^= t6;
    t5 = m7;
    x6 ^= t6;
    t6 = t1;
    x3 ^= t4;
    t1 ^= t3;
    t3 &= m3;
    x0 ^= t4;
    x2 ^= t5;
    m4 &= t1;
    t2 ^= t3;
    t1 &= m5;
    x0 ^= t2;
    t0 = m0;
    t1 ^= t3;
    x4 ^= t5;
    t3 = m9;
    x6 ^= t2;
    x3 ^= t1;
    x5 ^= t1;
    t6 = x0;
    t1 = m1;
    x0 ^= x6;
    x1 ^= t3;
    t0 ^= t1;
    x7 ^= t3;
    t1 ^= m4;
    x4 ^= t0;
    x7 ^= t0;
    x1 ^= t1;
    x2 ^= t1;
    t2 = x1;
    t1 = x4;
    x1 ^= x6;
    x4 = x5;
    x6 = x2;
    x1 ^= x5;
    x6 ^= x3;
    t0 = x7;
    x4 ^= x6;
    x3 = x0;
    x7 = x5;
    x3 ^= x4;
    x7 ^= x2;
    x5 = t6;
    x2 = x7;
    x5 ^= t0;
    x2 ^= t1;
    x0 ^= t2;
    x2 ^= x5;
    state[hook(0, i + 0)] = ~x0;
    state[hook(0, i + 1)] = ~x1;
    state[hook(0, i + 2)] = x2;
    state[hook(0, i + 3)] = x3;
    state[hook(0, i + 4)] = x4;
    state[hook(0, i + 5)] = ~x5;
    state[hook(0, i + 6)] = ~x6;
    state[hook(0, i + 7)] = x7;
  }
}

void subBytes(local uint4* state) {
  uint4 x0, x1, x2, x3, x4, x5, x6, x7;
  uint4 a0, a1, a2, a3, b0, b1, b2, b3;
  uint4 t0, t1, t2, t3, t4, t5, t6, t7, t8, t9, t10, t11, t12, t13, t14;
  for (int i = 0; i < 32; i += 8) {
    a0 = state[hook(0, i + 0)];
    a1 = state[hook(0, i + 1)];
    a2 = state[hook(0, i + 2)];
    a3 = state[hook(0, i + 3)];
    b0 = state[hook(0, i + 4)];
    b1 = state[hook(0, i + 5)];
    b2 = state[hook(0, i + 6)];
    b3 = state[hook(0, i + 7)];

    x7 = b1 ^ b3;
    x3 = a1 ^ a2;
    x6 = x3 ^ a3;
    x0 = a1 ^ b2;
    x1 = x0 ^ b0;
    x0 ^= a0;
    x2 = x6 ^ b0 ^ b3;
    x3 ^= b2 ^ b3;
    x4 = x6 ^ x7;
    x5 = a2 ^ a3 ^ x7;
    x6 ^= b0 ^ b2 ^ b3;

    a0 = x0 ^ x4;
    a1 = x1 ^ x5;
    a2 = x2 ^ x6;
    a3 = x3 ^ x7;

    b0 = x4 ^ x5 ^ x7;
    b1 = x5 ^ x6;
    b2 = x6 ^ x7;
    b3 = b0 ^ b2;
    b0 = b2;
    b2 = b1 ^ x7 ^ b3;
    b1 = x7;

    t0 = a3 & x3;
    t1 = (a2 & x2) ^ t0;
    t2 = t0 ^ (a2 & x3) ^ (a3 & x2);
    t3 = a1 & x1;
    t4 = (a0 & x0) ^ t3;
    t5 = t3 ^ (a0 & x1) ^ (a1 & x0);
    t0 = a0 ^ a2;
    t3 = a1 ^ a3;
    x0 ^= x2;
    x1 ^= x3;
    t6 = t3 & x1;
    x2 = (t0 & x0) ^ t6 ^ t4;
    x3 = t6 ^ (t0 & x1) ^ (t3 & x0) ^ t5;
    x0 = t2 ^ t4;
    x1 = t1 ^ t2 ^ t5;

    t0 = b0 ^ x0;
    t1 = b1 ^ x1;
    t2 = b2 ^ x2;
    t3 = b3 ^ x3;
    t4 = t0 & t3;
    t5 = t1 & t2;
    t6 = t1 & t3;
    t7 = t2 & t3;
    t8 = t0 & t5;
    t9 = t0 & t6;
    t10 = t0 & t7;
    t11 = t1 & t7;
    t12 = t1 ^ t2;
    t13 = t11 ^ t10;
    t14 = t4 ^ t5;
    b0 = t0 ^ t12 ^ t13 ^ t6 ^ t9 ^ t14 ^ t8;
    b1 = t12 ^ t3 ^ t11 ^ t9 ^ (t0 & t2);
    b2 = t2 ^ t13 ^ t14;
    b3 = t2 ^ t3 ^ t11 ^ t4;

    t0 = b0 ^ b2;
    t1 = b1 ^ b3;
    t2 = b3 & x7;
    t3 = (b2 & x6) ^ t2;
    t4 = t2 ^ (b2 & x7) ^ (b3 & x6);
    t5 = b1 & x5;
    t6 = (b0 & x4) ^ t5;
    t7 = t5 ^ (b0 & x5) ^ (b1 & x4);
    t2 = x4 ^ x6;
    t5 = x5 ^ x7;
    t8 = t1 & t5;
    x4 = t4 ^ t6;
    x5 = t3 ^ t4 ^ t7;
    x6 = (t0 & t2) ^ t8 ^ t6;
    x7 = t8 ^ (t0 & t5) ^ (t1 & t2) ^ t7;
    t2 = b3 & a3;
    t3 = (b2 & a2) ^ t2;
    t4 = t2 ^ (b2 & a3) ^ (b3 & a2);
    t5 = b1 & a1;
    t6 = (b0 & a0) ^ t5;
    t7 = t5 ^ (b0 & a1) ^ (b1 & a0);
    t2 = a0 ^ a2;
    t5 = a1 ^ a3;
    t8 = t1 & t5;
    x0 = t4 ^ t6;
    x1 = t3 ^ t4 ^ t7;
    x2 = (t0 & t2) ^ t8 ^ t6;
    x3 = t8 ^ (t0 & t5) ^ (t1 & t2) ^ t7;

    a0 = x0 ^ x1 ^ x2;
    a1 = x6 ^ x7;
    a2 = x0 ^ x7;
    a3 = x2 ^ x7;
    b0 = x4 ^ x5 ^ x6;
    state[hook(0, i + 0)] = ~(a0 ^ a1);
    state[hook(0, i + 1)] = ~a2;
    state[hook(0, i + 2)] = x0 ^ x2 ^ x3 ^ b0;
    state[hook(0, i + 3)] = a0;
    state[hook(0, i + 4)] = a2 ^ x1 ^ x4;
    state[hook(0, i + 5)] = ~a3;
    state[hook(0, i + 6)] = ~(b0 ^ x7);
    state[hook(0, i + 7)] = a3 ^ x3;
  }
}

void shiftRows(local uint4* state) {
  for (int i = 8; i < 16; i++)
    state[hook(0, i)] = state[hook(0, i)].s1230;
  for (int i = 16; i < 24; i++)
    state[hook(0, i)] = state[hook(0, i)].s2301;
  for (int i = 24; i < 32; i++)
    state[hook(0, i)] = state[hook(0, i)].s3012;
}

void mixColumns(local uint4* s) {
  uint4 t0, t1, t2, t3, t4, t5, t6, t7;
  uint4 q0, q1, q2;
  q0 = s[hook(1, 7)] ^ s[hook(1, 8)];
  q1 = s[hook(1, 15)] ^ s[hook(1, 16)];
  q2 = s[hook(1, 23)] ^ s[hook(1, 24)];
  t0 = q0 ^ q1 ^ s[hook(1, 24)];
  t1 = s[hook(1, 0)] ^ q1 ^ q2;
  t2 = s[hook(1, 0)] ^ s[hook(1, 8)] ^ q2 ^ s[hook(1, 31)];
  t3 = s[hook(1, 0)] ^ q0 ^ s[hook(1, 16)] ^ s[hook(1, 31)];
  t4 = s[hook(1, 0)] ^ q0 ^ s[hook(1, 9)] ^ s[hook(1, 15)] ^ s[hook(1, 17)] ^ s[hook(1, 25)];
  t5 = s[hook(1, 1)] ^ s[hook(1, 8)] ^ q1 ^ s[hook(1, 17)] ^ s[hook(1, 23)] ^ s[hook(1, 25)];
  t6 = s[hook(1, 1)] ^ s[hook(1, 9)] ^ s[hook(1, 16)] ^ q2 ^ s[hook(1, 25)] ^ s[hook(1, 31)];
  t7 = s[hook(1, 0)] ^ s[hook(1, 1)] ^ s[hook(1, 7)] ^ s[hook(1, 9)] ^ s[hook(1, 17)] ^ s[hook(1, 24)] ^ s[hook(1, 31)];
  s[hook(1, 0)] = t0;
  s[hook(1, 8)] = t1;
  s[hook(1, 16)] = t2;
  s[hook(1, 24)] = t3;
  t0 = s[hook(1, 1)] ^ s[hook(1, 9)] ^ s[hook(1, 10)] ^ s[hook(1, 18)] ^ s[hook(1, 26)];
  t1 = s[hook(1, 2)] ^ s[hook(1, 9)] ^ s[hook(1, 17)] ^ s[hook(1, 18)] ^ s[hook(1, 26)];
  t2 = s[hook(1, 2)] ^ s[hook(1, 10)] ^ s[hook(1, 17)] ^ s[hook(1, 25)] ^ s[hook(1, 26)];
  t3 = s[hook(1, 1)] ^ s[hook(1, 2)] ^ s[hook(1, 10)] ^ s[hook(1, 18)] ^ s[hook(1, 25)];
  s[hook(1, 1)] = t4;
  s[hook(1, 9)] = t5;
  s[hook(1, 17)] = t6;
  s[hook(1, 25)] = t7;
  t4 = s[hook(1, 2)] ^ s[hook(1, 7)] ^ s[hook(1, 10)] ^ s[hook(1, 11)] ^ s[hook(1, 15)] ^ s[hook(1, 19)] ^ s[hook(1, 27)];
  t5 = s[hook(1, 3)] ^ s[hook(1, 10)] ^ s[hook(1, 15)] ^ s[hook(1, 18)] ^ s[hook(1, 19)] ^ s[hook(1, 23)] ^ s[hook(1, 27)];
  t6 = s[hook(1, 3)] ^ s[hook(1, 11)] ^ s[hook(1, 18)] ^ s[hook(1, 23)] ^ s[hook(1, 26)] ^ s[hook(1, 27)] ^ s[hook(1, 31)];
  t7 = s[hook(1, 2)] ^ s[hook(1, 3)] ^ s[hook(1, 7)] ^ s[hook(1, 11)] ^ s[hook(1, 19)] ^ s[hook(1, 26)] ^ s[hook(1, 31)];
  s[hook(1, 2)] = t0;
  s[hook(1, 10)] = t1;
  s[hook(1, 18)] = t2;
  s[hook(1, 26)] = t3;
  t0 = s[hook(1, 3)] ^ s[hook(1, 7)] ^ s[hook(1, 11)] ^ s[hook(1, 12)] ^ s[hook(1, 15)] ^ s[hook(1, 20)] ^ s[hook(1, 28)];
  t1 = s[hook(1, 4)] ^ s[hook(1, 11)] ^ s[hook(1, 15)] ^ s[hook(1, 19)] ^ s[hook(1, 20)] ^ s[hook(1, 23)] ^ s[hook(1, 28)];
  t2 = s[hook(1, 4)] ^ s[hook(1, 12)] ^ s[hook(1, 19)] ^ s[hook(1, 23)] ^ s[hook(1, 27)] ^ s[hook(1, 28)] ^ s[hook(1, 31)];
  t3 = s[hook(1, 3)] ^ s[hook(1, 4)] ^ s[hook(1, 7)] ^ s[hook(1, 12)] ^ s[hook(1, 20)] ^ s[hook(1, 27)] ^ s[hook(1, 31)];
  s[hook(1, 3)] = t4;
  s[hook(1, 11)] = t5;
  s[hook(1, 19)] = t6;
  s[hook(1, 27)] = t7;
  t4 = s[hook(1, 4)] ^ s[hook(1, 12)] ^ s[hook(1, 13)] ^ s[hook(1, 21)] ^ s[hook(1, 29)];
  t5 = s[hook(1, 5)] ^ s[hook(1, 12)] ^ s[hook(1, 20)] ^ s[hook(1, 21)] ^ s[hook(1, 29)];
  t6 = s[hook(1, 5)] ^ s[hook(1, 13)] ^ s[hook(1, 20)] ^ s[hook(1, 28)] ^ s[hook(1, 29)];
  t7 = s[hook(1, 4)] ^ s[hook(1, 5)] ^ s[hook(1, 13)] ^ s[hook(1, 21)] ^ s[hook(1, 28)];
  s[hook(1, 4)] = t0;
  s[hook(1, 12)] = t1;
  s[hook(1, 20)] = t2;
  s[hook(1, 28)] = t3;
  t0 = s[hook(1, 5)] ^ s[hook(1, 13)] ^ s[hook(1, 14)] ^ s[hook(1, 22)] ^ s[hook(1, 30)];
  t1 = s[hook(1, 6)] ^ s[hook(1, 13)] ^ s[hook(1, 21)] ^ s[hook(1, 22)] ^ s[hook(1, 30)];
  t2 = s[hook(1, 6)] ^ s[hook(1, 14)] ^ s[hook(1, 21)] ^ s[hook(1, 29)] ^ s[hook(1, 30)];
  t3 = s[hook(1, 5)] ^ s[hook(1, 6)] ^ s[hook(1, 14)] ^ s[hook(1, 22)] ^ s[hook(1, 29)];
  s[hook(1, 5)] = t4;
  s[hook(1, 13)] = t5;
  s[hook(1, 21)] = t6;
  s[hook(1, 29)] = t7;
  t4 = s[hook(1, 6)] ^ s[hook(1, 14)] ^ s[hook(1, 15)] ^ s[hook(1, 23)] ^ s[hook(1, 31)];
  t5 = s[hook(1, 7)] ^ s[hook(1, 14)] ^ s[hook(1, 22)] ^ s[hook(1, 23)] ^ s[hook(1, 31)];
  t6 = s[hook(1, 7)] ^ s[hook(1, 15)] ^ s[hook(1, 22)] ^ s[hook(1, 30)] ^ s[hook(1, 31)];
  t7 = s[hook(1, 6)] ^ s[hook(1, 7)] ^ s[hook(1, 15)] ^ s[hook(1, 23)] ^ s[hook(1, 30)];
  s[hook(1, 6)] = t0;
  s[hook(1, 7)] = t4;
  s[hook(1, 14)] = t1;
  s[hook(1, 15)] = t5;
  s[hook(1, 22)] = t2;
  s[hook(1, 23)] = t6;
  s[hook(1, 30)] = t3;
  s[hook(1, 31)] = t7;
}

void bitslice(const global uint4* input, local uint4* state) {
  const uint4 c1 = (uint4)(1);
  for (int i = 0; i < 32; i++)
    state[hook(0, i)] = (uint4)(0);
  for (int i = 0; i < 32; i += 8) {
    uint4 t0 = input[hook(2, i + 0)], t1 = input[hook(2, i + 1)];
    uint4 t2 = input[hook(2, i + 2)], t3 = input[hook(2, i + 3)];
    uint4 t4 = input[hook(2, i + 4)], t5 = input[hook(2, i + 5)];
    uint4 t6 = input[hook(2, i + 6)], t7 = input[hook(2, i + 7)];
    for (int j = 0; j < 32; j++) {
      state[hook(0, j)] |= (((t0 >> (uint4)(j)) & c1) << (uint4)(i + 0)) | (((t1 >> (uint4)(j)) & c1) << (uint4)(i + 1)) | (((t2 >> (uint4)(j)) & c1) << (uint4)(i + 2)) | (((t3 >> (uint4)(j)) & c1) << (uint4)(i + 3)) | (((t4 >> (uint4)(j)) & c1) << (uint4)(i + 4)) | (((t5 >> (uint4)(j)) & c1) << (uint4)(i + 5)) | (((t6 >> (uint4)(j)) & c1) << (uint4)(i + 6)) | (((t7 >> (uint4)(j)) & c1) << (uint4)(i + 7));
    }
  }
}

void unbitslice(local uint4* state, global uint4* output) {
  const uint4 c1 = (uint4)(1);
  for (int i = 0; i < 32; i += 2) {
    uint4 t0 = (uint4)(0);
    uint4 t1 = (uint4)(0);
    for (int j = 0; j < 32; j++) {
      t0 |= ((state[hook(0, j)] >> (uint4)(i + 0)) & c1) << (uint4)(j);
      t1 |= ((state[hook(0, j)] >> (uint4)(i + 1)) & c1) << (uint4)(j);
    }
    output[hook(3, i)] = t0;
    output[hook(3, i + 1)] = t1;
  }
}

kernel void bitslice_kernel(global uint4* state) {
  const uint4 c1 = (uint4)(1);
  state += get_global_id(0) * 32;

  uint4 t0 = state[hook(0, 0)], t1 = state[hook(0, 1)];
  uint4 t2 = state[hook(0, 2)], t3 = state[hook(0, 3)];
  uint4 t4 = state[hook(0, 4)], t5 = state[hook(0, 5)];
  uint4 t6 = state[hook(0, 6)], t7 = state[hook(0, 7)];
  uint4 t8 = state[hook(0, 8)], t9 = state[hook(0, 9)];
  uint4 t10 = state[hook(0, 10)], t11 = state[hook(0, 11)];
  uint4 t12 = state[hook(0, 12)], t13 = state[hook(0, 13)];
  uint4 t14 = state[hook(0, 14)], t15 = state[hook(0, 15)];
  uint4 t16 = state[hook(0, 16)], t17 = state[hook(0, 17)];
  uint4 t18 = state[hook(0, 18)], t19 = state[hook(0, 19)];
  uint4 t20 = state[hook(0, 20)], t21 = state[hook(0, 21)];
  uint4 t22 = state[hook(0, 22)], t23 = state[hook(0, 23)];
  uint4 t24 = state[hook(0, 24)], t25 = state[hook(0, 25)];
  uint4 t26 = state[hook(0, 26)], t27 = state[hook(0, 27)];
  uint4 t28 = state[hook(0, 28)], t29 = state[hook(0, 29)];
  uint4 t30 = state[hook(0, 30)], t31 = state[hook(0, 31)];
  for (int j = 0; j < 32; j++) {
    const uint4 cj = (uint4)(j);
    state[hook(0, j)] = (((t0 >> cj) & c1) << (uint4)(0)) | (((t1 >> cj) & c1) << (uint4)(1)) | (((t2 >> cj) & c1) << (uint4)(2)) | (((t3 >> cj) & c1) << (uint4)(3)) | (((t4 >> cj) & c1) << (uint4)(4)) | (((t5 >> cj) & c1) << (uint4)(5)) | (((t6 >> cj) & c1) << (uint4)(6)) | (((t7 >> cj) & c1) << (uint4)(7)) | (((t8 >> cj) & c1) << (uint4)(8)) | (((t9 >> cj) & c1) << (uint4)(9)) | (((t10 >> cj) & c1) << (uint4)(10)) | (((t11 >> cj) & c1) << (uint4)(11)) | (((t12 >> cj) & c1) << (uint4)(12)) | (((t13 >> cj) & c1) << (uint4)(13)) | (((t14 >> cj) & c1) << (uint4)(14)) | (((t15 >> cj) & c1) << (uint4)(15)) | (((t16 >> cj) & c1) << (uint4)(16)) | (((t17 >> cj) & c1) << (uint4)(17)) | (((t18 >> cj) & c1) << (uint4)(18)) | (((t19 >> cj) & c1) << (uint4)(19)) | (((t20 >> cj) & c1) << (uint4)(20)) | (((t21 >> cj) & c1) << (uint4)(21)) | (((t22 >> cj) & c1) << (uint4)(22)) | (((t23 >> cj) & c1) << (uint4)(23)) | (((t24 >> cj) & c1) << (uint4)(24)) | (((t25 >> cj) & c1) << (uint4)(25)) | (((t26 >> cj) & c1) << (uint4)(26)) | (((t27 >> cj) & c1) << (uint4)(27)) | (((t28 >> cj) & c1) << (uint4)(28)) | (((t29 >> cj) & c1) << (uint4)(29)) | (((t30 >> cj) & c1) << (uint4)(30)) | (((t31 >> cj) & c1) << (uint4)(31));
  }
}