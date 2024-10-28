//{"global_out":2,"num_vals":1,"out":3,"stage":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void collect_indices(const int stage, const unsigned int num_vals, global int* global_out) {
  global int* const out = global_out + num_vals * get_global_id(1);

  unsigned int offset = 1 << (stage * 7);
  unsigned int gidx = offset * get_group_id(0) - 1;

  unsigned int next_offset = 1 << ((stage - 1) * 7);
  unsigned int tidx = next_offset * (get_global_id(0) + 1) - 1;

  bool run = tidx < (num_vals - 1);
  run = run && gidx < (num_vals - 1);
  run = run && get_group_id(0) > 0;
  run = run && get_local_id(0) != (128 - 1);
  if (run) {
    out[hook(3, tidx)] += out[hook(3, gidx)];
  }
}