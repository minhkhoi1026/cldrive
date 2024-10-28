//{"result":0,"sequence_input":1}
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
  int g_3;
  volatile ulong g_9;
  uchar g_12;
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

ulong func_1(struct S0* p_16);
ulong func_1(struct S0* p_16) {
  int* l_2 = &p_16->g_3;
  int* l_4 = (void*)0;
  int* l_5 = &p_16->g_3;
  int* l_6 = &p_16->g_3;
  int* l_7 = (void*)0;
  int* l_8[10] = {&p_16->g_3, &p_16->g_3, &p_16->g_3, &p_16->g_3, &p_16->g_3, &p_16->g_3, &p_16->g_3, &p_16->g_3, &p_16->g_3, &p_16->g_3};
  char l_15 = (-7L);
  int i;
  --p_16->g_9;
  p_16->g_12++;
  l_15 ^= (*l_2);
  return (*l_2);
}

kernel void entry(global ulong* result, global int* sequence_input) {
  int;
  struct S0 c_17;
  struct S0* p_16 = &c_17;
  struct S0 c_18 = {
      0x617CA002L, 0xCB143E95AAD8530DL, 0x2EL, sequence_input[hook(1, get_global_id(0))], sequence_input[hook(1, get_global_id(1))], sequence_input[hook(1, get_global_id(2))], sequence_input[hook(1, get_local_id(0))], sequence_input[hook(1, get_local_id(1))], sequence_input[hook(1, get_local_id(2))], sequence_input[hook(1, get_group_id(0))], sequence_input[hook(1, get_group_id(1))], sequence_input[hook(1, get_group_id(2))],
  };
  c_17 = c_18;
  barrier(0x01 | 0x02);
  func_1(p_16);
  barrier(0x01 | 0x02);
  ulong crc64_context = 0xFFFFFFFFFFFFFFFFUL;
  int print_hash_value = 0;
  transparent_crc_no_string(&crc64_context, p_16->g_3);
  transparent_crc_no_string(&crc64_context, p_16->g_9);
  transparent_crc_no_string(&crc64_context, p_16->g_12);
  result[hook(0, get_linear_global_id())] = crc64_context ^ 0xFFFFFFFFFFFFFFFFUL;
}