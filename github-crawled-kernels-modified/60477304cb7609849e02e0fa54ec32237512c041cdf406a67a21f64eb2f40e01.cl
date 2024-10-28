//{"in":0,"input_size":3,"intstate_in":8,"intstate_out":7,"local_w":9,"out":2,"sbox":4,"sbox_inv":5,"state_in":10,"state_out":11,"temp_column":6,"w":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant uchar sbox[256] = {0x63, 0x7C, 0x77, 0x7B, 0xF2, 0x6B, 0x6F, 0xC5, 0x30, 0x01, 0x67, 0x2B, 0xFE, 0xD7, 0xAB, 0x76, 0xCA, 0x82, 0xC9, 0x7D, 0xFA, 0x59, 0x47, 0xF0, 0xAD, 0xD4, 0xA2, 0xAF, 0x9C, 0xA4, 0x72, 0xC0, 0xB7, 0xFD, 0x93, 0x26, 0x36, 0x3F, 0xF7, 0xCC, 0x34, 0xA5, 0xE5, 0xF1, 0x71, 0xD8, 0x31, 0x15, 0x04, 0xC7, 0x23, 0xC3, 0x18, 0x96, 0x05, 0x9A, 0x07, 0x12, 0x80, 0xE2, 0xEB, 0x27, 0xB2, 0x75, 0x09, 0x83, 0x2C, 0x1A, 0x1B, 0x6E, 0x5A, 0xA0, 0x52, 0x3B, 0xD6, 0xB3, 0x29, 0xE3, 0x2F, 0x84, 0x53, 0xD1, 0x00, 0xED, 0x20, 0xFC, 0xB1, 0x5B, 0x6A, 0xCB, 0xBE, 0x39, 0x4A, 0x4C, 0x58, 0xCF, 0xD0, 0xEF, 0xAA, 0xFB, 0x43, 0x4D, 0x33, 0x85, 0x45, 0xF9, 0x02, 0x7F, 0x50, 0x3C, 0x9F, 0xA8, 0x51, 0xA3, 0x40, 0x8F, 0x92, 0x9D, 0x38, 0xF5, 0xBC, 0xB6, 0xDA, 0x21, 0x10, 0xFF, 0xF3, 0xD2, 0xCD, 0x0C, 0x13, 0xEC, 0x5F, 0x97, 0x44, 0x17, 0xC4, 0xA7, 0x7E, 0x3D, 0x64, 0x5D, 0x19, 0x73, 0x60, 0x81, 0x4F, 0xDC, 0x22, 0x2A, 0x90, 0x88, 0x46, 0xEE, 0xB8, 0x14, 0xDE, 0x5E, 0x0B, 0xDB, 0xE0, 0x32, 0x3A, 0x0A, 0x49, 0x06, 0x24, 0x5C, 0xC2, 0xD3, 0xAC, 0x62, 0x91, 0x95, 0xE4, 0x79, 0xE7, 0xC8, 0x37, 0x6D, 0x8D, 0xD5, 0x4E, 0xA9, 0x6C, 0x56, 0xF4, 0xEA, 0x65, 0x7A, 0xAE, 0x08, 0xBA, 0x78, 0x25, 0x2E, 0x1C, 0xA6, 0xB4, 0xC6, 0xE8, 0xDD, 0x74, 0x1F, 0x4B, 0xBD, 0x8B, 0x8A, 0x70, 0x3E, 0xB5, 0x66, 0x48, 0x03, 0xF6, 0x0E, 0x61, 0x35, 0x57, 0xB9, 0x86, 0xC1, 0x1D, 0x9E, 0xE1, 0xF8, 0x98, 0x11, 0x69, 0xD9, 0x8E, 0x94, 0x9B, 0x1E, 0x87, 0xE9, 0xCE, 0x55, 0x28, 0xDF, 0x8C, 0xA1, 0x89, 0x0D, 0xBF, 0xE6, 0x42, 0x68, 0x41, 0x99, 0x2D, 0x0F, 0xB0, 0x54, 0xBB, 0x16};

