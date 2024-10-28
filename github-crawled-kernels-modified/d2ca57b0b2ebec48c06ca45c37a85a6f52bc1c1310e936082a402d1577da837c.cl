//{"input_image":0,"output_image":1,"sampling_kernel":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant const sampler_t g_sampler = 0x10 | 0 | 2;
constant const float sampling_kernel[5] = {01.f / 16.f, 04.f / 16.f, 06.f / 16.f, 04.f / 16.f, 01.f / 16.f};

kernel void downsample_col(read_only image2d_t input_image, write_only image2d_t output_image) {
  int2 out_coord = (int2)(get_global_id(0), get_global_id(1));
  int2 in_coord = (int2)(out_coord.x, out_coord.y * 2);

  float4 sample = 0.0f;
  for (int i = -2; i < 3; ++i) {
    sample += read_imagef(input_image, g_sampler, in_coord + (int2)(0, i)) * sampling_kernel[hook(2, 2 + i)];
  }

  write_imagef(output_image, out_coord, sample);
}