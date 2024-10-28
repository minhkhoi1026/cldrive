//{"height":2,"imgData":0,"width":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float sstep(float a, float x) {
  if (x >= a) {
    return 1;
  }
  return 0;
}

float pulse(float a, float b, float x) {
  return sstep(a, x) - sstep(b, x);
}

float3 windowTile(int ix) {
  ix = ix % 5;

  if (ix == 1)
    return (float3)(0.2, 0.2, 0.2);
  if (ix == 2)
    return (float3)(0, 0, 0.2);
  if (ix == 3)
    return (float3)(0.2, 0.2, 0);
  if (ix == 4)
    return (float3)(0, 0.1, 0.2);
  return (float3)(0, 0, 0.2);
}

float3 skyscraper(float x, float y) {
  float sx = x * 5;
  float sy = y * 25;
  int ix = (int)sx;
  int iy = (int)sy;
  float fx = sx - ix;
  float fy = sy - iy;

  float p = pulse(0.5 - 0.35 / 2, 0.5 + 0.35 / 2, fy);
  if (p > 0) {
    if (iy % 2 == 0)
      return windowTile(ix + 1);
    return windowTile(ix);
  }

  return (float3)(0.9, 0.9, 0.84);
}

kernel void generate_texture(global unsigned char* imgData, int width, int height) {
  int i = get_global_id(0);

  float3 c = skyscraper((i % width) / (float)width, (i / width) / (float)height);

  i = i * 4;

  imgData[hook(0, i)] = 255 * c.z;
  imgData[hook(0, i + 1)] = 255 * c.y;
  imgData[hook(0, i + 2)] = 255 * c.x;
  imgData[hook(0, i + 3)] = 255;
}