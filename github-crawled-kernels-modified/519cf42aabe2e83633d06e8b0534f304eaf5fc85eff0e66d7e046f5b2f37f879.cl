//{"height":3,"input":0,"output":1,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void erosion(global int* input, global int* output, int width, int height) {
  unsigned int x = get_global_id(0);
  unsigned int y = get_global_id(1);

  int frameW = 3;

  int frameA = 3 * 3;

  int frameLeft = x;
  int frameBottom = y;

  int frameTop = ((x + frameW) < (width)) ? (x + frameW) : (width);
  int frameRight = ((y + frameW) < (height)) ? (y + frameW) : (height);

  int center = input[hook(0, (frameLeft + 1) + width * (frameBottom + 1))] / 255;

  output[hook(1, (frameLeft + 1) + width * (frameBottom + 1))] = center * 255;

  output[hook(1, (frameLeft + 0) + width * (frameBottom + 1))] = ((input[hook(0, (frameLeft + 0) + width * (frameBottom + 1))] / 255) & center) * 255;
  output[hook(1, (frameLeft + 1) + width * (frameBottom + 2))] = ((input[hook(0, (frameLeft + 1) + width * (frameBottom + 2))] / 255) & center) * 255;
  output[hook(1, (frameLeft + 1) + width * (frameBottom + 0))] = ((input[hook(0, (frameLeft + 1) + width * (frameBottom + 0))] / 255) & center) * 255;
  output[hook(1, (frameLeft + 2) + width * (frameBottom + 1))] = ((input[hook(0, (frameLeft + 2) + width * (frameBottom + 1))] / 255) & center) * 255;
}