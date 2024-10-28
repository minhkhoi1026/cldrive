//{"I":0,"IPatchLocal":21,"I_patch":23,"I_patch[0]":22,"I_patch[1]":28,"I_patch[2]":31,"J":1,"PATCH_X":9,"PATCH_Y":10,"c_iters":13,"c_winSize_x":11,"c_winSize_y":12,"calcErr":14,"cols":8,"dIdx_patch":25,"dIdx_patch[0]":24,"dIdx_patch[1]":29,"dIdx_patch[2]":32,"dIdy_patch":27,"dIdy_patch[0]":26,"dIdy_patch[1]":30,"dIdy_patch[2]":33,"err":5,"level":6,"m1":18,"m2":19,"m3":20,"nextPts":3,"prevPts":2,"rows":7,"smem1":15,"smem2":16,"smem3":17,"status":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline void reduce3(float val1, float val2, float val3, local volatile float* smem1, local volatile float* smem2, local volatile float* smem3, int tid) {
  smem1[hook(15, tid)] = val1;
  smem2[hook(16, tid)] = val2;
  smem3[hook(17, tid)] = val3;
  barrier(0x01);

  if (tid < 32) {
    smem1[hook(15, tid)] += smem1[hook(15, tid + 32)];
    smem2[hook(16, tid)] += smem2[hook(16, tid + 32)];
    smem3[hook(17, tid)] += smem3[hook(17, tid + 32)];
  }
  barrier(0x01);
  if (tid < 16) {
    smem1[hook(15, tid)] += smem1[hook(15, tid + 16)];
    smem2[hook(16, tid)] += smem2[hook(16, tid + 16)];
    smem3[hook(17, tid)] += smem3[hook(17, tid + 16)];
  }
  barrier(0x01);
  if (tid < 1) {
    local float8* m1 = (local float8*)smem1;
    local float8* m2 = (local float8*)smem2;
    local float8* m3 = (local float8*)smem3;
    float8 t1 = m1[hook(18, 0)] + m1[hook(18, 1)];
    float8 t2 = m2[hook(19, 0)] + m2[hook(19, 1)];
    float8 t3 = m3[hook(20, 0)] + m3[hook(20, 1)];
    float4 t14 = t1.lo + t1.hi;
    float4 t24 = t2.lo + t2.hi;
    float4 t34 = t3.lo + t3.hi;
    smem1[hook(15, 0)] = t14.x + t14.y + t14.z + t14.w;
    smem2[hook(16, 0)] = t24.x + t24.y + t24.z + t24.w;
    smem3[hook(17, 0)] = t34.x + t34.y + t34.z + t34.w;
  }
  barrier(0x01);
}

inline void reduce2(float val1, float val2, local volatile float* smem1, local volatile float* smem2, int tid) {
  smem1[hook(15, tid)] = val1;
  smem2[hook(16, tid)] = val2;
  barrier(0x01);

  if (tid < 32) {
    smem1[hook(15, tid)] += smem1[hook(15, tid + 32)];
    smem2[hook(16, tid)] += smem2[hook(16, tid + 32)];
  }
  barrier(0x01);
  if (tid < 16) {
    smem1[hook(15, tid)] += smem1[hook(15, tid + 16)];
    smem2[hook(16, tid)] += smem2[hook(16, tid + 16)];
  }
  barrier(0x01);
  if (tid < 1) {
    local float8* m1 = (local float8*)smem1;
    local float8* m2 = (local float8*)smem2;
    float8 t1 = m1[hook(18, 0)] + m1[hook(18, 1)];
    float8 t2 = m2[hook(19, 0)] + m2[hook(19, 1)];
    float4 t14 = t1.lo + t1.hi;
    float4 t24 = t2.lo + t2.hi;
    smem1[hook(15, 0)] = t14.x + t14.y + t14.z + t14.w;
    smem2[hook(16, 0)] = t24.x + t24.y + t24.z + t24.w;
  }
  barrier(0x01);
}

