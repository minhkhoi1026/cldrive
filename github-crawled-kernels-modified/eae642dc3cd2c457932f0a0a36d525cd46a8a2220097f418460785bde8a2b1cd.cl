//{"Lwhite_acc":3,"input_image":0,"logAvgLum_acc":2,"output_image":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float GL_to_CL(unsigned int val);
float3 RGBtoXYZ(float3 rgb);
const sampler_t sampler = 0 | 0 | 0x10;
kernel void reinhardGlobal(read_only image2d_t input_image, write_only image2d_t output_image, global float* logAvgLum_acc, global float* Lwhite_acc) {
  float Lwhite = Lwhite_acc[hook(3, 0)];
  float logAvgLum = logAvgLum_acc[hook(2, 0)];

  int2 pos;
  uint4 pixel;
  float3 rgb, xyz;
  for (pos.y = get_global_id(1); pos.y < 128; pos.y += get_global_size(1)) {
    for (pos.x = get_global_id(0); pos.x < 16; pos.x += get_global_size(0)) {
      pixel = read_imageui(input_image, sampler, pos);

      rgb.x = GL_to_CL(pixel.x);
      rgb.y = GL_to_CL(pixel.y);
      rgb.z = GL_to_CL(pixel.z);

      xyz = RGBtoXYZ(rgb);

      float L = ((8 * 1.f) / logAvgLum) * xyz.y;
      float Ld = (L * (1.f + L / (Lwhite * Lwhite))) / (1.f + L);

      pixel.x = clamp((pow(rgb.x / xyz.y, (float).5) * Ld) * 255.f, 0.f, 255.f);
      pixel.y = clamp((pow(rgb.y / xyz.y, (float).5) * Ld) * 255.f, 0.f, 255.f);
      pixel.z = clamp((pow(rgb.z / xyz.y, (float).5) * Ld) * 255.f, 0.f, 255.f);
      write_imageui(output_image, pos, pixel);
    }
  }
}