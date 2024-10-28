//{"K_conv":4,"N_Fin":7,"N_Fin_dim":8,"N_Fin_sq_pad":9,"N_Fout_dim":10,"N_elem":3,"P_conv":6,"S_conv":5,"conv_wt":1,"in_data":0,"in_size":2,"input":19,"input[local_x]":18,"kernel_size":3,"out_data":1,"out_size":5,"pool_type":6,"stride":4,"weight":17,"weight[local_y]":16}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel __attribute((reqd_work_group_size(8, 8, 1))) void conv(global float* restrict in_data, global float* restrict conv_wt, global float* restrict out_data, const int N_elem, const int K_conv, const int S_conv, const int P_conv, const int N_Fin, const int N_Fin_dim, const int N_Fin_sq_pad, const int N_Fout_dim) {
  local float weight[8][8];
  local float input[8][8];

  int block_y = get_group_id(1);

  int local_x = get_local_id(0);
  int local_y = get_local_id(1);

  int global_y = get_global_id(1);
  int global_x = get_global_id(0);

  int K_conv_sq = K_conv * K_conv;

  int a_start = N_elem * 8 * block_y;
  int a_end = a_start + N_elem - 1;

  float conv_out = 0.0;

  for (int a = a_start, b = 0; a <= a_end; a += 8, b += 8) {
    weight[hook(17, local_y)][hook(16, local_x)] = conv_wt[hook(1, a + N_elem * local_y + local_x)];

    int gx = b + local_y;
    int gy = global_x;
    int ch_no = gx / K_conv_sq;
    int i_k = gx - (ch_no * K_conv_sq);
    int k_row_no = i_k / K_conv;
    int k_row = k_row_no - P_conv;
    int k_col = i_k - (k_row_no * K_conv) - P_conv;
    int out_feat_row = gy / N_Fout_dim;
    int row = (out_feat_row)*S_conv + k_row;
    int col = (gy - (out_feat_row * N_Fout_dim)) * S_conv + k_col;
    int location = ch_no * N_Fin_sq_pad + row * N_Fin_dim + col;

    float data;
    if (gx > N_Fin * K_conv_sq || gy > N_Fout_dim * N_Fout_dim || row < 0 || col < 0 || row >= N_Fin_dim || col >= N_Fin_dim)
      data = 0.0;
    else
      data = in_data[hook(0, location)];

    input[hook(19, local_x)][hook(18, local_y)] = data;

    barrier(0x01);

    for (int k = 0; k < 8; ++k) {
      float product = (weight[hook(17, local_y)][hook(16, k)] * input[hook(19, local_x)][hook(18, k)]);
      conv_out += product;
    }

    barrier(0x01);
  }
  out_data[hook(1, get_global_id(1) * get_global_size(0) + get_global_id(0))] = conv_out;
}

kernel void pool(global float* restrict in_data, global float* restrict out_data, const int in_size, const int kernel_size, const int stride, const int out_size, const int pool_type) {
  int filter_index = get_global_id(0);

  for (int row = 0; row < out_size; row++) {
    for (int col = 0; col < out_size; col++) {
      float tmp = -100.0;

      if (pool_type == 1)
        tmp = 0.0;

      for (int i = 0; i < (kernel_size * kernel_size); i++) {
        int k_row = i / kernel_size;
        int k_col = i - (k_row * kernel_size);

        float data = in_data[hook(0, filter_index * in_size * in_size + (row * stride + k_row) * in_size + (col * stride + k_col))];

        if (pool_type == 1)
          tmp += data / 16;
        else {
          if (tmp < data)
            tmp = data;
        }
      }
      out_data[hook(1, filter_index * out_size * out_size + row * out_size + col)] = tmp;
    }
  }
}