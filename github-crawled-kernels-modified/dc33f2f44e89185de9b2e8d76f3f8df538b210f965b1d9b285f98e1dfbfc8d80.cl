//{"g_qs":3,"g_rho_i":4,"g_rhs":6,"g_speed":5,"g_us":0,"g_vs":1,"g_ws":2,"nx2":7,"ny2":8,"nz2":9,"qs":31,"qs[k]":30,"qs[k][j]":29,"rho_i":12,"rho_i[k]":11,"rho_i[k][j]":10,"rhs":28,"rhs[k]":27,"rhs[k][j]":26,"rhs[k][j][i]":25,"speed":24,"speed[k]":23,"speed[k][j]":22,"us":15,"us[k]":14,"us[k][j]":13,"vs":18,"vs[k]":17,"vs[k][j]":16,"ws":21,"ws[k]":20,"ws[k][j]":19}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void txinvr(global const double* g_us, global const double* g_vs, global const double* g_ws, global const double* g_qs, global const double* g_rho_i, global const double* g_speed, global double* g_rhs, int nx2, int ny2, int nz2) {
  int i, j, k;
  double t1, t2, t3, ac, ru1, uu, vv, ww, r1, r2, r3, r4, r5, ac2inv;

  k = get_global_id(2) + 1;
  j = get_global_id(1) + 1;
  i = get_global_id(0) + 1;
  if (k > nz2 || j > ny2 || i > nx2)
    return;

  global double(*us)[(64 / 2 * 2) + 1][(64 / 2 * 2) + 1] = (global double(*)[(64 / 2 * 2) + 1][(64 / 2 * 2) + 1]) g_us;
  global double(*vs)[(64 / 2 * 2) + 1][(64 / 2 * 2) + 1] = (global double(*)[(64 / 2 * 2) + 1][(64 / 2 * 2) + 1]) g_vs;
  global double(*ws)[(64 / 2 * 2) + 1][(64 / 2 * 2) + 1] = (global double(*)[(64 / 2 * 2) + 1][(64 / 2 * 2) + 1]) g_ws;
  global double(*qs)[(64 / 2 * 2) + 1][(64 / 2 * 2) + 1] = (global double(*)[(64 / 2 * 2) + 1][(64 / 2 * 2) + 1]) g_qs;
  global double(*rho_i)[(64 / 2 * 2) + 1][(64 / 2 * 2) + 1] = (global double(*)[(64 / 2 * 2) + 1][(64 / 2 * 2) + 1]) g_rho_i;
  global double(*speed)[(64 / 2 * 2) + 1][(64 / 2 * 2) + 1] = (global double(*)[(64 / 2 * 2) + 1][(64 / 2 * 2) + 1]) g_speed;
  global double(*rhs)[(64 / 2 * 2) + 1][(64 / 2 * 2) + 1][5] = (global double(*)[(64 / 2 * 2) + 1][(64 / 2 * 2) + 1][5]) g_rhs;

  ru1 = rho_i[hook(12, k)][hook(11, j)][hook(10, i)];
  uu = us[hook(15, k)][hook(14, j)][hook(13, i)];
  vv = vs[hook(18, k)][hook(17, j)][hook(16, i)];
  ww = ws[hook(21, k)][hook(20, j)][hook(19, i)];
  ac = speed[hook(24, k)][hook(23, j)][hook(22, i)];
  ac2inv = ac * ac;

  r1 = rhs[hook(28, k)][hook(27, j)][hook(26, i)][hook(25, 0)];
  r2 = rhs[hook(28, k)][hook(27, j)][hook(26, i)][hook(25, 1)];
  r3 = rhs[hook(28, k)][hook(27, j)][hook(26, i)][hook(25, 2)];
  r4 = rhs[hook(28, k)][hook(27, j)][hook(26, i)][hook(25, 3)];
  r5 = rhs[hook(28, k)][hook(27, j)][hook(26, i)][hook(25, 4)];

  t1 = 0.4 / ac2inv * (qs[hook(31, k)][hook(30, j)][hook(29, i)] * r1 - uu * r2 - vv * r3 - ww * r4 + r5);
  t2 = sqrt(0.5) * ru1 * (uu * r1 - r2);
  t3 = (sqrt(0.5) * ru1 * ac) * t1;

  rhs[hook(28, k)][hook(27, j)][hook(26, i)][hook(25, 0)] = r1 - t1;
  rhs[hook(28, k)][hook(27, j)][hook(26, i)][hook(25, 1)] = -ru1 * (ww * r1 - r4);
  rhs[hook(28, k)][hook(27, j)][hook(26, i)][hook(25, 2)] = ru1 * (vv * r1 - r3);
  rhs[hook(28, k)][hook(27, j)][hook(26, i)][hook(25, 3)] = -t2 + t3;
  rhs[hook(28, k)][hook(27, j)][hook(26, i)][hook(25, 4)] = t2 + t3;
}