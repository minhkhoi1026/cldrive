//{"A":9,"b":11,"c_aptW":19,"c_aptX":16,"c_aptY":18,"data":12,"featureDir":25,"featureSize":13,"featureX":15,"featureY":17,"imgTex":8,"img_cols":4,"img_rows":3,"keypoints":5,"keypoints_offset":7,"keypoints_step":6,"s_X":20,"s_Y":21,"s_angle":22,"s_mod":14,"s_sumx":23,"s_sumy":24,"sumTex":0,"sum_offset":2,"sum_step":1,"x":10}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
__inline unsigned int read_sumTex_(global unsigned int* sumTex, int sum_step, int img_rows, int img_cols, int2 coord) {
  int x = clamp(coord.x, 0, img_cols);
  int y = clamp(coord.y, 0, img_rows);
  return sumTex[hook(0, sum_step * y + x)];
}

__inline uchar read_imgTex_(global uchar* imgTex, int img_step, int img_rows, int img_cols, float2 coord) {
  int x = clamp(convert_int_rte(coord.x), 0, img_cols - 1);
  int y = clamp(convert_int_rte(coord.y), 0, img_rows - 1);
  return imgTex[hook(8, img_step * y + x)];
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
  float det = A[hook(9, 0)].x * (A[hook(9, 1)].y * A[hook(9, 2)].z - A[hook(9, 1)].z * A[hook(9, 2)].y) - A[hook(9, 0)].y * (A[hook(9, 1)].x * A[hook(9, 2)].z - A[hook(9, 1)].z * A[hook(9, 2)].x) + A[hook(9, 0)].z * (A[hook(9, 1)].x * A[hook(9, 2)].y - A[hook(9, 1)].y * A[hook(9, 2)].x);

  if (det != 0) {
    float invdet = 1.0f / det;

    x[hook(10, 0)] = invdet * (b[hook(11, 0)] * (A[hook(9, 1)].y * A[hook(9, 2)].z - A[hook(9, 1)].z * A[hook(9, 2)].y) - A[hook(9, 0)].y * (b[hook(11, 1)] * A[hook(9, 2)].z - A[hook(9, 1)].z * b[hook(11, 2)]) + A[hook(9, 0)].z * (b[hook(11, 1)] * A[hook(9, 2)].y - A[hook(9, 1)].y * b[hook(11, 2)]));

    x[hook(10, 1)] = invdet * (A[hook(9, 0)].x * (b[hook(11, 1)] * A[hook(9, 2)].z - A[hook(9, 1)].z * b[hook(11, 2)]) - b[hook(11, 0)] * (A[hook(9, 1)].x * A[hook(9, 2)].z - A[hook(9, 1)].z * A[hook(9, 2)].x) + A[hook(9, 0)].z * (A[hook(9, 1)].x * b[hook(11, 2)] - b[hook(11, 1)] * A[hook(9, 2)].x));

    x[hook(10, 2)] = invdet * (A[hook(9, 0)].x * (A[hook(9, 1)].y * b[hook(11, 2)] - b[hook(11, 1)] * A[hook(9, 2)].y) - A[hook(9, 0)].y * (A[hook(9, 1)].x * b[hook(11, 2)] - b[hook(11, 1)] * A[hook(9, 2)].x) + b[hook(11, 0)] * (A[hook(9, 1)].x * A[hook(9, 2)].y - A[hook(9, 1)].y * A[hook(9, 2)].x));

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
  data[hook(12, tid)] = *partial_reduction;
  barrier(0x01);

  if (tid < 16) {
    data[hook(12, tid)] = *partial_reduction = (*partial_reduction) + (data[hook(12, tid + 16)]);
  }
  barrier(0x01);
  if (tid < 8) {
    data[hook(12, tid)] = *partial_reduction = (*partial_reduction) + (data[hook(12, tid + 8)]);
  }
  barrier(0x01);
  if (tid < 4) {
    data[hook(12, tid)] = *partial_reduction = (*partial_reduction) + (data[hook(12, tid + 4)]);
  }
  barrier(0x01);
  if (tid < 2) {
    data[hook(12, tid)] = *partial_reduction = (*partial_reduction) + (data[hook(12, tid + 2)]);
  }
  barrier(0x01);
  if (tid < 1) {
    data[hook(12, tid)] = *partial_reduction = (*partial_reduction) + (data[hook(12, tid + 1)]);
  }
}

kernel void SURF_calcOrientation(global unsigned int* sumTex, int sum_step, int sum_offset, int img_rows, int img_cols, global float* keypoints, int keypoints_step, int keypoints_offset) {
  keypoints_step /= sizeof(*keypoints);

  sum_step /= sizeof(unsigned int);

  global float* featureX = keypoints + 0 * keypoints_step;
  global float* featureY = keypoints + 1 * keypoints_step;
  global float* featureSize = keypoints + 4 * keypoints_step;
  global float* featureDir = keypoints + 5 * keypoints_step;

  local float s_X[113];
  local float s_Y[113];
  local float s_angle[113];

  local float s_sumx[(48 * 2)];
  local float s_sumy[(48 * 2)];
  local float s_mod[(48 * 2)];

  const float s = featureSize[hook(13, get_group_id(0))] * 1.2f / 9.0f;

  const int grad_wav_size = 2 * round(2.0f * s);

  if ((img_rows + 1) < grad_wav_size || (img_cols + 1) < grad_wav_size)
    return;

  const int tid = get_local_id(0);

  if (tid < (48 * 2) - (360 / 5)) {
    s_mod[hook(14, tid + (360 / 5))] = 0.0f;
  }

  float ratio = (float)grad_wav_size / 4;

  int r2 = round(ratio * 2.0f);
  int r4 = round(ratio * 4.0f);
  for (int i = tid; i < 113; i += (360 / 5)) {
    float X = 0.0f, Y = 0.0f, angle = 0.0f;
    const float margin = (float)(grad_wav_size - 1) / 2.0f;
    const int x = round(featureX[hook(15, get_group_id(0))] + c_aptX[hook(16, i)] * s - margin);
    const int y = round(featureY[hook(17, get_group_id(0))] + c_aptY[hook(18, i)] * s - margin);

    if (y >= 0 && y < (img_rows + 1) - grad_wav_size && x >= 0 && x < (img_cols + 1) - grad_wav_size) {
      float apt = c_aptW[hook(19, i)];

      float t00 = read_sumTex_(sumTex, sum_step, img_rows, img_cols, (int2)(x, y));
      float t02 = read_sumTex_(sumTex, sum_step, img_rows, img_cols, (int2)(x, y + r2));
      float t04 = read_sumTex_(sumTex, sum_step, img_rows, img_cols, (int2)(x, y + r4));
      float t20 = read_sumTex_(sumTex, sum_step, img_rows, img_cols, (int2)(x + r2, y));
      float t24 = read_sumTex_(sumTex, sum_step, img_rows, img_cols, (int2)(x + r2, y + r4));
      float t40 = read_sumTex_(sumTex, sum_step, img_rows, img_cols, (int2)(x + r4, y));
      float t42 = read_sumTex_(sumTex, sum_step, img_rows, img_cols, (int2)(x + r4, y + r2));
      float t44 = read_sumTex_(sumTex, sum_step, img_rows, img_cols, (int2)(x + r4, y + r4));

      float t = t00 - t04 - t20 + t24;
      X -= t / ((r2) * (r4));

      t = t20 - t24 - t40 + t44;
      X += t / ((r4 - r2) * (r4));

      t = t00 - t02 - t40 + t42;
      Y += t / ((r2) * (r4));

      t = t02 - t04 - t42 + t44;
      Y -= t / ((r4) * (r4 - r2));

      X = apt * X;
      Y = apt * Y;

      angle = atan2(Y, X);

      if (angle < 0)
        angle += 2.0f * 3.14159265f;
      angle *= 180.0f / 3.14159265f;
    }

    s_X[hook(20, i)] = X;
    s_Y[hook(21, i)] = Y;
    s_angle[hook(22, i)] = angle;
  }
  barrier(0x01);

  float bestx = 0, besty = 0, best_mod = 0;
  float sumx = 0.0f, sumy = 0.0f;
  const int dir = tid * 5;
  for (int i = 0; i < 113; ++i) {
    int angle = round(s_angle[hook(22, i)]);

    int d = abs(angle - dir);
    if (d < 60 / 2 || d > 360 - 60 / 2) {
      sumx += s_X[hook(20, i)];
      sumy += s_Y[hook(21, i)];
    }
  }
  s_sumx[hook(23, tid)] = sumx;
  s_sumy[hook(24, tid)] = sumy;
  s_mod[hook(14, tid)] = sumx * sumx + sumy * sumy;
  barrier(0x01);

  for (int t = 48; t >= 3; t /= 2) {
    if (tid < t) {
      if (s_mod[hook(14, tid)] < s_mod[hook(14, tid + t)]) {
        s_mod[hook(14, tid)] = s_mod[hook(14, tid + t)];
        s_sumx[hook(23, tid)] = s_sumx[hook(23, tid + t)];
        s_sumy[hook(24, tid)] = s_sumy[hook(24, tid + t)];
      }
    }
    barrier(0x01);
  }

  if (tid == 0) {
    int bestIdx = 0;

    if (s_mod[hook(14, 1)] > s_mod[hook(14, bestIdx)])
      bestIdx = 1;
    if (s_mod[hook(14, 2)] > s_mod[hook(14, bestIdx)])
      bestIdx = 2;

    float kp_dir = atan2(s_sumy[hook(24, bestIdx)], s_sumx[hook(23, bestIdx)]);
    if (kp_dir < 0)
      kp_dir += 2.0f * 3.14159265f;
    kp_dir *= 180.0f / 3.14159265f;

    kp_dir = 360.0f - kp_dir;
    if (fabs(kp_dir - 360.f) < 0x1.0p-23f)
      kp_dir = 0.f;

    featureDir[hook(25, get_group_id(0))] = kp_dir;
  }
}