//{"array":1,"block":2,"higherLevelArray":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Scan_WorkEfficientAdd(global unsigned int* higherLevelArray, global unsigned int* array, local unsigned int* block) {
  int GID = get_global_id(0);
  int group = get_group_id(0);
  if (group > 0)
    array[hook(1, GID)] += higherLevelArray[hook(0, group - 1)];
}