//{"KeccakF1600_RoundConstant":7,"hash":0,"output":1,"outputHash":9,"s":5,"startNonce":2,"state":8,"t":4,"target":3,"u":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant const int ROT1024[8][8] = {{55, 43, 37, 40, 16, 22, 38, 12}, {25, 25, 46, 13, 14, 13, 52, 57}, {33, 8, 18, 57, 21, 12, 32, 54}, {34, 43, 25, 60, 44, 9, 59, 34}, {28, 7, 47, 48, 51, 9, 35, 41}, {17, 6, 18, 25, 43, 42, 40, 15}, {58, 7, 32, 45, 19, 18, 2, 56}, {47, 49, 27, 58, 37, 48, 53, 56}};
constant const ulong t12[9] = {0x80, 0x7000000000000000, 0x7000000000000080, 0xd8, 0xb000000000000000, 0xb0000000000000d8, 0x08, 0xff00000000000000, 0xff00000000000008};
constant const ulong KeccakF1600_RoundConstant[24] = {0x0000000000000001ull, 0x0000000000008082ull, 0x800000000000808aull, 0x8000000080008000ull, 0x000000000000808bull, 0x0000000080000001ull, 0x8000000080008081ull, 0x8000000000008009ull, 0x000000000000008aull, 0x0000000000000088ull, 0x0000000080008009ull, 0x000000008000000aull, 0x000000008000808bull, 0x800000000000008bull, 0x8000000000008089ull, 0x8000000000008003ull, 0x8000000000008002ull, 0x8000000000000080ull, 0x000000000000800aull, 0x800000008000000aull, 0x8000000080008081ull, 0x8000000000008080ull, 0x0000000080000001ull, 0x8000000080008008ull};
inline void keccak_block(ulong* s) {
  size_t i;
  ulong t[5], u[5], v, w;

  for (i = 0; i < 24; i++) {
    t[hook(4, 0)] = s[hook(5, 0)] ^ s[hook(5, 5)] ^ s[hook(5, 10)] ^ s[hook(5, 15)] ^ s[hook(5, 20)];
    t[hook(4, 1)] = s[hook(5, 1)] ^ s[hook(5, 6)] ^ s[hook(5, 11)] ^ s[hook(5, 16)] ^ s[hook(5, 21)];
    t[hook(4, 2)] = s[hook(5, 2)] ^ s[hook(5, 7)] ^ s[hook(5, 12)] ^ s[hook(5, 17)] ^ s[hook(5, 22)];
    t[hook(4, 3)] = s[hook(5, 3)] ^ s[hook(5, 8)] ^ s[hook(5, 13)] ^ s[hook(5, 18)] ^ s[hook(5, 23)];
    t[hook(4, 4)] = s[hook(5, 4)] ^ s[hook(5, 9)] ^ s[hook(5, 14)] ^ s[hook(5, 19)] ^ s[hook(5, 24)];

    u[hook(6, 0)] = t[hook(4, 4)] ^ (((t[hook(4, 1)]) << (1)) | ((t[hook(4, 1)]) >> (64 - (1))));
    u[hook(6, 1)] = t[hook(4, 0)] ^ (((t[hook(4, 2)]) << (1)) | ((t[hook(4, 2)]) >> (64 - (1))));
    u[hook(6, 2)] = t[hook(4, 1)] ^ (((t[hook(4, 3)]) << (1)) | ((t[hook(4, 3)]) >> (64 - (1))));
    u[hook(6, 3)] = t[hook(4, 2)] ^ (((t[hook(4, 4)]) << (1)) | ((t[hook(4, 4)]) >> (64 - (1))));
    u[hook(6, 4)] = t[hook(4, 3)] ^ (((t[hook(4, 0)]) << (1)) | ((t[hook(4, 0)]) >> (64 - (1))));

    s[hook(5, 0)] ^= u[hook(6, 0)];
    s[hook(5, 5)] ^= u[hook(6, 0)];
    s[hook(5, 10)] ^= u[hook(6, 0)];
    s[hook(5, 15)] ^= u[hook(6, 0)];
    s[hook(5, 20)] ^= u[hook(6, 0)];
    s[hook(5, 1)] ^= u[hook(6, 1)];
    s[hook(5, 6)] ^= u[hook(6, 1)];
    s[hook(5, 11)] ^= u[hook(6, 1)];
    s[hook(5, 16)] ^= u[hook(6, 1)];
    s[hook(5, 21)] ^= u[hook(6, 1)];
    s[hook(5, 2)] ^= u[hook(6, 2)];
    s[hook(5, 7)] ^= u[hook(6, 2)];
    s[hook(5, 12)] ^= u[hook(6, 2)];
    s[hook(5, 17)] ^= u[hook(6, 2)];
    s[hook(5, 22)] ^= u[hook(6, 2)];
    s[hook(5, 3)] ^= u[hook(6, 3)];
    s[hook(5, 8)] ^= u[hook(6, 3)];
    s[hook(5, 13)] ^= u[hook(6, 3)];
    s[hook(5, 18)] ^= u[hook(6, 3)];
    s[hook(5, 23)] ^= u[hook(6, 3)];
    s[hook(5, 4)] ^= u[hook(6, 4)];
    s[hook(5, 9)] ^= u[hook(6, 4)];
    s[hook(5, 14)] ^= u[hook(6, 4)];
    s[hook(5, 19)] ^= u[hook(6, 4)];
    s[hook(5, 24)] ^= u[hook(6, 4)];

    v = s[hook(5, 1)];
    s[hook(5, 1)] = (((s[hook(5, 6)]) << (44)) | ((s[hook(5, 6)]) >> (64 - (44))));
    s[hook(5, 6)] = (((s[hook(5, 9)]) << (20)) | ((s[hook(5, 9)]) >> (64 - (20))));
    s[hook(5, 9)] = (((s[hook(5, 22)]) << (61)) | ((s[hook(5, 22)]) >> (64 - (61))));
    s[hook(5, 22)] = (((s[hook(5, 14)]) << (39)) | ((s[hook(5, 14)]) >> (64 - (39))));
    s[hook(5, 14)] = (((s[hook(5, 20)]) << (18)) | ((s[hook(5, 20)]) >> (64 - (18))));
    s[hook(5, 20)] = (((s[hook(5, 2)]) << (62)) | ((s[hook(5, 2)]) >> (64 - (62))));
    s[hook(5, 2)] = (((s[hook(5, 12)]) << (43)) | ((s[hook(5, 12)]) >> (64 - (43))));
    s[hook(5, 12)] = (((s[hook(5, 13)]) << (25)) | ((s[hook(5, 13)]) >> (64 - (25))));
    s[hook(5, 13)] = (((s[hook(5, 19)]) << (8)) | ((s[hook(5, 19)]) >> (64 - (8))));
    s[hook(5, 19)] = (((s[hook(5, 23)]) << (56)) | ((s[hook(5, 23)]) >> (64 - (56))));
    s[hook(5, 23)] = (((s[hook(5, 15)]) << (41)) | ((s[hook(5, 15)]) >> (64 - (41))));
    s[hook(5, 15)] = (((s[hook(5, 4)]) << (27)) | ((s[hook(5, 4)]) >> (64 - (27))));
    s[hook(5, 4)] = (((s[hook(5, 24)]) << (14)) | ((s[hook(5, 24)]) >> (64 - (14))));
    s[hook(5, 24)] = (((s[hook(5, 21)]) << (2)) | ((s[hook(5, 21)]) >> (64 - (2))));
    s[hook(5, 21)] = (((s[hook(5, 8)]) << (55)) | ((s[hook(5, 8)]) >> (64 - (55))));
    s[hook(5, 8)] = (((s[hook(5, 16)]) << (45)) | ((s[hook(5, 16)]) >> (64 - (45))));
    s[hook(5, 16)] = (((s[hook(5, 5)]) << (36)) | ((s[hook(5, 5)]) >> (64 - (36))));
    s[hook(5, 5)] = (((s[hook(5, 3)]) << (28)) | ((s[hook(5, 3)]) >> (64 - (28))));
    s[hook(5, 3)] = (((s[hook(5, 18)]) << (21)) | ((s[hook(5, 18)]) >> (64 - (21))));
    s[hook(5, 18)] = (((s[hook(5, 17)]) << (15)) | ((s[hook(5, 17)]) >> (64 - (15))));
    s[hook(5, 17)] = (((s[hook(5, 11)]) << (10)) | ((s[hook(5, 11)]) >> (64 - (10))));
    s[hook(5, 11)] = (((s[hook(5, 7)]) << (6)) | ((s[hook(5, 7)]) >> (64 - (6))));
    s[hook(5, 7)] = (((s[hook(5, 10)]) << (3)) | ((s[hook(5, 10)]) >> (64 - (3))));
    s[hook(5, 10)] = (((v) << (1)) | ((v) >> (64 - (1))));

    v = s[hook(5, 0)];
    w = s[hook(5, 1)];
    s[hook(5, 0)] ^= (~w) & s[hook(5, 2)];
    s[hook(5, 1)] ^= (~s[hook(5, 2)]) & s[hook(5, 3)];
    s[hook(5, 2)] ^= (~s[hook(5, 3)]) & s[hook(5, 4)];
    s[hook(5, 3)] ^= (~s[hook(5, 4)]) & v;
    s[hook(5, 4)] ^= (~v) & w;
    v = s[hook(5, 5)];
    w = s[hook(5, 6)];
    s[hook(5, 5)] ^= (~w) & s[hook(5, 7)];
    s[hook(5, 6)] ^= (~s[hook(5, 7)]) & s[hook(5, 8)];
    s[hook(5, 7)] ^= (~s[hook(5, 8)]) & s[hook(5, 9)];
    s[hook(5, 8)] ^= (~s[hook(5, 9)]) & v;
    s[hook(5, 9)] ^= (~v) & w;
    v = s[hook(5, 10)];
    w = s[hook(5, 11)];
    s[hook(5, 10)] ^= (~w) & s[hook(5, 12)];
    s[hook(5, 11)] ^= (~s[hook(5, 12)]) & s[hook(5, 13)];
    s[hook(5, 12)] ^= (~s[hook(5, 13)]) & s[hook(5, 14)];
    s[hook(5, 13)] ^= (~s[hook(5, 14)]) & v;
    s[hook(5, 14)] ^= (~v) & w;
    v = s[hook(5, 15)];
    w = s[hook(5, 16)];
    s[hook(5, 15)] ^= (~w) & s[hook(5, 17)];
    s[hook(5, 16)] ^= (~s[hook(5, 17)]) & s[hook(5, 18)];
    s[hook(5, 17)] ^= (~s[hook(5, 18)]) & s[hook(5, 19)];
    s[hook(5, 18)] ^= (~s[hook(5, 19)]) & v;
    s[hook(5, 19)] ^= (~v) & w;
    v = s[hook(5, 20)];
    w = s[hook(5, 21)];
    s[hook(5, 20)] ^= (~w) & s[hook(5, 22)];
    s[hook(5, 21)] ^= (~s[hook(5, 22)]) & s[hook(5, 23)];
    s[hook(5, 22)] ^= (~s[hook(5, 23)]) & s[hook(5, 24)];
    s[hook(5, 23)] ^= (~s[hook(5, 24)]) & v;
    s[hook(5, 24)] ^= (~v) & w;

    s[hook(5, 0)] ^= KeccakF1600_RoundConstant[hook(7, i)];
  }
};

__attribute__((reqd_work_group_size(128, 1, 1)));

__attribute__((reqd_work_group_size(128, 1, 1)));
__attribute__((reqd_work_group_size(128, 1, 1))) kernel void keccakProcess(global ulong* hash, global ulong* output, ulong startNonce, constant ulong* target) {
  ulong nonce = startNonce + (ulong)get_global_id(0);
  global ulong* outputHash = &(hash[hook(0, get_global_id(0) - get_global_offset(0))]);

  ulong state[25];
  ulong comp;

  for (int i = 0; i < 9; i++) {
    state[hook(8, i)] = outputHash[hook(9, i)];
  }

  for (int i = 9; i < 25; i++) {
    state[hook(8, i)] = 0;
  }

  keccak_block(state);

  for (int i = 0; i < 7; i++) {
    state[hook(8, i)] ^= outputHash[hook(9, 9 + i)];
  }
  state[hook(8, 7)] ^= 0x05;
  state[hook(8, 8)] ^= (ulong)(1ULL << 63);

  keccak_block(state);
  keccak_block(state);

  if (state[hook(8, 6)] <= target[hook(3, 15)]) {
    output[hook(1, 0)] = nonce;
  }
}