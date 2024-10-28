//{"cb":12,"cc":13,"ce":7,"cn":9,"cs":10,"ct":11,"cw":8,"nx":4,"ny":5,"nz":6,"pIn":0,"sdc":3,"tIn":1,"tOut":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void hotspotOpt1(global float* restrict pIn, global float* restrict tIn, global float* restrict tOut, float sdc, int nx, int ny, int nz, float ce, float cw, float cn, float cs, float ct, float cb, float cc) {
  for (int z = 0; z < nz; z++) {
    for (int y = 0; y < ny; y++) {
      for (int x = 0; x < nx; x++) {
        int c = x + y * nx + z * nx * ny;

        int w = (x == 0) ? c : c - 1;
        int e = (x == nx - 1) ? c : c + 1;
        int n = (y == 0) ? c : c - nx;
        int s = (y == ny - 1) ? c : c + nx;
        int b = (z == 0) ? c : c - nx * ny;
        int t = (z == nz - 1) ? c : c + nx * ny;

        tOut[hook(2, c)] = tIn[hook(1, c)] * cc + tIn[hook(1, n)] * cn + tIn[hook(1, s)] * cs + tIn[hook(1, e)] * ce + tIn[hook(1, w)] * cw + tIn[hook(1, t)] * ct + tIn[hook(1, b)] * cb + sdc * pIn[hook(0, c)] + ct * (80.0f);
      }
    }
  }
}