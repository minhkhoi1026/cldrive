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
  volatile ulong g_2;
  ulong g_3;
  int g_9;
  int* volatile g_8;
  volatile ushort2 g_14;
  unsigned int g_17;
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

int func_1(struct S0* p_18);
int func_1(struct S0* p_18) {
  char l_4 = 0x16L;
  if (p_18->g_2) {
    l_4 = (p_18->g_2 >= p_18->g_3);
    for (p_18->g_3 = 17; (p_18->g_3 == 6); --p_18->g_3) {
      unsigned int l_7 = 7UL;
      (*p_18->g_8) |= l_7;
    }
  } else {
    int* l_10 = &p_18->g_9;
    int l_11 = 0x64896E6AL;
    int* l_12 = &p_18->g_9;
    int* l_13[6] = {&p_18->g_9, &p_18->g_9, &p_18->g_9, &p_18->g_9, &p_18->g_9, &p_18->g_9};
    int i;
    ++p_18->g_14.y;
    p_18->g_17 &= (*p_18->g_8);
  }
  return (*p_18->g_8);
}

kernel void entry(global ulong* result, global int* sequence_input) {
  int i;
  struct S0 c_19;
  struct S0* p_18 = &c_19;
  struct S0 c_20 = {
      1UL, 0xA1E948708EF6B8F3L, 4L, &p_18->g_9, (ushort2)(65534UL, 0x5612L), 0x878ED7C3L, sequence_input[hook(1, get_global_id(0))], sequence_input[hook(1, get_global_id(1))], sequence_input[hook(1, get_global_id(2))], sequence_input[hook(1, get_local_id(0))], sequence_input[hook(1, get_local_id(1))], sequence_input[hook(1, get_local_id(2))], sequence_input[hook(1, get_group_id(0))], sequence_input[hook(1, get_group_id(1))], sequence_input[hook(1, get_group_id(2))],
  };
  c_19 = c_20;
  barrier(0x01 | 0x02);
  func_1(p_18);
  barrier(0x01 | 0x02);
  ulong crc64_context = 0xFFFFFFFFFFFFFFFFUL;
  int print_hash_value = 0;
  transparent_crc_no_string(&crc64_context, p_18->g_2);
  transparent_crc_no_string(&crc64_context, p_18->g_3);
  transparent_crc_no_string(&crc64_context, p_18->g_9);
  transparent_crc_no_string(&crc64_context, p_18->g_14.x);
  transparent_crc_no_string(&crc64_context, p_18->g_14.y);
  transparent_crc_no_string(&crc64_context, p_18->g_17);
  result[hook(0, get_linear_global_id())] = crc64_context ^ 0xFFFFFFFFFFFFFFFFUL;
}