//{"cc":9,"escapeOrbit":8,"height":7,"imMax":3,"imMin":2,"limColor":10,"maxIter":5,"minIter":4,"outputBuffer":12,"reMax":1,"reMin":0,"rngBuffer":11,"width":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
unsigned int isInMSet(const float2 c, const unsigned int minIter, const unsigned int maxIter, const float escapeOrbit) {
  int iter = 0;
  float2 z = 0.0f;

  if (!(((c.x - 0.25f) * (c.x - 0.25f) + (c.y * c.y)) * (((c.x - 0.25f) * (c.x - 0.25f) + (c.y * c.y)) + (c.x - 0.25f)) < 0.25f * c.y * c.y)) {
    if (!((c.x + 1.0f) * (c.x + 1.0f) + (c.y * c.y) < 0.0625f)) {
      if (!((((c.x + 1.309f) * (c.x + 1.309f)) + c.y * c.y) < 0.00345f)) {
        if (!((((c.x + 0.125f) * (c.x + 0.125f)) + (c.y - 0.744f) * (c.y - 0.744f)) < 0.0088f)) {
          if (!((((c.x + 0.125f) * (c.x + 0.125f)) + (c.y + 0.744f) * (c.y + 0.744f)) < 0.0088f)) {
            while ((iter < maxIter) && (z.x * z.x + z.y * z.y < escapeOrbit)) {
              z = (float2)(z.x * z.x - z.y * z.y, (z.x * z.y * 2.0f)) + c;
              iter++;
            }

            if ((iter > minIter) && (iter < maxIter))
              return 0;
          }
        }
      }
    }
  }
  return 1;
}

kernel void buddhabrot(const float reMin, const float reMax, const float imMin, const float imMax, const unsigned int minIter, const unsigned int maxIter, const unsigned int width, const unsigned int height, const float escapeOrbit, const float2 cc, const uint4 limColor, global uint4* rngBuffer, global uint4* outputBuffer) {
  int id = get_global_id(0);

  unsigned int s1 = rngBuffer[hook(11, id)].x;
  unsigned int s2 = rngBuffer[hook(11, id)].y;
  unsigned int s3 = rngBuffer[hook(11, id)].z;

  float2 rand;

  unsigned int b;
  b = (((s1 << 13) ^ s1) >> 19);
  s1 = (((s1 & 4294967294) << 12) ^ b);
  b = (((s2 << 2) ^ s2) >> 25);
  s2 = (((s2 & 4294967288) << 4) ^ b);
  b = (((s3 << 3) ^ s3) >> 11);
  s3 = (((s3 & 4294967280) << 17) ^ b);

  rand.x = (float)((s1 ^ s2 ^ s3) * 2.3283064365e-10);

  b = (((s1 << 13) ^ s1) >> 19);
  s1 = (((s1 & 4294967294) << 12) ^ b);
  b = (((s2 << 2) ^ s2) >> 25);
  s2 = (((s2 & 4294967288) << 4) ^ b);
  b = (((s3 << 3) ^ s3) >> 11);
  s3 = (((s3 & 4294967280) << 17) ^ b);

  rand.y = (float)((s1 ^ s2 ^ s3) * 2.3283064365e-10);

  rngBuffer[hook(11, id)] = (uint4)(s1, s2, s3, b);

  float2 c = (float2)(mix(-2.0f, 2.0f, rand.x), mix(-2.0f, 2.0f, rand.y));

  if (!isInMSet(c, minIter, maxIter, escapeOrbit)) {
    int x, y;
    int iter = 0;
    float2 z = 0.0f;
    int i;

    while ((iter < maxIter) && ((z.x * z.x + z.y * z.y) < escapeOrbit)) {
      z = (float2)(z.x * z.x - z.y * z.y, (z.x * z.y * 2.0f)) + c;
      x = (z.x - reMin) / (reMax - reMin) * width;
      y = height - (z.y - imMin) / (imMax - imMin) * height;

      if ((iter > minIter) && (x > 0) && (y > 0) && (x < width) && (y < height)) {
        i = x + (y * width);

        outputBuffer[hook(12, i)].w++;

        if (iter <= limColor.x)
          outputBuffer[hook(12, i)].x++;
        else if ((iter > limColor.x) && (iter < limColor.y))
          outputBuffer[hook(12, i)].y++;
        else if (iter >= limColor.y)
          outputBuffer[hook(12, i)].z++;
      }

      iter++;
    }
  }
}