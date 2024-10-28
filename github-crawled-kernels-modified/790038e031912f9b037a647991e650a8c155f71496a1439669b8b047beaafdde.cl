//{"cosTheta":3,"destImage":1,"sampler":4,"sinTheta":2,"sourceImage":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void imageRotate(read_only image2d_t sourceImage, write_only image2d_t destImage, float sinTheta, float cosTheta, sampler_t sampler) {
  int2 srcCoords, destCoords;

  const int2 center = {get_image_width(sourceImage) / 2, get_image_height(sourceImage) / 2};

  destCoords.x = get_global_id(0);
  destCoords.y = get_global_id(1);

  srcCoords.x = (float)(destCoords.x - center.x) * cosTheta + (float)(destCoords.y - center.y) * sinTheta + center.x;
  srcCoords.y = (float)(destCoords.y - center.y) * cosTheta - (float)(destCoords.x - center.x) * sinTheta + center.y;

  write_imageui(destImage, destCoords, read_imageui(sourceImage, sampler, srcCoords));
}