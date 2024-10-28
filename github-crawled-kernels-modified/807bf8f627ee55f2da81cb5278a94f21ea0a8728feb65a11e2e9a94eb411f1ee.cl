//{"p_8->g_5":2,"result":0,"sequence_input":1}
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
  int g_3;
  volatile uchar g_5[3];
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

int func_1(struct S1* p_8);
int func_1(struct S1* p_8) {
  int* l_2 = &p_8->g_3;
  int* l_4[5][10][1] = {{{&p_8->g_3}, {&p_8->g_3}, {&p_8->g_3}, {&p_8->g_3}, {&p_8->g_3}, {&p_8->g_3}, {&p_8->g_3}, {&p_8->g_3}, {&p_8->g_3}, {&p_8->g_3}}, {{&p_8->g_3}, {&p_8->g_3}, {&p_8->g_3}, {&p_8->g_3}, {&p_8->g_3}, {&p_8->g_3}, {&p_8->g_3}, {&p_8->g_3}, {&p_8->g_3}, {&p_8->g_3}}, {{&p_8->g_3}, {&p_8->g_3}, {&p_8->g_3}, {&p_8->g_3}, {&p_8->g_3}, {&p_8->g_3}, {&p_8->g_3}, {&p_8->g_3}, {&p_8->g_3}, {&p_8->g_3}}, {{&p_8->g_3}, {&p_8->g_3}, {&p_8->g_3}, {&p_8->g_3}, {&p_8->g_3}, {&p_8->g_3}, {&p_8->g_3}, {&p_8->g_3}, {&p_8->g_3}, {&p_8->g_3}}, {{&p_8->g_3}, {&p_8->g_3}, {&p_8->g_3}, {&p_8->g_3}, {&p_8->g_3}, {&p_8->g_3}, {&p_8->g_3}, {&p_8->g_3}, {&p_8->g_3}, {&p_8->g_3}}};
  int i, j, k;
  --p_8->g_5[hook(2, 1)];
  return p_8->g_5[hook(2, 1)];
}

kernel void entry(global ulong* result, global int* sequence_input) {
  int i;
  struct S1 c_9;
  struct S1* p_8 = &c_9;
  struct S1 c_10 = {
      0L, {255UL, 255UL, 255UL}, sequence_input[hook(1, get_global_id(0))], sequence_input[hook(1, get_global_id(1))], sequence_input[hook(1, get_global_id(2))], sequence_input[hook(1, get_local_id(0))], sequence_input[hook(1, get_local_id(1))], sequence_input[hook(1, get_local_id(2))], sequence_input[hook(1, get_group_id(0))], sequence_input[hook(1, get_group_id(1))], sequence_input[hook(1, get_group_id(2))],
  };
  c_9 = c_10;
  barrier(0x01 | 0x02);
  func_1(p_8);
  barrier(0x01 | 0x02);
  ulong crc64_context = 0xFFFFFFFFFFFFFFFFUL;
  int print_hash_value = 0;
  transparent_crc_no_string(&crc64_context, p_8->g_3);
  for (i = 0; i < 3; i++) {
    transparent_crc_no_string(&crc64_context, p_8->g_5[hook(2, i)]);
  }
  result[hook(0, get_linear_global_id())] = crc64_context ^ 0xFFFFFFFFFFFFFFFFUL;
}