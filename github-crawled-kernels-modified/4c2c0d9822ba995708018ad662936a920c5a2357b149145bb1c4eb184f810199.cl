//{"group":1,"group_length":0,"group_temp":3,"group_temp_length":2,"neighbours":6,"neighbours_index":5,"neighbours_length":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void point_edge_expand(int group_length, global int* group, int group_temp_length, global int* group_temp, int neighbours_length, global int* neighbours_index, global int* neighbours) {
  int idx = get_global_id(0);
  if (idx >= group_length || group[hook(1, idx)])
    return;
  for (int i = neighbours_index[hook(5, idx)]; i < neighbours_index[hook(5, idx + 1)]; ++i)
    group_temp[hook(3, idx)] = max(group_temp[hook(3, idx)], group[hook(1, neighbours[ihook(6, i))]);
}