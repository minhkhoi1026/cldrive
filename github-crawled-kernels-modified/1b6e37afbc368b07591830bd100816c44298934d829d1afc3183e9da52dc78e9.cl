//{"aVec":0,"bVec":1,"cVec":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vectors_kernel(global int* aVec, global int* bVec, global int* cVec) {
  unsigned int groupID = get_group_id(0);

  cVec[hook(2, groupID)] = aVec[hook(0, groupID)] + bVec[hook(1, groupID)];
}