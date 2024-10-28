//{"compactValues":3,"scan":2,"valid":0,"values":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void CompactArray_Long(global int* valid, global long* values, global int* scan, global long* compactValues) {
  const int index = get_global_id(0);
  if (valid[hook(0, index)]) {
    compactValues[hook(3, scan[ihook(2, index))] = values[hook(1, index)];
  }
}