//{"convolution_window":2,"img_input":0,"img_output":1,"window_size_x":3,"window_size_y":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vglClFuzzyGeoDilate(read_only image2d_t img_input, write_only image2d_t img_output, constant float* convolution_window, int window_size_x, int window_size_y) {
  int2 coords = (int2)(get_global_id(0), get_global_id(1));
  const sampler_t smp = 0 | 2 | 0x10;

  int factorx = floor((float)window_size_x / 2.0f);
  int factory = floor((float)window_size_y / 2.0f);
  int conv_controller = 0;
  float4 pmax = (0, 0, 0, 0);
  for (int j = -factory; j <= factory; j++) {
    for (int i = -factorx; i <= factorx; i++) {
      float4 a = read_imagef(img_input, smp, (int2)(coords.x + i, coords.y + j));
      float b = convolution_window[hook(2, conv_controller)];
      float4 S = sqrt(a * b);
      pmax = max(pmax, S);
      conv_controller++;
    }
  }
  write_imagef(img_output, coords, pmax);
}