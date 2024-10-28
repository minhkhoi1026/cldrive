//{"l_2":2,"p_9->g_3":3,"p_9->g_4":4,"result":0,"sequence_input":1}
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
  int g_3[4];
  ulong g_4[2];
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
  unsigned int l_2[9];
  int l_5 = 0L;
  short l_6 = 0x782BL;
  int i;
  for (i = 0; i < 9; i++)
    l_2[hook(2, i)] = 4294967290UL;
  for (p_9->g_3[hook(3, 1)] = 8; (p_9->g_3[hook(3, 1)] >= 1); p_9->g_3[hook(3, 1)] -= 1) {
    int i;
    p_9->g_4[hook(4, 0)] ^= l_2[hook(2, p_9->g_3[1hook(3, 1))];
    l_5 &= 0L;
  }
  l_5 = (+0x10FECAFEL);
  l_5 = ((++p_9->g_4[hook(4, 0)]) | p_9->g_3[hook(3, 1)]);
  return p_9->g_3[hook(3, 1)];
}

kernel void entry(global ulong* result, global int* sequence_input) {
  int i;
  struct S1 c_10;
  struct S1* p_9 = &c_10;
  struct S1 c_11 = {
      {0x4FE04822L, 0x4FE04822L, 0x4FE04822L, 0x4FE04822L}, {18446744073709551615UL, 18446744073709551615UL}, sequence_input[hook(1, get_global_id(0))], sequence_input[hook(1, get_global_id(1))], sequence_input[hook(1, get_global_id(2))], sequence_input[hook(1, get_local_id(0))], sequence_input[hook(1, get_local_id(1))], sequence_input[hook(1, get_local_id(2))], sequence_input[hook(1, get_group_id(0))], sequence_input[hook(1, get_group_id(1))], sequence_input[hook(1, get_group_id(2))],
  };
  c_10 = c_11;
  barrier(0x01 | 0x02);
  func_1(p_9);
  barrier(0x01 | 0x02);
  ulong crc64_context = 0xFFFFFFFFFFFFFFFFUL;
  int print_hash_value = 0;
  for (i = 0; i < 4; i++) {
    transparent_crc_no_string(&crc64_context, p_9->g_3[hook(3, i)]);
  }
  for (i = 0; i < 2; i++) {
    transparent_crc_no_string(&crc64_context, p_9->g_4[hook(4, i)]);
  }
  result[hook(0, get_linear_global_id())] = crc64_context ^ 0xFFFFFFFFFFFFFFFFUL;
}