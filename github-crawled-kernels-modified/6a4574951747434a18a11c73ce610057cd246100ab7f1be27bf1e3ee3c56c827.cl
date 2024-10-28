//{"data":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void intergroup_hidden_race(global int* data, global int* output) {
  int group = get_group_id(0);
  output[hook(1, group)] = data[hook(0, 0)];
  if (group == 1) {
    data[hook(0, 0)] = group;
  }
}