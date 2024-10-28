//{"dist_mins_global":1,"idx_mins_global":2,"num_elts":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void do_init_distances(int num_elts, global float* dist_mins_global, global int* idx_mins_global) {
  int tid = get_global_id(0);
  if (tid >= num_elts) {
    return;
  }

  dist_mins_global[hook(1, tid)] = 3.402823466e+38;
  idx_mins_global[hook(2, tid)] = 0;
}