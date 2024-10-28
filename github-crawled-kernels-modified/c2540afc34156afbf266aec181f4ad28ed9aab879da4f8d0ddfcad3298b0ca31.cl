//{"batchSize":7,"dinp":0,"dom":4,"doutp":1,"inp":3,"inputWidth":5,"outp":2,"perc":6}
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

kernel void dropout_backward(global float* dinp, global float* doutp, global float* outp, global float* inp, global float* dom, int inputWidth, float perc, int batchSize) {
  int tid = get_global_id(0);

  if (tid < batchSize) {
    for (int i = 0; i < inputWidth; i++) {
      if (dom[hook(4, tid * inputWidth + i)] < 1.0f - perc) {
        dinp[hook(0, tid * inputWidth + i)] = doutp[hook(1, tid * inputWidth + i)];
      }
    }
  }
}