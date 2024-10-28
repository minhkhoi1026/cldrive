//{"I":0,"I_patch":19,"J":1,"c_iters":14,"c_winSize_x":12,"c_winSize_y":13,"calcErr":15,"cols":11,"dIdx_patch":20,"dIdy_patch":21,"prevU":6,"prevUStep":7,"prevV":8,"prevVStep":9,"rows":10,"smem1":16,"smem2":17,"smem3":18,"u":2,"uStep":3,"v":4,"vStep":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline void reduce3(float val1, float val2, float val3, local volatile float* smem1, local volatile float* smem2, local volatile float* smem3, int tid) {
  smem1[hook(16, tid)] = val1;
  smem2[hook(17, tid)] = val2;
  smem3[hook(18, tid)] = val3;
  barrier(0x01);

  if (tid < 32) {
    smem1[hook(16, tid)] += smem1[hook(16, tid + 32)];
    smem2[hook(17, tid)] += smem2[hook(17, tid + 32)];
    smem3[hook(18, tid)] += smem3[hook(18, tid + 32)];
  }
  barrier(0x01);
  if (tid < 16) {
    smem1[hook(16, tid)] += smem1[hook(16, tid + 16)];
    smem2[hook(17, tid)] += smem2[hook(17, tid + 16)];
    smem3[hook(18, tid)] += smem3[hook(18, tid + 16)];
  }
  barrier(0x01);
  if (tid < 8) {
    smem1[hook(16, tid)] += smem1[hook(16, tid + 8)];
    smem2[hook(17, tid)] += smem2[hook(17, tid + 8)];
    smem3[hook(18, tid)] += smem3[hook(18, tid + 8)];

    smem1[hook(16, tid)] += smem1[hook(16, tid + 4)];
    smem2[hook(17, tid)] += smem2[hook(17, tid + 4)];
    smem3[hook(18, tid)] += smem3[hook(18, tid + 4)];

    smem1[hook(16, tid)] += smem1[hook(16, tid + 2)];
    smem2[hook(17, tid)] += smem2[hook(17, tid + 2)];
    smem3[hook(18, tid)] += smem3[hook(18, tid + 2)];

    smem1[hook(16, tid)] += smem1[hook(16, tid + 1)];
    smem2[hook(17, tid)] += smem2[hook(17, tid + 1)];
    smem3[hook(18, tid)] += smem3[hook(18, tid + 1)];
  }
  barrier(0x01);
}

inline void reduce2(float val1, float val2, local volatile float* smem1, local volatile float* smem2, int tid) {
  smem1[hook(16, tid)] = val1;
  smem2[hook(17, tid)] = val2;
  barrier(0x01);

  if (tid < 32) {
    smem1[hook(16, tid)] += smem1[hook(16, tid + 32)];
    smem2[hook(17, tid)] += smem2[hook(17, tid + 32)];
  }
  barrier(0x01);
  if (tid < 16) {
    smem1[hook(16, tid)] += smem1[hook(16, tid + 16)];
    smem2[hook(17, tid)] += smem2[hook(17, tid + 16)];
  }
  barrier(0x01);
  if (tid < 8) {
    smem1[hook(16, tid)] += smem1[hook(16, tid + 8)];
    smem2[hook(17, tid)] += smem2[hook(17, tid + 8)];

    smem1[hook(16, tid)] += smem1[hook(16, tid + 4)];
    smem2[hook(17, tid)] += smem2[hook(17, tid + 4)];

    smem1[hook(16, tid)] += smem1[hook(16, tid + 2)];
    smem2[hook(17, tid)] += smem2[hook(17, tid + 2)];

    smem1[hook(16, tid)] += smem1[hook(16, tid + 1)];
    smem2[hook(17, tid)] += smem2[hook(17, tid + 1)];
  }
  barrier(0x01);
}

inline void reduce1(float val1, local volatile float* smem1, int tid) {
  smem1[hook(16, tid)] = val1;
  barrier(0x01);

  if (tid < 32) {
    smem1[hook(16, tid)] += smem1[hook(16, tid + 32)];
  }
  barrier(0x01);
  if (tid < 16) {
    smem1[hook(16, tid)] += smem1[hook(16, tid + 16)];
  }
  barrier(0x01);
  if (tid < 8) {
    smem1[hook(16, tid)] += smem1[hook(16, tid + 8)];
    smem1[hook(16, tid)] += smem1[hook(16, tid + 4)];
    smem1[hook(16, tid)] += smem1[hook(16, tid + 2)];
    smem1[hook(16, tid)] += smem1[hook(16, tid + 1)];
  }
  barrier(0x01);
}

constant sampler_t sampler = 0 | 2 | 0x20;

