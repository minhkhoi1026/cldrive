//{"compactIndices":3,"edgeIndices":1,"edgeValid":0,"scan":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void CompactIndexArray(global int* edgeValid, global int* edgeIndices, global int* scan, global int* compactIndices) {
  const int index = get_global_id(0);
  if (edgeValid[hook(0, index)]) {
    compactIndices[hook(3, scan[ihook(2, index))] = edgeIndices[hook(1, index)];
  }
}