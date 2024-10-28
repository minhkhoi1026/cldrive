//{"dst":4,"inner_size":1,"n":0,"norm":2,"src":3}
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

;

kernel void Normalize(int n, int inner_size, global const float* restrict norm, global const float* restrict src, global float* dst) {
  int idx = get_global_id(0);
  int global_size = get_global_size(0);

  for (; idx < n; idx += global_size) {
    int outer_idx = idx / inner_size;
    dst[hook(4, idx)] = src[hook(3, idx)] * norm[hook(2, outer_idx)];
  }
}