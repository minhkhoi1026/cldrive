//{"floatBuff":2,"iterationsGlobal":0,"iterationsInternal":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline unsigned long fibonacci(int n) {
  unsigned long n1 = 0;
  unsigned long n2 = 1;
  unsigned long next = 0;

  next = n1 + n2;
  for (int j = 0; j < n - 3; j++) {
    n1 = n2;
    n2 = next;
    next = n1 + n2;
  }

  return next;
}

inline float trigonometrySP(int t) {
  float result = 0;
  float p1 = 0;
  float p2 = 0;

  for (int j = 0; j < t; j++) {
    float testVal = 1.33f;
    p1 = cos(testVal) + sin(testVal);
    p2 = p1 * tan(testVal);
    result += p1 + p2;
  }

  return result;
}

inline double trigonometryDP(int t) {
  double result = 0;
  double p1 = 0;
  double p2 = 0;

  for (int j = 0; j < t; j++) {
    double testVal = 1.33f;
    p1 = cos(testVal) + sin(testVal);
    p2 = p1 * tan(testVal);
    result += p1 + p2;
  }

  return result;
}

inline double piLeibniz(int p) {
  double part = 0;
  for (int i = 0; i < p; i++) {
    if (i % 2 == 0)
      part += 1 / (2.0 * (double)i + 1.0);
    else
      part -= 1 / (2.0 * (double)i + 1.0);
  }

  double series = 4 * part;
  return series;
}

kernel void trigonometryLoopSP(const int iterationsGlobal, const int iterationsInternal, global float* floatBuff) {
  float r = 0;
  for (int i = 0; i < iterationsGlobal; i++) {
    r = trigonometrySP(iterationsInternal);
  }

  size_t gid = get_global_id(0);
  floatBuff[hook(2, gid)] = r;
}