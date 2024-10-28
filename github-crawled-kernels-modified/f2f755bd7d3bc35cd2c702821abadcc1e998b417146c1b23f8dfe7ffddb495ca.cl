//{"image":0,"value":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void fillImage2D(write_only image2d_t image, private float value) {
  const int2 pos = {get_global_id(0), get_global_id(1)};
  int dataType = get_image_channel_data_type(image);
  if (dataType == 0x10DE) {
    write_imagef(image, pos, (float4)(value, value, value, value));
  } else if (dataType == 0x10D7 || dataType == 0x10D8) {
    write_imagei(image, pos, (int4)(value, value, value, value));
  }
   else {
    write_imageui(image, pos, (uint4)(value, value, value, value));
  }
}