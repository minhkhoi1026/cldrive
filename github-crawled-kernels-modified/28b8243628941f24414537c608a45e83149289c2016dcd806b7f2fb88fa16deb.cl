//{"height":3,"image":1,"offset":5,"step":4,"val":0,"width":2}
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

kernel void memsetKernel(float val, global float* image, int width, int height, int step, int offset) {
  if (get_global_id(0) >= width || get_global_id(1) >= height) {
    return;
  }
  image += offset;
  image[hook(1, get_global_id(0) + get_global_id(1) * step)] = val;
}