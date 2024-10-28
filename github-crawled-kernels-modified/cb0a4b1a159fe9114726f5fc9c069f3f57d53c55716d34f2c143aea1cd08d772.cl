//{"dst":2,"overlay":1,"src":0,"xScale":3,"yScale":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t nearestSampler = 0 | 2 | 0x10;
constant sampler_t linearSampler = 0 | 2 | 0x20;
kernel void overlay(read_only image2d_t src, read_only image2d_t overlay, write_only image2d_t dst, float xScale, float yScale) {
  int2 srcPos = {get_global_id(0), get_global_id(1)};

  float2 scale = {xScale, yScale};
  float2 overlayPos = convert_float2(srcPos) * scale;

  uint4 srcValue = read_imageui(src, nearestSampler, srcPos);
  uint4 overlayValue = read_imageui(overlay, linearSampler, overlayPos);
  uint4 dstValue;

  dstValue.xyz = ((overlayValue.xyz * overlayValue.w) + (srcValue.xyz * (255 - overlayValue.w))) / 255;
  dstValue.w = 255;

  write_imageui(dst, srcPos, dstValue);
}