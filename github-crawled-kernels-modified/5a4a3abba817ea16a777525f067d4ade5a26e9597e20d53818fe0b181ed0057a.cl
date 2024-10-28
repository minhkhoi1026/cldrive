//{"batchSize":5,"dinp":0,"doutp":1,"inp":3,"inputWidth":4,"outp":2}
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

kernel void softmax_backward(global float* dinp, global float* doutp, global float* outp, global float* inp, int inputWidth, int batchSize) {
  int tid = get_global_id(0);

  if (tid < batchSize) {
    float sum = 0.0f;
    for (int i = 0; i < inputWidth; i++) {
      float tmp = exp(inp[hook(3, tid * inputWidth + i)]);
      sum += tmp;
    }
    for (int j = 0; j < inputWidth; j++) {
      for (int i = 0; i < inputWidth; i++) {
        if (i == j) {
          dinp[hook(0, tid * inputWidth + i)] += doutp[hook(1, tid * inputWidth + j)] * (sum - exp(inp[hook(3, tid * inputWidth + i)])) / (sum * sum) * exp(inp[hook(3, tid * inputWidth + i)]);
        } else {
          dinp[hook(0, tid * inputWidth + i)] -= doutp[hook(1, tid * inputWidth + j)] * exp(inp[hook(3, tid * inputWidth + j)]) / (sum * sum) * exp(inp[hook(3, tid * inputWidth + i)]);
        }
      }
    }
  }
}