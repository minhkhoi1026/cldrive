//{"p_4->g_3":4,"p_4->g_3[8]":3,"p_4->g_3[8][0]":2,"p_4->g_3[i]":6,"p_4->g_3[i][j]":5,"result":0,"sequence_input":1}
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

union U0 {
  char f0;
  volatile int f1;
  short f2;
  uchar f3;
  uchar f4;
};

struct S1 {
  int4 g_2;
  union U0 g_3[10][7][3];
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

union U0 func_1(struct S1* p_4);
union U0 func_1(struct S1* p_4) {
  p_4->g_2.y = ((int4)(p_4->g_2.zyzw)).z;
  return p_4->g_3[hook(4, 8)][hook(3, 0)][hook(2, 1)];
}

kernel void entry(global ulong* result, global int* sequence_input) {
  int i, j, k;
  struct S1 c_5;
  struct S1* p_4 = &c_5;
  struct S1 c_6 = {
      (int4)(7L, (int2)(7L, 0x187F2FB5L), 0x187F2FB5L), {{{{0x3DL}, {1L}, {1L}}, {{0x3DL}, {1L}, {1L}}, {{0x3DL}, {1L}, {1L}}, {{0x3DL}, {1L}, {1L}}, {{0x3DL}, {1L}, {1L}}, {{0x3DL}, {1L}, {1L}}, {{0x3DL}, {1L}, {1L}}}, {{{0x3DL}, {1L}, {1L}}, {{0x3DL}, {1L}, {1L}}, {{0x3DL}, {1L}, {1L}}, {{0x3DL}, {1L}, {1L}}, {{0x3DL}, {1L}, {1L}}, {{0x3DL}, {1L}, {1L}}, {{0x3DL}, {1L}, {1L}}}, {{{0x3DL}, {1L}, {1L}}, {{0x3DL}, {1L}, {1L}}, {{0x3DL}, {1L}, {1L}}, {{0x3DL}, {1L}, {1L}}, {{0x3DL}, {1L}, {1L}}, {{0x3DL}, {1L}, {1L}}, {{0x3DL}, {1L}, {1L}}}, {{{0x3DL}, {1L}, {1L}}, {{0x3DL}, {1L}, {1L}}, {{0x3DL}, {1L}, {1L}}, {{0x3DL}, {1L}, {1L}}, {{0x3DL}, {1L}, {1L}}, {{0x3DL}, {1L}, {1L}}, {{0x3DL}, {1L}, {1L}}}, {{{0x3DL}, {1L}, {1L}}, {{0x3DL}, {1L}, {1L}}, {{0x3DL}, {1L}, {1L}}, {{0x3DL}, {1L}, {1L}}, {{0x3DL}, {1L}, {1L}}, {{0x3DL}, {1L}, {1L}}, {{0x3DL}, {1L}, {1L}}}, {{{0x3DL}, {1L}, {1L}}, {{0x3DL}, {1L}, {1L}}, {{0x3DL}, {1L}, {1L}}, {{0x3DL}, {1L}, {1L}}, {{0x3DL}, {1L}, {1L}}, {{0x3DL}, {1L}, {1L}}, {{0x3DL}, {1L}, {1L}}}, {{{0x3DL}, {1L}, {1L}}, {{0x3DL}, {1L}, {1L}}, {{0x3DL}, {1L}, {1L}}, {{0x3DL}, {1L}, {1L}}, {{0x3DL}, {1L}, {1L}}, {{0x3DL}, {1L}, {1L}}, {{0x3DL}, {1L}, {1L}}}, {{{0x3DL}, {1L}, {1L}}, {{0x3DL}, {1L}, {1L}}, {{0x3DL}, {1L}, {1L}}, {{0x3DL}, {1L}, {1L}}, {{0x3DL}, {1L}, {1L}}, {{0x3DL}, {1L}, {1L}}, {{0x3DL}, {1L}, {1L}}}, {{{0x3DL}, {1L}, {1L}}, {{0x3DL}, {1L}, {1L}}, {{0x3DL}, {1L}, {1L}}, {{0x3DL}, {1L}, {1L}}, {{0x3DL}, {1L}, {1L}}, {{0x3DL}, {1L}, {1L}}, {{0x3DL}, {1L}, {1L}}}, {{{0x3DL}, {1L}, {1L}}, {{0x3DL}, {1L}, {1L}}, {{0x3DL}, {1L}, {1L}}, {{0x3DL}, {1L}, {1L}}, {{0x3DL}, {1L}, {1L}}, {{0x3DL}, {1L}, {1L}}, {{0x3DL}, {1L}, {1L}}}}, sequence_input[hook(1, get_global_id(0))], sequence_input[hook(1, get_global_id(1))], sequence_input[hook(1, get_global_id(2))], sequence_input[hook(1, get_local_id(0))], sequence_input[hook(1, get_local_id(1))], sequence_input[hook(1, get_local_id(2))], sequence_input[hook(1, get_group_id(0))], sequence_input[hook(1, get_group_id(1))], sequence_input[hook(1, get_group_id(2))],
  };
  c_5 = c_6;
  barrier(0x01 | 0x02);
  func_1(p_4);
  barrier(0x01 | 0x02);
  ulong crc64_context = 0xFFFFFFFFFFFFFFFFUL;
  int print_hash_value = 0;
  transparent_crc_no_string(&crc64_context, p_4->g_2.x);
  transparent_crc_no_string(&crc64_context, p_4->g_2.y);
  transparent_crc_no_string(&crc64_context, p_4->g_2.z);
  transparent_crc_no_string(&crc64_context, p_4->g_2.w);
  for (i = 0; i < 10; i++) {
    for (j = 0; j < 7; j++) {
      for (k = 0; k < 3; k++) {
        transparent_crc_no_string(&crc64_context, p_4->g_3[hook(4, i)][hook(6, j)][hook(5, k)].f0);
      }
    }
  }
  result[hook(0, get_linear_global_id())] = crc64_context ^ 0xFFFFFFFFFFFFFFFFUL;
}