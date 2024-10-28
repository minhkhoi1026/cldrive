//{"g_atomic_input":1,"g_special_values":2,"result":0,"sequence_input":3}
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
  char f1;
  unsigned int f2;
  volatile ulong f3;
  unsigned int f4;
};

struct S3 {
  struct S0 g_2;
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

struct S0 func_1(struct S3* p_3);
struct S0 func_1(struct S3* p_3) {
  return p_3->g_2;
}

kernel void entry(global ulong* result, global volatile unsigned int* g_atomic_input, global volatile unsigned int* g_special_values, global int* sequence_input) {
  int;
  struct S3 c_4;
  struct S3* p_3 = &c_4;
  struct S3 c_5 = {
      {9UL, 0x12L, 0xD42CA8CDL, 0x2AE7B79F6A715CC4L, 0xB1647C2CL}, sequence_input[hook(3, get_global_id(0))], sequence_input[hook(3, get_global_id(1))], sequence_input[hook(3, get_global_id(2))], sequence_input[hook(3, get_local_id(0))], sequence_input[hook(3, get_local_id(1))], sequence_input[hook(3, get_local_id(2))], sequence_input[hook(3, get_group_id(0))], sequence_input[hook(3, get_group_id(1))], sequence_input[hook(3, get_group_id(2))],
  };
  c_4 = c_5;
  barrier(0x01 | 0x02);
  func_1(p_3);
  barrier(0x01 | 0x02);
  ulong crc64_context = 0xFFFFFFFFFFFFFFFFUL;
  int print_hash_value = 0;
  transparent_crc_no_string(&crc64_context, p_3->g_2.f0);
  transparent_crc_no_string(&crc64_context, p_3->g_2.f1);
  transparent_crc_no_string(&crc64_context, p_3->g_2.f2);
  transparent_crc_no_string(&crc64_context, p_3->g_2.f3);
  transparent_crc_no_string(&crc64_context, p_3->g_2.f4);
  result[hook(0, get_linear_global_id())] = crc64_context ^ 0xFFFFFFFFFFFFFFFFUL;
}