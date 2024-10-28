//{"border":6,"cols":4,"gpuResults":3,"gpuSrc":2,"gpuWall":1,"iteration":0,"prev":7,"result":8,"startStep":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void dynproc_kernel(int iteration, global int* restrict gpuWall, global int* restrict gpuSrc, global int* restrict gpuResults, int cols, int startStep, int border) {
  int bx = get_group_id(0);
  int tx = get_local_id(0);

  local int prev[256];
  local int result[256];

  int small_block_cols = 256 - (iteration * 1 * 2);

  int blkX = (small_block_cols * bx) - border;
  int blkXmax = blkX + 256 - 1;

  int xidx = blkX + tx;

  int validXmin = (blkX < 0) ? -blkX : 0;
  int validXmax = (blkXmax > cols - 1) ? 256 - 1 - (blkXmax - cols + 1) : 256 - 1;

  int W = tx - 1;
  int E = tx + 1;

  W = (W < validXmin) ? validXmin : W;
  E = (E > validXmax) ? validXmax : E;

  bool isValid = ((tx) >= (validXmin) && (tx) <= (validXmax));

  if (((xidx) >= (0) && (xidx) <= (cols - 1))) {
    prev[hook(7, tx)] = gpuSrc[hook(2, xidx)];
  }

  barrier(0x01);

  bool computed;
  for (int i = 0; i < iteration; i++) {
    computed = false;

    if (((tx) >= (i + 1) && (tx) <= (256 - i - 2)) && isValid) {
      computed = true;
      int left = prev[hook(7, W)];
      int up = prev[hook(7, tx)];
      int right = prev[hook(7, E)];
      int shortest = ((left) <= (up) ? (left) : (up));
      shortest = ((shortest) <= (right) ? (shortest) : (right));

      int index = cols * (startStep + i) + xidx;
      result[hook(8, tx)] = shortest + gpuWall[hook(1, index)];
    }

    barrier(0x01);

    if (i == iteration - 1) {
      break;
    }

    if (computed) {
      prev[hook(7, tx)] = result[hook(8, tx)];
    }
    barrier(0x01);
  }

  if (computed) {
    gpuResults[hook(3, xidx)] = result[hook(8, tx)];
  }
}