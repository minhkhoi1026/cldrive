//{"image":0,"label":2,"lowerThreshold":3,"segmentation":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 0 | 0x10;
float getIntensity(read_only image2d_t image, int2 pos) {
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

kernel void thresholdingWithOnlyLower(read_only image2d_t image, write_only image2d_t segmentation, private uchar label, private float lowerThreshold) {
  const int2 pos = {get_global_id(0), get_global_id(1)};

  const float value = getIntensity(image, pos);

  uchar writeValue = 0;
  if (value >= lowerThreshold) {
    writeValue = label;
  }
  write_imageui(segmentation, pos, writeValue);
}