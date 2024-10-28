//{"batchSize":8,"dinp":0,"doutp":2,"dpars":1,"inp":4,"inputWidth":6,"outp":3,"outputWidth":7,"pars":5}
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

kernel void and_backward(global float* dinp, global float* dpars, global float* doutp, global float* outp, global float* inp, global float* pars, int inputWidth, int outputWidth, int batchSize) {
  int tid = get_global_id(0);

  if (tid < batchSize) {
    for (int i = 0; i < outputWidth; i++) {
      atomic_add(&(dpars[hook(1, i * (inputWidth + 1))]), doutp[hook(2, tid * outputWidth + i)] * outp[hook(3, tid * outputWidth + i)] / pars[hook(5, i * (inputWidth + 1))]);
      for (int j = 0; j < inputWidth; j++) {
        if (dinp != ((void*)0)) {
          dinp[hook(0, tid * inputWidth + j)] += doutp[hook(2, tid * outputWidth + i)] * outp[hook(3, tid * outputWidth + i)] * pars[hook(5, i * (inputWidth + 1) + 1 + j)] / (0.01f + 0.99f * inp[hook(4, tid * inputWidth + j)]);
        }
        atomic_add(&(dpars[hook(1, i * (inputWidth + 1) + 1 + j)]), doutp[hook(2, tid * outputWidth + i)] * outp[hook(3, tid * outputWidth + i)] * log(0.01f + 0.99f * inp[hook(4, tid * inputWidth + j)]));
      }
    }
  }
}