inline void reduce1(float val1, local volatile float* smem1, int tid) {
  smem1[hook(15, tid)] = val1;
  barrier(0x01);

  if (tid < 32) {
    smem1[hook(15, tid)] += smem1[hook(15, tid + 32)];
  }
  barrier(0x01);
  if (tid < 16) {
    smem1[hook(15, tid)] += smem1[hook(15, tid + 16)];
  }
  barrier(0x01);
  if (tid < 1) {
    local float8* m1 = (local float8*)smem1;
    float8 t1 = m1[hook(18, 0)] + m1[hook(18, 1)];
    float4 t14 = t1.lo + t1.hi;
    smem1[hook(15, 0)] = t14.x + t14.y + t14.z + t14.w;
  }
  barrier(0x01);
}

constant sampler_t sampler = 0 | 2 | 0x20;

inline void SetPatch(local float* IPatchLocal, int TileY, int TileX, float* Pch, float* Dx, float* Dy, float* A11, float* A12, float* A22, float w) {
  int xid = get_local_id(0);
  int yid = get_local_id(1);
  int xBase = mad24(TileX, 8, (xid + 1));
  int yBase = mad24(TileY, 8, (yid + 1));

  *Pch = (IPatchLocal[hook(21, mad24(((yBase) + (0)), (8 * 3 + 2), ((xBase) + (0))))]);

  *Dx = mad(((IPatchLocal[hook(21, mad24(((yBase) + (-1)), (8 * 3 + 2), ((xBase) + (1))))]) + (IPatchLocal[hook(21, mad24(((yBase) + (+1)), (8 * 3 + 2), ((xBase) + (1))))]) - (IPatchLocal[hook(21, mad24(((yBase) + (-1)), (8 * 3 + 2), ((xBase) + (-1))))]) - (IPatchLocal[hook(21, mad24(((yBase) + (+1)), (8 * 3 + 2), ((xBase) + (-1))))])), 3.0f, ((IPatchLocal[hook(21, mad24(((yBase) + (0)), (8 * 3 + 2), ((xBase) + (1))))]) - (IPatchLocal[hook(21, mad24(((yBase) + (0)), (8 * 3 + 2), ((xBase) + (-1))))])) * 10.0f) * w;
  *Dy = mad(((IPatchLocal[hook(21, mad24(((yBase) + (1)), (8 * 3 + 2), ((xBase) + (-1))))]) + (IPatchLocal[hook(21, mad24(((yBase) + (1)), (8 * 3 + 2), ((xBase) + (+1))))]) - (IPatchLocal[hook(21, mad24(((yBase) + (-1)), (8 * 3 + 2), ((xBase) + (-1))))]) - (IPatchLocal[hook(21, mad24(((yBase) + (-1)), (8 * 3 + 2), ((xBase) + (+1))))])), 3.0f, ((IPatchLocal[hook(21, mad24(((yBase) + (1)), (8 * 3 + 2), ((xBase) + (0))))]) - (IPatchLocal[hook(21, mad24(((yBase) + (-1)), (8 * 3 + 2), ((xBase) + (0))))])) * 10.0f) * w;

  *A11 = mad(*Dx, *Dx, *A11);
  *A12 = mad(*Dx, *Dy, *A12);
  *A22 = mad(*Dy, *Dy, *A22);
}

inline void GetPatch(image2d_t J, float x, float y, float* Pch, float* Dx, float* Dy, float* b1, float* b2) {
  float diff = read_imagef(J, sampler, (float2)(x, y)).x - *Pch;
  *b1 = mad(diff, *Dx, *b1);
  *b2 = mad(diff, *Dy, *b2);
}

inline void GetError(image2d_t J, const float x, const float y, const float* Pch, float* errval) {
  float diff = read_imagef(J, sampler, (float2)(x, y)).x - *Pch;
  *errval += fabs(diff);
}

