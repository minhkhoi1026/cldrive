//{"in_image":0,"out_image":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 2 | 0x10;
kernel void blur(read_only image2d_t in_image, write_only image2d_t out_image) {
  const int2 pos = {get_global_id(0), get_global_id(1)};
  float blue_out;
  float green_out;
  float red_out;
  int y;
  int x;

  red_out = 0.;
  green_out = 0.;
  blue_out = 0.;
  for (y = -1; y <= 1; y = y + 1) {
    for (x = -1; x <= 1; x = x + 1) {
      red_out = red_out + read_imagef(in_image, sampler, pos + (int2)(x, y)).x / 9;
      green_out = green_out + read_imagef(in_image, sampler, pos + (int2)(x, y)).y / 9;
      blue_out = blue_out + read_imagef(in_image, sampler, pos + (int2)(x, y)).z / 9;
    }
  }

  float4 _out_ = {red_out, green_out, blue_out, 0.0f};
  write_imagef(out_image, (int2)(pos.x, pos.y), _out_);
}