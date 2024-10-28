//{"global_state":0,"state":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void F(private unsigned int* state, int src_idx, int dst_idx);
void FL(private unsigned int* state);
void InvFL(private unsigned int* state);
kernel void encrypt(global unsigned int* global_state) {
 private
  unsigned int state[128];
  global_state += get_global_id(0) * 128;

  for (int i = 0; i < 128; i++)
    state[hook(1, i)] = global_state[hook(0, i)];

  for (int j = 0; j < 2; j++) {
    for (int i = 0; i < 3; i++) {
      F(state, 0, 64);
      F(state, 64, 0);
    }
    FL(state);
    InvFL(state + 64);
  }
  for (int i = 0; i < 3; i++) {
    F(state, 0, 64);
    F(state, 64, 0);
  }

  for (int i = 0; i < 64; i++)
    global_state[hook(0, i)] = state[hook(1, i + 64)];
  for (int i = 0; i < 64; i++)
    global_state[hook(0, i + 64)] = state[hook(1, i)];
}