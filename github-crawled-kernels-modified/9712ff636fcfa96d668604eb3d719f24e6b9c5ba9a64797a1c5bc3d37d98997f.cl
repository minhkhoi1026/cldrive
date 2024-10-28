//{"area":3,"histo":0,"img":1,"local_histo":4,"ptr":5,"widthStep":2}
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
kernel void calc_histogram_norm(global float* histo, global char* img, int widthStep, struct CvRect area) {
  int base = get_global_id(0);
  int tam = get_global_size(0);
  float inv_sum;
  int private_sum = 0, local_histo[10 * 10 + 10];
  local int sum;
  if (base == 0)
    sum = 0;
  for (int i = 0; i < 10 * 10 + 10; ++i)
    local_histo[hook(4, i)] = 0;

  for (int f = area.y + base; f < area.height; f += tam) {
    global float* ptr = (global float*)(img + widthStep * f);
    for (int col = area.x; col < area.width; ++col) {
      int desp = 3 * col;
      int bin = histo_bin(ptr[hook(5, desp)], ptr[hook(5, desp + 1)], ptr[hook(5, desp + 2)]);
      ++local_histo[hook(4, bin)];
    }
  }

  for (int i = 0; i < 10 * 10 + 10; ++i)
    private_sum += local_histo[hook(4, i)];
  atomic_add(&sum, private_sum);
  barrier(0x01);

  inv_sum = 1.0f / sum;
  for (int i = 0; i < 10 * 10 + 10; ++i)
    AtomicAddG(&histo[hook(0, i)], local_histo[hook(4, i)] * inv_sum);
}