//{"l_15":7,"l_15[5]":6,"l_6":5,"p_18->g_7":4,"p_18->g_7[0]":3,"p_18->g_7[0][0]":2,"result":0,"sequence_input":1}
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

struct S5 {
  char g_9;
  char* g_8;
  char** g_7[1][1][9];
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

ushort func_1(struct S5* p_18);
char** func_2(uchar p_3, char** p_4, long p_5, struct S5* p_18);
ushort func_1(struct S5* p_18) {
  unsigned int l_6[7];
  char*** l_17 = &p_18->g_7[hook(4, 0)][hook(3, 0)][hook(2, 4)];
  int i;
  for (i = 0; i < 7; i++)
    l_6[hook(5, i)] = 0x6F1860ECL;
  (*l_17) = func_2(l_6[hook(5, 6)], p_18->g_7[hook(4, 0)][hook(3, 0)][hook(2, 4)], p_18->g_9, p_18);
  return l_6[hook(5, 5)];
}

char** func_2(uchar p_3, char** p_4, long p_5, struct S5* p_18) {
  char** l_16 = &p_18->g_8;
  for (p_18->g_9 = 0; (p_18->g_9 <= 18); p_18->g_9++) {
    unsigned int l_12 = 0xBD0176DFL;
    char** l_15[6][2] = {{&p_18->g_8, &p_18->g_8}, {&p_18->g_8, &p_18->g_8}, {&p_18->g_8, &p_18->g_8}, {&p_18->g_8, &p_18->g_8}, {&p_18->g_8, &p_18->g_8}, {&p_18->g_8, &p_18->g_8}};
    int i, j;
    l_12--;
    return l_15[hook(7, 5)][hook(6, 0)];
  }
  p_4 = p_4;
  return l_16;
}

kernel void entry(global ulong* result, global int* sequence_input) {
  int i, j, k;
  struct S5 c_19;
  struct S5* p_18 = &c_19;
  struct S5 c_20 = {
      0x35L, &p_18->g_9, {{{&p_18->g_8, &p_18->g_8, &p_18->g_8, &p_18->g_8, &p_18->g_8, &p_18->g_8, &p_18->g_8, &p_18->g_8, &p_18->g_8}}}, sequence_input[hook(1, get_global_id(0))], sequence_input[hook(1, get_global_id(1))], sequence_input[hook(1, get_global_id(2))], sequence_input[hook(1, get_local_id(0))], sequence_input[hook(1, get_local_id(1))], sequence_input[hook(1, get_local_id(2))], sequence_input[hook(1, get_group_id(0))], sequence_input[hook(1, get_group_id(1))], sequence_input[hook(1, get_group_id(2))],
  };
  c_19 = c_20;
  barrier(0x01 | 0x02);
  func_1(p_18);
  barrier(0x01 | 0x02);
  ulong crc64_context = 0xFFFFFFFFFFFFFFFFUL;
  int print_hash_value = 0;
  transparent_crc_no_string(&crc64_context, p_18->g_9);
  result[hook(0, get_linear_global_id())] = crc64_context ^ 0xFFFFFFFFFFFFFFFFUL;
}