//{"g_atomic_input":1,"g_special_values":2,"result":0,"sequence_input":3}
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

unsigned int func_1(struct S1* p_15);
unsigned int func_1(struct S1* p_15) {
  int* l_2 = &p_15->g_3;
  int* l_4 = &p_15->g_3;
  int* l_5 = &p_15->g_3;
  int* l_6 = &p_15->g_3;
  int* l_7 = &p_15->g_3;
  int* l_8 = &p_15->g_3;
  int* l_9 = &p_15->g_3;
  int* l_10 = &p_15->g_3;
  int* l_11[9] = {&p_15->g_3, &p_15->g_3, &p_15->g_3, &p_15->g_3, &p_15->g_3, &p_15->g_3, &p_15->g_3, &p_15->g_3, &p_15->g_3};
  int i;
  p_15->g_12++;
  return p_15->g_12;
}

kernel void entry(global ulong* result, global volatile unsigned int* g_atomic_input, global volatile unsigned int* g_special_values, global int* sequence_input) {
  int;
  struct S1 c_16;
  struct S1* p_15 = &c_16;
  struct S1 c_17 = {
      0x70A290BEL, 8UL, sequence_input[hook(3, get_global_id(0))], sequence_input[hook(3, get_global_id(1))], sequence_input[hook(3, get_global_id(2))], sequence_input[hook(3, get_local_id(0))], sequence_input[hook(3, get_local_id(1))], sequence_input[hook(3, get_local_id(2))], sequence_input[hook(3, get_group_id(0))], sequence_input[hook(3, get_group_id(1))], sequence_input[hook(3, get_group_id(2))],
  };
  c_16 = c_17;
  barrier(0x01 | 0x02);
  func_1(p_15);
  barrier(0x01 | 0x02);
  ulong crc64_context = 0xFFFFFFFFFFFFFFFFUL;
  int print_hash_value = 0;
  transparent_crc_no_string(&crc64_context, p_15->g_3);
  transparent_crc_no_string(&crc64_context, p_15->g_12);
  result[hook(0, get_linear_global_id())] = crc64_context ^ 0xFFFFFFFFFFFFFFFFUL;
}