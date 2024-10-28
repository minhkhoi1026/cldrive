//{"input_image":0,"output_image":1,"sampling_kernel":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant const sampler_t g_sampler = 0x10 | 0 | 2;
constant const float sampling_kernel[5] = {01.f / 16.f, 04.f / 16.f, 06.f / 16.f, 04.f / 16.f, 01.f / 16.f};

kernel void upsample_row(read_only image2d_t input_image, write_only image2d_t output_image) {
  int2 out_dim = get_image_dim(output_image);

  int2 in_coord = (int2)(get_global_id(0), get_global_id(1));
  int2 out_coord = (int2)(in_coord.x * 2, in_coord.y);

  float4 in0 = read_imagef(input_image, g_sampler, in_coord + (int2)(-1, 0));
  float4 in1 = read_imagef(input_image, g_sampler, in_coord + (int2)(0, 0));
  float4 in2 = read_imagef(input_image, g_sampler, in_coord + (int2)(1, 0));

  float4 out0 = (in0 * sampling_kernel[hook(2, 0)] + in1 * sampling_kernel[hook(2, 2)] + in2 * sampling_kernel[hook(2, 0)]) * 2;

  float4 out1 = (in1 * sampling_kernel[hook(2, 1)] + in2 * sampling_kernel[hook(2, 1)]) * 2;

  write_imagef(output_image, out_coord, out0);

  if ((out_dim.x % 2 != 0) && out_coord.x == out_dim.x - 1) {
    return;
  }

  write_imagef(output_image, out_coord + (int2)(1, 0), out1);
}