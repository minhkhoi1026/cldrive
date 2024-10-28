//{"in":0,"input_size":4,"intstate_in":7,"intstate_out":6,"local_w":8,"num_rounds":3,"out":2,"state_in":9,"state_out":10,"temp_column":5,"w":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
uchar gf16_squarer(uchar value) {
  return ((((value) & (1 << (3))) >> (3)) << 3) | (((((value) & (1 << (3))) >> (3)) ^ (((value) & (1 << (2))) >> (2))) << 2) | (((((value) & (1 << (2))) >> (2)) ^ (((value) & (1 << (1))) >> (1))) << 1) | (((((value) & (1 << (3))) >> (3)) ^ (((value) & (1 << (1))) >> (1)) ^ (((value) & (1 << (0))) >> (0))));
}

uchar gf16_mult_by_lambda(uchar value) {
  return (((((value) & (1 << (2))) >> (2)) ^ (((value) & (1 << (0))) >> (0))) << 3) | (((((value) & (1 << (3))) >> (3)) ^ (((value) & (1 << (2))) >> (2)) ^ (((value) & (1 << (1))) >> (1)) ^ (((value) & (1 << (0))) >> (0))) << 2) | (((((value) & (1 << (3))) >> (3))) << 1) | (((((value) & (1 << (2))) >> (2))));
}

uchar gf4_mult_by_psi(uchar value) {
  return (((((value) & (1 << (1))) >> (1)) ^ (((value) & (1 << (0))) >> (0))) << 1) | (((((value) & (1 << (1))) >> (1))));
}

uchar gf4_mult(uchar a, uchar b) {
  return ((((((a) & (1 << (1))) >> (1)) & (((b) & (1 << (1))) >> (1))) ^ ((((a) & (1 << (0))) >> (0)) & (((b) & (1 << (1))) >> (1))) ^ ((((a) & (1 << (1))) >> (1)) & (((b) & (1 << (0))) >> (0)))) << 1) | ((((((a) & (1 << (1))) >> (1)) & (((b) & (1 << (1))) >> (1))) ^ ((((a) & (1 << (0))) >> (0)) & (((b) & (1 << (0))) >> (0)))));
}

uchar gf16_mult(uchar a, uchar b) {
  uchar a_hi = (((a)&0b1100) >> 2);
  uchar a_lo = ((a)&0b0011);
  uchar b_hi = (((b)&0b1100) >> 2);
  uchar b_lo = ((b)&0b0011);

  uchar result_upper = gf4_mult(a_hi, b_hi) ^ gf4_mult(a_hi, b_lo) ^ gf4_mult(a_lo, b_hi);
  uchar result_lower = gf4_mult_by_psi(gf4_mult(a_hi, b_hi)) ^ gf4_mult(a_lo, b_lo);

  return ((((result_upper)&0b0011) << 2) | ((result_lower)&0b0011));
}

uchar gf16_multiplicative_inverse(uchar value) {
  uchar v3 = (((value) & (1 << (3))) >> (3));
  uchar v2 = (((value) & (1 << (2))) >> (2));
  uchar v1 = (((value) & (1 << (1))) >> (1));
  uchar v0 = (((value) & (1 << (0))) >> (0));
  return ((v3 ^ (v3 & v2 & v1) ^ (v3 & v0) ^ v2) << 3) | (((v3 & v2 & v1) ^ (v3 & v2 & v0) ^ (v3 & v0) ^ v2 ^ (v2 & v1)) << 2) | ((v3 ^ (v3 & v2 & v1) ^ (v3 & v1 & v0) ^ v2 ^ (v2 & v0) ^ v1) << 1) | (((v3 & v2 & v1) ^ (v3 & v2 & v0) ^ (v3 & v1) ^ (v3 & v1 & v0) ^ (v3 & v0) ^ v2 ^ (v2 & v1) ^ (v2 & v1 & v0) ^ v1 ^ v0));
}

