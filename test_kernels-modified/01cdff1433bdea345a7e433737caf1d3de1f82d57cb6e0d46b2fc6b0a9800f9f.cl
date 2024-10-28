//{"state":1,"x":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
struct RandomResult {
  uint4 state;
  float value;
};

unsigned int tausStep(unsigned int z, int S1, int S2, int S3, unsigned int M) {
  unsigned int b = (((z << S1) ^ z) >> S2);
  return (((z & M) << S3) ^ b);
}

unsigned int lcgStep(unsigned int z, unsigned int A, unsigned int C) {
  return (A * z + C);
}

struct RandomResult random(uint4 state) {
  state.x = tausStep(state.x, 13, 19, 12, 4294967294);
  state.y = tausStep(state.y, 2, 25, 4, 4294967288);
  state.z = tausStep(state.z, 3, 11, 17, 4294967280);
  state.w = lcgStep(state.w, 1664525, 1013904223);

  struct RandomResult result;
  result.state = state;
  result.value = 2.3283064365387e-10 * (state.x ^ state.y ^ state.z ^ state.w);

  return result;
}

kernel void uniformRandom(global float* x, global uint4* state) {
  size_t i = get_global_id(0);
  struct RandomResult result = random(state[hook(1, i)]);
  state[hook(1, i)] = result.state;
  x[hook(0, i)] = result.value;
}