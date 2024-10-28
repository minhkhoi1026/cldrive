//{"X":5,"buff":17,"buffer":19,"collide":6,"dst":21,"dstv":22,"dword":24,"gather":14,"indirected":25,"modifier":20,"salsa20_simd_shuffle":18,"salsa20_simd_unshuffle":16,"si":13,"slice":10,"so":12,"src":7,"swz":23,"target":8,"ubyte":11,"valB":0,"valS":2,"valV":1,"value":9,"words":15,"yescrypt_N":3,"yescrypt_r1":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant const unsigned int salsa20_simd_shuffle[64] = {0x00, 0x01, 0x02, 0x03, 0x14, 0x15, 0x16, 0x17, 0x28, 0x29, 0x2a, 0x2b, 0x3c, 0x3d, 0x3e, 0x3f, 0x10, 0x11, 0x12, 0x13, 0x24, 0x25, 0x26, 0x27, 0x38, 0x39, 0x3a, 0x3b, 0x0c, 0x0d, 0x0e, 0x0f, 0x20, 0x21, 0x22, 0x23, 0x34, 0x35, 0x36, 0x37, 0x08, 0x09, 0x0a, 0x0b, 0x1c, 0x1d, 0x1e, 0x1f, 0x30, 0x31, 0x32, 0x33, 0x04, 0x05, 0x06, 0x07, 0x18, 0x19, 0x1a, 0x1b, 0x2c, 0x2d, 0x2e, 0x2f};

constant const uchar salsa20_simd_unshuffle[64] = {0x00, 0x01, 0x02, 0x03, 0x34, 0x35, 0x36, 0x37, 0x28, 0x29, 0x2a, 0x2b, 0x1c, 0x1d, 0x1e, 0x1f, 0x10, 0x11, 0x12, 0x13, 0x04, 0x05, 0x06, 0x07, 0x38, 0x39, 0x3a, 0x3b, 0x2c, 0x2d, 0x2e, 0x2f, 0x20, 0x21, 0x22, 0x23, 0x14, 0x15, 0x16, 0x17, 0x08, 0x09, 0x0a, 0x0b, 0x3c, 0x3d, 0x3e, 0x3f, 0x30, 0x31, 0x32, 0x33, 0x24, 0x25, 0x26, 0x27, 0x18, 0x19, 0x1a, 0x1b, 0x0c, 0x0d, 0x0e, 0x0f};

unsigned int Integerify(local ulong* block, const unsigned int r) {
  const local ulong* X = block + (2 * r - 1) * 8;

  return (unsigned int)(X[hook(5, 0)]);
}

void blkxor(local ulong* block, global ulong* modifier, const unsigned int s) {
  local uchar* collide = (local uchar*)block;
  global uchar* src = (global uchar*)modifier;
  for (unsigned int loop = 0; loop < (s * sizeof(ulong)) / get_local_size(0); loop++) {
    collide[hook(6, get_local_id(0))] ^= src[hook(7, get_local_id(0))];
    collide += get_local_size(0);
    src += get_local_size(0);
  }
  barrier(0x01);
}

void blkcpy(global ulong* dst, local ulong* src, const unsigned int s) {
  local uchar* value = (local uchar*)src;
  global uchar* target = (global uchar*)dst;
  for (unsigned int loop = 0; loop < (s * sizeof(ulong)) / get_local_size(0); loop++) {
    target[hook(8, get_local_id(0))] = value[hook(9, get_local_id(0))];
    target += get_local_size(0);
    value += get_local_size(0);
  }
  barrier(0x01);
}

