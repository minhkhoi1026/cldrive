//{"bottomLeft":0,"delta":1,"maxIterations":2,"results":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void CreatePixelArrayMandelbrotSetFloat(float2 bottomLeft, float2 delta, int maxIterations, global ushort* results) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  int width = get_global_size(0);

  float zr = 0.0f;
  float zi = 0.0f;

  float cr = bottomLeft.x + (delta.x * x);
  float ci = bottomLeft.y + (delta.y * y);

  ushort iter = 0;

  for (; iter < maxIterations; ++iter) {
    float zrNext = ((zr * zr) - (zi * zi)) + cr;
    float ziNext = (2 * zr * zi) + ci;

    if (fabs(zrNext) >= 2.0f || fabs(ziNext) >= 2.0f || zrNext * zrNext + ziNext * ziNext >= 4.0f) {
      break;
    }

    zr = zrNext;
    zi = ziNext;
  }

  results[hook(3, y * width + x)] = iter;
}