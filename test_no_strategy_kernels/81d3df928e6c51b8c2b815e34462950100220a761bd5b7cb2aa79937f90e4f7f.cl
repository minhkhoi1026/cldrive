//{"batchSize":8,"dinp":0,"doutp":2,"doutp2":10,"dpars":1,"inp":4,"inp2":9,"inputWidth":6,"outp":3,"outputWidth":7,"pars":5}
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

kernel void matrix_backward(global float* dinp, global float* dpars, global float* doutp, global float* outp, global float* inp, global float* pars, int inputWidth, int outputWidth, int batchSize) {
  int tid = get_global_id(0);

  if (tid < batchSize) {
    float inp2[5000];
    for (int i = 0; i < inputWidth; i++) {
      inp2[hook(9, i)] = inp[hook(4, tid * inputWidth + i)];
    }
    float doutp2[5000];
    for (int i = 0; i < outputWidth; i++) {
      doutp2[hook(10, i)] = doutp[hook(2, tid * outputWidth + i)];
    }

    for (int i = 0; i < outputWidth; i++) {
      atomic_add(&(dpars[hook(1, i * (inputWidth + 1))]), doutp2[hook(10, i)]);
      for (int j = 0; j < inputWidth; j++) {
        if (dinp != ((void*)0)) {
          dinp[hook(0, tid * inputWidth + j)] += doutp2[hook(10, i)] * pars[hook(5, i * (inputWidth + 1) + 1 + j)];
        }
        atomic_add(&(dpars[hook(1, i * (inputWidth + 1) + 1 + j)]), doutp2[hook(10, i)] * inp2[hook(9, j)]);
      }
    }
  }
}