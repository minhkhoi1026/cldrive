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
  int f0;
  unsigned int f1;
  volatile long f2;
  volatile int f3;
  char f4;
  volatile int f5;
  uchar f6;
  long f7;
  int f8;
  uchar f9;
};

struct S1 {
  unsigned int g_3;
  struct S0 g_4;
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

struct S0 func_1(struct S1* p_5);
struct S0 func_1(struct S1* p_5) {
  char l_2 = 0x74L;
  p_5->g_3 = l_2;
  return p_5->g_4;
}

kernel void entry(global ulong* result, global int* sequence_input) {
  int;
  struct S1 c_6;
  struct S1* p_5 = &c_6;
  struct S1 c_7 = {
      0xB0E1B1B5L, {-1L, 0UL, 1L, 0x25155467L, 0x01L, 0x123CCDE6L, 254UL, -1L, 5L, 252UL}, sequence_input[hook(1, get_global_id(0))], sequence_input[hook(1, get_global_id(1))], sequence_input[hook(1, get_global_id(2))], sequence_input[hook(1, get_local_id(0))], sequence_input[hook(1, get_local_id(1))], sequence_input[hook(1, get_local_id(2))], sequence_input[hook(1, get_group_id(0))], sequence_input[hook(1, get_group_id(1))], sequence_input[hook(1, get_group_id(2))],
  };
  c_6 = c_7;
  barrier(0x01 | 0x02);
  func_1(p_5);
  barrier(0x01 | 0x02);
  ulong crc64_context = 0xFFFFFFFFFFFFFFFFUL;
  int print_hash_value = 0;
  transparent_crc_no_string(&crc64_context, p_5->g_3);
  transparent_crc_no_string(&crc64_context, p_5->g_4.f0);
  transparent_crc_no_string(&crc64_context, p_5->g_4.f1);
  transparent_crc_no_string(&crc64_context, p_5->g_4.f2);
  transparent_crc_no_string(&crc64_context, p_5->g_4.f3);
  transparent_crc_no_string(&crc64_context, p_5->g_4.f4);
  transparent_crc_no_string(&crc64_context, p_5->g_4.f5);
  transparent_crc_no_string(&crc64_context, p_5->g_4.f6);
  transparent_crc_no_string(&crc64_context, p_5->g_4.f7);
  transparent_crc_no_string(&crc64_context, p_5->g_4.f8);
  transparent_crc_no_string(&crc64_context, p_5->g_4.f9);
  result[hook(0, get_linear_global_id())] = crc64_context ^ 0xFFFFFFFFFFFFFFFFUL;
}