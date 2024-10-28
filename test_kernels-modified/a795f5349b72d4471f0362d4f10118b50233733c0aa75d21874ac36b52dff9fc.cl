//{"exitCells":0,"length":4,"newActiveParticles":3,"oldActiveParticles":1,"scanArray":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void CollectActiveParticles(global int* exitCells, global int* oldActiveParticles, global int* scanArray, global int* newActiveParticles, int length) {
  int globalID = get_global_id(0);
  if (globalID < length)
    if (exitCells[hook(0, oldActiveParticles[ghook(1, globalID))] >= 0)
      newActiveParticles[hook(3, scanArray[ghook(2, globalID))] = oldActiveParticles[hook(1, globalID)];
}