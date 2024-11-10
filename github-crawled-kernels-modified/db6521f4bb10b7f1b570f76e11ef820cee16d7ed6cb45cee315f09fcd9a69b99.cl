//{"p_3->g_2":4,"p_3->g_2[4]":3,"p_3->g_2[4][1]":2,"p_3->g_2[i]":6,"p_3->g_2[i][j]":5,"result":0,"sequence_input":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline __attribute__((always_inline)) void transparent_crc_no_string(ulong* crc64_context, ulong val) {
  *crc64_context += val;
}

inline __attribute__((always_inline)) unsigned int get_linear_group_id(void) {
  return (get_group_id(2) * get_num_groups(1) + get_group_id(1)) * get_num_groups(0) + get_group_id(0);
}

inline __attribute__((always_inline)) unsigned int get_linear_global_id(void) {
  return (get_global_id(2) * get_global_size(1) + get_global_id(1)) * get_global_size(0) + get_global_id(0);
}

inline __attribute__((always_inline)) unsigned int get_linear_local_id(void) {
  return (get_local_id(2) * get_local_size(1) + get_local_id(1)) * get_local_size(0) + get_local_id(0);
}

struct S1 {
  uchar g_2[8][3][6];
  ulong global_0_offset;
  ulong global_1_offset;
  ulong global_2_offset;
  ulong local_0_offset;
  ulong local_1_offset;
  ulong local_2_offset;
  ulong group_0_offset;
  ulong group_1_offset;
  ulong group_2_offset;
};

unsigned int func_1(struct S1* p_3);
unsigned int func_1(struct S1* p_3) {
  return p_3->g_2[hook(4, 4)][hook(3, 1)][hook(2, 5)];
}

kernel void entry(global ulong* result, global int* sequence_input) {
  int i, j, k;
  struct S1 c_4;
  struct S1* p_3 = &c_4;
  struct S1 c_5 = {
      {{{0x2FL, 5UL, 5UL, 0x22L, 0xF5L, 255UL}, {0x2FL, 5UL, 5UL, 0x22L, 0xF5L, 255UL}, {0x2FL, 5UL, 5UL, 0x22L, 0xF5L, 255UL}}, {{0x2FL, 5UL, 5UL, 0x22L, 0xF5L, 255UL}, {0x2FL, 5UL, 5UL, 0x22L, 0xF5L, 255UL}, {0x2FL, 5UL, 5UL, 0x22L, 0xF5L, 255UL}}, {{0x2FL, 5UL, 5UL, 0x22L, 0xF5L, 255UL}, {0x2FL, 5UL, 5UL, 0x22L, 0xF5L, 255UL}, {0x2FL, 5UL, 5UL, 0x22L, 0xF5L, 255UL}}, {{0x2FL, 5UL, 5UL, 0x22L, 0xF5L, 255UL}, {0x2FL, 5UL, 5UL, 0x22L, 0xF5L, 255UL}, {0x2FL, 5UL, 5UL, 0x22L, 0xF5L, 255UL}}, {{0x2FL, 5UL, 5UL, 0x22L, 0xF5L, 255UL}, {0x2FL, 5UL, 5UL, 0x22L, 0xF5L, 255UL}, {0x2FL, 5UL, 5UL, 0x22L, 0xF5L, 255UL}}, {{0x2FL, 5UL, 5UL, 0x22L, 0xF5L, 255UL}, {0x2FL, 5UL, 5UL, 0x22L, 0xF5L, 255UL}, {0x2FL, 5UL, 5UL, 0x22L, 0xF5L, 255UL}}, {{0x2FL, 5UL, 5UL, 0x22L, 0xF5L, 255UL}, {0x2FL, 5UL, 5UL, 0x22L, 0xF5L, 255UL}, {0x2FL, 5UL, 5UL, 0x22L, 0xF5L, 255UL}}, {{0x2FL, 5UL, 5UL, 0x22L, 0xF5L, 255UL}, {0x2FL, 5UL, 5UL, 0x22L, 0xF5L, 255UL}, {0x2FL, 5UL, 5UL, 0x22L, 0xF5L, 255UL}}}, sequence_input[hook(1, get_global_id(0))], sequence_input[hook(1, get_global_id(1))], sequence_input[hook(1, get_global_id(2))], sequence_input[hook(1, get_local_id(0))], sequence_input[hook(1, get_local_id(1))], sequence_input[hook(1, get_local_id(2))], sequence_input[hook(1, get_group_id(0))], sequence_input[hook(1, get_group_id(1))], sequence_input[hook(1, get_group_id(2))],
  };
  c_4 = c_5;
  barrier(0x01 | 0x02);
  func_1(p_3);
  barrier(0x01 | 0x02);
  ulong crc64_context = 0xFFFFFFFFFFFFFFFFUL;
  int print_hash_value = 0;
  for (i = 0; i < 8; i++) {
    for (j = 0; j < 3; j++) {
      for (k = 0; k < 6; k++) {
        transparent_crc_no_string(&crc64_context, p_3->g_2[hook(4, i)][hook(6, j)][hook(5, k)]);
      }
    }
  }
  result[hook(0, get_linear_global_id())] = crc64_context ^ 0xFFFFFFFFFFFFFFFFUL;
}