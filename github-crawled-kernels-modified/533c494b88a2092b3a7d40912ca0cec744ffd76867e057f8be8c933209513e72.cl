//{"r":2,"seed_memory":0,"start_seed":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int average(int a, int b, int c, int d, int e, int f, int g, int h) {
  return floor(((0x000000FF & a) + (0x000000FF & a) + (0x000000FF & a) + (0x000000FF & a) + (0x000000FF & a) + (0x000000FF & a) + (0x000000FF & a) + (0x000000FF & a)) * 0.125f);
}

int rand(int* seed) {
  int const a = 16807;
  int const m = 2147483647;

  *seed = (long)(*seed * a) % m;
  return (*seed);
}

int GetBlock(int x, int y, int z, global float* r, int noiseCount, int noiseSize) {
  int xf, yf, zf, xpf, ypf, zpf, nSsqr;
  nSsqr = noiseSize * noiseSize;
  float xv, yv, zv;
  xv = (float)x / ((float)noiseSize);
  yv = (float)y / ((float)noiseSize);
  zv = (float)z / ((float)noiseSize);
  xf = floor(xv);
  yf = floor(yv);
  zf = floor(zv);
  xv -= xf;
  yv -= yf;
  zv -= zf;
  xf = xv * (float)noiseSize;
  yf = yv * (float)noiseSize;
  zf = zv * (float)noiseSize;
  xpf = xf < (noiseSize - 1) ? xf + 1 : 0;
  ypf = yf < (noiseSize - 1) ? yf + 1 : 0;
  zpf = zf < (noiseSize - 1) ? zf + 1 : 0;
  float a, b, c, d, e, f, g, h;
  a = r[hook(2, xf + yf * noiseSize + zf * nSsqr)];
  b = r[hook(2, xpf + yf * noiseSize + zf * nSsqr)];
  c = r[hook(2, xf + ypf * noiseSize + zf * nSsqr)];
  d = r[hook(2, xpf + ypf * noiseSize + zf * nSsqr)];
  e = r[hook(2, xf + yf * noiseSize + zpf * nSsqr)];
  f = r[hook(2, xpf + yf * noiseSize + zpf * nSsqr)];
  g = r[hook(2, xf + ypf * noiseSize + zpf * nSsqr)];
  h = r[hook(2, xpf + ypf * noiseSize + zpf * nSsqr)];
  float value = zv * (a * xv + b * (1.0f - xv)) + (1.0f - zv) * (c * yv + d * (1.0f - yv));
  value = ((float)((float)(127 - y) / 64.0f) - 1.0f) + value * 0.07;

  value = value > 0.1f ? 1.0f : value;
  value = value < -0.1f ? -1.0f : value;

  return (int)(127.5f * (value + 1.0f));
}

kernel void random_number_kernel(global float* seed_memory, int start_seed) {
  int global_id = get_global_id(0) + get_global_id(1) * get_global_size(0) + get_global_id(2) * get_global_size(0) * get_global_size(1);

  int n = global_id + start_seed;

  n = (n << 13) ^ n;

  seed_memory[hook(0, global_id)] = (1.0f - ((n * (n * n * 15731 + 789221) +

                                     1376312589) &
                                    0x7fffffff) *
                                       0.000000000931322574615478515625f);
}