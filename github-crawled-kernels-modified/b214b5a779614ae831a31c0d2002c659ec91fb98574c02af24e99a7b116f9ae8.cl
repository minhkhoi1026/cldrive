//{"col_height":8,"col_width":9,"dilation_h":16,"dilation_w":17,"in_c":3,"in_data":1,"in_data_tmp":22,"in_h":4,"in_n":2,"in_w":5,"kernel_exten_h":18,"kernel_exten_w":19,"num_threads":20,"out_data":0,"out_data_tmp":21,"out_h":6,"out_w":7,"pad_left":13,"pad_up":12,"stride_h":14,"stride_w":15,"window_h":10,"window_w":11}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ker_im2sequence_fwd(global float* out_data, global const float* in_data, const int in_n, const int in_c, const int in_h, const int in_w, const int out_h, const int out_w, const int col_height, const int col_width, const int window_h, const int window_w, const int pad_up, const int pad_left, const int stride_h, const int stride_w, const int dilation_h, const int dilation_w, const int kernel_exten_h, const int kernel_exten_w, const int num_threads) {
  int global_idx = get_global_id(0);
  int out_size_per_img = out_h * out_w;
  int w = global_idx % out_w;
  int h = (global_idx / out_w) % out_h;
  int n = (global_idx / out_size_per_img) % in_n;
  int c = global_idx / (out_size_per_img * in_n);

  int in_start_w = w * stride_w - pad_left;
  int in_start_h = h * stride_h - pad_up;
  int in_end_w = in_start_w + kernel_exten_w;
  int in_end_h = in_start_h + kernel_exten_h;
  int in_offset = (n * in_c + c) * in_h * in_w;
  global const float* in_data_tmp = in_data + in_offset;
  int out_offset = (global_idx % col_height * in_c + c) * window_h * window_w;
  global float* out_data_tmp = out_data;

  for (int i = in_start_h; i < in_end_h; i += dilation_h) {
    for (int j = in_start_w; j < in_end_w; j += dilation_w) {
      if (i < 0 || i >= in_h || j < 0 || j >= in_w) {
        out_data_tmp[hook(21, out_offset++)] = 0;
      } else {
        out_data_tmp[hook(21, out_offset++)] = in_data_tmp[hook(22, i * in_w + j)];
      }
    }
  }
}