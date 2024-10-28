//{"height":1,"integralImage":2,"integralImage2":3,"width":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void verticalIntegral(int width, int height, global uint3* integralImage, global ulong3* integralImage2) {
  size_t globalId = get_global_id(0);

  if (globalId >= width)
    return;

  int offset = globalId;
  int cur;

  for (int y = 1; y < height; y++) {
    cur = offset + width;

    integralImage[hook(2, cur)] += integralImage[hook(2, offset)];
    integralImage2[hook(3, cur)] += integralImage2[hook(3, offset)];

    offset = cur;
  }
}