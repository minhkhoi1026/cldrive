//{"cells":0,"numCells":2,"numParticles":3,"particles_list":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void initCellsOld(global int* cells, global int* particles_list, const unsigned int numCells, const unsigned int numParticles) {
  const unsigned int i = get_global_id(0);

  if (i < numCells) {
    cells[hook(0, i)] = -1;
  }

  if (i < numParticles) {
    particles_list[hook(1, i)] = -1;
  }
}