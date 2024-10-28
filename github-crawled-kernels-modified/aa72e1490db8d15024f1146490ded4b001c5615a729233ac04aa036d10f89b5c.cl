//{"blurred":0,"collapsed":2,"laplacian":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant const sampler_t g_sampler = 0x10 | 0 | 2;
constant const float sampling_kernel[5] = {01.f / 16.f, 04.f / 16.f, 06.f / 16.f, 04.f / 16.f, 01.f / 16.f};

kernel void collapse_level(read_only image2d_t blurred, read_only image2d_t laplacian, write_only image2d_t collapsed) {
  int2 coord = (int2)(get_global_id(0), get_global_id(1));

  float4 b = read_imagef(blurred, g_sampler, coord);
  float4 l = read_imagef(laplacian, g_sampler, coord);

  float4 c = b + l;

  c = clamp(c, 0.0f, 1.0f);

  write_imagef(collapsed, coord, c);
}