inline void SetPatch(image2d_t I, float x, float y, float* Pch, float* Dx, float* Dy, float* A11, float* A12, float* A22) {
  *Pch = read_imagef(I, sampler, (float2)(x, y)).x;

  float dIdx = 3.0f * read_imagef(I, sampler, (float2)(x + 1, y - 1)).x + 10.0f * read_imagef(I, sampler, (float2)(x + 1, y)).x + 3.0f * read_imagef(I, sampler, (float2)(x + 1, y + 1)).x - (3.0f * read_imagef(I, sampler, (float2)(x - 1, y - 1)).x + 10.0f * read_imagef(I, sampler, (float2)(x - 1, y)).x + 3.0f * read_imagef(I, sampler, (float2)(x - 1, y + 1)).x);

  float dIdy = 3.0f * read_imagef(I, sampler, (float2)(x - 1, y + 1)).x + 10.0f * read_imagef(I, sampler, (float2)(x, y + 1)).x + 3.0f * read_imagef(I, sampler, (float2)(x + 1, y + 1)).x - (3.0f * read_imagef(I, sampler, (float2)(x - 1, y - 1)).x + 10.0f * read_imagef(I, sampler, (float2)(x, y - 1)).x + 3.0f * read_imagef(I, sampler, (float2)(x + 1, y - 1)).x);

  *Dx = dIdx;
  *Dy = dIdy;

  *A11 += dIdx * dIdx;
  *A12 += dIdx * dIdy;
  *A22 += dIdy * dIdy;
}

inline void GetPatch(image2d_t J, float x, float y, float* Pch, float* Dx, float* Dy, float* b1, float* b2) {
  float J_val = read_imagef(J, sampler, (float2)(x, y)).x;
  float diff = (J_val - *Pch) * 32.0f;
  *b1 += diff * *Dx;
  *b2 += diff * *Dy;
}

inline void GetError(image2d_t J, const float x, const float y, const float* Pch, float* errval) {
  float diff = read_imagef(J, sampler, (float2)(x, y)).x - *Pch;
  *errval += fabs(diff);
}

inline void SetPatch4(image2d_t I, const float x, const float y, float4* Pch, float4* Dx, float4* Dy, float* A11, float* A12, float* A22) {
  *Pch = read_imagef(I, sampler, (float2)(x, y));

  float4 dIdx = 3.0f * read_imagef(I, sampler, (float2)(x + 1, y - 1)) + 10.0f * read_imagef(I, sampler, (float2)(x + 1, y)) + 3.0f * read_imagef(I, sampler, (float2)(x + 1, y + 1)) - (3.0f * read_imagef(I, sampler, (float2)(x - 1, y - 1)) + 10.0f * read_imagef(I, sampler, (float2)(x - 1, y)) + 3.0f * read_imagef(I, sampler, (float2)(x - 1, y + 1)));

  float4 dIdy = 3.0f * read_imagef(I, sampler, (float2)(x - 1, y + 1)) + 10.0f * read_imagef(I, sampler, (float2)(x, y + 1)) + 3.0f * read_imagef(I, sampler, (float2)(x + 1, y + 1)) - (3.0f * read_imagef(I, sampler, (float2)(x - 1, y - 1)) + 10.0f * read_imagef(I, sampler, (float2)(x, y - 1)) + 3.0f * read_imagef(I, sampler, (float2)(x + 1, y - 1)));

  *Dx = dIdx;
  *Dy = dIdy;
  float4 sqIdx = dIdx * dIdx;
  *A11 += sqIdx.x + sqIdx.y + sqIdx.z;
  sqIdx = dIdx * dIdy;
  *A12 += sqIdx.x + sqIdx.y + sqIdx.z;
  sqIdx = dIdy * dIdy;
  *A22 += sqIdx.x + sqIdx.y + sqIdx.z;
}

inline void GetPatch4(image2d_t J, const float x, const float y, const float4* Pch, const float4* Dx, const float4* Dy, float* b1, float* b2) {
  float4 J_val = read_imagef(J, sampler, (float2)(x, y));
  float4 diff = (J_val - *Pch) * 32.0f;
  float4 xdiff = diff * *Dx;
  *b1 += xdiff.x + xdiff.y + xdiff.z;
  xdiff = diff * *Dy;
  *b2 += xdiff.x + xdiff.y + xdiff.z;
}

inline void GetError4(image2d_t J, const float x, const float y, const float4* Pch, float* errval) {
  float4 diff = read_imagef(J, sampler, (float2)(x, y)) - *Pch;
  *errval += fabs(diff.x) + fabs(diff.y) + fabs(diff.z);
}

