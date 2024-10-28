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

float3 window(float x, float y) {
  float frame = (1 - pulse(0.05, 0.95, x)) + (1 - pulse(0.05, 0.95, y));
  if (frame > 0) {
    return (float3)(0.1, 0.1, 0.1);
  }

  if (y > 0.5) {
    return (float3)(0, 0.3, 0.5);
  }
  return (float3)(0.2, 0.2, 0.25);
}

kernel void generate_texture(global unsigned char* imgData, int width, int height) {
  int i = get_global_id(0);

  float3 c = window((i % width) / (float)width, (i / width) / (float)height);

  i = i * 4;

  imgData[hook(0, i)] = 255 * c.z;
  imgData[hook(0, i + 1)] = 255 * c.y;
  imgData[hook(0, i + 2)] = 255 * c.x;
  imgData[hook(0, i + 3)] = 255;
}