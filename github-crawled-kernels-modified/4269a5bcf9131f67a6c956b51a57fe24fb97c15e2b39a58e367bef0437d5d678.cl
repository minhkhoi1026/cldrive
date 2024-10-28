//{"Accum":3,"FHTStage":1,"FHTStore":2,"IFHTStage":4,"IR":0,"IR_bin_shift":7,"channels_map":5,"chnl_stride":6,"current_bin":9,"first_cycle":12,"last_cycle":13,"loop_offset":10,"this_loop_sz":11,"total_n_bins":8}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void FHTmad(float* z_k, float* z_N_k, float x_k, float x_N_k, float y_k, float y_N_k) {
  *z_k = x_k * (y_k + y_N_k) + x_N_k * (y_k - y_N_k);
  *z_N_k = x_N_k * (y_k + y_N_k) - x_k * (y_k - y_N_k);
}

kernel void FHTMultAddHeadDevided(global const float* IR, global const float* FHTStage, global float* FHTStore, global float* Accum, global float* IFHTStage, global const int* channels_map, int chnl_stride, int IR_bin_shift, int total_n_bins, int current_bin, int loop_offset, int this_loop_sz, int first_cycle, int last_cycle) {
  int block_sz = get_global_size(0) * 2;
  int k = get_global_id(0);
  int N_k = block_sz - k;
  int chnl_id = channels_map[hook(5, get_group_id(1))];

  unsigned int sample_offset = mul24(chnl_id, block_sz);
  unsigned int channel_off = chnl_stride * chnl_id;
  unsigned int accum_chnl_offset = mul24(block_sz, chnl_id);
  int bin_id = ((current_bin - loop_offset) < 0) ? total_n_bins + (current_bin - loop_offset) : (current_bin - loop_offset);
  int ir_id = loop_offset + IR_bin_shift;
  int IR_offset = ir_id * block_sz;
  int store_offset = bin_id * block_sz;
  float ir_k, ir_N_k;
  float fht_k, fht_N_k;
  float t_accum_k, t_accum_N_k;
  float accum_k = 0, accum_N_k = 0;

  N_k = (k == 0) ? block_sz / 2 : N_k;

  if (first_cycle) {
    Accum[hook(3, accum_chnl_offset + k)] = 0;
    Accum[hook(3, accum_chnl_offset + N_k)] = 0;

    fht_k = FHTStage[hook(1, sample_offset + k)];
    fht_N_k = FHTStage[hook(1, sample_offset + N_k)];
    int current_store_offset = current_bin * block_sz;
    FHTStore[hook(2, channel_off + current_store_offset + k)] = fht_k;
    FHTStore[hook(2, channel_off + current_store_offset + N_k)] = fht_N_k;
  }

  for (; (ir_id < total_n_bins) && (this_loop_sz > 0); this_loop_sz--, ir_id += 1, bin_id -= 1)

  {
    bin_id = (bin_id < 0) ? total_n_bins + bin_id : bin_id;
    IR_offset = ir_id * block_sz;
    store_offset = bin_id * block_sz;
    ir_k = IR[hook(0, channel_off + IR_offset + k)];
    ir_N_k = IR[hook(0, channel_off + IR_offset + N_k)];
    fht_k = FHTStore[hook(2, channel_off + store_offset + k)];
    fht_N_k = FHTStore[hook(2, channel_off + store_offset + N_k)];
    if (k == 0) {
      t_accum_k = ir_k * fht_k * (float)2.;
      t_accum_N_k = ir_N_k * fht_N_k * (float)2.;

    } else {
      FHTmad(&t_accum_k, &t_accum_N_k, ir_k, ir_N_k, fht_k, fht_N_k);
    }
    accum_k += t_accum_k;
    accum_N_k += t_accum_N_k;
  }

  Accum[hook(3, accum_chnl_offset + k)] += accum_k;
  Accum[hook(3, accum_chnl_offset + N_k)] += accum_N_k;

  if (last_cycle) {
    IFHTStage[hook(4, accum_chnl_offset + k)] = Accum[hook(3, accum_chnl_offset + k)];
    IFHTStage[hook(4, accum_chnl_offset + N_k)] = Accum[hook(3, accum_chnl_offset + N_k)];
  }
}