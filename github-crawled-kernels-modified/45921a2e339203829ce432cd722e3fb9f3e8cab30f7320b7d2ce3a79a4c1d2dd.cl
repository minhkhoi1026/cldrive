//{"sourceImage":0,"targetImage":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t samplerIn = 1 | 4 | 0x20;
const sampler_t samplerOut = 0 | 4 | 0x20;
kernel void resizeImage(read_only image2d_t sourceImage, write_only image2d_t targetImage) {
  int w = get_image_width(targetImage);
  int h = get_image_height(targetImage);

  int outX = get_global_id(0);
  int outY = get_global_id(1);
  int2 posOut = {outX, outY};

  float inX = outX / (float)w;
  float inY = outY / (float)h;
  float2 posIn = (float2)(inX, inY);

  float4 pixel = read_imagef(sourceImage, samplerIn, posIn);
  write_imagef(targetImage, posOut, pixel);
}