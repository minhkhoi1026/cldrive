//{"a":8,"b":9,"data":3,"fail":2,"half_n_cmplx":1,"in":4,"out":5,"reversed":6,"work":0,"x":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline void globalLoads8(float2* data, global float2* in, int stride) {
  for (int i = 0; i < 8; i++)
    data[hook(3, i)] = in[hook(4, i * stride)];
}

inline void globalStores8(float2* data, global float2* out, int stride) {
  int reversed[] = {0, 4, 2, 6, 1, 5, 3, 7};

  for (int i = 0; i < 8; i++)
    out[hook(5, i * stride)] = data[hook(3, reversed[ihook(6, i))];
}

inline void storex8(float2* a, local float* x, int sx) {
  int reversed[] = {0, 4, 2, 6, 1, 5, 3, 7};

  for (int i = 0; i < 8; i++)
    x[hook(7, i * sx)] = a[hook(8, reversed[ihook(6, i))].x;
}

inline void storey8(float2* a, local float* x, int sx) {
  int reversed[] = {0, 4, 2, 6, 1, 5, 3, 7};

  for (int i = 0; i < 8; i++)
    x[hook(7, i * sx)] = a[hook(8, reversed[ihook(6, i))].y;
}

inline void loadx8(float2* a, local float* x, int sx) {
  for (int i = 0; i < 8; i++)
    a[hook(8, i)].x = x[hook(7, i * sx)];
}

inline void loady8(float2* a, local float* x, int sx) {
  for (int i = 0; i < 8; i++)
    a[hook(8, i)].y = x[hook(7, i * sx)];
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
kernel void chk1D_512(global float2* work, int half_n_cmplx, global int* fail) {
  int i, tid = get_local_id(0);
  int blockIdx = get_group_id(0) * 512 + tid;
  float2 a[8], b[8];

  work = work + blockIdx;

  for (i = 0; i < 8; i++) {
    a[hook(8, i)] = work[hook(0, i * 64)];
  }

  for (i = 0; i < 8; i++) {
    b[hook(9, i)] = work[hook(0, half_n_cmplx + i * 64)];
  }

  for (i = 0; i < 8; i++) {
    if (a[hook(8, i)].x != b[hook(9, i)].x || a[hook(8, i)].y != b[hook(9, i)].y) {
      *fail = 1;
    }
  }
}