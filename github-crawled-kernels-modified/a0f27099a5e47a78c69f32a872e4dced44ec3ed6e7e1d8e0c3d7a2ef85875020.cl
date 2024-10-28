//{"K_conv":4,"N_Fin":7,"N_Fin_dim":8,"N_Fin_sq_pad":9,"N_Fout_dim":10,"N_elem":3,"P_conv":6,"S_conv":5,"conv_wt":1,"filter_weight":1,"in_data":0,"input":22,"input[local_x]":21,"input_channels":3,"input_im":0,"input_size":4,"out_data":2,"output_im":2,"output_size":7,"pad":5,"stride":6,"weight":20,"weight[local_y]":19}
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
    weight[hook(20, local_y)][hook(19, local_x)] = conv_wt[hook(1, a + N_elem * local_y + local_x)];

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

    input[hook(22, local_x)][hook(21, local_y)] = data;

    barrier(0x01);

    for (int k = 0; k < 8; ++k) {
      float product = (weight[hook(20, local_y)][hook(19, k)] * input[hook(22, local_x)][hook(21, k)]);
      conv_out += product;
    }

    barrier(0x01);
  }
  out_data[hook(2, get_global_id(1) * get_global_size(0) + get_global_id(0))] = conv_out;
}

kernel void conv1x1(global float* restrict input_im, global const float* restrict filter_weight, global float* restrict output_im, const int input_channels, const int input_size, const int pad, const int stride, const int output_size) {
  int filter_index = get_global_id(0);
  int i = get_global_id(1);

  filter_weight += filter_index * input_channels;
  output_im += filter_index * output_size * output_size;

  {
    for (int j = 0; j < output_size; j++) {
      float tmp = 0;

      for (int k = 0; k < input_channels; k++) {
        int h = i * stride - pad;
        int w = j * stride - pad;

        if ((h >= 0) && (h < input_size) && (w >= 0) && (w < input_size)) {
          tmp += input_im[hook(0, k * input_size * input_size + h * input_size + w)] * filter_weight[hook(1, k)];
        }
      }

      output_im[hook(2, i * output_size + j)] = tmp;
    }
  }
}