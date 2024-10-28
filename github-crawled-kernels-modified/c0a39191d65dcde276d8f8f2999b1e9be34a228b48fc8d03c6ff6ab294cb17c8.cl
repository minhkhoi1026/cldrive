//{"PBOread":1,"PBOspacing":5,"PBOwrite":2,"borderRadius":8,"colors":6,"fillArea":7,"image":0,"imageSpacingX":3,"imageSpacingY":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 4 | 0x10;
kernel void render2D(read_only image2d_t image, global float* PBOread, global float* PBOwrite, private float imageSpacingX, private float imageSpacingY, private float PBOspacing, global float* colors, global char* fillArea, private int borderRadius) {
  const int2 PBOposition = {get_global_id(0), get_global_id(1)};
  const int linearPosition = PBOposition.x + (get_global_size(1) - 1 - PBOposition.y) * get_global_size(0);

  float2 imagePosition = convert_float2(PBOposition) * PBOspacing;
  imagePosition.x /= imageSpacingX;
  imagePosition.y /= imageSpacingY;
  imagePosition = round(imagePosition);

  float2 offsets[8] = {{1, 0}, {0, 1}, {1, 1}, {-1, 0}, {0, -1}, {-1, -1}, {-1, 1}, {1, -1}};

  float4 float3;
  char useBackground = 1;

  if (imagePosition.x < get_image_width(image) && imagePosition.y < get_image_height(image)) {
    unsigned int label = read_imageui(image, sampler, imagePosition).x;

    if (label > 0) {
      char getColor = 0;
      if (fillArea[hook(7, label)] == 1) {
        getColor = 1;
      } else {
        for (int a = -borderRadius; a <= borderRadius; ++a) {
          for (int b = -borderRadius; b <= borderRadius; ++b) {
            float2 offset = {a, b};
            if (length(offset) < borderRadius && read_imageui(image, sampler, imagePosition + offset).x != label) {
              getColor = 1;
            }
          }
        }
      }
      if (getColor == 1) {
        useBackground = 0;

        float3.xyz = vload3(label, colors);
        float3.w = 1.0f;
      }
    }
  }

  if (useBackground == 1) {
    float3 = vload4(linearPosition, PBOread);
  }

  vstore4(float3, linearPosition, PBOwrite);
}