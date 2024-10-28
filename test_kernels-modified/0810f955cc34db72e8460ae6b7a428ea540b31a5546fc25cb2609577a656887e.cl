//{"angle":8,"batchSize":7,"inp":2,"inputWidth":3,"noise":1,"nx1":11,"nx2":12,"outp":0,"outputWidth":4,"sx":9,"sy":10,"t_outp":14,"t_tmp":15,"trainRun":13,"x1":5,"x2":6}
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

kernel void preprocess_forward(global float* outp, global float* noise, global float* inp, int inputWidth, int outputWidth, int x1, int x2, int batchSize, float angle, float sx, float sy, int nx1, int nx2, int trainRun) {
  int tid = get_global_id(0);

  if (tid < batchSize) {
    if (trainRun == 1) {
      float t_outp[784];
      float t_tmp[784];

      for (int i = 0; i < outputWidth; i++) {
        t_outp[hook(14, i)] = 0.0f;
        t_tmp[hook(15, i)] = 0.0f;
      }

      for (int i = 0; i < nx1; i++) {
        for (int j = 0; j < nx2; j++) {
          int ii = (int)i * x1 / nx1;
          int jj = (int)j * x2 / nx2;
          float p = inp[hook(2, tid * inputWidth + ii * x2 + jj)];

          float iii = (i + 0.0f) / (nx1 + 0.0f) - 0.5f;
          float jjj = (j + 0.0f) / (nx2 + 0.0f) - 0.5f;

          float iiii = (cos(angle) * iii - sin(angle) * jjj) * sx + 0.5f;
          float jjjj = (sin(angle) * iii + cos(angle) * jjj) * sy + 0.5f;

          int fi = (int)((float)iiii * (x1 + 0.0f));
          int fj = (int)((float)jjjj * (x2 + 0.0f));

          if (fi >= 0 && fi < x1 && fj >= 0 && fj < x2) {
            t_outp[hook(14, fi * x2 + fj)] = (t_outp[hook(14, fi * x2 + fj)] * t_tmp[hook(15, fi * x2 + fj)] + p) / (t_tmp[hook(15, fi * x2 + fj)] + 1.0f);
            t_tmp[hook(15, fi * x2 + fj)] += 1.0f;
          }
        }
      }
      for (int i = 0; i < outputWidth; i++) {
        outp[hook(0, tid * outputWidth + i)] = t_outp[hook(14, i)] + noise[hook(1, tid * outputWidth + i)];
      }
    } else {
      for (int i = 0; i < outputWidth; i++) {
        outp[hook(0, tid * outputWidth + i)] = inp[hook(2, tid * outputWidth + i)];
      }
    }
  }
}