uchar gf256_multiplicative_inverse(uchar value) {
  uchar value_composite = ((((((value) & (1 << (7))) >> (7)) ^ (((value) & (1 << (5))) >> (5))) << 7) | (((((value) & (1 << (7))) >> (7)) ^ (((value) & (1 << (6))) >> (6)) ^ (((value) & (1 << (4))) >> (4)) ^ (((value) & (1 << (3))) >> (3)) ^ (((value) & (1 << (2))) >> (2)) ^ (((value) & (1 << (1))) >> (1))) << 6) | (((((value) & (1 << (7))) >> (7)) ^ (((value) & (1 << (5))) >> (5)) ^ (((value) & (1 << (3))) >> (3)) ^ (((value) & (1 << (2))) >> (2))) << 5) | (((((value) & (1 << (7))) >> (7)) ^ (((value) & (1 << (5))) >> (5)) ^ (((value) & (1 << (3))) >> (3)) ^ (((value) & (1 << (2))) >> (2)) ^ (((value) & (1 << (1))) >> (1))) << 4) | (((((value) & (1 << (7))) >> (7)) ^ (((value) & (1 << (6))) >> (6)) ^ (((value) & (1 << (2))) >> (2)) ^ (((value) & (1 << (1))) >> (1))) << 3) | (((((value) & (1 << (7))) >> (7)) ^ (((value) & (1 << (4))) >> (4)) ^ (((value) & (1 << (3))) >> (3)) ^ (((value) & (1 << (2))) >> (2)) ^ (((value) & (1 << (1))) >> (1))) << 2) | (((((value) & (1 << (6))) >> (6)) ^ (((value) & (1 << (4))) >> (4)) ^ (((value) & (1 << (1))) >> (1))) << 1) | (((((value) & (1 << (6))) >> (6)) ^ (((value) & (1 << (1))) >> (1)) ^ (((value) & (1 << (0))) >> (0)))));

  uchar value_high = (((value_composite)&0xF0) >> 4);
  uchar value_low = ((value_composite)&0x0F);

  uchar hi_square = gf16_squarer(value_high);
  uchar hi_square_lambda = gf16_mult_by_lambda(hi_square);
  uchar lohi_sum = value_high ^ value_low;
  uchar lo_lohi_prod = gf16_mult(value_low, lohi_sum);

  uchar common_term = gf16_multiplicative_inverse(hi_square_lambda ^ lo_lohi_prod);

  uchar result_hi_composite = gf16_mult(value_high, common_term);
  uchar result_lo_composite = gf16_mult(lohi_sum, common_term);

  uchar result_composite = ((((result_hi_composite)&0x0F) << 4) | ((result_lo_composite)&0x0F));

  return ((((((result_composite) & (1 << (7))) >> (7)) ^ (((result_composite) & (1 << (6))) >> (6)) ^ (((result_composite) & (1 << (5))) >> (5)) ^ (((result_composite) & (1 << (1))) >> (1))) << 7) | (((((result_composite) & (1 << (6))) >> (6)) ^ (((result_composite) & (1 << (2))) >> (2))) << 6) | (((((result_composite) & (1 << (6))) >> (6)) ^ (((result_composite) & (1 << (5))) >> (5)) ^ (((result_composite) & (1 << (1))) >> (1))) << 5) | (((((result_composite) & (1 << (6))) >> (6)) ^ (((result_composite) & (1 << (5))) >> (5)) ^ (((result_composite) & (1 << (4))) >> (4)) ^ (((result_composite) & (1 << (2))) >> (2)) ^ (((result_composite) & (1 << (1))) >> (1))) << 4) | (((((result_composite) & (1 << (5))) >> (5)) ^ (((result_composite) & (1 << (4))) >> (4)) ^ (((result_composite) & (1 << (3))) >> (3)) ^ (((result_composite) & (1 << (2))) >> (2)) ^ (((result_composite) & (1 << (1))) >> (1))) << 3) | (((((result_composite) & (1 << (7))) >> (7)) ^ (((result_composite) & (1 << (4))) >> (4)) ^ (((result_composite) & (1 << (3))) >> (3)) ^ (((result_composite) & (1 << (2))) >> (2)) ^ (((result_composite) & (1 << (1))) >> (1))) << 2) | (((((result_composite) & (1 << (5))) >> (5)) ^ (((result_composite) & (1 << (4))) >> (4))) << 1) | (((((result_composite) & (1 << (6))) >> (6)) ^ (((result_composite) & (1 << (5))) >> (5)) ^ (((result_composite) & (1 << (4))) >> (4)) ^ (((result_composite) & (1 << (2))) >> (2)) ^ (((result_composite) & (1 << (0))) >> (0)))));
}

