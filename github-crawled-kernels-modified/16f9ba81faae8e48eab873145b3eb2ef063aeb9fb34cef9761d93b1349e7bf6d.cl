//{"g_atomic_input":1,"g_special_values":2,"l_3":6,"l_3[3]":5,"l_3[3][7]":4,"result":0,"sequence_input":3}
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
  ulong g_4;
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

char func_1(struct S1* p_5);
char func_1(struct S1* p_5) {
  int l_2 = 0x6942A1E9L;
  int l_3[6][9][4] = {{{0x356BF5EEL, 0x4C9CA319L, 0x7EF23E46L, (-1L)}, {0x356BF5EEL, 0x4C9CA319L, 0x7EF23E46L, (-1L)}, {0x356BF5EEL, 0x4C9CA319L, 0x7EF23E46L, (-1L)}, {0x356BF5EEL, 0x4C9CA319L, 0x7EF23E46L, (-1L)}, {0x356BF5EEL, 0x4C9CA319L, 0x7EF23E46L, (-1L)}, {0x356BF5EEL, 0x4C9CA319L, 0x7EF23E46L, (-1L)}, {0x356BF5EEL, 0x4C9CA319L, 0x7EF23E46L, (-1L)}, {0x356BF5EEL, 0x4C9CA319L, 0x7EF23E46L, (-1L)}, {0x356BF5EEL, 0x4C9CA319L, 0x7EF23E46L, (-1L)}}, {{0x356BF5EEL, 0x4C9CA319L, 0x7EF23E46L, (-1L)}, {0x356BF5EEL, 0x4C9CA319L, 0x7EF23E46L, (-1L)}, {0x356BF5EEL, 0x4C9CA319L, 0x7EF23E46L, (-1L)}, {0x356BF5EEL, 0x4C9CA319L, 0x7EF23E46L, (-1L)}, {0x356BF5EEL, 0x4C9CA319L, 0x7EF23E46L, (-1L)}, {0x356BF5EEL, 0x4C9CA319L, 0x7EF23E46L, (-1L)}, {0x356BF5EEL, 0x4C9CA319L, 0x7EF23E46L, (-1L)}, {0x356BF5EEL, 0x4C9CA319L, 0x7EF23E46L, (-1L)}, {0x356BF5EEL, 0x4C9CA319L, 0x7EF23E46L, (-1L)}}, {{0x356BF5EEL, 0x4C9CA319L, 0x7EF23E46L, (-1L)}, {0x356BF5EEL, 0x4C9CA319L, 0x7EF23E46L, (-1L)}, {0x356BF5EEL, 0x4C9CA319L, 0x7EF23E46L, (-1L)}, {0x356BF5EEL, 0x4C9CA319L, 0x7EF23E46L, (-1L)}, {0x356BF5EEL, 0x4C9CA319L, 0x7EF23E46L, (-1L)}, {0x356BF5EEL, 0x4C9CA319L, 0x7EF23E46L, (-1L)}, {0x356BF5EEL, 0x4C9CA319L, 0x7EF23E46L, (-1L)}, {0x356BF5EEL, 0x4C9CA319L, 0x7EF23E46L, (-1L)}, {0x356BF5EEL, 0x4C9CA319L, 0x7EF23E46L, (-1L)}}, {{0x356BF5EEL, 0x4C9CA319L, 0x7EF23E46L, (-1L)}, {0x356BF5EEL, 0x4C9CA319L, 0x7EF23E46L, (-1L)}, {0x356BF5EEL, 0x4C9CA319L, 0x7EF23E46L, (-1L)}, {0x356BF5EEL, 0x4C9CA319L, 0x7EF23E46L, (-1L)}, {0x356BF5EEL, 0x4C9CA319L, 0x7EF23E46L, (-1L)}, {0x356BF5EEL, 0x4C9CA319L, 0x7EF23E46L, (-1L)}, {0x356BF5EEL, 0x4C9CA319L, 0x7EF23E46L, (-1L)}, {0x356BF5EEL, 0x4C9CA319L, 0x7EF23E46L, (-1L)}, {0x356BF5EEL, 0x4C9CA319L, 0x7EF23E46L, (-1L)}}, {{0x356BF5EEL, 0x4C9CA319L, 0x7EF23E46L, (-1L)}, {0x356BF5EEL, 0x4C9CA319L, 0x7EF23E46L, (-1L)}, {0x356BF5EEL, 0x4C9CA319L, 0x7EF23E46L, (-1L)}, {0x356BF5EEL, 0x4C9CA319L, 0x7EF23E46L, (-1L)}, {0x356BF5EEL, 0x4C9CA319L, 0x7EF23E46L, (-1L)}, {0x356BF5EEL, 0x4C9CA319L, 0x7EF23E46L, (-1L)}, {0x356BF5EEL, 0x4C9CA319L, 0x7EF23E46L, (-1L)}, {0x356BF5EEL, 0x4C9CA319L, 0x7EF23E46L, (-1L)}, {0x356BF5EEL, 0x4C9CA319L, 0x7EF23E46L, (-1L)}}, {{0x356BF5EEL, 0x4C9CA319L, 0x7EF23E46L, (-1L)}, {0x356BF5EEL, 0x4C9CA319L, 0x7EF23E46L, (-1L)}, {0x356BF5EEL, 0x4C9CA319L, 0x7EF23E46L, (-1L)}, {0x356BF5EEL, 0x4C9CA319L, 0x7EF23E46L, (-1L)}, {0x356BF5EEL, 0x4C9CA319L, 0x7EF23E46L, (-1L)}, {0x356BF5EEL, 0x4C9CA319L, 0x7EF23E46L, (-1L)}, {0x356BF5EEL, 0x4C9CA319L, 0x7EF23E46L, (-1L)}, {0x356BF5EEL, 0x4C9CA319L, 0x7EF23E46L, (-1L)}, {0x356BF5EEL, 0x4C9CA319L, 0x7EF23E46L, (-1L)}}};
  int i, j, k;
  l_3[hook(6, 3)][hook(5, 7)][hook(4, 2)] ^= l_2;
  return p_5->g_4;
}

kernel void entry(global ulong* result, global volatile unsigned int* g_atomic_input, global volatile unsigned int* g_special_values, global int* sequence_input) {
  int;
  struct S1 c_6;
  struct S1* p_5 = &c_6;
  struct S1 c_7 = {
      18446744073709551615UL, sequence_input[hook(3, get_global_id(0))], sequence_input[hook(3, get_global_id(1))], sequence_input[hook(3, get_global_id(2))], sequence_input[hook(3, get_local_id(0))], sequence_input[hook(3, get_local_id(1))], sequence_input[hook(3, get_local_id(2))], sequence_input[hook(3, get_group_id(0))], sequence_input[hook(3, get_group_id(1))], sequence_input[hook(3, get_group_id(2))],
  };
  c_6 = c_7;
  barrier(0x01 | 0x02);
  func_1(p_5);
  barrier(0x01 | 0x02);
  ulong crc64_context = 0xFFFFFFFFFFFFFFFFUL;
  int print_hash_value = 0;
  transparent_crc_no_string(&crc64_context, p_5->g_4);
  result[hook(0, get_linear_global_id())] = crc64_context ^ 0xFFFFFFFFFFFFFFFFUL;
}