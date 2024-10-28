//{"N9":19,"c_hessianThreshold":16,"c_layer_cols":14,"c_layer_rows":13,"c_max_candidates":15,"c_nOctaveLayers":11,"c_octave":12,"counter_offset":8,"det":0,"det_offset":2,"det_step":1,"imgTex":18,"img_cols":10,"img_rows":9,"maxCounter":7,"maxPosBuffer":6,"sumTex":17,"trace":3,"trace_offset":5,"trace_step":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
__inline unsigned int read_sumTex_(global unsigned int* sumTex, int sum_step, int img_rows, int img_cols, int2 coord) {
  int x = clamp(coord.x, 0, img_cols);
  int y = clamp(coord.y, 0, img_rows);
  return sumTex[hook(17, sum_step * y + x)];
}

__inline uchar read_imgTex_(global uchar* imgTex, int img_step, int img_rows, int img_cols, float2 coord) {
  int x = clamp(convert_int_rte(coord.x), 0, img_cols - 1);
  int y = clamp(convert_int_rte(coord.y), 0, img_rows - 1);
  return imgTex[hook(18, img_step * y + x)];
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

kernel void SURF_findMaximaInLayer(global float* det, int det_step, int det_offset, global float* trace, int trace_step, int trace_offset, global int4* maxPosBuffer, volatile global int* maxCounter, int counter_offset, int img_rows, int img_cols, int c_nOctaveLayers, int c_octave, int c_layer_rows, int c_layer_cols, int c_max_candidates, float c_hessianThreshold) {
  volatile local float N9[768];

  det_step /= sizeof(float);
  trace_step /= sizeof(float);
  maxCounter += counter_offset;

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

  int l_x = min(max(j, 0), img_cols - 1);
  int l_y = c_layer_rows * layer + min(max(i, 0), img_rows - 1);

  N9[hook(19, localLin - zoff)] = det[hook(0, det_step * (l_y - c_layer_rows) + l_x)];
  N9[hook(19, localLin)] = det[hook(0, det_step * (l_y) + l_x)];
  N9[hook(19, localLin + zoff)] = det[hook(0, det_step * (l_y + c_layer_rows) + l_x)];
  barrier(0x01);

  if (i < c_layer_rows - margin && j < c_layer_cols - margin && get_local_id(0) > 0 && get_local_id(0) < get_local_size(0) - 1 && get_local_id(1) > 0 && get_local_id(1) < get_local_size(1) - 1) {
    float val0 = N9[hook(19, localLin)];
    if (val0 > c_hessianThreshold) {
      const bool condmax = val0 > N9[hook(19, localLin - 1 - get_local_size(0) - zoff)] && val0 > N9[hook(19, localLin - get_local_size(0) - zoff)] && val0 > N9[hook(19, localLin + 1 - get_local_size(0) - zoff)] && val0 > N9[hook(19, localLin - 1 - zoff)] && val0 > N9[hook(19, localLin - zoff)] && val0 > N9[hook(19, localLin + 1 - zoff)] && val0 > N9[hook(19, localLin - 1 + get_local_size(0) - zoff)] && val0 > N9[hook(19, localLin + get_local_size(0) - zoff)] && val0 > N9[hook(19, localLin + 1 + get_local_size(0) - zoff)]

                           && val0 > N9[hook(19, localLin - 1 - get_local_size(0))] && val0 > N9[hook(19, localLin - get_local_size(0))] && val0 > N9[hook(19, localLin + 1 - get_local_size(0))] && val0 > N9[hook(19, localLin - 1)] && val0 > N9[hook(19, localLin + 1)] && val0 > N9[hook(19, localLin - 1 + get_local_size(0))] && val0 > N9[hook(19, localLin + get_local_size(0))] && val0 > N9[hook(19, localLin + 1 + get_local_size(0))]

                           && val0 > N9[hook(19, localLin - 1 - get_local_size(0) + zoff)] && val0 > N9[hook(19, localLin - get_local_size(0) + zoff)] && val0 > N9[hook(19, localLin + 1 - get_local_size(0) + zoff)] && val0 > N9[hook(19, localLin - 1 + zoff)] && val0 > N9[hook(19, localLin + zoff)] && val0 > N9[hook(19, localLin + 1 + zoff)] && val0 > N9[hook(19, localLin - 1 + get_local_size(0) + zoff)] && val0 > N9[hook(19, localLin + get_local_size(0) + zoff)] && val0 > N9[hook(19, localLin + 1 + get_local_size(0) + zoff)];

      if (condmax) {
        int ind = atomic_inc(maxCounter);

        if (ind < c_max_candidates) {
          const int laplacian = (int)copysign(1.0f, trace[hook(3, trace_step * (layer * c_layer_rows + i) + j)]);

          maxPosBuffer[hook(6, ind)] = (int4)(j, i, layer, laplacian);
        }
      }
    }
  }
}