//{"g_atomic_input":1,"g_special_values":2,"l_2":4,"result":0,"sequence_input":3}
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

union U1 {
  long f0;
  char f1;
};

struct S2 {
  union U1 g_3;
  int g_6;
  volatile unsigned int g_7;
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

int func_1(struct S2* p_11);
int func_1(struct S2* p_11) {
  union U1* l_2[8] = {&p_11->g_3, &p_11->g_3, &p_11->g_3, &p_11->g_3, &p_11->g_3, &p_11->g_3, &p_11->g_3, &p_11->g_3};
  union U1** l_4 = &l_2[hook(4, 6)];
  int* l_5[7][7][5] = {{{&p_11->g_6, (void*)0, &p_11->g_6, &p_11->g_6, &p_11->g_6}, {&p_11->g_6, (void*)0, &p_11->g_6, &p_11->g_6, &p_11->g_6}, {&p_11->g_6, (void*)0, &p_11->g_6, &p_11->g_6, &p_11->g_6}, {&p_11->g_6, (void*)0, &p_11->g_6, &p_11->g_6, &p_11->g_6}, {&p_11->g_6, (void*)0, &p_11->g_6, &p_11->g_6, &p_11->g_6}, {&p_11->g_6, (void*)0, &p_11->g_6, &p_11->g_6, &p_11->g_6}, {&p_11->g_6, (void*)0, &p_11->g_6, &p_11->g_6, &p_11->g_6}}, {{&p_11->g_6, (void*)0, &p_11->g_6, &p_11->g_6, &p_11->g_6}, {&p_11->g_6, (void*)0, &p_11->g_6, &p_11->g_6, &p_11->g_6}, {&p_11->g_6, (void*)0, &p_11->g_6, &p_11->g_6, &p_11->g_6}, {&p_11->g_6, (void*)0, &p_11->g_6, &p_11->g_6, &p_11->g_6}, {&p_11->g_6, (void*)0, &p_11->g_6, &p_11->g_6, &p_11->g_6}, {&p_11->g_6, (void*)0, &p_11->g_6, &p_11->g_6, &p_11->g_6}, {&p_11->g_6, (void*)0, &p_11->g_6, &p_11->g_6, &p_11->g_6}}, {{&p_11->g_6, (void*)0, &p_11->g_6, &p_11->g_6, &p_11->g_6}, {&p_11->g_6, (void*)0, &p_11->g_6, &p_11->g_6, &p_11->g_6}, {&p_11->g_6, (void*)0, &p_11->g_6, &p_11->g_6, &p_11->g_6}, {&p_11->g_6, (void*)0, &p_11->g_6, &p_11->g_6, &p_11->g_6}, {&p_11->g_6, (void*)0, &p_11->g_6, &p_11->g_6, &p_11->g_6}, {&p_11->g_6, (void*)0, &p_11->g_6, &p_11->g_6, &p_11->g_6}, {&p_11->g_6, (void*)0, &p_11->g_6, &p_11->g_6, &p_11->g_6}}, {{&p_11->g_6, (void*)0, &p_11->g_6, &p_11->g_6, &p_11->g_6}, {&p_11->g_6, (void*)0, &p_11->g_6, &p_11->g_6, &p_11->g_6}, {&p_11->g_6, (void*)0, &p_11->g_6, &p_11->g_6, &p_11->g_6}, {&p_11->g_6, (void*)0, &p_11->g_6, &p_11->g_6, &p_11->g_6}, {&p_11->g_6, (void*)0, &p_11->g_6, &p_11->g_6, &p_11->g_6}, {&p_11->g_6, (void*)0, &p_11->g_6, &p_11->g_6, &p_11->g_6}, {&p_11->g_6, (void*)0, &p_11->g_6, &p_11->g_6, &p_11->g_6}}, {{&p_11->g_6, (void*)0, &p_11->g_6, &p_11->g_6, &p_11->g_6}, {&p_11->g_6, (void*)0, &p_11->g_6, &p_11->g_6, &p_11->g_6}, {&p_11->g_6, (void*)0, &p_11->g_6, &p_11->g_6, &p_11->g_6}, {&p_11->g_6, (void*)0, &p_11->g_6, &p_11->g_6, &p_11->g_6}, {&p_11->g_6, (void*)0, &p_11->g_6, &p_11->g_6, &p_11->g_6}, {&p_11->g_6, (void*)0, &p_11->g_6, &p_11->g_6, &p_11->g_6}, {&p_11->g_6, (void*)0, &p_11->g_6, &p_11->g_6, &p_11->g_6}}, {{&p_11->g_6, (void*)0, &p_11->g_6, &p_11->g_6, &p_11->g_6}, {&p_11->g_6, (void*)0, &p_11->g_6, &p_11->g_6, &p_11->g_6}, {&p_11->g_6, (void*)0, &p_11->g_6, &p_11->g_6, &p_11->g_6}, {&p_11->g_6, (void*)0, &p_11->g_6, &p_11->g_6, &p_11->g_6}, {&p_11->g_6, (void*)0, &p_11->g_6, &p_11->g_6, &p_11->g_6}, {&p_11->g_6, (void*)0, &p_11->g_6, &p_11->g_6, &p_11->g_6}, {&p_11->g_6, (void*)0, &p_11->g_6, &p_11->g_6, &p_11->g_6}}, {{&p_11->g_6, (void*)0, &p_11->g_6, &p_11->g_6, &p_11->g_6}, {&p_11->g_6, (void*)0, &p_11->g_6, &p_11->g_6, &p_11->g_6}, {&p_11->g_6, (void*)0, &p_11->g_6, &p_11->g_6, &p_11->g_6}, {&p_11->g_6, (void*)0, &p_11->g_6, &p_11->g_6, &p_11->g_6}, {&p_11->g_6, (void*)0, &p_11->g_6, &p_11->g_6, &p_11->g_6}, {&p_11->g_6, (void*)0, &p_11->g_6, &p_11->g_6, &p_11->g_6}, {&p_11->g_6, (void*)0, &p_11->g_6, &p_11->g_6, &p_11->g_6}}};
  ulong l_10 = 18446744073709551611UL;
  int i, j, k;
  (*l_4) = l_2[hook(4, 7)];
  p_11->g_7++;
  l_10 = (p_11->g_6 <= 0L);
  return p_11->g_3.f0;
}

kernel void entry(global ulong* result, global volatile unsigned int* g_atomic_input, global volatile unsigned int* g_special_values, global int* sequence_input) {
  int;
  struct S2 c_12;
  struct S2* p_11 = &c_12;
  struct S2 c_13 = {
      {0x37161AB6EC79CF18L}, 8L, 0xE35D5D90L, sequence_input[hook(3, get_global_id(0))], sequence_input[hook(3, get_global_id(1))], sequence_input[hook(3, get_global_id(2))], sequence_input[hook(3, get_local_id(0))], sequence_input[hook(3, get_local_id(1))], sequence_input[hook(3, get_local_id(2))], sequence_input[hook(3, get_group_id(0))], sequence_input[hook(3, get_group_id(1))], sequence_input[hook(3, get_group_id(2))],
  };
  c_12 = c_13;
  barrier(0x01 | 0x02);
  func_1(p_11);
  barrier(0x01 | 0x02);
  ulong crc64_context = 0xFFFFFFFFFFFFFFFFUL;
  int print_hash_value = 0;
  transparent_crc_no_string(&crc64_context, p_11->g_3.f0);
  transparent_crc_no_string(&crc64_context, p_11->g_6);
  transparent_crc_no_string(&crc64_context, p_11->g_7);
  result[hook(0, get_linear_global_id())] = crc64_context ^ 0xFFFFFFFFFFFFFFFFUL;
}