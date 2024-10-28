//{"channels":7,"height":6,"image":1,"patch":0,"startX":2,"startY":3,"startZ":4,"width":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 0 | 0x10;
kernel void applyPatch3D(read_only image3d_t patch, global float* image, private int startX, private int startY, private int startZ, private int width, private int height, private int channels) {
  const int4 pos = {get_global_id(0) + startX, get_global_id(1) + startY, get_global_id(2) + startZ, 0};
  int dataType = get_image_channel_data_type(patch);
  float4 value;
  if (dataType == 0x10DE) {
    value = read_imagef(patch, sampler, pos - (int4)(startX, startY, startZ, 0));
  } else if (dataType == 0x10DA || dataType == 0x10DB) {
    value = convert_float4(read_imageui(patch, sampler, pos - (int4)(startX, startY, startZ, 0)));
  } else {
    value = convert_float4(read_imagei(patch, sampler, pos - (int4)(startX, startY, startZ, 0)));
  }
  image[hook(1, (pos.x + pos.y * width + pos.z * width * height) * channels)] = value.x;
  if (channels > 1)
    image[hook(1, (pos.x + pos.y * width + pos.z * width * height) * channels + 1)] = value.y;
  if (channels > 2)
    image[hook(1, (pos.x + pos.y * width + pos.z * width * height) * channels + 2)] = value.z;
  if (channels > 3)
    image[hook(1, (pos.x + pos.y * width + pos.z * width * height) * channels + 3)] = value.w;
}