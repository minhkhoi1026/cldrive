//{"input_uv":2,"input_y":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float lab_fun(float a) {
  if (a > 0.008856f)
    return pow(a, 1.0f / 3);
  else
    return (float)(7.787f * a + 16.0f / 116);
}
kernel void kernel_csc_nv12torgba(read_only image2d_t input_y, write_only image2d_t output, read_only image2d_t input_uv) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  sampler_t sampler = 0 | 0 | 0x10;
  float4 pixel_y1 = read_imagef(input_y, sampler, (int2)(2 * x, 2 * y));
  float4 pixel_y2 = read_imagef(input_y, sampler, (int2)(2 * x + 1, 2 * y));
  float4 pixel_y3 = read_imagef(input_y, sampler, (int2)(2 * x, 2 * y + 1));
  float4 pixel_y4 = read_imagef(input_y, sampler, (int2)(2 * x + 1, 2 * y + 1));
  float4 pixel_u = read_imagef(input_uv, sampler, (int2)(2 * x, y));
  float4 pixel_v = read_imagef(input_uv, sampler, (int2)(2 * x + 1, y));
  float4 pixel_out1, pixel_out2, pixel_out3, pixel_out4;
  pixel_out1.x = pixel_y1.x + 1.13983f * (pixel_v.x - 0.5f);
  pixel_out1.y = pixel_y1.x - 0.39465f * (pixel_u.x - 0.5f) - 0.5806f * (pixel_v.x - 0.5f);
  pixel_out1.z = pixel_y1.x + 2.03211f * (pixel_u.x - 0.5f);
  pixel_out1.w = 0.0f;
  pixel_out2.x = pixel_y2.x + 1.13983f * (pixel_v.x - 0.5f);
  pixel_out2.y = pixel_y2.x - 0.39465f * (pixel_u.x - 0.5f) - 0.5806f * (pixel_v.x - 0.5f);
  pixel_out2.z = pixel_y2.x + 2.03211f * (pixel_u.x - 0.5f);
  pixel_out2.w = 0.0f;
  pixel_out3.x = pixel_y3.x + 1.13983f * (pixel_v.x - 0.5f);
  pixel_out3.y = pixel_y3.x - 0.39465f * (pixel_u.x - 0.5f) - 0.5806f * (pixel_v.x - 0.5f);
  pixel_out3.z = pixel_y3.x + 2.03211f * (pixel_u.x - 0.5f);
  pixel_out3.w = 0.0f;
  pixel_out4.x = pixel_y4.x + 1.13983f * (pixel_v.x - 0.5f);
  pixel_out4.y = pixel_y4.x - 0.39465f * (pixel_u.x - 0.5f) - 0.5806f * (pixel_v.x - 0.5f);
  pixel_out4.z = pixel_y4.x + 2.03211f * (pixel_u.x - 0.5f);
  pixel_out4.w = 0.0f;
  write_imagef(output, (int2)(2 * x, 2 * y), pixel_out1);
  write_imagef(output, (int2)(2 * x + 1, 2 * y), pixel_out2);
  write_imagef(output, (int2)(2 * x, 2 * y + 1), pixel_out3);
  write_imagef(output, (int2)(2 * x + 1, 2 * y + 1), pixel_out4);
}