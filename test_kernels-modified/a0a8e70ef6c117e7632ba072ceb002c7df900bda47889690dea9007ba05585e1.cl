//{"batchSize":3,"dpars":1,"pars":0,"stepSize":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline float atomic_add(volatile global float* address, const float value) {
  float old = value;
  while ((old = atomic_xchg(address, atomic_xchg(address, 0.0f) + old)) != 0.0f)
    ;
  return old;
}

kernel void make_step_kernel(global float* pars, global float* dpars, float stepSize, int batchSize) {
  int tid = get_global_id(0);

  if (tid < batchSize) {
    pars[hook(0, tid)] -= dpars[hook(1, tid)] * stepSize;
    dpars[hook(1, tid)] = 0;
  }
}