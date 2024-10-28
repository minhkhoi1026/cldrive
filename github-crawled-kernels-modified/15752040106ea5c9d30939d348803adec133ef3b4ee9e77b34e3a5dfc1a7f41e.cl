//{"filter":2,"filter_width":3,"img_in":0,"img_out":1,"sampler":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void convolution(read_only image2d_t img_in, write_only image2d_t img_out, constant float* filter, int filter_width, sampler_t sampler) {
  int out_col = get_global_id(0);
  int out_row = get_global_id(1);

  int half_width = (int)(filter_width / 2);

  float4 sum = {0.0f, 0.0f, 0.0f, 0.0f};

  int filter_idx = 0;

  int2 coords;

  for (int i = -half_width; i <= half_width; i++) {
    coords.y = out_row + i;

    for (int j = -half_width; j <= half_width; j++) {
      coords.x = out_col + j;

      float4 pixel = read_imagef(img_in, sampler, coords);

      sum.x += pixel.x * filter[hook(2, filter_idx++)];
    }
  }

  coords.x = out_col;
  coords.y = out_row;

  write_imagef(img_out, coords, sum);
}