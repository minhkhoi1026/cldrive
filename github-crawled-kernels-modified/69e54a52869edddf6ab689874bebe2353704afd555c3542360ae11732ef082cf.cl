//{"bottom_diff":12,"channels":3,"height":4,"kernel_h":8,"kernel_w":9,"nthreads":0,"pooled_h":6,"pooled_w":7,"rand_idx":1,"rand_idx_slice":14,"stride_h":10,"stride_w":11,"top_diff":2,"top_diff_slice":13,"width":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sto_pool_backward(const int nthreads, global const float* rand_idx, global const float* const top_diff, const int channels, const int height, const int width, const int pooled_h, const int pooled_w, const int kernel_h, const int kernel_w, const int stride_h, const int stride_w, global float* bottom_diff) {
  for (int i = get_global_id(0); i < nthreads; i += get_global_size(0)) {
    const int w = i % width;
    const int h = (i / width) % height;
    const int c = (i / width / height) % channels;
    const int n = i / width / height / channels;

    const int phstart = (h < kernel_h) ? 0 : (h - kernel_h) / stride_h + 1;
    const int phend = min(h / stride_h + 1, pooled_h);
    const int pwstart = (w < kernel_w) ? 0 : (w - kernel_w) / stride_w + 1;
    const int pwend = min(w / stride_w + 1, pooled_w);
    float gradient = 0.0;
    global const float* rand_idx_slice = rand_idx + (n * channels + c) * pooled_h * pooled_w;
    global const float* top_diff_slice = top_diff + (n * channels + c) * pooled_h * pooled_w;
    for (int ph = phstart; ph < phend; ++ph) {
      for (int pw = pwstart; pw < pwend; ++pw) {
        gradient += top_diff_slice[hook(13, ph * pooled_w + pw)] * (i == (int)(rand_idx_slice[hook(14, ph * pooled_w + pw)]) ? 1.0 : 0.0);
      }
    }
    bottom_diff[hook(12, i)] = gradient;
  }
}