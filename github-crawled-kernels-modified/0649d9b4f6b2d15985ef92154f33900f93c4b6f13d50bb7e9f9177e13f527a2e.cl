//{"hashOut":1,"hi":2,"initialState":5,"initialState[8 + i]":6,"initialState[i]":4,"input":0,"lo":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
unsigned int LE_UINT_LOAD(unsigned int v) {
  return __builtin_astype((__builtin_astype((v), uchar4).wzyx), unsigned int);
}

constant unsigned int initialState[16][2] = {{0x2AEA2A61u, 0x50F494D4u}, {0x2D538B8Bu, 0x4167D83Eu}, {0x3FEE2313u, 0xC701CF8Cu}, {0xCC39968Eu, 0x50AC5695u}, {0x4D42C787u, 0xA647A8B3u}, {0x97CF0BEFu, 0x825B4537u}, {0xEEF864D2u, 0xF22090C4u}, {0xD0E5CD33u, 0xA23911AEu}, {0xFCD398D9u, 0x148FE485u}, {0x1B017BEFu, 0xB6444532u}, {0x6A536159u, 0x2FF5781Cu}, {0x91FA7934u, 0x0DBADEA9u}, {0xD65C8A2Bu, 0xA5A70E75u}, {0xB1C62456u, 0xBC796576u}, {0x1921C8F7u, 0xE7989AF1u}, {0x7795D246u, 0xD43E3B44u}};

void CubeHash_2W_EvnRound(unsigned int* lo, local unsigned int* hi) {
  hi[hook(2, 0 * 32)] += lo[hook(3, 0)];
  hi[hook(2, 1 * 32)] += lo[hook(3, 1)];
  hi[hook(2, 2 * 32)] += lo[hook(3, 2)];
  hi[hook(2, 3 * 32)] += lo[hook(3, 3)];
  hi[hook(2, 4 * 32)] += lo[hook(3, 4)];
  hi[hook(2, 5 * 32)] += lo[hook(3, 5)];
  hi[hook(2, 6 * 32)] += lo[hook(3, 6)];
  hi[hook(2, 7 * 32)] += lo[hook(3, 7)];
  lo[hook(3, 0)] = rotate(lo[hook(3, 0)], 7u);
  lo[hook(3, 1)] = rotate(lo[hook(3, 1)], 7u);
  lo[hook(3, 2)] = rotate(lo[hook(3, 2)], 7u);
  lo[hook(3, 3)] = rotate(lo[hook(3, 3)], 7u);
  lo[hook(3, 4)] = rotate(lo[hook(3, 4)], 7u);
  lo[hook(3, 5)] = rotate(lo[hook(3, 5)], 7u);
  lo[hook(3, 6)] = rotate(lo[hook(3, 6)], 7u);
  lo[hook(3, 7)] = rotate(lo[hook(3, 7)], 7u);
  lo[hook(3, 4)] ^= hi[hook(2, (0 + 0) * 32)];
  lo[hook(3, 5)] ^= hi[hook(2, (1 + 0) * 32)];
  lo[hook(3, 6)] ^= hi[hook(2, (2 + 0) * 32)];
  lo[hook(3, 7)] ^= hi[hook(2, (3 + 0) * 32)];
  lo[hook(3, 0)] ^= hi[hook(2, (0 + 4) * 32)];
  lo[hook(3, 1)] ^= hi[hook(2, (1 + 4) * 32)];
  lo[hook(3, 2)] ^= hi[hook(2, (2 + 4) * 32)];
  lo[hook(3, 3)] ^= hi[hook(2, (3 + 4) * 32)];
  hi[hook(2, 1 * 32)] += lo[hook(3, 4)];
  hi[hook(2, 0 * 32)] += lo[hook(3, 5)];
  hi[hook(2, 3 * 32)] += lo[hook(3, 6)];
  hi[hook(2, 2 * 32)] += lo[hook(3, 7)];
  hi[hook(2, 5 * 32)] += lo[hook(3, 0)];
  hi[hook(2, 4 * 32)] += lo[hook(3, 1)];
  hi[hook(2, 7 * 32)] += lo[hook(3, 2)];
  hi[hook(2, 6 * 32)] += lo[hook(3, 3)];
  lo[hook(3, 0)] = rotate(lo[hook(3, 0)], 11u);
  lo[hook(3, 1)] = rotate(lo[hook(3, 1)], 11u);
  lo[hook(3, 2)] = rotate(lo[hook(3, 2)], 11u);
  lo[hook(3, 3)] = rotate(lo[hook(3, 3)], 11u);
  lo[hook(3, 4)] = rotate(lo[hook(3, 4)], 11u);
  lo[hook(3, 5)] = rotate(lo[hook(3, 5)], 11u);
  lo[hook(3, 6)] = rotate(lo[hook(3, 6)], 11u);
  lo[hook(3, 7)] = rotate(lo[hook(3, 7)], 11u);
  lo[hook(3, 0)] ^= hi[hook(2, 7 * 32)];
  lo[hook(3, 1)] ^= hi[hook(2, 6 * 32)];
  lo[hook(3, 2)] ^= hi[hook(2, 5 * 32)];
  lo[hook(3, 3)] ^= hi[hook(2, 4 * 32)];
  lo[hook(3, 4)] ^= hi[hook(2, 3 * 32)];
  lo[hook(3, 5)] ^= hi[hook(2, 2 * 32)];
  lo[hook(3, 6)] ^= hi[hook(2, 1 * 32)];
  lo[hook(3, 7)] ^= hi[hook(2, 0 * 32)];
}

