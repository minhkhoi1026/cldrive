//{"batchSize":3,"inp":1,"inputWidth":2,"o_max":5,"o_min":4,"outp":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline float atomic_add(volatile global float* address, const float value) {
  float old = value;
  while ((old = atomic_xchg(address, atomic_xchg(address, 0.0f) + old)) != 0.0f)
    ;
  return old;
}

kernel void sigmoid_forward(global float* outp, global float* inp, int inputWidth, int batchSize, float o_min, float o_max) {
  int tid = get_global_id(0);

  if (tid < batchSize) {
    for (int i = 0; i < inputWidth; i++) {
      outp[hook(0, tid * inputWidth + i)] = o_min + (o_max - o_min) / (1.0f + exp(inp[hook(1, tid * inputWidth + i)]));
    }
  }
}