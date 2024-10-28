//{"(<recovery-expr>() == 0) ? 0 : 1":24,"20 + <recovery-expr>()":12,"5 + <recovery-expr>()":14,"<recovery-expr>()":4,"<recovery-expr>() + 10":8,"<recovery-expr>() + 15":9,"<recovery-expr>() + 20":10,"<recovery-expr>() + 5":7,"<recovery-expr>()[(<recovery-expr>() == 0) ? 0 : 1]":23,"<recovery-expr>(A)":6,"<recovery-expr>(nonce_pos)":5,"a[<recovery-expr>()]":15,"b[20 + <recovery-expr>()]":11,"b[5 + <recovery-expr>()]":13,"b[<recovery-expr>()]":16,"c[<recovery-expr>()]":20,"c[<recovery-expr>()][0]":19,"c[<recovery-expr>()][1]":21,"c[<recovery-expr>()][2]":22,"d[<recovery-expr>()]":18,"hashes":3,"input_data":0,"input_size":1,"nonce":2,"ro[<recovery-expr>()]":17}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant const uint64_t rc[2][24] = {{0x0000000000000001UL, 0x0000000000008082UL, 0x800000000000808AUL, 0x8000000080008000UL, 0x000000000000808BUL, 0x0000000080000001UL, 0x8000000080008081UL, 0x8000000000008009UL, 0x000000000000008AUL, 0x0000000000000088UL, 0x0000000080008009UL, 0x000000008000000AUL, 0x000000008000808BUL, 0x800000000000008BUL, 0x8000000000008089UL, 0x8000000000008003UL, 0x8000000000008002UL, 0x8000000000000080UL, 0x000000000000800AUL, 0x800000008000000AUL, 0x8000000080008081UL, 0x8000000000008080UL, 0x0000000080000001UL, 0x8000000080008008UL}, {0UL, 0UL, 0UL, 0UL, 0UL, 0UL, 0UL, 0UL, 0UL, 0UL, 0UL, 0UL, 0UL, 0UL, 0UL, 0UL, 0UL, 0UL, 0UL, 0UL, 0UL, 0UL, 0UL, 0UL}};

constant const int ro[25][2] = {{0, 64}, {44, 20}, {43, 21}, {21, 43}, {14, 50}, {1, 63}, {6, 58}, {25, 39}, {8, 56}, {18, 46}, {62, 2}, {55, 9}, {39, 25}, {41, 23}, {2, 62}, {28, 36}, {20, 44}, {3, 61}, {45, 19}, {61, 3}, {27, 37}, {36, 28}, {10, 54}, {15, 49}, {56, 8}};

constant const int a[25] = {0, 6, 12, 18, 24, 1, 7, 13, 19, 20, 2, 8, 14, 15, 21, 3, 9, 10, 16, 22, 4, 5, 11, 17, 23};

constant const int b[25] = {0, 1, 2, 3, 4, 1, 2, 3, 4, 0, 2, 3, 4, 0, 1, 3, 4, 0, 1, 2, 4, 0, 1, 2, 3};

constant const int c[25][3] = {{0, 1, 2}, {1, 2, 3}, {2, 3, 4}, {3, 4, 0}, {4, 0, 1}, {5, 6, 7}, {6, 7, 8}, {7, 8, 9}, {8, 9, 5}, {9, 5, 6}, {10, 11, 12}, {11, 12, 13}, {12, 13, 14}, {13, 14, 10}, {14, 10, 11}, {15, 16, 17}, {16, 17, 18}, {17, 18, 19}, {18, 19, 15}, {19, 15, 16}, {20, 21, 22}, {21, 22, 23}, {22, 23, 24}, {23, 24, 20}, {24, 20, 21}};

constant const int d[25] = {0, 1, 2, 3, 4, 10, 11, 12, 13, 14, 20, 21, 22, 23, 24, 5, 6, 7, 8, 9, 15, 16, 17, 18, 19};

__attribute__((reqd_work_group_size(32, 1, 1))) __attribute__((reqd_work_group_size(32, 1, 1))) kernel void sha3_initial(global const uint8_t* input_data, uint32_t input_size, uint32_t nonce, global uint64_t* hashes) {
  const uint32_t t = get_local_id(0);
  const uint32_t g = get_group_id(0);

  if (t >= 25)
    return;

  const uint32_t s = t % 5;

  global uint64_t* input = (global uint64_t*)(input_data);

  local uint64_t A[25];
  local uint64_t C[25];
  local uint64_t D[25];

  hook(4, <recovery-expr>(A))] = (t < 16) ? hook(4, <recovery-expr>())] : 0;

  local uint32_t* nonce_pos = (local uint32_t*)(A) + 9;
  nonce += g;
  nonce_pos[hook(5, 0)] = (nonce_pos[hook(4, 0)] & 0xFFFFFFU) | ((nonce & 0xFF) << 24);
  nonce_pos[hook(5, 1)] = (nonce_pos[hook(4, 1)] & 0xFF000000U) | (nonce >> 8);

  uint32_t wordIndex = input_size / sizeof(uint64_t);
  const uint32_t tail_size = input_size % sizeof(uint64_t);

  A[wordIndex] ^= (uint64_t)(((uint64_t)(0x02 | (1 << 2))) << (tail_size * 8));
  A[hook(6, 16)] ^= 0x8000000000000000UL;

  for (int i = 0; i < 24; ++i) {
    hook(4, <recovery-expr>(C))] = hook(4, <recovery-expr>())] ^ hook(7, <recovery-expr>())] ^ hook(8, <recovery-expr>())] ^ hook(9, <recovery-expr>())] ^ hook(10, <recovery-expr>())];
    hook(4, <recovery-expr>(D))] = hook(11, <recoveryhook(12, b))] ^ (((hook(13, <recovery-hook(14, b))]) << 1) | ((hook(13, <recovery-hook(14, b))]) >> 63));
    hook(4, <recovery-expr>(C))] = (((hook(15, <recovery-exprhook(4, a))] ^ hook(16, <recovery-exprhook(4, b))]) << hook(4, ro)][hook(17, 0)]) | ((hook(15, <recovery-exprhook(4, a))] ^ hook(16, <recovery-exprhook(4, b))]) >> hook(4, ro)][hook(17, 1)]));
    hook(18, <recovery-expr>hook(4, d))] = hook(19, <recovery-ehook(4, c)>(hook(20, 0))] ^ ((~hook(21, <recovery-ehook(4, c)>(hook(20, 1))]) & hook(22, <recovery-ehook(4, c)>(hook(20, 2))]);
    hook(4, <recovery-expr>(A))] ^= hook(24, <recovery-expr>())][hook(23, i)];
  }

  if (t < 4) {
    hashes += g * (32 / sizeof(uint64_t));
    hook(4, <recovery-expr>(hashes))] = hook(4, <recovery-expr>())];
  }
}