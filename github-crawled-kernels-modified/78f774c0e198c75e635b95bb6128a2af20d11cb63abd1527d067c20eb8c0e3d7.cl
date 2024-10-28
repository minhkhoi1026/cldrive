//{"input":0,"output":1,"p":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_snr(read_only image2d_t input, write_only image2d_t output) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  sampler_t sampler = 0 | 2 | 0x10;

  float4 p[9];
  p[hook(2, 0)] = read_imagef(input, sampler, (int2)(x - 1, y - 1));
  p[hook(2, 1)] = read_imagef(input, sampler, (int2)(x, y - 1));
  p[hook(2, 2)] = read_imagef(input, sampler, (int2)(x + 1, y - 1));
  p[hook(2, 3)] = read_imagef(input, sampler, (int2)(x - 1, y));
  p[hook(2, 4)] = read_imagef(input, sampler, (int2)(x, y));
  p[hook(2, 5)] = read_imagef(input, sampler, (int2)(x + 1, y));
  p[hook(2, 6)] = read_imagef(input, sampler, (int2)(x - 1, y + 1));
  p[hook(2, 7)] = read_imagef(input, sampler, (int2)(x, y + 1));
  p[hook(2, 8)] = read_imagef(input, sampler, (int2)(x + 1, y + 1));

  float4 pixel_out;
  pixel_out.x = (p[hook(2, 0)].x + p[hook(2, 1)].x + p[hook(2, 2)].x + p[hook(2, 3)].x + p[hook(2, 4)].x + p[hook(2, 5)].x + p[hook(2, 6)].x + p[hook(2, 7)].x + p[hook(2, 8)].x) / 9.0f;
  pixel_out.y = (p[hook(2, 0)].y + p[hook(2, 1)].y + p[hook(2, 2)].y + p[hook(2, 3)].y + p[hook(2, 4)].y + p[hook(2, 5)].y + p[hook(2, 6)].y + p[hook(2, 7)].y + p[hook(2, 8)].y) / 9.0f;
  pixel_out.z = (p[hook(2, 0)].z + p[hook(2, 1)].z + p[hook(2, 2)].z + p[hook(2, 3)].z + p[hook(2, 4)].z + p[hook(2, 5)].z + p[hook(2, 6)].z + p[hook(2, 7)].z + p[hook(2, 8)].z) / 9.0f;
  pixel_out.w = p[hook(2, 4)].w;
  write_imagef(output, (int2)(x, y), pixel_out);
}