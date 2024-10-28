//{"l_2":4,"l_2[1]":3,"l_2[1][2]":2,"result":0,"sequence_input":1}
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
  char f0;
  uchar f1;
};

struct S3 {
  int g_4;
  int* volatile g_3;
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

unsigned int func_1(struct S3* p_7);
unsigned int func_1(struct S3* p_7) {
  ulong l_2[2][6][9] = {{{0UL, 0x6F49C23EDB39523DL, 0xEB2391CB4E76AB2AL, 0x6F49C23EDB39523DL, 0UL, 0x47C9D5FAC12265E3L, 0x1342F3D47941CE3CL, 0x78213AF72B5725D3L, 0xA5B0420410224968L}, {0UL, 0x6F49C23EDB39523DL, 0xEB2391CB4E76AB2AL, 0x6F49C23EDB39523DL, 0UL, 0x47C9D5FAC12265E3L, 0x1342F3D47941CE3CL, 0x78213AF72B5725D3L, 0xA5B0420410224968L}, {0UL, 0x6F49C23EDB39523DL, 0xEB2391CB4E76AB2AL, 0x6F49C23EDB39523DL, 0UL, 0x47C9D5FAC12265E3L, 0x1342F3D47941CE3CL, 0x78213AF72B5725D3L, 0xA5B0420410224968L}, {0UL, 0x6F49C23EDB39523DL, 0xEB2391CB4E76AB2AL, 0x6F49C23EDB39523DL, 0UL, 0x47C9D5FAC12265E3L, 0x1342F3D47941CE3CL, 0x78213AF72B5725D3L, 0xA5B0420410224968L}, {0UL, 0x6F49C23EDB39523DL, 0xEB2391CB4E76AB2AL, 0x6F49C23EDB39523DL, 0UL, 0x47C9D5FAC12265E3L, 0x1342F3D47941CE3CL, 0x78213AF72B5725D3L, 0xA5B0420410224968L}, {0UL, 0x6F49C23EDB39523DL, 0xEB2391CB4E76AB2AL, 0x6F49C23EDB39523DL, 0UL, 0x47C9D5FAC12265E3L, 0x1342F3D47941CE3CL, 0x78213AF72B5725D3L, 0xA5B0420410224968L}}, {{0UL, 0x6F49C23EDB39523DL, 0xEB2391CB4E76AB2AL, 0x6F49C23EDB39523DL, 0UL, 0x47C9D5FAC12265E3L, 0x1342F3D47941CE3CL, 0x78213AF72B5725D3L, 0xA5B0420410224968L}, {0UL, 0x6F49C23EDB39523DL, 0xEB2391CB4E76AB2AL, 0x6F49C23EDB39523DL, 0UL, 0x47C9D5FAC12265E3L, 0x1342F3D47941CE3CL, 0x78213AF72B5725D3L, 0xA5B0420410224968L}, {0UL, 0x6F49C23EDB39523DL, 0xEB2391CB4E76AB2AL, 0x6F49C23EDB39523DL, 0UL, 0x47C9D5FAC12265E3L, 0x1342F3D47941CE3CL, 0x78213AF72B5725D3L, 0xA5B0420410224968L}, {0UL, 0x6F49C23EDB39523DL, 0xEB2391CB4E76AB2AL, 0x6F49C23EDB39523DL, 0UL, 0x47C9D5FAC12265E3L, 0x1342F3D47941CE3CL, 0x78213AF72B5725D3L, 0xA5B0420410224968L}, {0UL, 0x6F49C23EDB39523DL, 0xEB2391CB4E76AB2AL, 0x6F49C23EDB39523DL, 0UL, 0x47C9D5FAC12265E3L, 0x1342F3D47941CE3CL, 0x78213AF72B5725D3L, 0xA5B0420410224968L}, {0UL, 0x6F49C23EDB39523DL, 0xEB2391CB4E76AB2AL, 0x6F49C23EDB39523DL, 0UL, 0x47C9D5FAC12265E3L, 0x1342F3D47941CE3CL, 0x78213AF72B5725D3L, 0xA5B0420410224968L}}};
  struct S0 l_5 = {-1L, 0xDCL};
  struct S0* l_6 = &l_5;
  int i, j, k;
  (*p_7->g_3) = l_2[hook(4, 1)][hook(3, 2)][hook(2, 5)];
  (*l_6) = l_5;
  return l_5.f0;
}

kernel void entry(global ulong* result, global int* sequence_input) {
  int;
  struct S3 c_8;
  struct S3* p_7 = &c_8;
  struct S3 c_9 = {
      1L, &p_7->g_4, sequence_input[hook(1, get_global_id(0))], sequence_input[hook(1, get_global_id(1))], sequence_input[hook(1, get_global_id(2))], sequence_input[hook(1, get_local_id(0))], sequence_input[hook(1, get_local_id(1))], sequence_input[hook(1, get_local_id(2))], sequence_input[hook(1, get_group_id(0))], sequence_input[hook(1, get_group_id(1))], sequence_input[hook(1, get_group_id(2))],
  };
  c_8 = c_9;
  barrier(0x01 | 0x02);
  func_1(p_7);
  barrier(0x01 | 0x02);
  ulong crc64_context = 0xFFFFFFFFFFFFFFFFUL;
  int print_hash_value = 0;
  transparent_crc_no_string(&crc64_context, p_7->g_4);
  result[hook(0, get_linear_global_id())] = crc64_context ^ 0xFFFFFFFFFFFFFFFFUL;
}