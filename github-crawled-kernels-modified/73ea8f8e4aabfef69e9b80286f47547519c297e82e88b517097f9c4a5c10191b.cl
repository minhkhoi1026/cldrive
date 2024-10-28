//{"g_atomic_input":1,"g_special_values":2,"l_2":5,"l_atomic_input":7,"l_special_values":8,"p_4->l_atomic_input":4,"p_4->l_special_values":6,"result":0,"sequence_input":3}
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

struct S2 {
  int g_3;
  ulong global_0_offset;
  ulong global_1_offset;
  ulong global_2_offset;
  ulong local_0_offset;
  ulong local_1_offset;
  ulong local_2_offset;
  ulong group_0_offset;
  ulong group_1_offset;
  ulong group_2_offset;
  local volatile unsigned int* l_atomic_input;
  local volatile unsigned int* l_special_values;
};

ushort func_1(struct S2* p_4);
ushort func_1(struct S2* p_4) {
  if ((atomic_inc(&p_4->l_atomic_input[hook(4, 29)]) == 6)) {
    ulong l_2[8];
    int i;
    for (i = 0; i < 8; i++)
      l_2[hook(5, i)] = 0UL;
    l_2[hook(5, 7)] |= 0L;
    unsigned int result = 0;
    int l_2_i0;
    for (l_2_i0 = 0; l_2_i0 < 8; l_2_i0++) {
      result += l_2[hook(5, l_2_i0)];
    }
    atomic_add(&p_4->l_special_values[hook(6, 29)], result);
  } else {
    (1 + 1);
  }
  return p_4->g_3;
}

kernel void entry(global ulong* result, global volatile unsigned int* g_atomic_input, global volatile unsigned int* g_special_values, global int* sequence_input) {
  int i;
  local volatile unsigned int l_atomic_input[48];
  if (get_linear_local_id() == 0)
    for (i = 0; i < 48; i++)
      l_atomic_input[hook(7, i)] = 0;
  local volatile unsigned int l_special_values[48];
  if (get_linear_local_id() == 0)
    for (i = 0; i < 48; i++)
      l_special_values[hook(8, i)] = 0;
  struct S2 c_5;
  struct S2* p_4 = &c_5;
  struct S2 c_6 = {
      4L, sequence_input[hook(3, get_global_id(0))], sequence_input[hook(3, get_global_id(1))], sequence_input[hook(3, get_global_id(2))], sequence_input[hook(3, get_local_id(0))], sequence_input[hook(3, get_local_id(1))], sequence_input[hook(3, get_local_id(2))], sequence_input[hook(3, get_group_id(0))], sequence_input[hook(3, get_group_id(1))], sequence_input[hook(3, get_group_id(2))], l_atomic_input, l_special_values,
  };
  c_5 = c_6;
  barrier(0x01 | 0x02);
  func_1(p_4);
  barrier(0x01 | 0x02);
  ulong crc64_context = 0xFFFFFFFFFFFFFFFFUL;
  int print_hash_value = 0;
  transparent_crc_no_string(&crc64_context, p_4->g_3);
  barrier(0x01 | 0x02);
  if (!get_linear_local_id())
    for (i = 0; i < 48; i++)
      transparent_crc_no_string(&crc64_context, p_4->l_special_values[hook(6, i)]);
  result[hook(0, get_linear_global_id())] = crc64_context ^ 0xFFFFFFFFFFFFFFFFUL;
}