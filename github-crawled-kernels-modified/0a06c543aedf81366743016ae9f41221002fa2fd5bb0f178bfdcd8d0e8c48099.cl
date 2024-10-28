//{"grid":0,"odd":5,"rh":4,"rl":3,"sh":2,"sl":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void evolve(global int* grid, int sl, int sh, int rl, int rh, int odd) {
  int row, row_global, rows_per_strip, row_strips;
  int col, col_left, col_strip_offset, col_my_strip;
  int lsb_old, lsb_new, row_leftbits, row_old, row_new;
  int above, level, below, next_value;

  row = get_local_id(0);
  rows_per_strip = get_local_size(0);
  row_strips = get_num_groups(0);
  col_my_strip = get_group_id(1);
  col_strip_offset = col_my_strip * row_strips * rows_per_strip;
  row_global = get_global_id(0);
  row_leftbits = (col_strip_offset + row_global) << 1;

  lsb_new = (lsb_old = odd & 1) ? 0 : 1;
  row_old = row_leftbits | lsb_old;
  above = (row == 0) ? 0 : grid[hook(0, row_old - 2)];
  level = grid[hook(0, row_old)];
  below = (row == rows_per_strip - 1) ? 0 : grid[hook(0, row_old + 2)];
  row_new = row_leftbits | lsb_new;

  next_value = 0;
  for (col = 1; col <= 30; col++) {
    int mask, mask_left, mask_right, alive_status;

    mask = 1 << col;
    mask_left = mask << 1;
    mask_right = mask >> 1;
    alive_status = (mask & level) ? (((mask_left & above) ? 1 : 0) + ((mask & above) ? 1 : 0) + ((mask_right & above) ? 1 : 0) + ((mask_left & level) ? 1 : 0) + ((mask_right & level) ? 1 : 0) + ((mask_left & below) ? 1 : 0) + ((mask & below) ? 1 : 0) + ((mask_right & below) ? 1 : 0)) >= (sl) && (((mask_left & above) ? 1 : 0) + ((mask & above) ? 1 : 0) + ((mask_right & above) ? 1 : 0) + ((mask_left & level) ? 1 : 0) + ((mask_right & level) ? 1 : 0) + ((mask_left & below) ? 1 : 0) + ((mask & below) ? 1 : 0) + ((mask_right & below) ? 1 : 0)) <= (sh) : (((mask_left & above) ? 1 : 0) + ((mask & above) ? 1 : 0) + ((mask_right & above) ? 1 : 0) + ((mask_left & level) ? 1 : 0) + ((mask_right & level) ? 1 : 0) + ((mask_left & below) ? 1 : 0) + ((mask & below) ? 1 : 0) + ((mask_right & below) ? 1 : 0)) >= (rl) && (((mask_left & above) ? 1 : 0) + ((mask & above) ? 1 : 0) + ((mask_right & above) ? 1 : 0) + ((mask_left & level) ? 1 : 0) + ((mask_right & level) ? 1 : 0) + ((mask_left & below) ? 1 : 0) + ((mask & below) ? 1 : 0) + ((mask_right & below) ? 1 : 0)) <= (rh);
    next_value &= ~mask;
    next_value |= alive_status ? mask : 0;
  }

  grid[hook(0, row_new)] = next_value;
}