//{"n":1,"particles":0,"region":2}
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
kernel void calc_particles_init(global struct float4* particles, int n, struct CvRect region) {
  int base = get_global_id(0);
  int tam = get_global_size(0);

  int width = region.width;
  int height = region.height;
  float x = region.x + (float)(width >> 1);
  float y = region.y + (float)(height >> 1);

  for (int j = base; j < n; j += tam) {
    particles[hook(0, j)].x0 = x;
    particles[hook(0, j)].xp = x;
    particles[hook(0, j)].x = x;
    particles[hook(0, j)].y0 = y;
    particles[hook(0, j)].yp = y;
    particles[hook(0, j)].y = y;
    particles[hook(0, j)].sp = 1.0f;
    particles[hook(0, j)].s = 1.0f;
    particles[hook(0, j)].width = width;
    particles[hook(0, j)].height = height;
    particles[hook(0, j)].w = 0.0f;
  }
}