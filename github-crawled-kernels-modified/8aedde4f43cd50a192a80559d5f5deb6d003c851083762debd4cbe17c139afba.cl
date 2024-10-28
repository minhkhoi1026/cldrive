//{"filter_weight":1,"input_channels":3,"input_im":0,"input_size":4,"output_im":2,"output_size":7,"pad":5,"stride":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void conv1x1(global float* restrict input_im, global const float* restrict filter_weight, global float* restrict output_im, const int input_channels, const int input_size, const int pad, const int stride, const int output_size) {
  int filter_index = get_global_id(0);
  int i = get_global_id(1);

  filter_weight += filter_index * input_channels;
  output_im += filter_index * output_size * output_size;

  {
    for (int j = 0; j < output_size; j++) {
      float tmp = 0;

      for (int k = 0; k < input_channels; k++) {
        int h = i * stride - pad;
        int w = j * stride - pad;

        if ((h >= 0) && (h < input_size) && (w >= 0) && (w < input_size)) {
          tmp += input_im[hook(0, k * input_size * input_size + h * input_size + w)] * filter_weight[hook(1, k)];
        }
      }
      output_im[hook(2, i * output_size + j)] = tmp;
    }
  }
}