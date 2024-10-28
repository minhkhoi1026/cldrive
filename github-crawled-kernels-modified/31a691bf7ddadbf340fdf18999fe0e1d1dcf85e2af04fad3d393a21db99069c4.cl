//{"height":5,"histo":7,"historef":3,"img":2,"n":1,"p":0,"ptr":8,"width":6,"widthStep":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
struct CvRect {
  int x;
  int y;
  int width;
  int height;
};

struct float4 {
  float x;
  float y;
  float s;
  float xp;
  float yp;
  float sp;
  float x0;
  float y0;
  int width;
  int height;
  float w;
};
inline void AtomicAddG(volatile global float* source, const float operand) {
  union {
    unsigned int intVal;
    float floatVal;
  } newVal;
  union {
    unsigned int intVal;
    float floatVal;
  } prevVal;
  do {
    prevVal.floatVal = *source;
    newVal.floatVal = prevVal.floatVal + operand;
  } while (atomic_cmpxchg((volatile global unsigned int*)source, prevVal.intVal, newVal.intVal) != prevVal.intVal);
}

inline void AtomicAddL(volatile local float* source, const float operand) {
  union {
    unsigned int intVal;
    float floatVal;
  } newVal;
  union {
    unsigned int intVal;
    float floatVal;
  } prevVal;
  do {
    prevVal.floatVal = *source;
    newVal.floatVal = prevVal.floatVal + operand;
  } while (atomic_cmpxchg((volatile local unsigned int*)source, prevVal.intVal, newVal.intVal) != prevVal.intVal);
}
int histo_bin(float h, float s, float v) {
  int hd, sd, vd;

  vd = min((int)(v * 10 / 1.0f), 10 - 1);
  if (s < 0.1f || v < 0.2f)
    return 10 * 10 + vd;

  hd = min((int)(h * 10 / 360.0f), 10 - 1);
  sd = min((int)(s * 10 / 1.0f), 10 - 1);
  return sd * 10 + hd;
}
double ran_gaussian(int* estadoN1, double sigma) {
  double x, y, r2;
  do {
    *estadoN1 = (214013 * (*estadoN1) + 2531011) % 2147483648;
    double u1 = (*estadoN1) / 2147483648.0;
    *estadoN1 = (214013 * (*estadoN1) + 2531011) % 2147483648;
    double u2 = (*estadoN1) / 2147483648.0;

    x = -1.0 + 2.0 * u1;
    y = -1.0 + 2.0 * u2;

    r2 = x * x + y * y;
  } while (r2 > 1.0 || r2 == 0);

  return sigma * y * sqrt(-2.0 * log(r2) / r2);
}
kernel void calc_probabilidad(global struct float4* p, int n, global char* img, global float* historef, int widthStep, int height, int width) {
  int base = get_global_id(0);
  int tam = get_global_size(0);
  float inv_sum;
  int sum;
  int w, h, Forigen, Corigen, Ffinal, Cfinal;
  int histo[10 * 10 + 10];

  for (int i = base; i < n; i += tam) {
    sum = 0;
    for (int j = 0; j < 10 * 10 + 10; ++j)
      histo[hook(7, j)] = 0;

    w = round(p[hook(0, i)].width * p[hook(0, i)].s);
    h = round(p[hook(0, i)].height * p[hook(0, i)].s);
    Forigen = (round(p[hook(0, i)].y) - (h >> 1));
    Forigen = Forigen < 0 ? 0 : Forigen;
    Corigen = (round(p[hook(0, i)].x) - (w >> 1));
    Corigen = Corigen < 0 ? 0 : Corigen;
    Ffinal = Forigen + h > height ? height : Forigen + h;
    Cfinal = Corigen + w > width ? width : Corigen + w;

    for (int f = Forigen; f < Ffinal; ++f) {
      global float* ptr = (global float*)(img + widthStep * f);
      for (int col = Corigen; col < Cfinal; ++col) {
        int desp = 3 * col;
        int bin = histo_bin(ptr[hook(8, desp)], ptr[hook(8, desp + 1)], ptr[hook(8, desp + 2)]);
        histo[hook(7, bin)]++;
      }
    }

    for (int j = 0; j < 10 * 10 + 10; ++j)
      sum += histo[hook(7, j)];

    inv_sum = 1.0f / sum;

    float sumatoria = 0.0f;
    for (int j = 0; j < 10 * 10 + 10; ++j)
      sumatoria += (float)sqrt(histo[hook(7, j)] * inv_sum * historef[hook(3, j)]);
    float d_sq = 1.0f - sumatoria;
    p[hook(0, i)].w = (float)exp(-20 * d_sq);
  }
}