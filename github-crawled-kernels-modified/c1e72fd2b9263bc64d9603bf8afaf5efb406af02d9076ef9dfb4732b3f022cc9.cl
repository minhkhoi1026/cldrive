//{"cb":12,"cc":13,"ce":7,"cn":9,"cs":10,"ct":11,"cw":8,"nx":4,"ny":5,"nz":6,"p":0,"sdc":3,"tIn":1,"tOut":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void hotspotOpt1(global float* p, global float* tIn, global float* tOut, float sdc, int nx, int ny, int nz, float ce, float cw, float cn, float cs, float ct, float cb, float cc) {
  float amb_temp = 80.0;

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
  tOut[hook(2, c)] = cc * temp2 + cw * tIn[hook(1, W)] + ce * tIn[hook(1, E)] + cs * tIn[hook(1, S)] + cn * tIn[hook(1, N)] + cb * temp1 + ct * temp3 + sdc * p[hook(0, c)] + ct * amb_temp;
  c += xy;
  W += xy;
  E += xy;
  N += xy;
  S += xy;

  for (int k = 1; k < nz - 1; ++k) {
    temp1 = temp2;
    temp2 = temp3;
    temp3 = tIn[hook(1, c + xy)];
    tOut[hook(2, c)] = cc * temp2 + cw * tIn[hook(1, W)] + ce * tIn[hook(1, E)] + cs * tIn[hook(1, S)] + cn * tIn[hook(1, N)] + cb * temp1 + ct * temp3 + sdc * p[hook(0, c)] + ct * amb_temp;
    c += xy;
    W += xy;
    E += xy;
    N += xy;
    S += xy;
  }
  temp1 = temp2;
  temp2 = temp3;
  tOut[hook(2, c)] = cc * temp2 + cw * tIn[hook(1, W)] + ce * tIn[hook(1, E)] + cs * tIn[hook(1, S)] + cn * tIn[hook(1, N)] + cb * temp1 + ct * temp3 + sdc * p[hook(0, c)] + ct * amb_temp;
  return;
}