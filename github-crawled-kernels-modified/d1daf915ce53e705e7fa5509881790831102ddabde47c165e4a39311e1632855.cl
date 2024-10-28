//{"c_img_cols":6,"c_img_rows":5,"c_layer_rows":9,"c_nOctaveLayers":7,"c_octave":8,"det":1,"det_step":3,"src":11,"sumTex":0,"sumTex_step":10,"trace":2,"trace_step":4}
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

kernel void icvCalcLayerDetAndTrace(image2d_t sumTex, global float* det, global float* trace, int det_step, int trace_step, int c_img_rows, int c_img_cols, int c_nOctaveLayers, int c_octave, int c_layer_rows, int sumTex_step) {
  det_step /= sizeof(*det);
  trace_step /= sizeof(*trace);
  sumTex_step /= sizeof(unsigned int);

  const int gridDim_y = get_num_groups(1) / (c_nOctaveLayers + 2);
  const int blockIdx_y = get_group_id(1) % gridDim_y;
  const int blockIdx_z = get_group_id(1) / gridDim_y;

  const int j = get_local_id(0) + get_group_id(0) * get_local_size(0);
  const int i = get_local_id(1) + blockIdx_y * get_local_size(1);
  const int layer = blockIdx_z;

  const int size = calcSize(c_octave, layer);

  const int samples_i = 1 + ((c_img_rows - size) >> c_octave);
  const int samples_j = 1 + ((c_img_cols - size) >> c_octave);

  const int margin = (size >> 1) >> c_octave;

  if (size <= c_img_rows && size <= c_img_cols && i < samples_i && j < samples_j) {
    int x = j << c_octave;
    int y = i << c_octave;

    float ratio = (float)size / 9;

    int r1 = round(ratio);
    int r2 = round(ratio * 2.0f);
    int r3 = round(ratio * 3.0f);
    int r4 = round(ratio * 4.0f);
    int r5 = round(ratio * 5.0f);
    int r6 = round(ratio * 6.0f);
    int r7 = round(ratio * 7.0f);
    int r8 = round(ratio * 8.0f);
    int r9 = round(ratio * 9.0f);

    float d = 0;
    {
      int t02 = read_sumTex(sumTex, sampler, (int2)(x, y + r2), c_img_rows, c_img_cols, sumTex_step);
      int t07 = read_sumTex(sumTex, sampler, (int2)(x, y + r7), c_img_rows, c_img_cols, sumTex_step);
      int t32 = read_sumTex(sumTex, sampler, (int2)(x + r3, y + r2), c_img_rows, c_img_cols, sumTex_step);
      int t37 = read_sumTex(sumTex, sampler, (int2)(x + r3, y + r7), c_img_rows, c_img_cols, sumTex_step);
      int t62 = read_sumTex(sumTex, sampler, (int2)(x + r6, y + r2), c_img_rows, c_img_cols, sumTex_step);
      int t67 = read_sumTex(sumTex, sampler, (int2)(x + r6, y + r7), c_img_rows, c_img_cols, sumTex_step);
      int t92 = read_sumTex(sumTex, sampler, (int2)(x + r9, y + r2), c_img_rows, c_img_cols, sumTex_step);
      int t97 = read_sumTex(sumTex, sampler, (int2)(x + r9, y + r7), c_img_rows, c_img_cols, sumTex_step);

      d = calcAxisAlignedDerivative(t02, t07, t32, t37, (r3) * (r7 - r2), t62, t67, t92, t97, (r9 - r6) * (r7 - r2), t32, t37, t62, t67, (r6 - r3) * (r7 - r2));
    }
    const float dx = (float)d;

    d = 0;
    {
      int t20 = read_sumTex(sumTex, sampler, (int2)(x + r2, y), c_img_rows, c_img_cols, sumTex_step);
      int t23 = read_sumTex(sumTex, sampler, (int2)(x + r2, y + r3), c_img_rows, c_img_cols, sumTex_step);
      int t70 = read_sumTex(sumTex, sampler, (int2)(x + r7, y), c_img_rows, c_img_cols, sumTex_step);
      int t73 = read_sumTex(sumTex, sampler, (int2)(x + r7, y + r3), c_img_rows, c_img_cols, sumTex_step);
      int t26 = read_sumTex(sumTex, sampler, (int2)(x + r2, y + r6), c_img_rows, c_img_cols, sumTex_step);
      int t76 = read_sumTex(sumTex, sampler, (int2)(x + r7, y + r6), c_img_rows, c_img_cols, sumTex_step);
      int t29 = read_sumTex(sumTex, sampler, (int2)(x + r2, y + r9), c_img_rows, c_img_cols, sumTex_step);
      int t79 = read_sumTex(sumTex, sampler, (int2)(x + r7, y + r9), c_img_rows, c_img_cols, sumTex_step);

      d = calcAxisAlignedDerivative(t20, t23, t70, t73, (r7 - r2) * (r3), t26, t29, t76, t79, (r7 - r2) * (r9 - r6), t23, t26, t73, t76, (r7 - r2) * (r6 - r3));
    }
    const float dy = (float)d;

    d = 0;
    {
      float t = 0;
      t += read_sumTex(sumTex, sampler, (int2)(x + r1, y + r1), c_img_rows, c_img_cols, sumTex_step);
      t -= read_sumTex(sumTex, sampler, (int2)(x + r1, y + r4), c_img_rows, c_img_cols, sumTex_step);
      t -= read_sumTex(sumTex, sampler, (int2)(x + r4, y + r1), c_img_rows, c_img_cols, sumTex_step);
      t += read_sumTex(sumTex, sampler, (int2)(x + r4, y + r4), c_img_rows, c_img_cols, sumTex_step);
      d += t / ((r4 - r1) * (r4 - r1));

      t = 0;
      t += read_sumTex(sumTex, sampler, (int2)(x + r5, y + r1), c_img_rows, c_img_cols, sumTex_step);
      t -= read_sumTex(sumTex, sampler, (int2)(x + r5, y + r4), c_img_rows, c_img_cols, sumTex_step);
      t -= read_sumTex(sumTex, sampler, (int2)(x + r8, y + r1), c_img_rows, c_img_cols, sumTex_step);
      t += read_sumTex(sumTex, sampler, (int2)(x + r8, y + r4), c_img_rows, c_img_cols, sumTex_step);
      d -= t / ((r8 - r5) * (r4 - r1));

      t = 0;
      t += read_sumTex(sumTex, sampler, (int2)(x + r1, y + r5), c_img_rows, c_img_cols, sumTex_step);
      t -= read_sumTex(sumTex, sampler, (int2)(x + r1, y + r8), c_img_rows, c_img_cols, sumTex_step);
      t -= read_sumTex(sumTex, sampler, (int2)(x + r4, y + r5), c_img_rows, c_img_cols, sumTex_step);
      t += read_sumTex(sumTex, sampler, (int2)(x + r4, y + r8), c_img_rows, c_img_cols, sumTex_step);
      d -= t / ((r4 - r1) * (r8 - r5));

      t = 0;
      t += read_sumTex(sumTex, sampler, (int2)(x + r5, y + r5), c_img_rows, c_img_cols, sumTex_step);
      t -= read_sumTex(sumTex, sampler, (int2)(x + r5, y + r8), c_img_rows, c_img_cols, sumTex_step);
      t -= read_sumTex(sumTex, sampler, (int2)(x + r8, y + r5), c_img_rows, c_img_cols, sumTex_step);
      t += read_sumTex(sumTex, sampler, (int2)(x + r8, y + r8), c_img_rows, c_img_cols, sumTex_step);
      d += t / ((r8 - r5) * (r8 - r5));
    }
    const float dxy = (float)d;

    det[hook(1, j + margin + det_step * (layer * c_layer_rows + i + margin))] = dx * dy - 0.81f * dxy * dxy;
    trace[hook(2, j + margin + trace_step * (layer * c_layer_rows + i + margin))] = dx + dy;
  }
}