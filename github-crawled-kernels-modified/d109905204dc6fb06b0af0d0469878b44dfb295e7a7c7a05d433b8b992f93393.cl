//{"bias_data":15,"conved_channel":4,"conved_height":5,"conved_width":6,"height":2,"input_data":1,"input_slice":16,"kernel_h":7,"kernel_w":8,"numel":0,"output_data":13,"pad_h":11,"pad_w":12,"stride_h":9,"stride_w":10,"weight_data":14,"weight_slice":17,"width":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline float activation(float in) {
  float output = in;
  return output;
}

inline float4 activation_type4(float4 in

) {
  float4 output = in;
  return output;
}

kernel void depthwise_conv2d(const int numel, global float* input_data, const int height, const int width, const int conved_channel, const int conved_height, const int conved_width, const int kernel_h, const int kernel_w, const int stride_h, const int stride_w, const int pad_h, const int pad_w, global float* output_data, global float* weight_data, global float* bias_data) {
  int index = get_global_id(0);
  int tmp = get_global_size(0);
  for (index; index < numel; index += tmp) {
    const int pw = index % conved_width;
    const int ph = (index / conved_width) % conved_height;
    const int c = (index / conved_width / conved_height) % conved_channel;
    const int n = index / conved_width / conved_height / conved_channel;
    int hstart = ph * stride_h - pad_h;
    int wstart = pw * stride_w - pad_w;
    int hend = min(hstart + kernel_h, height + pad_h);
    int wend = min(wstart + kernel_w, width + pad_w);
    hstart = max(hstart, 0);
    wstart = max(wstart, 0);
    hend = min(hend, height);
    wend = min(wend, width);
    float v = 0;
    global float* input_slice = input_data + (n * conved_channel + c) * height * width;
    global float* weight_slice = weight_data + c * kernel_h * kernel_w;
    int khstart = hend < kernel_h ? kernel_h - hend : 0;
    int kwstart = wend < kernel_w ? kernel_w - wend : 0;
    for (int h = hstart; h < hend; ++h) {
      for (int w = wstart; w < wend; ++w) {
        v += input_slice[hook(16, h * width + w)] * weight_slice[hook(17, (khstart + h - hstart) * kernel_w + (kwstart + w - wstart))];
      }
    }
    if (bias_data != ((void*)0)) {
      v += bias_data[hook(15, c)];
    }

    output_data[hook(13, index)] = v;
  }
}