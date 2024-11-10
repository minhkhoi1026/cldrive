//{"l_2":4,"l_2[5]":3,"l_2[5][1]":2,"result":0,"sequence_input":1}
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

struct S7 {
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

int func_1(struct S7* p_3);
int func_1(struct S7* p_3) {
  ulong l_2[7][9][4] = {{{0x81308FB828C20713L, 7UL, 18446744073709551615UL, 0x734166DA9A16D6AEL}, {0x81308FB828C20713L, 7UL, 18446744073709551615UL, 0x734166DA9A16D6AEL}, {0x81308FB828C20713L, 7UL, 18446744073709551615UL, 0x734166DA9A16D6AEL}, {0x81308FB828C20713L, 7UL, 18446744073709551615UL, 0x734166DA9A16D6AEL}, {0x81308FB828C20713L, 7UL, 18446744073709551615UL, 0x734166DA9A16D6AEL}, {0x81308FB828C20713L, 7UL, 18446744073709551615UL, 0x734166DA9A16D6AEL}, {0x81308FB828C20713L, 7UL, 18446744073709551615UL, 0x734166DA9A16D6AEL}, {0x81308FB828C20713L, 7UL, 18446744073709551615UL, 0x734166DA9A16D6AEL}, {0x81308FB828C20713L, 7UL, 18446744073709551615UL, 0x734166DA9A16D6AEL}}, {{0x81308FB828C20713L, 7UL, 18446744073709551615UL, 0x734166DA9A16D6AEL}, {0x81308FB828C20713L, 7UL, 18446744073709551615UL, 0x734166DA9A16D6AEL}, {0x81308FB828C20713L, 7UL, 18446744073709551615UL, 0x734166DA9A16D6AEL}, {0x81308FB828C20713L, 7UL, 18446744073709551615UL, 0x734166DA9A16D6AEL}, {0x81308FB828C20713L, 7UL, 18446744073709551615UL, 0x734166DA9A16D6AEL}, {0x81308FB828C20713L, 7UL, 18446744073709551615UL, 0x734166DA9A16D6AEL}, {0x81308FB828C20713L, 7UL, 18446744073709551615UL, 0x734166DA9A16D6AEL}, {0x81308FB828C20713L, 7UL, 18446744073709551615UL, 0x734166DA9A16D6AEL}, {0x81308FB828C20713L, 7UL, 18446744073709551615UL, 0x734166DA9A16D6AEL}}, {{0x81308FB828C20713L, 7UL, 18446744073709551615UL, 0x734166DA9A16D6AEL}, {0x81308FB828C20713L, 7UL, 18446744073709551615UL, 0x734166DA9A16D6AEL}, {0x81308FB828C20713L, 7UL, 18446744073709551615UL, 0x734166DA9A16D6AEL}, {0x81308FB828C20713L, 7UL, 18446744073709551615UL, 0x734166DA9A16D6AEL}, {0x81308FB828C20713L, 7UL, 18446744073709551615UL, 0x734166DA9A16D6AEL}, {0x81308FB828C20713L, 7UL, 18446744073709551615UL, 0x734166DA9A16D6AEL}, {0x81308FB828C20713L, 7UL, 18446744073709551615UL, 0x734166DA9A16D6AEL}, {0x81308FB828C20713L, 7UL, 18446744073709551615UL, 0x734166DA9A16D6AEL}, {0x81308FB828C20713L, 7UL, 18446744073709551615UL, 0x734166DA9A16D6AEL}}, {{0x81308FB828C20713L, 7UL, 18446744073709551615UL, 0x734166DA9A16D6AEL}, {0x81308FB828C20713L, 7UL, 18446744073709551615UL, 0x734166DA9A16D6AEL}, {0x81308FB828C20713L, 7UL, 18446744073709551615UL, 0x734166DA9A16D6AEL}, {0x81308FB828C20713L, 7UL, 18446744073709551615UL, 0x734166DA9A16D6AEL}, {0x81308FB828C20713L, 7UL, 18446744073709551615UL, 0x734166DA9A16D6AEL}, {0x81308FB828C20713L, 7UL, 18446744073709551615UL, 0x734166DA9A16D6AEL}, {0x81308FB828C20713L, 7UL, 18446744073709551615UL, 0x734166DA9A16D6AEL}, {0x81308FB828C20713L, 7UL, 18446744073709551615UL, 0x734166DA9A16D6AEL}, {0x81308FB828C20713L, 7UL, 18446744073709551615UL, 0x734166DA9A16D6AEL}}, {{0x81308FB828C20713L, 7UL, 18446744073709551615UL, 0x734166DA9A16D6AEL}, {0x81308FB828C20713L, 7UL, 18446744073709551615UL, 0x734166DA9A16D6AEL}, {0x81308FB828C20713L, 7UL, 18446744073709551615UL, 0x734166DA9A16D6AEL}, {0x81308FB828C20713L, 7UL, 18446744073709551615UL, 0x734166DA9A16D6AEL}, {0x81308FB828C20713L, 7UL, 18446744073709551615UL, 0x734166DA9A16D6AEL}, {0x81308FB828C20713L, 7UL, 18446744073709551615UL, 0x734166DA9A16D6AEL}, {0x81308FB828C20713L, 7UL, 18446744073709551615UL, 0x734166DA9A16D6AEL}, {0x81308FB828C20713L, 7UL, 18446744073709551615UL, 0x734166DA9A16D6AEL}, {0x81308FB828C20713L, 7UL, 18446744073709551615UL, 0x734166DA9A16D6AEL}}, {{0x81308FB828C20713L, 7UL, 18446744073709551615UL, 0x734166DA9A16D6AEL}, {0x81308FB828C20713L, 7UL, 18446744073709551615UL, 0x734166DA9A16D6AEL}, {0x81308FB828C20713L, 7UL, 18446744073709551615UL, 0x734166DA9A16D6AEL}, {0x81308FB828C20713L, 7UL, 18446744073709551615UL, 0x734166DA9A16D6AEL}, {0x81308FB828C20713L, 7UL, 18446744073709551615UL, 0x734166DA9A16D6AEL}, {0x81308FB828C20713L, 7UL, 18446744073709551615UL, 0x734166DA9A16D6AEL}, {0x81308FB828C20713L, 7UL, 18446744073709551615UL, 0x734166DA9A16D6AEL}, {0x81308FB828C20713L, 7UL, 18446744073709551615UL, 0x734166DA9A16D6AEL}, {0x81308FB828C20713L, 7UL, 18446744073709551615UL, 0x734166DA9A16D6AEL}}, {{0x81308FB828C20713L, 7UL, 18446744073709551615UL, 0x734166DA9A16D6AEL}, {0x81308FB828C20713L, 7UL, 18446744073709551615UL, 0x734166DA9A16D6AEL}, {0x81308FB828C20713L, 7UL, 18446744073709551615UL, 0x734166DA9A16D6AEL}, {0x81308FB828C20713L, 7UL, 18446744073709551615UL, 0x734166DA9A16D6AEL}, {0x81308FB828C20713L, 7UL, 18446744073709551615UL, 0x734166DA9A16D6AEL}, {0x81308FB828C20713L, 7UL, 18446744073709551615UL, 0x734166DA9A16D6AEL}, {0x81308FB828C20713L, 7UL, 18446744073709551615UL, 0x734166DA9A16D6AEL}, {0x81308FB828C20713L, 7UL, 18446744073709551615UL, 0x734166DA9A16D6AEL}, {0x81308FB828C20713L, 7UL, 18446744073709551615UL, 0x734166DA9A16D6AEL}}};
  int i, j, k;
  return l_2[hook(4, 5)][hook(3, 1)][hook(2, 2)];
}

kernel void entry(global ulong* result, global int* sequence_input) {
  int;
  struct S7 c_4;
  struct S7* p_3 = &c_4;
  struct S7 c_5 = {
      sequence_input[hook(1, get_global_id(0))], sequence_input[hook(1, get_global_id(1))], sequence_input[hook(1, get_global_id(2))], sequence_input[hook(1, get_local_id(0))], sequence_input[hook(1, get_local_id(1))], sequence_input[hook(1, get_local_id(2))], sequence_input[hook(1, get_group_id(0))], sequence_input[hook(1, get_group_id(1))], sequence_input[hook(1, get_group_id(2))],
  };
  c_4 = c_5;
  barrier(0x01 | 0x02);
  func_1(p_3);
  barrier(0x01 | 0x02);
  ulong crc64_context = 0xFFFFFFFFFFFFFFFFUL;
  int print_hash_value = 0;
  result[hook(0, get_linear_global_id())] = crc64_context ^ 0xFFFFFFFFFFFFFFFFUL;
}