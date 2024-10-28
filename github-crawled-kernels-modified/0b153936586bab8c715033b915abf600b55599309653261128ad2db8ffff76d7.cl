//{"I":0,"I_patch":22,"I_patch[0]":21,"I_patch[1]":27,"I_patch[2]":30,"J":1,"PATCH_X":11,"PATCH_Y":12,"c_iters":16,"c_winSize_x":14,"c_winSize_y":15,"calcErr":17,"cn":13,"cols":10,"dIdx_patch":24,"dIdx_patch[0]":23,"dIdx_patch[1]":28,"dIdx_patch[2]":31,"dIdy_patch":26,"dIdy_patch[0]":25,"dIdy_patch[1]":29,"dIdy_patch[2]":32,"err":7,"level":8,"nextPts":4,"nextPtsStep":5,"prevPts":2,"prevPtsStep":3,"rows":9,"smem1":18,"smem2":19,"smem3":20,"status":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline void reduce3(float val1, float val2, float val3, local volatile float* smem1, local volatile float* smem2, local volatile float* smem3, int tid) {
  smem1[hook(18, tid)] = val1;
  smem2[hook(19, tid)] = val2;
  smem3[hook(20, tid)] = val3;
  barrier(0x01);

  if (tid < 32) {
    smem1[hook(18, tid)] += smem1[hook(18, tid + 32)];
    smem2[hook(19, tid)] += smem2[hook(19, tid + 32)];
    smem3[hook(20, tid)] += smem3[hook(20, tid + 32)];
  }
  barrier(0x01);
  if (tid < 16) {
    smem1[hook(18, tid)] += smem1[hook(18, tid + 16)];
    smem2[hook(19, tid)] += smem2[hook(19, tid + 16)];
    smem3[hook(20, tid)] += smem3[hook(20, tid + 16)];
  }
  barrier(0x01);
  if (tid < 8) {
    smem1[hook(18, tid)] += smem1[hook(18, tid + 8)];
    smem2[hook(19, tid)] += smem2[hook(19, tid + 8)];
    smem3[hook(20, tid)] += smem3[hook(20, tid + 8)];

    smem1[hook(18, tid)] += smem1[hook(18, tid + 4)];
    smem2[hook(19, tid)] += smem2[hook(19, tid + 4)];
    smem3[hook(20, tid)] += smem3[hook(20, tid + 4)];

    smem1[hook(18, tid)] += smem1[hook(18, tid + 2)];
    smem2[hook(19, tid)] += smem2[hook(19, tid + 2)];
    smem3[hook(20, tid)] += smem3[hook(20, tid + 2)];

    smem1[hook(18, tid)] += smem1[hook(18, tid + 1)];
    smem2[hook(19, tid)] += smem2[hook(19, tid + 1)];
    smem3[hook(20, tid)] += smem3[hook(20, tid + 1)];
  }
  barrier(0x01);
}

inline void reduce2(float val1, float val2, local volatile float* smem1, local volatile float* smem2, int tid) {
  smem1[hook(18, tid)] = val1;
  smem2[hook(19, tid)] = val2;
  barrier(0x01);

  if (tid < 32) {
    smem1[hook(18, tid)] += smem1[hook(18, tid + 32)];
    smem2[hook(19, tid)] += smem2[hook(19, tid + 32)];
  }
  barrier(0x01);
  if (tid < 16) {
    smem1[hook(18, tid)] += smem1[hook(18, tid + 16)];
    smem2[hook(19, tid)] += smem2[hook(19, tid + 16)];
  }
  barrier(0x01);
  if (tid < 8) {
    smem1[hook(18, tid)] += smem1[hook(18, tid + 8)];
    smem2[hook(19, tid)] += smem2[hook(19, tid + 8)];

    smem1[hook(18, tid)] += smem1[hook(18, tid + 4)];
    smem2[hook(19, tid)] += smem2[hook(19, tid + 4)];

    smem1[hook(18, tid)] += smem1[hook(18, tid + 2)];
    smem2[hook(19, tid)] += smem2[hook(19, tid + 2)];

    smem1[hook(18, tid)] += smem1[hook(18, tid + 1)];
    smem2[hook(19, tid)] += smem2[hook(19, tid + 1)];
  }
  barrier(0x01);
}

