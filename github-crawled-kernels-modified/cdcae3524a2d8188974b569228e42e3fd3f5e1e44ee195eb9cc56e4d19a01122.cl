//{"noiseCount":2,"noiseSize":3,"r":1,"tmpData":0,"xOff":4,"yOff":5,"zOff":6}
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
  a = r[hook(1, xf + yf * noiseSize + zf * nSsqr)];
  b = r[hook(1, xpf + yf * noiseSize + zf * nSsqr)];
  c = r[hook(1, xf + ypf * noiseSize + zf * nSsqr)];
  d = r[hook(1, xpf + ypf * noiseSize + zf * nSsqr)];
  e = r[hook(1, xf + yf * noiseSize + zpf * nSsqr)];
  f = r[hook(1, xpf + yf * noiseSize + zpf * nSsqr)];
  g = r[hook(1, xf + ypf * noiseSize + zpf * nSsqr)];
  h = r[hook(1, xpf + ypf * noiseSize + zpf * nSsqr)];
  float value = zv * (a * xv + b * (1.0f - xv)) + (1.0f - zv) * (c * yv + d * (1.0f - yv));
  value = ((float)((float)(127 - y) / 64.0f) - 1.0f) + value * 0.07;

  value = value > 0.1f ? 1.0f : value;
  value = value < -0.1f ? -1.0f : value;

  return (int)(127.5f * (value + 1.0f));
}

kernel void chunkInit1(global int* tmpData, global float* r, int noiseCount, int noiseSize, int xOff, int yOff, int zOff) {
  int global_id = get_global_id(0) + get_global_id(1) * get_global_size(0) + get_global_id(2) * get_global_size(0) * get_global_size(1);

  xOff = 0;
  yOff = 0;
  zOff = 0;

  int x = get_global_id(0);
  int y = get_global_id(1);
  int z = get_global_id(2);
  int size = get_global_size(0) * get_global_size(1) * get_global_size(2);

  int a, b, c, d, e, f, g, h;

  int id = (x + y * get_global_size(0) + z * get_global_size(0) * get_global_size(1)) * 8;

  int globId = ((((int)(x * 0.5f)) + (int)((int)y * 0.5f) * get_global_size(0) * 0.5f + (int)((int)z * 0.5f) * get_global_size(0) * get_global_size(1) * 0.25f)) * 8 + (x % 2 + ((y % 2) * 2) + ((z % 2) * 4));

  a = GetBlock(x * 2 + xOff, y * 2 + yOff, z * 2 + zOff, r, noiseCount, noiseSize);
  b = GetBlock(x * 2 + xOff + 1, y * 2 + yOff, z * 2 + zOff, r, noiseCount, noiseSize);
  c = GetBlock(x * 2 + xOff, y * 2 + yOff + 1, z * 2 + zOff, r, noiseCount, noiseSize);
  d = GetBlock(x * 2 + xOff + 1, y * 2 + yOff + 1, z * 2 + zOff, r, noiseCount, noiseSize);
  e = GetBlock(x * 2 + xOff, y * 2 + yOff, z * 2 + zOff + 1, r, noiseCount, noiseSize);
  f = GetBlock(x * 2 + xOff + 1, y * 2 + yOff, z * 2 + zOff + 1, r, noiseCount, noiseSize);
  g = GetBlock(x * 2 + xOff, y * 2 + yOff + 1, z * 2 + zOff + 1, r, noiseCount, noiseSize);
  h = GetBlock(x * 2 + xOff + 1, y * 2 + yOff + 1, z * 2 + zOff + 1, r, noiseCount, noiseSize);

  if (a == b && a == c && a == d && a == e && a == f && a == g && a == h) {
    tmpData[hook(0, id)] = (int)0x00000000;
    tmpData[hook(0, id + 1)] = (int)0x00000000;
    tmpData[hook(0, id + 2)] = (int)0x00000000;
    tmpData[hook(0, id + 3)] = (int)0x00000000;
    tmpData[hook(0, id + 4)] = (int)0x00000000;
    tmpData[hook(0, id + 5)] = (int)0x00000000;
    tmpData[hook(0, id + 6)] = (int)0x00000000;
    tmpData[hook(0, id + 7)] = (int)0x00000000;
    tmpData[hook(0, (size << 3) + globId)] = (int)(0xC0000000) | (0x00FFFFFF & a);

  } else {
    tmpData[hook(0, id)] = (int)(0xC0000000) | (0x00FFFFFF & a);
    tmpData[hook(0, id + 1)] = (int)(0xC0000000) | (0x00FFFFFF & b);
    tmpData[hook(0, id + 2)] = (int)(0xC0000000) | (0x00FFFFFF & c);
    tmpData[hook(0, id + 3)] = (int)(0xC0000000) | (0x00FFFFFF & d);
    tmpData[hook(0, id + 4)] = (int)(0xC0000000) | (0x00FFFFFF & e);
    tmpData[hook(0, id + 5)] = (int)(0xC0000000) | (0x00FFFFFF & f);
    tmpData[hook(0, id + 6)] = (int)(0xC0000000) | (0x00FFFFFF & g);
    tmpData[hook(0, id + 7)] = (int)(0xC0000000) | (0x00FFFFFF & h);

    tmpData[hook(0, (size << 3) + globId)] = (int)(0x80000000) | (0x00FFFFFF & id);
  }
}