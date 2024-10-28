//{"indices":0,"keys":1,"prefix_sums":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void prefix_sum_sort(volatile global int* indices, global int* keys, global int* prefix_sums) {
  const int g_id = get_global_id(0);

  const int key = keys[hook(1, g_id)];

  int dest_index = atomic_inc(prefix_sums + key);
  indices[hook(0, dest_index)] = g_id;
}