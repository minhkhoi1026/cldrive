//{"bias_data":1,"bias_flag":22,"channel_in_stride":11,"channel_out_stride":8,"dilation_h":19,"dilation_w":20,"din":0,"dout":21,"hin":9,"hout":6,"in_channels":4,"kernel_h":12,"kernel_size":14,"kernel_w":13,"num":3,"out_channels":5,"pad_h":17,"pad_w":18,"relu_flag":23,"stride_h":15,"stride_w":16,"weight_data":2,"win":10,"wout":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void direct_deconv(global const float* din, global const float* bias_data, global const float* const weight_data, const int num, const int in_channels, const int out_channels, const int hout, const int wout, const int channel_out_stride, const int hin, const int win, const int channel_in_stride, const int kernel_h, const int kernel_w, const int kernel_size, const int stride_h, const int stride_w, const int pad_h, const int pad_w, const int dilation_h, const int dilation_w, global float* dout, const int bias_flag, const int relu_flag) {
  local float local_inputs[(16 + 32 - 1) * (16 + 32 - 1)];

  const int group_i = get_group_id(0);
  const int group_j = get_group_id(1);

  const int local_id_x = get_local_id(0);
  const int local_id_y = get_local_id(1);

  const int global_id_x = get_global_id(0);
  const int global_id_y = get_global_id(1);

  const int input_in_tile = (16 + kernel_h - 1) * (16 + kernel_w - 1);

  if (global_id_x < wout && global_id_y < hout) {
    for (int ic = 0; ic < in_channels; ic++) {
      for (int i = local_id_x; i < input_in_tile; i += 16) {
      }

      barrier(0x01);
    }
  }
}