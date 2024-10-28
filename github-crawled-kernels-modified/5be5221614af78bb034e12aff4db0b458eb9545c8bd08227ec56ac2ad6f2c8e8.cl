//{"bottom":1,"bottom_slice":13,"channels":2,"height":3,"kernel_h":7,"kernel_w":8,"nthreads":0,"pooled_h":5,"pooled_w":6,"rand_idx":11,"stride_h":9,"stride_w":10,"top":12,"width":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sto_pool_forward_train(const int nthreads, global const float* bottom, const int channels, const int height, const int width, const int pooled_h, const int pooled_w, const int kernel_h, const int kernel_w, const int stride_h, const int stride_w, global float* rand_idx, global float* top) {
  for (int i = get_global_id(0); i < nthreads; i += get_global_size(0)) {
    const int pw = i % pooled_w;
    const int ph = (i / pooled_w) % pooled_h;
    const int c = (i / pooled_w / pooled_h) % channels;
    const int n = i / pooled_w / pooled_h / channels;

    const int hstart = ph * stride_h;
    const int hend = min(hstart + kernel_h, height);
    const int wstart = pw * stride_w;
    const int wend = min(wstart + kernel_w, width);
    float cumsum = 0.;
    global const float* bottom_slice = bottom + (n * channels + c) * height * width;

    for (int h = hstart; h < hend; ++h) {
      for (int w = wstart; w < wend; ++w) {
        cumsum += bottom_slice[hook(13, h * width + w)];
      }
    }
    const float thres = rand_idx[hook(11, i)] * cumsum;

    cumsum = 0;
    for (int h = hstart; h < hend; ++h) {
      for (int w = wstart; w < wend; ++w) {
        cumsum += bottom_slice[hook(13, h * width + w)];
        if (cumsum >= thres) {
          rand_idx[hook(11, i)] = ((n * channels + c) * height + h) * width + w;
          top[hook(12, i)] = bottom_slice[hook(13, h * width + w)];
          h = hend;
          w = wend;
        }
      }
    }
  }
}