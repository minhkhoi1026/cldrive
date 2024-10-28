//{"KRT":2,"ck_rinv":13,"cols":5,"ct":12,"rows":6,"scale":11,"tl_u":3,"tl_v":4,"xmap":0,"xmap_offset":9,"xmap_step":7,"ymap":1,"ymap_offset":10,"ymap_step":8}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void buildWarpPlaneMaps(global float* xmap, global float* ymap, constant float* KRT, int tl_u, int tl_v, int cols, int rows, int xmap_step, int ymap_step, int xmap_offset, int ymap_offset, float scale) {
  int du = get_global_id(0);
  int dv = get_global_id(1);

  constant float* ck_rinv = KRT;
  constant float* ct = KRT + 9;

  if (du < cols && dv < rows) {
    int xmap_index = mad24(dv, xmap_step, xmap_offset + du);
    int ymap_index = mad24(dv, ymap_step, ymap_offset + du);

    float u = tl_u + du;
    float v = tl_v + dv;
    float x, y;

    float x_ = u / scale - ct[hook(12, 0)];
    float y_ = v / scale - ct[hook(12, 1)];

    float z;
    x = ck_rinv[hook(13, 0)] * x_ + ck_rinv[hook(13, 1)] * y_ + ck_rinv[hook(13, 2)] * (1 - ct[hook(12, 2)]);
    y = ck_rinv[hook(13, 3)] * x_ + ck_rinv[hook(13, 4)] * y_ + ck_rinv[hook(13, 5)] * (1 - ct[hook(12, 2)]);
    z = ck_rinv[hook(13, 6)] * x_ + ck_rinv[hook(13, 7)] * y_ + ck_rinv[hook(13, 8)] * (1 - ct[hook(12, 2)]);

    x /= z;
    y /= z;

    xmap[hook(0, xmap_index)] = x;
    ymap[hook(1, ymap_index)] = y;
  }
}