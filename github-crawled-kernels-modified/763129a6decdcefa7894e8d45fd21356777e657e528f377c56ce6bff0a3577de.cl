//{"all_stacks":1,"num_elts":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void do_init_allstacks(int num_elts, global int* all_stacks) {
  int tid = get_global_id(0);
  if (tid >= num_elts) {
    return;
  }

  all_stacks[hook(1, tid)] = 0;
}