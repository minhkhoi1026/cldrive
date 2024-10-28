//{"((__global char *)output)":4,"((__global float *)output)":7,"((__global short *)output)":6,"((__global uchar *)output)":3,"((__global ushort *)output)":5,"input":0,"output":1,"useInterpolation":2}
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

float4 readFromImage3D(read_only image3d_t input, sampler_t sampler, float4 position) {
  int dataType = get_image_channel_data_type(input);
  if (dataType == 0x10DE) {
    return read_imagef(input, sampler, position);
  } else if (dataType == 0x10DA || dataType == 0x10DB) {
    return convert_float4(read_imageui(input, sampler, position));
  } else {
    return convert_float4(read_imagei(input, sampler, position));
  }
}

kernel void resize3D(read_only image3d_t input,

                     global void* output,

                     private char useInterpolation) {
  const int4 pos = {get_global_id(0), get_global_id(1), get_global_id(2), 0};
  const float4 normalizedPosition = {(float)pos.x / get_global_size(0), (float)pos.y / get_global_size(1), (float)pos.z / get_global_size(2), 0};
  int dataType = get_image_channel_data_type(input);
  float4 value;
  if (useInterpolation == 1) {
    value = readFromImage3D(input, samplerLinear, normalizedPosition);
  } else {
    value = readFromImage3D(input, samplerNearest, normalizedPosition);
  }

  if (dataType == 0x10DA) {
    ((global uchar*)output)[hook(3, pos.x + pos.y * get_global_size(0) + pos.z * get_global_size(0) * get_global_size(1))] = value.x;
  } else if (dataType == 0x10D7) {
    ((global char*)output)[hook(4, pos.x + pos.y * get_global_size(0) + pos.z * get_global_size(0) * get_global_size(1))] = value.x;
  } else if (dataType == 0x10DB) {
    ((global ushort*)output)[hook(5, pos.x + pos.y * get_global_size(0) + pos.z * get_global_size(0) * get_global_size(1))] = value.x;
  } else if (dataType == 0x10D8) {
    ((global short*)output)[hook(6, pos.x + pos.y * get_global_size(0) + pos.z * get_global_size(0) * get_global_size(1))] = value.x;
  } else if (dataType == 0x10DE) {
    ((global float*)output)[hook(7, pos.x + pos.y * get_global_size(0) + pos.z * get_global_size(0) * get_global_size(1))] = value.x;
  }
}