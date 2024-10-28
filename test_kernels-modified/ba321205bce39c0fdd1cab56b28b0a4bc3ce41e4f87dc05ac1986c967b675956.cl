//{"bottom":1,"bottom_slice":15,"channels":2,"height":3,"kernel_h":7,"kernel_w":8,"mask":14,"nthreads":0,"pad_h":11,"pad_w":12,"pooled_h":5,"pooled_w":6,"stride_h":9,"stride_w":10,"top":13,"width":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void max_pool_forward(const int nthreads, global const float* bottom, const int channels, const int height, const int width, const int pooled_h, const int pooled_w, const int kernel_h, const int kernel_w, const int stride_h, const int stride_w, const int pad_h, const int pad_w, global float* top, global float* mask) {
  for (int i = get_global_id(0); i < nthreads; i += get_global_size(0)) {
    const int pw = i % pooled_w;
    const int ph = (i / pooled_w) % pooled_h;
    const int c = (i / pooled_w / pooled_h) % channels;
    const int n = i / pooled_w / pooled_h / channels;

    int hstart = ph * stride_h - pad_h;
    int wstart = pw * stride_w - pad_w;
    const int hend = min(hstart + kernel_h, height);
    const int wend = min(wstart + kernel_w, width);
    hstart = max(hstart, (int)0);
    wstart = max(wstart, (int)0);

    float maxval = -0x1.fffffep127f;
    int maxidx = -1;
    global const float* bottom_slice = bottom + (n * channels + c) * height * width;
    for (int h = hstart; h < hend; ++h) {
      for (int w = wstart; w < wend; ++w) {
        const int index = h * width + w;
        if (bottom_slice[hook(15, index)] > maxval) {
          maxidx = index;
          maxval = bottom_slice[hook(15, maxidx)];
        }
      }
    }
    top[hook(13, i)] = maxval;
    mask[hook(14, i)] = (float)maxidx;
  }
}