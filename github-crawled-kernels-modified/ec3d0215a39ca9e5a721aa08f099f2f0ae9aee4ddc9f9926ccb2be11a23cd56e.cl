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

struct S1 {
  int4 g_4;
  int* volatile g_3;
  int* volatile g_7;
  int* volatile g_9;
  int* volatile g_10;
  int* volatile g_12;
  int* volatile g_13;
  int* volatile g_14;
  int* volatile g_15;
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

long func_1(struct S1* p_17);
long func_1(struct S1* p_17) {
  char l_2 = (-10L);
  int* l_5 = (void*)0;
  int* l_6 = (void*)0;
  int* l_8 = (void*)0;
  int* l_11 = (void*)0;
  int* l_16 = (void*)0;
  p_17->g_4.y = l_2;
  return p_17->g_4.z;
}

kernel void entry(global ulong* result, global int* sequence_input) {
  int i;
  struct S1 c_18;
  struct S1* p_17 = &c_18;
  struct S1 c_19 = {
      (int4)(0L, (int2)(0L, 0L), 0L), (void*)0, (void*)0, (void*)0, (void*)0, (void*)0, (void*)0, (void*)0, (void*)0, sequence_input[hook(1, get_global_id(0))], sequence_input[hook(1, get_global_id(1))], sequence_input[hook(1, get_global_id(2))], sequence_input[hook(1, get_local_id(0))], sequence_input[hook(1, get_local_id(1))], sequence_input[hook(1, get_local_id(2))], sequence_input[hook(1, get_group_id(0))], sequence_input[hook(1, get_group_id(1))], sequence_input[hook(1, get_group_id(2))],
  };
  c_18 = c_19;
  barrier(0x01 | 0x02);
  func_1(p_17);
  barrier(0x01 | 0x02);
  ulong crc64_context = 0xFFFFFFFFFFFFFFFFUL;
  int print_hash_value = 0;
  transparent_crc_no_string(&crc64_context, p_17->g_4.x);
  transparent_crc_no_string(&crc64_context, p_17->g_4.y);
  transparent_crc_no_string(&crc64_context, p_17->g_4.z);
  transparent_crc_no_string(&crc64_context, p_17->g_4.w);
  result[hook(0, get_linear_global_id())] = crc64_context ^ 0xFFFFFFFFFFFFFFFFUL;
}