void ReadPatchIToLocalMem(image2d_t I, float2 float4, local float* IPatchLocal) {
  int xid = get_local_id(0);
  int yid = get_local_id(1);

  IPatchLocal[hook(21, mad24(mad24((0), 8, yid), (8 * 3 + 2), mad24((0), 8, xid)))] = read_imagef(I, sampler, (float2)(mad((float)(0), (float)8, float4.x + xid - 0.5f), mad((float)(0), (float)8, float4.y + yid - 0.5f))).x;
  ;
  IPatchLocal[hook(21, mad24(mad24((0), 8, yid), (8 * 3 + 2), mad24((1), 8, xid)))] = read_imagef(I, sampler, (float2)(mad((float)(1), (float)8, float4.x + xid - 0.5f), mad((float)(0), (float)8, float4.y + yid - 0.5f))).x;
  ;
  IPatchLocal[hook(21, mad24(mad24((0), 8, yid), (8 * 3 + 2), mad24((2), 8, xid)))] = read_imagef(I, sampler, (float2)(mad((float)(2), (float)8, float4.x + xid - 0.5f), mad((float)(0), (float)8, float4.y + yid - 0.5f))).x;
  ;
  IPatchLocal[hook(21, mad24(mad24((1), 8, yid), (8 * 3 + 2), mad24((0), 8, xid)))] = read_imagef(I, sampler, (float2)(mad((float)(0), (float)8, float4.x + xid - 0.5f), mad((float)(1), (float)8, float4.y + yid - 0.5f))).x;
  ;
  IPatchLocal[hook(21, mad24(mad24((1), 8, yid), (8 * 3 + 2), mad24((1), 8, xid)))] = read_imagef(I, sampler, (float2)(mad((float)(1), (float)8, float4.x + xid - 0.5f), mad((float)(1), (float)8, float4.y + yid - 0.5f))).x;
  ;
  IPatchLocal[hook(21, mad24(mad24((1), 8, yid), (8 * 3 + 2), mad24((2), 8, xid)))] = read_imagef(I, sampler, (float2)(mad((float)(2), (float)8, float4.x + xid - 0.5f), mad((float)(1), (float)8, float4.y + yid - 0.5f))).x;
  ;
  IPatchLocal[hook(21, mad24(mad24((2), 8, yid), (8 * 3 + 2), mad24((0), 8, xid)))] = read_imagef(I, sampler, (float2)(mad((float)(0), (float)8, float4.x + xid - 0.5f), mad((float)(2), (float)8, float4.y + yid - 0.5f))).x;
  ;
  IPatchLocal[hook(21, mad24(mad24((2), 8, yid), (8 * 3 + 2), mad24((1), 8, xid)))] = read_imagef(I, sampler, (float2)(mad((float)(1), (float)8, float4.x + xid - 0.5f), mad((float)(2), (float)8, float4.y + yid - 0.5f))).x;
  ;
  IPatchLocal[hook(21, mad24(mad24((2), 8, yid), (8 * 3 + 2), mad24((2), 8, xid)))] = read_imagef(I, sampler, (float2)(mad((float)(2), (float)8, float4.x + xid - 0.5f), mad((float)(2), (float)8, float4.y + yid - 0.5f))).x;
  ;
  if (xid < 2) {
    IPatchLocal[hook(21, mad24(mad24((0), 8, yid), (8 * 3 + 2), mad24((3), 8, xid)))] = read_imagef(I, sampler, (float2)(mad((float)(3), (float)8, float4.x + xid - 0.5f), mad((float)(0), (float)8, float4.y + yid - 0.5f))).x;
    ;
    IPatchLocal[hook(21, mad24(mad24((1), 8, yid), (8 * 3 + 2), mad24((3), 8, xid)))] = read_imagef(I, sampler, (float2)(mad((float)(3), (float)8, float4.x + xid - 0.5f), mad((float)(1), (float)8, float4.y + yid - 0.5f))).x;
    ;
    IPatchLocal[hook(21, mad24(mad24((2), 8, yid), (8 * 3 + 2), mad24((3), 8, xid)))] = read_imagef(I, sampler, (float2)(mad((float)(3), (float)8, float4.x + xid - 0.5f), mad((float)(2), (float)8, float4.y + yid - 0.5f))).x;
    ;
  }

  if (yid < 2) {
    IPatchLocal[hook(21, mad24(mad24((3), 8, yid), (8 * 3 + 2), mad24((0), 8, xid)))] = read_imagef(I, sampler, (float2)(mad((float)(0), (float)8, float4.x + xid - 0.5f), mad((float)(3), (float)8, float4.y + yid - 0.5f))).x;
    ;
    IPatchLocal[hook(21, mad24(mad24((3), 8, yid), (8 * 3 + 2), mad24((1), 8, xid)))] = read_imagef(I, sampler, (float2)(mad((float)(1), (float)8, float4.x + xid - 0.5f), mad((float)(3), (float)8, float4.y + yid - 0.5f))).x;
    ;
    IPatchLocal[hook(21, mad24(mad24((3), 8, yid), (8 * 3 + 2), mad24((2), 8, xid)))] = read_imagef(I, sampler, (float2)(mad((float)(2), (float)8, float4.x + xid - 0.5f), mad((float)(3), (float)8, float4.y + yid - 0.5f))).x;
    ;
  }

  if (yid < 2 && xid < 2) {
    IPatchLocal[hook(21, mad24(mad24((3), 8, yid), (8 * 3 + 2), mad24((3), 8, xid)))] = read_imagef(I, sampler, (float2)(mad((float)(3), (float)8, float4.x + xid - 0.5f), mad((float)(3), (float)8, float4.y + yid - 0.5f))).x;
    ;
  }
  barrier(0x01);
}

