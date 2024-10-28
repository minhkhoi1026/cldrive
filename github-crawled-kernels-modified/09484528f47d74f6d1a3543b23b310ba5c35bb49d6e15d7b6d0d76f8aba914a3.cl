//{"gridCellIdx":1,"gridCellIdxFixedUp":2,"kParticleCount":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sph_kernel_indexPostPass(int kParticleCount, global int* gridCellIdx, global int* gridCellIdxFixedUp) {
  size_t gid = get_global_id(0);

  if (gridCellIdx[hook(1, gid)] != -1) {
    gridCellIdxFixedUp[hook(2, gid)] = gridCellIdx[hook(1, gid)];
  } else {
    int preCell = gid;

    while (preCell >= 0) {
      int pid = gridCellIdx[hook(1, preCell)];
      if (pid != -1) {
        gridCellIdxFixedUp[hook(2, gid)] = pid;
        break;
      } else {
        preCell--;
      }
    }
  }
}