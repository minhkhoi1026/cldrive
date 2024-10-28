//{"c_layer_rows":7,"c_nOctaveLayers":5,"c_octave":6,"det":8,"det_offset":10,"det_step":9,"imgTex":14,"img_cols":4,"img_rows":3,"sumTex":0,"sum_offset":2,"sum_step":1,"trace":11,"trace_offset":13,"trace_step":12}
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

kernel void SURF_calcLayerDetAndTrace(global unsigned int* sumTex, int sum_step, int sum_offset, int img_rows, int img_cols, int c_nOctaveLayers, int c_octave, int c_layer_rows,

                                      global float* det, int det_step, int det_offset, global float* trace, int trace_step, int trace_offset) {
  det_step /= sizeof(*det);
  trace_step /= sizeof(*trace);

  sum_step /= sizeof(unsigned int);

  const int gridDim_y = get_num_groups(1) / (c_nOctaveLayers + 2);
  const int blockIdx_y = get_group_id(1) % gridDim_y;
  const int blockIdx_z = get_group_id(1) / gridDim_y;

  const int j = get_local_id(0) + get_group_id(0) * get_local_size(0);
  const int i = get_local_id(1) + blockIdx_y * get_local_size(1);
  const int layer = blockIdx_z;

  const int size = calcSize(c_octave, layer);

  const int samples_i = 1 + ((img_rows - size) >> c_octave);
  const int samples_j = 1 + ((img_cols - size) >> c_octave);

  const int margin = (size >> 1) >> c_octave;

  if (size <= img_rows && size <= img_cols && i < samples_i && j < samples_j) {
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
      int t02 = read_sumTex_(sumTex, sum_step, img_rows, img_cols, (int2)(x, y + r2));
      int t07 = read_sumTex_(sumTex, sum_step, img_rows, img_cols, (int2)(x, y + r7));
      int t32 = read_sumTex_(sumTex, sum_step, img_rows, img_cols, (int2)(x + r3, y + r2));
      int t37 = read_sumTex_(sumTex, sum_step, img_rows, img_cols, (int2)(x + r3, y + r7));
      int t62 = read_sumTex_(sumTex, sum_step, img_rows, img_cols, (int2)(x + r6, y + r2));
      int t67 = read_sumTex_(sumTex, sum_step, img_rows, img_cols, (int2)(x + r6, y + r7));
      int t92 = read_sumTex_(sumTex, sum_step, img_rows, img_cols, (int2)(x + r9, y + r2));
      int t97 = read_sumTex_(sumTex, sum_step, img_rows, img_cols, (int2)(x + r9, y + r7));

      d = calcAxisAlignedDerivative(t02, t07, t32, t37, (r3) * (r7 - r2), t62, t67, t92, t97, (r9 - r6) * (r7 - r2), t32, t37, t62, t67, (r6 - r3) * (r7 - r2));
    }
    const float dx = (float)d;

    d = 0;
    {
      int t20 = read_sumTex_(sumTex, sum_step, img_rows, img_cols, (int2)(x + r2, y));
      int t23 = read_sumTex_(sumTex, sum_step, img_rows, img_cols, (int2)(x + r2, y + r3));
      int t70 = read_sumTex_(sumTex, sum_step, img_rows, img_cols, (int2)(x + r7, y));
      int t73 = read_sumTex_(sumTex, sum_step, img_rows, img_cols, (int2)(x + r7, y + r3));
      int t26 = read_sumTex_(sumTex, sum_step, img_rows, img_cols, (int2)(x + r2, y + r6));
      int t76 = read_sumTex_(sumTex, sum_step, img_rows, img_cols, (int2)(x + r7, y + r6));
      int t29 = read_sumTex_(sumTex, sum_step, img_rows, img_cols, (int2)(x + r2, y + r9));
      int t79 = read_sumTex_(sumTex, sum_step, img_rows, img_cols, (int2)(x + r7, y + r9));

      d = calcAxisAlignedDerivative(t20, t23, t70, t73, (r7 - r2) * (r3), t26, t29, t76, t79, (r7 - r2) * (r9 - r6), t23, t26, t73, t76, (r7 - r2) * (r6 - r3));
    }
    const float dy = (float)d;

    d = 0;
    {
      float t = 0;
      t += read_sumTex_(sumTex, sum_step, img_rows, img_cols, (int2)(x + r1, y + r1));
      t -= read_sumTex_(sumTex, sum_step, img_rows, img_cols, (int2)(x + r1, y + r4));
      t -= read_sumTex_(sumTex, sum_step, img_rows, img_cols, (int2)(x + r4, y + r1));
      t += read_sumTex_(sumTex, sum_step, img_rows, img_cols, (int2)(x + r4, y + r4));
      d += t / ((r4 - r1) * (r4 - r1));

      t = 0;
      t += read_sumTex_(sumTex, sum_step, img_rows, img_cols, (int2)(x + r5, y + r1));
      t -= read_sumTex_(sumTex, sum_step, img_rows, img_cols, (int2)(x + r5, y + r4));
      t -= read_sumTex_(sumTex, sum_step, img_rows, img_cols, (int2)(x + r8, y + r1));
      t += read_sumTex_(sumTex, sum_step, img_rows, img_cols, (int2)(x + r8, y + r4));
      d -= t / ((r8 - r5) * (r4 - r1));

      t = 0;
      t += read_sumTex_(sumTex, sum_step, img_rows, img_cols, (int2)(x + r1, y + r5));
      t -= read_sumTex_(sumTex, sum_step, img_rows, img_cols, (int2)(x + r1, y + r8));
      t -= read_sumTex_(sumTex, sum_step, img_rows, img_cols, (int2)(x + r4, y + r5));
      t += read_sumTex_(sumTex, sum_step, img_rows, img_cols, (int2)(x + r4, y + r8));
      d -= t / ((r4 - r1) * (r8 - r5));

      t = 0;
      t += read_sumTex_(sumTex, sum_step, img_rows, img_cols, (int2)(x + r5, y + r5));
      t -= read_sumTex_(sumTex, sum_step, img_rows, img_cols, (int2)(x + r5, y + r8));
      t -= read_sumTex_(sumTex, sum_step, img_rows, img_cols, (int2)(x + r8, y + r5));
      t += read_sumTex_(sumTex, sum_step, img_rows, img_cols, (int2)(x + r8, y + r8));
      d += t / ((r8 - r5) * (r8 - r5));
    }
    const float dxy = (float)d;

    det[hook(8, j + margin + det_step * (layer * c_layer_rows + i + margin))] = dx * dy - 0.81f * dxy * dxy;
    trace[hook(11, j + margin + trace_step * (layer * c_layer_rows + i + margin))] = dx + dy;
  }
}