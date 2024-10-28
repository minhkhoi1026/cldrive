//{"filter_bias":8,"filter_weight":7,"input_channels":0,"input_im":6,"input_size":1,"output_im":9,"output_size":5,"pad":2,"start_channel":4,"stride":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void conv2d3x3(const int input_channels, const int input_size, const int pad, const int stride, const int start_channel, const int output_size, global float* restrict input_im, global const float* restrict filter_weight, global const float* restrict filter_bias, global float* restrict output_im) {
  int filter_index = get_global_id(0);

  filter_weight += filter_index * input_channels * 9;
  float bias = filter_bias[hook(8, filter_index)];
  output_im += (start_channel + filter_index) * output_size * output_size;

  for (int i = 0; i < output_size; i++) {
    for (int j = 0; j < output_size; j++) {
      float tmp = bias;

      for (int k = 0; k < input_channels; k++) {
        for (int l = 0; l < 3; l++) {
          int h = i * stride + l - pad;
          for (int m = 0; m < 3; m++) {
            int w = j * stride + m - pad;
            if ((h >= 0) && (h < input_size) && (w >= 0) && (w < input_size)) {
              tmp += input_im[hook(6, k * input_size * input_size + (i * stride + l - pad) * input_size + j * stride + m - pad)] * filter_weight[hook(7, 9 * k + 3 * l + m)];
            }
          }
        }
      }

      output_im[hook(9, i * output_size + j)] = (tmp > 0.0) ? tmp : 0.0;
    }
  }
}