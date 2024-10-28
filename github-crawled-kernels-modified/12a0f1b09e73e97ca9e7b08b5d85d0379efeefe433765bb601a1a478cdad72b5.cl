//{"batchSize":11,"convos":13,"inp":1,"inputWidth":4,"numConvolutions":6,"numPics":3,"outp":0,"outputWidth":5,"pars":2,"pics":12,"x1":7,"x2":8,"y1":9,"y2":10}
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

kernel void convolution_forward(global float* outp, global float* inp, global float* pars, int numPics, int inputWidth, int outputWidth, int numConvolutions, int x1, int x2, int y1, int y2, int batchSize) {
  int tid = get_global_id(0);

  if (tid < batchSize) {
    float pics[784];
    for (int i = 0; i < x1 * x2 * numPics; i++) {
      pics[hook(12, i)] = inp[hook(1, tid * inputWidth + i)];
    }
    float convos[64];

    int pos = 0;
    for (int c = 0; c < numConvolutions; c++) {
      for (int i = 0; i < y1 * y2; i++) {
        convos[hook(13, i)] = pars[hook(2, c * y1 * y2 + i)];
      }

      for (int p = 0; p < numPics; p++) {
        for (int i = 0; i < x1 - y1 + 1; i++) {
          for (int j = 0; j < x2 - y2 + 1; j++) {
            float tmp = 0;
            for (int k = 0; k < y1; k++) {
              for (int l = 0; l < y2; l++) {
                tmp += pics[hook(12, p * x1 * x2 + (i + k) * x2 + (j + l))] * convos[hook(13, k * y2 + l)];
              }
            }
            outp[hook(0, tid * outputWidth + pos)] = tmp;
            pos++;
          }
        }
      }
    }
  }
}