//{"cache":1,"state":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void subBytes(local uint4* state, int offset);
void mixColumns(local uint4* state);
void shiftRows(local uint4* state, int id);
void round_(local uint4* state, int offset, int id, const constant uint4* key, int key_offset);
kernel void bitslice_kernel(global uint4* state, local uint4* cache) {
  const uint4 c1 = (uint4)(1);
  size_t id = get_local_id(0);
  uint4 t = (uint4)(0), cs;
  cache += id & 0xFFFFFFE0;
  state += get_global_id(0) & 0xFFFFFFE0;

  id &= 0x1F;
  cache[hook(1, id)] = state[hook(0, id)];
  barrier(0x01);

  cs = (uint4)(id);
  for (int i = 0; i < 32; i++)
    t |= ((cache[hook(1, i)] >> cs) & c1) << (uint4)(i);
  state[hook(0, id)] = t;
}