//{"buffer":0,"sums":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void AddSums(global int* buffer, global int* sums) {
  unsigned int globalId = get_global_id(0);

  int val = sums[hook(1, get_group_id(0))];

  buffer[hook(0, globalId * 2 + 0)] += val;
  buffer[hook(0, globalId * 2 + 1)] += val;
}