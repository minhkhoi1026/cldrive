//{"g_atomic_reduction":1,"l_5":3,"l_atomic_reduction":4,"p_6->g_4":5,"result":0,"sequence_input":2}
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
  volatile uchar g_2;
  volatile int g_4[4];
  volatile int* volatile g_3;
  unsigned int v_collective;
  ulong global_0_offset;
  ulong global_1_offset;
  ulong global_2_offset;
  ulong local_0_offset;
  ulong local_1_offset;
  ulong local_2_offset;
  ulong group_0_offset;
  ulong group_1_offset;
  ulong group_2_offset;
  local volatile unsigned int* l_atomic_reduction;
  global volatile unsigned int* g_atomic_reduction;
};

unsigned int func_1(struct S3* p_6);
unsigned int func_1(struct S3* p_6) {
  unsigned int l_5[5] = {0x2A831D26L, 0x2A831D26L, 0x2A831D26L, 0x2A831D26L, 0x2A831D26L};
  int i;
  (*p_6->g_3) = p_6->g_2;
  return l_5[hook(3, 4)];
}

kernel void entry(global ulong* result, global volatile int* g_atomic_reduction, global int* sequence_input) {
  int i;
  local volatile unsigned int l_atomic_reduction[1];
  if (get_linear_local_id() == 0)
    for (i = 0; i < 1; i++)
      l_atomic_reduction[hook(4, i)] = 0;
  struct S3 c_7;
  struct S3* p_6 = &c_7;
  struct S3 c_8 = {
      0x65L, {7L, 7L, 7L, 7L}, &p_6->g_4[hook(5, 1)], 0, sequence_input[hook(2, get_global_id(0))], sequence_input[hook(2, get_global_id(1))], sequence_input[hook(2, get_global_id(2))], sequence_input[hook(2, get_local_id(0))], sequence_input[hook(2, get_local_id(1))], sequence_input[hook(2, get_local_id(2))], sequence_input[hook(2, get_group_id(0))], sequence_input[hook(2, get_group_id(1))], sequence_input[hook(2, get_group_id(2))], l_atomic_reduction, g_atomic_reduction,
  };
  c_7 = c_8;
  barrier(0x01 | 0x02);
  func_1(p_6);
  barrier(0x01 | 0x02);
  ulong crc64_context = 0xFFFFFFFFFFFFFFFFUL;
  int print_hash_value = 0;
  transparent_crc_no_string(&crc64_context, p_6->g_2);
  for (i = 0; i < 4; i++) {
    transparent_crc_no_string(&crc64_context, p_6->g_4[hook(5, i)]);
  }
  transparent_crc_no_string(&crc64_context, p_6->v_collective);
  result[hook(0, get_linear_global_id())] = crc64_context ^ 0xFFFFFFFFFFFFFFFFUL;
}