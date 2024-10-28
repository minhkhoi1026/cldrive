//{"bias":18,"bias_flag":19,"channel_in_stride":0,"channel_out_stride":1,"channels":5,"din":3,"dout":16,"hin":6,"hout":8,"kernel_h":10,"kernel_size":2,"kernel_w":11,"num":4,"pad_h":14,"pad_w":15,"relu_flag":20,"sharedw":21,"stride_h":12,"stride_w":13,"top_diff_slice":22,"weight":17,"win":7,"wout":9}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void depthwise_deconv_2d(const int channel_in_stride, const int channel_out_stride, const int kernel_size, global const float* din, const int num, const int channels, const int hin, const int win, const int hout, const int wout, const int kernel_h, const int kernel_w, const int stride_h, const int stride_w, const int pad_h, const int pad_w, global float* dout, global const float* weight, global const float* const bias, const int bias_flag, const int relu_flag) {
  int wo = get_global_id(0);
  int w = wo + pad_w;

  int ho = get_global_id(1);
  int h = ho + pad_h;

  int c = get_group_id(2) % channels;
  int i = get_group_id(2);
  int index = i * channel_out_stride + ho * wout + wo;

  local float sharedw[256];

  int idx = get_local_id(1) * get_local_size(0) + get_local_id(0);

  if (idx < kernel_size) {
    sharedw[hook(21, idx)] = weight[hook(17, c * kernel_size + idx)];
  }

  barrier(0x01);

  if (wo < wout && ho < hout) {
    const int phstart = (h < kernel_h) ? 0 : (h - kernel_h) / stride_h + 1;
    const int phend = min(h / stride_h + 1, hin);
    const int pwstart = (w < kernel_w) ? 0 : (w - kernel_w) / stride_w + 1;
    const int pwend = min(w / stride_w + 1, win);

    const int khstart = (h >= kernel_h) ? ((h - kernel_h) % stride_h) + (kernel_h - stride_h) : h;
    const int kwstart = (w >= kernel_w) ? ((w - kernel_w) % stride_w) + (kernel_w - stride_w) : w;

    float gradient = 0;
    const global float* top_diff_slice = din + i * channel_in_stride;

    for (int ph = phstart; ph < phend; ++ph) {
      for (int pw = pwstart; pw < pwend; ++pw) {
        int kh = khstart - (ph - phstart) * stride_h;
        int kw = kwstart - (pw - pwstart) * stride_w;
        gradient += top_diff_slice[hook(22, ph * win + pw)] * sharedw[hook(21, kh * kernel_w + kw)];
      }
    }

    if (bias_flag) {
      gradient += bias[hook(18, c)];
    }

    if (relu_flag) {
      gradient = gradient > (float)0 ? gradient : (float)0;
    }

    dout[hook(16, index)] = gradient;
  }
}