//{"input":0,"output":1,"useInterpolation":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t samplerLinear = 1 | 0 | 0x20;
constant sampler_t samplerNearest = 1 | 0 | 0x10;
void writeToImage(write_only image2d_t input, int2 position, float4 value) {
  int dataType = get_image_channel_data_type(input);
  if (dataType == 0x10DE) {
    write_imagef(input, position, value);
  } else if (dataType == 0x10DA || dataType == 0x10DB) {
    write_imageui(input, position, convert_uint4(value));
  } else {
    write_imagei(input, position, convert_int4(value));
  }
}

float4 readFromImage(read_only image2d_t input, sampler_t sampler, float2 position) {
  int dataType = get_image_channel_data_type(input);
  if (dataType == 0x10DE) {
    return read_imagef(input, sampler, position);
  } else if (dataType == 0x10DA || dataType == 0x10DB) {
    return convert_float4(read_imageui(input, sampler, position));
  } else {
    return convert_float4(read_imagei(input, sampler, position));
  }
}

kernel void resize2D(read_only image2d_t input, write_only image2d_t output, private char useInterpolation) {
  const int2 position = {get_global_id(0), get_global_id(1)};
  const float2 normalizedPosition = {(float)position.x / get_global_size(0), (float)position.y / get_global_size(1)};
  int dataType = get_image_channel_data_type(input);
  float4 value;
  if (useInterpolation == 1) {
    value = readFromImage(input, samplerLinear, normalizedPosition);
  } else {
    value = readFromImage(input, samplerNearest, normalizedPosition);
  }
  writeToImage(output, position, value);
}