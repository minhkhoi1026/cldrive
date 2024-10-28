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

int windowTile(float x, float y) {
  float xp = pulse(0.28 / 2, 1 - 0.28 / 2, x);
  float yp = pulse(0.12 / 2, 1 - 0.12 / 2, y);

  if (xp == 1 && yp == 0) {
    return 1;
  } else if (xp == 0) {
    return 2;
  }
  return 3;
}

float skyscraper(float x, float y) {
  float sx = x * 5;
  float sy = y * 25;
  int ix = (int)sx;
  int iy = (int)sy;
  float fx = sx - ix;
  float fy = sy - iy;

  int w = windowTile(fx, fy);
  if (w != 3)
    return w;

  w = 4;
  if (iy % 2 == 0)
    w = 5;

  return w;
}

kernel void generate_texture(global unsigned char* imgData, int width, int height) {
  int i = get_global_id(0);

  unsigned char r, g, b;
  float c = skyscraper((i % width) / (float)width, (i / width) / (float)height);

  if (c == 1) {
    r = 87;
    g = 97;
    b = 102;
  } else if (c == 2) {
    r = 153;
    g = r;
    b = r;
  } else if (c == 4) {
    r = 51;
    g = 77;
    b = 128;
  } else {
    r = 104;
    g = 128;
    b = 179;
  }

  i = i * 4;

  imgData[hook(0, i)] = b;
  imgData[hook(0, i + 1)] = g;
  imgData[hook(0, i + 2)] = r;
  imgData[hook(0, i + 3)] = 255;
}