//{"Cap":8,"Rx":9,"Rx_1":14,"Ry":10,"Ry_1":15,"Rz":11,"Rz_1":16,"border_cols":6,"border_rows":7,"grid_cols":4,"grid_rows":5,"iteration":0,"power":1,"power_on_cuda":20,"power_on_cuda[ty]":19,"step":12,"step_div_Cap":13,"temp_dst":3,"temp_on_cuda":18,"temp_on_cuda[N]":24,"temp_on_cuda[S]":23,"temp_on_cuda[ty]":17,"temp_src":2,"temp_t":22,"temp_t[ty]":21}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void hotspot(int iteration, global double* power, global double* temp_src, global double* temp_dst, int grid_cols, int grid_rows, int border_cols, int border_rows, double Cap, double Rx, double Ry, double Rz, double step, double step_div_Cap, double Rx_1, double Ry_1, double Rz_1) {
  local double temp_on_cuda[16][16];
  local double power_on_cuda[16][16];
  local double temp_t[16][16];

  double amb_temp = 80.0f;

  int bx = get_group_id(0);
  int by = get_group_id(1);

  int tx = get_local_id(0);
  int ty = get_local_id(1);
  int small_block_rows = 16 - iteration * 2;
  int small_block_cols = 16 - iteration * 2;

  int blkY = small_block_rows * by - border_rows;
  int blkX = small_block_cols * bx - border_cols;
  int blkYmax = blkY + 16 - 1;
  int blkXmax = blkX + 16 - 1;

  int yidx = blkY + ty;
  int xidx = blkX + tx;

  int loadYidx = yidx, loadXidx = xidx;
  int index = grid_cols * loadYidx + loadXidx;

  if (((loadYidx) >= (0) && (loadYidx) <= (grid_rows - 1)) && ((loadXidx) >= (0) && (loadXidx) <= (grid_cols - 1))) {
    temp_on_cuda[hook(18, ty)][hook(17, tx)] = temp_src[hook(2, index)];
    power_on_cuda[hook(20, ty)][hook(19, tx)] = power[hook(1, index)];
  }
  barrier(0x01);

  int validYmin = (blkY < 0) ? -blkY : 0;
  int validYmax = (blkYmax > grid_rows - 1) ? 16 - 1 - (blkYmax - grid_rows + 1) : 16 - 1;
  int validXmin = (blkX < 0) ? -blkX : 0;
  int validXmax = (blkXmax > grid_cols - 1) ? 16 - 1 - (blkXmax - grid_cols + 1) : 16 - 1;

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
    if (((tx) >= (i + 1) && (tx) <= (16 - i - 2)) && ((ty) >= (i + 1) && (ty) <= (16 - i - 2)) && ((tx) >= (validXmin) && (tx) <= (validXmax)) && ((ty) >= (validYmin) && (ty) <= (validYmax))) {
      computed = true;
      temp_t[hook(22, ty)][hook(21, tx)] = temp_on_cuda[hook(18, ty)][hook(17, tx)] + step_div_Cap * (power_on_cuda[hook(20, ty)][hook(19, tx)] + (temp_on_cuda[hook(18, S)][hook(23, tx)] + temp_on_cuda[hook(18, N)][hook(24, tx)] - 2.0f * temp_on_cuda[hook(18, ty)][hook(17, tx)]) * Ry_1 + (temp_on_cuda[hook(18, ty)][hook(17, E)] + temp_on_cuda[hook(18, ty)][hook(17, W)] - 2.0f * temp_on_cuda[hook(18, ty)][hook(17, tx)]) * Rx_1 + (amb_temp - temp_on_cuda[hook(18, ty)][hook(17, tx)]) * Rz_1);
    }
    barrier(0x01);

    if (i == iteration - 1)
      break;
    if (computed)
      temp_on_cuda[hook(18, ty)][hook(17, tx)] = temp_t[hook(22, ty)][hook(21, tx)];

    barrier(0x01);
  }

  if (computed) {
    temp_dst[hook(3, index)] = temp_t[hook(22, ty)][hook(21, tx)];
  }
}