//{"a":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void clCode(global int* a) {
  int globalId = get_global_id(0);
  int numOfGroups = get_num_groups(0);
  int groupId = get_group_id(0);
  int localId = get_local_id(0);

  a[hook(0, globalId * 4 + 0)] = globalId;
  a[hook(0, globalId * 4 + 1)] = numOfGroups;
  a[hook(0, globalId * 4 + 2)] = groupId;
  a[hook(0, globalId * 4 + 3)] = localId;
}