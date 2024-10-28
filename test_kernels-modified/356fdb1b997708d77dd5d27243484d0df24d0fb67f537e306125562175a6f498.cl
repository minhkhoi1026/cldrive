//{"bottom_diff":14,"channels":3,"height":4,"kernel_h":8,"kernel_w":9,"mask":2,"mask_slice":15,"nthreads":0,"pad_h":12,"pad_w":13,"pooled_h":6,"pooled_w":7,"stride_h":10,"stride_w":11,"top_diff":1,"top_diff_slice":16,"width":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void max_pool_backward(const int nthreads, global const float* top_diff, global const float* mask, const int channels, const int height, const int width, const int pooled_h, const int pooled_w, const int kernel_h, const int kernel_w, const int stride_h, const int stride_w, const int pad_h, const int pad_w, global float* bottom_diff) {
  for (int i = get_global_id(0); i < nthreads; i += get_global_size(0)) {
    const int w = i % width;
    const int h = (i / width) % height;
    const int c = (i / width / height) % channels;
    const int n = i / width / height / channels;

    const int phstart = (h + pad_h < kernel_h) ? 0 : (h + pad_h - kernel_h) / stride_h + 1;
    const int phend = min((h + pad_h) / stride_h + 1, pooled_h);
    const int pwstart = (w + pad_w < kernel_w) ? 0 : (w + pad_w - kernel_w) / stride_w + 1;
    const int pwend = min((w + pad_w) / stride_w + 1, pooled_w);
    float gradient = 0.0f;
    const int offset = (n * channels + c) * pooled_h * pooled_w;
    global const float* top_diff_slice = top_diff + offset;
    global const float* mask_slice = mask + offset;
    for (int ph = phstart; ph < phend; ++ph) {
      for (int pw = pwstart; pw < pwend; ++pw) {
        if (mask_slice[hook(15, ph * pooled_w + pw)] == (float)(h * width + w)) {
          gradient += top_diff_slice[hook(16, ph * pooled_w + pw)];
        }
      }
    }
    bottom_diff[hook(14, i)] = gradient;
  }
}