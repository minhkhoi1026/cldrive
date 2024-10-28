//{"col_data":13,"col_offset":14,"data_im":15,"height":3,"height_col":11,"im_data":1,"im_offset":2,"ksize_h":5,"ksize_w":6,"n":0,"pad_h":7,"pad_w":8,"stride_h":9,"stride_w":10,"width":4,"width_col":12}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void im2col_kernel(const int n, const global float* im_data, int im_offset, const int height, const int width, const int ksize_h, const int ksize_w, const int pad_h, const int pad_w, const int stride_h, const int stride_w, const int height_col, const int width_col, global float* col_data, int col_offset) {
  global const float* data_im = im_data + im_offset;
  global float* data_col = col_data + col_offset;

  for (int index = get_group_id(0) * get_local_size(0) + get_local_id(0); index < (n); index += get_local_size(0) * get_num_groups(0)) {
    int w_out = index % width_col;
    index /= width_col;
    int h_out = index % height_col;
    int channel_in = index / height_col;
    int channel_out = channel_in * ksize_h * ksize_w;
    int h_in = h_out * stride_h - pad_h;
    int w_in = w_out * stride_w - pad_w;
    data_col += (channel_out * height_col + h_out) * width_col + w_out;
    data_im += (channel_in * height + h_in) * width + w_in;
    for (int i = 0; i < ksize_h; ++i) {
      for (int j = 0; j < ksize_w; ++j) {
        int h = h_in + i;
        int w = w_in + j;
        *data_col = (h >= 0 && w >= 0 && h < height && w < width) ? data_im[hook(15, i * width + j)] : 0;
        data_col += height_col * width_col;
      }
    }
  }
}