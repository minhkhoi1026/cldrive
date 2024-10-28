//{"height":3,"input":1,"output":0,"p":4,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sobel(global uchar* output, global uchar* input, int width, int height) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  int p[9];
  int offset = y * width + x;
  if (x < 1 || y < 1 || x > width - 2 || y > height - 2) {
    output[hook(0, offset)] = 0;
  } else {
    p[hook(4, 0)] = input[hook(1, offset - width - 1)] & 0xff;
    p[hook(4, 1)] = input[hook(1, offset - width)] & 0xff;
    p[hook(4, 2)] = input[hook(1, offset - width + 1)] & 0xff;
    p[hook(4, 3)] = input[hook(1, offset - 1)] & 0xff;
    p[hook(4, 4)] = input[hook(1, offset)] & 0xff;
    p[hook(4, 5)] = input[hook(1, offset + 1)] & 0xff;
    p[hook(4, 6)] = input[hook(1, offset + width - 1)] & 0xff;
    p[hook(4, 7)] = input[hook(1, offset + width)] & 0xff;
    p[hook(4, 8)] = input[hook(1, offset + width + 1)] & 0xff;

    int sum1 = p[hook(4, 0)] + 2 * p[hook(4, 1)] + p[hook(4, 2)] - p[hook(4, 6)] - 2 * p[hook(4, 7)] - p[hook(4, 8)];
    int sum2 = p[hook(4, 0)] + 2 * p[hook(4, 3)] + p[hook(4, 6)] - p[hook(4, 2)] - 2 * p[hook(4, 5)] - p[hook(4, 8)];
    float sum3 = sum1 * sum1 + sum2 * sum2;

    int sum = sqrt(sum3);
    if (sum > 255)
      sum = 255;
    output[hook(0, offset)] = (char)sum;
  }
}