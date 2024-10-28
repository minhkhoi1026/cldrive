//{"l_3":2,"p_9->g_8":4,"p_9->g_8[1]":3,"result":0,"sequence_input":1}
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
  int g_4;
  int** volatile g_5;
  int* g_8[5][7];
  int** volatile g_7;
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

long func_1(struct S1* p_9);
long func_1(struct S1* p_9) {
  int* l_3[9] = {&p_9->g_4, &p_9->g_4, &p_9->g_4, &p_9->g_4, &p_9->g_4, &p_9->g_4, &p_9->g_4, &p_9->g_4, &p_9->g_4};
  int** l_2 = &l_3[hook(2, 4)];
  int** l_6 = (void*)0;
  int i;
  (*p_9->g_7) = ((*l_2) = (void*)0);
  return p_9->g_4;
}

kernel void entry(global ulong* result, global int* sequence_input) {
  int i, j;
  struct S1 c_10;
  struct S1* p_9 = &c_10;
  struct S1 c_11 = {
      0x43BEB716L, (void*)0, {{&p_9->g_4, &p_9->g_4, &p_9->g_4, &p_9->g_4, &p_9->g_4, &p_9->g_4, &p_9->g_4}, {&p_9->g_4, &p_9->g_4, &p_9->g_4, &p_9->g_4, &p_9->g_4, &p_9->g_4, &p_9->g_4}, {&p_9->g_4, &p_9->g_4, &p_9->g_4, &p_9->g_4, &p_9->g_4, &p_9->g_4, &p_9->g_4}, {&p_9->g_4, &p_9->g_4, &p_9->g_4, &p_9->g_4, &p_9->g_4, &p_9->g_4, &p_9->g_4}, {&p_9->g_4, &p_9->g_4, &p_9->g_4, &p_9->g_4, &p_9->g_4, &p_9->g_4, &p_9->g_4}}, &p_9->g_8[hook(4, 1)][hook(3, 1)], sequence_input[hook(1, get_global_id(0))], sequence_input[hook(1, get_global_id(1))], sequence_input[hook(1, get_global_id(2))], sequence_input[hook(1, get_local_id(0))], sequence_input[hook(1, get_local_id(1))], sequence_input[hook(1, get_local_id(2))], sequence_input[hook(1, get_group_id(0))], sequence_input[hook(1, get_group_id(1))], sequence_input[hook(1, get_group_id(2))],
  };
  c_10 = c_11;
  barrier(0x01 | 0x02);
  func_1(p_9);
  barrier(0x01 | 0x02);
  ulong crc64_context = 0xFFFFFFFFFFFFFFFFUL;
  int print_hash_value = 0;
  transparent_crc_no_string(&crc64_context, p_9->g_4);
  result[hook(0, get_linear_global_id())] = crc64_context ^ 0xFFFFFFFFFFFFFFFFUL;
}