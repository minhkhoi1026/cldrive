//{"channels":3,"data_col":1,"data_col_off":2,"data_im":16,"data_im_off":17,"dilation_h":12,"dilation_w":13,"height":4,"height_col":14,"kernel_h":6,"kernel_w":7,"n":0,"pad_h":8,"pad_w":9,"stride_h":10,"stride_w":11,"width":5,"width_col":15}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void col2im(const int n, global const float* data_col, const int data_col_off, const int channels, const int height, const int width, const int kernel_h, const int kernel_w, const int pad_h, const int pad_w, const int stride_h, const int stride_w, const int dilation_h, const int dilation_w, const int height_col, const int width_col, global float* data_im, const int data_im_off) {
  for (int index = get_global_id(0); index < n; index += get_global_size(0)) {
    float val = 0;
    const int w_im = index % width + pad_w;
    const int h_im = (index / width) % height + pad_h;
    const int c_im = index / (width * height);
    int kernel_extent_w = (kernel_w - 1) * dilation_w + 1;
    int kernel_extent_h = (kernel_h - 1) * dilation_h + 1;

    const int w_col_start = (w_im < kernel_extent_w) ? 0 : (w_im - kernel_extent_w) / stride_w + 1;
    const int w_col_end = min(w_im / stride_w + 1, width_col);
    const int h_col_start = (h_im < kernel_extent_h) ? 0 : (h_im - kernel_extent_h) / stride_h + 1;
    const int h_col_end = min(h_im / stride_h + 1, height_col);

    for (int h_col = h_col_start; h_col < h_col_end; h_col += 1) {
      for (int w_col = w_col_start; w_col < w_col_end; w_col += 1) {
        int h_k = (h_im - h_col * stride_h);
        int w_k = (w_im - w_col * stride_w);
        if (h_k % dilation_h == 0 && w_k % dilation_w == 0) {
          h_k /= dilation_h;
          w_k /= dilation_w;
          int data_col_index = (((c_im * kernel_h + h_k) * kernel_w + w_k) * height_col + h_col) * width_col + w_col;
          val += data_col[hook(1, data_col_off + data_col_index)];
        }
      }
    }
    data_im[hook(16, data_im_off + index)] = val;
  }
}