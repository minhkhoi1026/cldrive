//{"batchSize":3,"inp":1,"inputWidth":2,"outp":0}
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

kernel void softmax_forward(global float* outp, global float* inp, int inputWidth, int batchSize) {
  int tid = get_global_id(0);

  if (tid < batchSize) {
    float sum = 0.0f;
    for (int i = 0; i < inputWidth; i++) {
      float tmp = exp(inp[hook(1, tid * inputWidth + i)]);
      outp[hook(0, tid * inputWidth + i)] = tmp;
      sum += tmp;
    }
    for (int i = 0; i < inputWidth; i++) {
      outp[hook(0, tid * inputWidth + i)] /= sum;
    }
  }
}