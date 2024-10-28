//{"Accum1":3,"Accum2":15,"FHTStage":1,"FHTStore":2,"IFHTStage1":4,"IFHTStage2":16,"IR1":0,"IR2":14,"IR_bin_shift":7,"channels_map":5,"chnl_stride":6,"current_bin":9,"first_cycle":12,"last_cycle":13,"loop_offset":10,"this_loop_sz":11,"total_n_bins":8}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void FHTmad(float* z_k, float* z_N_k, float x_k, float x_N_k, float y_k, float y_N_k) {
  *z_k = x_k * (y_k + y_N_k) + x_N_k * (y_k - y_N_k);
  *z_N_k = x_N_k * (y_k + y_N_k) - x_k * (y_k - y_N_k);
}

kernel void FHTMultAddHeadDevidedXFade(global const float* IR1, global const float* FHTStage, global float* FHTStore, global float* Accum1, global float* IFHTStage1, global const int* channels_map, int chnl_stride, int IR_bin_shift, int total_n_bins, int current_bin, int loop_offset, int this_loop_sz, int first_cycle, int last_cycle, global const float* IR2, global float* Accum2, global float* IFHTStage2) {
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
  float ir1_k, ir1_N_k, ir2_k, ir2_N_k;
  float fht_k, fht_N_k;
  float t_accum1_k, t_accum1_N_k, t_accum2_k, t_accum2_N_k;
  float accum1_k = 0, accum1_N_k = 0, accum2_k = 0, accum2_N_k = 0;

  N_k = (k == 0) ? block_sz / 2 : N_k;

  if (first_cycle) {
    Accum1[hook(3, accum_chnl_offset + k)] = 0;
    Accum1[hook(3, accum_chnl_offset + N_k)] = 0;
    Accum2[hook(15, accum_chnl_offset + k)] = 0;
    Accum2[hook(15, accum_chnl_offset + N_k)] = 0;

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
    ir1_k = IR1[hook(0, channel_off + IR_offset + k)];
    ir1_N_k = IR1[hook(0, channel_off + IR_offset + N_k)];
    ir2_k = IR2[hook(14, channel_off + IR_offset + k)];
    ir2_N_k = IR2[hook(14, channel_off + IR_offset + N_k)];
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

  Accum1[hook(3, accum_chnl_offset + k)] += accum1_k;
  Accum1[hook(3, accum_chnl_offset + N_k)] += accum1_N_k;
  Accum2[hook(15, accum_chnl_offset + k)] += accum2_k;
  Accum2[hook(15, accum_chnl_offset + N_k)] += accum2_N_k;

  if (last_cycle) {
    IFHTStage1[hook(4, accum_chnl_offset + k)] = Accum1[hook(3, accum_chnl_offset + k)];
    IFHTStage1[hook(4, accum_chnl_offset + N_k)] = Accum1[hook(3, accum_chnl_offset + N_k)];
    IFHTStage2[hook(16, accum_chnl_offset + k)] = Accum2[hook(15, accum_chnl_offset + k)];
    IFHTStage2[hook(16, accum_chnl_offset + N_k)] = Accum2[hook(15, accum_chnl_offset + N_k)];
  }
}