void Block_pwxform(local ulong* slice, global ulong* valS, local ulong* gather) {
  const size_t YESCRYPT_S_SIZE1 = 1 << 8;
  const size_t YESCRYPT_S_SIMD = 2;
  const size_t YESCRYPT_S_P = 4;
  const size_t YESCRYPT_S_ROUNDS = 6;
  const global uchar* so = (global uchar*)(valS);
  const global uchar* si = (global uchar*)(valS + YESCRYPT_S_SIZE1 * YESCRYPT_S_SIMD);
  slice += (get_local_id(0) / 16) * YESCRYPT_S_SIMD;
  gather += (get_local_id(0) / 16) * YESCRYPT_S_SIMD * 2;
  {
    ulong xo = slice[hook(10, 0)];
    ulong xi = slice[hook(10, 1)];
    for (unsigned int round = 0; round < YESCRYPT_S_ROUNDS; round++) {
      const unsigned int YESCRYPT_S_MASK = (YESCRYPT_S_SIZE1 - 1) * YESCRYPT_S_SIMD * 8;
      const ulong YESCRYPT_S_MASK2 = ((ulong)YESCRYPT_S_MASK << 32) | YESCRYPT_S_MASK;
      const ulong x = xo & YESCRYPT_S_MASK2;
      {
        const unsigned int teamwork = get_local_id(0) % 16;
        local uchar* ubyte = (local uchar*)(gather);
        ubyte[hook(11, teamwork)] = so[hook(12, (unsigned int)(x) + teamwork)];
        ubyte[hook(11, teamwork + 16)] = si[hook(13, (unsigned int)(x >> 32) + teamwork)];
      }
      xo = (ulong)(xo >> 32) * (unsigned int)xo;
      xi = (ulong)(xi >> 32) * (unsigned int)xi;
      barrier(0x01);
      xo += gather[hook(14, 0 + 0)];
      xo ^= gather[hook(14, 2 + 0)];
      xi += gather[hook(14, 0 + 1)];
      xi ^= gather[hook(14, 2 + 1)];
    }
    slice[hook(10, 0)] = xo;
    slice[hook(10, 1)] = xi;
  }
}

