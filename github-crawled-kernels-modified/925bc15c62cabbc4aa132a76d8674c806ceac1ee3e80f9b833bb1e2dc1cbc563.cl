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

float window(float x, float y) {
  return pulse(0.05, 0.95, x) - pulse(0.48, 0.52, x) - pulse(0, 0.05, y) - pulse(0.95, 1, y) - pulse(0.48, 0.52, y);
}

kernel void generate_texture(global unsigned char* imgData, int width, int height) {
  int i = get_global_id(0);

  unsigned char r, g, b;
  float c = window((i % width) / (float)width, (i / width) / (float)height);

  r = 0;
  g = c * 64;
  b = c * 128;

  i = i * 4;

  imgData[hook(0, i)] = b;
  imgData[hook(0, i + 1)] = g;
  imgData[hook(0, i + 2)] = r;
  imgData[hook(0, i + 3)] = 255;
}