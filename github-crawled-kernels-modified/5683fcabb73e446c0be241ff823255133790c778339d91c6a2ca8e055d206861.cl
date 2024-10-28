//{"alpha":3,"dst":2,"eps":4,"n":0,"src":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline void AtomicAdd(volatile global float* source, const float operand) {
  union {
    unsigned int intVal;
    float floatVal;
  } newVal;
  union {
    unsigned int intVal;
    float floatVal;
  } prevVal;

  prevVal.floatVal = *source;

  while (true) {
    newVal.floatVal = prevVal.floatVal + operand;
    newVal.intVal = atomic_cmpxchg((volatile global unsigned int*)source, prevVal.intVal, newVal.intVal);

    if (newVal.intVal == prevVal.intVal) {
      break;
    }

    prevVal.intVal = newVal.intVal;
  }
}

kernel void GpuPowReverse(int n, global const float* restrict src, global float* restrict dst, float alpha, float eps) {
  int idx = get_global_id(0);
  int global_size = get_global_size(0);

  for (; idx < n; idx += global_size) {
    dst[hook(2, idx)] = 1 / (pow(src[hook(1, idx)], alpha) + eps);
  }
}