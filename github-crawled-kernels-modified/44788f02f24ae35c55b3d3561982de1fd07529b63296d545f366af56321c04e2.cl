//{"input_image":0,"output_image":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant const sampler_t g_sampler = 0x10 | 0 | 2;
kernel void halve_image(read_only image2d_t input_image, write_only image2d_t output_image) {
  int2 coord = (int2)(get_global_id(0), get_global_id(1));

  float4 val = read_imagef(input_image, g_sampler, coord) / 2;

  write_imagef(output_image, coord, val);
}