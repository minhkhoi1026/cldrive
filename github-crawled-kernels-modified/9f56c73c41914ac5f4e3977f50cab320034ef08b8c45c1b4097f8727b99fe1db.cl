//{"results":1,"scratch":2,"values":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void find_minimum(global const float* values, global float* results, local float* scratch) {
  int i = get_local_id(0);
  int n = get_local_size(0);
  scratch[hook(2, i)] = values[hook(0, get_global_id(0))];
  barrier(0x01);
  for (int j = n / 2; j > 0; j /= 2) {
    if (i < j)
      scratch[hook(2, i)] = min(scratch[hook(2, i)], scratch[hook(2, i + j)]);
    barrier(0x01);
  }
  if (i == 0)
    results[hook(1, get_group_id(0))] = scratch[hook(2, 0)];
}