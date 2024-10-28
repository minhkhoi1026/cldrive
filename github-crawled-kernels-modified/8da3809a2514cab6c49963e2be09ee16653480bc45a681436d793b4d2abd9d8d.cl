//{"costArray":1,"maskArray":0,"sourceVertex":3,"updatingCostArray":2,"vertexCount":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void initializeBuffers(global int* maskArray, global float* costArray, global float* updatingCostArray, int sourceVertex, int vertexCount) {
  int tid = get_global_id(0);

  if (sourceVertex == tid) {
    maskArray[hook(0, tid)] = 1;
    costArray[hook(1, tid)] = 0.0;
    updatingCostArray[hook(2, tid)] = 0.0;
  } else {
    maskArray[hook(0, tid)] = 0;
    costArray[hook(1, tid)] = 0x1.fffffep127f;
    updatingCostArray[hook(2, tid)] = 0x1.fffffep127f;
  }
}