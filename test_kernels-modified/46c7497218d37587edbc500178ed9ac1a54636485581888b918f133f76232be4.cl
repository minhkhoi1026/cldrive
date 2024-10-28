//{"global_state":0,"key":1,"state":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void subBytes(local uint4* state, int offset);
void mixColumns(local uint4* state);
void shiftRows(local uint4* state, int id);
void round_(local uint4* state, int offset, int id, const constant uint4* key, int key_offset);
kernel void encrypt(global uint4* global_state, const global uint4* key, local uint4* state) {
  int local_id = get_local_id(0);
  int id = local_id & (4 - 1);
  int offset = id * (32 / 4);
  global_state += (get_global_id(0) / 4) * 32;
  state += (local_id / 4) * 32;

  for (unsigned int i = 0; i < 8; i++)
    state[hook(2, offset + i)] = global_state[hook(0, offset + i)] ^ key[hook(1, offset + i)];

  for (unsigned int round = 1; round < 10; round++) {
    subBytes(state, offset);
    shiftRows(state, id);
    barrier(0x01);
    if (id == 0)
      mixColumns(state);
    barrier(0x01);
    for (unsigned int i = 0; i < 8; i++)
      state[hook(2, offset + i)] ^= key[hook(1, offset + round * 32 + i)];
  }

  subBytes(state, offset);
  shiftRows(state, id);
  for (unsigned int i = 0; i < 8; i++)
    global_state[hook(0, offset + i)] = state[hook(2, offset + i)] ^ key[hook(1, offset + 320 + i)];
}