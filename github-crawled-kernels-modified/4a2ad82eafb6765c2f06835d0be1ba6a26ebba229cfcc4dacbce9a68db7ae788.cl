//{"n":1,"p":0,"sum":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
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

kernel void calc_sum_pesos(global const struct float4* restrict p, const int n, global float* sum) {
  int lid = get_local_id(0);
  int base = get_global_id(0);
  int tam = get_global_size(0);
  local float sum_local;
  if (lid == 0)
    sum_local = 0.0f;
  barrier(0x01);

  for (int i = base; i < n; i += tam)
    AtomicAddL(&sum_local, p[hook(0, i)].w);

  barrier(0x01);
  if (lid == 0)
    AtomicAddG(&sum[hook(2, 0)], sum_local);
}