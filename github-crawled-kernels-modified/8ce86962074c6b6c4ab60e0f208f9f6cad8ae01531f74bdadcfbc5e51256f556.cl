//{"l_5":2,"p_13->g_10":4,"p_13->g_2":3,"result":0,"sequence_input":1}
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
  int g_2[1];
  int g_3;
  volatile int g_6;
  int g_7;
  volatile int g_8;
  char g_9;
  volatile ushort g_10[9];
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

int func_1(struct S0* p_13);
int func_1(struct S0* p_13) {
  int* l_4 = (void*)0;
  int* l_5[2];
  int i;
  for (i = 0; i < 2; i++)
    l_5[hook(2, i)] = &p_13->g_3;
  for (p_13->g_3 = 0; (p_13->g_3 <= 0); p_13->g_3 += 1) {
    int i;
    return p_13->g_2[hook(3, p_13->g_3)];
  }
  p_13->g_10[hook(4, 3)]++;
  return p_13->g_9;
}

kernel void entry(global ulong* result, global int* sequence_input) {
  int i;
  struct S0 c_14;
  struct S0* p_13 = &c_14;
  struct S0 c_15 = {
      {(-1L)}, 0x2DE2167FL, 0x0184DCC8L, 5L, 1L, 1L, {0x8BBDL, 0x8838L, 0x8BBDL, 0x8BBDL, 0x8838L, 0x8BBDL, 0x8BBDL, 0x8838L, 0x8BBDL}, sequence_input[hook(1, get_global_id(0))], sequence_input[hook(1, get_global_id(1))], sequence_input[hook(1, get_global_id(2))], sequence_input[hook(1, get_local_id(0))], sequence_input[hook(1, get_local_id(1))], sequence_input[hook(1, get_local_id(2))], sequence_input[hook(1, get_group_id(0))], sequence_input[hook(1, get_group_id(1))], sequence_input[hook(1, get_group_id(2))],
  };
  c_14 = c_15;
  barrier(0x01 | 0x02);
  func_1(p_13);
  barrier(0x01 | 0x02);
  ulong crc64_context = 0xFFFFFFFFFFFFFFFFUL;
  int print_hash_value = 0;
  for (i = 0; i < 1; i++) {
    transparent_crc_no_string(&crc64_context, p_13->g_2[hook(3, i)]);
  }
  transparent_crc_no_string(&crc64_context, p_13->g_3);
  transparent_crc_no_string(&crc64_context, p_13->g_6);
  transparent_crc_no_string(&crc64_context, p_13->g_7);
  transparent_crc_no_string(&crc64_context, p_13->g_8);
  transparent_crc_no_string(&crc64_context, p_13->g_9);
  for (i = 0; i < 9; i++) {
    transparent_crc_no_string(&crc64_context, p_13->g_10[hook(4, i)]);
  }
  result[hook(0, get_linear_global_id())] = crc64_context ^ 0xFFFFFFFFFFFFFFFFUL;
}