//{"cols":4,"dx_buf":1,"dx_buf_offset":8,"dx_buf_step":7,"dy_buf":2,"dy_buf_offset":10,"dy_buf_step":9,"rows":3,"smem":12,"smem[lidy]":11,"src":0,"src_offset":6,"src_step":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline float calc(int x, int y) {
  return (float)abs(x) + abs(y);
}
kernel void __attribute__((reqd_work_group_size(16, 16, 1))) calcSobelRowPass(global const uchar* src, global int* dx_buf, global int* dy_buf, int rows, int cols, int src_step, int src_offset, int dx_buf_step, int dx_buf_offset, int dy_buf_step, int dy_buf_offset) {
  dx_buf_step /= sizeof(*dx_buf);
  dx_buf_offset /= sizeof(*dx_buf);
  dy_buf_step /= sizeof(*dy_buf);
  dy_buf_offset /= sizeof(*dy_buf);

  int gidx = get_global_id(0);
  int gidy = get_global_id(1);

  int lidx = get_local_id(0);
  int lidy = get_local_id(1);

  local int smem[16][18];

  smem[hook(12, lidy)][hook(11, lidx + 1)] = src[hook(0, gidx + min(gidy, rows - 1) * src_step + src_offset)];
  if (lidx == 0) {
    smem[hook(12, lidy)][hook(11, 0)] = src[hook(0, max(gidx - 1, 0) + min(gidy, rows - 1) * src_step + src_offset)];
    smem[hook(12, lidy)][hook(11, 17)] = src[hook(0, min(gidx + 16, cols - 1) + min(gidy, rows - 1) * src_step + src_offset)];
  }
  barrier(0x01);

  if (gidy < rows && gidx < cols) {
    dx_buf[hook(1, gidx + gidy * dx_buf_step + dx_buf_offset)] = -smem[hook(12, lidy)][hook(11, lidx)] + smem[hook(12, lidy)][hook(11, lidx + 2)];
    dy_buf[hook(2, gidx + gidy * dy_buf_step + dy_buf_offset)] = smem[hook(12, lidy)][hook(11, lidx)] + 2 * smem[hook(12, lidy)][hook(11, lidx + 1)] + smem[hook(12, lidy)][hook(11, lidx + 2)];
  }
}