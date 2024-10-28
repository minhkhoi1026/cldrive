//{"A":13,"H":28,"N9":18,"N9[0]":27,"N9[0][0]":32,"N9[0][1]":26,"N9[0][2]":31,"N9[1]":21,"N9[1][0]":23,"N9[1][1]":20,"N9[1][2]":22,"N9[2]":25,"N9[2][0]":30,"N9[2][1]":24,"N9[2][2]":29,"N9[get_local_id(2)]":17,"N9[get_local_id(2)][get_local_id(1)]":16,"b":15,"c_DM":12,"c_img_cols":7,"c_img_rows":6,"c_layer_rows":9,"c_max_features":10,"c_octave":8,"dD":19,"det":0,"det_step":4,"featureCounter":3,"featureHessian":38,"featureLaplacian":35,"featureOctave":36,"featureSize":37,"featureX":33,"featureY":34,"keypoints":2,"keypoints_step":5,"maxPosBuffer":1,"src":11,"x":14}
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

  int2 dx1 = convert_int2(round(ratio * src[hook(11, 0)]));
  int2 dy1 = convert_int2(round(ratio * src[hook(11, 1)]));
  int2 dx2 = convert_int2(round(ratio * src[hook(11, 2)]));
  int2 dy2 = convert_int2(round(ratio * src[hook(11, 3)]));

  float t = 0;
  t += read_sumTex(sumTex, sampler, (int2)(x + dx1.x, y + dy1.x), rows, cols, elemPerRow);
  t -= read_sumTex(sumTex, sampler, (int2)(x + dx1.x, y + dy2.x), rows, cols, elemPerRow);
  t -= read_sumTex(sumTex, sampler, (int2)(x + dx2.x, y + dy1.x), rows, cols, elemPerRow);
  t += read_sumTex(sumTex, sampler, (int2)(x + dx2.x, y + dy2.x), rows, cols, elemPerRow);
  d += t * src[hook(11, 4)].x / ((dx2.x - dx1.x) * (dy2.x - dy1.x));

  t = 0;
  t += read_sumTex(sumTex, sampler, (int2)(x + dx1.y, y + dy1.y), rows, cols, elemPerRow);
  t -= read_sumTex(sumTex, sampler, (int2)(x + dx1.y, y + dy2.y), rows, cols, elemPerRow);
  t -= read_sumTex(sumTex, sampler, (int2)(x + dx2.y, y + dy1.y), rows, cols, elemPerRow);
  t += read_sumTex(sumTex, sampler, (int2)(x + dx2.y, y + dy2.y), rows, cols, elemPerRow);
  d += t * src[hook(11, 4)].y / ((dx2.y - dx1.y) * (dy2.y - dy1.y));

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

  int dx1 = round(ratio * c_DM[hook(12, 0)]);
  int dy1 = round(ratio * c_DM[hook(12, 1)]);
  int dx2 = round(ratio * c_DM[hook(12, 2)]);
  int dy2 = round(ratio * c_DM[hook(12, 3)]);

  float t = 0;

  t += read_sumTex(maskSumTex, sampler, (int2)(sum_j + dx1, sum_i + dy1), rows, cols, step);
  t -= read_sumTex(maskSumTex, sampler, (int2)(sum_j + dx1, sum_i + dy2), rows, cols, step);
  t -= read_sumTex(maskSumTex, sampler, (int2)(sum_j + dx2, sum_i + dy1), rows, cols, step);
  t += read_sumTex(maskSumTex, sampler, (int2)(sum_j + dx2, sum_i + dy2), rows, cols, step);

  d += t * c_DM[hook(12, 4)] / ((dx2 - dx1) * (dy2 - dy1));

  return (d >= 0.5f);
}

