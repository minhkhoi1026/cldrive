//{"col":2,"num_rows":0,"rowOffset":1,"val":3,"vals":4,"x":5,"y":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void PageRankUpdateGpu(unsigned int num_rows, global unsigned int* rowOffset, global unsigned int* col, global float* val, local float* vals, global float* x, global float* y) {
  int thread_id = get_global_id(0);
  int local_id = get_local_id(0);
  int warp_id = thread_id / 64;
  int lane = thread_id & (64 - 1);
  int row = warp_id;

  if (row < num_rows) {
    y[hook(6, row)] = 0.0;
    int row_A_start = rowOffset[hook(1, row)];
    int row_A_end = rowOffset[hook(1, row + 1)];

    vals[hook(4, local_id)] = 0;
    for (int jj = row_A_start + lane; jj < row_A_end; jj += 64)
      vals[hook(4, local_id)] += val[hook(3, jj)] * x[hook(5, col[jhook(2, jj))];

    if (lane < 32)
      vals[hook(4, local_id)] += vals[hook(4, local_id + 32)];
    if (lane < 16)
      vals[hook(4, local_id)] += vals[hook(4, local_id + 16)];
    if (lane < 8)
      vals[hook(4, local_id)] += vals[hook(4, local_id + 8)];
    if (lane < 4)
      vals[hook(4, local_id)] += vals[hook(4, local_id + 4)];
    if (lane < 2)
      vals[hook(4, local_id)] += vals[hook(4, local_id + 2)];
    if (lane < 1)
      vals[hook(4, local_id)] += vals[hook(4, local_id + 1)];
    if (lane == 0)
      y[hook(6, row)] += vals[hook(4, local_id)];
  }
}