constant uchar sbox_inv[256] = {0x52, 0x09, 0x6A, 0xD5, 0x30, 0x36, 0xA5, 0x38, 0xBF, 0x40, 0xA3, 0x9E, 0x81, 0xF3, 0xD7, 0xFB, 0x7C, 0xE3, 0x39, 0x82, 0x9B, 0x2F, 0xFF, 0x87, 0x34, 0x8E, 0x43, 0x44, 0xC4, 0xDE, 0xE9, 0xCB, 0x54, 0x7B, 0x94, 0x32, 0xA6, 0xC2, 0x23, 0x3D, 0xEE, 0x4C, 0x95, 0x0B, 0x42, 0xFA, 0xC3, 0x4E, 0x08, 0x2E, 0xA1, 0x66, 0x28, 0xD9, 0x24, 0xB2, 0x76, 0x5B, 0xA2, 0x49, 0x6D, 0x8B, 0xD1, 0x25, 0x72, 0xF8, 0xF6, 0x64, 0x86, 0x68, 0x98, 0x16, 0xD4, 0xA4, 0x5C, 0xCC, 0x5D, 0x65, 0xB6, 0x92, 0x6C, 0x70, 0x48, 0x50, 0xFD, 0xED, 0xB9, 0xDA, 0x5E, 0x15, 0x46, 0x57, 0xA7, 0x8D, 0x9D, 0x84, 0x90, 0xD8, 0xAB, 0x00, 0x8C, 0xBC, 0xD3, 0x0A, 0xF7, 0xE4, 0x58, 0x05, 0xB8, 0xB3, 0x45, 0x06, 0xD0, 0x2C, 0x1E, 0x8F, 0xCA, 0x3F, 0x0F, 0x02, 0xC1, 0xAF, 0xBD, 0x03, 0x01, 0x13, 0x8A, 0x6B, 0x3A, 0x91, 0x11, 0x41, 0x4F, 0x67, 0xDC, 0xEA, 0x97, 0xF2, 0xCF, 0xCE, 0xF0, 0xB4, 0xE6, 0x73, 0x96, 0xAC, 0x74, 0x22, 0xE7, 0xAD, 0x35, 0x85, 0xE2, 0xF9, 0x37, 0xE8, 0x1C, 0x75, 0xDF, 0x6E, 0x47, 0xF1, 0x1A, 0x71, 0x1D, 0x29, 0xC5, 0x89, 0x6F, 0xB7, 0x62, 0x0E, 0xAA, 0x18, 0xBE, 0x1B, 0xFC, 0x56, 0x3E, 0x4B, 0xC6, 0xD2, 0x79, 0x20, 0x9A, 0xDB, 0xC0, 0xFE, 0x78, 0xCD, 0x5A, 0xF4, 0x1F, 0xDD, 0xA8, 0x33, 0x88, 0x07, 0xC7, 0x31, 0xB1, 0x12, 0x10, 0x59, 0x27, 0x80, 0xEC, 0x5F, 0x60, 0x51, 0x7F, 0xA9, 0x19, 0xB5, 0x4A, 0x0D, 0x2D, 0xE5, 0x7A, 0x9F, 0x93, 0xC9, 0x9C, 0xEF, 0xA0, 0xE0, 0x3B, 0x4D, 0xAE, 0x2A, 0xF5, 0xB0, 0xC8, 0xEB, 0xBB, 0x3C, 0x83, 0x53, 0x99, 0x61, 0x17, 0x2B, 0x04, 0x7E, 0xBA, 0x77, 0xD6, 0x26, 0xE1, 0x69, 0x14, 0x63, 0x55, 0x21, 0x0C, 0x7D};

