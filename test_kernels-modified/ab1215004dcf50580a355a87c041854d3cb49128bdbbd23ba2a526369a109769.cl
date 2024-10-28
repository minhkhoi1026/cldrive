//{"block_results":1,"output":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void propagate_subblock_results(global float* output, global float* block_results) {
  unsigned int group_id = get_group_id(0);
  unsigned int gid = get_global_id(0);
  if (group_id > 0)
    output[hook(0, gid)] += block_results[hook(1, group_id - 1)];
}