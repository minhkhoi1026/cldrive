//{"blurz_a":4,"blurz_b":3,"blurz_g":2,"blurz_r":1,"data":9,"data[ky + 1]":8,"data[ly + 1]":11,"data[ly + 2]":12,"data[ly]":10,"depth":7,"grid":0,"sh":6,"sw":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
__attribute__((reqd_work_group_size(8, 8, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) kernel void bilateral_blur(global const float8* grid, global float2* blurz_r, global float2* blurz_g, global float2* blurz_b, global float2* blurz_a, int sw, int sh, int depth) {
  const int gid_x = get_global_id(0);
  const int gid_y = get_global_id(1);

  const int lx = get_local_id(0);
  const int ly = get_local_id(1);

  float8 vpp = (float8)(0.0f);
  float8 vp = (float8)(0.0f);
  float8 v = (float8)(0.0f);

  local float8 data[16 + 2][16 + 2];

  for (int d = 0; d < depth; d++) {
    for (int ky = get_local_id(1) - 1; ky < 16 + 1; ky += get_local_size(1))
      for (int kx = get_local_id(0) - 1; kx < 16 + 1; kx += get_local_size(0)) {
        int xx = clamp((int)get_group_id(0) * 16 + kx, 0, sw - 1);
        int yy = clamp((int)get_group_id(1) * 16 + ky, 0, sh - 1);

        data[hook(9, ky + 1)][hook(8, kx + 1)] = grid[hook(0, xx + sw * (yy + d * sh))];
      }

    barrier(0x01);

    data[hook(9, ly)][hook(10, lx + 1)] = (data[hook(9, ly)][hook(10, lx)] + 2.0f * data[hook(9, ly)][hook(10, lx + 1)] + data[hook(9, ly)][hook(10, lx + 2)]) / 4.0f;
    data[hook(9, ly + 1)][hook(11, lx + 1)] = (data[hook(9, ly + 1)][hook(11, lx)] + 2.0f * data[hook(9, ly + 1)][hook(11, lx + 1)] + data[hook(9, ly + 1)][hook(11, lx + 2)]) / 4.0f;
    data[hook(9, ly + 2)][hook(12, lx + 1)] = (data[hook(9, ly + 2)][hook(12, lx)] + 2.0f * data[hook(9, ly + 2)][hook(12, lx + 1)] + data[hook(9, ly + 2)][hook(12, lx + 2)]) / 4.0f;

    barrier(0x01);

    if (d == 0) {
      v = (data[hook(9, ly)][hook(10, lx + 1)] + 2.0f * data[hook(9, ly + 1)][hook(11, lx + 1)] + data[hook(9, ly + 2)][hook(12, lx + 1)]) / 4.0f;
      vpp = v;
      vp = v;
    } else {
      vpp = vp;
      vp = v;

      v = (data[hook(9, ly)][hook(10, lx + 1)] + 2.0f * data[hook(9, ly + 1)][hook(11, lx + 1)] + data[hook(9, ly + 2)][hook(12, lx + 1)]) / 4.0f;

      float8 blurred = (vpp + 2.0f * vp + v) / 4.0f;

      if (gid_x < sw && gid_y < sh) {
        blurz_r[hook(1, gid_x + sw * (gid_y + sh * (d - 1)))] = blurred.s01;
        blurz_g[hook(2, gid_x + sw * (gid_y + sh * (d - 1)))] = blurred.s23;
        blurz_b[hook(3, gid_x + sw * (gid_y + sh * (d - 1)))] = blurred.s45;
        blurz_a[hook(4, gid_x + sw * (gid_y + sh * (d - 1)))] = blurred.s67;
      }
    }
  }

  vpp = vp;
  vp = v;

  float8 blurred = (vpp + 2.0f * vp + v) / 4.0f;

  if (gid_x < sw && gid_y < sh) {
    blurz_r[hook(1, gid_x + sw * (gid_y + sh * (depth - 1)))] = blurred.s01;
    blurz_g[hook(2, gid_x + sw * (gid_y + sh * (depth - 1)))] = blurred.s23;
    blurz_b[hook(3, gid_x + sw * (gid_y + sh * (depth - 1)))] = blurred.s45;
    blurz_a[hook(4, gid_x + sw * (gid_y + sh * (depth - 1)))] = blurred.s67;
  }
}