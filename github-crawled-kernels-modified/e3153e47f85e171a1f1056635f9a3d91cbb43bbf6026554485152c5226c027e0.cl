//{"dst2Image":1,"dstImage":0,"dsth":6,"dstw":5,"dstx":3,"dsty":4,"opacity":8,"src":7,"srcImage":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t lsamp = 2 | 0x20;
const sampler_t nsamp = 2 | 0x10;
kernel void drawImage(write_only image2d_t dstImage, read_only image2d_t dst2Image, read_only image2d_t srcImage, int dstx, int dsty, int dstw, int dsth, float4 src, float opacity) {
  int2 dstPos = (int2)(get_global_id(0) + dstx, get_global_id(1) + dsty);
  float2 srcPos = (float2)(get_global_id(0) * src.z / dstw + src.x, get_global_id(1) * src.w / dsth + src.y);
  if (dstPos.x < dstx || dstPos.x >= (dstx + dstw) || dstPos.y < dsty || dstPos.y >= (dsty + dsth))
    return;
  float4 scolor = read_imagef(srcImage, lsamp, srcPos);
  float4 dcolor = read_imagef(dst2Image, nsamp, dstPos);

  dcolor = (float4)(dcolor.xyz * (1.0f - scolor.w * opacity) + scolor.xyz * scolor.w * opacity, 1.0f);
  write_imagef(dstImage, dstPos, clamp(dcolor, 0.0f, 1.0f));
}