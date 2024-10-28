//{"dist_array":1,"num_nodes":4,"rho":3,"sigma":2,"source":0}
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
kernel void clean_1d_array(const int source, global int* dist_array, global float* sigma, global float* rho, const int num_nodes) {
  int tid = get_global_id(0);

  if (tid < num_nodes) {
    sigma[hook(2, tid)] = 0;

    if (tid == source) {
      rho[hook(3, tid)] = 1;
      dist_array[hook(1, tid)] = 0;

    } else {
      rho[hook(3, tid)] = 0;
      dist_array[hook(1, tid)] = -1;
    }
  }
}