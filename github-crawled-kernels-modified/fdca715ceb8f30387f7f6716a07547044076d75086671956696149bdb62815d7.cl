//{"exitCells":0,"length":3,"oldActiveParticles":1,"scanArray":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void InitializeScanArray(global int* exitCells, global int* oldActiveParticles, global int* scanArray, int length) {
  int globalID = get_global_id(0);
  if (globalID < length)
    scanArray[hook(2, globalID)] = exitCells[hook(0, oldActiveParticles[ghook(1, globalID))] < 0 ? 0 : 1;
}