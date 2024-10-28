//{"filter_bias":4,"filter_weight":3,"input_channels":0,"input_im":2,"input_size":1,"output_im":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void conv2d1x1(const int input_channels, const int input_size, global float* input_im, global const float* restrict filter_weight, global const float* restrict filter_bias, global float* restrict output_im) {
  int filter_index = get_global_id(0);

  filter_weight += filter_index * input_channels;

  float bias = filter_bias[hook(4, filter_index)];

  output_im += filter_index * input_size * input_size;

  for (int i = 0; i < input_size; i++) {
    for (int j = 0; j < input_size; j++) {
      float tmp = bias;
      for (int k = 0; k < input_channels; k++) {
        tmp += input_im[hook(2, k * input_size * input_size + i * input_size + j)] * filter_weight[hook(3, k)];
      }

      output_im[hook(5, i * input_size + j)] = (tmp > 0.0) ? tmp : 0.0;
    }
  }
}