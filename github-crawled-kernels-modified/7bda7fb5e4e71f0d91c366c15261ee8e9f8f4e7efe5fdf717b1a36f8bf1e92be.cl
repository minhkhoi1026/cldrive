//{"batchSize":5,"inp":1,"inputWidth":3,"outp":0,"outputWidth":4,"pars":2}
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

kernel void and_forward(global float* outp, global float* inp, global float* pars, int inputWidth, int outputWidth, int batchSize) {
  int tid = get_global_id(0);

  if (tid < batchSize) {
    for (int i = 0; i < outputWidth; i++) {
      float tmp = pars[hook(2, i * (inputWidth + 1))];
      for (int j = 0; j < inputWidth; j++) {
        tmp *= pow(0.01f + 0.99f * inp[hook(1, tid * inputWidth + j)], pars[hook(2, i * (inputWidth + 1) + 1 + j)]);
      }
      outp[hook(0, tid * outputWidth + i)] = tmp;
    }
  }
}