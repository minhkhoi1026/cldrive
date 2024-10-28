//{"ck_rinv":2,"cols":5,"rows":6,"scale":11,"tl_u":3,"tl_v":4,"xmap":0,"xmap_offset":9,"xmap_step":7,"ymap":1,"ymap_offset":10,"ymap_step":8}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void buildWarpCylindricalMaps(global float* xmap, global float* ymap, constant float* ck_rinv, int tl_u, int tl_v, int cols, int rows, int xmap_step, int ymap_step, int xmap_offset, int ymap_offset, float scale) {
  int du = get_global_id(0);
  int dv = get_global_id(1);

  if (du < cols && dv < rows) {
    int xmap_index = mad24(dv, xmap_step, xmap_offset + du);
    int ymap_index = mad24(dv, ymap_step, ymap_offset + du);

    float u = tl_u + du;
    float v = tl_v + dv;
    float x, y;

    u /= scale;
    float x_ = sin(u);
    float y_ = v / scale;
    float z_ = cos(u);

    float z;
    x = ck_rinv[hook(2, 0)] * x_ + ck_rinv[hook(2, 1)] * y_ + ck_rinv[hook(2, 2)] * z_;
    y = ck_rinv[hook(2, 3)] * x_ + ck_rinv[hook(2, 4)] * y_ + ck_rinv[hook(2, 5)] * z_;
    z = ck_rinv[hook(2, 6)] * x_ + ck_rinv[hook(2, 7)] * y_ + ck_rinv[hook(2, 8)] * z_;

    if (z > 0) {
      x /= z;
      y /= z;
    } else
      x = y = -1;

    xmap[hook(0, xmap_index)] = x;
    ymap[hook(1, ymap_index)] = y;
  }
}