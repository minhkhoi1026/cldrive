//{"convolution_window":2,"img_input":0,"img_output":1,"window_size_x":3,"window_size_y":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vglClDilate(read_only image2d_t img_input, write_only image2d_t img_output, constant float* convolution_window, int window_size_x, int window_size_y) {
  int2 coords = (int2)(get_global_id(0), get_global_id(1));
  const sampler_t smp = 0 | 2 | 0x10;

  int factorx = floor((float)window_size_x / 2.0f);
  int factory = floor((float)window_size_y / 2.0f);
  int conv_controller = 0;
  float4 pmax = 0.0f;
  for (int i = -factory; i <= factory; i++) {
    for (int j = -factorx; j <= factorx; j++) {
      float4 p = read_imagef(img_input, smp, (int2)(coords.x + j, coords.y + i));
      if (!(convolution_window[hook(2, conv_controller)] == 0))
        pmax = max(p, pmax);
      conv_controller++;
    }
  }
  write_imagef(img_output, coords, pmax);
}