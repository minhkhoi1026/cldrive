//{"filter":1,"input":0,"output":3,"radius":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t imageSampler = 0 | 2 | 0x10;
kernel void convolveHoriz1D(read_only image2d_t input, global const float* filter, int radius, write_only image2d_t output) {
  int2 coord = (int2)(get_global_id(0), get_global_id(1));
  float4 temp = 0.0f;
  int i = 0;

  int2 pixel = coord;
  int left = pixel.x - radius;
  int right = pixel.x + radius;

  for (pixel.x = left; pixel.x <= right; pixel.x++, i++) {
    temp += filter[hook(1, i)] * read_imagef(input, imageSampler, pixel);
  }

  write_imagef(output, coord, temp);
}