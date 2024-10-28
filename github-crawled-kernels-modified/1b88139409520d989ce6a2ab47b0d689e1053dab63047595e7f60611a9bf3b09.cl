//{"bitsliceKey":1,"expandedKey":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void subBytes(local uint4* state, int offset);
void mixColumns(local uint4* state);
void shiftRows(local uint4* state, int id);
void round_(local uint4* state, int offset, int id, const constant uint4* key, int key_offset);
kernel void bitslice_key(constant uchar* expandedKey, global uint4* bitsliceKey) {
  size_t gid = get_global_id(0);
  int q = gid >> 5;
  int g = (q << 7) + (gid & 0x1F);
  int k = g >> 3;
  int j = g & 7;

  bitsliceKey[hook(1, gid)] = (uint4)(((expandedKey[hook(0, k + 0)] >> j) & 1) == 0 ? 0 : 0xffffffff, ((expandedKey[hook(0, k + 4)] >> j) & 1) == 0 ? 0 : 0xffffffff, ((expandedKey[hook(0, k + 8)] >> j) & 1) == 0 ? 0 : 0xffffffff, ((expandedKey[hook(0, k + 12)] >> j) & 1) == 0 ? 0 : 0xffffffff);
}