//{"convolution_window":2,"gama":5,"img_input":0,"img_output":1,"window_size_x":3,"window_size_y":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vglClFuzzyDaPErode(read_only image2d_t img_input, write_only image2d_t img_output, constant float* convolution_window, int window_size_x, int window_size_y, float gama) {
  int2 coords = (int2)(get_global_id(0), get_global_id(1));
  const sampler_t smp = 0 | 2 | 0x10;

  int factorx = floor((float)window_size_x / 2.0f);
  int factory = floor((float)window_size_y / 2.0f);
  int conv_controller = 0;
  float4 pmin = (1.0, 1.0, 1.0, 1.0);
  for (int j = -factory; j <= factory; j++) {
    for (int i = -factorx; i <= factorx; i++) {
      float4 a = read_imagef(img_input, smp, (int2)(coords.x + i, coords.y + j));
      float b = 1 - convolution_window[hook(2, conv_controller)];
      float4 S = 1 - (((1 - a) * (1 - b)) / (max(max(1 - a, 1 - b), gama)));
      pmin = min(pmin, S);
      conv_controller++;
    }
  }
  write_imagef(img_output, coords, pmin);
}