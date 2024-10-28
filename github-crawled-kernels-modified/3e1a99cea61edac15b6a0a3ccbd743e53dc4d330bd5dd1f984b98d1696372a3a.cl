//{"n":2,"out":1,"sums":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void addGroupSums(global int* sums, global int4* out, unsigned int n) {
  unsigned int wgXdim = get_num_groups(0);

  unsigned int gX = get_global_id(0);
  unsigned int gY = get_global_id(1);
  unsigned int wgX = get_group_id(0);

  int sum = sums[hook(0, gY * (wgXdim + 1) + wgX)];

  if (gX < n)
    out[hook(1, gY * n + gX)] += sum;
}