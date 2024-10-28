//{"dstImg":1,"sampler":2,"srcImg":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void rotation(read_only image2d_t srcImg, write_only image2d_t dstImg, sampler_t sampler) {
  int2 outImageCoord = (int2)(get_global_id(0), get_global_id(1));
  int2 originOutImageCoord = (int2)(get_global_id(0), get_global_id(1));
  float angle = (3.14 / 180) * 30;
  int x = (outImageCoord.x - get_image_width(srcImg) / 2) * cos(angle) - (outImageCoord.y - get_image_height(srcImg) / 2) * sin(angle) + get_image_width(srcImg) / 2;
  int y = (outImageCoord.x - get_image_width(srcImg) / 2) * sin(angle) + (outImageCoord.y - get_image_height(srcImg) / 2) * cos(angle) + get_image_height(srcImg) / 2;

  outImageCoord.x = x;
  outImageCoord.y = y;

  float4 outColor = (float4)read_imagef(srcImg, sampler, (int2)originOutImageCoord);
  write_imagef(dstImg, outImageCoord, outColor);
}