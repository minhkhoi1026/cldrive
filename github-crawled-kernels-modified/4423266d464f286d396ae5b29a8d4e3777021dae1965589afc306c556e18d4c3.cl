//{"exitCells":0,"length":2,"scanArray":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void InitializeScanArray(global int* exitCells, global int* scanArray, int length) {
  int globalID = get_global_id(0);
  if (globalID < length) {
    if (exitCells[hook(0, globalID)] < -1)
      exitCells[hook(0, globalID)] = -(exitCells[hook(0, globalID)] + 2);
    scanArray[hook(1, globalID)] = exitCells[hook(0, globalID)] == -1 ? 0 : 1;
  }
}