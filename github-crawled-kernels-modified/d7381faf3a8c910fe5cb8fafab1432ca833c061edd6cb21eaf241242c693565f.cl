//{"F":5,"H":4,"N":10,"W":3,"a":1,"dx":2,"image":12,"k":0,"len":7,"ptr":6,"px":8,"py":9,"width":11}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline float BesselJ1(float x) {
  float y = (x < 0.0f) ? -x : x;

  if (y < 3.945f) {
    float x2 = x * x;
    float x3 = x2 * x;
    float x5 = x3 * x2;
    float x7 = x5 * x2;
    float x9 = x7 * x2;
    float x11 = x9 * x2;
    float x13 = x11 * x2;

    return x / 2.0f - x3 / 16.0f + x5 / 384.0f - x7 / 18432.0f + x9 / 1.47456e6f - x11 / 1.769472e8f + x13 / 2.97271296e10f;
  } else {
    float y2 = y * y;
    float y3 = y2 * y;
    float y4 = y2 * y2;

    float answer = native_sqrt(2.0f / (3.14159265359f * y)) * (1.0f + 3.0f / (16.0f * y2) - 99.0f / (512.0f * y4)) * native_cos(y - 3.0f * 3.14159265359f / 4.0f + 3.0f / (8.0f * y) - 21.0f / (128.0f * y3));

    if (x < 0.0f)
      answer = -answer;
    return answer;
  }
}

kernel void pixelPSF(const float k, const float a, const float dx, const int W, const int H, const int F, global const int* ptr, global const int* len, global const float* px, global const float* py, global const float* N, global const float* width, global float* image) {
  int img = get_global_id(0);
  int m = get_global_id(1);
  int n = get_global_id(2);

  float xp = (a + dx) * (float)m;
  float yp = (a + dx) * (float)n;

  float Gsum = 0.0f;

  for (int i = 0; i < F; i++) {
    float xs = a * (float)i / (float)F + dx * 0.5f + a * 0.5f / (float)F;
    float x = xp + xs;

    for (int j = 0; j < F; j++) {
      float ys = a * (float)j / (float)F + dx * 0.5f + a * 0.5f / (float)F;
      float y = yp + ys;

      for (int p = ptr[hook(6, img)]; p < ptr[hook(6, img)] + len[hook(7, img)]; p++) {
        float numphoton = (float)N[hook(10, p)];
        float xtemp = (x - px[hook(8, p)]);
        float ytemp = (y - py[hook(9, p)]);
        float r = native_sqrt(xtemp * xtemp + ytemp * ytemp);

        if (r * r < 0.000001f) {
          r = 0.000001f;
        }

        float width1 = width[hook(11, p)] / 1.8666f;

        float intensity = 975.414f * k * k / (width1 * width1);

        float value = (2.0f * BesselJ1(k * r / width1) * width1 / (k * r));
        Gsum += value * intensity * numphoton * value;
      }
    }
  }

  image[hook(12, m + n * W + img * W * H)] = Gsum / (float)(F * F);
}