uchar sbox(uchar value) {
  uchar inverse = gf256_multiplicative_inverse(value);
  return ((((((inverse) & (1 << (7))) >> (7)) ^ (((inverse) & (1 << (6))) >> (6)) ^ (((inverse) & (1 << (5))) >> (5)) ^ (((inverse) & (1 << (4))) >> (4)) ^ (((inverse) & (1 << (3))) >> (3))) << 7) | (((((inverse) & (1 << (6))) >> (6)) ^ (((inverse) & (1 << (5))) >> (5)) ^ (((inverse) & (1 << (4))) >> (4)) ^ (((inverse) & (1 << (3))) >> (3)) ^ (((inverse) & (1 << (2))) >> (2)) ^ 1) << 6) | (((((inverse) & (1 << (5))) >> (5)) ^ (((inverse) & (1 << (4))) >> (4)) ^ (((inverse) & (1 << (3))) >> (3)) ^ (((inverse) & (1 << (2))) >> (2)) ^ (((inverse) & (1 << (1))) >> (1)) ^ 1) << 5) | (((((inverse) & (1 << (4))) >> (4)) ^ (((inverse) & (1 << (3))) >> (3)) ^ (((inverse) & (1 << (2))) >> (2)) ^ (((inverse) & (1 << (1))) >> (1)) ^ (((inverse) & (1 << (0))) >> (0))) << 4) | (((((inverse) & (1 << (7))) >> (7)) ^ (((inverse) & (1 << (3))) >> (3)) ^ (((inverse) & (1 << (2))) >> (2)) ^ (((inverse) & (1 << (1))) >> (1)) ^ (((inverse) & (1 << (0))) >> (0))) << 3) | (((((inverse) & (1 << (7))) >> (7)) ^ (((inverse) & (1 << (6))) >> (6)) ^ (((inverse) & (1 << (2))) >> (2)) ^ (((inverse) & (1 << (1))) >> (1)) ^ (((inverse) & (1 << (0))) >> (0))) << 2) | (((((inverse) & (1 << (7))) >> (7)) ^ (((inverse) & (1 << (6))) >> (6)) ^ (((inverse) & (1 << (5))) >> (5)) ^ (((inverse) & (1 << (1))) >> (1)) ^ (((inverse) & (1 << (0))) >> (0)) ^ 1) << 1) | (((((inverse) & (1 << (7))) >> (7)) ^ (((inverse) & (1 << (6))) >> (6)) ^ (((inverse) & (1 << (5))) >> (5)) ^ (((inverse) & (1 << (4))) >> (4)) ^ (((inverse) & (1 << (0))) >> (0)) ^ 1)));
}

uchar sbox_inv(uchar value) {
  uchar affine = ((((((value) & (1 << (6))) >> (6)) ^ (((value) & (1 << (4))) >> (4)) ^ (((value) & (1 << (1))) >> (1))) << 7) | (((((value) & (1 << (5))) >> (5)) ^ (((value) & (1 << (3))) >> (3)) ^ (((value) & (1 << (0))) >> (0))) << 6) | (((((value) & (1 << (7))) >> (7)) ^ (((value) & (1 << (4))) >> (4)) ^ (((value) & (1 << (2))) >> (2))) << 5) | (((((value) & (1 << (6))) >> (6)) ^ (((value) & (1 << (3))) >> (3)) ^ (((value) & (1 << (1))) >> (1))) << 4) | (((((value) & (1 << (5))) >> (5)) ^ (((value) & (1 << (2))) >> (2)) ^ (((value) & (1 << (0))) >> (0))) << 3) | (((((value) & (1 << (7))) >> (7)) ^ (((value) & (1 << (4))) >> (4)) ^ (((value) & (1 << (1))) >> (1)) ^ 1) << 2) | (((((value) & (1 << (6))) >> (6)) ^ (((value) & (1 << (3))) >> (3)) ^ (((value) & (1 << (0))) >> (0))) << 1) | (((((value) & (1 << (7))) >> (7)) ^ (((value) & (1 << (5))) >> (5)) ^ (((value) & (1 << (2))) >> (2)) ^ 1)));
  return gf256_multiplicative_inverse(affine);
}

void sub_bytes(private uchar* in, private uchar* out) {
  for (int i = 0; i < 16u; ++i) {
    out[hook(2, i)] = sbox(in[hook(0, i)]);
  }
}

void sub_bytes_inv(private uchar* in, private uchar* out) {
  for (int i = 0; i < 16u; ++i) {
    out[hook(2, i)] = sbox_inv(in[hook(0, i)]);
  }
}

