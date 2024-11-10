//{"height":2,"imgData":0,"width":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float pulseWave(float x, float length) {
  float h = -0.5 * cospi(2 * x) + 0.5;
  if (h > (1.0 - length)) {
    return 1.0;
  } else {
    return 0.0;
  }
}

float roof(float x, float y) {
  float cx = 5.0 * x;
  float cx2 = 5.0 * (x - 0.5);
  float cy = 5.0 * (y - 10.0);

  bool shift = ((int)cy) % 2 == 0;
  float c = 0.0;
  if (shift) {
    c = pulseWave(cx, 0.99);
  } else {
    c = pulseWave(cx2, 0.99);
  }
  c = c + pulseWave(cy, 0.99);

  return c;
}

kernel void generate_texture(global unsigned char* imgData, int width, int height) {
  int i = get_global_id(0);

  unsigned char r, g, b;
  float c = roof((i % width) / (float)width, (i / width) / (float)height);

  if (c > 1.0) {
    r = 51;
    g = r;
    b = r;
  } else {
    r = 26;
    g = r;
    b = r;
  }

  i = i * 4;

  imgData[hook(0, i)] = b;
  imgData[hook(0, i + 1)] = g;
  imgData[hook(0, i + 2)] = r;
  imgData[hook(0, i + 3)] = 255;
}