inline void reduce1(float val1, local volatile float* smem1, int tid) {
  smem1[hook(18, tid)] = val1;
  barrier(0x01);

  if (tid < 32) {
    smem1[hook(18, tid)] += smem1[hook(18, tid + 32)];
  }
  barrier(0x01);
  if (tid < 16) {
    smem1[hook(18, tid)] += smem1[hook(18, tid + 16)];
  }
  barrier(0x01);
  if (tid < 8) {
    smem1[hook(18, tid)] += smem1[hook(18, tid + 8)];
    smem1[hook(18, tid)] += smem1[hook(18, tid + 4)];
    smem1[hook(18, tid)] += smem1[hook(18, tid + 2)];
    smem1[hook(18, tid)] += smem1[hook(18, tid + 1)];
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

kernel void lkSparse_C1_D5(image2d_t I, image2d_t J, global const float2* prevPts, int prevPtsStep, global float2* nextPts, int nextPtsStep, global uchar* status, global float* err, const int level, const int rows, const int cols, int PATCH_X, int PATCH_Y, int cn, int c_winSize_x, int c_winSize_y, int c_iters, char calcErr) {
  local float smem1[64];
  local float smem2[64];
  local float smem3[64];

  unsigned int xid = get_local_id(0);
  unsigned int yid = get_local_id(1);
  unsigned int gid = get_group_id(0);
  unsigned int xsize = get_local_size(0);
  unsigned int ysize = get_local_size(1);
  int xBase, yBase, k;

  float2 c_halfWin = (float2)((c_winSize_x - 1) >> 1, (c_winSize_y - 1) >> 1);

  const int tid = mad24(yid, xsize, xid);

  float2 prevPt = prevPts[hook(2, gid)] / (float2)(1 << level);

  if (prevPt.x < 0 || prevPt.x >= cols || prevPt.y < 0 || prevPt.y >= rows) {
    if (tid == 0 && level == 0) {
      status[hook(6, gid)] = 0;
    }

    return;
  }
  prevPt -= c_halfWin;

  float A11 = 0;
  float A12 = 0;
  float A22 = 0;

  float I_patch[3][3];
  float dIdx_patch[3][3];
  float dIdy_patch[3][3];

  yBase = yid;
  {
    xBase = xid;
    SetPatch(I, prevPt.x + xBase + 0.5f, prevPt.y + yBase + 0.5f, &I_patch[hook(22, 0)][hook(21, 0)], &dIdx_patch[hook(24, 0)][hook(23, 0)], &dIdy_patch[hook(26, 0)][hook(25, 0)], &A11, &A12, &A22);

    xBase += xsize;
    SetPatch(I, prevPt.x + xBase + 0.5f, prevPt.y + yBase + 0.5f, &I_patch[hook(22, 0)][hook(21, 1)], &dIdx_patch[hook(24, 0)][hook(23, 1)], &dIdy_patch[hook(26, 0)][hook(25, 1)], &A11, &A12, &A22);

    xBase += xsize;
    if (xBase < c_winSize_x)
      SetPatch(I, prevPt.x + xBase + 0.5f, prevPt.y + yBase + 0.5f, &I_patch[hook(22, 0)][hook(21, 2)], &dIdx_patch[hook(24, 0)][hook(23, 2)], &dIdy_patch[hook(26, 0)][hook(25, 2)], &A11, &A12, &A22);
  }
  yBase += ysize;
  {
    xBase = xid;
    SetPatch(I, prevPt.x + xBase + 0.5f, prevPt.y + yBase + 0.5f, &I_patch[hook(22, 1)][hook(27, 0)], &dIdx_patch[hook(24, 1)][hook(28, 0)], &dIdy_patch[hook(26, 1)][hook(29, 0)], &A11, &A12, &A22);

    xBase += xsize;
    SetPatch(I, prevPt.x + xBase + 0.5f, prevPt.y + yBase + 0.5f, &I_patch[hook(22, 1)][hook(27, 1)], &dIdx_patch[hook(24, 1)][hook(28, 1)], &dIdy_patch[hook(26, 1)][hook(29, 1)], &A11, &A12, &A22);

    xBase += xsize;
    if (xBase < c_winSize_x)
      SetPatch(I, prevPt.x + xBase + 0.5f, prevPt.y + yBase + 0.5f, &I_patch[hook(22, 1)][hook(27, 2)], &dIdx_patch[hook(24, 1)][hook(28, 2)], &dIdy_patch[hook(26, 1)][hook(29, 2)], &A11, &A12, &A22);
  }
  yBase += ysize;
  if (yBase < c_winSize_y) {
    xBase = xid;
    SetPatch(I, prevPt.x + xBase + 0.5f, prevPt.y + yBase + 0.5f, &I_patch[hook(22, 2)][hook(30, 0)], &dIdx_patch[hook(24, 2)][hook(31, 0)], &dIdy_patch[hook(26, 2)][hook(32, 0)], &A11, &A12, &A22);

    xBase += xsize;
    SetPatch(I, prevPt.x + xBase + 0.5f, prevPt.y + yBase + 0.5f, &I_patch[hook(22, 2)][hook(30, 1)], &dIdx_patch[hook(24, 2)][hook(31, 1)], &dIdy_patch[hook(26, 2)][hook(32, 1)], &A11, &A12, &A22);

    xBase += xsize;
    if (xBase < c_winSize_x)
      SetPatch(I, prevPt.x + xBase + 0.5f, prevPt.y + yBase + 0.5f, &I_patch[hook(22, 2)][hook(30, 2)], &dIdx_patch[hook(24, 2)][hook(31, 2)], &dIdy_patch[hook(26, 2)][hook(32, 2)], &A11, &A12, &A22);
  }

  reduce3(A11, A12, A22, smem1, smem2, smem3, tid);

  A11 = smem1[hook(18, 0)];
  A12 = smem2[hook(19, 0)];
  A22 = smem3[hook(20, 0)];
  barrier(0x01);

  float D = A11 * A22 - A12 * A12;

  if (D < 1.192092896e-07f) {
    if (tid == 0 && level == 0)
      status[hook(6, gid)] = 0;

    return;
  }

  A11 /= D;
  A12 /= D;
  A22 /= D;

  prevPt = nextPts[hook(4, gid)] * 2.0f - c_halfWin;

  for (k = 0; k < c_iters; ++k) {
    if (prevPt.x < -c_halfWin.x || prevPt.x >= cols || prevPt.y < -c_halfWin.y || prevPt.y >= rows) {
      if (tid == 0 && level == 0)
        status[hook(6, gid)] = 0;
      return;
    }

    float b1 = 0;
    float b2 = 0;

    yBase = yid;
    {
      xBase = xid;
      GetPatch(J, prevPt.x + xBase + 0.5f, prevPt.y + yBase + 0.5f, &I_patch[hook(22, 0)][hook(21, 0)], &dIdx_patch[hook(24, 0)][hook(23, 0)], &dIdy_patch[hook(26, 0)][hook(25, 0)], &b1, &b2);

      xBase += xsize;
      GetPatch(J, prevPt.x + xBase + 0.5f, prevPt.y + yBase + 0.5f, &I_patch[hook(22, 0)][hook(21, 1)], &dIdx_patch[hook(24, 0)][hook(23, 1)], &dIdy_patch[hook(26, 0)][hook(25, 1)], &b1, &b2);

      xBase += xsize;
      if (xBase < c_winSize_x)
        GetPatch(J, prevPt.x + xBase + 0.5f, prevPt.y + yBase + 0.5f, &I_patch[hook(22, 0)][hook(21, 2)], &dIdx_patch[hook(24, 0)][hook(23, 2)], &dIdy_patch[hook(26, 0)][hook(25, 2)], &b1, &b2);
    }
    yBase += ysize;
    {
      xBase = xid;
      GetPatch(J, prevPt.x + xBase + 0.5f, prevPt.y + yBase + 0.5f, &I_patch[hook(22, 1)][hook(27, 0)], &dIdx_patch[hook(24, 1)][hook(28, 0)], &dIdy_patch[hook(26, 1)][hook(29, 0)], &b1, &b2);

      xBase += xsize;
      GetPatch(J, prevPt.x + xBase + 0.5f, prevPt.y + yBase + 0.5f, &I_patch[hook(22, 1)][hook(27, 1)], &dIdx_patch[hook(24, 1)][hook(28, 1)], &dIdy_patch[hook(26, 1)][hook(29, 1)], &b1, &b2);

      xBase += xsize;
      if (xBase < c_winSize_x)
        GetPatch(J, prevPt.x + xBase + 0.5f, prevPt.y + yBase + 0.5f, &I_patch[hook(22, 1)][hook(27, 2)], &dIdx_patch[hook(24, 1)][hook(28, 2)], &dIdy_patch[hook(26, 1)][hook(29, 2)], &b1, &b2);
    }
    yBase += ysize;
    if (yBase < c_winSize_y) {
      xBase = xid;
      GetPatch(J, prevPt.x + xBase + 0.5f, prevPt.y + yBase + 0.5f, &I_patch[hook(22, 2)][hook(30, 0)], &dIdx_patch[hook(24, 2)][hook(31, 0)], &dIdy_patch[hook(26, 2)][hook(32, 0)], &b1, &b2);

      xBase += xsize;
      GetPatch(J, prevPt.x + xBase + 0.5f, prevPt.y + yBase + 0.5f, &I_patch[hook(22, 2)][hook(30, 1)], &dIdx_patch[hook(24, 2)][hook(31, 1)], &dIdy_patch[hook(26, 2)][hook(32, 1)], &b1, &b2);

      xBase += xsize;
      if (xBase < c_winSize_x)
        GetPatch(J, prevPt.x + xBase + 0.5f, prevPt.y + yBase + 0.5f, &I_patch[hook(22, 2)][hook(30, 2)], &dIdx_patch[hook(24, 2)][hook(31, 2)], &dIdy_patch[hook(26, 2)][hook(32, 2)], &b1, &b2);
    }

    reduce2(b1, b2, smem1, smem2, tid);

    b1 = smem1[hook(18, 0)];
    b2 = smem2[hook(19, 0)];
    barrier(0x01);

    float2 delta;
    delta.x = A12 * b2 - A22 * b1;
    delta.y = A12 * b1 - A11 * b2;

    prevPt += delta;

    if (fabs(delta.x) < 0.01f && fabs(delta.y) < 0.01f)
      break;
  }

  D = 0.0f;
  if (calcErr) {
    yBase = yid;
    {
      xBase = xid;
      GetError(J, prevPt.x + xBase + 0.5f, prevPt.y + yBase + 0.5f, &I_patch[hook(22, 0)][hook(21, 0)], &D);

      xBase += xsize;
      GetError(J, prevPt.x + xBase + 0.5f, prevPt.y + yBase + 0.5f, &I_patch[hook(22, 0)][hook(21, 1)], &D);

      xBase += xsize;
      if (xBase < c_winSize_x)
        GetError(J, prevPt.x + xBase + 0.5f, prevPt.y + yBase + 0.5f, &I_patch[hook(22, 0)][hook(21, 2)], &D);
    }
    yBase += ysize;
    {
      xBase = xid;
      GetError(J, prevPt.x + xBase + 0.5f, prevPt.y + yBase + 0.5f, &I_patch[hook(22, 1)][hook(27, 0)], &D);

      xBase += xsize;
      GetError(J, prevPt.x + xBase + 0.5f, prevPt.y + yBase + 0.5f, &I_patch[hook(22, 1)][hook(27, 1)], &D);

      xBase += xsize;
      if (xBase < c_winSize_x)
        GetError(J, prevPt.x + xBase + 0.5f, prevPt.y + yBase + 0.5f, &I_patch[hook(22, 1)][hook(27, 2)], &D);
    }
    yBase += ysize;
    if (yBase < c_winSize_y) {
      xBase = xid;
      GetError(J, prevPt.x + xBase + 0.5f, prevPt.y + yBase + 0.5f, &I_patch[hook(22, 2)][hook(30, 0)], &D);

      xBase += xsize;
      GetError(J, prevPt.x + xBase + 0.5f, prevPt.y + yBase + 0.5f, &I_patch[hook(22, 2)][hook(30, 1)], &D);

      xBase += xsize;
      if (xBase < c_winSize_x)
        GetError(J, prevPt.x + xBase + 0.5f, prevPt.y + yBase + 0.5f, &I_patch[hook(22, 2)][hook(30, 2)], &D);
    }

    reduce1(D, smem1, tid);
  }

  if (tid == 0) {
    prevPt += c_halfWin;

    nextPts[hook(4, gid)] = prevPt;

    if (calcErr)
      err[hook(7, gid)] = smem1[hook(18, 0)] / (float)(c_winSize_x * c_winSize_y);
  }
}