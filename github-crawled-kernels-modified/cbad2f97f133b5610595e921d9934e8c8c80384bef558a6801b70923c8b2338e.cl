//{"group":1,"group_length":0,"group_temp":3,"group_temp_length":2,"neighbours":6,"neighbours_index":5,"neighbours_length":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void polygon_edge_expand_back(int group_length, global int* group, int group_temp_length, global int* group_temp, int neighbours_length, global int* neighbours_index, global int* neighbours) {
  int idx = get_global_id(0);
  if (idx >= group_length || group[hook(1, idx)])
    return;
  group[hook(1, idx)] = group_temp[hook(3, idx)];
}