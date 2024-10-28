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

int crossWalk(float x, float y) {
  float sx = x * 32 + 1;
  float sy = y * 32 + 1;
  int ix = (int)sx;
  int iy = (int)sy;
  float fx = sx - ix;
  float fy = sy - iy;

  if (iy == 1 || iy == 3 || iy == 30 || iy == 32) {
    float c = pulse(0.5 - (0.25 / 2), 0.5 + (0.25 / 2), fy);
    return (int)c * 255;
  } else if (ix == 1 || ix == 3 || ix == 30 || ix == 32) {
    float c = pulse(0.5 - (0.25 / 2), 0.5 + (0.25 / 2), fx);
    return (int)c * 255;
  }

  return 0;
}

kernel void generate_texture(global unsigned char* imgData, int width, int height) {
  int i = get_global_id(0);

  unsigned char r, g, b;
  int c = crossWalk((i % width) / (float)width, (i / width) / (float)height);

  r = c;
  g = r;
  b = r;

  i = i * 4;

  imgData[hook(0, i)] = b;
  imgData[hook(0, i + 1)] = g;
  imgData[hook(0, i + 2)] = r;
  imgData[hook(0, i + 3)] = 255;
}