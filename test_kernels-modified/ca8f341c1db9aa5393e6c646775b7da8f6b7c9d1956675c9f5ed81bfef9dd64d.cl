//{"batchSize":5,"dinput":1,"error":0,"expOutp":2,"inputWidth":4,"outp":3}
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

kernel void error_square_kernel(global float* error, global float* dinput, global float* expOutp, global float* outp, int inputWidth, int batchSize) {
  int tid = get_global_id(0);

  if (tid < batchSize) {
    for (int i = 0; i < inputWidth; i++) {
      float tmp = outp[hook(3, tid * inputWidth + i)] - expOutp[hook(2, tid * inputWidth + i)];
      error[hook(0, tid * inputWidth + i)] = tmp * tmp;
      dinput[hook(1, tid * inputWidth + i)] = 2.0f * tmp;
    }
  }
}