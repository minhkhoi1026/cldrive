//{"dst":1,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t linearSamp = 1 | 2 | 0x20;
kernel void resizeLayer(read_only image2d_t src, write_only image2d_t dst) {
  if (get_global_id(0) >= get_image_width(dst) || get_global_id(1) >= get_image_height(dst)) {
    return;
  }

  float2 srcSize = (float2)(convert_float(get_image_width(src)), convert_float(get_image_height(src)));
  float2 dstSize = (float2)(convert_float(get_image_width(dst)), convert_float(get_image_height(dst)));
  float2 borderOffset = 0.5f / srcSize;

  float2 dstCoord = (float2)(convert_float(get_global_id(0)), convert_float(get_global_id(1))) / (dstSize - 1.f);

  float2 coord = borderOffset + dstCoord * (1.f - 2.f * borderOffset);

  write_imagef(dst, (int2)(get_global_id(0), get_global_id(1)), read_imagef(src, linearSamp, coord));
}