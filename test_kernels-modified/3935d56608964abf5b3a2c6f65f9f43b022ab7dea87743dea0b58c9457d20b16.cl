//{"channels":5,"col_data":1,"col_offset":2,"data_col":16,"data_im":17,"height":3,"height_col":12,"im_data":14,"im_offset":15,"n":0,"pad_h":8,"pad_w":9,"patch_h":6,"patch_w":7,"stride_h":10,"stride_w":11,"width":4,"width_col":13}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void col2im_kernel(const int n, global const float* col_data, int col_offset, const int height, const int width, const int channels, const int patch_h, const int patch_w, const int pad_h, const int pad_w, const int stride_h, const int stride_w, const int height_col, const int width_col, global float* im_data, int im_offset) {
  global float* data_im = im_data + im_offset;
  global const float* data_col = col_data + col_offset;

  for (int index = get_group_id(0) * get_local_size(0) + get_local_id(0); index < (n); index += get_local_size(0) * get_num_groups(0)) {
    float val = 0;
    int w = index % width + pad_w;
    int h = (index / width) % height + pad_h;
    int c = index / (width * height);

    int w_col_start = (w < patch_w) ? 0 : (w - patch_w) / stride_w + 1;
    int w_col_end = min(w / stride_w + 1, width_col);
    int h_col_start = (h < patch_h) ? 0 : (h - patch_h) / stride_h + 1;
    int h_col_end = min(h / stride_h + 1, height_col);
    int offset = (c * patch_h * patch_w + h * patch_w + w) * height_col * width_col;
    int coeff_h_col = (1 - stride_h * patch_w * height_col) * width_col;
    int coeff_w_col = (1 - stride_w * height_col * width_col);
    for (int h_col = h_col_start; h_col < h_col_end; ++h_col) {
      for (int w_col = w_col_start; w_col < w_col_end; ++w_col) {
        val += data_col[hook(16, offset + h_col * coeff_h_col + w_col * coeff_w_col)];
      }
    }
    data_im[hook(17, index)] = val;
  }
}