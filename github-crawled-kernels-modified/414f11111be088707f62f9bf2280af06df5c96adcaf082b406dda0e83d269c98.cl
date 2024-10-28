//{"image":0,"level":2,"texture":1,"window":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 4 | 0x10;
float4 readPixelAsFloat(image2d_t image, sampler_t sampler, int2 pos) {
  int dataType = get_image_channel_data_type(image);
  if (dataType == 0x10DE) {
    return read_imagef(image, sampler, pos);
  } else if (dataType == 0x10D7 || dataType == 0x10D8) {
    return convert_float4(read_imagei(image, sampler, pos));
  } else {
    return convert_float4(read_imageui(image, sampler, pos));
  }
}

kernel void renderToTexture(read_only image2d_t image, write_only image2d_t texture, private float level, private float window) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);

  float4 value = readPixelAsFloat(image, sampler, (int2)(x, y));
  if (get_image_channel_order(image) == 0x10B0) {
    value.y = value.x;
    value.z = value.x;
  }

  value = (value - level + window / 2) / window;
  value = clamp(value, 0.0f, 1.0f);
  value.w = 1.0f;
  write_imagef(texture, (int2)(x, get_image_height(image) - y - 1), value);
}