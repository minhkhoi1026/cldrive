//{"g_atomic_input":1,"g_special_values":2,"p_8->g_3":6,"p_8->g_3[0]":5,"p_8->g_3[0][0]":4,"p_8->g_3[i]":8,"p_8->g_3[i][j]":7,"result":0,"sequence_input":3}
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
  int g_3[1][4][10];
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

unsigned int func_1(struct S1* p_8);
unsigned int func_1(struct S1* p_8) {
  int* l_2 = &p_8->g_3[hook(6, 0)][hook(5, 0)][hook(4, 6)];
  int* l_4[6][9] = {{&p_8->g_3[hook(6, 0)][hook(5, 0)][hook(4, 6)], &p_8->g_3[hook(6, 0)][hook(5, 0)][hook(4, 6)], &p_8->g_3[hook(6, 0)][hook(5, 0)][hook(4, 6)], &p_8->g_3[hook(6, 0)][hook(5, 0)][hook(4, 6)], &p_8->g_3[hook(6, 0)][hook(5, 0)][hook(4, 6)], &p_8->g_3[hook(6, 0)][hook(5, 0)][hook(4, 6)], &p_8->g_3[hook(6, 0)][hook(5, 0)][hook(4, 6)], &p_8->g_3[hook(6, 0)][hook(5, 0)][hook(4, 6)], &p_8->g_3[hook(6, 0)][hook(5, 0)][hook(4, 6)]}, {&p_8->g_3[hook(6, 0)][hook(5, 0)][hook(4, 6)], &p_8->g_3[hook(6, 0)][hook(5, 0)][hook(4, 6)], &p_8->g_3[hook(6, 0)][hook(5, 0)][hook(4, 6)], &p_8->g_3[hook(6, 0)][hook(5, 0)][hook(4, 6)], &p_8->g_3[hook(6, 0)][hook(5, 0)][hook(4, 6)], &p_8->g_3[hook(6, 0)][hook(5, 0)][hook(4, 6)], &p_8->g_3[hook(6, 0)][hook(5, 0)][hook(4, 6)], &p_8->g_3[hook(6, 0)][hook(5, 0)][hook(4, 6)], &p_8->g_3[hook(6, 0)][hook(5, 0)][hook(4, 6)]}, {&p_8->g_3[hook(6, 0)][hook(5, 0)][hook(4, 6)], &p_8->g_3[hook(6, 0)][hook(5, 0)][hook(4, 6)], &p_8->g_3[hook(6, 0)][hook(5, 0)][hook(4, 6)], &p_8->g_3[hook(6, 0)][hook(5, 0)][hook(4, 6)], &p_8->g_3[hook(6, 0)][hook(5, 0)][hook(4, 6)], &p_8->g_3[hook(6, 0)][hook(5, 0)][hook(4, 6)], &p_8->g_3[hook(6, 0)][hook(5, 0)][hook(4, 6)], &p_8->g_3[hook(6, 0)][hook(5, 0)][hook(4, 6)], &p_8->g_3[hook(6, 0)][hook(5, 0)][hook(4, 6)]}, {&p_8->g_3[hook(6, 0)][hook(5, 0)][hook(4, 6)], &p_8->g_3[hook(6, 0)][hook(5, 0)][hook(4, 6)], &p_8->g_3[hook(6, 0)][hook(5, 0)][hook(4, 6)], &p_8->g_3[hook(6, 0)][hook(5, 0)][hook(4, 6)], &p_8->g_3[hook(6, 0)][hook(5, 0)][hook(4, 6)], &p_8->g_3[hook(6, 0)][hook(5, 0)][hook(4, 6)], &p_8->g_3[hook(6, 0)][hook(5, 0)][hook(4, 6)], &p_8->g_3[hook(6, 0)][hook(5, 0)][hook(4, 6)], &p_8->g_3[hook(6, 0)][hook(5, 0)][hook(4, 6)]}, {&p_8->g_3[hook(6, 0)][hook(5, 0)][hook(4, 6)], &p_8->g_3[hook(6, 0)][hook(5, 0)][hook(4, 6)], &p_8->g_3[hook(6, 0)][hook(5, 0)][hook(4, 6)], &p_8->g_3[hook(6, 0)][hook(5, 0)][hook(4, 6)], &p_8->g_3[hook(6, 0)][hook(5, 0)][hook(4, 6)], &p_8->g_3[hook(6, 0)][hook(5, 0)][hook(4, 6)], &p_8->g_3[hook(6, 0)][hook(5, 0)][hook(4, 6)], &p_8->g_3[hook(6, 0)][hook(5, 0)][hook(4, 6)], &p_8->g_3[hook(6, 0)][hook(5, 0)][hook(4, 6)]}, {&p_8->g_3[hook(6, 0)][hook(5, 0)][hook(4, 6)], &p_8->g_3[hook(6, 0)][hook(5, 0)][hook(4, 6)], &p_8->g_3[hook(6, 0)][hook(5, 0)][hook(4, 6)], &p_8->g_3[hook(6, 0)][hook(5, 0)][hook(4, 6)], &p_8->g_3[hook(6, 0)][hook(5, 0)][hook(4, 6)], &p_8->g_3[hook(6, 0)][hook(5, 0)][hook(4, 6)], &p_8->g_3[hook(6, 0)][hook(5, 0)][hook(4, 6)], &p_8->g_3[hook(6, 0)][hook(5, 0)][hook(4, 6)], &p_8->g_3[hook(6, 0)][hook(5, 0)][hook(4, 6)]}};
  ulong l_5 = 0xBB35B68906353005L;
  int i, j;
  l_5--;
  return p_8->g_3[hook(6, 0)][hook(5, 0)][hook(4, 6)];
}

