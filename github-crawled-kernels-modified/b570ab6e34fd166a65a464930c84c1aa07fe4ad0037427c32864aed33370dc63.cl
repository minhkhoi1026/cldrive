//{"bottom_data":19,"bottom_data_data":1,"bottom_data_offset":2,"channels":4,"height":5,"kernel_h":9,"kernel_w":10,"nthreads":0,"num":3,"pad_h":13,"pad_w":14,"pooled_height":7,"pooled_width":8,"stride_h":11,"stride_w":12,"top_data":20,"top_data_data":15,"top_data_offset":16,"top_mask":21,"top_mask_data":17,"top_mask_offset":18,"width":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void MaxPoolForward(const int nthreads, global const float* bottom_data_data, int bottom_data_offset, const int num, const int channels, const int height, const int width, const int pooled_height, const int pooled_width, const int kernel_h, const int kernel_w, const int stride_h, const int stride_w, const int pad_h, const int pad_w, global float* top_data_data, int top_data_offset, global float* top_mask_data, int top_mask_offset) {
  global const float* bottom_data = bottom_data_data + bottom_data_offset;
  global float* top_data = top_data_data + top_data_offset;
  global float* top_mask = top_mask_data + top_mask_offset;

  for (int index = get_group_id(0) * get_local_size(0) + get_local_id(0); index < (nthreads); index += get_local_size(0) * get_num_groups(0)) {
    int pw = index % pooled_width;
    int ph = (index / pooled_width) % pooled_height;
    int c = (index / pooled_width / pooled_height) % channels;
    int n = index / pooled_width / pooled_height / channels;
    int hstart = ph * stride_h - pad_h;
    int wstart = pw * stride_w - pad_w;
    int hend = min(hstart + kernel_h, height);
    int wend = min(wstart + kernel_w, width);
    hstart = max(hstart, 0);
    wstart = max(wstart, 0);
    float maxval = -0x1.fffffep127f;
    int maxidx = -1;
    bottom_data += (n * channels + c) * height * width;
    for (int h = hstart; h < hend; ++h) {
      for (int w = wstart; w < wend; ++w) {
        if (bottom_data[hook(19, h * width + w)] > maxval) {
          maxidx = h * width + w;
          maxval = bottom_data[hook(19, maxidx)];
        }
      }
    }
    top_data[hook(20, index)] = maxval;
    top_mask[hook(21, index)] = maxidx + 1;
  }
}