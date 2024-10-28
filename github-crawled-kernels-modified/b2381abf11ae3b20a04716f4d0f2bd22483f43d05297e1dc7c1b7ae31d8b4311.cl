//{"image":1,"patch":0,"startX":2,"startY":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 0 | 0x10;
kernel void applyPatch2D(read_only image2d_t patch, write_only image2d_t image, private int startX, private int startY) {
  const int2 pos = {get_global_id(0) + startX, get_global_id(1) + startY};
  int dataType = get_image_channel_data_type(image);
  if (dataType == 0x10DE) {
    write_imagef(image, pos, read_imagef(patch, sampler, pos - (int2)(startX, startY)));
  } else if (dataType == 0x10DA || dataType == 0x10DB) {
    write_imageui(image, pos, read_imageui(patch, sampler, pos - (int2)(startX, startY)));
  } else {
    write_imagei(image, pos, read_imagei(patch, sampler, pos - (int2)(startX, startY)));
  }
}