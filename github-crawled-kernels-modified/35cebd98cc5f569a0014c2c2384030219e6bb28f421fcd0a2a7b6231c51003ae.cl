//{"K_conv":4,"N_Fin":7,"N_Fin_dim":8,"N_Fin_sq_pad":9,"N_Fout_dim":10,"N_elem":3,"P_conv":6,"S_conv":5,"conv_wt":1,"in_data":0,"input":14,"input[local_x]":13,"out_data":2,"weight":12,"weight[local_y]":11}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void conv(global float* restrict in_data, global float* restrict conv_wt, global float* restrict out_data, const int N_elem, const int K_conv, const int S_conv, const int P_conv, const int N_Fin, const int N_Fin_dim, const int N_Fin_sq_pad, const int N_Fout_dim) {
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

  float out = 0.0;

  for (int a = a_start, b = 0; a <= a_end; a += 8, b += 8) {
    weight[hook(12, local_y)][hook(11, local_x)] = conv_wt[hook(1, a + N_elem * local_y + local_x)];

    ushort gx = b + local_y;
    ushort gy = global_x;
    ushort ch_no = gx / K_conv_sq;
    ushort i_k = gx - (ch_no * K_conv_sq);
    ushort k_row_no = i_k / K_conv;
    short k_row = k_row_no - P_conv;
    short k_col = i_k - (k_row_no * K_conv) - P_conv;
    ushort out_feat_row = gy / N_Fout_dim;
    short row = (out_feat_row)*S_conv + k_row;
    short col = (gy - (out_feat_row * N_Fout_dim)) * S_conv + k_col;
    unsigned location = ch_no * N_Fin_sq_pad + row * N_Fin_dim + col;

    float data;
    if (gx > N_Fin * K_conv_sq || gy > N_Fout_dim * N_Fout_dim || row < 0 || col < 0 || row >= N_Fin_dim || col >= N_Fin_dim)
      data = 0.0;
    else
      data = in_data[hook(0, location)];

    input[hook(14, local_x)][hook(13, local_y)] = data;

    barrier(0x01);

    for (int k = 0; k < 8; ++k) {
      out += (weight[hook(12, local_y)][hook(11, k)] * input[hook(14, local_x)][hook(13, k)]);
    }

    barrier(0x01);
  }
  out_data[hook(2, get_global_id(1) * get_global_size(0) + get_global_id(0))] = out;
}