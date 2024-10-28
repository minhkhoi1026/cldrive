//{"dst":1,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t smpUNormNoClampNearest = 0 | 0 | 0x10;
kernel void grayscaleKernel(read_only image2d_t src, write_only image2d_t dst) {
  if (get_global_id(0) >= get_image_width(dst) || get_global_id(1) >= get_image_height(dst)) {
    return;
  }

  float4 float3 = read_imagef(src, smpUNormNoClampNearest, (int2)(get_global_id(0), get_global_id(1)));
  float gray = 0.2989 * float3.x + 0.5870 * float3.y + 0.1140 * float3.z;
  float4 result = (float4)(gray, gray, gray, float3.w);

  write_imagef(dst, (int2)(get_global_id(0), get_global_id(1)), result);
}