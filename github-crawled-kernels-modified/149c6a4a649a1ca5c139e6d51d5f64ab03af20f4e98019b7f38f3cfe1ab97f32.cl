//{"channelFirst":11,"channels":7,"clipIntensity":10,"horizontalFlip":6,"input":0,"maxIntensity":9,"mean":3,"minIntensity":8,"output":1,"scaleFactor":2,"signedInputNormalization":5,"std":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 0 | 0x10;
kernel void normalize2DInput(read_only image2d_t input, global float* output, private float scaleFactor, private float mean, private float std, private int signedInputNormalization, private int horizontalFlip, private int channels, private float minIntensity, private float maxIntensity, private int clipIntensity, private int channelFirst) {
  const int2 pos = {get_global_id(0), get_global_id(1)};
  const int dataType = get_image_channel_data_type(input);
  float4 value;
  if (dataType == 0x10DE) {
    value = read_imagef(input, sampler, pos);
  } else if (dataType == 0x10D7 || dataType == 0x10D8) {
    value = convert_float4(read_imagei(input, sampler, pos));
  } else {
    value = convert_float4(read_imageui(input, sampler, pos));
  }

  if (clipIntensity)
    value = clamp(value, minIntensity, maxIntensity);
  value = (value - mean) / std;
  value = value * scaleFactor;
  if (signedInputNormalization) {
    value = value * 2 - 1;
  }

  int x;
  if (horizontalFlip == 1) {
    x = (get_global_size(0) - pos.x - 1);
  } else {
    x = pos.x;
  }
  const int width = get_global_size(0);
  const int height = get_global_size(1);
  if (channelFirst == 0) {
    int position = (pos.x + pos.y * width) * channels;
    output[hook(1, position)] = value.x;
    if (channels > 1)
      output[hook(1, position + 1)] = value.y;
    if (channels > 2)
      output[hook(1, position + 2)] = value.z;
    if (channels > 3)
      output[hook(1, position + 3)] = value.w;
  } else {
    int position = pos.x + pos.y * width;
    output[hook(1, position)] = value.x;
    if (channels > 1)
      output[hook(1, position + 1 * width * height)] = value.y;
    if (channels > 2)
      output[hook(1, position + 2 * width * height)] = value.z;
    if (channels > 3)
      output[hook(1, position + 3 * width * height)] = value.w;
  }
}