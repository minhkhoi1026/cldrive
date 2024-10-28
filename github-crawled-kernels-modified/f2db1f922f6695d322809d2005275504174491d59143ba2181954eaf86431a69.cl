//{"input":0,"output":1,"scale2":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t imageSampler = 0 | 2 | 0x10;
kernel void det_hessian(read_only image2d_t input, write_only image2d_t output, float scale2) {
  int2 pixel = (int2)(get_global_id(0), get_global_id(1));
  float3 H = 0.0f;

  float center2 = 2 * read_imagef(input, imageSampler, pixel).x;
  H.x = read_imagef(input, imageSampler, pixel + (int2)(1, 0)).x - center2 + read_imagef(input, imageSampler, pixel + (int2)(-1, 0)).x;
  H.y = read_imagef(input, imageSampler, pixel + (int2)(0, 1)).x - center2 + read_imagef(input, imageSampler, pixel + (int2)(0, -1)).x;
  H.z = (read_imagef(input, imageSampler, pixel + (int2)(1, 1)).x - read_imagef(input, imageSampler, pixel + (int2)(1, -1)).x - read_imagef(input, imageSampler, pixel + (int2)(-1, 1)).x + read_imagef(input, imageSampler, pixel + (int2)(-1, -1)).x) / 4.0f;

  float det = scale2 * (H.x * H.y - H.z * H.z);

  write_imagef(output, pixel, (float4)det);
}