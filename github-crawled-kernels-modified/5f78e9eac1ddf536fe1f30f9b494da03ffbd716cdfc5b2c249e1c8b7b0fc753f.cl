//{"input":1,"inputDimensions":3,"mask":2,"maskDimensions":4,"output":0,"x_w":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void simpleConvolution(global unsigned int* output, global unsigned int* input, global float* mask, const uint2 inputDimensions, const uint2 maskDimensions, int x_w) {
  unsigned int tid = get_global_id(0);

  unsigned int width = inputDimensions.x;
  unsigned int height = inputDimensions.y;

  unsigned int x = tid % width;
  unsigned int y = tid / width;

  unsigned int maskWidth = maskDimensions.x;
  unsigned int maskHeight = maskDimensions.y;

  unsigned int vstep = (maskWidth - 1) / 2;
  unsigned int hstep = (maskHeight - 1) / 2;

  unsigned int left = (x < vstep) ? 0 : (x - vstep);
  unsigned int right = ((x + vstep) >= width) ? width - 1 : (x + vstep);
  unsigned int top = (y < hstep) ? 0 : (y - hstep);
  unsigned int bottom = ((y + hstep) >= height) ? height - 1 : (y + hstep);

  float sumFX = 0;

  for (unsigned int i = left; i <= right; ++i)
    for (unsigned int j = top; j <= bottom; ++j) {
      unsigned int maskIndex = (j - (y - hstep)) * maskWidth + (i - (x - vstep));
      unsigned int index = j * width + i;

      sumFX += ((float)input[hook(1, index)] * mask[hook(2, maskIndex)]);
    }

  sumFX += 0.5f;
  output[hook(0, tid)] = (unsigned int)sumFX;
}