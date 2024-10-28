//{"high":5,"input":0,"low":4,"max":3,"min":2,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 0 | 0x10;
kernel void scaleImage2D(read_only image2d_t input, write_only image2d_t output, private float min, private float max, private float low, private float high) {
  const int2 pos = {get_global_id(0), get_global_id(1)};
  int dataType = get_image_channel_data_type(input);

  float4 value;
  if (dataType == 0x10DE) {
    value = read_imagef(input, sampler, pos);
  } else if (dataType == 0x10DA || dataType == 0x10DB) {
    value = convert_float4(read_imageui(input, sampler, pos));
  } else {
    value = convert_float4(read_imagei(input, sampler, pos));
  }
  value = (value - min) / (max - min);
  value = value * (high - low) + low;

  write_imagef(output, pos, value);
}