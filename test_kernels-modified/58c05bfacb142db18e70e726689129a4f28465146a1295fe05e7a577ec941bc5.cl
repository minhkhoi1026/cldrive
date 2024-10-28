//{"all_depths":1,"all_idxs":2,"num_elts":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void do_init_depths_idx(int num_elts, global int* all_depths, global int* all_idxs) {
  int tid = get_global_id(0);
  if (tid >= num_elts) {
    return;
  }

  all_depths[hook(1, tid)] = 0;
  all_idxs[hook(2, tid)] = 0;
}