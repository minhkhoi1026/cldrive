//{"A":7,"b":9,"cols":4,"data":10,"imgTex":6,"keypoints":0,"keypoints_offset":2,"keypoints_step":1,"rows":3,"sumTex":5,"x":8}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
__inline unsigned int read_sumTex_(global unsigned int* sumTex, int sum_step, int img_rows, int img_cols, int2 coord) {
  int x = clamp(coord.x, 0, img_cols);
  int y = clamp(coord.y, 0, img_rows);
  return sumTex[hook(5, sum_step * y + x)];
}

__inline uchar read_imgTex_(global uchar* imgTex, int img_step, int img_rows, int img_cols, float2 coord) {
  int x = clamp(convert_int_rte(coord.x), 0, img_cols - 1);
  int y = clamp(convert_int_rte(coord.y), 0, img_rows - 1);
  return imgTex[hook(6, img_step * y + x)];
}
constant sampler_t sampler = 0 | 2 | 0x10;
__inline int calcSize(int octave, int layer) {
  const int HAAR_SIZE0 = 9;

  const int HAAR_SIZE_INC = 6;

  return (HAAR_SIZE0 + HAAR_SIZE_INC * layer) << octave;
}

float calcAxisAlignedDerivative(int plus1a_A, int plus1a_B, int plus1a_C, int plus1a_D, float plus1a_scale, int plus1b_A, int plus1b_B, int plus1b_C, int plus1b_D, float plus1b_scale, int minus2_A, int minus2_B, int minus2_C, int minus2_D, float minus2_scale) {
  float plus1a = plus1a_A - plus1a_B - plus1a_C + plus1a_D;
  float plus1b = plus1b_A - plus1b_B - plus1b_C + plus1b_D;
  float minus2 = minus2_A - minus2_B - minus2_C + minus2_D;

  return (plus1a / plus1a_scale - 2.0f * minus2 / minus2_scale + plus1b / plus1b_scale);
}

