//{"borderRadius":4,"colors":2,"fillArea":3,"image":0,"opacity":5,"texture":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 4 | 0x10;
kernel void renderToTexture(read_only image2d_t image, write_only image2d_t texture, global float* colors, global char* fillArea, private int borderRadius, private float opacity) {
  const int2 imagePosition = {get_global_id(0), get_global_id(1)};

  float4 float3 = {1, 1, 1, 0};

  unsigned int label = read_imageui(image, sampler, imagePosition).x;

  if (label > 0) {
    char getColor = 0;
    if (fillArea[hook(3, label)] == 1) {
      getColor = 1;
    } else {
      for (int a = -borderRadius; a <= borderRadius; ++a) {
        for (int b = -borderRadius; b <= borderRadius; ++b) {
          int2 offset = {a, b};
          if (read_imageui(image, sampler, imagePosition + offset).x != label) {
            if (borderRadius == 1 || length(convert_float2(offset)) < borderRadius) {
              getColor = 1;
            }
          }
        }
      }
    }
    if (getColor == 1) {
      float3.xyz = vload3(label, colors);
      float3.w = opacity;
    }
  }

  write_imagef(texture, (int2)(imagePosition.x, get_image_height(image) - imagePosition.y - 1), float3);
}