//{"N9":19,"c_DM":18,"c_hessianThreshold":14,"c_img_cols":8,"c_img_rows":7,"c_layer_cols":12,"c_layer_rows":11,"c_max_candidates":13,"c_nOctaveLayers":9,"c_octave":10,"counter_offset":4,"det":0,"det_step":5,"maskSumTex":15,"mask_step":16,"maxCounter":3,"maxPosBuffer":2,"src":17,"trace":1,"trace_step":6}
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

  int2 dx1 = convert_int2(round(ratio * src[hook(17, 0)]));
  int2 dy1 = convert_int2(round(ratio * src[hook(17, 1)]));
  int2 dx2 = convert_int2(round(ratio * src[hook(17, 2)]));
  int2 dy2 = convert_int2(round(ratio * src[hook(17, 3)]));

  float t = 0;
  t += read_sumTex(sumTex, sampler, (int2)(x + dx1.x, y + dy1.x), rows, cols, elemPerRow);
  t -= read_sumTex(sumTex, sampler, (int2)(x + dx1.x, y + dy2.x), rows, cols, elemPerRow);
  t -= read_sumTex(sumTex, sampler, (int2)(x + dx2.x, y + dy1.x), rows, cols, elemPerRow);
  t += read_sumTex(sumTex, sampler, (int2)(x + dx2.x, y + dy2.x), rows, cols, elemPerRow);
  d += t * src[hook(17, 4)].x / ((dx2.x - dx1.x) * (dy2.x - dy1.x));

  t = 0;
  t += read_sumTex(sumTex, sampler, (int2)(x + dx1.y, y + dy1.y), rows, cols, elemPerRow);
  t -= read_sumTex(sumTex, sampler, (int2)(x + dx1.y, y + dy2.y), rows, cols, elemPerRow);
  t -= read_sumTex(sumTex, sampler, (int2)(x + dx2.y, y + dy1.y), rows, cols, elemPerRow);
  t += read_sumTex(sumTex, sampler, (int2)(x + dx2.y, y + dy2.y), rows, cols, elemPerRow);
  d += t * src[hook(17, 4)].y / ((dx2.y - dx1.y) * (dy2.y - dy1.y));

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

  int dx1 = round(ratio * c_DM[hook(18, 0)]);
  int dy1 = round(ratio * c_DM[hook(18, 1)]);
  int dx2 = round(ratio * c_DM[hook(18, 2)]);
  int dy2 = round(ratio * c_DM[hook(18, 3)]);

  float t = 0;

  t += read_sumTex(maskSumTex, sampler, (int2)(sum_j + dx1, sum_i + dy1), rows, cols, step);
  t -= read_sumTex(maskSumTex, sampler, (int2)(sum_j + dx1, sum_i + dy2), rows, cols, step);
  t -= read_sumTex(maskSumTex, sampler, (int2)(sum_j + dx2, sum_i + dy1), rows, cols, step);
  t += read_sumTex(maskSumTex, sampler, (int2)(sum_j + dx2, sum_i + dy2), rows, cols, step);

  d += t * c_DM[hook(18, 4)] / ((dx2 - dx1) * (dy2 - dy1));

  return (d >= 0.5f);
}

