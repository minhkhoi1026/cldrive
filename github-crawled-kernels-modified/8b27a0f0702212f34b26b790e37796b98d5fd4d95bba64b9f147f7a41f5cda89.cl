//{"costArray":4,"edgeArray":1,"edgeCount":7,"maskArray":3,"updatingCostArray":5,"vertexArray":0,"vertexCount":6,"weightArray":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void OCL_SSSP_KERNEL1(global int* vertexArray, global int* edgeArray, global float* weightArray, global int* maskArray, global float* costArray, global float* updatingCostArray, int vertexCount, int edgeCount) {
  int tid = get_global_id(0);

  if (maskArray[hook(3, tid)] != 0) {
    maskArray[hook(3, tid)] = 0;

    int edgeStart = vertexArray[hook(0, tid)];
    int edgeEnd;
    if (tid + 1 < (vertexCount)) {
      edgeEnd = vertexArray[hook(0, tid + 1)];
    } else {
      edgeEnd = edgeCount;
    }

    for (int edge = edgeStart; edge < edgeEnd; edge++) {
      int nid = edgeArray[hook(1, edge)];

      if (updatingCostArray[hook(5, nid)] > (costArray[hook(4, tid)] + weightArray[hook(2, edge)])) {
        updatingCostArray[hook(5, nid)] = (costArray[hook(4, tid)] + weightArray[hook(2, edge)]);
      }
    }
  }
}