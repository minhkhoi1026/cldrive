//{"cols":5,"dx":0,"dx_offset":9,"dx_step":8,"dy":1,"dy_offset":11,"dy_step":10,"high_thresh":7,"low_thresh":6,"mag":2,"mag_offset":13,"mag_step":12,"map":3,"map_offset":15,"map_step":14,"rows":4,"smem":17,"smem[lidy + 1]":19,"smem[lidy + 2]":21,"smem[lidy]":20,"smem[ly + 14]":18,"smem[ly]":16}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline float calc(int x, int y) {
  return (float)abs(x) + abs(y);
}
kernel void __attribute__((reqd_work_group_size(16, 16, 1))) calcMap(global const int* dx, global const int* dy, global const float* mag, global int* map, int rows, int cols, float low_thresh, float high_thresh, int dx_step, int dx_offset, int dy_step, int dy_offset, int mag_step, int mag_offset, int map_step, int map_offset) {
  dx_step /= sizeof(*dx);
  dx_offset /= sizeof(*dx);
  dy_step /= sizeof(*dy);
  dy_offset /= sizeof(*dy);
  mag_step /= sizeof(*mag);
  mag_offset /= sizeof(*mag);
  map_step /= sizeof(*map);
  map_offset /= sizeof(*map);

  mag += mag_offset;
  map += map_offset;

  local float smem[18][18];

  int gidx = get_global_id(0);
  int gidy = get_global_id(1);

  int lidx = get_local_id(0);
  int lidy = get_local_id(1);

  int grp_idx = get_global_id(0) & 0xFFFFF0;
  int grp_idy = get_global_id(1) & 0xFFFFF0;

  int tid = lidx + lidy * 16;
  int lx = tid % 18;
  int ly = tid / 18;
  if (ly < 14) {
    smem[hook(17, ly)][hook(16, lx)] = mag[hook(2, grp_idx + lx + min(grp_idy + ly, rows - 1) * mag_step)];
  }
  if (ly < 4 && grp_idy + ly + 14 <= rows && grp_idx + lx <= cols) {
    smem[hook(17, ly + 14)][hook(18, lx)] = mag[hook(2, grp_idx + lx + min(grp_idy + ly + 14, rows - 1) * mag_step)];
  }

  barrier(0x01);

  if (gidy < rows && gidx < cols) {
    int x = dx[hook(0, gidx + gidy * dx_step)];
    int y = dy[hook(1, gidx + gidy * dy_step)];
    const int s = (x ^ y) < 0 ? -1 : 1;
    const float m = smem[hook(17, lidy + 1)][hook(19, lidx + 1)];
    x = abs(x);
    y = abs(y);

    int edge_type = 0;
    if (m > low_thresh) {
      const int tg22x = x * (int)(0.4142135623730950488016887242097f * (1 << 15) + 0.5f);
      const int tg67x = tg22x + (x << (1 + 15));
      y <<= 15;
      if (y < tg22x) {
        if (m > smem[hook(17, lidy + 1)][hook(19, lidx)] && m >= smem[hook(17, lidy + 1)][hook(19, lidx + 2)]) {
          edge_type = 1 + (int)(m > high_thresh);
        }
      } else if (y > tg67x) {
        if (m > smem[hook(17, lidy)][hook(20, lidx + 1)] && m >= smem[hook(17, lidy + 2)][hook(21, lidx + 1)]) {
          edge_type = 1 + (int)(m > high_thresh);
        }
      } else {
        if (m > smem[hook(17, lidy)][hook(20, lidx + 1 - s)] && m > smem[hook(17, lidy + 2)][hook(21, lidx + 1 + s)]) {
          edge_type = 1 + (int)(m > high_thresh);
        }
      }
    }
    map[hook(3, gidx + 1 + (gidy + 1) * map_step)] = edge_type;
  }
}