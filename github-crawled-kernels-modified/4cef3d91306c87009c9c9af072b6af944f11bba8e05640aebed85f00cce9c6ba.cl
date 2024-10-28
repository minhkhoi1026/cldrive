//{"cols":6,"dx":2,"dx_buf":0,"dx_buf_offset":8,"dx_buf_step":7,"dx_offset":12,"dx_step":11,"dy":3,"dy_buf":1,"dy_buf_offset":10,"dy_buf_step":9,"dy_offset":14,"dy_step":13,"mag":4,"mag_offset":16,"mag_step":15,"rows":5,"sdx":18,"sdx[0]":21,"sdx[17]":22,"sdx[lidy + 1]":17,"sdx[lidy + 2]":26,"sdx[lidy]":25,"sdy":20,"sdy[0]":23,"sdy[17]":24,"sdy[lidy + 1]":19,"sdy[lidy + 2]":28,"sdy[lidy]":27}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline float calc(int x, int y) {
  return (float)abs(x) + abs(y);
}
kernel void __attribute__((reqd_work_group_size(16, 16, 1))) calcMagnitude_buf(global const int* dx_buf, global const int* dy_buf, global int* dx, global int* dy, global float* mag, int rows, int cols, int dx_buf_step, int dx_buf_offset, int dy_buf_step, int dy_buf_offset, int dx_step, int dx_offset, int dy_step, int dy_offset, int mag_step, int mag_offset) {
  dx_buf_step /= sizeof(*dx_buf);
  dx_buf_offset /= sizeof(*dx_buf);
  dy_buf_step /= sizeof(*dy_buf);
  dy_buf_offset /= sizeof(*dy_buf);
  dx_step /= sizeof(*dx);
  dx_offset /= sizeof(*dx);
  dy_step /= sizeof(*dy);
  dy_offset /= sizeof(*dy);
  mag_step /= sizeof(*mag);
  mag_offset /= sizeof(*mag);

  int gidx = get_global_id(0);
  int gidy = get_global_id(1);

  int lidx = get_local_id(0);
  int lidy = get_local_id(1);

  local int sdx[18][16];
  local int sdy[18][16];

  sdx[hook(18, lidy + 1)][hook(17, lidx)] = dx_buf[hook(0, gidx + min(gidy, rows - 1) * dx_buf_step + dx_buf_offset)];
  sdy[hook(20, lidy + 1)][hook(19, lidx)] = dy_buf[hook(1, gidx + min(gidy, rows - 1) * dy_buf_step + dy_buf_offset)];
  if (lidy == 0) {
    sdx[hook(18, 0)][hook(21, lidx)] = dx_buf[hook(0, gidx + min(max(gidy - 1, 0), rows - 1) * dx_buf_step + dx_buf_offset)];
    sdx[hook(18, 17)][hook(22, lidx)] = dx_buf[hook(0, gidx + min(gidy + 16, rows - 1) * dx_buf_step + dx_buf_offset)];

    sdy[hook(20, 0)][hook(23, lidx)] = dy_buf[hook(1, gidx + min(max(gidy - 1, 0), rows - 1) * dy_buf_step + dy_buf_offset)];
    sdy[hook(20, 17)][hook(24, lidx)] = dy_buf[hook(1, gidx + min(gidy + 16, rows - 1) * dy_buf_step + dy_buf_offset)];
  }
  barrier(0x01);

  if (gidx < cols && gidy < rows) {
    int x = sdx[hook(18, lidy)][hook(25, lidx)] + 2 * sdx[hook(18, lidy + 1)][hook(17, lidx)] + sdx[hook(18, lidy + 2)][hook(26, lidx)];
    int y = -sdy[hook(20, lidy)][hook(27, lidx)] + sdy[hook(20, lidy + 2)][hook(28, lidx)];

    dx[hook(2, gidx + gidy * dx_step + dx_offset)] = x;
    dy[hook(3, gidx + gidy * dy_step + dy_offset)] = y;

    mag[hook(4, (gidx + 1) + (gidy + 1) * mag_step + mag_offset)] = calc(x, y);
  }
}