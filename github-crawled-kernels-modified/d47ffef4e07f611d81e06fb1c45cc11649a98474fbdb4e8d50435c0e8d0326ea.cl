//{"frameCount":5,"input":0,"last":2,"memoryIn":1,"memoryOut":4,"output":3}
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

kernel void WMAiteration(read_only image2d_t input, read_only image2d_t memoryIn, read_only image2d_t last, write_only image2d_t output, write_only image2d_t memoryOut, private int frameCount) {
  const int2 pos = {get_global_id(0), get_global_id(1)};

  float newValue = getPixelAsFloat(input, pos);
  float2 oldMemory = read_imagef(memoryIn, sampler, pos).xy;
  float newTotal = oldMemory.x + newValue - getPixelAsFloat(last, pos);
  float newNumerator = oldMemory.y + frameCount * newValue - oldMemory.x;
  write_imagef(memoryOut, pos, (float4)(newTotal, newNumerator, 0, 0));

  int dataType = get_image_channel_data_type(output);
  if (dataType == 0x10DE) {
    write_imagef(output, pos, newNumerator / (frameCount * (frameCount + 1.0f) / 2.0f));
  } else {
    if (dataType == 0x10DA || dataType == 0x10DB) {
      write_imageui(output, pos, (unsigned int)round(newNumerator / (frameCount * (frameCount + 1.0f) / 2.0f)));
    } else {
      write_imagei(output, pos, (int)round(newNumerator / (frameCount * (frameCount + 1.0f) / 2.0f)));
    }
  }
}