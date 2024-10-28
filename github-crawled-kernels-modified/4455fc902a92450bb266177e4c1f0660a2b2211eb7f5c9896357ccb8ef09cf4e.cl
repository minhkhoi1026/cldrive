//{"p_13->g_12":5,"p_13->g_8":4,"p_13->g_8[0]":3,"p_13->g_8[0][6]":2,"p_13->g_8[i]":7,"p_13->g_8[i][j]":6,"result":0,"sequence_input":1}
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
  unsigned int g_8[1][7][6];
  int g_12[5];
  int* volatile g_11;
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

unsigned int func_1(struct S0* p_13);
unsigned int func_1(struct S0* p_13) {
  int* l_2 = &p_13->g_3;
  int* l_4 = &p_13->g_3;
  int* l_5 = &p_13->g_3;
  int* l_6 = &p_13->g_3;
  int* l_7 = &p_13->g_3;
  p_13->g_8[hook(4, 0)][hook(3, 6)][hook(2, 0)]++;
  (*p_13->g_11) = ((*l_4) |= 0x50A4BA31L);
  return p_13->g_3;
}

kernel void entry(global ulong* result, global int* sequence_input) {
  int i, j, k;
  struct S0 c_14;
  struct S0* p_13 = &c_14;
  struct S0 c_15 = {
      4L, {{{0x9989D221L, 7UL, 6UL, 4294967289UL, 6UL, 7UL}, {0x9989D221L, 7UL, 6UL, 4294967289UL, 6UL, 7UL}, {0x9989D221L, 7UL, 6UL, 4294967289UL, 6UL, 7UL}, {0x9989D221L, 7UL, 6UL, 4294967289UL, 6UL, 7UL}, {0x9989D221L, 7UL, 6UL, 4294967289UL, 6UL, 7UL}, {0x9989D221L, 7UL, 6UL, 4294967289UL, 6UL, 7UL}, {0x9989D221L, 7UL, 6UL, 4294967289UL, 6UL, 7UL}}}, {0L, 0L, 0L, 0L, 0L}, &p_13->g_12[hook(5, 3)], sequence_input[hook(1, get_global_id(0))], sequence_input[hook(1, get_global_id(1))], sequence_input[hook(1, get_global_id(2))], sequence_input[hook(1, get_local_id(0))], sequence_input[hook(1, get_local_id(1))], sequence_input[hook(1, get_local_id(2))], sequence_input[hook(1, get_group_id(0))], sequence_input[hook(1, get_group_id(1))], sequence_input[hook(1, get_group_id(2))],
  };
  c_14 = c_15;
  barrier(0x01 | 0x02);
  func_1(p_13);
  barrier(0x01 | 0x02);
  ulong crc64_context = 0xFFFFFFFFFFFFFFFFUL;
  int print_hash_value = 0;
  transparent_crc_no_string(&crc64_context, p_13->g_3);
  for (i = 0; i < 1; i++) {
    for (j = 0; j < 7; j++) {
      for (k = 0; k < 6; k++) {
        transparent_crc_no_string(&crc64_context, p_13->g_8[hook(4, i)][hook(7, j)][hook(6, k)]);
      }
    }
  }
  for (i = 0; i < 5; i++) {
    transparent_crc_no_string(&crc64_context, p_13->g_12[hook(5, i)]);
  }
  result[hook(0, get_linear_global_id())] = crc64_context ^ 0xFFFFFFFFFFFFFFFFUL;
}