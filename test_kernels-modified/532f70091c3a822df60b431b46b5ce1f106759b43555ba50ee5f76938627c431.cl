//{"data":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void intergroup_race(global int* data) {
  int g = get_group_id(0);
  if (get_local_id(0) == 0) {
    data[hook(0, g)] = g;
  }
  barrier(0x02);
  if (get_global_id(0) == 0) {
    int x = 0;
    for (int i = 0; i < get_num_groups(0); i++) {
      x += data[hook(0, i)];
    }
    data[hook(0, 0)] = x;
  }
  barrier(0x02);
}