inline bool solve3x3_float(const float4* A, const float* b, float* x) {
  float det = A[hook(13, 0)].x * (A[hook(13, 1)].y * A[hook(13, 2)].z - A[hook(13, 1)].z * A[hook(13, 2)].y) - A[hook(13, 0)].y * (A[hook(13, 1)].x * A[hook(13, 2)].z - A[hook(13, 1)].z * A[hook(13, 2)].x) + A[hook(13, 0)].z * (A[hook(13, 1)].x * A[hook(13, 2)].y - A[hook(13, 1)].y * A[hook(13, 2)].x);

  if (det != 0) {
    float invdet = 1.0 / det;

    x[hook(14, 0)] = invdet * (b[hook(15, 0)] * (A[hook(13, 1)].y * A[hook(13, 2)].z - A[hook(13, 1)].z * A[hook(13, 2)].y) - A[hook(13, 0)].y * (b[hook(15, 1)] * A[hook(13, 2)].z - A[hook(13, 1)].z * b[hook(15, 2)]) + A[hook(13, 0)].z * (b[hook(15, 1)] * A[hook(13, 2)].y - A[hook(13, 1)].y * b[hook(15, 2)]));

    x[hook(14, 1)] = invdet * (A[hook(13, 0)].x * (b[hook(15, 1)] * A[hook(13, 2)].z - A[hook(13, 1)].z * b[hook(15, 2)]) - b[hook(15, 0)] * (A[hook(13, 1)].x * A[hook(13, 2)].z - A[hook(13, 1)].z * A[hook(13, 2)].x) + A[hook(13, 0)].z * (A[hook(13, 1)].x * b[hook(15, 2)] - b[hook(15, 1)] * A[hook(13, 2)].x));

    x[hook(14, 2)] = invdet * (A[hook(13, 0)].x * (A[hook(13, 1)].y * b[hook(15, 2)] - b[hook(15, 1)] * A[hook(13, 2)].y) - A[hook(13, 0)].y * (A[hook(13, 1)].x * b[hook(15, 2)] - b[hook(15, 1)] * A[hook(13, 2)].x) + b[hook(15, 0)] * (A[hook(13, 1)].x * A[hook(13, 2)].y - A[hook(13, 1)].y * A[hook(13, 2)].x));

    return true;
  }
  return false;
}
kernel void icvInterpolateKeypoint(global const float* det, global const int4* maxPosBuffer, global float* keypoints, volatile global int* featureCounter, int det_step, int keypoints_step, int c_img_rows, int c_img_cols, int c_octave, int c_layer_rows, int c_max_features) {
  det_step /= sizeof(*det);
  keypoints_step /= sizeof(*keypoints);
  global float* featureX = keypoints + 0 * keypoints_step;
  global float* featureY = keypoints + 1 * keypoints_step;
  global int* featureLaplacian = (global int*)keypoints + 2 * keypoints_step;
  global int* featureOctave = (global int*)keypoints + 3 * keypoints_step;
  global float* featureSize = keypoints + 4 * keypoints_step;
  global float* featureHessian = keypoints + 6 * keypoints_step;

  const int4 maxPos = maxPosBuffer[hook(1, get_group_id(0))];

  const int j = maxPos.x - 1 + get_local_id(0);
  const int i = maxPos.y - 1 + get_local_id(1);
  const int layer = maxPos.z - 1 + get_local_id(2);

  volatile local float N9[3][3][3];

  N9[hook(18, get_local_id(2))][hook(17, get_local_id(1))][hook(16, get_local_id(0))] = det[hook(0, det_step * (c_layer_rows * layer + i) + j)];
  barrier(0x01);

  if (get_local_id(0) == 0 && get_local_id(1) == 0 && get_local_id(2) == 0) {
    float dD[3];

    dD[hook(19, 0)] = -0.5f * (N9[hook(18, 1)][hook(21, 1)][hook(20, 2)] - N9[hook(18, 1)][hook(21, 1)][hook(20, 0)]);

    dD[hook(19, 1)] = -0.5f * (N9[hook(18, 1)][hook(21, 2)][hook(22, 1)] - N9[hook(18, 1)][hook(21, 0)][hook(23, 1)]);

    dD[hook(19, 2)] = -0.5f * (N9[hook(18, 2)][hook(25, 1)][hook(24, 1)] - N9[hook(18, 0)][hook(27, 1)][hook(26, 1)]);

    float4 H[3];

    H[hook(28, 0)].x = N9[hook(18, 1)][hook(21, 1)][hook(20, 0)] - 2.0f * N9[hook(18, 1)][hook(21, 1)][hook(20, 1)] + N9[hook(18, 1)][hook(21, 1)][hook(20, 2)];

    H[hook(28, 0)].y = 0.25f * (N9[hook(18, 1)][hook(21, 2)][hook(22, 2)] - N9[hook(18, 1)][hook(21, 2)][hook(22, 0)] - N9[hook(18, 1)][hook(21, 0)][hook(23, 2)] + N9[hook(18, 1)][hook(21, 0)][hook(23, 0)]);

    H[hook(28, 0)].z = 0.25f * (N9[hook(18, 2)][hook(25, 1)][hook(24, 2)] - N9[hook(18, 2)][hook(25, 1)][hook(24, 0)] - N9[hook(18, 0)][hook(27, 1)][hook(26, 2)] + N9[hook(18, 0)][hook(27, 1)][hook(26, 0)]);

    H[hook(28, 1)].x = H[hook(28, 0)].y;

    H[hook(28, 1)].y = N9[hook(18, 1)][hook(21, 0)][hook(23, 1)] - 2.0f * N9[hook(18, 1)][hook(21, 1)][hook(20, 1)] + N9[hook(18, 1)][hook(21, 2)][hook(22, 1)];

    H[hook(28, 1)].z = 0.25f * (N9[hook(18, 2)][hook(25, 2)][hook(29, 1)] - N9[hook(18, 2)][hook(25, 0)][hook(30, 1)] - N9[hook(18, 0)][hook(27, 2)][hook(31, 1)] + N9[hook(18, 0)][hook(27, 0)][hook(32, 1)]);

    H[hook(28, 2)].x = H[hook(28, 0)].z;

    H[hook(28, 2)].y = H[hook(28, 1)].z;

    H[hook(28, 2)].z = N9[hook(18, 0)][hook(27, 1)][hook(26, 1)] - 2.0f * N9[hook(18, 1)][hook(21, 1)][hook(20, 1)] + N9[hook(18, 2)][hook(25, 1)][hook(24, 1)];

    float x[3];

    if (solve3x3_float(H, dD, x)) {
      if (fabs(x[hook(14, 0)]) <= 1.f && fabs(x[hook(14, 1)]) <= 1.f && fabs(x[hook(14, 2)]) <= 1.f) {
        const int size = calcSize(c_octave, maxPos.z);

        const int sum_i = (maxPos.y - ((size >> 1) >> c_octave)) << c_octave;
        const int sum_j = (maxPos.x - ((size >> 1) >> c_octave)) << c_octave;

        const float center_i = sum_i + (float)(size - 1) / 2;
        const float center_j = sum_j + (float)(size - 1) / 2;

        const float px = center_j + x[hook(14, 0)] * (1 << c_octave);
        const float py = center_i + x[hook(14, 1)] * (1 << c_octave);

        const int ds = size - calcSize(c_octave, maxPos.z - 1);
        const float psize = round(size + x[hook(14, 2)] * ds);

        const float s = psize * 1.2f / 9.0f;

        const int grad_wav_size = 2 * round(2.0f * s);

        if ((c_img_rows + 1) >= grad_wav_size && (c_img_cols + 1) >= grad_wav_size) {
          int ind = atomic_inc(featureCounter);

          if (ind < c_max_features) {
            featureX[hook(33, ind)] = px;
            featureY[hook(34, ind)] = py;
            featureLaplacian[hook(35, ind)] = maxPos.w;
            featureOctave[hook(36, ind)] = c_octave;
            featureSize[hook(37, ind)] = psize;
            featureHessian[hook(38, ind)] = N9[hook(18, 1)][hook(21, 1)][hook(20, 1)];
          }
        }
      }
    }
  }
}