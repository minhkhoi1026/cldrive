//{"bottom_diff":21,"bottom_diff_data":17,"bottom_diff_offset":18,"channels":6,"height":7,"kernel_h":11,"kernel_w":12,"nthreads":0,"num":5,"pad_h":15,"pad_w":16,"pooled_height":9,"pooled_width":10,"stride_h":13,"stride_w":14,"top_diff":20,"top_diff_data":1,"top_diff_offset":2,"top_mask":19,"top_mask_data":3,"top_mask_offset":4,"width":8}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void MaxPoolBackward(const int nthreads, global const float* top_diff_data, int top_diff_offset, global const float* top_mask_data, const int top_mask_offset, const int num, const int channels, const int height, const int width, const int pooled_height, const int pooled_width, const int kernel_h, const int kernel_w, const int stride_h, const int stride_w, const int pad_h, const int pad_w, global float* bottom_diff_data, int bottom_diff_offset) {
  global const float* top_diff = top_diff_data + top_diff_offset;
  global const float* top_mask = top_mask_data + top_mask_offset;
  global float* bottom_diff = bottom_diff_data + bottom_diff_offset;

  for (int index = get_group_id(0) * get_local_size(0) + get_local_id(0); index < (nthreads); index += get_local_size(0) * get_num_groups(0)) {
    int w = index % width;
    int h = (index / width) % height;
    int c = (index / width / height) % channels;
    int n = index / width / height / channels;
    int phstart = (h + pad_h < kernel_h) ? 0 : (h + pad_h - kernel_h) / stride_h + 1;
    int phend = min((h + pad_h) / stride_h + 1, pooled_height);
    int pwstart = (w + pad_w < kernel_w) ? 0 : (w + pad_w - kernel_w) / stride_w + 1;
    int pwend = min((w + pad_w) / stride_w + 1, pooled_width);
    float gradient = 0;
    int offset = (n * channels + c) * pooled_height * pooled_width;
    top_diff += offset;
    top_mask += offset;
    for (int ph = phstart; ph < phend; ++ph) {
      for (int pw = pwstart; pw < pwend; ++pw) {
        if (top_mask[hook(19, ph * pooled_width + pw)] - 1 == h * width + w) {
          gradient += top_diff[hook(20, ph * pooled_width + pw)];
        }
      }
    }
    bottom_diff[hook(21, index)] = gradient;
  }
}