inline bool solve3x3_float(const float4* A, const float* b, float* x) {
  float det = A[hook(7, 0)].x * (A[hook(7, 1)].y * A[hook(7, 2)].z - A[hook(7, 1)].z * A[hook(7, 2)].y) - A[hook(7, 0)].y * (A[hook(7, 1)].x * A[hook(7, 2)].z - A[hook(7, 1)].z * A[hook(7, 2)].x) + A[hook(7, 0)].z * (A[hook(7, 1)].x * A[hook(7, 2)].y - A[hook(7, 1)].y * A[hook(7, 2)].x);

  if (det != 0) {
    float invdet = 1.0f / det;

    x[hook(8, 0)] = invdet * (b[hook(9, 0)] * (A[hook(7, 1)].y * A[hook(7, 2)].z - A[hook(7, 1)].z * A[hook(7, 2)].y) - A[hook(7, 0)].y * (b[hook(9, 1)] * A[hook(7, 2)].z - A[hook(7, 1)].z * b[hook(9, 2)]) + A[hook(7, 0)].z * (b[hook(9, 1)] * A[hook(7, 2)].y - A[hook(7, 1)].y * b[hook(9, 2)]));

    x[hook(8, 1)] = invdet * (A[hook(7, 0)].x * (b[hook(9, 1)] * A[hook(7, 2)].z - A[hook(7, 1)].z * b[hook(9, 2)]) - b[hook(9, 0)] * (A[hook(7, 1)].x * A[hook(7, 2)].z - A[hook(7, 1)].z * A[hook(7, 2)].x) + A[hook(7, 0)].z * (A[hook(7, 1)].x * b[hook(9, 2)] - b[hook(9, 1)] * A[hook(7, 2)].x));

    x[hook(8, 2)] = invdet * (A[hook(7, 0)].x * (A[hook(7, 1)].y * b[hook(9, 2)] - b[hook(9, 1)] * A[hook(7, 2)].y) - A[hook(7, 0)].y * (A[hook(7, 1)].x * b[hook(9, 2)] - b[hook(9, 1)] * A[hook(7, 2)].x) + b[hook(9, 0)] * (A[hook(7, 1)].x * A[hook(7, 2)].y - A[hook(7, 1)].y * A[hook(7, 2)].x));

    return true;
  }
  return false;
}
constant float c_aptX[113] = {-6, -5, -5, -5, -5, -5, -5, -5, -4, -4, -4, -4, -4, -4, -4, -4, -4, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 5, 5, 5, 5, 5, 5, 5, 6};
constant float c_aptY[113] = {0, -3, -2, -1, 0, 1, 2, 3, -4, -3, -2, -1, 0, 1, 2, 3, 4, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, -6, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, -4, -3, -2, -1, 0, 1, 2, 3, 4, -3, -2, -1, 0, 1, 2, 3, 0};
constant float c_aptW[113] = {0.001455130288377404f, 0.001707611023448408f, 0.002547456417232752f, 0.003238451667129993f, 0.0035081731621176f, 0.003238451667129993f, 0.002547456417232752f, 0.001707611023448408f, 0.002003900473937392f, 0.0035081731621176f, 0.005233579315245152f, 0.00665318313986063f, 0.00720730796456337f, 0.00665318313986063f, 0.005233579315245152f, 0.0035081731621176f, 0.002003900473937392f, 0.001707611023448408f, 0.0035081731621176f, 0.006141661666333675f, 0.009162282571196556f, 0.01164754293859005f, 0.01261763460934162f, 0.01164754293859005f, 0.009162282571196556f, 0.006141661666333675f, 0.0035081731621176f, 0.001707611023448408f, 0.002547456417232752f, 0.005233579315245152f, 0.009162282571196556f, 0.01366852037608624f, 0.01737609319388866f, 0.0188232995569706f, 0.01737609319388866f, 0.01366852037608624f, 0.009162282571196556f, 0.005233579315245152f, 0.002547456417232752f, 0.003238451667129993f, 0.00665318313986063f, 0.01164754293859005f, 0.01737609319388866f, 0.02208934165537357f, 0.02392910048365593f, 0.02208934165537357f, 0.01737609319388866f, 0.01164754293859005f, 0.00665318313986063f, 0.003238451667129993f, 0.001455130288377404f, 0.0035081731621176f, 0.00720730796456337f, 0.01261763460934162f, 0.0188232995569706f, 0.02392910048365593f, 0.02592208795249462f, 0.02392910048365593f, 0.0188232995569706f, 0.01261763460934162f, 0.00720730796456337f, 0.0035081731621176f, 0.001455130288377404f, 0.003238451667129993f, 0.00665318313986063f, 0.01164754293859005f, 0.01737609319388866f, 0.02208934165537357f, 0.02392910048365593f, 0.02208934165537357f, 0.01737609319388866f, 0.01164754293859005f, 0.00665318313986063f, 0.003238451667129993f, 0.002547456417232752f, 0.005233579315245152f, 0.009162282571196556f, 0.01366852037608624f, 0.01737609319388866f, 0.0188232995569706f, 0.01737609319388866f, 0.01366852037608624f, 0.009162282571196556f, 0.005233579315245152f, 0.002547456417232752f, 0.001707611023448408f, 0.0035081731621176f, 0.006141661666333675f, 0.009162282571196556f, 0.01164754293859005f, 0.01261763460934162f, 0.01164754293859005f, 0.009162282571196556f, 0.006141661666333675f, 0.0035081731621176f, 0.001707611023448408f, 0.002003900473937392f, 0.0035081731621176f, 0.005233579315245152f, 0.00665318313986063f, 0.00720730796456337f, 0.00665318313986063f, 0.005233579315245152f, 0.0035081731621176f, 0.002003900473937392f, 0.001707611023448408f, 0.002547456417232752f, 0.003238451667129993f, 0.0035081731621176f, 0.003238451667129993f, 0.002547456417232752f, 0.001707611023448408f, 0.001455130288377404f};

constant float2 c_NX[5] = {(float2)(0, 2), (float2)(0, 0), (float2)(2, 4), (float2)(4, 4), (float2)(-1, 1)};
constant float2 c_NY[5] = {(float2)(0, 0), (float2)(0, 2), (float2)(4, 4), (float2)(2, 4), (float2)(1, -1)};

void reduce_32_sum(volatile local float* data, volatile float* partial_reduction, int tid) {
  data[hook(10, tid)] = *partial_reduction;
  barrier(0x01);

  if (tid < 16) {
    data[hook(10, tid)] = *partial_reduction = (*partial_reduction) + (data[hook(10, tid + 16)]);
  }
  barrier(0x01);
  if (tid < 8) {
    data[hook(10, tid)] = *partial_reduction = (*partial_reduction) + (data[hook(10, tid + 8)]);
  }
  barrier(0x01);
  if (tid < 4) {
    data[hook(10, tid)] = *partial_reduction = (*partial_reduction) + (data[hook(10, tid + 4)]);
  }
  barrier(0x01);
  if (tid < 2) {
    data[hook(10, tid)] = *partial_reduction = (*partial_reduction) + (data[hook(10, tid + 2)]);
  }
  barrier(0x01);
  if (tid < 1) {
    data[hook(10, tid)] = *partial_reduction = (*partial_reduction) + (data[hook(10, tid + 1)]);
  }
}

kernel void SURF_setUpRight(global float* keypoints, int keypoints_step, int keypoints_offset, int rows, int cols) {
  int i = get_global_id(0);
  keypoints_step /= sizeof(*keypoints);

  if (i < cols) {
    keypoints[hook(0, mad24(keypoints_step, 5, i))] = 270.f;
  }
}