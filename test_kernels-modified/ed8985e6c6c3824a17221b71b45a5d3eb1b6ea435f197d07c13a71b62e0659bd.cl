//{"a":0,"b":2,"length":5,"n_items":3,"nullMem":4,"r":1}
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

kernel void BScan(global unsigned int* a, global unsigned int* r, local unsigned int* b, unsigned int n_items, unsigned int nullMem, global unsigned int* length) {
  unsigned int gid = get_global_id(0);
  unsigned int lid = get_local_id(0);
  unsigned int dp = 1;

  if (gid * 2 >= nullMem) {
    a[hook(0, 2 * gid)] = 0;
    a[hook(0, 2 * gid + 1)] = 0;
  }
  b[hook(2, 2 * lid)] = (a[hook(0, 2 * gid)] & 0xFF000000) != 0 ? 1 : 0;
  b[hook(2, 2 * lid + 1)] = (a[hook(0, 2 * gid + 1)] & 0xFF000000) != 0 ? 1 : 0;

  for (unsigned int s = n_items >> 1; s > 0; s >>= 1) {
    barrier(0x01);
    if (lid < s) {
      unsigned int i = dp * (2 * lid + 1) - 1;
      unsigned int j = dp * (2 * lid + 2) - 1;
      b[hook(2, j)] += b[hook(2, i)];
    }

    dp <<= 1;
  }
  if (lid == 0) {
    length[hook(5, get_group_id(0))] = b[hook(2, n_items - 1)];
    b[hook(2, n_items - 1)] = 0;
  }

  for (unsigned int s = 1; s < n_items; s <<= 1) {
    dp >>= 1;
    barrier(0x01);

    if (lid < s) {
      unsigned int i = dp * (2 * lid + 1) - 1;
      unsigned int j = dp * (2 * lid + 2) - 1;

      unsigned int t = b[hook(2, j)];
      b[hook(2, j)] += b[hook(2, i)];
      b[hook(2, i)] = t;
    }
  }

  barrier(0x01);

  r[hook(1, 2 * gid)] = b[hook(2, 2 * lid)];
  r[hook(1, 2 * gid + 1)] = b[hook(2, 2 * lid + 1)];
}