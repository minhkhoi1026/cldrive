//{"dstImg":1,"srcImg":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void YCrCb2RGB(read_only image2d_t srcImg, write_only image2d_t dstImg) {
  int2 pos = (int2)(get_global_id(0), get_global_id(1));
  float4 yuv = read_imagef(srcImg, pos);
  float R = 1.000f * yuv.x + 0.000f * (yuv.z - .5f) + 1.400f * (yuv.y - .5f);
  float G = 1.000f * yuv.x - 0.343f * (yuv.z - .5f) - 0.711f * (yuv.y - .5f);
  float B = 1.000f * yuv.x + 1.765f * (yuv.z - .5f) + 0.000f * (yuv.y - .5f);
  write_imagef(dstImg, pos, (float4)(R, G, B, 0));
}