kernel void lkDense_C1_D0(image2d_t I, image2d_t J, global float* u, int uStep, global float* v, int vStep, global const float* prevU, int prevUStep, global const float* prevV, int prevVStep, const int rows, const int cols, int c_winSize_x, int c_winSize_y, int c_iters, char calcErr) {
  int c_halfWin_x = (c_winSize_x - 1) / 2;
  int c_halfWin_y = (c_winSize_y - 1) / 2;

  const int patchWidth = get_local_size(0) + 2 * c_halfWin_x;
  const int patchHeight = get_local_size(1) + 2 * c_halfWin_y;

  local int smem[8192];

  local int* I_patch = smem;
  local int* dIdx_patch = I_patch + patchWidth * patchHeight;
  local int* dIdy_patch = dIdx_patch + patchWidth * patchHeight;

  const int xBase = get_group_id(0) * get_local_size(0);
  const int yBase = get_group_id(1) * get_local_size(1);

  sampler_t sampleri = 0 | 2 | 0x10;

  for (int i = get_local_id(1); i < patchHeight; i += get_local_size(1)) {
    for (int j = get_local_id(0); j < patchWidth; j += get_local_size(0)) {
      float x = xBase - c_halfWin_x + j + 0.5f;
      float y = yBase - c_halfWin_y + i + 0.5f;

      I_patch[hook(19, i * patchWidth + j)] = read_imagei(I, sampleri, (float2)(x, y)).x;

      dIdx_patch[hook(20, i * patchWidth + j)] = 3 * read_imagei(I, sampleri, (float2)(x + 1, y - 1)).x + 10 * read_imagei(I, sampleri, (float2)(x + 1, y)).x + 3 * read_imagei(I, sampleri, (float2)(x + 1, y + 1)).x - (3 * read_imagei(I, sampleri, (float2)(x - 1, y - 1)).x + 10 * read_imagei(I, sampleri, (float2)(x - 1, y)).x + 3 * read_imagei(I, sampleri, (float2)(x - 1, y + 1)).x);

      dIdy_patch[hook(21, i * patchWidth + j)] = 3 * read_imagei(I, sampleri, (float2)(x - 1, y + 1)).x + 10 * read_imagei(I, sampleri, (float2)(x, y + 1)).x + 3 * read_imagei(I, sampleri, (float2)(x + 1, y + 1)).x - (3 * read_imagei(I, sampleri, (float2)(x - 1, y - 1)).x + 10 * read_imagei(I, sampleri, (float2)(x, y - 1)).x + 3 * read_imagei(I, sampleri, (float2)(x + 1, y - 1)).x);
    }
  }
  barrier(0x01);

  const int x = get_global_id(0);
  const int y = get_global_id(1);

  if (x >= cols || y >= rows)
    return;

  int A11i = 0;
  int A12i = 0;
  int A22i = 0;

  for (int i = 0; i < c_winSize_y; ++i) {
    for (int j = 0; j < c_winSize_x; ++j) {
      int dIdx = dIdx_patch[hook(20, (get_local_id(1) + i) * patchWidth + (get_local_id(0) + j))];
      int dIdy = dIdy_patch[hook(21, (get_local_id(1) + i) * patchWidth + (get_local_id(0) + j))];

      A11i += dIdx * dIdx;
      A12i += dIdx * dIdy;
      A22i += dIdy * dIdy;
    }
  }

  float A11 = A11i;
  float A12 = A12i;
  float A22 = A22i;

  float D = A11 * A22 - A12 * A12;

  if (D < 1.192092896e-07f) {
    return;
  }

  D = 1.f / D;

  A11 *= D;
  A12 *= D;
  A22 *= D;

  float2 nextPt;
  nextPt.x = x + prevU[hook(6, y / 2 * prevUStep / 4 + x / 2)] * 2.0f;
  nextPt.y = y + prevV[hook(8, y / 2 * prevVStep / 4 + x / 2)] * 2.0f;

  for (int k = 0; k < c_iters; ++k) {
    if (nextPt.x < 0 || nextPt.x >= cols || nextPt.y < 0 || nextPt.y >= rows) {
      return;
    }

    int b1 = 0;
    int b2 = 0;

    for (int i = 0; i < c_winSize_y; ++i) {
      for (int j = 0; j < c_winSize_x; ++j) {
        int iI = I_patch[hook(19, (get_local_id(1) + i) * patchWidth + get_local_id(0) + j)];
        int iJ = read_imagei(J, sampler, (float2)(nextPt.x - c_halfWin_x + j + 0.5f, nextPt.y - c_halfWin_y + i + 0.5f)).x;

        int diff = (iJ - iI) * 32;

        int dIdx = dIdx_patch[hook(20, (get_local_id(1) + i) * patchWidth + (get_local_id(0) + j))];
        int dIdy = dIdy_patch[hook(21, (get_local_id(1) + i) * patchWidth + (get_local_id(0) + j))];

        b1 += diff * dIdx;
        b2 += diff * dIdy;
      }
    }

    float2 delta;
    delta.x = A12 * b2 - A22 * b1;
    delta.y = A12 * b1 - A11 * b2;

    nextPt.x += delta.x;
    nextPt.y += delta.y;

    if (fabs(delta.x) < 0.01f && fabs(delta.y) < 0.01f)
      break;
  }

  u[hook(2, y * uStep / 4 + x)] = nextPt.x - x;
  v[hook(4, y * vStep / 4 + x)] = nextPt.y - y;

  if (calcErr) {
    int errval = 0;

    for (int i = 0; i < c_winSize_y; ++i) {
      for (int j = 0; j < c_winSize_x; ++j) {
        int iI = I_patch[hook(19, (get_local_id(1) + i) * patchWidth + get_local_id(0) + j)];
        int iJ = read_imagei(J, sampler, (float2)(nextPt.x - c_halfWin_x + j + 0.5f, nextPt.y - c_halfWin_y + i + 0.5f)).x;

        errval += abs(iJ - iI);
      }
    }
  }
}