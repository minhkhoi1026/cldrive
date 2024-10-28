//{"activeParticles":2,"exitCells":0,"length":3,"scanArray":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void CollectActiveParticles(global int* exitCells, global int* scanArray, global int* activeParticles, int length) {
  int globalID = get_global_id(0);
  if (globalID < length) {
    if (exitCells[hook(0, globalID)] != -1)
      activeParticles[hook(2, scanArray[ghook(1, globalID))] = globalID;
  }
}