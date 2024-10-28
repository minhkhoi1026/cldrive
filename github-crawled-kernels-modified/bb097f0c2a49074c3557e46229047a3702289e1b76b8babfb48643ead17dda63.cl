//{"cb":12,"cc":13,"ce":7,"cn":9,"cs":10,"ct":11,"cw":8,"nx":4,"ny":5,"nz":6,"p":0,"sdc":3,"tIn":1,"tOut":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
__attribute__((num_simd_work_items(4))) __attribute__((reqd_work_group_size((64), (4), 1))) kernel void hotspotOpt1(global float* restrict p, global float* restrict tIn, global float* restrict tOut, float sdc, int nx, int ny, int nz, float ce, float cw, float cn, float cs, float ct, float cb, float cc) {
  int i = get_global_id(0);
  int j = get_global_id(1);
  int c = i + j * nx;
  int xy = nx * ny;

  int W = (i == 0) ? c : c - 1;
  int E = (i == nx - 1) ? c : c + 1;
  int N = (j == 0) ? c : c - nx;
  int S = (j == ny - 1) ? c : c + nx;

  float temp1, temp2, temp3;
  temp1 = temp2 = tIn[hook(1, c)];
  temp3 = tIn[hook(1, c + xy)];
  tOut[hook(2, c)] = cc * temp2 + cn * tIn[hook(1, N)] + cs * tIn[hook(1, S)] + ce * tIn[hook(1, E)] + cw * tIn[hook(1, W)] + ct * temp3 + cb * temp1 + sdc * p[hook(0, c)] + ct * (80.0f);
  c += xy;
  W += xy;
  E += xy;
  N += xy;
  S += xy;

  for (int k = 1; k < nz - 1; ++k) {
    temp1 = temp2;
    temp2 = temp3;
    temp3 = tIn[hook(1, c + xy)];
    tOut[hook(2, c)] = cc * temp2 + cn * tIn[hook(1, N)] + cs * tIn[hook(1, S)] + ce * tIn[hook(1, E)] + cw * tIn[hook(1, W)] + ct * temp3 + cb * temp1 + sdc * p[hook(0, c)] + ct * (80.0f);
    c += xy;
    W += xy;
    E += xy;
    N += xy;
    S += xy;
  }
  temp1 = temp2;
  temp2 = temp3;
  tOut[hook(2, c)] = cc * temp2 + cn * tIn[hook(1, N)] + cs * tIn[hook(1, S)] + ce * tIn[hook(1, E)] + cw * tIn[hook(1, W)] + ct * temp3 + cb * temp1 + sdc * p[hook(0, c)] + ct * (80.0f);
  return;
}