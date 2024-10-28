//{"cc":9,"escapeOrbit":8,"height":7,"imMax":3,"imMin":2,"limColor":10,"maxIter":5,"minIter":4,"outputBuffer":12,"reMax":1,"reMin":0,"rngBuffer":11,"width":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float frand(unsigned int* s1, unsigned int* s2, unsigned int* s3) {
  unsigned int b;
  b = (((*s1 << 13) ^ *s1) >> 19);
  *s1 = (((*s1 & 4294967294) << 12) ^ b);
  b = (((*s2 << 2) ^ *s2) >> 25);
  *s2 = (((*s2 & 4294967288) << 4) ^ b);
  b = (((*s3 << 3) ^ *s3) >> 11);
  *s3 = (((*s3 & 4294967280) << 17) ^ b);

  return (float)((*s1 ^ *s2 ^ *s3) * 2.3283064365e-10);
}

kernel void buddhabrot(const float reMin, const float reMax, const float imMin, const float imMax, const unsigned int minIter, const unsigned int maxIter, const unsigned int width, const unsigned int height, const float escapeOrbit, const float2 cc, const uint4 limColor, global uint4* rngBuffer, global uint4* outputBuffer) {
  int id = get_global_id(0);

  unsigned int s1 = rngBuffer[hook(11, id)].x;
  unsigned int s2 = rngBuffer[hook(11, id)].y;
  unsigned int s3 = rngBuffer[hook(11, id)].z;

  float2 rand;
  rand.x = frand(&s1, &s2, &s3);
  rand.y = frand(&s1, &s2, &s3);

  float rew = reMax - reMin;
  float imh = imMax - imMin;
  unsigned int jMax = (unsigned int)(4.f / rew * 100.f);

  float rr = rew / width;
  float ri = imh / height;

  rew = 1.0f / rew;
  imh = 1.0f / imh;

  float2 c = (float2)(mix(-2.0f, 2.0f, rand.x), mix(-2.0f, 2.0f, rand.y));

  unsigned int jLim = jMax * 10;
  float alpha = 0.0f;
  unsigned int j = 0;
  unsigned int atscr = 0, lastatscr;
  unsigned int isInMSet;
  int iter = 0;
  float2 z = 0.0f;
  while ((j < jMax) && (j < jLim)) {
    lastatscr = atscr;
    atscr = 0;
    iter = 0;
    z = 0.0f;

    isInMSet = 1;
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
                isInMSet = 0;
            }
          }
        }
      }
    }

    if (!isInMSet) {
      int x, y;
      iter = 0;
      z = 0.0f;
      int i;

      while ((iter < maxIter) && ((z.x * z.x + z.y * z.y) < escapeOrbit)) {
        z = (float2)(z.x * z.x - z.y * z.y, (z.x * z.y * 2.0f)) + c;

        x = (z.x - reMin) * rew * width;
        y = height - (z.y - imMin) * imh * height;

        if ((iter > minIter) && (x > 0) && (y > 0) && (x < width) && (y < height)) {
          atscr++;

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

    if (!atscr)
      break;
    else if (atscr != lastatscr)
      if (atscr > lastatscr)
        jMax *= 1.2f;
      else
        jMax *= 0.8f;

    float q = frand(&s1, &s2, &s3);
    alpha = q * 2.f * 3.1415926f;
    c.x += rr * cos(alpha);
    c.y += ri * sin(alpha);
    rr *= 1.5f;
    ri *= 1.5f;

    j++;
  }

  rngBuffer[hook(11, id)] = (uint4)(s1, s2, s3, 0);
}