void CubeHash_2W_OddRound(unsigned int* lo, local unsigned int* hi) {
  hi = hi + (get_local_id(0) == 0 ? 1 : -1);

  hi[hook(2, 1 * 32)] += lo[hook(3, 6)];
  hi[hook(2, 0 * 32)] += lo[hook(3, 7)];
  hi[hook(2, 3 * 32)] += lo[hook(3, 4)];
  hi[hook(2, 2 * 32)] += lo[hook(3, 5)];
  hi[hook(2, 5 * 32)] += lo[hook(3, 2)];
  hi[hook(2, 4 * 32)] += lo[hook(3, 3)];
  hi[hook(2, 7 * 32)] += lo[hook(3, 0)];
  hi[hook(2, 6 * 32)] += lo[hook(3, 1)];
  lo[hook(3, 0)] = rotate(lo[hook(3, 0)], 7u);
  lo[hook(3, 1)] = rotate(lo[hook(3, 1)], 7u);
  lo[hook(3, 2)] = rotate(lo[hook(3, 2)], 7u);
  lo[hook(3, 3)] = rotate(lo[hook(3, 3)], 7u);
  lo[hook(3, 4)] = rotate(lo[hook(3, 4)], 7u);
  lo[hook(3, 5)] = rotate(lo[hook(3, 5)], 7u);
  lo[hook(3, 6)] = rotate(lo[hook(3, 6)], 7u);
  lo[hook(3, 7)] = rotate(lo[hook(3, 7)], 7u);
  lo[hook(3, 0)] ^= hi[hook(2, (0 + 3) * 32)];
  lo[hook(3, 1)] ^= hi[hook(2, (0 + 2) * 32)];
  lo[hook(3, 2)] ^= hi[hook(2, (0 + 1) * 32)];
  lo[hook(3, 3)] ^= hi[hook(2, (0 + 0) * 32)];
  lo[hook(3, 4)] ^= hi[hook(2, (4 + 3) * 32)];
  lo[hook(3, 5)] ^= hi[hook(2, (4 + 2) * 32)];
  lo[hook(3, 6)] ^= hi[hook(2, (4 + 1) * 32)];
  lo[hook(3, 7)] ^= hi[hook(2, (4 + 0) * 32)];
  hi[hook(2, 0 * 32)] += lo[hook(3, 2)];
  hi[hook(2, 1 * 32)] += lo[hook(3, 3)];
  hi[hook(2, 2 * 32)] += lo[hook(3, 0)];
  hi[hook(2, 3 * 32)] += lo[hook(3, 1)];
  hi[hook(2, 4 * 32)] += lo[hook(3, 6)];
  hi[hook(2, 5 * 32)] += lo[hook(3, 7)];
  hi[hook(2, 6 * 32)] += lo[hook(3, 4)];
  hi[hook(2, 7 * 32)] += lo[hook(3, 5)];
  lo[hook(3, 0)] = rotate(lo[hook(3, 0)], 11u);
  lo[hook(3, 1)] = rotate(lo[hook(3, 1)], 11u);
  lo[hook(3, 2)] = rotate(lo[hook(3, 2)], 11u);
  lo[hook(3, 3)] = rotate(lo[hook(3, 3)], 11u);
  lo[hook(3, 4)] = rotate(lo[hook(3, 4)], 11u);
  lo[hook(3, 5)] = rotate(lo[hook(3, 5)], 11u);
  lo[hook(3, 6)] = rotate(lo[hook(3, 6)], 11u);
  lo[hook(3, 7)] = rotate(lo[hook(3, 7)], 11u);
  lo[hook(3, 0)] ^= hi[hook(2, 0 * 32)];
  lo[hook(3, 1)] ^= hi[hook(2, 1 * 32)];
  lo[hook(3, 2)] ^= hi[hook(2, 2 * 32)];
  lo[hook(3, 3)] ^= hi[hook(2, 3 * 32)];
  lo[hook(3, 4)] ^= hi[hook(2, 4 * 32)];
  lo[hook(3, 5)] ^= hi[hook(2, 5 * 32)];
  lo[hook(3, 6)] ^= hi[hook(2, 6 * 32)];
  lo[hook(3, 7)] ^= hi[hook(2, 7 * 32)];
}

