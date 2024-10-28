//{"convolution_window":2,"img_input":0,"img_output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vglClBlurSq3(read_only image2d_t img_input, write_only image2d_t img_output) {
  int2 coords = (int2)(get_global_id(0), get_global_id(1));
  const sampler_t smp = 0 | 2 | 0x10;

  float4 result = (0, 0, 0, 0);
  float convolution_window[9] = {
      1.0 / 16.0, 2.0 / 16.0, 1.0 / 16.0, 2.0 / 16.0, 4.0 / 16.0, 2.0 / 16.0, 1.0 / 16.0, 2.0 / 16.0, 1.0 / 16.0,
  };

  int xi = 0;
  int yi = 0;
  for (xi = -1; xi <= 1; xi++) {
    for (yi = -1; yi <= 1; yi++) {
      float4 p = read_imagef(img_input, smp, (int2)(coords.x + xi, coords.y + yi));
      p.xyz *= convolution_window[hook(2, 3 * (xi + 1) + yi + 1)];
      result += p;
    }
  }
  write_imagef(img_output, coords, result);
}