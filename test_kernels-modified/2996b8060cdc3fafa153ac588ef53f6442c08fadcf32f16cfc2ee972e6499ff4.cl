//{"compactActiveEdges":3,"edgeScan":1,"edgeValid":0,"edges":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant int4 EDGE_END_OFFSETS[3] = {
    (int4)(1, 0, 0, 0),
    (int4)(0, 1, 0, 0),
    (int4)(0, 0, 1, 0),
};

kernel void CompactEdges(global int* edgeValid, global int* edgeScan, global int* edges, global int* compactActiveEdges) {
  const int index = get_global_id(0);

  if (edgeValid[hook(0, index)]) {
    compactActiveEdges[hook(3, edgeScan[ihook(1, index))] = edges[hook(2, index)];
  }
}