//{"bc_d":0,"num_nodes":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline float atomic_add_float(global float* const address, const float value) {
  unsigned int oldval, newval, readback;

  *(float*)&oldval = *address;
  *(float*)&newval = (*(float*)&oldval + value);
  while ((readback = atomic_cmpxchg((global unsigned int*)address, oldval, newval)) != oldval) {
    oldval = readback;
    *(float*)&newval = (*(float*)&oldval + value);
  }
  return *(float*)&oldval;
}
kernel void clean_bc(global float* bc_d, const int num_nodes) {
  int tid = get_global_id(0);

  if (tid < num_nodes)
    bc_d[hook(0, tid)] = 0;
}