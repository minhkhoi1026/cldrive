//{"batchSize":5,"dinp":0,"doutp":1,"inp":3,"inputWidth":4,"o_max":7,"o_min":6,"outp":2}
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

kernel void sigmoid_backward(global float* dinp, global float* doutp, global float* outp, global float* inp, int inputWidth, int batchSize, float o_min, float o_max) {
  int tid = get_global_id(0);

  if (tid < batchSize) {
    for (int i = 0; i < inputWidth; i++) {
      float tmp = (outp[hook(2, tid * inputWidth + i)] - o_min) / (o_max - o_min);
      dinp[hook(0, tid * inputWidth + i)] = doutp[hook(1, tid * inputWidth + i)] * tmp * (tmp - 1.0f) * (o_max - o_min);
    }
  }
}