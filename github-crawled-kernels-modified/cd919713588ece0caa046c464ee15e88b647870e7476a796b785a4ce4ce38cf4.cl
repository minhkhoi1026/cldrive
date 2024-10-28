//{"g_atomic_input":1,"g_special_values":2,"l_11":10,"l_21":16,"l_21[0]":18,"l_21[0][2]":17,"l_21[i]":15,"l_21[i][j]":14,"l_23":13,"l_3":9,"l_7":7,"l_7[1]":6,"l_7[1][3]":5,"l_7[l_7[1][3][2]]":12,"l_7[l_7[1][3][2]][(l_4 + 1)]":11,"l_9":8,"p_27->g_26":20,"p_27->g_atomic_input":4,"p_27->g_special_values":19,"result":0,"sequence_input":3}
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
  char f1;
  long f2;
};

struct S1 {
  unsigned int g_26[5];
  ulong global_0_offset;
  ulong global_1_offset;
  ulong global_2_offset;
  ulong local_0_offset;
  ulong local_1_offset;
  ulong local_2_offset;
  ulong group_0_offset;
  ulong group_1_offset;
  ulong group_2_offset;
  global volatile unsigned int* g_atomic_input;
  global volatile unsigned int* g_special_values;
};

unsigned int func_1(struct S1* p_27);
unsigned int func_1(struct S1* p_27) {
  char l_3[5] = {6L, 6L, 6L, 6L, 6L};
  int i;
  if ((atomic_inc(&p_27->g_atomic_input[hook(4, 72 * get_linear_group_id() + 10)]) == 0)) {
    ushort l_2 = 0x0FE1L;
    if (l_2) {
      int l_4 = (-8L);
      for (l_4 = 4; (l_4 >= 0); l_4 -= 1) {
        int* l_5 = (void*)0;
        int l_7[2][9][4] = {{{(-1L), 5L, 0x193C1DE6L, 0x7E44142BL}, {(-1L), 5L, 0x193C1DE6L, 0x7E44142BL}, {(-1L), 5L, 0x193C1DE6L, 0x7E44142BL}, {(-1L), 5L, 0x193C1DE6L, 0x7E44142BL}, {(-1L), 5L, 0x193C1DE6L, 0x7E44142BL}, {(-1L), 5L, 0x193C1DE6L, 0x7E44142BL}, {(-1L), 5L, 0x193C1DE6L, 0x7E44142BL}, {(-1L), 5L, 0x193C1DE6L, 0x7E44142BL}, {(-1L), 5L, 0x193C1DE6L, 0x7E44142BL}}, {{(-1L), 5L, 0x193C1DE6L, 0x7E44142BL}, {(-1L), 5L, 0x193C1DE6L, 0x7E44142BL}, {(-1L), 5L, 0x193C1DE6L, 0x7E44142BL}, {(-1L), 5L, 0x193C1DE6L, 0x7E44142BL}, {(-1L), 5L, 0x193C1DE6L, 0x7E44142BL}, {(-1L), 5L, 0x193C1DE6L, 0x7E44142BL}, {(-1L), 5L, 0x193C1DE6L, 0x7E44142BL}, {(-1L), 5L, 0x193C1DE6L, 0x7E44142BL}, {(-1L), 5L, 0x193C1DE6L, 0x7E44142BL}}};
        int* l_6 = &l_7[hook(7, 1)][hook(6, 3)][hook(5, 2)];
        int i, j, k;
        l_6 = (l_5 = (void*)0);
        for (l_7[hook(7, 1)][hook(6, 3)][hook(5, 2)] = 0; (l_7[hook(7, 1)][hook(6, 3)][hook(5, 2)] <= 1); l_7[hook(7, 1)][hook(6, 3)][hook(5, 2)] += 1) {
          long l_8 = 4L;
          unsigned int l_9[4] = {2UL, 2UL, 2UL, 2UL};
          int i;
          l_9[hook(8, 0)] |= (l_8 = l_3[hook(9, (l_7[1hook(7, 1)[3hook(6, 3)[2hook(5, 2) + 1))]);
          for (l_8 = 0; (l_8 <= 4); l_8 += 1) {
            int l_10 = 0x67AB6CE1L;
            ulong l_11[6];
            int l_12 = 0x1C90E69CL;
            uchar l_13 = 0x3CL;
            struct S0 l_14 = {0x44184EB3L, 0x0AL, 0L};
            struct S0 l_15 = {0x4E10B49FL, 0x37L, 0x26243A5D8D34108FL};
            int i, j, k;
            for (i = 0; i < 6; i++)
              l_11[hook(10, i)] = 1UL;
            l_13 ^= ((l_12 = (l_7[hook(7, l_7[1hook(7, 1)[3hook(6, 3)[2hook(5, 2))][hook(12, (l_4 + 1))][hook(11, (l_7[1hook(7, 1)[3hook(6, 3)[2hook(5, 2) + 1))], (l_11[hook(10, 5)] = l_10))), 0x1532955FL);
            l_15 = l_14;
          }
        }
        for (l_7[hook(7, 1)][hook(6, 3)][hook(5, 2)] = 0; (l_7[hook(7, 1)][hook(6, 3)][hook(5, 2)] <= 4); l_7[hook(7, 1)][hook(6, 3)][hook(5, 2)] += 1) {
          char l_16 = (-2L);
          unsigned int l_17 = 4294967295UL;
          int** l_20 = (void*)0;
          int l_23[4];
          int* l_22 = &l_23[hook(13, 1)];
          int** l_21[3][3][2];
          int i, j, k;
          for (i = 0; i < 4; i++)
            l_23[hook(13, i)] = 0x4628AEA3L;
          for (i = 0; i < 3; i++) {
            for (j = 0; j < 3; j++) {
              for (k = 0; k < 2; k++)
                l_21[hook(16, i)][hook(15, j)][hook(14, k)] = &l_22;
            }
          }
          l_17++;
          l_6 = (void*)0;
          l_21[hook(16, 0)][hook(18, 2)][hook(17, 1)] = (l_20 = l_20);
        }
      }
    } else {
      int l_24 = 1L;
      int l_25 = (-1L);
      l_25 ^= l_24;
    }
    unsigned int result = 0;
    result += l_2;
    atomic_add(&p_27->g_special_values[hook(19, 72 * get_linear_group_id() + 10)], result);
  } else {
    (1 + 1);
  }
  return p_27->g_26[hook(20, 0)];
}

kernel void entry(global ulong* result, global volatile unsigned int* g_atomic_input, global volatile unsigned int* g_special_values, global int* sequence_input) {
  int i;
  struct S1 c_28;
  struct S1* p_27 = &c_28;
  struct S1 c_29 = {
      {8UL, 8UL, 8UL, 8UL, 8UL}, sequence_input[hook(3, get_global_id(0))], sequence_input[hook(3, get_global_id(1))], sequence_input[hook(3, get_global_id(2))], sequence_input[hook(3, get_local_id(0))], sequence_input[hook(3, get_local_id(1))], sequence_input[hook(3, get_local_id(2))], sequence_input[hook(3, get_group_id(0))], sequence_input[hook(3, get_group_id(1))], sequence_input[hook(3, get_group_id(2))], g_atomic_input, g_special_values,
  };
  c_28 = c_29;
  barrier(0x01 | 0x02);
  func_1(p_27);
  barrier(0x01 | 0x02);
  ulong crc64_context = 0xFFFFFFFFFFFFFFFFUL;
  int print_hash_value = 0;
  for (i = 0; i < 5; i++) {
    transparent_crc_no_string(&crc64_context, p_27->g_26[hook(20, i)]);
  }
  barrier(0x01 | 0x02);
  if (!get_linear_global_id())
    for (i = 0; i < 72; i++)
      transparent_crc_no_string(&crc64_context, p_27->g_special_values[hook(19, i + 72 * get_linear_group_id())]);
  result[hook(0, get_linear_global_id())] = crc64_context ^ 0xFFFFFFFFFFFFFFFFUL;
}