//{"data_col":15,"data_col_off":16,"data_im":1,"data_im_off":2,"data_im_ptr":17,"dilation_h":11,"dilation_w":12,"height":3,"height_col":13,"kernel_h":5,"kernel_w":6,"n":0,"pad_h":7,"pad_w":8,"stride_h":9,"stride_w":10,"width":4,"width_col":14}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void im2col(const int n, global const float* data_im, const int data_im_off, const int height, const int width, const int kernel_h, const int kernel_w, const int pad_h, const int pad_w, const int stride_h, const int stride_w, const int dilation_h, const int dilation_w, const int height_col, const int width_col, global float* data_col, const int data_col_off) {
  for (int index = get_global_id(0); index < n; index += get_global_size(0)) {
    const int h_index = index / width_col;
    const int h_col = h_index % height_col;
    const int w_col = index % width_col;
    const int c_im = h_index / height_col;
    const int c_col = c_im * kernel_h * kernel_w;
    const int h_offset = h_col * stride_h - pad_h;
    const int w_offset = w_col * stride_w - pad_w;

    global float* data_col_ptr = data_col + data_col_off;
    data_col_ptr += (c_col * height_col + h_col) * width_col + w_col;
    global const float* data_im_ptr = data_im + data_im_off;
    data_im_ptr += (c_im * height + h_offset) * width + w_offset;

    for (int i = 0; i < kernel_h; ++i) {
      for (int j = 0; j < kernel_w; ++j) {
        int h_im = h_offset + i * dilation_h;
        int w_im = w_offset + j * dilation_w;
        *data_col_ptr = (h_im >= 0 && w_im >= 0 && h_im < height && w_im < width) ? data_im_ptr[hook(17, i * dilation_h * width + j * dilation_w)] : 0;
        data_col_ptr += height_col * width_col;
      }
    }
  }
}