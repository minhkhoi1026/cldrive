//{"global_state":0,"key":1,"state":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void subBytes(private uint4* state, int offset);
void mixColumns(private uint4* state);
void shiftRows(private uint4* state);
void round_(private uint4* state, int offset, int id, const constant uint4* key, int key_offset);
kernel void encrypt(global uint4* global_state, const global uint4* key) {
 private
  uint4 state[32];
  global_state += get_global_id(0) * 32;

  for (unsigned int i = 0; i < 32; i++)
    state[hook(2, i)] = global_state[hook(0, i)] ^ key[hook(1, i)];

  for (unsigned int round = 1; round < 10; round++) {
    subBytes(state, 0);
    subBytes(state, 8);
    subBytes(state, 16);
    subBytes(state, 24);
    shiftRows(state);
    mixColumns(state);
    for (unsigned int i = 0; i < 32; i++)
      state[hook(2, i)] ^= key[hook(1, round * 32 + i)];
  }

  subBytes(state, 0);
  subBytes(state, 8);
  subBytes(state, 16);
  subBytes(state, 24);
  shiftRows(state);
  for (unsigned int i = 0; i < 32; i++)
    global_state[hook(0, i)] = state[hook(2, i)] ^ key[hook(1, 320 + i)];
}