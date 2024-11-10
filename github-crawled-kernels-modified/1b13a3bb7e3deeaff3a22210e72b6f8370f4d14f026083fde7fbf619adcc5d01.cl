//{"group":1,"group_length":0,"group_temp":3,"group_temp_length":2,"points":6,"points_index":5,"points_length":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void point_polygon_expand_back(int group_length, global int* group, int group_temp_length, global int* group_temp, int points_length, global int* points_index, global int* points) {
  int idx = get_global_id(0);
  if (idx >= group_length)
    return;
  group[hook(1, idx)] = group_temp[hook(3, idx)];
}