//{"border":6,"cols":4,"gpuResults":3,"gpuSrc":2,"gpuWall":1,"iteration":0,"prev":7,"startStep":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
__attribute__((reqd_work_group_size(256, 1, 1))) __attribute__((num_simd_work_items(16))) __attribute__((num_compute_units(1))) kernel void dynproc_kernel(int iteration, global int* restrict gpuWall, global int* restrict gpuSrc, global int* restrict gpuResults, int cols, int startStep, int border) {
  int bx = get_group_id(0);
  int tx = get_local_id(0);

  local int __attribute__((memory, numbanks(1), bankwidth(4 * 16), doublepump)) prev[256];
  int result_out, result_in;

  int small_block_cols = 256 - (iteration * 1 * 2);

  int blkX = (small_block_cols * bx) - border;
  int blkXmax = blkX + 256 - 1;

  int xidx = blkX + tx;

  int validXmin = (blkX < 0) ? -blkX : 0;
  int validXmax = (blkXmax > cols - 1) ? 256 - 1 - (blkXmax - cols + 1) : 256 - 1;

  if (((xidx) >= (0) && (xidx) <= (cols - 1))) {
    result_in = gpuSrc[hook(2, xidx)];
  }

  barrier(0x01);

  bool computed;
  for (int i = 0; i < iteration; i++) {
    float result;
    if (i == 0) {
      result = result_in;
    } else if (computed) {
      result = result_out;
    }
    prev[hook(7, tx)] = result;
    barrier(0x01);

    computed = false;
    int center = prev[hook(7, tx)];
    int left_temp = prev[hook(7, tx - 1)];
    int right_temp = prev[hook(7, tx + 1)];
    barrier(0x01);

    int left = (tx - 1 < validXmin) ? center : left_temp;
    int right = (tx + 1 > validXmax) ? center : right_temp;

    if (((tx) >= (i + 1) && (tx) <= (256 - i - 2)) && ((tx) >= (validXmin) && (tx) <= (validXmax))) {
      computed = true;
      int index = cols * (startStep + i) + xidx;
      int shortest = ((left) <= (center) ? (left) : (center));
      result_out = ((shortest) <= (right) ? (shortest) : (right)) + gpuWall[hook(1, index)];
    }

    if (i == iteration - 1) {
      break;
    }
  }

  if (computed) {
    gpuResults[hook(3, xidx)] = result_out;
  }
}