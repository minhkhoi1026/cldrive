//{"K_conv":4,"N_Fin":7,"N_Fin_dim":8,"N_Fin_sq_pad":9,"N_Fout_dim":10,"N_elem":3,"P_conv":6,"S_conv":5,"bn_biases":2,"bn_running_mean":3,"bn_running_var":4,"bn_weights":1,"conv_wt":1,"eps":7,"in_data":0,"in_size":6,"input":21,"input[local_x]":20,"out_data":5,"relu_type":8,"weight":19,"weight[local_y]":18}
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
    weight[hook(19, local_y)][hook(18, local_x)] = conv_wt[hook(1, a + N_elem * local_y + local_x)];

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

    input[hook(21, local_x)][hook(20, local_y)] = data;

    barrier(0x01);

    for (int k = 0; k < 8; ++k) {
      float product = (weight[hook(19, local_y)][hook(18, k)] * input[hook(21, local_x)][hook(20, k)]);
      conv_out += product;
    }

    barrier(0x01);
  }
  out_data[hook(5, get_global_id(1) * get_global_size(0) + get_global_id(0))] = conv_out;
}

kernel void batchnorm(global float* restrict in_data, global float* restrict bn_weights, global float* restrict bn_biases, global float* restrict bn_running_mean, global float* restrict bn_running_var, global float* restrict out_data, const int in_size, const float eps, const int relu_type) {
  int filter_index = get_global_id(0);
  int pixel_index = get_global_id(1);
  int index = filter_index * in_size + pixel_index;
  float out;

  out = (bn_weights[hook(1, filter_index)] * ((in_data[hook(0, index)] - bn_running_mean[hook(3, filter_index)]) / sqrt(bn_running_var[hook(4, filter_index)] + eps))) + bn_biases[hook(2, filter_index)];

  if (relu_type == 1)
    out_data[hook(5, index)] = (out > 0.0f) ? out : (out * 0.1f);
  else
    out_data[hook(5, index)] = out;
}