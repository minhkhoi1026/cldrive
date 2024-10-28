//{"bottom_diff":13,"channels":2,"height":3,"kernel_h":7,"kernel_w":8,"nthreads":0,"pad_h":11,"pad_w":12,"pooled_h":5,"pooled_w":6,"stride_h":9,"stride_w":10,"top_diff":1,"top_diff_slice":14,"width":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ave_pool_backward(const int nthreads, global const float* top_diff, const int channels, const int height, const int width, const int pooled_h, const int pooled_w, const int kernel_h, const int kernel_w, const int stride_h, const int stride_w, const int pad_h, const int pad_w, global float* bottom_diff) {
  for (int i = get_global_id(0); i < nthreads; i += get_global_size(0)) {
    const int w = i % width + pad_w;
    const int h = (i / width) % height + pad_h;
    const int c = (i / width / height) % channels;
    const int n = i / width / height / channels;

    const int phstart = (h < kernel_h) ? 0 : (h - kernel_h) / stride_h + 1;
    const int phend = min(h / stride_h + 1, pooled_h);
    const int pwstart = (w < kernel_w) ? 0 : (w - kernel_w) / stride_w + 1;
    const int pwend = min(w / stride_w + 1, pooled_w);
    float gradient = 0.0;
    global const float* const top_diff_slice = top_diff + (n * channels + c) * pooled_h * pooled_w;
    for (int ph = phstart; ph < phend; ++ph) {
      for (int pw = pwstart; pw < pwend; ++pw) {
        int hstart = ph * stride_h - pad_h;
        int wstart = pw * stride_w - pad_w;
        int hend = min(hstart + kernel_h, height + pad_h);
        int wend = min(wstart + kernel_w, width + pad_w);
        int pool_size = (hend - hstart) * (wend - wstart);
        gradient += top_diff_slice[hook(14, ph * pooled_w + pw)] / pool_size;
      }
    }
    bottom_diff[hook(13, i)] = gradient;
  }
}