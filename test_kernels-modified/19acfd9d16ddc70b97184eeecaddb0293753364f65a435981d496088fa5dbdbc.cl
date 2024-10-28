//{"aux":2,"generados":4,"n":0,"p":1,"pesos":3}
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
void mergeA(global struct float4* p, int start, int m, int stop, global struct float4* aux) {
  for (int i = start; i < m; i++)
    aux[hook(2, i)] = p[hook(1, i)];
  for (int j = m; j < stop; j++)
    aux[hook(2, j)] = p[hook(1, m + stop - j - 1)];
  int i = start, j = stop - 1;
  for (int k = start; k < stop; k++)
    if (aux[hook(2, j)].w > aux[hook(2, i)].w)
      p[hook(1, k)] = aux[hook(2, j--)];
    else
      p[hook(1, k)] = aux[hook(2, i++)];
}

kernel void remuestreo_parcial(int n, global struct float4* p, global struct float4* aux, global int* pesos, global int* generados) {
  int base = get_global_id(0);
  int tam = get_global_size(0);
  int start, stop;

  for (int i = base; i < n; i += tam) {
    if (i > 0)
      start = pesos[hook(3, i - 1)];
    else
      start = 0;
    stop = pesos[hook(3, i)];
    for (int j = start; j < stop; ++j)
      if (j < n)
        aux[hook(2, j)] = p[hook(1, i)];
  }
  if (base == 0)
    *generados = pesos[hook(3, n - 1)];
}