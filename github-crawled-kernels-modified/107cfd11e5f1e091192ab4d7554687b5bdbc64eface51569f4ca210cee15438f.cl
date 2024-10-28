//{"Rx_1":9,"Ry_1":10,"Rz_1":11,"border_cols":6,"border_rows":7,"grid_cols":4,"grid_rows":5,"iteration":0,"power":1,"power_on_cuda":17,"power_on_cuda[ty]":16,"small_block_cols":13,"small_block_rows":12,"step_div_Cap":8,"temp_dst":3,"temp_on_cuda":15,"temp_on_cuda[N]":21,"temp_on_cuda[S]":20,"temp_on_cuda[ty]":14,"temp_src":2,"temp_t":19,"temp_t[ty]":18}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
__attribute__((reqd_work_group_size(512, 512, 1))) __attribute__((num_simd_work_items(SSIZE))) kernel void hotspot(int iteration, global float* restrict power, global float* restrict temp_src, global float* restrict temp_dst, int grid_cols, int grid_rows, int border_cols, int border_rows, float step_div_Cap, float Rx_1, float Ry_1, float Rz_1, int small_block_rows, int small_block_cols) {
  local float temp_on_cuda[512][512];
  local float power_on_cuda[512][512];
  local float temp_t[512][512];

  int bx = get_group_id(0);
  int by = get_group_id(1);

  int tx = get_local_id(0);
  int ty = get_local_id(1);

  int blkY = small_block_rows * by - border_rows;
  int blkX = small_block_cols * bx - border_cols;
  int blkYmax = blkY + 512 - 1;
  int blkXmax = blkX + 512 - 1;

  int yidx = blkY + ty;
  int xidx = blkX + tx;

  int loadYidx = yidx, loadXidx = xidx;
  int index = grid_cols * loadYidx + loadXidx;

  if (((loadYidx) >= (0) && (loadYidx) <= (grid_rows - 1)) && ((loadXidx) >= (0) && (loadXidx) <= (grid_cols - 1))) {
    temp_on_cuda[hook(15, ty)][hook(14, tx)] = temp_src[hook(2, index)];
    power_on_cuda[hook(17, ty)][hook(16, tx)] = power[hook(1, index)];
  }
  barrier(0x01);

  int validYmin = (blkY < 0) ? -blkY : 0;
  int validYmax = (blkYmax > grid_rows - 1) ? 512 - 1 - (blkYmax - grid_rows + 1) : 512 - 1;
  int validXmin = (blkX < 0) ? -blkX : 0;
  int validXmax = (blkXmax > grid_cols - 1) ? 512 - 1 - (blkXmax - grid_cols + 1) : 512 - 1;

  int N = ty - 1;
  int S = ty + 1;
  int W = tx - 1;
  int E = tx + 1;

  N = (N < validYmin) ? validYmin : N;
  S = (S > validYmax) ? validYmax : S;
  W = (W < validXmin) ? validXmin : W;
  E = (E > validXmax) ? validXmax : E;

  bool computed;
  for (int i = 0; i < iteration; i++) {
    computed = false;
    if (((tx) >= (i + 1) && (tx) <= (512 - i - 2)) && ((ty) >= (i + 1) && (ty) <= (512 - i - 2)) && ((tx) >= (validXmin) && (tx) <= (validXmax)) && ((ty) >= (validYmin) && (ty) <= (validYmax))) {
      computed = true;
      temp_t[hook(19, ty)][hook(18, tx)] = temp_on_cuda[hook(15, ty)][hook(14, tx)] + step_div_Cap * (power_on_cuda[hook(17, ty)][hook(16, tx)] + (temp_on_cuda[hook(15, S)][hook(20, tx)] + temp_on_cuda[hook(15, N)][hook(21, tx)] - 2.0f * temp_on_cuda[hook(15, ty)][hook(14, tx)]) * Ry_1 + (temp_on_cuda[hook(15, ty)][hook(14, E)] + temp_on_cuda[hook(15, ty)][hook(14, W)] - 2.0f * temp_on_cuda[hook(15, ty)][hook(14, tx)]) * Rx_1 + ((80.0f) - temp_on_cuda[hook(15, ty)][hook(14, tx)]) * Rz_1);
    }
    barrier(0x01);

    if (i == iteration - 1)
      break;
    if (computed)
      temp_on_cuda[hook(15, ty)][hook(14, tx)] = temp_t[hook(19, ty)][hook(18, tx)];

    barrier(0x01);
  }

  if (computed) {
    temp_dst[hook(3, index)] = temp_t[hook(19, ty)][hook(18, tx)];
  }
}