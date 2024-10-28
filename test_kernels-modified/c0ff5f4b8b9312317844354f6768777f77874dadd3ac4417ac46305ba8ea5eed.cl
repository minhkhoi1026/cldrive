//{"cb":12,"cc":13,"ce":7,"cn":9,"cs":10,"ct":11,"cw":8,"nx":4,"ny":5,"nz":6,"pIn":0,"sdc":3,"tIn":1,"tOut":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
__attribute__((max_global_work_dim(0))) kernel void hotspotOpt1(global float* restrict pIn, global float* restrict tIn, global float* restrict tOut, float sdc, int nx, int ny, int nz, float ce, float cw, float cn, float cs, float ct, float cb, float cc) {
  for (int z = 0; z < nz; z++) {
    for (int y = 0; y < ny; y++) {
      for (int x = 0; x < nx; x++) {
        int index = x + y * nx + z * nx * ny;
        float c = tIn[hook(1, index)];

        float w = (x == 0) ? c : tIn[hook(1, index - 1)];
        float e = (x == nx - 1) ? c : tIn[hook(1, index + 1)];
        float n = (y == 0) ? c : tIn[hook(1, index - nx)];
        float s = (y == ny - 1) ? c : tIn[hook(1, index + nx)];
        float b = (z == 0) ? c : tIn[hook(1, index - nx * ny)];
        float t = (z == nz - 1) ? c : tIn[hook(1, index + nx * ny)];

        tOut[hook(2, index)] = c * cc + n * cn + s * cs + e * ce + w * cw + t * ct + b * cb + sdc * pIn[hook(0, index)] + ct * (80.0f);
      }
    }
  }
}