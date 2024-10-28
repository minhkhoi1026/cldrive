//{"bottom_slice":15,"channels":2,"din":0,"dout":13,"hin":3,"hout":5,"kernel_h":7,"kernel_w":8,"num":1,"pad_h":11,"pad_w":12,"stride_h":9,"stride_w":10,"weight":14,"weight_slice":16,"win":4,"wout":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Depthwiseconv(global float* din, const int num, const int channels, const int hin, const int win, const int hout, const int wout, const int kernel_h, const int kernel_w, const int stride_h, const int stride_w, const int pad_h, const int pad_w, global float* dout, global float* weight) {
  int local_idx = get_global_id(0);
  int size_channel_in = hin * win;
  int size_channel_out = hout * wout;
  int size_kernel = kernel_h * kernel_w;
  const int count = num * channels * hout * wout;

  if (local_idx < count) {
    const int pw = local_idx % wout;
    const int ph = (local_idx / wout) % hout;
    const int c = (local_idx / size_channel_out) % channels;
    const int n = local_idx / size_channel_out / channels;
    int hstart = ph * stride_h - pad_h;
    int wstart = pw * stride_w - pad_w;
    int hend = min(hstart + kernel_h, hin + pad_h);
    int wend = min(wstart + kernel_w, win + pad_w);

    hstart = max(hstart, 0);
    wstart = max(wstart, 0);
    hend = min(hend, hin);
    wend = min(wend, win);
    float aveval = 0;
    global float* bottom_slice = din + (n * channels + c) * size_channel_in;
    global float* weight_slice = weight + c * size_kernel;

    int khstart = hend < kernel_h ? kernel_h - hend : 0;
    int kwstart = wend < kernel_w ? kernel_w - wend : 0;

    for (int h = hstart; h < hend; ++h) {
      for (int w = wstart; w < wend; ++w) {
        aveval += bottom_slice[hook(15, h * win + w)] * weight_slice[hook(16, (khstart + h - hstart) * kernel_w + (kwstart + w - wstart))];
      }
    }

    dout[hook(13, local_idx)] = aveval;
  }
}