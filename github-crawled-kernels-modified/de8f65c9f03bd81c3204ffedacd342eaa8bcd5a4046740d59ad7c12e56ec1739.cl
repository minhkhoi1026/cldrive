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
  unsigned int f0;
  unsigned int f1;
  unsigned int f2;
  ulong f3;
};

struct S1 {
  unsigned int f0;
  volatile int f1;
  volatile int f2;
  volatile struct S0 f3;
  int f4;
  long f5;
};

struct S2 {
  int g_3;
  int* g_2;
  int* g_5;
  struct S1 g_6;
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

struct S1 func_1(struct S2* p_7);
struct S1 func_1(struct S2* p_7) {
  int** l_4 = &p_7->g_2;
  p_7->g_5 = ((*l_4) = p_7->g_2);
  return p_7->g_6;
}

kernel void entry(global ulong* result, global int* sequence_input) {
  int;
  struct S2 c_8;
  struct S2* p_7 = &c_8;
  struct S2 c_9 = {
      1L, &p_7->g_3, &p_7->g_3, {0UL, 0x3CCD2466L, 0x1F08664AL, {0x1600D549L, 0xE623B470L, 0xBA87A5EAL, 0xB5D1CB6A7F4EA14CL}, 0x530C4E2BL, 0x5F40E13F5E3D1AA1L}, sequence_input[hook(1, get_global_id(0))], sequence_input[hook(1, get_global_id(1))], sequence_input[hook(1, get_global_id(2))], sequence_input[hook(1, get_local_id(0))], sequence_input[hook(1, get_local_id(1))], sequence_input[hook(1, get_local_id(2))], sequence_input[hook(1, get_group_id(0))], sequence_input[hook(1, get_group_id(1))], sequence_input[hook(1, get_group_id(2))],
  };
  c_8 = c_9;
  barrier(0x01 | 0x02);
  func_1(p_7);
  barrier(0x01 | 0x02);
  ulong crc64_context = 0xFFFFFFFFFFFFFFFFUL;
  int print_hash_value = 0;
  transparent_crc_no_string(&crc64_context, p_7->g_3);
  transparent_crc_no_string(&crc64_context, p_7->g_6.f0);
  transparent_crc_no_string(&crc64_context, p_7->g_6.f1);
  transparent_crc_no_string(&crc64_context, p_7->g_6.f2);
  transparent_crc_no_string(&crc64_context, p_7->g_6.f3.f0);
  transparent_crc_no_string(&crc64_context, p_7->g_6.f3.f1);
  transparent_crc_no_string(&crc64_context, p_7->g_6.f3.f2);
  transparent_crc_no_string(&crc64_context, p_7->g_6.f3.f3);
  transparent_crc_no_string(&crc64_context, p_7->g_6.f4);
  transparent_crc_no_string(&crc64_context, p_7->g_6.f5);
  result[hook(0, get_linear_global_id())] = crc64_context ^ 0xFFFFFFFFFFFFFFFFUL;
}