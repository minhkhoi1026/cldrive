//{"Cap":8,"Rx":9,"Ry":10,"Rz":11,"border_cols":6,"border_rows":7,"grid_cols":4,"grid_rows":5,"iteration":0,"power":1,"power_on_cuda":16,"power_on_cuda[ty]":15,"step":12,"temp_dst":3,"temp_on_cuda":14,"temp_on_cuda[N]":20,"temp_on_cuda[S]":19,"temp_on_cuda[ty]":13,"temp_src":2,"temp_t":18,"temp_t[ty]":17}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void hotspot(int iteration, global float* power, global float* temp_src, global float* temp_dst, int grid_cols, int grid_rows, int border_cols, int border_rows, float Cap, float Rx, float Ry, float Rz, float step) {
  local float temp_on_cuda[64][64];
  local float power_on_cuda[64][64];
  local float temp_t[64][64];

  float amb_temp = 80.0f;
  float step_div_Cap;
  float Rx_1, Ry_1, Rz_1;

  int bx = get_group_id(0);
  int by = get_group_id(1);

  int tx = get_local_id(0);
  int ty = get_local_id(1);

  step_div_Cap = step / Cap;

  Rx_1 = 1 / Rx;
  Ry_1 = 1 / Ry;
  Rz_1 = 1 / Rz;

  int small_block_rows = 64 - iteration * 2;
  int small_block_cols = 64 - iteration * 2;

  int blkY = small_block_rows * by - border_rows;
  int blkX = small_block_cols * bx - border_cols;
  int blkYmax = blkY + 64 - 1;
  int blkXmax = blkX + 64 - 1;

  int yidx = blkY + ty;
  int xidx = blkX + tx;

  int loadYidx = yidx, loadXidx = xidx;
  int index = grid_cols * loadYidx + loadXidx;

  if (((loadYidx) >= (0) && (loadYidx) <= (grid_rows - 1)) && ((loadXidx) >= (0) && (loadXidx) <= (grid_cols - 1))) {
    temp_on_cuda[hook(14, ty)][hook(13, tx)] = temp_src[hook(2, index)];
    power_on_cuda[hook(16, ty)][hook(15, tx)] = power[hook(1, index)];
  }
  barrier(0x01);

  int validYmin = (blkY < 0) ? -blkY : 0;
  int validYmax = (blkYmax > grid_rows - 1) ? 64 - 1 - (blkYmax - grid_rows + 1) : 64 - 1;
  int validXmin = (blkX < 0) ? -blkX : 0;
  int validXmax = (blkXmax > grid_cols - 1) ? 64 - 1 - (blkXmax - grid_cols + 1) : 64 - 1;

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
    if (((tx) >= (i + 1) && (tx) <= (64 - i - 2)) && ((ty) >= (i + 1) && (ty) <= (64 - i - 2)) && ((tx) >= (validXmin) && (tx) <= (validXmax)) && ((ty) >= (validYmin) && (ty) <= (validYmax))) {
      computed = true;
      temp_t[hook(18, ty)][hook(17, tx)] = temp_on_cuda[hook(14, ty)][hook(13, tx)] + step_div_Cap * (power_on_cuda[hook(16, ty)][hook(15, tx)] + (temp_on_cuda[hook(14, S)][hook(19, tx)] + temp_on_cuda[hook(14, N)][hook(20, tx)] - 2.0f * temp_on_cuda[hook(14, ty)][hook(13, tx)]) * Ry_1 + (temp_on_cuda[hook(14, ty)][hook(13, E)] + temp_on_cuda[hook(14, ty)][hook(13, W)] - 2.0f * temp_on_cuda[hook(14, ty)][hook(13, tx)]) * Rx_1 + (amb_temp - temp_on_cuda[hook(14, ty)][hook(13, tx)]) * Rz_1);
    }
    barrier(0x01);

    if (i == iteration - 1)
      break;
    if (computed)
      temp_on_cuda[hook(14, ty)][hook(13, tx)] = temp_t[hook(18, ty)][hook(17, tx)];

    barrier(0x01);
  }

  if (computed) {
    temp_dst[hook(3, index)] = temp_t[hook(18, ty)][hook(17, tx)];
  }
}