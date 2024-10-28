//{"data_col":1,"data_im":9,"height":2,"height_col":7,"ksize":4,"n":0,"pad":5,"stride":6,"width":3,"width_col":8}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void col2im_gpu_kernel(const int n, global const float* data_col, const int height, const int width, const int ksize, const int pad, const int stride, const int height_col, const int width_col, global float* data_im) {
  int index = get_global_id(1) * get_global_size(0) + get_global_id(0);
  for (; index < n; index += get_global_size(1) * get_global_size(0)) {
    float val = 0;
    int w = index % width + pad;
    int h = (index / width) % height + pad;
    int c = index / (width * height);

    int w_col_start = (w < ksize) ? 0 : (w - ksize) / stride + 1;
    int w_col_end = min(w / stride + 1, width_col);
    int h_col_start = (h < ksize) ? 0 : (h - ksize) / stride + 1;
    int h_col_end = min(h / stride + 1, height_col);

    int offset = (c * ksize * ksize + h * ksize + w) * height_col * width_col;
    int coeff_h_col = (1 - stride * ksize * height_col) * width_col;
    int coeff_w_col = (1 - stride * height_col * width_col);
    for (int h_col = h_col_start; h_col < h_col_end; ++h_col) {
      for (int w_col = w_col_start; w_col < w_col_end; ++w_col) {
        val += data_col[hook(1, offset + h_col * coeff_h_col + w_col * coeff_w_col)];
      }
    }
    data_im[hook(9, index)] += val;
  }
}