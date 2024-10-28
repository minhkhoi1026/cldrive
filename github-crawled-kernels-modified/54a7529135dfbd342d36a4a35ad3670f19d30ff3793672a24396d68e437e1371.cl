//{"SBox":3,"block":8,"block0":4,"block1":5,"galoisCoeff":9,"input":1,"output":0,"roundKey":2,"rounds":7,"width":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline uchar4 sbox(global uchar* SBox, uchar4 block) {
  return (uchar4)(SBox[hook(3, block.x)], SBox[hook(3, block.y)], SBox[hook(3, block.z)], SBox[hook(3, block.w)]);
}

uchar4 shiftRows(uchar4 value, unsigned int rowNumber) {
  uchar4 tempValue = value;
  for (unsigned int i = 0; i < rowNumber; i++) {
    tempValue = tempValue.yzwx;
  }
  return tempValue;
}

uchar4 shiftRowsInv(uchar4 value, unsigned int j) {
  uchar4 tempValue = value;
  for (unsigned int i = 0; i < j; ++i) {
    tempValue = tempValue.wxyz;
  }
  return tempValue;
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

uchar4 mixColumns(local uchar4* block, private unsigned int* galoisCoeff, unsigned int j, unsigned int localIndex, unsigned int localSizex) {
  unsigned int bw = 4;

  uchar x, y, z, w;

  unsigned int localIdx = localIndex - localSizex * j;

  x = galoisMultiplication(block[hook(8, localIdx)].x, galoisCoeff[hook(9, (bw - j) % bw)]);
  y = galoisMultiplication(block[hook(8, localIdx)].y, galoisCoeff[hook(9, (bw - j) % bw)]);
  z = galoisMultiplication(block[hook(8, localIdx)].z, galoisCoeff[hook(9, (bw - j) % bw)]);
  w = galoisMultiplication(block[hook(8, localIdx)].w, galoisCoeff[hook(9, (bw - j) % bw)]);

  for (unsigned int k = 1; k < 4; ++k) {
    x ^= galoisMultiplication(block[hook(8, k * localSizex + localIdx)].x, galoisCoeff[hook(9, (k + bw - j) % bw)]);
    y ^= galoisMultiplication(block[hook(8, k * localSizex + localIdx)].y, galoisCoeff[hook(9, (k + bw - j) % bw)]);
    z ^= galoisMultiplication(block[hook(8, k * localSizex + localIdx)].z, galoisCoeff[hook(9, (k + bw - j) % bw)]);
    w ^= galoisMultiplication(block[hook(8, k * localSizex + localIdx)].w, galoisCoeff[hook(9, (k + bw - j) % bw)]);
  }

  return (uchar4)(x, y, z, w);
}

kernel void AESEncrypt(global uchar4* output, global uchar4* input, global uchar4* roundKey, global uchar* SBox, local uchar4* block0, local uchar4* block1, const unsigned int width, const unsigned int rounds)

{
  unsigned int localIdx = get_local_id(0);
  unsigned int localIdy = get_local_id(1);

  unsigned int globalIdx = get_global_id(0);
  unsigned int globalIdy = get_global_id(1);

  unsigned int blockIdx = get_group_id(0);
  unsigned int blockIdy = get_group_id(1);

  unsigned int ndRangeSizex = get_global_size(0);
  unsigned int ndRangeSizey = get_global_size(1);

  unsigned int localSizex = get_local_size(0);
  unsigned int localSizey = get_local_size(1);

  unsigned int localIndex = localIdy * (localSizex) + localIdx;

  unsigned int globalIndex1 = localIndex + (localSizex * localSizey * (blockIdx + blockIdy * (ndRangeSizex / localSizex)));

  unsigned int globalIndex = globalIdy * ndRangeSizex + globalIdx;

  block0[hook(4, localIndex)] = input[hook(1, globalIndex)];

  block0[hook(4, localIndex)] ^= roundKey[hook(2, localIdy)];

 private
  unsigned int galoisCoeff[4];
  galoisCoeff[hook(9, 0)] = 2;
  galoisCoeff[hook(9, 1)] = 3;
  galoisCoeff[hook(9, 2)] = 1;
  galoisCoeff[hook(9, 3)] = 1;

  for (int i = 1; i < rounds; i++) {
    block0[hook(4, localIndex)] = sbox(SBox, block0[hook(4, localIndex)]);

    block0[hook(4, localIndex)] = shiftRows(block0[hook(4, localIndex)], localIdy);
    barrier(0x01);

    block1[hook(5, localIndex)] = mixColumns(block0, galoisCoeff, localIdy, localIndex, localSizex);
    barrier(0x01);

    block0[hook(4, localIndex)] = block1[hook(5, localIndex)] ^ roundKey[hook(2, i * 4 + localIdy)];
  }

  block0[hook(4, localIndex)] = sbox(SBox, block0[hook(4, localIndex)]);

  block0[hook(4, localIndex)] = shiftRows(block0[hook(4, localIndex)], localIdy);

  block0[hook(4, localIndex)] ^= roundKey[hook(2, localIdy + rounds * 4)];

  output[hook(0, globalIndex)] = block0[hook(4, localIndex)];
}