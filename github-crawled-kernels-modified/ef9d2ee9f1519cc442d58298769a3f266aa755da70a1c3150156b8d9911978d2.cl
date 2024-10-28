//{"a":6,"data":1,"in":2,"out":3,"reversed":4,"reversed8":7,"smem":8,"work":0,"x":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline void globalLoads8(float2* data, global float2* in, int stride) {
  for (int i = 0; i < 8; i++)
    data[hook(1, i)] = in[hook(2, i * stride)];
}

inline void globalStores8(float2* data, global float2* out, int stride) {
  int reversed[] = {0, 4, 2, 6, 1, 5, 3, 7};

  for (int i = 0; i < 8; i++)
    out[hook(3, i * stride)] = data[hook(1, reversed[ihook(4, i))];
}

inline void storex8(float2* a, local float* x, int sx) {
  int reversed[] = {0, 4, 2, 6, 1, 5, 3, 7};

  for (int i = 0; i < 8; i++)
    x[hook(5, i * sx)] = a[hook(6, reversed[ihook(4, i))].x;
}

inline void storey8(float2* a, local float* x, int sx) {
  int reversed[] = {0, 4, 2, 6, 1, 5, 3, 7};

  for (int i = 0; i < 8; i++)
    x[hook(5, i * sx)] = a[hook(6, reversed[ihook(4, i))].y;
}

inline void loadx8(float2* a, local float* x, int sx) {
  for (int i = 0; i < 8; i++)
    a[hook(6, i)].x = x[hook(5, i * sx)];
}

inline void loady8(float2* a, local float* x, int sx) {
  for (int i = 0; i < 8; i++)
    a[hook(6, i)].y = x[hook(5, i * sx)];
}
inline float2 exp_i(float phi) {
  return (float2)(cos(phi), sin(phi));
}

inline float2 cmplx_mul(float2 a, float2 b) {
  return (float2)(a.x * b.x - a.y * b.y, a.x * b.y + a.y * b.x);
}
inline float2 cm_fl_mul(float2 a, float b) {
  return (float2)(b * a.x, b * a.y);
}
inline float2 cmplx_add(float2 a, float2 b) {
  return (float2)(a.x + b.x, a.y + b.y);
}
inline float2 cmplx_sub(float2 a, float2 b) {
  return (float2)(a.x - b.x, a.y - b.y);
}
kernel void ifft1D_512(global float2* work) {
  int i;
  int tid = get_local_id(0);
  int blockIdx = get_group_id(0) * 512 + tid;
  int hi = tid >> 3;
  int lo = tid & 7;
  float2 data[8];
  local float smem[8 * 8 * 9];

  work = work + blockIdx;
  globalLoads8(data, work, 64);

  {
    {
      float2 c0 = *&data[hook(1, 0)];
      *&data[hook(1, 0)] = cmplx_add(c0, *&data[hook(1, 4)]);
      *&data[hook(1, 4)] = cmplx_sub(c0, *&data[hook(1, 4)]);
    };
    {
      float2 c0 = *&data[hook(1, 1)];
      *&data[hook(1, 1)] = cmplx_add(c0, *&data[hook(1, 5)]);
      *&data[hook(1, 5)] = cmplx_sub(c0, *&data[hook(1, 5)]);
    };
    {
      float2 c0 = *&data[hook(1, 2)];
      *&data[hook(1, 2)] = cmplx_add(c0, *&data[hook(1, 6)]);
      *&data[hook(1, 6)] = cmplx_sub(c0, *&data[hook(1, 6)]);
    };
    {
      float2 c0 = *&data[hook(1, 3)];
      *&data[hook(1, 3)] = cmplx_add(c0, *&data[hook(1, 7)]);
      *&data[hook(1, 7)] = cmplx_sub(c0, *&data[hook(1, 7)]);
    };
    data[hook(1, 5)] = cm_fl_mul(cmplx_mul(data[hook(1, 5)], (float2)(1, 1)), 0x1.6a09e667f3bcdp-1);
    data[hook(1, 6)] = cmplx_mul(data[hook(1, 6)], (float2)(0, 1));
    data[hook(1, 7)] = cm_fl_mul(cmplx_mul(data[hook(1, 7)], (float2)(-1, 1)), 0x1.6a09e667f3bcdp-1);
    {
      {
        float2 c0 = *&data[hook(1, 0)];
        *&data[hook(1, 0)] = cmplx_add(c0, *&data[hook(1, 2)]);
        *&data[hook(1, 2)] = cmplx_sub(c0, *&data[hook(1, 2)]);
      };
      {
        float2 c0 = *&data[hook(1, 1)];
        *&data[hook(1, 1)] = cmplx_add(c0, *&data[hook(1, 3)]);
        *&data[hook(1, 3)] = cmplx_sub(c0, *&data[hook(1, 3)]);
      };
      *&data[hook(1, 3)] = cmplx_mul(*&data[hook(1, 3)], (float2)(0, 1));
      {
        float2 c0 = *&data[hook(1, 0)];
        *&data[hook(1, 0)] = cmplx_add(c0, *&data[hook(1, 1)]);
        *&data[hook(1, 1)] = cmplx_sub(c0, *&data[hook(1, 1)]);
      };
      {
        float2 c0 = *&data[hook(1, 2)];
        *&data[hook(1, 2)] = cmplx_add(c0, *&data[hook(1, 3)]);
        *&data[hook(1, 3)] = cmplx_sub(c0, *&data[hook(1, 3)]);
      };
    };
    {
      {
        float2 c0 = *&data[hook(1, 4)];
        *&data[hook(1, 4)] = cmplx_add(c0, *&data[hook(1, 6)]);
        *&data[hook(1, 6)] = cmplx_sub(c0, *&data[hook(1, 6)]);
      };
      {
        float2 c0 = *&data[hook(1, 5)];
        *&data[hook(1, 5)] = cmplx_add(c0, *&data[hook(1, 7)]);
        *&data[hook(1, 7)] = cmplx_sub(c0, *&data[hook(1, 7)]);
      };
      *&data[hook(1, 7)] = cmplx_mul(*&data[hook(1, 7)], (float2)(0, 1));
      {
        float2 c0 = *&data[hook(1, 4)];
        *&data[hook(1, 4)] = cmplx_add(c0, *&data[hook(1, 5)]);
        *&data[hook(1, 5)] = cmplx_sub(c0, *&data[hook(1, 5)]);
      };
      {
        float2 c0 = *&data[hook(1, 6)];
        *&data[hook(1, 6)] = cmplx_add(c0, *&data[hook(1, 7)]);
        *&data[hook(1, 7)] = cmplx_sub(c0, *&data[hook(1, 7)]);
      };
    };
  };

  {
    int reversed8[] = {0, 4, 2, 6, 1, 5, 3, 7};
    for (int j = 1; j < 8; j++)
      data[hook(1, j)] = cmplx_mul(data[hook(1, j)], exp_i((2 * 3.14159265358979323846f * reversed8[hook(7, j)] / (512)) * (tid)));
  };
  {
    storex8(data, &smem[hook(8, hi * 8 + lo)], 66);
    if ((0xf) & 8)
      barrier(0x01);
    loadx8(data, &smem[hook(8, lo * 66 + hi)], 8);
    if ((0xf) & 4)
      barrier(0x01);
    storey8(data, &smem[hook(8, hi * 8 + lo)], 66);
    if ((0xf) & 2)
      barrier(0x01);
    loady8(data, &smem[hook(8, lo * 66 + hi)], 8);
    if ((0xf) & 1)
      barrier(0x01);
  };

  {
    {
      float2 c0 = *&data[hook(1, 0)];
      *&data[hook(1, 0)] = cmplx_add(c0, *&data[hook(1, 4)]);
      *&data[hook(1, 4)] = cmplx_sub(c0, *&data[hook(1, 4)]);
    };
    {
      float2 c0 = *&data[hook(1, 1)];
      *&data[hook(1, 1)] = cmplx_add(c0, *&data[hook(1, 5)]);
      *&data[hook(1, 5)] = cmplx_sub(c0, *&data[hook(1, 5)]);
    };
    {
      float2 c0 = *&data[hook(1, 2)];
      *&data[hook(1, 2)] = cmplx_add(c0, *&data[hook(1, 6)]);
      *&data[hook(1, 6)] = cmplx_sub(c0, *&data[hook(1, 6)]);
    };
    {
      float2 c0 = *&data[hook(1, 3)];
      *&data[hook(1, 3)] = cmplx_add(c0, *&data[hook(1, 7)]);
      *&data[hook(1, 7)] = cmplx_sub(c0, *&data[hook(1, 7)]);
    };
    data[hook(1, 5)] = cm_fl_mul(cmplx_mul(data[hook(1, 5)], (float2)(1, 1)), 0x1.6a09e667f3bcdp-1);
    data[hook(1, 6)] = cmplx_mul(data[hook(1, 6)], (float2)(0, 1));
    data[hook(1, 7)] = cm_fl_mul(cmplx_mul(data[hook(1, 7)], (float2)(-1, 1)), 0x1.6a09e667f3bcdp-1);
    {
      {
        float2 c0 = *&data[hook(1, 0)];
        *&data[hook(1, 0)] = cmplx_add(c0, *&data[hook(1, 2)]);
        *&data[hook(1, 2)] = cmplx_sub(c0, *&data[hook(1, 2)]);
      };
      {
        float2 c0 = *&data[hook(1, 1)];
        *&data[hook(1, 1)] = cmplx_add(c0, *&data[hook(1, 3)]);
        *&data[hook(1, 3)] = cmplx_sub(c0, *&data[hook(1, 3)]);
      };
      *&data[hook(1, 3)] = cmplx_mul(*&data[hook(1, 3)], (float2)(0, 1));
      {
        float2 c0 = *&data[hook(1, 0)];
        *&data[hook(1, 0)] = cmplx_add(c0, *&data[hook(1, 1)]);
        *&data[hook(1, 1)] = cmplx_sub(c0, *&data[hook(1, 1)]);
      };
      {
        float2 c0 = *&data[hook(1, 2)];
        *&data[hook(1, 2)] = cmplx_add(c0, *&data[hook(1, 3)]);
        *&data[hook(1, 3)] = cmplx_sub(c0, *&data[hook(1, 3)]);
      };
    };
    {
      {
        float2 c0 = *&data[hook(1, 4)];
        *&data[hook(1, 4)] = cmplx_add(c0, *&data[hook(1, 6)]);
        *&data[hook(1, 6)] = cmplx_sub(c0, *&data[hook(1, 6)]);
      };
      {
        float2 c0 = *&data[hook(1, 5)];
        *&data[hook(1, 5)] = cmplx_add(c0, *&data[hook(1, 7)]);
        *&data[hook(1, 7)] = cmplx_sub(c0, *&data[hook(1, 7)]);
      };
      *&data[hook(1, 7)] = cmplx_mul(*&data[hook(1, 7)], (float2)(0, 1));
      {
        float2 c0 = *&data[hook(1, 4)];
        *&data[hook(1, 4)] = cmplx_add(c0, *&data[hook(1, 5)]);
        *&data[hook(1, 5)] = cmplx_sub(c0, *&data[hook(1, 5)]);
      };
      {
        float2 c0 = *&data[hook(1, 6)];
        *&data[hook(1, 6)] = cmplx_add(c0, *&data[hook(1, 7)]);
        *&data[hook(1, 7)] = cmplx_sub(c0, *&data[hook(1, 7)]);
      };
    };
  };

  {
    int reversed8[] = {0, 4, 2, 6, 1, 5, 3, 7};
    for (int j = 1; j < 8; j++)
      data[hook(1, j)] = cmplx_mul(data[hook(1, j)], exp_i((2 * 3.14159265358979323846f * reversed8[hook(7, j)] / (64)) * (hi)));
  };
  {
    storex8(data, &smem[hook(8, hi * 8 + lo)], 8 * 9);
    if ((0xE) & 8)
      barrier(0x01);
    loadx8(data, &smem[hook(8, hi * 8 * 9 + lo)], 8);
    if ((0xE) & 4)
      barrier(0x01);
    storey8(data, &smem[hook(8, hi * 8 + lo)], 8 * 9);
    if ((0xE) & 2)
      barrier(0x01);
    loady8(data, &smem[hook(8, hi * 8 * 9 + lo)], 8);
    if ((0xE) & 1)
      barrier(0x01);
  };

  {
    {
      float2 c0 = *&data[hook(1, 0)];
      *&data[hook(1, 0)] = cmplx_add(c0, *&data[hook(1, 4)]);
      *&data[hook(1, 4)] = cmplx_sub(c0, *&data[hook(1, 4)]);
    };
    {
      float2 c0 = *&data[hook(1, 1)];
      *&data[hook(1, 1)] = cmplx_add(c0, *&data[hook(1, 5)]);
      *&data[hook(1, 5)] = cmplx_sub(c0, *&data[hook(1, 5)]);
    };
    {
      float2 c0 = *&data[hook(1, 2)];
      *&data[hook(1, 2)] = cmplx_add(c0, *&data[hook(1, 6)]);
      *&data[hook(1, 6)] = cmplx_sub(c0, *&data[hook(1, 6)]);
    };
    {
      float2 c0 = *&data[hook(1, 3)];
      *&data[hook(1, 3)] = cmplx_add(c0, *&data[hook(1, 7)]);
      *&data[hook(1, 7)] = cmplx_sub(c0, *&data[hook(1, 7)]);
    };
    data[hook(1, 5)] = cm_fl_mul(cmplx_mul(data[hook(1, 5)], (float2)(1, 1)), 0x1.6a09e667f3bcdp-1);
    data[hook(1, 6)] = cmplx_mul(data[hook(1, 6)], (float2)(0, 1));
    data[hook(1, 7)] = cm_fl_mul(cmplx_mul(data[hook(1, 7)], (float2)(-1, 1)), 0x1.6a09e667f3bcdp-1);
    {
      {
        float2 c0 = *&data[hook(1, 0)];
        *&data[hook(1, 0)] = cmplx_add(c0, *&data[hook(1, 2)]);
        *&data[hook(1, 2)] = cmplx_sub(c0, *&data[hook(1, 2)]);
      };
      {
        float2 c0 = *&data[hook(1, 1)];
        *&data[hook(1, 1)] = cmplx_add(c0, *&data[hook(1, 3)]);
        *&data[hook(1, 3)] = cmplx_sub(c0, *&data[hook(1, 3)]);
      };
      *&data[hook(1, 3)] = cmplx_mul(*&data[hook(1, 3)], (float2)(0, 1));
      {
        float2 c0 = *&data[hook(1, 0)];
        *&data[hook(1, 0)] = cmplx_add(c0, *&data[hook(1, 1)]);
        *&data[hook(1, 1)] = cmplx_sub(c0, *&data[hook(1, 1)]);
      };
      {
        float2 c0 = *&data[hook(1, 2)];
        *&data[hook(1, 2)] = cmplx_add(c0, *&data[hook(1, 3)]);
        *&data[hook(1, 3)] = cmplx_sub(c0, *&data[hook(1, 3)]);
      };
    };
    {
      {
        float2 c0 = *&data[hook(1, 4)];
        *&data[hook(1, 4)] = cmplx_add(c0, *&data[hook(1, 6)]);
        *&data[hook(1, 6)] = cmplx_sub(c0, *&data[hook(1, 6)]);
      };
      {
        float2 c0 = *&data[hook(1, 5)];
        *&data[hook(1, 5)] = cmplx_add(c0, *&data[hook(1, 7)]);
        *&data[hook(1, 7)] = cmplx_sub(c0, *&data[hook(1, 7)]);
      };
      *&data[hook(1, 7)] = cmplx_mul(*&data[hook(1, 7)], (float2)(0, 1));
      {
        float2 c0 = *&data[hook(1, 4)];
        *&data[hook(1, 4)] = cmplx_add(c0, *&data[hook(1, 5)]);
        *&data[hook(1, 5)] = cmplx_sub(c0, *&data[hook(1, 5)]);
      };
      {
        float2 c0 = *&data[hook(1, 6)];
        *&data[hook(1, 6)] = cmplx_add(c0, *&data[hook(1, 7)]);
        *&data[hook(1, 7)] = cmplx_sub(c0, *&data[hook(1, 7)]);
      };
    };
  };

  for (i = 0; i < 8; i++) {
    data[hook(1, i)].x = data[hook(1, i)].x / 512.0f;
    data[hook(1, i)].y = data[hook(1, i)].y / 512.0f;
  }

  globalStores8(data, work, 64);
}