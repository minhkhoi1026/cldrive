//{"input_im":2,"input_size":0,"output_im":3,"output_size":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void maxpool2d(const int input_size, const int output_size, global float* input_im, global float* restrict output_im) {
  int channels = get_global_id(0);

  input_im += channels * input_size * input_size;
  output_im += channels * output_size * output_size;

  for (int i = 0; i < output_size; i++) {
    for (int j = 0; j < output_size; j++) {
      float tmp = 0.0;

      for (int k = 0; k < 3; k++) {
        for (int l = 0; l < 3; l++) {
          float value = input_im[hook(2, (i * 2 + k) * input_size + j * 2 + l)];
          if (value > tmp)
            tmp = value;
        }
      }

      *output_im = tmp;
      output_im++;
    }
  }
}