__attribute__((reqd_work_group_size(8, 8, 1))) kernel void lkSparse(image2d_t I, image2d_t J, global const float2* prevPts, global float2* nextPts, global uchar* status, global float* err, const int level, const int rows, const int cols, int PATCH_X, int PATCH_Y, int c_winSize_x, int c_winSize_y, int c_iters, char calcErr) {
  local float smem1[(8 * 8)];
  local float smem2[(8 * 8)];
  local float smem3[(8 * 8)];

  int xid = get_local_id(0);
  int yid = get_local_id(1);
  int gid = get_group_id(0);
  int xsize = get_local_size(0);
  int ysize = get_local_size(1);
  int k;
  int xBase = mad24(xsize, 2, xid);
  int yBase = mad24(ysize, 2, yid);
  float wx = (xBase < c_winSize_x) ? 1 : 0;
  float wy = (yBase < c_winSize_y) ? 1 : 0;

  float2 c_halfWin = (float2)((c_winSize_x - 1) >> 1, (c_winSize_y - 1) >> 1);

  const int tid = mad24(yid, xsize, xid);

  float2 prevPt = prevPts[hook(2, gid)] / (float2)(1 << level);

  if (prevPt.x < 0 || prevPt.x >= cols || prevPt.y < 0 || prevPt.y >= rows) {
    if (tid == 0 && level == 0) {
      status[hook(4, gid)] = 0;
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

  local float IPatchLocal[(8 * 3 + 2) * (8 * 3 + 2)];
  ReadPatchIToLocalMem(I, prevPt, IPatchLocal);

  {
    SetPatch(IPatchLocal, 0, 0, &I_patch[hook(23, 0)][hook(22, 0)], &dIdx_patch[hook(25, 0)][hook(24, 0)], &dIdy_patch[hook(27, 0)][hook(26, 0)], &A11, &A12, &A22, 1);

    SetPatch(IPatchLocal, 0, 1, &I_patch[hook(23, 0)][hook(22, 1)], &dIdx_patch[hook(25, 0)][hook(24, 1)], &dIdy_patch[hook(27, 0)][hook(26, 1)], &A11, &A12, &A22, 1);

    SetPatch(IPatchLocal, 0, 2, &I_patch[hook(23, 0)][hook(22, 2)], &dIdx_patch[hook(25, 0)][hook(24, 2)], &dIdy_patch[hook(27, 0)][hook(26, 2)], &A11, &A12, &A22, wx);
  }
  {
    SetPatch(IPatchLocal, 1, 0, &I_patch[hook(23, 1)][hook(28, 0)], &dIdx_patch[hook(25, 1)][hook(29, 0)], &dIdy_patch[hook(27, 1)][hook(30, 0)], &A11, &A12, &A22, 1);

    SetPatch(IPatchLocal, 1, 1, &I_patch[hook(23, 1)][hook(28, 1)], &dIdx_patch[hook(25, 1)][hook(29, 1)], &dIdy_patch[hook(27, 1)][hook(30, 1)], &A11, &A12, &A22, 1);

    SetPatch(IPatchLocal, 1, 2, &I_patch[hook(23, 1)][hook(28, 2)], &dIdx_patch[hook(25, 1)][hook(29, 2)], &dIdy_patch[hook(27, 1)][hook(30, 2)], &A11, &A12, &A22, wx);
  }
  {
    SetPatch(IPatchLocal, 2, 0, &I_patch[hook(23, 2)][hook(31, 0)], &dIdx_patch[hook(25, 2)][hook(32, 0)], &dIdy_patch[hook(27, 2)][hook(33, 0)], &A11, &A12, &A22, wy);

    SetPatch(IPatchLocal, 2, 1, &I_patch[hook(23, 2)][hook(31, 1)], &dIdx_patch[hook(25, 2)][hook(32, 1)], &dIdy_patch[hook(27, 2)][hook(33, 1)], &A11, &A12, &A22, wy);

    SetPatch(IPatchLocal, 2, 2, &I_patch[hook(23, 2)][hook(31, 2)], &dIdx_patch[hook(25, 2)][hook(32, 2)], &dIdy_patch[hook(27, 2)][hook(33, 2)], &A11, &A12, &A22, wx * wy);
  }

  reduce3(A11, A12, A22, smem1, smem2, smem3, tid);

  A11 = smem1[hook(15, 0)];
  A12 = smem2[hook(16, 0)];
  A22 = smem3[hook(17, 0)];
  barrier(0x01);

  float D = mad(A11, A22, -A12 * A12);

  if (D < 1.192092896e-07f) {
    if (tid == 0 && level == 0)
      status[hook(4, gid)] = 0;

    return;
  }

  A11 /= D;
  A12 /= D;
  A22 /= D;

  prevPt = mad(nextPts[hook(3, gid)], 2.0f, -c_halfWin);

  float2 offset0 = (float2)(xid + 0.5f, yid + 0.5f);
  float2 offset1 = (float2)(xsize, ysize);
  float2 loc0 = prevPt + offset0;
  float2 loc1 = loc0 + offset1;
  float2 loc2 = loc1 + offset1;

  for (k = 0; k < c_iters; ++k) {
    if (prevPt.x < -c_halfWin.x || prevPt.x >= cols || prevPt.y < -c_halfWin.y || prevPt.y >= rows) {
      if (tid == 0 && level == 0)
        status[hook(4, gid)] = 0;
      break;
    }
    float b1 = 0;
    float b2 = 0;

    {
      GetPatch(J, loc0.x, loc0.y, &I_patch[hook(23, 0)][hook(22, 0)], &dIdx_patch[hook(25, 0)][hook(24, 0)], &dIdy_patch[hook(27, 0)][hook(26, 0)], &b1, &b2);

      GetPatch(J, loc1.x, loc0.y, &I_patch[hook(23, 0)][hook(22, 1)], &dIdx_patch[hook(25, 0)][hook(24, 1)], &dIdy_patch[hook(27, 0)][hook(26, 1)], &b1, &b2);

      GetPatch(J, loc2.x, loc0.y, &I_patch[hook(23, 0)][hook(22, 2)], &dIdx_patch[hook(25, 0)][hook(24, 2)], &dIdy_patch[hook(27, 0)][hook(26, 2)], &b1, &b2);
    }
    {
      GetPatch(J, loc0.x, loc1.y, &I_patch[hook(23, 1)][hook(28, 0)], &dIdx_patch[hook(25, 1)][hook(29, 0)], &dIdy_patch[hook(27, 1)][hook(30, 0)], &b1, &b2);

      GetPatch(J, loc1.x, loc1.y, &I_patch[hook(23, 1)][hook(28, 1)], &dIdx_patch[hook(25, 1)][hook(29, 1)], &dIdy_patch[hook(27, 1)][hook(30, 1)], &b1, &b2);

      GetPatch(J, loc2.x, loc1.y, &I_patch[hook(23, 1)][hook(28, 2)], &dIdx_patch[hook(25, 1)][hook(29, 2)], &dIdy_patch[hook(27, 1)][hook(30, 2)], &b1, &b2);
    }
    {
      GetPatch(J, loc0.x, loc2.y, &I_patch[hook(23, 2)][hook(31, 0)], &dIdx_patch[hook(25, 2)][hook(32, 0)], &dIdy_patch[hook(27, 2)][hook(33, 0)], &b1, &b2);

      GetPatch(J, loc1.x, loc2.y, &I_patch[hook(23, 2)][hook(31, 1)], &dIdx_patch[hook(25, 2)][hook(32, 1)], &dIdy_patch[hook(27, 2)][hook(33, 1)], &b1, &b2);

      GetPatch(J, loc2.x, loc2.y, &I_patch[hook(23, 2)][hook(31, 2)], &dIdx_patch[hook(25, 2)][hook(32, 2)], &dIdy_patch[hook(27, 2)][hook(33, 2)], &b1, &b2);
    }

    reduce2(b1, b2, smem1, smem2, tid);

    b1 = smem1[hook(15, 0)];
    b2 = smem2[hook(16, 0)];
    barrier(0x01);

    float2 delta;
    delta.x = mad(A12, b2, -A22 * b1) * 32.0f;
    delta.y = mad(A12, b1, -A11 * b2) * 32.0f;

    prevPt += delta;
    loc0 += delta;
    loc1 += delta;
    loc2 += delta;

    if (fabs(delta.x) < 0.01f && fabs(delta.y) < 0.01f)
      break;
  }

  D = 0.0f;
  if (calcErr) {
    {
      GetError(J, loc0.x, loc0.y, &I_patch[hook(23, 0)][hook(22, 0)], &D);
      GetError(J, loc1.x, loc0.y, &I_patch[hook(23, 0)][hook(22, 1)], &D);
    }
    {
      GetError(J, loc0.x, loc1.y, &I_patch[hook(23, 1)][hook(28, 0)], &D);
      GetError(J, loc1.x, loc1.y, &I_patch[hook(23, 1)][hook(28, 1)], &D);
    }
    if (xBase < c_winSize_x) {
      GetError(J, loc2.x, loc0.y, &I_patch[hook(23, 0)][hook(22, 2)], &D);
      GetError(J, loc2.x, loc1.y, &I_patch[hook(23, 1)][hook(28, 2)], &D);
    }
    if (yBase < c_winSize_y) {
      GetError(J, loc0.x, loc2.y, &I_patch[hook(23, 2)][hook(31, 0)], &D);
      GetError(J, loc1.x, loc2.y, &I_patch[hook(23, 2)][hook(31, 1)], &D);
      if (xBase < c_winSize_x)
        GetError(J, loc2.x, loc2.y, &I_patch[hook(23, 2)][hook(31, 2)], &D);
    }

    reduce1(D, smem1, tid);
  }

  if (tid == 0) {
    prevPt += c_halfWin;

    nextPts[hook(3, gid)] = prevPt;

    if (calcErr)
      err[hook(5, gid)] = smem1[hook(15, 0)] / (float)(c_winSize_x * c_winSize_y);
  }
}