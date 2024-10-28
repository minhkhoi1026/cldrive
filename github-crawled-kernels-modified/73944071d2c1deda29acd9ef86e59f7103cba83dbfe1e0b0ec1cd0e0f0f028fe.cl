//{"Off":1,"r":2,"tmpData":0}
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

kernel void chunkInit2(global int* tmpData, int Off) {
  int global_id = get_global_id(0) + get_global_id(1) * get_global_size(0) + get_global_id(2) * get_global_size(0) * get_global_size(1);
  int a, b, c, d, e, f, g, h;

  int x = get_global_id(0);
  int y = get_global_id(1);
  int z = get_global_id(2);

  int id = (x + y * get_global_size(0) + z * get_global_size(0) * get_global_size(1)) * 8;
  int globId = ((((int)(x * 0.5f)) + (int)((int)y * 0.5f) * get_global_size(0) * 0.5f + (int)((int)z * 0.5f) * get_global_size(0) * get_global_size(1) * 0.25f)) * 8 + (x % 2 + ((y % 2) * 2) + ((z % 2) * 4));

  int cubeSize = get_global_size(0) * get_global_size(1) * get_global_size(2);

  a = tmpData[hook(0, Off + id)];
  b = tmpData[hook(0, Off + id + 1)];
  c = tmpData[hook(0, Off + id + 2)];
  d = tmpData[hook(0, Off + id + 3)];
  e = tmpData[hook(0, Off + id + 4)];
  f = tmpData[hook(0, Off + id + 5)];
  g = tmpData[hook(0, Off + id + 6)];
  h = tmpData[hook(0, Off + id + 7)];

  if (a == b && a == c && a == d && a == e && a == f && a == g && a == h && (a & 0x40000000) != 0) {
    tmpData[hook(0, Off + id)] = (int)0x00000000;
    tmpData[hook(0, Off + id + 1)] = (int)0x00000000;
    tmpData[hook(0, Off + id + 2)] = (int)0x00000000;
    tmpData[hook(0, Off + id + 3)] = (int)0x00000000;
    tmpData[hook(0, Off + id + 4)] = (int)0x00000000;
    tmpData[hook(0, Off + id + 5)] = (int)0x00000000;
    tmpData[hook(0, Off + id + 6)] = (int)0x00000000;
    tmpData[hook(0, Off + id + 7)] = (int)0x00000000;

    tmpData[hook(0, Off + (cubeSize << 3) + globId)] = (int)(0xC0000000) | (0x00FFFFFF & a);
  } else {
    tmpData[hook(0, Off + (cubeSize << 3) + globId)] = (int)(0x80000000) | (0x00FFFFFF & (Off + id));
  }
}