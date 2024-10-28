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

unsigned int IsInMSet(float2 c, unsigned int minIter, unsigned int maxIter, float escapeOrbit) {
  unsigned int iter = 0;
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

kernel void metrohast(const float reMin, const float reMax, const float imMin, const float imMax, const unsigned int minIter, const unsigned int maxIter, const unsigned int width, const unsigned int height, const float escapeOrbit, const float2 cc, const uint4 limColor, global uint4* rngBuffer, global uint4* outputBuffer) {
  int id = get_global_id(0);

  unsigned int s1 = rngBuffer[hook(11, id)].x;
  unsigned int s2 = rngBuffer[hook(11, id)].y;
  unsigned int s3 = rngBuffer[hook(11, id)].z;

  float2 rand;

  rand.x = frand(&s1, &s2, &s3);
  rand.y = frand(&s1, &s2, &s3);

  float rew = reMax - reMin;
  float imh = imMax - imMin;
  unsigned int jMax = (unsigned int)(log(4.f / rew + 1.f) * 100.f);

  float r1 = rew * 0.0001f;
  float r2 = imh * 0.1f;
  float logreim = -log(r2 / r1);

  rew = 1.0f / rew;
  imh = 1.0f / imh;

  float2 c = (float2)(mix(-2.0f, 2.0f, rand.x), mix(-2.0f, 2.0f, rand.y));

  int iter = 0;
  float2 z = 0.0f;
  iter = 0;
  z = 0.0f;

  int x, y;
  int i;

  unsigned int atscr = 0;
  while ((iter < maxIter) && ((z.x * z.x + z.y * z.y) < escapeOrbit)) {
    z = (float2)(z.x * z.x - z.y * z.y, (z.x * z.y * 2.0f)) + c;

    x = (z.x - reMin) * rew * width;
    y = height - (z.y - imMin) * imh * height;

    if ((iter > minIter) && (x > 0) && (y > 0) && (x < width) && (y < height))
      atscr++;

    iter++;
  }

  float2 prev_c = c;
  float prev_contrib = atscr / (float)iter;
  float prev_iter = iter;
  unsigned int prev_atscr = atscr;
  int j = 0;
  for (j = 0; j < jMax; j++) {
    float2 mutc = prev_c;
    float q = mix(0.0f, 5.0f, frand(&s1, &s2, &s3));
    if (q < 4.0f) {
      float a = frand(&s1, &s2, &s3);
      float b = frand(&s1, &s2, &s3);
      float phi = a * 2.0f * 3.1415926f;
      float r = r2 * exp(logreim * b);

      mutc.x += r * cos(phi);
      mutc.y += r * sin(phi);
    } else {
      mutc.x = mix(-2.0f, 2.0f, frand(&s1, &s2, &s3));
      mutc.y = mix(-2.0f, 2.0f, frand(&s1, &s2, &s3));
    }

    if (IsInMSet(mutc, minIter, maxIter, escapeOrbit))
      continue;

    z = 0.0f;
    unsigned int mut_iter = 0;
    unsigned int mut_atscr = 0;
    while ((mut_iter < maxIter) && ((z.x * z.x + z.y * z.y) < escapeOrbit)) {
      z = (float2)(z.x * z.x - z.y * z.y, (z.x * z.y * 2.0f)) + mutc;

      x = (z.x - reMin) * rew * width;
      y = height - (z.y - imMin) * imh * height;

      if ((iter > minIter) && (x > 0) && (y > 0) && (x < width) && (y < height))
        mut_atscr++;

      mut_iter++;
    }

    float mut_contrib = mut_atscr / (float)mut_iter;
    if (mut_contrib == 0.0f)
      continue;

    float t1 = (1.f - (mut_iter - mut_atscr) / mut_iter) / (1.f - (prev_iter - prev_atscr) / prev_iter);
    float t2 = (1.f - (prev_iter - prev_atscr) / prev_iter) / (1.f - (mut_iter - mut_atscr) / mut_iter);
    float alpha = min(1.0f, exp(log(mut_contrib * t1) - log(prev_contrib * t2)));
    float rnd = frand(&s1, &s2, &s3);

    if (alpha > rnd) {
      prev_contrib = mut_contrib;
      prev_iter = mut_iter;
      prev_atscr = mut_atscr;
      prev_c = mutc;

      iter = 0;
      z = 0.0f;
      while ((iter < maxIter) && ((z.x * z.x + z.y * z.y) < escapeOrbit)) {
        z = (float2)(z.x * z.x - z.y * z.y, (z.x * z.y * 2.0f)) + mutc;

        x = (z.x - reMin) * rew * width;
        y = height - (z.y - imMin) * imh * height;

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

  rngBuffer[hook(11, id)] = (uint4)(s1, s2, s3, 0);
}