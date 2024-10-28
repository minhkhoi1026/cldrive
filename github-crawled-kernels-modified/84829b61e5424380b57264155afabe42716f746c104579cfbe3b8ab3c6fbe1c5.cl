//{"batchSize":5,"dom":2,"inp":1,"inputWidth":3,"outp":0,"perc":4}
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

kernel void dropout_forward(global float* outp, global float* inp, global float* dom, int inputWidth, float perc, int batchSize) {
  int tid = get_global_id(0);

  if (tid < batchSize) {
    for (int i = 0; i < inputWidth; i++) {
      if (dom[hook(2, tid * inputWidth + i)] < 1.0f - perc) {
        outp[hook(0, tid * inputWidth + i)] = inp[hook(1, tid * inputWidth + i)];
      } else {
        outp[hook(0, tid * inputWidth + i)] = 0;
      }
    }
  }
}