//{"chunk":0,"dChunkSize":4,"length":3,"r":5,"result":2,"scan":1}
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
  a = r[hook(5, xf + yf * noiseSize + zf * nSsqr)];
  b = r[hook(5, xpf + yf * noiseSize + zf * nSsqr)];
  c = r[hook(5, xf + ypf * noiseSize + zf * nSsqr)];
  d = r[hook(5, xpf + ypf * noiseSize + zf * nSsqr)];
  e = r[hook(5, xf + yf * noiseSize + zpf * nSsqr)];
  f = r[hook(5, xpf + yf * noiseSize + zpf * nSsqr)];
  g = r[hook(5, xf + ypf * noiseSize + zpf * nSsqr)];
  h = r[hook(5, xpf + ypf * noiseSize + zpf * nSsqr)];
  float value = zv * (a * xv + b * (1.0f - xv)) + (1.0f - zv) * (c * yv + d * (1.0f - yv));
  value = ((float)((float)(127 - y) / 64.0f) - 1.0f) + value * 0.07;

  value = value > 0.1f ? 1.0f : value;
  value = value < -0.1f ? -1.0f : value;

  return (int)(127.5f * (value + 1.0f));
}

kernel void chunkMemCpy(global unsigned int* chunk, global unsigned int* scan, global unsigned int* result, global unsigned int* length, unsigned int dChunkSize) {
  int gid = get_global_id(0);
  unsigned int value = chunk[hook(0, gid)];
  if (value != 0) {
    if ((value & 0xFF000000) == 0x80000000) {
      if (((gid - gid % dChunkSize) / dChunkSize) - 1.0 < 0) {
        value = 0x80000000 | ((int)scan[hook(1, value & 16777215)]);
      } else {
        value = 0x80000000 | ((int)scan[hook(1, value & 16777215)] + (int)length[hook(3, (((value & 16777215) - (value & 16777215) % dChunkSize) / dChunkSize))]);
      }
    }
    if (((gid - gid % dChunkSize) / dChunkSize) - 1.0 < 0) {
      result[hook(2, (int)scan[ghook(1, gid))] = value;
    } else {
      result[hook(2, (int)scan[ghook(1, gid) + (int)length[(hook(3, ((gid - gid % dChunkSize) / dChunkSize)))] = value;
    }
  }
}