//{"input":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 4 | 0x10;
float readImageAsFloat2D(read_only image2d_t image, sampler_t sampler, int2 position) {
  int dataType = get_image_channel_data_type(image);
  if (dataType == 0x10DE || dataType == 0x10D1 || dataType == 0x10D3) {
    return read_imagef(image, sampler, position).x;
  } else if (dataType == 0x10D8 || dataType == 0x10D7) {
    return (float)read_imagei(image, sampler, position).x;
  } else {
    return (float)read_imageui(image, sampler, position).x;
  }
}

float readImageAsFloat3D(read_only image3d_t image, sampler_t sampler, int4 position) {
  int dataType = get_image_channel_data_type(image);
  if (dataType == 0x10DE || dataType == 0x10D1 || dataType == 0x10D3) {
    return read_imagef(image, sampler, position).x;
  } else if (dataType == 0x10D8 || dataType == 0x10D7) {
    return (float)read_imagei(image, sampler, position).x;
  } else {
    return (float)read_imageui(image, sampler, position).x;
  }
}

kernel void gradient2D(read_only image2d_t input, write_only image2d_t output) {
  const int2 pos = {get_global_id(0), get_global_id(1)};

  float2 gradient = {(readImageAsFloat2D(input, sampler, pos + (int2)(1, 0)) - readImageAsFloat2D(input, sampler, pos - (int2)(1, 0))) * 0.5f, (readImageAsFloat2D(input, sampler, pos + (int2)(0, 1)) - readImageAsFloat2D(input, sampler, pos - (int2)(0, 1))) * 0.5f};
  write_imagef(output, pos, gradient.xyyy);
}