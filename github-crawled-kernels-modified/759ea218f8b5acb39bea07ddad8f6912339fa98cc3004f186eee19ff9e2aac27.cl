//{"input":0,"output":1,"transform":2,"transformedPosition":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 4 | 0x10;
float4 transformPosition(constant float* transform, int2 PBOposition) {
  float4 position = {PBOposition.x, PBOposition.y, 0, 1};
  float transformedPosition[4];

  for (int i = 0; i < 4; i++) {
    float sum = 0;
    sum += transform[hook(2, i + 0 * 4)] * position.x;
    sum += transform[hook(2, i + 1 * 4)] * position.y;
    sum += transform[hook(2, i + 2 * 4)] * position.z;
    sum += transform[hook(2, i + 3 * 4)] * position.w;
    transformedPosition[hook(3, i)] = sum;
  }

  float4 result = {transformedPosition[hook(3, 0)], transformedPosition[hook(3, 1)], transformedPosition[hook(3, 2)], transformedPosition[hook(3, 3)]};
  return result;
}

kernel void arbitrarySlicing(read_only image3d_t input, write_only image2d_t output, constant float* transform) {
  const int2 position = {get_global_id(0), get_global_id(1)};

  float4 imagePosition = transformPosition(transform, position);
  imagePosition.w = 1;

  int dataType = get_image_channel_data_type(input);
  if (dataType == 0x10DE) {
    float4 value = read_imagef(input, sampler, imagePosition);
    write_imagef(output, position, value);
  } else if (dataType == 0x10DA || dataType == 0x10DB) {
    uint4 value = read_imageui(input, sampler, imagePosition);
    write_imageui(output, position, value);
  } else {
    int4 value = read_imagei(input, sampler, imagePosition);
    write_imagei(output, position, value);
  }
}