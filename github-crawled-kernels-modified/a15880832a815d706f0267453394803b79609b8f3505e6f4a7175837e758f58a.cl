//{"Accum":2,"FHTStage":1,"IFHTStage":3,"IR":0,"IR_bin_shift":7,"block_sz":6,"channels_map":4,"chnl_stride":5,"current_bin":10,"first_interval":8,"total_n_bins":9}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void FHTmad(float* z_k, float* z_N_k, float x_k, float x_N_k, float y_k, float y_N_k) {
  *z_k = x_k * (y_k + y_N_k) + x_N_k * (y_k - y_N_k);
  *z_N_k = x_N_k * (y_k + y_N_k) - x_k * (y_k - y_N_k);
}

kernel void FHTMultAddAccum(global const float* IR, global const float* FHTStage, global float* Accum, global float* IFHTStage, global const int* channels_map, int chnl_stride, int block_sz, int IR_bin_shift, int first_interval, int total_n_bins, int current_bin) {
  int k = get_global_id(0);
  int N_k = get_global_size(0) * 2 - k;
  int rel_bin_id = get_group_id(1);
  int chnl_id = channels_map[hook(4, get_group_id(2))];

  unsigned int channel_off = chnl_stride * chnl_id;
  int bin_id = ((current_bin + rel_bin_id) >= total_n_bins) ? (current_bin + rel_bin_id) - total_n_bins : (current_bin + rel_bin_id);
  unsigned int bin_offset = bin_id * block_sz;
  int IR_id = IR_bin_shift + rel_bin_id;
  unsigned int IR_offset = IR_id * block_sz;
  unsigned int sample_offset = chnl_id * block_sz;
  float ir_k, ir_N_k;
  float fht_k, fht_N_k;
  float accum_k, accum_N_k;
  float t_accum_k, t_accum_N_k;

  N_k = (k == 0) ? get_global_size(0) : N_k;

  ir_k = IR[hook(0, channel_off + IR_offset + k)];
  ir_N_k = IR[hook(0, channel_off + IR_offset + N_k)];
  fht_k = FHTStage[hook(1, sample_offset + k)];
  fht_N_k = FHTStage[hook(1, sample_offset + N_k)];
  accum_k = Accum[hook(2, channel_off + bin_offset + k)];
  accum_N_k = Accum[hook(2, channel_off + bin_offset + N_k)];

  if (k == 0) {
    t_accum_k = ir_k * fht_k * (float)2.;
    t_accum_N_k = ir_N_k * fht_N_k * (float)2.;

  } else {
    FHTmad(&t_accum_k, &t_accum_N_k, ir_k, ir_N_k, fht_k, fht_N_k);
  }
  accum_k += t_accum_k;
  accum_N_k += t_accum_N_k;

  barrier(0x02);

  if (first_interval && bin_id == current_bin) {
    IFHTStage[hook(3, sample_offset + k)] = accum_k;
    IFHTStage[hook(3, sample_offset + N_k)] = accum_N_k;
    accum_k = 0;
    accum_N_k = 0;
  }

  Accum[hook(2, channel_off + bin_offset + k)] = accum_k;
  Accum[hook(2, channel_off + bin_offset + N_k)] = accum_N_k;
}