kernel void entry(global ulong* result, global volatile unsigned int* g_atomic_input, global volatile unsigned int* g_special_values, global int* sequence_input) {
  int i, j, k;
  struct S1 c_9;
  struct S1* p_8 = &c_9;
  struct S1 c_10 = {
      {{{1L, 1L, 0x1C96C797L, (-1L), 3L, (-1L), 0x1C96C797L, 1L, 1L, 0x1C96C797L}, {1L, 1L, 0x1C96C797L, (-1L), 3L, (-1L), 0x1C96C797L, 1L, 1L, 0x1C96C797L}, {1L, 1L, 0x1C96C797L, (-1L), 3L, (-1L), 0x1C96C797L, 1L, 1L, 0x1C96C797L}, {1L, 1L, 0x1C96C797L, (-1L), 3L, (-1L), 0x1C96C797L, 1L, 1L, 0x1C96C797L}}}, sequence_input[hook(3, get_global_id(0))], sequence_input[hook(3, get_global_id(1))], sequence_input[hook(3, get_global_id(2))], sequence_input[hook(3, get_local_id(0))], sequence_input[hook(3, get_local_id(1))], sequence_input[hook(3, get_local_id(2))], sequence_input[hook(3, get_group_id(0))], sequence_input[hook(3, get_group_id(1))], sequence_input[hook(3, get_group_id(2))],
  };
  c_9 = c_10;
  barrier(0x01 | 0x02);
  func_1(p_8);
  barrier(0x01 | 0x02);
  ulong crc64_context = 0xFFFFFFFFFFFFFFFFUL;
  int print_hash_value = 0;
  for (i = 0; i < 1; i++) {
    for (j = 0; j < 4; j++) {
      for (k = 0; k < 10; k++) {
        transparent_crc_no_string(&crc64_context, p_8->g_3[hook(6, i)][hook(8, j)][hook(7, k)]);
      }
    }
  }
  result[hook(0, get_linear_global_id())] = crc64_context ^ 0xFFFFFFFFFFFFFFFFUL;
}