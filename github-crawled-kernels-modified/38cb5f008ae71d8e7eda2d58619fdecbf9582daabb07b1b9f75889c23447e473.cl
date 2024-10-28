//{"array":1,"higherLevelArray":0,"localBlock":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Scan_WorkEfficientAdd(global unsigned int* higherLevelArray, global unsigned int* array, local unsigned int* localBlock) {
  unsigned int id = get_local_id(0);
  unsigned int group = get_group_id(0);
  unsigned int pos = id + (group + 2) * get_local_size(0);

  localBlock[hook(2, id)] = array[hook(1, pos)];

  localBlock[hook(2, id)] += higherLevelArray[hook(0, group / 2)];

  array[hook(1, pos)] = localBlock[hook(2, id)];
}