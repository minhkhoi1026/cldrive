//{"costArray":4,"edgeArray":1,"maskArray":3,"updatingCostArray":5,"vertexArray":0,"vertexCount":6,"weightArray":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void OCL_SSSP_KERNEL2(global int* vertexArray, global int* edgeArray, global float* weightArray, global int* maskArray, global float* costArray, global float* updatingCostArray, int vertexCount) {
  int tid = get_global_id(0);

  if (costArray[hook(4, tid)] > updatingCostArray[hook(5, tid)]) {
    costArray[hook(4, tid)] = updatingCostArray[hook(5, tid)];
    maskArray[hook(3, tid)] = 1;
  }

  updatingCostArray[hook(5, tid)] = costArray[hook(4, tid)];
}