void Salsa20_8(local ulong slice[8]) {
  unsigned int inputValue = 0;
  local unsigned int* words = (local unsigned int*)(slice);
  if (get_local_id(0) < 16)
    inputValue = words[hook(15, get_local_id(0))];
  barrier(0x01);
  {
    local uchar* buff = (local uchar*)(slice);
    const unsigned int shuffled = salsa20_simd_unshuffle[hook(16, get_local_id(0))];
    uchar value = buff[hook(17, shuffled)];
    buff[hook(17, get_local_id(0))] = value;
  }
  barrier(0x01);
  for (unsigned int round = 0; round < 8; round += 2) {
    words[hook(15, 4)] ^= rotate(words[hook(15, 0)] + words[hook(15, 12)], 7u);
    words[hook(15, 8)] ^= rotate(words[hook(15, 4)] + words[hook(15, 0)], 9u);
    words[hook(15, 12)] ^= rotate(words[hook(15, 8)] + words[hook(15, 4)], 13u);
    words[hook(15, 0)] ^= rotate(words[hook(15, 12)] + words[hook(15, 8)], 18u);

    words[hook(15, 9)] ^= rotate(words[hook(15, 5)] + words[hook(15, 1)], 7u);
    words[hook(15, 13)] ^= rotate(words[hook(15, 9)] + words[hook(15, 5)], 9u);
    words[hook(15, 1)] ^= rotate(words[hook(15, 13)] + words[hook(15, 9)], 13u);
    words[hook(15, 5)] ^= rotate(words[hook(15, 1)] + words[hook(15, 13)], 18u);

    words[hook(15, 14)] ^= rotate(words[hook(15, 10)] + words[hook(15, 6)], 7u);
    words[hook(15, 2)] ^= rotate(words[hook(15, 14)] + words[hook(15, 10)], 9u);
    words[hook(15, 6)] ^= rotate(words[hook(15, 2)] + words[hook(15, 14)], 13u);
    words[hook(15, 10)] ^= rotate(words[hook(15, 6)] + words[hook(15, 2)], 18u);

    words[hook(15, 3)] ^= rotate(words[hook(15, 15)] + words[hook(15, 11)], 7u);
    words[hook(15, 7)] ^= rotate(words[hook(15, 3)] + words[hook(15, 15)], 9u);
    words[hook(15, 11)] ^= rotate(words[hook(15, 7)] + words[hook(15, 3)], 13u);
    words[hook(15, 15)] ^= rotate(words[hook(15, 11)] + words[hook(15, 7)], 18u);

    words[hook(15, 1)] ^= rotate(words[hook(15, 0)] + words[hook(15, 3)], 7u);
    words[hook(15, 2)] ^= rotate(words[hook(15, 1)] + words[hook(15, 0)], 9u);
    words[hook(15, 3)] ^= rotate(words[hook(15, 2)] + words[hook(15, 1)], 13u);
    words[hook(15, 0)] ^= rotate(words[hook(15, 3)] + words[hook(15, 2)], 18u);

    words[hook(15, 6)] ^= rotate(words[hook(15, 5)] + words[hook(15, 4)], 7u);
    words[hook(15, 7)] ^= rotate(words[hook(15, 6)] + words[hook(15, 5)], 9u);
    words[hook(15, 4)] ^= rotate(words[hook(15, 7)] + words[hook(15, 6)], 13u);
    words[hook(15, 5)] ^= rotate(words[hook(15, 4)] + words[hook(15, 7)], 18u);

    words[hook(15, 11)] ^= rotate(words[hook(15, 10)] + words[hook(15, 9)], 7u);
    words[hook(15, 8)] ^= rotate(words[hook(15, 11)] + words[hook(15, 10)], 9u);
    words[hook(15, 9)] ^= rotate(words[hook(15, 8)] + words[hook(15, 11)], 13u);
    words[hook(15, 10)] ^= rotate(words[hook(15, 9)] + words[hook(15, 8)], 18u);

    words[hook(15, 12)] ^= rotate(words[hook(15, 15)] + words[hook(15, 14)], 7u);
    words[hook(15, 13)] ^= rotate(words[hook(15, 12)] + words[hook(15, 15)], 9u);
    words[hook(15, 14)] ^= rotate(words[hook(15, 13)] + words[hook(15, 12)], 13u);
    words[hook(15, 15)] ^= rotate(words[hook(15, 14)] + words[hook(15, 13)], 18u);
  }
  {
    local uchar* buffer = (local uchar*)(slice);
    const unsigned int shuffled = salsa20_simd_shuffle[hook(18, get_local_id(0))];
    uchar value = buffer[hook(19, shuffled)];
    buffer[hook(19, get_local_id(0))] = value;
  }
  if (get_local_id(0) < 16)
    words[hook(15, get_local_id(0))] += inputValue;
  barrier(0x01);
}

void Blockmix_pwxform(local ulong* block, global ulong* valS, local ulong* gather, const unsigned int yescrypt_r1) {
  const size_t YESCRYPT_S_P_SIZE = 8;

  {
    local unsigned int* slice = (local unsigned int*)(block);
    local unsigned int* modifier = (local unsigned int*)(block + (yescrypt_r1 - 1) * YESCRYPT_S_P_SIZE);
    for (unsigned int loop = get_local_id(0); loop < YESCRYPT_S_P_SIZE * 2; loop += get_local_size(0)) {
      slice[hook(10, loop)] ^= modifier[hook(20, loop)];
    }
  }
  barrier(0x01);
  Block_pwxform(block, valS, gather);
  for (unsigned int loop = 1; loop < yescrypt_r1; loop++) {
    {
      local unsigned int* slice = (local unsigned int*)(block + loop * YESCRYPT_S_P_SIZE);
      local unsigned int* modifier = (local unsigned int*)(block + (loop - 1) * YESCRYPT_S_P_SIZE);
      for (unsigned int loop = get_local_id(0); loop < YESCRYPT_S_P_SIZE * 2; loop += get_local_size(0)) {
        slice[hook(10, loop)] ^= modifier[hook(20, loop)];
      }
      barrier(0x01);
    }
    Block_pwxform(block + loop * YESCRYPT_S_P_SIZE, valS, gather);
  }
  const unsigned int i = (yescrypt_r1 - 1) * YESCRYPT_S_P_SIZE / 8;
  Salsa20_8(block + i * 8);
}

