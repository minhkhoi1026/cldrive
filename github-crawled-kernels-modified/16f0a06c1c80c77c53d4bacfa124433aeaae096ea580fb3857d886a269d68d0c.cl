//{"blurred":1,"laplacian":2,"original":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant const sampler_t g_sampler = 0x10 | 0 | 2;
constant const float sampling_kernel[5] = {01.f / 16.f, 04.f / 16.f, 06.f / 16.f, 04.f / 16.f, 01.f / 16.f};

kernel void create_laplacian(read_only image2d_t original, read_only image2d_t blurred, write_only image2d_t laplacian) {
  int2 coord = (int2)(get_global_id(0), get_global_id(1));

  float4 o = read_imagef(original, g_sampler, coord);
  float4 b = read_imagef(blurred, g_sampler, coord);

  float4 l = o - b;

  l.s3 = o.s3;

  write_imagef(laplacian, coord, l);
}