void sub_bytes(private uchar* in, private uchar* out) {
  for (int i = 0; i < 16u; ++i) {
    out[hook(2, i)] = sbox[hook(4, in[ihook(0, i))];
  }
}

void sub_bytes_inv(private uchar* in, private uchar* out) {
  for (int i = 0; i < 16u; ++i) {
    out[hook(2, i)] = sbox_inv[hook(5, in[ihook(0, i))];
  }
}

void mix_columns(private uchar* in, private uchar* out) {
  uchar byte_value, byte_value_2;
 private
  uchar temp_column[16u];
  for (size_t col = 0; col < 4u; col++) {
    for (size_t i = 0; i < 4u; i++) {
      temp_column[hook(6, i)] = 0;
    }

    for (size_t j = 0; j < 4u; j++) {
      byte_value = in[hook(0, col * 4U + j)];

      byte_value_2 = (((byte_value) << 1u) ^ ((-((byte_value) >= 0x80u)) & 0x1Bu));
      temp_column[hook(6, (j + 0) % 4U)] ^= byte_value_2;
      temp_column[hook(6, (j + 1U) % 4U)] ^= byte_value;
      temp_column[hook(6, (j + 2U) % 4U)] ^= byte_value;
      temp_column[hook(6, (j + 3U) % 4U)] ^= byte_value ^ byte_value_2;
    }

    for (size_t k = 0; k < 4u; k++) {
      out[hook(2, col * 4U + k)] = temp_column[hook(6, k)];
    }
  }
}

void mix_columns_inv(private uchar* in, private uchar* out) {
  uchar byte_value, byte_value_2, byte_value_4, byte_value_8;
 private
  uchar temp_column[16u];
  for (size_t col = 0; col < 4u; col++) {
    for (size_t i = 0; i < 4u; i++) {
      temp_column[hook(6, i)] = 0;
    }
    for (size_t j = 0; j < 4u; j++) {
      byte_value = in[hook(0, col * 4U + j)];
      byte_value_2 = (((byte_value) << 1u) ^ ((-((byte_value) >= 0x80u)) & 0x1Bu));
      byte_value_4 = (((byte_value_2) << 1u) ^ ((-((byte_value_2) >= 0x80u)) & 0x1Bu));
      byte_value_8 = (((byte_value_4) << 1u) ^ ((-((byte_value_4) >= 0x80u)) & 0x1Bu));
      temp_column[hook(6, (j + 0) % 4U)] ^= byte_value_8 ^ byte_value_4 ^ byte_value_2;
      temp_column[hook(6, (j + 1U) % 4U)] ^= byte_value_8 ^ byte_value;
      temp_column[hook(6, (j + 2U) % 4U)] ^= byte_value_8 ^ byte_value_4 ^ byte_value;
      temp_column[hook(6, (j + 3U) % 4U)] ^= byte_value_8 ^ byte_value_2 ^ byte_value;
    }
    for (size_t k = 0; k < 4u; k++) {
      out[hook(2, col * 4U + k)] = temp_column[hook(6, k)];
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
    intstate_out[hook(7, j)] = intstate_in[hook(8, j)] ^ ((((keyword)&0xFF000000) >> 24) | (((keyword)&0x00FF0000) >> 8) | (((keyword)&0x0000FF00) << 8) | (((keyword)&0x000000FF) << 24));
  }
}
void encrypt_128(private uchar state_in[16u], private unsigned int* w, private uchar state_out[16u]) {
 private
  uchar temp_state1[16u];
 private
  uchar temp_state2[16u];
  add_round_key(state_in, w, temp_state2, 0);
  {
    size_t r = 1;
    for (size_t c = 0; c < ((10 / 2) - 1); c++) {
      aes_key_independent_enc_round(temp_state2, temp_state1);
      add_round_key(temp_state1, w, temp_state2, r * 4u);
      ++r;
      aes_key_independent_enc_round(temp_state2, temp_state1);
      add_round_key(temp_state1, w, temp_state2, r * 4u);
      ++r;
    }
    aes_key_independent_enc_round(temp_state2, temp_state1);
    add_round_key(temp_state1, w, temp_state2, r * 4u);
  };
  aes_key_independent_enc_round_final(temp_state2, temp_state1);
  add_round_key(temp_state1, w, state_out, 10 * 4u);
}

void encrypt_192(private uchar state_in[16u], private unsigned int* w, private uchar state_out[16u]) {
 private
  uchar temp_state1[16u];
 private
  uchar temp_state2[16u];
  add_round_key(state_in, w, temp_state2, 0);
  {
    size_t r = 1;
    for (size_t c = 0; c < ((12 / 2) - 1); c++) {
      aes_key_independent_enc_round(temp_state2, temp_state1);
      add_round_key(temp_state1, w, temp_state2, r * 4u);
      ++r;
      aes_key_independent_enc_round(temp_state2, temp_state1);
      add_round_key(temp_state1, w, temp_state2, r * 4u);
      ++r;
    }
    aes_key_independent_enc_round(temp_state2, temp_state1);
    add_round_key(temp_state1, w, temp_state2, r * 4u);
  };
  aes_key_independent_enc_round_final(temp_state2, temp_state1);
  add_round_key(temp_state1, w, state_out, 12 * 4u);
}

void encrypt_256(private uchar state_in[16u], private unsigned int* w, private uchar state_out[16u]) {
 private
  uchar temp_state1[16u];
 private
  uchar temp_state2[16u];
  add_round_key(state_in, w, temp_state2, 0);
  {
    size_t r = 1;
    for (size_t c = 0; c < ((14 / 2) - 1); c++) {
      aes_key_independent_enc_round(temp_state2, temp_state1);
      add_round_key(temp_state1, w, temp_state2, r * 4u);
      ++r;
      aes_key_independent_enc_round(temp_state2, temp_state1);
      add_round_key(temp_state1, w, temp_state2, r * 4u);
      ++r;
    }
    aes_key_independent_enc_round(temp_state2, temp_state1);
    add_round_key(temp_state1, w, temp_state2, r * 4u);
  };
  aes_key_independent_enc_round_final(temp_state2, temp_state1);
  add_round_key(temp_state1, w, state_out, 14 * 4u);
}
void decrypt_128(private uchar state_in[16u], private unsigned int* w, private uchar state_out[16u]) {
 private
  uchar temp_state1[16u];
 private
  uchar temp_state2[16u];
  add_round_key(state_in, w, temp_state1, 0);
  aes_key_independent_dec_round_initial(temp_state1, temp_state2);
  {
    size_t r = 1;
    for (size_t c = 0; c < ((10 / 2) - 1); c++) {
      add_round_key(temp_state2, w, temp_state1, r * 4u);
      aes_key_independent_dec_round(temp_state1, temp_state2);
      ++r;
      add_round_key(temp_state2, w, temp_state1, r * 4u);
      aes_key_independent_dec_round(temp_state1, temp_state2);
      ++r;
    }
    add_round_key(temp_state2, w, temp_state1, r * 4u);
    aes_key_independent_dec_round(temp_state1, temp_state2);
  };
  add_round_key(temp_state2, w, state_out, 10 * 4u);
}

void decrypt_192(private uchar state_in[16u], private unsigned int* w, private uchar state_out[16u]) {
 private
  uchar temp_state1[16u];
 private
  uchar temp_state2[16u];
  add_round_key(state_in, w, temp_state1, 0);
  aes_key_independent_dec_round_initial(temp_state1, temp_state2);
  {
    size_t r = 1;
    for (size_t c = 0; c < ((12 / 2) - 1); c++) {
      add_round_key(temp_state2, w, temp_state1, r * 4u);
      aes_key_independent_dec_round(temp_state1, temp_state2);
      ++r;
      add_round_key(temp_state2, w, temp_state1, r * 4u);
      aes_key_independent_dec_round(temp_state1, temp_state2);
      ++r;
    }
    add_round_key(temp_state2, w, temp_state1, r * 4u);
    aes_key_independent_dec_round(temp_state1, temp_state2);
  };
  add_round_key(temp_state2, w, state_out, 12 * 4u);
}

void decrypt_256(private uchar state_in[16u], private unsigned int* w, private uchar state_out[16u]) {
 private
  uchar temp_state1[16u];
 private
  uchar temp_state2[16u];
  add_round_key(state_in, w, temp_state1, 0);
  aes_key_independent_dec_round_initial(temp_state1, temp_state2);
  {
    size_t r = 1;
    for (size_t c = 0; c < ((14 / 2) - 1); c++) {
      add_round_key(temp_state2, w, temp_state1, r * 4u);
      aes_key_independent_dec_round(temp_state1, temp_state2);
      ++r;
      add_round_key(temp_state2, w, temp_state1, r * 4u);
      aes_key_independent_dec_round(temp_state1, temp_state2);
      ++r;
    }
    add_round_key(temp_state2, w, temp_state1, r * 4u);
    aes_key_independent_dec_round(temp_state1, temp_state2);
  };
  add_round_key(temp_state2, w, state_out, 14 * 4u);
}

void copy_extkey_to_local(private unsigned int* local_w, global unsigned int* restrict w) {
  for (size_t i = 0; i < 64; ++i) {
    local_w[hook(9, i)] = w[hook(1, i)];
  }
}
__attribute__((reqd_work_group_size(1, 1, 1))) __attribute__((reqd_work_group_size(1, 1, 1))) __attribute__((reqd_work_group_size(1, 1, 1))) kernel void aes256EncCipher(global uchar* restrict in, global unsigned int* restrict w, global uchar* restrict out, unsigned int input_size) {
 private
  uchar state_in[16u];
 private
  uchar state_out[16u];
  unsigned int __attribute__((register)) local_w[64];
  copy_extkey_to_local(local_w, w);
  for (size_t blockid = 0; blockid < input_size / 16u; blockid++) {
    for (size_t i = 0; i < 16u; ++i) {
      size_t offset = blockid * 16u + i;
      state_in[hook(10, i)] = in[hook(0, offset)];
    }
    encrypt_256(state_in, local_w, state_out);
    for (size_t i = 0; i < 16u; i++) {
      size_t offset = blockid * 16u + i;
      out[hook(2, offset)] = state_out[hook(11, i)];
    }
  }
}