//{"group":1,"group_length":0,"group_temp":3,"group_temp_length":2,"points":6,"points_index":5,"points_length":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void point_polygon_expand(int group_length, global int* group, int group_temp_length, global int* group_temp, int points_length, global int* points_index, global int* points) {
  int idx = get_global_id(0);
  if (idx >= group_length || group[hook(1, idx)])
    return;
  for (int pt = points_index[hook(5, idx)]; pt < points_index[hook(5, idx + 1)]; ++pt) {
    if (group[hook(1, points[phook(6, pt))]) {
      group_temp[hook(3, idx)] = 1;
      return;
    }
  }
}