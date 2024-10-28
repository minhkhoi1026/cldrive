//{"height":2,"iterations":6,"mandleset":0,"offsetX":4,"offsetY":5,"scale":3,"width":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mandel_kernel(global char* mandleset, const int width, const int height, const float scale, const float offsetX, const float offsetY, const int iterations) {
  int tid = get_global_id(0);

  int i = tid % width;
  int j = tid / height;

  float x0 = ((i * scale) - ((scale / 2) * width)) / width + offsetX;
  float y0 = ((j * scale) - ((scale / 2) * height)) / height + offsetY;

  float x = x0;
  float y = y0;

  float x2 = x * x;
  float y2 = y * y;

  float scaleSquare = scale * scale;

  unsigned int iter = 0;
  for (iter = 0; (x2 + y2 <= scaleSquare) && (iter < iterations); ++iter) {
    y = 2 * x * y + y0;
    x = x2 - y2 + x0;

    x2 = x * x;
    y2 = y * y;
  }
  if (iter == iterations)
    mandleset[hook(0, tid)] = 1;
  else
    mandleset[hook(0, tid)] = 0;
}