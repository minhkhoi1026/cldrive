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

kernel void gradient3D(read_only image3d_t input,

                       global float* output

) {
  const int4 pos = {get_global_id(0), get_global_id(1), get_global_id(2), 0};

  float3 gradient = {(readImageAsFloat3D(input, sampler, pos + (int4)(1, 0, 0, 0)) - readImageAsFloat3D(input, sampler, pos - (int4)(1, 0, 0, 0))) * 0.5f, (readImageAsFloat3D(input, sampler, pos + (int4)(0, 1, 0, 0)) - readImageAsFloat3D(input, sampler, pos - (int4)(0, 1, 0, 0))) * 0.5f, (readImageAsFloat3D(input, sampler, pos + (int4)(0, 0, 1, 0)) - readImageAsFloat3D(input, sampler, pos - (int4)(0, 0, 1, 0))) * 0.5f};

  vstore3(gradient, pos.x + pos.y * get_global_size(0) + pos.z * get_global_size(0) * get_global_size(1), output);
}