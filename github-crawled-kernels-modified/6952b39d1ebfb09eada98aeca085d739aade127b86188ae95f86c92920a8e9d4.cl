//{"l_5":6,"p_19->g_3":3,"p_19->g_3[1]":4,"p_19->g_3[2]":8,"p_19->g_3[3]":2,"p_19->g_3[6]":5,"p_19->g_3[8]":7,"p_19->g_3[i]":9,"result":0,"sequence_input":1}
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

struct S0 {
  int g_3[9][4];
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

unsigned int func_1(struct S0* p_19);
unsigned int func_1(struct S0* p_19) {
  int* l_2 = &p_19->g_3[hook(3, 3)][hook(2, 1)];
  int* l_4 = &p_19->g_3[hook(3, 1)][hook(4, 1)];
  int l_5[3];
  int* l_6 = &p_19->g_3[hook(3, 6)][hook(5, 0)];
  int* l_7 = &p_19->g_3[hook(3, 3)][hook(2, 1)];
  int* l_8 = &l_5[hook(6, 2)];
  int* l_9 = &l_5[hook(6, 0)];
  int* l_10 = &l_5[hook(6, 2)];
  int* l_11 = &p_19->g_3[hook(3, 8)][hook(7, 0)];
  int* l_12 = &l_5[hook(6, 0)];
  int* l_13 = &l_5[hook(6, 2)];
  int* l_14[6][4] = {{&p_19->g_3[hook(3, 2)][hook(8, 3)], &l_5[hook(6, 2)], &l_5[hook(6, 2)], &p_19->g_3[hook(3, 2)][hook(8, 3)]}, {&p_19->g_3[hook(3, 2)][hook(8, 3)], &l_5[hook(6, 2)], &l_5[hook(6, 2)], &p_19->g_3[hook(3, 2)][hook(8, 3)]}, {&p_19->g_3[hook(3, 2)][hook(8, 3)], &l_5[hook(6, 2)], &l_5[hook(6, 2)], &p_19->g_3[hook(3, 2)][hook(8, 3)]}, {&p_19->g_3[hook(3, 2)][hook(8, 3)], &l_5[hook(6, 2)], &l_5[hook(6, 2)], &p_19->g_3[hook(3, 2)][hook(8, 3)]}, {&p_19->g_3[hook(3, 2)][hook(8, 3)], &l_5[hook(6, 2)], &l_5[hook(6, 2)], &p_19->g_3[hook(3, 2)][hook(8, 3)]}, {&p_19->g_3[hook(3, 2)][hook(8, 3)], &l_5[hook(6, 2)], &l_5[hook(6, 2)], &p_19->g_3[hook(3, 2)][hook(8, 3)]}};
  unsigned int l_15 = 7UL;
  int** l_18 = &l_6;
  int i, j;
  for (i = 0; i < 3; i++)
    l_5[hook(6, i)] = 0x3BA20B95L;
  ++l_15;
  (*l_18) = &l_5[hook(6, 2)];
  return (*l_7);
}

kernel void entry(global ulong* result, global int* sequence_input) {
  int i, j;
  struct S0 c_20;
  struct S0* p_19 = &c_20;
  struct S0 c_21 = {
      {{0x7A5C62E0L, 0x7A5C62E0L, 0x3666A756L, 0x398070ADL}, {0x7A5C62E0L, 0x7A5C62E0L, 0x3666A756L, 0x398070ADL}, {0x7A5C62E0L, 0x7A5C62E0L, 0x3666A756L, 0x398070ADL}, {0x7A5C62E0L, 0x7A5C62E0L, 0x3666A756L, 0x398070ADL}, {0x7A5C62E0L, 0x7A5C62E0L, 0x3666A756L, 0x398070ADL}, {0x7A5C62E0L, 0x7A5C62E0L, 0x3666A756L, 0x398070ADL}, {0x7A5C62E0L, 0x7A5C62E0L, 0x3666A756L, 0x398070ADL}, {0x7A5C62E0L, 0x7A5C62E0L, 0x3666A756L, 0x398070ADL}, {0x7A5C62E0L, 0x7A5C62E0L, 0x3666A756L, 0x398070ADL}}, sequence_input[hook(1, get_global_id(0))], sequence_input[hook(1, get_global_id(1))], sequence_input[hook(1, get_global_id(2))], sequence_input[hook(1, get_local_id(0))], sequence_input[hook(1, get_local_id(1))], sequence_input[hook(1, get_local_id(2))], sequence_input[hook(1, get_group_id(0))], sequence_input[hook(1, get_group_id(1))], sequence_input[hook(1, get_group_id(2))],
  };
  c_20 = c_21;
  barrier(0x01 | 0x02);
  func_1(p_19);
  barrier(0x01 | 0x02);
  ulong crc64_context = 0xFFFFFFFFFFFFFFFFUL;
  int print_hash_value = 0;
  for (i = 0; i < 9; i++) {
    for (j = 0; j < 4; j++) {
      transparent_crc_no_string(&crc64_context, p_19->g_3[hook(3, i)][hook(9, j)]);
    }
  }
  result[hook(0, get_linear_global_id())] = crc64_context ^ 0xFFFFFFFFFFFFFFFFUL;
}