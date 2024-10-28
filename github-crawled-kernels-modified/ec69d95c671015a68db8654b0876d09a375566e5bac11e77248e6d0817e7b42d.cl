//{"dst":1,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t sampler = 2 | 0x10;
kernel void sobel(read_only image2d_t src, write_only image2d_t dst) {
  int x = (int)get_global_id(0);
  int y = (int)get_global_id(1);

  if (x >= get_image_width(src) || y >= get_image_height(src)) {
    return;
  }

  float4 p00 = read_imagef(src, sampler, (int2)(x - 1, y - 1));
  float4 p10 = read_imagef(src, sampler, (int2)(x, y - 1));
  float4 p20 = read_imagef(src, sampler, (int2)(x + 1, y - 1));

  float4 p01 = read_imagef(src, sampler, (int2)(x - 1, y));
  float4 p21 = read_imagef(src, sampler, (int2)(x + 1, y));

  float4 p02 = read_imagef(src, sampler, (int2)(x - 1, y + 1));
  float4 p12 = read_imagef(src, sampler, (int2)(x, y + 1));
  float4 p22 = read_imagef(src, sampler, (int2)(x + 1, y + 1));

  float3 gx = -p00.xyz - p20.xyz + 2.0f * (p21.xyz - p01.xyz) - p02.xyz + p22.xyz;

  float3 gy = -p00.xyz - p20.xyz + 2.0f * (p12.xyz - p10.xyz) + p02.xyz + p22.xyz;

  float gs_x = 0.3333f * (gx.x + gx.y + gx.z);
  float gs_y = 0.3333f * (gy.x + gy.y + gy.z);

  float g = native_sqrt(gs_x * gs_x + gs_y * gs_y);

  if (g < 1.1) {
    g = 0.0;
  } else {
    g /= 2.0;
  }

  write_imagef(dst, (int2)(x, y), (float4)(g, g, g, 1.0f));
}