//{"batchSize":7,"d1":5,"d2":6,"inp":1,"numPics":2,"outp":0,"x1":3,"x2":4}
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

kernel void max_forward(global float* outp, global float* inp, int numPics, int x1, int x2, int d1, int d2, int batchSize) {
  int tid = get_global_id(0);

  if (tid < batchSize) {
    for (int p = 0; p < numPics; p++) {
      for (int i1 = 0; i1 < x1 / d1; i1++) {
        for (int i2 = 0; i2 < x2 / d2; i2++) {
          float tmp = -0x1.fffffep127f;
          for (int j1 = 0; j1 < d1; j1++) {
            for (int j2 = 0; j2 < d2; j2++) {
              if (tmp < inp[hook(1, tid * numPics * x1 * x2 + p * x1 * x2 + (i1 * d1 + j1) * x2 + (i2 * d2 + j2))]) {
                tmp = inp[hook(1, tid * numPics * x1 * x2 + p * x1 * x2 + (i1 * d1 + j1) * x2 + (i2 * d2 + j2))];
              }
            }
          }
          outp[hook(0, tid * numPics * (x1 / d1) * (x2 / d2) + p * (x1 / d1) * (x2 / d2) + i1 * (x2 / d2) + i2)] = tmp;
        }
      }
    }
  }
}