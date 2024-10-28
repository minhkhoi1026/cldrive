//{"ai_a0":7,"ai_b0":8,"coef_imag":10,"coef_real":9,"dataPtr":0,"filterPtr":1,"firImag":12,"firReal":11,"numIterations":4,"paddedSingleInputLength":5,"resultPtr":2,"totalFiltersLength":6,"totalInputLength":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void tdfir(global float* restrict dataPtr, global float* restrict filterPtr, global float* restrict resultPtr, const int totalInputLength, const int numIterations, const int paddedSingleInputLength, const int totalFiltersLength) {
  int tid = get_global_id(0);

  float ai_a0[32 + 8 - 1];
  float ai_b0[32 + 8 - 1];

  float coef_real[32];
  float coef_imag[32];

  int ilen, k;

  for (ilen = 0; ilen < 32 + 8 - 1; ilen++) {
    ai_a0[hook(7, ilen)] = 0.0f;
    ai_b0[hook(8, ilen)] = 0.0f;
  }

  uchar load_filter = 1;
  ushort load_filter_index = tid * totalFiltersLength;
  uchar num_coefs_loaded = 0;
  ushort ifilter = 0;

  for (ilen = 0; ilen < numIterations; ilen++) {
    int currentIdx = 2 * tid * totalInputLength + 2 * 8 * ilen;

    float firReal[8] = {0.0f};
    float firImag[8] = {0.0f};

    for (k = 0; k < 32 - 1; k++) {
      ai_a0[hook(7, k)] = ai_a0[hook(7, k + 8)];
      ai_b0[hook(8, k)] = ai_b0[hook(8, k + 8)];
    }

    for (k = 0; k < 8; k++) {
      int dataIdx = currentIdx + 2 * k;
      ai_a0[hook(7, k + 32 - 1)] = dataPtr[hook(0, dataIdx)];
      ai_b0[hook(8, k + 32 - 1)] = dataPtr[hook(0, dataIdx + 1)];
    }
    if (load_filter) {
      for (k = 0; k < 32 - 32; k += 32) {
        for (int i = 0; i < 32; i++) {
          coef_real[hook(9, k + i)] = coef_real[hook(9, k + i + 32)];
          coef_imag[hook(10, k + i)] = coef_imag[hook(10, k + i + 32)];
        }
      }

      for (int i = 0; i < 32; i++) {
        coef_real[hook(9, 32 - (32 - i))] = filterPtr[hook(1, 2 * load_filter_index + 2 * i)];
        coef_imag[hook(10, 32 - (32 - i))] = filterPtr[hook(1, 2 * load_filter_index + 2 * i + 1)];
      }

      load_filter_index += 32;

      if (++num_coefs_loaded == (32 / 32)) {
        load_filter = 0;
        num_coefs_loaded = 0;
      }
    }

    for (k = 32 - 1; k >= 0; k--) {
      for (int i = 0; i < 8; i++) {
        firReal[hook(11, i)] += ai_a0[hook(7, k + i)] * coef_real[hook(9, 32 - 1 - k)] - ai_b0[hook(8, k + i)] * coef_imag[hook(10, 32 - 1 - k)];
        firImag[hook(12, i)] += ai_a0[hook(7, k + i)] * coef_imag[hook(10, 32 - 1 - k)] + ai_b0[hook(8, k + i)] * coef_real[hook(9, 32 - 1 - k)];
      }
    }

    for (int i = 0; i < 8; i++) {
      int resultIdx = currentIdx + 2 * i;

      resultPtr[hook(2, resultIdx)] = firReal[hook(11, i)];
      resultPtr[hook(2, resultIdx + 1)] = firImag[hook(12, i)];
    }

    if (ifilter == paddedSingleInputLength) {
      load_filter = 1;
    }
    if (ifilter == paddedSingleInputLength) {
      ifilter = 0;
    } else
      ifilter += 8;
  }
}