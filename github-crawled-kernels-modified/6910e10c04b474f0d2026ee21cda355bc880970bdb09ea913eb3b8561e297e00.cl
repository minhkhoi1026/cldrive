//{"l_6":4,"l_6[1]":3,"l_9":5,"p_15->g_14":8,"p_15->g_14[4]":7,"p_15->g_14[4][2]":6,"p_15->g_3":2,"result":0,"sequence_input":1}
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

struct S6 {
  int g_3[6];
  int* g_14[7][3][10];
  int** volatile g_13;
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

ulong func_1(struct S6* p_15);
ulong func_1(struct S6* p_15) {
  int* l_2 = &p_15->g_3[hook(2, 4)];
  int* l_4 = &p_15->g_3[hook(2, 4)];
  int* l_5 = &p_15->g_3[hook(2, 2)];
  int l_6[4][3] = {{0x3061ECE3L, 0x3061ECE3L, 0x3061ECE3L}, {0x3061ECE3L, 0x3061ECE3L, 0x3061ECE3L}, {0x3061ECE3L, 0x3061ECE3L, 0x3061ECE3L}, {0x3061ECE3L, 0x3061ECE3L, 0x3061ECE3L}};
  int* l_7 = &p_15->g_3[hook(2, 4)];
  int* l_8 = &l_6[hook(4, 1)][hook(3, 1)];
  int* l_9[3];
  unsigned int l_10 = 4294967295UL;
  int i, j;
  for (i = 0; i < 3; i++)
    l_9[hook(5, i)] = &p_15->g_3[hook(2, 4)];
  l_10--;
  (*p_15->g_13) = &l_6[hook(4, 1)][hook(3, 2)];
  return p_15->g_3[hook(2, 4)];
}

kernel void entry(global ulong* result, global int* sequence_input) {
  int i, j, k;
  struct S6 c_16;
  struct S6* p_15 = &c_16;
  struct S6 c_17 = {
      {0x047C4D14L, 0x047C4D14L, 0x047C4D14L, 0x047C4D14L, 0x047C4D14L, 0x047C4D14L}, {{{(void*)0, (void*)0, (void*)0, &p_15->g_3[hook(2, 1)], &p_15->g_3[hook(2, 4)], &p_15->g_3[hook(2, 4)], &p_15->g_3[hook(2, 4)], &p_15->g_3[hook(2, 2)], &p_15->g_3[hook(2, 4)], &p_15->g_3[hook(2, 4)]}, {(void*)0, (void*)0, (void*)0, &p_15->g_3[hook(2, 1)], &p_15->g_3[hook(2, 4)], &p_15->g_3[hook(2, 4)], &p_15->g_3[hook(2, 4)], &p_15->g_3[hook(2, 2)], &p_15->g_3[hook(2, 4)], &p_15->g_3[hook(2, 4)]}, {(void*)0, (void*)0, (void*)0, &p_15->g_3[hook(2, 1)], &p_15->g_3[hook(2, 4)], &p_15->g_3[hook(2, 4)], &p_15->g_3[hook(2, 4)], &p_15->g_3[hook(2, 2)], &p_15->g_3[hook(2, 4)], &p_15->g_3[hook(2, 4)]}}, {{(void*)0, (void*)0, (void*)0, &p_15->g_3[hook(2, 1)], &p_15->g_3[hook(2, 4)], &p_15->g_3[hook(2, 4)], &p_15->g_3[hook(2, 4)], &p_15->g_3[hook(2, 2)], &p_15->g_3[hook(2, 4)], &p_15->g_3[hook(2, 4)]}, {(void*)0, (void*)0, (void*)0, &p_15->g_3[hook(2, 1)], &p_15->g_3[hook(2, 4)], &p_15->g_3[hook(2, 4)], &p_15->g_3[hook(2, 4)], &p_15->g_3[hook(2, 2)], &p_15->g_3[hook(2, 4)], &p_15->g_3[hook(2, 4)]}, {(void*)0, (void*)0, (void*)0, &p_15->g_3[hook(2, 1)], &p_15->g_3[hook(2, 4)], &p_15->g_3[hook(2, 4)], &p_15->g_3[hook(2, 4)], &p_15->g_3[hook(2, 2)], &p_15->g_3[hook(2, 4)], &p_15->g_3[hook(2, 4)]}}, {{(void*)0, (void*)0, (void*)0, &p_15->g_3[hook(2, 1)], &p_15->g_3[hook(2, 4)], &p_15->g_3[hook(2, 4)], &p_15->g_3[hook(2, 4)], &p_15->g_3[hook(2, 2)], &p_15->g_3[hook(2, 4)], &p_15->g_3[hook(2, 4)]}, {(void*)0, (void*)0, (void*)0, &p_15->g_3[hook(2, 1)], &p_15->g_3[hook(2, 4)], &p_15->g_3[hook(2, 4)], &p_15->g_3[hook(2, 4)], &p_15->g_3[hook(2, 2)], &p_15->g_3[hook(2, 4)], &p_15->g_3[hook(2, 4)]}, {(void*)0, (void*)0, (void*)0, &p_15->g_3[hook(2, 1)], &p_15->g_3[hook(2, 4)], &p_15->g_3[hook(2, 4)], &p_15->g_3[hook(2, 4)], &p_15->g_3[hook(2, 2)], &p_15->g_3[hook(2, 4)], &p_15->g_3[hook(2, 4)]}}, {{(void*)0, (void*)0, (void*)0, &p_15->g_3[hook(2, 1)], &p_15->g_3[hook(2, 4)], &p_15->g_3[hook(2, 4)], &p_15->g_3[hook(2, 4)], &p_15->g_3[hook(2, 2)], &p_15->g_3[hook(2, 4)], &p_15->g_3[hook(2, 4)]}, {(void*)0, (void*)0, (void*)0, &p_15->g_3[hook(2, 1)], &p_15->g_3[hook(2, 4)], &p_15->g_3[hook(2, 4)], &p_15->g_3[hook(2, 4)], &p_15->g_3[hook(2, 2)], &p_15->g_3[hook(2, 4)], &p_15->g_3[hook(2, 4)]}, {(void*)0, (void*)0, (void*)0, &p_15->g_3[hook(2, 1)], &p_15->g_3[hook(2, 4)], &p_15->g_3[hook(2, 4)], &p_15->g_3[hook(2, 4)], &p_15->g_3[hook(2, 2)], &p_15->g_3[hook(2, 4)], &p_15->g_3[hook(2, 4)]}}, {{(void*)0, (void*)0, (void*)0, &p_15->g_3[hook(2, 1)], &p_15->g_3[hook(2, 4)], &p_15->g_3[hook(2, 4)], &p_15->g_3[hook(2, 4)], &p_15->g_3[hook(2, 2)], &p_15->g_3[hook(2, 4)], &p_15->g_3[hook(2, 4)]}, {(void*)0, (void*)0, (void*)0, &p_15->g_3[hook(2, 1)], &p_15->g_3[hook(2, 4)], &p_15->g_3[hook(2, 4)], &p_15->g_3[hook(2, 4)], &p_15->g_3[hook(2, 2)], &p_15->g_3[hook(2, 4)], &p_15->g_3[hook(2, 4)]}, {(void*)0, (void*)0, (void*)0, &p_15->g_3[hook(2, 1)], &p_15->g_3[hook(2, 4)], &p_15->g_3[hook(2, 4)], &p_15->g_3[hook(2, 4)], &p_15->g_3[hook(2, 2)], &p_15->g_3[hook(2, 4)], &p_15->g_3[hook(2, 4)]}}, {{(void*)0, (void*)0, (void*)0, &p_15->g_3[hook(2, 1)], &p_15->g_3[hook(2, 4)], &p_15->g_3[hook(2, 4)], &p_15->g_3[hook(2, 4)], &p_15->g_3[hook(2, 2)], &p_15->g_3[hook(2, 4)], &p_15->g_3[hook(2, 4)]}, {(void*)0, (void*)0, (void*)0, &p_15->g_3[hook(2, 1)], &p_15->g_3[hook(2, 4)], &p_15->g_3[hook(2, 4)], &p_15->g_3[hook(2, 4)], &p_15->g_3[hook(2, 2)], &p_15->g_3[hook(2, 4)], &p_15->g_3[hook(2, 4)]}, {(void*)0, (void*)0, (void*)0, &p_15->g_3[hook(2, 1)], &p_15->g_3[hook(2, 4)], &p_15->g_3[hook(2, 4)], &p_15->g_3[hook(2, 4)], &p_15->g_3[hook(2, 2)], &p_15->g_3[hook(2, 4)], &p_15->g_3[hook(2, 4)]}}, {{(void*)0, (void*)0, (void*)0, &p_15->g_3[hook(2, 1)], &p_15->g_3[hook(2, 4)], &p_15->g_3[hook(2, 4)], &p_15->g_3[hook(2, 4)], &p_15->g_3[hook(2, 2)], &p_15->g_3[hook(2, 4)], &p_15->g_3[hook(2, 4)]}, {(void*)0, (void*)0, (void*)0, &p_15->g_3[hook(2, 1)], &p_15->g_3[hook(2, 4)], &p_15->g_3[hook(2, 4)], &p_15->g_3[hook(2, 4)], &p_15->g_3[hook(2, 2)], &p_15->g_3[hook(2, 4)], &p_15->g_3[hook(2, 4)]}, {(void*)0, (void*)0, (void*)0, &p_15->g_3[hook(2, 1)], &p_15->g_3[hook(2, 4)], &p_15->g_3[hook(2, 4)], &p_15->g_3[hook(2, 4)], &p_15->g_3[hook(2, 2)], &p_15->g_3[hook(2, 4)], &p_15->g_3[hook(2, 4)]}}}, &p_15->g_14[hook(8, 4)][hook(7, 2)][hook(6, 7)], sequence_input[hook(1, get_global_id(0))], sequence_input[hook(1, get_global_id(1))], sequence_input[hook(1, get_global_id(2))], sequence_input[hook(1, get_local_id(0))], sequence_input[hook(1, get_local_id(1))], sequence_input[hook(1, get_local_id(2))], sequence_input[hook(1, get_group_id(0))], sequence_input[hook(1, get_group_id(1))], sequence_input[hook(1, get_group_id(2))],
  };
  c_16 = c_17;
  barrier(0x01 | 0x02);
  func_1(p_15);
  barrier(0x01 | 0x02);
  ulong crc64_context = 0xFFFFFFFFFFFFFFFFUL;
  int print_hash_value = 0;
  for (i = 0; i < 6; i++) {
    transparent_crc_no_string(&crc64_context, p_15->g_3[hook(2, i)]);
  }
  result[hook(0, get_linear_global_id())] = crc64_context ^ 0xFFFFFFFFFFFFFFFFUL;
}