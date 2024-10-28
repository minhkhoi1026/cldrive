//{"angle":2,"sourceImage":0,"targetImage":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t samplerIn = 0 | 4 | 0x10;
const sampler_t samplerOut = 0 | 4 | 0x10;
kernel void rotateImage(read_only image2d_t sourceImage, write_only image2d_t targetImage, int angle) {
  int inX = get_global_id(0);
  int inY = get_global_id(1);
  int2 posIn = {inX, inY};

  int w = get_image_width(targetImage);
  int h = get_image_height(targetImage);

  if (angle == 0) {
    int outX = inX;
    int outY = inY;
    int2 posOut = {outX, outY};
    uint4 pixel = read_imageui(sourceImage, samplerIn, posIn);
    write_imageui(targetImage, posOut, pixel);
  } else if (angle == 90) {
    int outX = w - 1 - inY;
    int outY = inX;
    int2 posOut = {outX, outY};
    uint4 pixel = read_imageui(sourceImage, samplerIn, posIn);
    write_imageui(targetImage, posOut, pixel);
  } else if (angle == 180) {
    int outX = w - 1 - inX;
    int outY = h - 1 - inY;
    int2 posOut = {outX, outY};
    uint4 pixel = read_imageui(sourceImage, samplerIn, posIn);
    write_imageui(targetImage, posOut, pixel);
  } else if (angle == 270) {
    int outX = inY;
    int outY = h - 1 - inX;
    int2 posOut = {outX, outY};
    uint4 pixel = read_imageui(sourceImage, samplerIn, posIn);
    write_imageui(targetImage, posOut, pixel);
  }
}