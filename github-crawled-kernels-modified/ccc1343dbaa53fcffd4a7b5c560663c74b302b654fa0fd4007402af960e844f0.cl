//{"dst":4,"inner_size":1,"n":0,"norm":2,"sdata":5,"src":3}
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

kernel void NormalizeComputeNorm(int n, int inner_size, global const float* restrict norm, global const float* restrict src, global float* restrict dst) {
  local float sdata[1];
  int tid = get_local_id(0);
  int i = get_global_id(0);
  int in_n_index = i / inner_size;
  int idx_limit = (in_n_index + 1) * inner_size;

  if (tid == 0) {
    sdata[hook(5, 0)] = 1 / (sqrt(norm[hook(2, in_n_index)] / inner_size) + 1e-6f);
  }

  barrier(0x01);

  if (i < idx_limit) {
    dst[hook(4, i)] = src[hook(3, i)] * sdata[hook(5, 0)];
  }
}