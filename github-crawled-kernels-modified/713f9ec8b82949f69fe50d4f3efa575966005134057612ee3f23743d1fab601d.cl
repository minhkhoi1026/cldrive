//{"gridCellIdx":2,"kParticleCount":0,"sortedPos":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sph_kernel_indexx(int kParticleCount, global float4* sortedPos, global int* gridCellIdx) {
  unsigned int gid = get_global_id(0);
  gridCellIdx[hook(2, gid)] = -1;

  int low = 0;
  int hi = kParticleCount - 1;
  int mid = 0;

  while (low <= hi) {
    mid = (hi + low) / 2;
    if (floor(sortedPos[hook(1, mid)].w) == gid) {
      int front = mid - 1;

      while ((front >= 0) && (sortedPos[hook(1, front)].w == gid)) {
        front--;
      }

      if (mid > front - 1) {
        gridCellIdx[hook(2, gid)] = front + 1;
      }

      break;

    } else if (sortedPos[hook(1, mid)].w < gid) {
      low = mid + 1;
    } else {
      hi = mid - 1;
    }
  }
}