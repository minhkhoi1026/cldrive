//{"bc":4,"d":2,"dist":1,"num_nodes":5,"s":0,"sigma":3}
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
kernel void back_sum_kernel(const int s, const int dist, global int* d, global float* sigma, global float* bc, const int num_nodes) {
  int tid = get_global_id(0);

  if (tid < num_nodes) {
    if (s != tid && d[hook(2, tid)] == dist - 1) {
      bc[hook(4, tid)] = bc[hook(4, tid)] + sigma[hook(3, tid)];
    }
  }
}