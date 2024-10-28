//{"input":0,"output":1,"scaleX":2,"scaleY":3,"useInterpolation":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t samplerLinear = 0 | 4 | 0x20;
constant sampler_t samplerNearest = 0 | 4 | 0x10;
float readImageAsFloat2D(read_only image2d_t image, sampler_t sampler, float2 position) {
  int dataType = get_image_channel_data_type(image);
  if (dataType == 0x10DE || dataType == 0x10D1 || dataType == 0x10D3) {
    return read_imagef(image, sampler, position).x;
  } else if (dataType == 0x10D8 || dataType == 0x10D7) {
    return (float)read_imagei(image, sampler, position).x;
  } else {
    return (float)read_imageui(image, sampler, position).x;
  }
}

kernel void resample2D(read_only image2d_t input, write_only image2d_t output, private float scaleX, private float scaleY, private uchar useInterpolation) {
  const int2 outputPosition = {get_global_id(0), get_global_id(1)};
  const int2 size = {get_global_size(0), get_global_size(1)};
  float2 inputPosition = {outputPosition.x * (1.0f / scaleX), outputPosition.y * (1.0f / scaleY)};

  int dataType = get_image_channel_data_type(output);
  float value;
  if (useInterpolation == 1) {
    value = readImageAsFloat2D(input, samplerLinear, inputPosition);
  } else {
    value = readImageAsFloat2D(input, samplerNearest, inputPosition);
  }
  if (dataType == 0x10DE || dataType == 0x10D1 || dataType == 0x10D3) {
    write_imagef(output, outputPosition, value);
  } else if (dataType == 0x10D8 || dataType == 0x10D7) {
    write_imagei(output, outputPosition, round(value));
  } else {
    write_imageui(output, outputPosition, round(value));
  }
}