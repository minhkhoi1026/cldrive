//{"readHistoPyramid":0,"writeHistoPyramid":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 4 | 0x10;
unsigned int Part1By2(unsigned int x) {
  x &= 0x000003ff;
  x = (x ^ (x << 16)) & 0xff0000ff;
  x = (x ^ (x << 8)) & 0x0300f00f;
  x = (x ^ (x << 4)) & 0x030c30c3;
  x = (x ^ (x << 2)) & 0x09249249;
  return x;
}

unsigned int EncodeMorton3(unsigned int x, unsigned int y, unsigned int z) {
  return (Part1By2(z) << 2) + (Part1By2(y) << 1) + Part1By2(x);
}

unsigned int EncodeMorton(int4 v) {
  return EncodeMorton3(v.x, v.y, v.z);
}

unsigned int Compact1By2(unsigned int x) {
  x &= 0x09249249;
  x = (x ^ (x >> 2)) & 0x030c30c3;
  x = (x ^ (x >> 4)) & 0x0300f00f;
  x = (x ^ (x >> 8)) & 0xff0000ff;
  x = (x ^ (x >> 16)) & 0x000003ff;
  return x;
}

unsigned int DecodeMorton3X(unsigned int code) {
  return Compact1By2(code >> 0);
}

unsigned int DecodeMorton3Y(unsigned int code) {
  return Compact1By2(code >> 1);
}

unsigned int DecodeMorton3Z(unsigned int code) {
  return Compact1By2(code >> 2);
}

constant int4 cubeOffsets[8] = {
    {0, 0, 0, 0}, {1, 0, 0, 0}, {0, 0, 1, 0}, {1, 0, 1, 0}, {0, 1, 0, 0}, {1, 1, 0, 0}, {0, 1, 1, 0}, {1, 1, 1, 0},
};

kernel void constructHPLevelCharChar(global uchar* readHistoPyramid, global uchar* writeHistoPyramid) {
  unsigned int writePos = EncodeMorton3(get_global_id(0), get_global_id(1), get_global_id(2));
  unsigned int readPos = EncodeMorton3(get_global_id(0) * 2, get_global_id(1) * 2, get_global_id(2) * 2);
  uchar writeValue = readHistoPyramid[hook(0, readPos)] + readHistoPyramid[hook(0, readPos + 1)] + readHistoPyramid[hook(0, readPos + 2)] + readHistoPyramid[hook(0, readPos + 3)] + readHistoPyramid[hook(0, readPos + 4)] + readHistoPyramid[hook(0, readPos + 5)] + readHistoPyramid[hook(0, readPos + 6)] + readHistoPyramid[hook(0, readPos + 7)];

  writeHistoPyramid[hook(1, writePos)] = writeValue;
}