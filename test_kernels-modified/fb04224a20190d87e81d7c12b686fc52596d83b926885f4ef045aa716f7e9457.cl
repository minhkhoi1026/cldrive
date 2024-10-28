//{"bottom_data":1,"bottom_slice":13,"channels":3,"height":4,"kernel_h":8,"kernel_w":9,"mask":14,"nthreads":0,"num":2,"pooled_height":6,"pooled_width":7,"stride_h":10,"stride_w":11,"top_data":12,"top_mask":15,"width":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void max_pool_forward_impl_float(const int nthreads, global const float* bottom_data, const int num, const int channels, const int height, const int width, const int pooled_height, const int pooled_width, const int kernel_h, const int kernel_w, const int stride_h, const int stride_w, const int pad_h, const int pad_w, global float* top_data, const int use_mask, global int* mask, global float* top_mask, bool no_mask) {
  for (int index = get_global_id(0); index < nthreads; index += get_global_size(0)) {
    const int pw = index % pooled_width;
    const int ph = (index / pooled_width) % pooled_height;
    const int c = (index / pooled_width / pooled_height) % channels;
    const int n = index / pooled_width / pooled_height / channels;
    int hstart = ph * stride_h - pad_h;
    int wstart = pw * stride_w - pad_w;
    const int hend = min(hstart + kernel_h, height);
    const int wend = min(wstart + kernel_w, width);
    hstart = max(hstart, (int)0);
    wstart = max(wstart, (int)0);
    float maxval = -0x1.fffffep127f;
    int maxidx = -1;
    global const float* bottom_slice = bottom_data + (n * channels + c) * height * width;
    for (int h = hstart; h < hend; ++h) {
      for (int w = wstart; w < wend; ++w) {
        if (bottom_slice[hook(13, h * width + w)] > maxval) {
          maxidx = h * width + w;
          maxval = bottom_slice[hook(13, maxidx)];
        }
      }
    }
    top_data[hook(12, index)] = maxval;
    if (!no_mask) {
      if (use_mask == 1) {
        mask[hook(14, index)] = maxidx;
      } else {
        top_mask[hook(15, index)] = maxidx;
      }
    }
  }
}

kernel void sto_pool_forward_test_float(const int nthreads, global const float* const bottom_data, const int num, const int channels, const int height, const int width, const int pooled_height, const int pooled_width, const int kernel_h, const int kernel_w, const int stride_h, const int stride_w, global float* top_data) {
  for (int index = get_global_id(0); index < nthreads; index += get_global_size(0)) {
    const int pw = index % pooled_width;
    const int ph = (index / pooled_width) % pooled_height;
    const int c = (index / pooled_width / pooled_height) % channels;
    const int n = index / pooled_width / pooled_height / channels;
    const int hstart = ph * stride_h;
    const int hend = min(hstart + kernel_h, height);
    const int wstart = pw * stride_w;
    const int wend = min(wstart + kernel_w, width);

    float cumsum = 0x1.0p-126f;
    float cumvalues = 0.;
    global const float* bottom_slice = bottom_data + (n * channels + c) * height * width;

    for (int h = hstart; h < hend; ++h) {
      for (int w = wstart; w < wend; ++w) {
        cumsum += bottom_slice[hook(13, h * width + w)];
        cumvalues += bottom_slice[hook(13, h * width + w)] * bottom_slice[hook(13, h * width + w)];
      }
    }
    top_data[hook(12, index)] = cumvalues / cumsum;
  }
}