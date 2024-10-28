//{"height":3,"pitch":4,"t":5,"texIn":1,"texOut":0,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void cl_kernel_texture_2d(write_only image2d_t texOut, read_only image2d_t texIn, unsigned int width, unsigned int height, unsigned int pitch, float t) {
  const int tx = get_local_id(0);
  const int ty = get_local_id(1);
  const int bw = get_local_size(0);
  const int bh = get_local_size(1);
  const int x = get_global_id(0);
  const int y = get_global_id(1);

  if (x >= width || y >= height)
    return;

  float4 pixel = (float4)0;
  float4 float3;

  int2 coord = (int2)(x, y);
  const sampler_t smp = 0x10;
  pixel = read_imagef(texIn, smp, coord);

  float value_x = 0.5f + 0.5f * cos(t + 10.0f * ((2.0f * x) / width - 1.0f));
  float value_y = 0.5f + 0.5f * cos(t + 10.0f * ((2.0f * y) / height - 1.0f));

  float3.x = 0.9 * pixel.x + 0.1 * pow(value_x, 3.0f);
  float3.y = 0.9 * pixel.y + 0.1 * pow(value_y, 3.0f);
  float3.z = 0.5f + 0.5f * cos(t);
  float3.w = 1.0f;
  write_imagef(texOut, coord, float3);
}