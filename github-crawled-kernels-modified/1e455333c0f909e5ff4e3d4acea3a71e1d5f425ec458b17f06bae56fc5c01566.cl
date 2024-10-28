//{"bottom":1,"bottom_slice":14,"channels":2,"height":3,"kernel_h":7,"kernel_w":8,"nthreads":0,"pad_h":11,"pad_w":12,"pooled_h":5,"pooled_w":6,"stride_h":9,"stride_w":10,"top":13,"width":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ave_pool_forward(const int nthreads, global const float* const bottom, const int channels, const int height, const int width, const int pooled_h, const int pooled_w, const int kernel_h, const int kernel_w, const int stride_h, const int stride_w, const int pad_h, const int pad_w, global float* top) {
  for (int i = get_global_id(0); i < nthreads; i += get_global_size(0)) {
    const int pw = i % pooled_w;
    const int ph = (i / pooled_w) % pooled_h;
    const int c = (i / pooled_w / pooled_h) % channels;
    const int n = i / pooled_w / pooled_h / channels;
    int hstart = ph * stride_h - pad_h;
    int wstart = pw * stride_w - pad_w;
    int hend = min(hstart + kernel_h, height + pad_h);
    int wend = min(wstart + kernel_w, width + pad_w);
    const int pool_size = (hend - hstart) * (wend - wstart);
    hstart = max(hstart, (int)0);
    wstart = max(wstart, (int)0);
    hend = min(hend, height);
    wend = min(wend, width);
    float aveval = 0;
    global const float* bottom_slice = bottom + (n * channels + c) * height * width;
    for (int h = hstart; h < hend; ++h) {
      for (int w = wstart; w < wend; ++w) {
        aveval += bottom_slice[hook(14, h * width + w)];
      }
    }
    top[hook(13, i)] = aveval / pool_size;
  }
}