//{"SBox":3,"block":8,"block0":4,"block1":5,"galiosCoeff":9,"input":1,"output":0,"roundKey":2,"rounds":7,"width":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
unsigned char galoisMultiplication(unsigned char a, unsigned char b) {
  unsigned char p = 0;
  for (unsigned int i = 0; i < 8; ++i) {
    if ((b & 1) == 1) {
      p ^= a;
    }
    unsigned char hiBitSet = (a & 0x80);
    a <<= 1;
    if (hiBitSet == 0x80) {
      a ^= 0x1b;
    }
    b >>= 1;
  }
  return p;
}

inline uchar4 sbox(global uchar* SBox, uchar4 block) {
  return (uchar4)(SBox[hook(3, block.x)], SBox[hook(3, block.y)], SBox[hook(3, block.z)], SBox[hook(3, block.w)]);
}

uchar4 mixColumns(local uchar4* block, private uchar4* galiosCoeff, unsigned int j) {
  unsigned int bw = 4;

  uchar x, y, z, w;

  x = galoisMultiplication(block[hook(8, 0)].x, galiosCoeff[hook(9, (bw - j) % bw)].x);
  y = galoisMultiplication(block[hook(8, 0)].y, galiosCoeff[hook(9, (bw - j) % bw)].x);
  z = galoisMultiplication(block[hook(8, 0)].z, galiosCoeff[hook(9, (bw - j) % bw)].x);
  w = galoisMultiplication(block[hook(8, 0)].w, galiosCoeff[hook(9, (bw - j) % bw)].x);

  for (unsigned int k = 1; k < 4; ++k) {
    x ^= galoisMultiplication(block[hook(8, k)].x, galiosCoeff[hook(9, (k + bw - j) % bw)].x);
    y ^= galoisMultiplication(block[hook(8, k)].y, galiosCoeff[hook(9, (k + bw - j) % bw)].x);
    z ^= galoisMultiplication(block[hook(8, k)].z, galiosCoeff[hook(9, (k + bw - j) % bw)].x);
    w ^= galoisMultiplication(block[hook(8, k)].w, galiosCoeff[hook(9, (k + bw - j) % bw)].x);
  }

  return (uchar4)(x, y, z, w);
}

uchar4 shiftRows(uchar4 row, unsigned int j) {
  uchar4 r = row;
  for (unsigned int i = 0; i < j; ++i) {
    r = r.yzwx;
  }
  return r;
}

kernel void AESEncrypt(global uchar4* output, global uchar4* input, global uchar4* roundKey, global uchar* SBox, local uchar4* block0, local uchar4* block1, const unsigned int width, const unsigned int rounds)

{
  unsigned int blockIdx = get_group_id(0);
  unsigned int blockIdy = get_group_id(1);

  unsigned int localIdx = get_local_id(0);
  unsigned int localIdy = get_local_id(1);

  unsigned int globalIndex = (((blockIdy * width / 4) + blockIdx) * 4) + (localIdy);
  unsigned int localIndex = localIdy;

 private
  uchar4 galiosCoeff[4];
  galiosCoeff[hook(9, 0)] = (uchar4)(2, 0, 0, 0);
  galiosCoeff[hook(9, 1)] = (uchar4)(3, 0, 0, 0);
  galiosCoeff[hook(9, 2)] = (uchar4)(1, 0, 0, 0);
  galiosCoeff[hook(9, 3)] = (uchar4)(1, 0, 0, 0);

  block0[hook(4, localIndex)] = input[hook(1, globalIndex)];

  block0[hook(4, localIndex)] ^= roundKey[hook(2, localIndex)];

  for (unsigned int r = 1; r < rounds; ++r) {
    block0[hook(4, localIndex)] = sbox(SBox, block0[hook(4, localIndex)]);

    block0[hook(4, localIndex)] = shiftRows(block0[hook(4, localIndex)], localIndex);

    barrier(0x01);
    block1[hook(5, localIndex)] = mixColumns(block0, galiosCoeff, localIndex);

    barrier(0x01);
    block0[hook(4, localIndex)] = block1[hook(5, localIndex)] ^ roundKey[hook(2, r * 4 + localIndex)];
  }
  block0[hook(4, localIndex)] = sbox(SBox, block0[hook(4, localIndex)]);

  block0[hook(4, localIndex)] = shiftRows(block0[hook(4, localIndex)], localIndex);

  output[hook(0, globalIndex)] = block0[hook(4, localIndex)] ^ roundKey[hook(2, (rounds) * 4 + localIndex)];
}