//{"g_atomic_input":1,"g_special_values":2,"l_7":4,"result":0,"sequence_input":3}
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

struct S3 {
  int g_3;
  volatile ushort g_11;
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

long func_1(struct S3* p_14);
long func_1(struct S3* p_14) {
  int* l_2 = &p_14->g_3;
  int* l_4 = &p_14->g_3;
  int* l_5 = &p_14->g_3;
  int* l_6[9][7][1] = {{{(void*)0}, {(void*)0}, {(void*)0}, {(void*)0}, {(void*)0}, {(void*)0}, {(void*)0}}, {{(void*)0}, {(void*)0}, {(void*)0}, {(void*)0}, {(void*)0}, {(void*)0}, {(void*)0}}, {{(void*)0}, {(void*)0}, {(void*)0}, {(void*)0}, {(void*)0}, {(void*)0}, {(void*)0}}, {{(void*)0}, {(void*)0}, {(void*)0}, {(void*)0}, {(void*)0}, {(void*)0}, {(void*)0}}, {{(void*)0}, {(void*)0}, {(void*)0}, {(void*)0}, {(void*)0}, {(void*)0}, {(void*)0}}, {{(void*)0}, {(void*)0}, {(void*)0}, {(void*)0}, {(void*)0}, {(void*)0}, {(void*)0}}, {{(void*)0}, {(void*)0}, {(void*)0}, {(void*)0}, {(void*)0}, {(void*)0}, {(void*)0}}, {{(void*)0}, {(void*)0}, {(void*)0}, {(void*)0}, {(void*)0}, {(void*)0}, {(void*)0}}, {{(void*)0}, {(void*)0}, {(void*)0}, {(void*)0}, {(void*)0}, {(void*)0}, {(void*)0}}};
  ulong l_7[5] = {1UL, 1UL, 1UL, 1UL, 1UL};
  long l_10 = 0x5C0E3E7631615E82L;
  int i, j, k;
  l_7[hook(4, 0)]++;
  p_14->g_11++;
  return p_14->g_3;
}

kernel void entry(global ulong* result, global volatile unsigned int* g_atomic_input, global volatile unsigned int* g_special_values, global int* sequence_input) {
  int;
  struct S3 c_15;
  struct S3* p_14 = &c_15;
  struct S3 c_16 = {
      0x588D0D3FL, 2UL, sequence_input[hook(3, get_global_id(0))], sequence_input[hook(3, get_global_id(1))], sequence_input[hook(3, get_global_id(2))], sequence_input[hook(3, get_local_id(0))], sequence_input[hook(3, get_local_id(1))], sequence_input[hook(3, get_local_id(2))], sequence_input[hook(3, get_group_id(0))], sequence_input[hook(3, get_group_id(1))], sequence_input[hook(3, get_group_id(2))],
  };
  c_15 = c_16;
  barrier(0x01 | 0x02);
  func_1(p_14);
  barrier(0x01 | 0x02);
  ulong crc64_context = 0xFFFFFFFFFFFFFFFFUL;
  int print_hash_value = 0;
  transparent_crc_no_string(&crc64_context, p_14->g_3);
  transparent_crc_no_string(&crc64_context, p_14->g_11);
  result[hook(0, get_linear_global_id())] = crc64_context ^ 0xFFFFFFFFFFFFFFFFUL;
}