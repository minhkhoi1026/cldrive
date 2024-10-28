//{"colorSet":2,"height":5,"iterArr":1,"iterLimit":3,"output":0,"width":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t sampler = 0 | 0x10;
kernel void mandelbrot_colorize(write_only image2d_t output, global unsigned int* iterArr, global float* colorSet, int iterLimit, int width, int height) {
  size_t x = get_global_id(1);
  size_t y = get_global_id(0);
  unsigned int i = iterArr[hook(1, x + y * height)];

  float r, g, b;
  if (i >= iterLimit - 1) {
    r = 0.0;
    g = 0.0;
    b = 0.0;
  } else {
    int j = i * 3;
    r = colorSet[hook(2, j)];
    g = colorSet[hook(2, j + 1)];
    b = colorSet[hook(2, j + 2)];
  }
  write_imagef(output, (int2)(x, y), (float4)(r, g, b, 1.0));
}