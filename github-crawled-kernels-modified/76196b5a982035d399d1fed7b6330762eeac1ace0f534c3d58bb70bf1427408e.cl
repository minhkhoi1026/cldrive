//{"Accum":0,"IFFTStage":1,"accum_chnl_stride":3,"channels_map":2,"n_loop_bins":4,"total_n_bins":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void FHTmad(float* z_k, float* z_N_k, float x_k, float x_N_k, float y_k, float y_N_k) {
  *z_k = x_k * (y_k + y_N_k) + x_N_k * (y_k - y_N_k);
  *z_N_k = x_N_k * (y_k + y_N_k) - x_k * (y_k - y_N_k);
}

kernel void FHTMultAddTail(global float* Accum, global float* IFFTStage, global const int* channels_map, int accum_chnl_stride, int n_loop_bins, int total_n_bins) {
  int k = get_global_id(0);
  int chunk_id = get_group_id(1);
  int chnl_id = channels_map[hook(2, get_group_id(2))];
  int block_sz = get_global_size(0);

  int channel_off = mul24(accum_chnl_stride, chnl_id);
  int accum_offset = mul24(chunk_id, block_sz);
  int accum_chnl_offset = channel_off;

  float accum = 0;
  for (int i = 0, bin_id = chunk_id; i < n_loop_bins && bin_id < total_n_bins; i++, bin_id += get_global_size(1)) {
    accum += Accum[hook(0, channel_off + mul24(bin_id, block_sz) + k)];
  }

  if (get_global_size(1) == 1) {
    IFFTStage[hook(1, mul24(block_sz, chnl_id) + k)] = accum;
  } else {
    Accum[hook(0, accum_chnl_offset + accum_offset + k)] = accum;
  }
}