void mix_columns(private uchar* in, private uchar* out) {
  uchar byte_value, byte_value_2;
 private
  uchar temp_column[16u];
  for (size_t col = 0; col < 4u; col++) {
    for (size_t i = 0; i < 4u; i++) {
      temp_column[hook(5, i)] = 0;
    }

    for (size_t j = 0; j < 4u; j++) {
      byte_value = in[hook(0, col * 4U + j)];

      byte_value_2 = (((byte_value) << 1u) ^ ((-((byte_value) >= 0x80u)) & 0x1Bu));
      temp_column[hook(5, (j + 0) % 4U)] ^= byte_value_2;
      temp_column[hook(5, (j + 1U) % 4U)] ^= byte_value;
      temp_column[hook(5, (j + 2U) % 4U)] ^= byte_value;
      temp_column[hook(5, (j + 3U) % 4U)] ^= byte_value ^ byte_value_2;
    }

    for (size_t k = 0; k < 4u; k++) {
      out[hook(2, col * 4U + k)] = temp_column[hook(5, k)];
    }
  }
}

void mix_columns_inv(private uchar* in, private uchar* out) {
  uchar byte_value, byte_value_2, byte_value_4, byte_value_8;
 private
  uchar temp_column[16u];
  for (size_t col = 0; col < 4u; col++) {
    for (size_t i = 0; i < 4u; i++) {
      temp_column[hook(5, i)] = 0;
    }
    for (size_t j = 0; j < 4u; j++) {
      byte_value = in[hook(0, col * 4U + j)];
      byte_value_2 = (((byte_value) << 1u) ^ ((-((byte_value) >= 0x80u)) & 0x1Bu));
      byte_value_4 = (((byte_value_2) << 1u) ^ ((-((byte_value_2) >= 0x80u)) & 0x1Bu));
      byte_value_8 = (((byte_value_4) << 1u) ^ ((-((byte_value_4) >= 0x80u)) & 0x1Bu));
      temp_column[hook(5, (j + 0) % 4U)] ^= byte_value_8 ^ byte_value_4 ^ byte_value_2;
      temp_column[hook(5, (j + 1U) % 4U)] ^= byte_value_8 ^ byte_value;
      temp_column[hook(5, (j + 2U) % 4U)] ^= byte_value_8 ^ byte_value_4 ^ byte_value;
      temp_column[hook(5, (j + 3U) % 4U)] ^= byte_value_8 ^ byte_value_2 ^ byte_value;
    }
    for (size_t k = 0; k < 4u; k++) {
      out[hook(2, col * 4U + k)] = temp_column[hook(5, k)];
    }
  }
}

void shift_rows(private uchar* in, private uchar* out) {
  out[hook(2, 0)] = in[hook(0, 0)];
  out[hook(2, 1)] = in[hook(0, 5)];
  out[hook(2, 2)] = in[hook(0, 10)];
  out[hook(2, 3)] = in[hook(0, 15)];
  out[hook(2, 4)] = in[hook(0, 4)];
  out[hook(2, 5)] = in[hook(0, 9)];
  out[hook(2, 6)] = in[hook(0, 14)];
  out[hook(2, 7)] = in[hook(0, 3)];
  out[hook(2, 8)] = in[hook(0, 8)];
  out[hook(2, 9)] = in[hook(0, 13)];
  out[hook(2, 10)] = in[hook(0, 2)];
  out[hook(2, 11)] = in[hook(0, 7)];
  out[hook(2, 12)] = in[hook(0, 12)];
  out[hook(2, 13)] = in[hook(0, 1)];
  out[hook(2, 14)] = in[hook(0, 6)];
  out[hook(2, 15)] = in[hook(0, 11)];
}

void shift_rows_inv(private uchar* in, private uchar* out) {
  out[hook(2, 0)] = in[hook(0, 0)];
  out[hook(2, 1)] = in[hook(0, 13)];
  out[hook(2, 2)] = in[hook(0, 10)];
  out[hook(2, 3)] = in[hook(0, 7)];
  out[hook(2, 4)] = in[hook(0, 4)];
  out[hook(2, 5)] = in[hook(0, 1)];
  out[hook(2, 6)] = in[hook(0, 14)];
  out[hook(2, 7)] = in[hook(0, 11)];
  out[hook(2, 8)] = in[hook(0, 8)];
  out[hook(2, 9)] = in[hook(0, 5)];
  out[hook(2, 10)] = in[hook(0, 2)];
  out[hook(2, 11)] = in[hook(0, 15)];
  out[hook(2, 12)] = in[hook(0, 12)];
  out[hook(2, 13)] = in[hook(0, 9)];
  out[hook(2, 14)] = in[hook(0, 6)];
  out[hook(2, 15)] = in[hook(0, 3)];
}

