//{"A":15,"H":30,"N9":20,"N9[0]":29,"N9[0][0]":34,"N9[0][1]":28,"N9[0][2]":33,"N9[1]":23,"N9[1][0]":25,"N9[1][1]":22,"N9[1][2]":24,"N9[2]":27,"N9[2][0]":32,"N9[2][1]":26,"N9[2][2]":31,"N9[get_local_id(2)]":19,"N9[get_local_id(2)][get_local_id(1)]":18,"b":17,"c_layer_rows":11,"c_max_features":12,"c_octave":10,"dD":21,"det":0,"det_offset":2,"det_step":1,"featureCounter":7,"featureHessian":40,"featureLaplacian":37,"featureOctave":38,"featureSize":39,"featureX":35,"featureY":36,"imgTex":14,"img_cols":9,"img_rows":8,"keypoints":4,"keypoints_offset":6,"keypoints_step":5,"maxPosBuffer":3,"sumTex":13,"x":16}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
__inline unsigned int read_sumTex_(global unsigned int* sumTex, int sum_step, int img_rows, int img_cols, int2 coord) {
  int x = clamp(coord.x, 0, img_cols);
  int y = clamp(coord.y, 0, img_rows);
  return sumTex[hook(13, sum_step * y + x)];
}

__inline uchar read_imgTex_(global uchar* imgTex, int img_step, int img_rows, int img_cols, float2 coord) {
  int x = clamp(convert_int_rte(coord.x), 0, img_cols - 1);
  int y = clamp(convert_int_rte(coord.y), 0, img_rows - 1);
  return imgTex[hook(14, img_step * y + x)];
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
  float det = A[hook(15, 0)].x * (A[hook(15, 1)].y * A[hook(15, 2)].z - A[hook(15, 1)].z * A[hook(15, 2)].y) - A[hook(15, 0)].y * (A[hook(15, 1)].x * A[hook(15, 2)].z - A[hook(15, 1)].z * A[hook(15, 2)].x) + A[hook(15, 0)].z * (A[hook(15, 1)].x * A[hook(15, 2)].y - A[hook(15, 1)].y * A[hook(15, 2)].x);

  if (det != 0) {
    float invdet = 1.0f / det;

    x[hook(16, 0)] = invdet * (b[hook(17, 0)] * (A[hook(15, 1)].y * A[hook(15, 2)].z - A[hook(15, 1)].z * A[hook(15, 2)].y) - A[hook(15, 0)].y * (b[hook(17, 1)] * A[hook(15, 2)].z - A[hook(15, 1)].z * b[hook(17, 2)]) + A[hook(15, 0)].z * (b[hook(17, 1)] * A[hook(15, 2)].y - A[hook(15, 1)].y * b[hook(17, 2)]));

    x[hook(16, 1)] = invdet * (A[hook(15, 0)].x * (b[hook(17, 1)] * A[hook(15, 2)].z - A[hook(15, 1)].z * b[hook(17, 2)]) - b[hook(17, 0)] * (A[hook(15, 1)].x * A[hook(15, 2)].z - A[hook(15, 1)].z * A[hook(15, 2)].x) + A[hook(15, 0)].z * (A[hook(15, 1)].x * b[hook(17, 2)] - b[hook(17, 1)] * A[hook(15, 2)].x));

    x[hook(16, 2)] = invdet * (A[hook(15, 0)].x * (A[hook(15, 1)].y * b[hook(17, 2)] - b[hook(17, 1)] * A[hook(15, 2)].y) - A[hook(15, 0)].y * (A[hook(15, 1)].x * b[hook(17, 2)] - b[hook(17, 1)] * A[hook(15, 2)].x) + b[hook(17, 0)] * (A[hook(15, 1)].x * A[hook(15, 2)].y - A[hook(15, 1)].y * A[hook(15, 2)].x));

    return true;
  }
  return false;
}
kernel void SURF_interpolateKeypoint(global const float* det, int det_step, int det_offset, global const int4* maxPosBuffer, global float* keypoints, int keypoints_step, int keypoints_offset, volatile global int* featureCounter, int img_rows, int img_cols, int c_octave, int c_layer_rows, int c_max_features) {
  det_step /= sizeof(*det);
  keypoints_step /= sizeof(*keypoints);
  global float* featureX = keypoints + 0 * keypoints_step;
  global float* featureY = keypoints + 1 * keypoints_step;
  global int* featureLaplacian = (global int*)keypoints + 2 * keypoints_step;
  global int* featureOctave = (global int*)keypoints + 3 * keypoints_step;
  global float* featureSize = keypoints + 4 * keypoints_step;
  global float* featureHessian = keypoints + 6 * keypoints_step;

  const int4 maxPos = maxPosBuffer[hook(3, get_group_id(0))];

  const int j = maxPos.x - 1 + get_local_id(0);
  const int i = maxPos.y - 1 + get_local_id(1);
  const int layer = maxPos.z - 1 + get_local_id(2);

  volatile local float N9[3][3][3];

  N9[hook(20, get_local_id(2))][hook(19, get_local_id(1))][hook(18, get_local_id(0))] = det[hook(0, det_step * (c_layer_rows * layer + i) + j)];
  barrier(0x01);

  if (get_local_id(0) == 0 && get_local_id(1) == 0 && get_local_id(2) == 0) {
    float dD[3];

    dD[hook(21, 0)] = -0.5f * (N9[hook(20, 1)][hook(23, 1)][hook(22, 2)] - N9[hook(20, 1)][hook(23, 1)][hook(22, 0)]);

    dD[hook(21, 1)] = -0.5f * (N9[hook(20, 1)][hook(23, 2)][hook(24, 1)] - N9[hook(20, 1)][hook(23, 0)][hook(25, 1)]);

    dD[hook(21, 2)] = -0.5f * (N9[hook(20, 2)][hook(27, 1)][hook(26, 1)] - N9[hook(20, 0)][hook(29, 1)][hook(28, 1)]);

    float4 H[3];

    H[hook(30, 0)].x = N9[hook(20, 1)][hook(23, 1)][hook(22, 0)] - 2.0f * N9[hook(20, 1)][hook(23, 1)][hook(22, 1)] + N9[hook(20, 1)][hook(23, 1)][hook(22, 2)];

    H[hook(30, 0)].y = 0.25f * (N9[hook(20, 1)][hook(23, 2)][hook(24, 2)] - N9[hook(20, 1)][hook(23, 2)][hook(24, 0)] - N9[hook(20, 1)][hook(23, 0)][hook(25, 2)] + N9[hook(20, 1)][hook(23, 0)][hook(25, 0)]);

    H[hook(30, 0)].z = 0.25f * (N9[hook(20, 2)][hook(27, 1)][hook(26, 2)] - N9[hook(20, 2)][hook(27, 1)][hook(26, 0)] - N9[hook(20, 0)][hook(29, 1)][hook(28, 2)] + N9[hook(20, 0)][hook(29, 1)][hook(28, 0)]);

    H[hook(30, 1)].x = H[hook(30, 0)].y;

    H[hook(30, 1)].y = N9[hook(20, 1)][hook(23, 0)][hook(25, 1)] - 2.0f * N9[hook(20, 1)][hook(23, 1)][hook(22, 1)] + N9[hook(20, 1)][hook(23, 2)][hook(24, 1)];

    H[hook(30, 1)].z = 0.25f * (N9[hook(20, 2)][hook(27, 2)][hook(31, 1)] - N9[hook(20, 2)][hook(27, 0)][hook(32, 1)] - N9[hook(20, 0)][hook(29, 2)][hook(33, 1)] + N9[hook(20, 0)][hook(29, 0)][hook(34, 1)]);

    H[hook(30, 2)].x = H[hook(30, 0)].z;

    H[hook(30, 2)].y = H[hook(30, 1)].z;

    H[hook(30, 2)].z = N9[hook(20, 0)][hook(29, 1)][hook(28, 1)] - 2.0f * N9[hook(20, 1)][hook(23, 1)][hook(22, 1)] + N9[hook(20, 2)][hook(27, 1)][hook(26, 1)];

    float x[3];

    if (solve3x3_float(H, dD, x)) {
      if (fabs(x[hook(16, 0)]) <= 1.f && fabs(x[hook(16, 1)]) <= 1.f && fabs(x[hook(16, 2)]) <= 1.f) {
        const int size = calcSize(c_octave, maxPos.z);

        const int sum_i = (maxPos.y - ((size >> 1) >> c_octave)) << c_octave;
        const int sum_j = (maxPos.x - ((size >> 1) >> c_octave)) << c_octave;

        const float center_i = sum_i + (float)(size - 1) / 2;
        const float center_j = sum_j + (float)(size - 1) / 2;

        const float px = center_j + x[hook(16, 0)] * (1 << c_octave);
        const float py = center_i + x[hook(16, 1)] * (1 << c_octave);

        const int ds = size - calcSize(c_octave, maxPos.z - 1);
        const float psize = round(size + x[hook(16, 2)] * ds);

        const float s = psize * 1.2f / 9.0f;

        const int grad_wav_size = 2 * round(2.0f * s);

        if ((img_rows + 1) >= grad_wav_size && (img_cols + 1) >= grad_wav_size) {
          int ind = atomic_inc(featureCounter);

          if (ind < c_max_features) {
            featureX[hook(35, ind)] = px;
            featureY[hook(36, ind)] = py;
            featureLaplacian[hook(37, ind)] = maxPos.w;
            featureOctave[hook(38, ind)] = c_octave;
            featureSize[hook(39, ind)] = psize;
            featureHessian[hook(40, ind)] = N9[hook(20, 1)][hook(23, 1)][hook(22, 1)];
          }
        }
      }
    }
  }
}