//{"bc":10,"col":1,"d":2,"dist":8,"num_edges":7,"num_nodes":6,"p":5,"rho":3,"row":0,"s":9,"sigma":4}
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
kernel void backtrack_kernel(global int* row, global int* col, global int* d, global float* rho, global float* sigma, global int* p, const int num_nodes, const int num_edges, const int dist, const int s, global float* bc) {
  int tid = get_global_id(0);

  if (tid < num_nodes && d[hook(2, tid)] == dist - 1) {
    int start = row[hook(0, tid)];
    int end;
    if (tid + 1 < num_nodes)
      end = row[hook(0, tid + 1)];
    else
      end = num_edges;

    for (int edge = start; edge < end; edge++) {
      int w = col[hook(1, edge)];

      if (d[hook(2, w)] == dist - 2)
        atomic_add_float(&sigma[hook(4, w)], rho[hook(3, w)] / rho[hook(3, tid)] * (1 + sigma[hook(4, tid)]));
    }

    if (tid != s)
      bc[hook(10, tid)] = bc[hook(10, tid)] + sigma[hook(4, tid)];
  }
}