//{"A":5,"b":7,"c_DM":4,"data":8,"featureDir":9,"keypoints":0,"keypoints_step":1,"nFeatures":2,"src":3,"x":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
unsigned int read_sumTex(image2d_t img, sampler_t sam, int2 coord, int rows, int cols, int elemPerRow) {
  return read_imageui(img, sam, coord).x;
}
uchar read_imgTex(image2d_t img, sampler_t sam, float2 coord, int rows, int cols, int elemPerRow) {
  return (uchar)read_imageui(img, sam, coord).x;
}
constant sampler_t sampler = 0 | 2 | 0x10;
float icvCalcHaarPatternSum_2(image2d_t sumTex, constant float2* src, int oldSize, int newSize, int y, int x, int rows, int cols, int elemPerRow) {
  float ratio = (float)newSize / oldSize;

  float d = 0;

  int2 dx1 = convert_int2(round(ratio * src[hook(3, 0)]));
  int2 dy1 = convert_int2(round(ratio * src[hook(3, 1)]));
  int2 dx2 = convert_int2(round(ratio * src[hook(3, 2)]));
  int2 dy2 = convert_int2(round(ratio * src[hook(3, 3)]));

  float t = 0;
  t += read_sumTex(sumTex, sampler, (int2)(x + dx1.x, y + dy1.x), rows, cols, elemPerRow);
  t -= read_sumTex(sumTex, sampler, (int2)(x + dx1.x, y + dy2.x), rows, cols, elemPerRow);
  t -= read_sumTex(sumTex, sampler, (int2)(x + dx2.x, y + dy1.x), rows, cols, elemPerRow);
  t += read_sumTex(sumTex, sampler, (int2)(x + dx2.x, y + dy2.x), rows, cols, elemPerRow);
  d += t * src[hook(3, 4)].x / ((dx2.x - dx1.x) * (dy2.x - dy1.x));

  t = 0;
  t += read_sumTex(sumTex, sampler, (int2)(x + dx1.y, y + dy1.y), rows, cols, elemPerRow);
  t -= read_sumTex(sumTex, sampler, (int2)(x + dx1.y, y + dy2.y), rows, cols, elemPerRow);
  t -= read_sumTex(sumTex, sampler, (int2)(x + dx2.y, y + dy1.y), rows, cols, elemPerRow);
  t += read_sumTex(sumTex, sampler, (int2)(x + dx2.y, y + dy2.y), rows, cols, elemPerRow);
  d += t * src[hook(3, 4)].y / ((dx2.y - dx1.y) * (dy2.y - dy1.y));

  return (float)d;
}

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

constant float c_DM[5] = {0, 0, 9, 9, 1};

bool within_check(image2d_t maskSumTex, int sum_i, int sum_j, int size, int rows, int cols, int step) {
  float ratio = (float)size / 9.0f;

  float d = 0;

  int dx1 = round(ratio * c_DM[hook(4, 0)]);
  int dy1 = round(ratio * c_DM[hook(4, 1)]);
  int dx2 = round(ratio * c_DM[hook(4, 2)]);
  int dy2 = round(ratio * c_DM[hook(4, 3)]);

  float t = 0;

  t += read_sumTex(maskSumTex, sampler, (int2)(sum_j + dx1, sum_i + dy1), rows, cols, step);
  t -= read_sumTex(maskSumTex, sampler, (int2)(sum_j + dx1, sum_i + dy2), rows, cols, step);
  t -= read_sumTex(maskSumTex, sampler, (int2)(sum_j + dx2, sum_i + dy1), rows, cols, step);
  t += read_sumTex(maskSumTex, sampler, (int2)(sum_j + dx2, sum_i + dy2), rows, cols, step);

  d += t * c_DM[hook(4, 4)] / ((dx2 - dx1) * (dy2 - dy1));

  return (d >= 0.5f);
}

inline bool solve3x3_float(const float4* A, const float* b, float* x) {
  float det = A[hook(5, 0)].x * (A[hook(5, 1)].y * A[hook(5, 2)].z - A[hook(5, 1)].z * A[hook(5, 2)].y) - A[hook(5, 0)].y * (A[hook(5, 1)].x * A[hook(5, 2)].z - A[hook(5, 1)].z * A[hook(5, 2)].x) + A[hook(5, 0)].z * (A[hook(5, 1)].x * A[hook(5, 2)].y - A[hook(5, 1)].y * A[hook(5, 2)].x);

  if (det != 0) {
    float invdet = 1.0 / det;

    x[hook(6, 0)] = invdet * (b[hook(7, 0)] * (A[hook(5, 1)].y * A[hook(5, 2)].z - A[hook(5, 1)].z * A[hook(5, 2)].y) - A[hook(5, 0)].y * (b[hook(7, 1)] * A[hook(5, 2)].z - A[hook(5, 1)].z * b[hook(7, 2)]) + A[hook(5, 0)].z * (b[hook(7, 1)] * A[hook(5, 2)].y - A[hook(5, 1)].y * b[hook(7, 2)]));

    x[hook(6, 1)] = invdet * (A[hook(5, 0)].x * (b[hook(7, 1)] * A[hook(5, 2)].z - A[hook(5, 1)].z * b[hook(7, 2)]) - b[hook(7, 0)] * (A[hook(5, 1)].x * A[hook(5, 2)].z - A[hook(5, 1)].z * A[hook(5, 2)].x) + A[hook(5, 0)].z * (A[hook(5, 1)].x * b[hook(7, 2)] - b[hook(7, 1)] * A[hook(5, 2)].x));

    x[hook(6, 2)] = invdet * (A[hook(5, 0)].x * (A[hook(5, 1)].y * b[hook(7, 2)] - b[hook(7, 1)] * A[hook(5, 2)].y) - A[hook(5, 0)].y * (A[hook(5, 1)].x * b[hook(7, 2)] - b[hook(7, 1)] * A[hook(5, 2)].x) + b[hook(7, 0)] * (A[hook(5, 1)].x * A[hook(5, 2)].y - A[hook(5, 1)].y * A[hook(5, 2)].x));

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
  data[hook(8, tid)] = *partial_reduction;
  barrier(0x01);

  if (tid < 16) {
    data[hook(8, tid)] = *partial_reduction = (*partial_reduction) + (data[hook(8, tid + 16)]);
  }
  barrier(0x01);
  if (tid < 8) {
    data[hook(8, tid)] = *partial_reduction = (*partial_reduction) + (data[hook(8, tid + 8)]);
  }
  barrier(0x01);
  if (tid < 4) {
    data[hook(8, tid)] = *partial_reduction = (*partial_reduction) + (data[hook(8, tid + 4)]);
  }
  barrier(0x01);
  if (tid < 2) {
    data[hook(8, tid)] = *partial_reduction = (*partial_reduction) + (data[hook(8, tid + 2)]);
  }
  barrier(0x01);
  if (tid < 1) {
    data[hook(8, tid)] = *partial_reduction = (*partial_reduction) + (data[hook(8, tid + 1)]);
  }
}

kernel void icvSetUpright(global float* keypoints, int keypoints_step, int nFeatures) {
  keypoints_step /= sizeof(*keypoints);
  global float* featureDir = keypoints + 5 * keypoints_step;

  if (get_global_id(0) <= nFeatures) {
    featureDir[hook(9, get_global_id(0))] = 270.0f;
  }
}