//{"buffer":0,"d_offset":5,"dst":7,"f_offset":4,"factors":6,"height":2,"step":3,"width":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 2 | 0x20;
inline void atomic_addf(volatile global float* source, const float operand) {
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

kernel void normalizeKernel(global float* buffer, int width, int height, int step, int f_offset, int d_offset) {
  global float* factors = buffer + f_offset;
  global float* dst = buffer + d_offset;

  int j = get_global_id(0);
  int i = get_global_id(1);

  if (j >= width || i >= height) {
    return;
  }
  float scale = factors[hook(6, step * i + j)];
  float invScale = (scale == 0.0f) ? 1.0f : (1.0f / scale);

  dst[hook(7, step * i + j)] *= invScale;
}