void aes_key_independent_enc_round(private uchar* state_in, private uchar* state_out) {
 private
  uchar temp1[16u];
 private
  uchar temp2[16u];
  sub_bytes(state_in, temp1);
  shift_rows(temp1, temp2);
  mix_columns(temp2, state_out);
}

void aes_key_independent_enc_round_final(private uchar* state_in, private uchar* state_out) {
 private
  uchar temp1[16u];
  sub_bytes(state_in, temp1);
  shift_rows(temp1, state_out);
}

void aes_key_independent_dec_round(private uchar* state_in, private uchar* state_out) {
 private
  uchar temp1[16u];
 private
  uchar temp2[16u];
  mix_columns_inv(state_in, temp1);
  shift_rows_inv(temp1, temp2);
  sub_bytes_inv(temp2, state_out);
}

void aes_key_independent_dec_round_initial(private uchar* state_in, private uchar* state_out) {
 private
  uchar temp1[16u];
  shift_rows_inv(state_in, temp1);
  sub_bytes_inv(temp1, state_out);
}

void add_round_key(private uchar* state_in, private unsigned int* w, private uchar* state_out, private size_t i) {
  unsigned int* intstate_in = (unsigned int*)state_in;
  unsigned int* intstate_out = (unsigned int*)state_out;
  for (size_t j = 0; j < 4u; ++j) {
    unsigned int keyword = w[hook(1, i + j)];
    intstate_out[hook(6, j)] = intstate_in[hook(7, j)] ^ ((((keyword)&0xFF000000) >> 24) | (((keyword)&0x00FF0000) >> 8) | (((keyword)&0x0000FF00) << 8) | (((keyword)&0x000000FF) << 24));
  }
}

void encrypt(private uchar state_in[16u], private unsigned int* w, private uchar state_out[16u], unsigned int num_rounds) {
 private
  uchar temp1[16u];
 private
  uchar temp2[16u];
  add_round_key(state_in, w, temp1, 0);
  for (size_t r = 1; r < num_rounds; r++) {
    aes_key_independent_enc_round(temp1, temp2);
    add_round_key(temp2, w, temp1, r * 4u);
  }

  aes_key_independent_enc_round_final(temp1, temp2);
  add_round_key(temp2, w, state_out, num_rounds * 4u);
}

void decrypt(private uchar state_in[16u], private unsigned int* w, private uchar state_out[16u], unsigned int num_rounds) {
 private
  uchar temp1[16u];
 private
  uchar temp2[16u];
  add_round_key(state_in, w, temp1, 0);
  aes_key_independent_dec_round_initial(temp1, temp2);

  for (size_t r = 1; r < num_rounds; r++) {
    add_round_key(temp2, w, temp1, r * 4u);
    aes_key_independent_dec_round(temp1, temp2);
  }

  add_round_key(temp2, w, state_out, num_rounds * 4u);
}

void copy_extkey_to_local(private unsigned int* local_w, global unsigned int* restrict w) {
  for (size_t i = 0; i < 60; ++i) {
    local_w[hook(8, i)] = w[hook(1, i)];
  }
}

__attribute__((reqd_work_group_size(1, 1, 1))) kernel void aesEncCipher(global uchar* restrict in, global unsigned int* restrict w, global uchar* restrict out, unsigned int num_rounds, unsigned int input_size) {
 private
  uchar state_in[16u];
 private
  uchar state_out[16u];
 private
  unsigned int local_w[60];
  copy_extkey_to_local(local_w, w);

  for (size_t blockid = 0; blockid < input_size / 16u; blockid++) {
    for (size_t i = 0; i < 16u; ++i) {
      size_t offset = blockid * 16u + i;
      state_in[hook(9, i)] = in[hook(0, offset)];
    }
    encrypt(state_in, local_w, state_out, num_rounds);
    for (size_t i = 0; i < 16u; i++) {
      size_t offset = blockid * 16u + i;
      out[hook(2, offset)] = state_out[hook(10, i)];
    }
  }
}