__attribute__((reqd_work_group_size(64, 1, 1))) kernel void SecondSmix1(global ulong* valB, global ulong* valV, global ulong* valS, const unsigned int yescrypt_N, const unsigned int yescrypt_r1) {
  const size_t slot = get_global_id(1) - get_global_offset(1);
  valV += slot * ((1024 * 1024 * 2) / sizeof(ulong));
  valS += slot * (2 * 256 * 2);
  valB += slot * (1024 / sizeof(ulong));
  local ulong block[16 * 8];
  {
    global uchar* src = (global uchar*)(valB);
    global uchar* dstv = (global uchar*)(valV);
    local uchar* dst = (local uchar*)block;
    const unsigned int shuffled = salsa20_simd_shuffle[hook(18, get_local_id(0))];
    const unsigned int byteOrder = (get_local_id(0) / 4) * 4 + 3 - get_local_id(0) % 4;
    for (unsigned int i = 0; i < 2 * 8; i++) {
      const uchar value = src[hook(7, shuffled)];
      dst[hook(21, get_local_id(0))] = value;
      dstv[hook(22, byteOrder)] = value;
      src += 8 * 8;
      dst += 8 * 8;
      dstv += 8 * 8;
    }
    barrier(0x01);
    local unsigned int* swz = (local unsigned int*)block;
    for (unsigned int i = get_local_id(0); i < 16 * 8 * 2; i += get_local_size(0)) {
      const unsigned int value = swz[hook(23, i)];
      swz[hook(23, i)] = __builtin_astype((__builtin_astype((value), uchar4).s3210), unsigned int);
    }
  }
  barrier(0x01);
  local ulong gather[4 * 4];
  Blockmix_pwxform(block, valS, gather, yescrypt_r1);
  const unsigned int yescrypt_s = 16 * 8;
  {
    global uchar* dst = (global uchar*)(valV + yescrypt_s);
    local uchar* src = (local uchar*)block;
    for (unsigned int i = 0; i < 2 * 8; i++) {
      dst[hook(21, get_local_id(0))] = src[hook(7, get_local_id(0))];
      src += 8 * 8;
      dst += 8 * 8;
    }
    barrier(0x01);
  }

  Blockmix_pwxform(block, valS, gather, yescrypt_r1);
  const bool yescrypt_rw = true;
  unsigned int yescrypt_n = 1;
  for (unsigned int yescrypt_i = 2; yescrypt_i < yescrypt_N; yescrypt_i++) {
    event_t copied = async_work_group_copy(valV + yescrypt_i * yescrypt_s, block, yescrypt_s, 0);
    wait_group_events(1, &copied);

    if (yescrypt_rw) {
      if ((yescrypt_i % 2) == 0) {
        if ((yescrypt_i & (yescrypt_i - 1)) == 0)
          yescrypt_n <<= 1;
      }
      unsigned int j = Integerify(block, 8);
      j &= yescrypt_n - 1;
      j += yescrypt_i - yescrypt_n;

      global const unsigned int* indirected = (global unsigned int*)(valV + j * yescrypt_s);
      local unsigned int* dword = (local unsigned int*)block;
      for (size_t el = 0; el < (yescrypt_s * 2) / 64; el++) {
        dword[hook(24, get_local_id(0))] ^= indirected[hook(25, get_local_id(0))];
        dword += get_local_size(0);
        indirected += get_local_size(0);
      }

      barrier(0x01);
    }
    Blockmix_pwxform(block, valS, gather, yescrypt_r1);
  }

  {
    global uchar* dst = (global uchar*)(valB);
    local uchar* src = (local uchar*)(block);
    const unsigned int shuffled = salsa20_simd_unshuffle[hook(16, get_local_id(0))];
    for (unsigned int i = 0; i < 2 * 8; i++) {
      dst[hook(21, get_local_id(0))] = src[hook(7, shuffled)];
      src += 8 * 8;
      dst += 8 * 8;
    }
  }
}