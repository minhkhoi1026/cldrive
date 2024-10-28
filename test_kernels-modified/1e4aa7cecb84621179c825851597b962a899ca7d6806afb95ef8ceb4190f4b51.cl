//{"d":4,"dst":2,"io":6,"iobuf":0,"q":7,"s":5,"scratch":1,"x":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void Salsa20(uint4* dst, const uint4* x) {
  uint4 v0 = dst[hook(2, 0)] ^ x[hook(3, 0)];
  uint4 v1 = dst[hook(2, 1)] ^ x[hook(3, 1)];
  uint4 v2 = dst[hook(2, 2)] ^ x[hook(3, 2)];
  uint4 v3 = dst[hook(2, 3)] ^ x[hook(3, 3)];

  uint4 w0 = v0;
  uint4 w1 = v1;
  uint4 w2 = v2;
  uint4 w3 = v3;

  for (int i = 0; i < 8; ++i) {
    w3 ^= rotate(w0 + w1, 7);
    w2 ^= rotate(w3 + w0, 9);
    w1 ^= rotate(w2 + w3, 13);
    w0 ^= rotate(w1 + w2, 18);

    uint4 w = w1;
    w1 = w3.s3012;
    w2 = w2.s2301;
    w3 = w.s1230;
  }

  dst[hook(2, 0)] = v0 + w0;
  dst[hook(2, 1)] = v1 + w1;
  dst[hook(2, 2)] = v2 + w2;
  dst[hook(2, 3)] = v3 + w3;
}

void DoubleSalsa20(uint4 x[8]) {
  Salsa20(x, x + 4);
  Salsa20(x + 4, x);
}

void memcpyToGlobal8(global uint4* d, const uint4* s) {
  for (int i = 0; i < 8; ++i)
    d[hook(4, i)] = s[hook(5, i)];
}

kernel void ScryptCore(global uint16* iobuf, global uint16* scratch) {
  unsigned int id = get_global_id(0);
  unsigned int lid = get_local_id(0);
  global uint4* io = (global uint4*)(iobuf + id * 2);
  global uint4* p = (global uint4*)(scratch + id * 1024 * 2);

  uint4 x[8];
  for (int i = 0; i < 8; ++i)
    x[hook(3, i)] = io[hook(6, i)];

  global uint4* pp = p;
  for (int i = 0; i < 1024; ++i, pp += 8) {
    memcpyToGlobal8(pp, x);
    DoubleSalsa20(x);
  }
  for (int i = 0; i < 1024; ++i) {
    global uint4* q = p + (x[hook(3, 4)].s0 & 1023) * 8;
    for (int i = 0; i < 8; ++i)
      x[hook(3, i)] ^= q[hook(7, i)];
    DoubleSalsa20(x);
  }

  memcpyToGlobal8(io, x);
}