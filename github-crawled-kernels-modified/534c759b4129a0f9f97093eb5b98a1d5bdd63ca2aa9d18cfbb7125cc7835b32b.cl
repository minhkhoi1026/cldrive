//{"l_2":2,"p_6->g_4":4,"p_6->g_4[9]":3,"p_6->g_5":7,"p_6->g_5[4]":6,"p_6->g_5[4][1]":5,"p_6->g_5[i]":9,"p_6->g_5[i][j]":8,"result":0,"sequence_input":1}
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
  volatile int g_5[8][8][4];
  volatile int* g_4[10][2];
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

long func_1(struct S0* p_6);
long func_1(struct S0* p_6) {
  int* l_3 = (void*)0;
  int** l_2[3];
  int i;
  for (i = 0; i < 3; i++)
    l_2[hook(2, i)] = &l_3;
  p_6->g_4[hook(4, 9)][hook(3, 1)] = (void*)0;
  return p_6->g_5[hook(7, 4)][hook(6, 1)][hook(5, 2)];
}

kernel void entry(global ulong* result, global int* sequence_input) {
  int i, j, k;
  struct S0 c_7;
  struct S0* p_6 = &c_7;
  struct S0 c_8 = {
      {{{0x63A88E00L, 0x63A88E00L, 0L, 0L}, {0x63A88E00L, 0x63A88E00L, 0L, 0L}, {0x63A88E00L, 0x63A88E00L, 0L, 0L}, {0x63A88E00L, 0x63A88E00L, 0L, 0L}, {0x63A88E00L, 0x63A88E00L, 0L, 0L}, {0x63A88E00L, 0x63A88E00L, 0L, 0L}, {0x63A88E00L, 0x63A88E00L, 0L, 0L}, {0x63A88E00L, 0x63A88E00L, 0L, 0L}}, {{0x63A88E00L, 0x63A88E00L, 0L, 0L}, {0x63A88E00L, 0x63A88E00L, 0L, 0L}, {0x63A88E00L, 0x63A88E00L, 0L, 0L}, {0x63A88E00L, 0x63A88E00L, 0L, 0L}, {0x63A88E00L, 0x63A88E00L, 0L, 0L}, {0x63A88E00L, 0x63A88E00L, 0L, 0L}, {0x63A88E00L, 0x63A88E00L, 0L, 0L}, {0x63A88E00L, 0x63A88E00L, 0L, 0L}}, {{0x63A88E00L, 0x63A88E00L, 0L, 0L}, {0x63A88E00L, 0x63A88E00L, 0L, 0L}, {0x63A88E00L, 0x63A88E00L, 0L, 0L}, {0x63A88E00L, 0x63A88E00L, 0L, 0L}, {0x63A88E00L, 0x63A88E00L, 0L, 0L}, {0x63A88E00L, 0x63A88E00L, 0L, 0L}, {0x63A88E00L, 0x63A88E00L, 0L, 0L}, {0x63A88E00L, 0x63A88E00L, 0L, 0L}}, {{0x63A88E00L, 0x63A88E00L, 0L, 0L}, {0x63A88E00L, 0x63A88E00L, 0L, 0L}, {0x63A88E00L, 0x63A88E00L, 0L, 0L}, {0x63A88E00L, 0x63A88E00L, 0L, 0L}, {0x63A88E00L, 0x63A88E00L, 0L, 0L}, {0x63A88E00L, 0x63A88E00L, 0L, 0L}, {0x63A88E00L, 0x63A88E00L, 0L, 0L}, {0x63A88E00L, 0x63A88E00L, 0L, 0L}}, {{0x63A88E00L, 0x63A88E00L, 0L, 0L}, {0x63A88E00L, 0x63A88E00L, 0L, 0L}, {0x63A88E00L, 0x63A88E00L, 0L, 0L}, {0x63A88E00L, 0x63A88E00L, 0L, 0L}, {0x63A88E00L, 0x63A88E00L, 0L, 0L}, {0x63A88E00L, 0x63A88E00L, 0L, 0L}, {0x63A88E00L, 0x63A88E00L, 0L, 0L}, {0x63A88E00L, 0x63A88E00L, 0L, 0L}}, {{0x63A88E00L, 0x63A88E00L, 0L, 0L}, {0x63A88E00L, 0x63A88E00L, 0L, 0L}, {0x63A88E00L, 0x63A88E00L, 0L, 0L}, {0x63A88E00L, 0x63A88E00L, 0L, 0L}, {0x63A88E00L, 0x63A88E00L, 0L, 0L}, {0x63A88E00L, 0x63A88E00L, 0L, 0L}, {0x63A88E00L, 0x63A88E00L, 0L, 0L}, {0x63A88E00L, 0x63A88E00L, 0L, 0L}}, {{0x63A88E00L, 0x63A88E00L, 0L, 0L}, {0x63A88E00L, 0x63A88E00L, 0L, 0L}, {0x63A88E00L, 0x63A88E00L, 0L, 0L}, {0x63A88E00L, 0x63A88E00L, 0L, 0L}, {0x63A88E00L, 0x63A88E00L, 0L, 0L}, {0x63A88E00L, 0x63A88E00L, 0L, 0L}, {0x63A88E00L, 0x63A88E00L, 0L, 0L}, {0x63A88E00L, 0x63A88E00L, 0L, 0L}}, {{0x63A88E00L, 0x63A88E00L, 0L, 0L}, {0x63A88E00L, 0x63A88E00L, 0L, 0L}, {0x63A88E00L, 0x63A88E00L, 0L, 0L}, {0x63A88E00L, 0x63A88E00L, 0L, 0L}, {0x63A88E00L, 0x63A88E00L, 0L, 0L}, {0x63A88E00L, 0x63A88E00L, 0L, 0L}, {0x63A88E00L, 0x63A88E00L, 0L, 0L}, {0x63A88E00L, 0x63A88E00L, 0L, 0L}}}, {{&p_6->g_5[hook(7, 4)][hook(6, 1)][hook(5, 2)], &p_6->g_5[hook(7, 4)][hook(6, 1)][hook(5, 2)]}, {&p_6->g_5[hook(7, 4)][hook(6, 1)][hook(5, 2)], &p_6->g_5[hook(7, 4)][hook(6, 1)][hook(5, 2)]}, {&p_6->g_5[hook(7, 4)][hook(6, 1)][hook(5, 2)], &p_6->g_5[hook(7, 4)][hook(6, 1)][hook(5, 2)]}, {&p_6->g_5[hook(7, 4)][hook(6, 1)][hook(5, 2)], &p_6->g_5[hook(7, 4)][hook(6, 1)][hook(5, 2)]}, {&p_6->g_5[hook(7, 4)][hook(6, 1)][hook(5, 2)], &p_6->g_5[hook(7, 4)][hook(6, 1)][hook(5, 2)]}, {&p_6->g_5[hook(7, 4)][hook(6, 1)][hook(5, 2)], &p_6->g_5[hook(7, 4)][hook(6, 1)][hook(5, 2)]}, {&p_6->g_5[hook(7, 4)][hook(6, 1)][hook(5, 2)], &p_6->g_5[hook(7, 4)][hook(6, 1)][hook(5, 2)]}, {&p_6->g_5[hook(7, 4)][hook(6, 1)][hook(5, 2)], &p_6->g_5[hook(7, 4)][hook(6, 1)][hook(5, 2)]}, {&p_6->g_5[hook(7, 4)][hook(6, 1)][hook(5, 2)], &p_6->g_5[hook(7, 4)][hook(6, 1)][hook(5, 2)]}, {&p_6->g_5[hook(7, 4)][hook(6, 1)][hook(5, 2)], &p_6->g_5[hook(7, 4)][hook(6, 1)][hook(5, 2)]}}, sequence_input[hook(1, get_global_id(0))], sequence_input[hook(1, get_global_id(1))], sequence_input[hook(1, get_global_id(2))], sequence_input[hook(1, get_local_id(0))], sequence_input[hook(1, get_local_id(1))], sequence_input[hook(1, get_local_id(2))], sequence_input[hook(1, get_group_id(0))], sequence_input[hook(1, get_group_id(1))], sequence_input[hook(1, get_group_id(2))],
  };
  c_7 = c_8;
  barrier(0x01 | 0x02);
  func_1(p_6);
  barrier(0x01 | 0x02);
  ulong crc64_context = 0xFFFFFFFFFFFFFFFFUL;
  int print_hash_value = 0;
  for (i = 0; i < 8; i++) {
    for (j = 0; j < 8; j++) {
      for (k = 0; k < 4; k++) {
        transparent_crc_no_string(&crc64_context, p_6->g_5[hook(7, i)][hook(9, j)][hook(8, k)]);
      }
    }
  }
  result[hook(0, get_linear_global_id())] = crc64_context ^ 0xFFFFFFFFFFFFFFFFUL;
}