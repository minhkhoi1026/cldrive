//{"data_col":9,"data_im":1,"height":2,"height_col":7,"ksize":4,"n":0,"pad":5,"stride":6,"width":3,"width_col":8}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void im2col_gpu_kernel(const int n, global const float* data_im, const int height, const int width, const int ksize, const int pad, const int stride, const int height_col, const int width_col, global float* data_col) {
  int index = get_global_id(1) * get_global_size(0) + get_global_id(0);
  for (; index < n; index += get_global_size(1) * get_global_size(0)) {
    int w_out = index % width_col;
    int h_index = index / width_col;
    int h_out = h_index % height_col;
    int channel_in = h_index / height_col;
    int channel_out = channel_in * ksize * ksize;
    int h_in = h_out * stride - pad;
    int w_in = w_out * stride - pad;

    int data_col_offset = (channel_out * height_col + h_out) * width_col + w_out;
    int data_im_offset = (channel_in * height + h_in) * width + w_in;
    for (int i = 0; i < ksize; ++i) {
      for (int j = 0; j < ksize; ++j) {
        int h = h_in + i;
        int w = w_in + j;

        data_col[hook(9, data_col_offset)] = (h >= 0 && w >= 0 && h < height && w < width) ? data_im[hook(1, data_im_offset + i * width + j)] : 0;

        data_col_offset += height_col * width_col;
      }
    }
  }
}