//{"input_im":0,"output_im":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void avgpool2d(global float* input_im, global float* restrict output_im) {
  int class_index = get_global_id(0);

  input_im += 169 * class_index;

  float tmp = 0.0f;

  for (int i = 0; i < 169; i++) {
    tmp += input_im[hook(0, i)];
  }

  output_im[hook(1, class_index)] = tmp / 169.0;
}