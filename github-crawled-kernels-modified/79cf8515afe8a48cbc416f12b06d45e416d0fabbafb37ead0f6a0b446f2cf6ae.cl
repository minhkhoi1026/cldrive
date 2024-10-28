//{"group":1,"group_length":0,"group_temp":3,"group_temp_length":2,"prims":6,"prims_index":5,"prims_length":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void polygon_polygon_expand(int group_length, global int* group, int group_temp_length, global int* group_temp, int prims_length, global int* prims_index, global int* prims) {
  int idx = get_global_id(0);
  if (idx >= group_length || group[hook(1, idx)])
    return;
  for (int pt = prims_index[hook(5, idx)]; pt < prims_index[hook(5, idx + 1)]; ++pt) {
    if (group[hook(1, prims[phook(6, pt))]) {
      group_temp[hook(3, idx)] = 1;
      return;
    }
  }
}