void CubeHash_2W_Pass(unsigned int* lo, local unsigned int* hi) {
  for (int j = 0; j < 8; j++) {
    CubeHash_2W_EvnRound(lo, hi);
    CubeHash_2W_OddRound(lo, hi);
  }
}

__attribute__((reqd_work_group_size(2, 32, 1))) kernel void CubeHash_2way(global unsigned int* input, global unsigned int* hashOut) {
  unsigned int lo[8];
  for (unsigned int i = 0; i < 8; i++)
    lo[hook(3, i)] = initialState[hook(5, i)][hook(4, get_local_id(0))];
  local unsigned int lds[8 * 2 * 32];
  local unsigned int* hi = lds + get_local_id(0) + (get_local_id(1) % 16) * 2;
  hi += get_local_id(1) >= 16 ? 8 * 2 * 16 : 0;
  for (unsigned int i = 0; i < 8; i++)
    hi[hook(2, i * 32)] = initialState[hook(5, 8 + i)][hook(6, get_local_id(0))];
  input += (get_global_id(1) - get_global_offset(1)) * 16;
  hashOut += (get_global_id(1) - get_global_offset(1)) * 16 + get_local_id(0);

  lo[hook(3, 0)] ^= LE_UINT_LOAD(input[hook(0, 1 - get_local_id(0))]);
  lo[hook(3, 1)] ^= LE_UINT_LOAD(input[hook(0, 3 - get_local_id(0))]);
  lo[hook(3, 2)] ^= LE_UINT_LOAD(input[hook(0, 5 - get_local_id(0))]);
  lo[hook(3, 3)] ^= LE_UINT_LOAD(input[hook(0, 7 - get_local_id(0))]);

  for (unsigned int pass = 0; pass < 13; pass++) {
    CubeHash_2W_Pass(lo, hi);
    switch (pass) {
      case 0:
        lo[hook(3, 0)] ^= LE_UINT_LOAD(input[hook(0, 9 - get_local_id(0))]);
        lo[hook(3, 1)] ^= LE_UINT_LOAD(input[hook(0, 11 - get_local_id(0))]);
        lo[hook(3, 2)] ^= LE_UINT_LOAD(input[hook(0, 13 - get_local_id(0))]);
        lo[hook(3, 3)] ^= LE_UINT_LOAD(input[hook(0, 15 - get_local_id(0))]);
        break;
      case 1:
        if (get_local_id(0) == 0)
          lo[hook(3, 0)] ^= 0x00000080;
        break;
      case 2:
        if (get_local_id(0) == 1)
          hi[hook(2, 7 * 32)] ^= 0x00000001;
        break;
    }
  }

  hashOut[hook(1, 2 * 0)] = lo[hook(3, 0)];
  hashOut[hook(1, 2 * 1)] = lo[hook(3, 1)];
  hashOut[hook(1, 2 * 2)] = lo[hook(3, 2)];
  hashOut[hook(1, 2 * 3)] = lo[hook(3, 3)];
  hashOut[hook(1, 2 * 4)] = lo[hook(3, 4)];
  hashOut[hook(1, 2 * 5)] = lo[hook(3, 5)];
  hashOut[hook(1, 2 * 6)] = lo[hook(3, 6)];
  hashOut[hook(1, 2 * 7)] = lo[hook(3, 7)];
}