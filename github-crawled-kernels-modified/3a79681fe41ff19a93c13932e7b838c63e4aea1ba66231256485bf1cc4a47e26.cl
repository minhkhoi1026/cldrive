//{"image":0,"integralImage":1,"integralImage2":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void horizontalIntegral(read_only image2d_t image, global uint3* integralImage, global ulong3* integralImage2) {
  size_t globalId = get_global_id(0);

  if (globalId >= get_image_height(image))
    return;

  int width = get_image_width(image);
  int offset = globalId * width;

  uint3 sum = (uint3)(0);
  ulong3 sum2 = (ulong3)(0);
  uint3 pixel;
  ulong3 pixel2;

  for (int x = 0; x < width; x++) {
    pixel = read_imageui(image, (int2)(x, globalId)).s012;
    pixel2 = convert_ulong3(pixel);

    sum += pixel;
    sum2 += pixel2 * pixel2;

    integralImage[hook(1, offset)] = sum;
    integralImage2[hook(2, offset)] = sum2;

    offset++;
  }
}