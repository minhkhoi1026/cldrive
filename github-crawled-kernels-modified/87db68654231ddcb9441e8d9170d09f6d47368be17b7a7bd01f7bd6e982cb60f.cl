//{"ck_rinv":8,"cols":7,"rows":6,"rowsPerWI":12,"scale":11,"tl_u":9,"tl_v":10,"xmap":13,"xmap_offset":2,"xmap_step":1,"xmapptr":0,"ymap":14,"ymap_offset":5,"ymap_step":4,"ymapptr":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void buildWarpCylindricalMaps(global uchar* xmapptr, int xmap_step, int xmap_offset, global uchar* ymapptr, int ymap_step, int ymap_offset, int rows, int cols, constant float* ck_rinv, int tl_u, int tl_v, float scale, int rowsPerWI) {
  int du = get_global_id(0);
  int dv0 = get_global_id(1) * rowsPerWI;

  if (du < cols) {
    int xmap_index = mad24(dv0, xmap_step, mad24(du, (int)sizeof(float), xmap_offset));
    int ymap_index = mad24(dv0, ymap_step, mad24(du, (int)sizeof(float), ymap_offset));

    float u = (tl_u + du) * scale;
    float x_, z_;
    x_ = sincos(u, &z_);

    for (int dv = dv0, dv1 = min(rows, dv0 + rowsPerWI); dv < dv1; ++dv, xmap_index += xmap_step, ymap_index += ymap_step) {
      global float* xmap = (global float*)(xmapptr + xmap_index);
      global float* ymap = (global float*)(ymapptr + ymap_index);

      float y_ = (tl_v + dv) * scale;

      float x, y, z;
      x = fma(ck_rinv[hook(8, 0)], x_, fma(ck_rinv[hook(8, 1)], y_, ck_rinv[hook(8, 2)] * z_));
      y = fma(ck_rinv[hook(8, 3)], x_, fma(ck_rinv[hook(8, 4)], y_, ck_rinv[hook(8, 5)] * z_));
      z = fma(ck_rinv[hook(8, 6)], x_, fma(ck_rinv[hook(8, 7)], y_, ck_rinv[hook(8, 8)] * z_));

      if (z > 0)
        x /= z, y /= z;
      else
        x = y = -1;

      xmap[hook(13, 0)] = x;
      ymap[hook(14, 0)] = y;
    }
  }
}