//{"batchSize":14,"convos":16,"dinp":0,"doutp":2,"dpars":1,"inp":4,"inputWidth":7,"numConvolutions":9,"numPics":6,"outp":3,"outputWidth":8,"pars":5,"pics":15,"x1":10,"x2":11,"y1":12,"y2":13}
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

kernel void convolution_backward(global float* dinp, global float* dpars, global float* doutp, global float* outp, global float* inp, global float* pars, int numPics, int inputWidth, int outputWidth, int numConvolutions, int x1, int x2, int y1, int y2, int batchSize) {
  int tid = get_global_id(0);

  if (tid < batchSize) {
    float pics[784];
    for (int i = 0; i < x1 * x2 * numPics; i++) {
      pics[hook(15, i)] = inp[hook(4, tid * inputWidth + i)];
    }
    float convos[64];

    int pos = 0;
    for (int c = 0; c < numConvolutions; c++) {
      for (int i = 0; i < y1 * y2; i++) {
        convos[hook(16, i)] = pars[hook(5, c * y1 * y2 + i)];
      }

      for (int p = 0; p < numPics; p++) {
        for (int i = 0; i < x1 - y1 + 1; i++) {
          for (int j = 0; j < x2 - y2 + 1; j++) {
            float tmp = doutp[hook(2, tid * outputWidth + pos)];
            if (tmp != 0) {
              for (int k = 0; k < y1; k++) {
                for (int l = 0; l < y2; l++) {
                  if (dinp != ((void*)0)) {
                    dinp[hook(0, tid * inputWidth + p * x1 * x2 + (i + k) * x2 + (j + l))] += tmp * convos[hook(16, k * y2 + l)];
                  }
                  atomic_add(&(dpars[hook(1, c * y1 * y2 + k * y2 + l)]), tmp * pics[hook(15, p * x1 * x2 + (i + k) * x2 + (j + l))]);
                }
              }
            }
            pos++;
          }
        }
      }
    }
  }
}