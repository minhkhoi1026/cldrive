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
  volatile unsigned int f0;
  unsigned int f1;
};

struct S2 {
  int g_2;
  int g_4;
  int* volatile g_3;
  volatile struct S1 g_5;
  volatile struct S1* volatile g_6;
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

short func_1(struct S2* p_7);
short func_1(struct S2* p_7) {
  (*p_7->g_3) &= (p_7->g_2 != p_7->g_2);
  (*p_7->g_6) = p_7->g_5;
  return p_7->g_5.f1;
}

kernel void entry(global ulong* result, global int* sequence_input) {
  int;
  struct S2 c_8;
  struct S2* p_7 = &c_8;
  struct S2 c_9 = {
      (-1L), 0x304800FAL, &p_7->g_4, {4294967295UL, 4294967295UL}, &p_7->g_5, sequence_input[hook(1, get_global_id(0))], sequence_input[hook(1, get_global_id(1))], sequence_input[hook(1, get_global_id(2))], sequence_input[hook(1, get_local_id(0))], sequence_input[hook(1, get_local_id(1))], sequence_input[hook(1, get_local_id(2))], sequence_input[hook(1, get_group_id(0))], sequence_input[hook(1, get_group_id(1))], sequence_input[hook(1, get_group_id(2))],
  };
  c_8 = c_9;
  barrier(0x01 | 0x02);
  func_1(p_7);
  barrier(0x01 | 0x02);
  ulong crc64_context = 0xFFFFFFFFFFFFFFFFUL;
  int print_hash_value = 0;
  transparent_crc_no_string(&crc64_context, p_7->g_2);
  transparent_crc_no_string(&crc64_context, p_7->g_4);
  transparent_crc_no_string(&crc64_context, p_7->g_5.f0);
  transparent_crc_no_string(&crc64_context, p_7->g_5.f1);
  result[hook(0, get_linear_global_id())] = crc64_context ^ 0xFFFFFFFFFFFFFFFFUL;
}