//{"clout":8,"clrng":7,"height":1,"imMax":5,"imMin":4,"maxIter":6,"reMax":3,"reMin":2,"width":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float2 clrand2(unsigned int id, global uint4* clrng) {
  unsigned int s1 = clrng[hook(7, id)].x;
  unsigned int s2 = clrng[hook(7, id)].y;
  unsigned int s3 = clrng[hook(7, id)].z;
  unsigned int b;

  b = (((s1 << 13) ^ s1) >> 19);
  s1 = (((s1 & 4294967294) << 12) ^ b);
  b = (((s2 << 2) ^ s2) >> 25);
  s2 = (((s2 & 4294967288) << 4) ^ b);
  b = (((s3 << 3) ^ s3) >> 11);
  s3 = (((s3 & 4294967280) << 17) ^ b);

  float2 result;
  result.x = (float)((s1 ^ s2 ^ s3) * 2.3283064365e-10);

  b = (((s1 << 13) ^ s1) >> 19);
  s1 = (((s1 & 4294967294) << 12) ^ b);
  b = (((s2 << 2) ^ s2) >> 25);
  s2 = (((s2 & 4294967288) << 4) ^ b);
  b = (((s3 << 3) ^ s3) >> 11);
  s3 = (((s3 & 4294967280) << 17) ^ b);

  result.y = (float)((s1 ^ s2 ^ s3) * 2.3283064365e-10);

  clrng[hook(7, id)] = (uint4)(s1, s2, s3, b);

  return result;
}

kernel void Mandelbrot(const unsigned int width, const unsigned int height, const float reMin, const float reMax, const float imMin, const float imMax, const unsigned int maxIter, global uint4* clrng, global uchar4* clout) {
  const float escapeOrbit = 4.0f;

  float2 rand = clrand2(get_global_id(0), clrng);
  float2 c = (float2)(mix(reMin, reMax, rand.x), mix(imMin, imMax, rand.y));

  float2 z = 0.0f;
  int iter = 0;

  if (!(((c.x - 0.25f) * (c.x - 0.25f) + (c.y * c.y)) * (((c.x - 0.25f) * (c.x - 0.25f) + (c.y * c.y)) + (c.x - 0.25f)) < 0.25f * c.y * c.y)) {
    if (!((c.x + 1.0f) * (c.x + 1.0f) + (c.y * c.y) < 0.0625f)) {
      if (!((((c.x + 1.309f) * (c.x + 1.309f)) + c.y * c.y) < 0.00345f)) {
        if (!((((c.x + 0.125f) * (c.x + 0.125f)) + (c.y - 0.744f) * (c.y - 0.744f)) < 0.0088f)) {
          if (!((((c.x + 0.125f) * (c.x + 0.125f)) + (c.y + 0.744f) * (c.y + 0.744f)) < 0.0088f)) {
            while ((iter < maxIter) && ((z.x * z.x + z.y * z.y) < escapeOrbit)) {
              z = (float2)(z.x * z.x - z.y * z.y, (z.x * z.y * 2.0f)) + c;
              iter++;
            }
          }
        }
      }
    }
  }

  int x = (c.x - reMin) / (reMax - reMin) * width;
  int y = height - (c.y - imMin) / (imMax - imMin) * height;

  if ((x >= 0) && (y >= 0) && (x < width) && (y < height)) {
    int i = x + y * width;
    float clr = 0.0f;

    if (iter < maxIter) {
      clr = 5.0f + iter - half_log(half_log(dot(z, z))) * half_log(1.0f / (reMax - reMin));
    }

    clr = clamp(clr, 0.0f, 255.0f);
    clr = (clr + clout[hook(8, i)].x) * 0.5f;

    clout[hook(8, i)].x = (uchar)clr;
    clout[hook(8, i)].y = (uchar)clr;
    clout[hook(8, i)].z = (uchar)clr;
    clout[hook(8, i)].w = 255;
  }
}