kernel void icvFindMaximaInLayer_withmask(global const float* det, global const float* trace, global int4* maxPosBuffer, volatile global int* maxCounter, int counter_offset, int det_step, int trace_step, int c_img_rows, int c_img_cols, int c_nOctaveLayers, int c_octave, int c_layer_rows, int c_layer_cols, int c_max_candidates, float c_hessianThreshold, image2d_t maskSumTex, int mask_step) {
  volatile local float N9[768];

  det_step /= sizeof(*det);
  trace_step /= sizeof(*trace);
  maxCounter += counter_offset;
  mask_step /= sizeof(unsigned int);

  const int gridDim_y = get_num_groups(1) / c_nOctaveLayers;
  const int blockIdx_y = get_group_id(1) % gridDim_y;
  const int blockIdx_z = get_group_id(1) / gridDim_y;

  const int layer = blockIdx_z + 1;

  const int size = calcSize(c_octave, layer);

  const int margin = ((calcSize(c_octave, layer + 1) >> 1) >> c_octave) + 1;

  const int j = get_local_id(0) + get_group_id(0) * (get_local_size(0) - 2) + margin - 1;
  const int i = get_local_id(1) + blockIdx_y * (get_local_size(1) - 2) + margin - 1;

  const int zoff = get_local_size(0) * get_local_size(1);
  const int localLin = get_local_id(0) + get_local_id(1) * get_local_size(0) + zoff;
  N9[hook(19, localLin - zoff)] = det[hook(0, det_step * (c_layer_rows * (layer - 1) + min(max(i, 0), c_img_rows - 1)) + min(max(j, 0), c_img_cols - 1))];
  N9[hook(19, localLin)] = det[hook(0, det_step * (c_layer_rows * (layer) + min(max(i, 0), c_img_rows - 1)) + min(max(j, 0), c_img_cols - 1))];
  N9[hook(19, localLin + zoff)] = det[hook(0, det_step * (c_layer_rows * (layer + 1) + min(max(i, 0), c_img_rows - 1)) + min(max(j, 0), c_img_cols - 1))];

  barrier(0x01);

  if (i < c_layer_rows - margin && j < c_layer_cols - margin && get_local_id(0) > 0 && get_local_id(0) < get_local_size(0) - 1 && get_local_id(1) > 0 && get_local_id(1) < get_local_size(1) - 1) {
    float val0 = N9[hook(19, localLin)];

    if (val0 > c_hessianThreshold) {
      const int sum_i = (i - ((size >> 1) >> c_octave)) << c_octave;
      const int sum_j = (j - ((size >> 1) >> c_octave)) << c_octave;

      if (within_check(maskSumTex, sum_i, sum_j, size, c_img_rows, c_img_cols, mask_step)) {
        const bool condmax = val0 > N9[hook(19, localLin - 1 - get_local_size(0) - zoff)] && val0 > N9[hook(19, localLin - get_local_size(0) - zoff)] && val0 > N9[hook(19, localLin + 1 - get_local_size(0) - zoff)] && val0 > N9[hook(19, localLin - 1 - zoff)] && val0 > N9[hook(19, localLin - zoff)] && val0 > N9[hook(19, localLin + 1 - zoff)] && val0 > N9[hook(19, localLin - 1 + get_local_size(0) - zoff)] && val0 > N9[hook(19, localLin + get_local_size(0) - zoff)] && val0 > N9[hook(19, localLin + 1 + get_local_size(0) - zoff)]

                             && val0 > N9[hook(19, localLin - 1 - get_local_size(0))] && val0 > N9[hook(19, localLin - get_local_size(0))] && val0 > N9[hook(19, localLin + 1 - get_local_size(0))] && val0 > N9[hook(19, localLin - 1)] && val0 > N9[hook(19, localLin + 1)] && val0 > N9[hook(19, localLin - 1 + get_local_size(0))] && val0 > N9[hook(19, localLin + get_local_size(0))] && val0 > N9[hook(19, localLin + 1 + get_local_size(0))]

                             && val0 > N9[hook(19, localLin - 1 - get_local_size(0) + zoff)] && val0 > N9[hook(19, localLin - get_local_size(0) + zoff)] && val0 > N9[hook(19, localLin + 1 - get_local_size(0) + zoff)] && val0 > N9[hook(19, localLin - 1 + zoff)] && val0 > N9[hook(19, localLin + zoff)] && val0 > N9[hook(19, localLin + 1 + zoff)] && val0 > N9[hook(19, localLin - 1 + get_local_size(0) + zoff)] && val0 > N9[hook(19, localLin + get_local_size(0) + zoff)] && val0 > N9[hook(19, localLin + 1 + get_local_size(0) + zoff)];

        if (condmax) {
          int ind = atomic_inc(maxCounter);

          if (ind < c_max_candidates) {
            const int laplacian = (int)copysign(1.0f, trace[hook(1, trace_step * (layer * c_layer_rows + i) + j)]);

            maxPosBuffer[hook(2, ind)] = (int4)(j, i, layer, laplacian);
          }
        }
      }
    }
  }
}