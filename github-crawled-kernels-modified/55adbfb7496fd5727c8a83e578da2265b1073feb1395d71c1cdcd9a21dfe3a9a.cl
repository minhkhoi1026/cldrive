//{"frameCount":3,"input":0,"memoryOut":2,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 4 | 0x10;
float getPixelAsFloat(read_only image2d_t image, int2 pos) {
  float value;
  int dataType = get_image_channel_data_type(image);
  if (dataType == 0x10DE) {
    value = read_imagef(image, sampler, pos).x;
  } else if (dataType == 0x10DA || dataType == 0x10DB) {
    value = read_imageui(image, sampler, pos).x;
  } else {
    value = read_imagei(image, sampler, pos).x;
  }
  return value;
}

kernel void WMAinitialize(read_only image2d_t input, write_only image2d_t output, write_only image2d_t memoryOut, private int frameCount) {
  const int2 pos = {get_global_id(0), get_global_id(1)};

  float value = getPixelAsFloat(input, pos);
  float sum = value * frameCount;
  float numerator = 0.0f;
  for (int i = 0; i < frameCount; ++i) {
    numerator += (i + 1) * value;
  }
  float result = numerator / (frameCount * (frameCount + 1.0f) / 2.0f);

  write_imagef(memoryOut, pos, (float4)(sum, numerator, 0, 0));

  int dataType = get_image_channel_data_type(output);
  if (dataType == 0x10DE) {
    write_imagef(output, pos, result);
  } else {
    if (dataType == 0x10DA || dataType == 0x10DB) {
      write_imageui(output, pos, (unsigned int)round(result));
    } else {
      write_imagei(output, pos, (int)round(result));
    }
  }
}