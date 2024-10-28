//{"cache":1,"state":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void F(private unsigned int* state, int src_idx, int dst_idx);
void FL(private unsigned int* state);
void InvFL(private unsigned int* state);
kernel void shuffle_state1(global unsigned int* state, local unsigned int* cache) {
  size_t id = get_local_id(0);
  cache += (id & 0xFFFFFFE0) << 2;
  state += (get_global_id(0) & 0xFFFFFFE0) << 2;

  id &= 0x1F;
  cache[hook(1, id * 4 + 0)] = state[hook(0, id * 4 + 0)];
  cache[hook(1, id * 4 + 1)] = state[hook(0, id * 4 + 1)];
  cache[hook(1, id * 4 + 2)] = state[hook(0, id * 4 + 2)];
  cache[hook(1, id * 4 + 3)] = state[hook(0, id * 4 + 3)];
  barrier(0x01);

  state[hook(0, id + 0)] = cache[hook(1, id * 4 + 0)];
  state[hook(0, id + 32)] = cache[hook(1, id * 4 + 1)];
  state[hook(0, id + 64)] = cache[hook(1, id * 4 + 2)];
  state[hook(0, id + 96)] = cache[hook(1, id * 4 + 3)];
}