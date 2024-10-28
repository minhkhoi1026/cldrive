//{"PBOread":1,"PBOspacing":5,"PBOwrite":2,"image":0,"imageSpacingX":3,"imageSpacingY":4,"level":6,"translationX":8,"translationY":9,"window":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t interpolationSampler = 0 | 4 | 0x20;
float4 readPixelAsFloat(image2d_t image, sampler_t sampler, float2 pos) {
  int dataType = get_image_channel_data_type(image);
  if (dataType == 0x10DE) {
    return read_imagef(image, sampler, pos);
  } else if (dataType == 0x10D7 || dataType == 0x10D8) {
    return convert_float4(read_imagei(image, sampler, pos));
  } else {
    return convert_float4(read_imageui(image, sampler, pos));
  }
}

float4 readPixelAsFloat3D(image3d_t image, sampler_t sampler, float4 pos) {
  int dataType = get_image_channel_data_type(image);
  if (dataType == 0x10DE) {
    return read_imagef(image, sampler, pos);
  } else if (dataType == 0x10D7 || dataType == 0x10D8) {
    return convert_float4(read_imagei(image, sampler, pos));
  } else {
    return convert_float4(read_imageui(image, sampler, pos));
  }
}

kernel void render2Dimage(read_only image2d_t image, global float* PBOread, global float* PBOwrite, private float imageSpacingX, private float imageSpacingY, private float PBOspacing, private float level, private float window, private float translationX, private float translationY) {
  const int2 PBOposition = {get_global_id(0), get_global_id(1)};
  const int linearPosition = PBOposition.x + (get_global_size(1) - 1 - PBOposition.y) * get_global_size(0);

  float2 imagePosition = convert_float2(PBOposition) * PBOspacing + (float2)(translationX, translationY);
  imagePosition.x /= imageSpacingX;
  imagePosition.y /= imageSpacingY;

  if (imagePosition.x < get_image_width(image) && imagePosition.y < get_image_height(image)) {
    float4 value = readPixelAsFloat(image, interpolationSampler, imagePosition);

    if (get_image_channel_order(image) == 0x10B0) {
      value.y = value.x;
      value.z = value.x;
    }

    value = (value - level + window / 2) / window;
    value = clamp(value, 0.0f, 1.0f);

    vstore4(value, linearPosition, PBOwrite);
  } else {
    float4 value = vload4(linearPosition, PBOread);

    vstore4(value, linearPosition, PBOwrite);
  }
}