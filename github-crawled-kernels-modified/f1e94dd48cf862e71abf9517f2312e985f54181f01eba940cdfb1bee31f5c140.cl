//{"Accum1":3,"Accum2":12,"FHTStage":1,"FHTStore":2,"IR1":0,"IR2":11,"IR_bin_shift":7,"accum_chnl_stride":5,"channels_map":4,"chnl_stride":6,"current_bin":10,"n_loop_bins":8,"total_n_bins":9}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void FHTmad(float* z_k, float* z_N_k, float x_k, float x_N_k, float y_k, float y_N_k) {
  *z_k = x_k * (y_k + y_N_k) + x_N_k * (y_k - y_N_k);
  *z_N_k = x_N_k * (y_k + y_N_k) - x_k * (y_k - y_N_k);
}

kernel void FHTMultAddHeadXFade(global const float* IR1, global const float* FHTStage, global float* FHTStore, global float* Accum1, global const int* channels_map, int accum_chnl_stride, int chnl_stride, int IR_bin_shift, int n_loop_bins, int total_n_bins, int current_bin, global const float* IR2, global float* Accum2) {
  int block_sz = get_global_size(0) * 2;
  int k = get_global_id(0);
  int N_k = block_sz - k;
  int chunk_id = get_group_id(1);
  int chnl_id = channels_map[hook(4, get_group_id(2))];

  unsigned int sample_offset = mul24(chnl_id, block_sz);
  unsigned int channel_off = chnl_stride * chnl_id;
  unsigned int accum_offset = mul24(chunk_id, block_sz);
  unsigned int accum_chnl_offset = mul24(accum_chnl_stride, chnl_id);
  int bin_id = ((current_bin - chunk_id) < 0) ? total_n_bins + (current_bin - chunk_id) : (current_bin - chunk_id);
  int ir_id = chunk_id + IR_bin_shift;
  int IR_offset = ir_id * block_sz;
  int store_offset = bin_id * block_sz;

  float ir1_k, ir1_N_k, ir2_k, ir2_N_k;
  float fht_k, fht_N_k;
  float t_accum1_k, t_accum1_N_k, t_accum2_k, t_accum2_N_k;
  float accum1_k = 0, accum1_N_k = 0, accum2_k = 0, accum2_N_k = 0;

  int i = 0;

  N_k = (k == 0) ? block_sz / 2 : N_k;

  if (chunk_id == 0) {
    ir1_k = IR1[hook(0, channel_off + IR_offset + k)];
    ir1_N_k = IR1[hook(0, channel_off + IR_offset + N_k)];
    ir2_k = IR2[hook(11, channel_off + IR_offset + k)];
    ir2_N_k = IR2[hook(11, channel_off + IR_offset + N_k)];
    fht_k = FHTStage[hook(1, sample_offset + k)];
    fht_N_k = FHTStage[hook(1, sample_offset + N_k)];
    FHTStore[hook(2, channel_off + store_offset + k)] = fht_k;
    FHTStore[hook(2, channel_off + store_offset + N_k)] = fht_N_k;

    if (k == 0) {
      t_accum1_k = ir1_k * fht_k * (float)2.;
      t_accum1_N_k = ir1_N_k * fht_N_k * (float)2.;
      t_accum2_k = ir2_k * fht_k * (float)2.;
      t_accum2_N_k = ir2_N_k * fht_N_k * (float)2.;

    } else {
      FHTmad(&t_accum1_k, &t_accum1_N_k, ir1_k, ir1_N_k, fht_k, fht_N_k);
      FHTmad(&t_accum2_k, &t_accum2_N_k, ir2_k, ir2_N_k, fht_k, fht_N_k);
    }
    accum1_k += t_accum1_k;
    accum1_N_k += t_accum1_N_k;
    accum2_k += t_accum2_k;
    accum2_N_k += t_accum2_N_k;
    i = 1;
    ir_id += get_global_size(1);
    bin_id -= get_global_size(1);
  }

  for (; i < n_loop_bins && ir_id < total_n_bins; i++, ir_id += get_global_size(1), bin_id -= get_global_size(1)) {
    bin_id = (bin_id < 0) ? total_n_bins + bin_id : bin_id;
    IR_offset = ir_id * block_sz;
    store_offset = bin_id * block_sz;
    ir1_k = IR1[hook(0, channel_off + IR_offset + k)];
    ir1_N_k = IR1[hook(0, channel_off + IR_offset + N_k)];
    ir2_k = IR2[hook(11, channel_off + IR_offset + k)];
    ir2_N_k = IR2[hook(11, channel_off + IR_offset + N_k)];
    fht_k = FHTStore[hook(2, channel_off + store_offset + k)];
    fht_N_k = FHTStore[hook(2, channel_off + store_offset + N_k)];
    if (k == 0) {
      t_accum1_k = ir1_k * fht_k * (float)2.;
      t_accum1_N_k = ir1_N_k * fht_N_k * (float)2.;
      t_accum2_k = ir2_k * fht_k * (float)2.;
      t_accum2_N_k = ir2_N_k * fht_N_k * (float)2.;

    } else {
      FHTmad(&t_accum1_k, &t_accum1_N_k, ir1_k, ir1_N_k, fht_k, fht_N_k);
      FHTmad(&t_accum2_k, &t_accum2_N_k, ir2_k, ir2_N_k, fht_k, fht_N_k);
    }
    accum1_k += t_accum1_k;
    accum1_N_k += t_accum1_N_k;
    accum2_k += t_accum2_k;
    accum2_N_k += t_accum2_N_k;
  }

  Accum1[hook(3, accum_chnl_offset + accum_offset + k)] = accum1_k;
  Accum1[hook(3, accum_chnl_offset + accum_offset + N_k)] = accum1_N_k;
  Accum2[hook(12, accum_chnl_offset + accum_offset + k)] = accum2_k;
  Accum2[hook(12, accum_chnl_offset + accum_offset + N_k)] = accum2_N_k;
}