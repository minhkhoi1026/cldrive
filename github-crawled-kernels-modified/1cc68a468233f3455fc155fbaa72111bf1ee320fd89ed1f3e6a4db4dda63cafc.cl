//{"g_qs":4,"g_rhs":6,"g_speed":5,"g_u":0,"g_us":1,"g_vs":2,"g_ws":3,"nx2":7,"ny2":8,"nz2":9,"qs":32,"qs[k]":31,"qs[k][j]":30,"rhs":25,"rhs[k]":24,"rhs[k][j]":23,"rhs[k][j][i]":22,"speed":21,"speed[k]":20,"speed[k][j]":19,"u":29,"u[k]":28,"u[k][j]":27,"u[k][j][i]":26,"us":12,"us[k]":11,"us[k][j]":10,"vs":15,"vs[k]":14,"vs[k][j]":13,"ws":18,"ws[k]":17,"ws[k][j]":16}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void tzetar(global double* g_u, global double* g_us, global double* g_vs, global double* g_ws, global double* g_qs, global double* g_speed, global double* g_rhs, int nx2, int ny2, int nz2) {
  int i, j, k;
  double t1, t2, t3, ac, xvel, yvel, zvel, r1, r2, r3, r4, r5;
  double btuz, ac2u, uzik1;

  k = get_global_id(2) + 1;
  j = get_global_id(1) + 1;
  i = get_global_id(0) + 1;
  if (k > nz2 || j > ny2 || i > nx2)
    return;

  global double(*u)[(64 / 2 * 2) + 1][(64 / 2 * 2) + 1][5] = (global double(*)[(64 / 2 * 2) + 1][(64 / 2 * 2) + 1][5]) g_u;
  global double(*us)[(64 / 2 * 2) + 1][(64 / 2 * 2) + 1] = (global double(*)[(64 / 2 * 2) + 1][(64 / 2 * 2) + 1]) g_us;
  global double(*vs)[(64 / 2 * 2) + 1][(64 / 2 * 2) + 1] = (global double(*)[(64 / 2 * 2) + 1][(64 / 2 * 2) + 1]) g_vs;
  global double(*ws)[(64 / 2 * 2) + 1][(64 / 2 * 2) + 1] = (global double(*)[(64 / 2 * 2) + 1][(64 / 2 * 2) + 1]) g_ws;
  global double(*qs)[(64 / 2 * 2) + 1][(64 / 2 * 2) + 1] = (global double(*)[(64 / 2 * 2) + 1][(64 / 2 * 2) + 1]) g_qs;
  global double(*speed)[(64 / 2 * 2) + 1][(64 / 2 * 2) + 1] = (global double(*)[(64 / 2 * 2) + 1][(64 / 2 * 2) + 1]) g_speed;
  global double(*rhs)[(64 / 2 * 2) + 1][(64 / 2 * 2) + 1][5] = (global double(*)[(64 / 2 * 2) + 1][(64 / 2 * 2) + 1][5]) g_rhs;

  xvel = us[hook(12, k)][hook(11, j)][hook(10, i)];
  yvel = vs[hook(15, k)][hook(14, j)][hook(13, i)];
  zvel = ws[hook(18, k)][hook(17, j)][hook(16, i)];
  ac = speed[hook(21, k)][hook(20, j)][hook(19, i)];

  ac2u = ac * ac;

  r1 = rhs[hook(25, k)][hook(24, j)][hook(23, i)][hook(22, 0)];
  r2 = rhs[hook(25, k)][hook(24, j)][hook(23, i)][hook(22, 1)];
  r3 = rhs[hook(25, k)][hook(24, j)][hook(23, i)][hook(22, 2)];
  r4 = rhs[hook(25, k)][hook(24, j)][hook(23, i)][hook(22, 3)];
  r5 = rhs[hook(25, k)][hook(24, j)][hook(23, i)][hook(22, 4)];

  uzik1 = u[hook(29, k)][hook(28, j)][hook(27, i)][hook(26, 0)];
  btuz = sqrt(0.5) * uzik1;

  t1 = btuz / ac * (r4 + r5);
  t2 = r3 + t1;
  t3 = btuz * (r4 - r5);

  rhs[hook(25, k)][hook(24, j)][hook(23, i)][hook(22, 0)] = t2;
  rhs[hook(25, k)][hook(24, j)][hook(23, i)][hook(22, 1)] = -uzik1 * r2 + xvel * t2;
  rhs[hook(25, k)][hook(24, j)][hook(23, i)][hook(22, 2)] = uzik1 * r1 + yvel * t2;
  rhs[hook(25, k)][hook(24, j)][hook(23, i)][hook(22, 3)] = zvel * t2 + t3;
  rhs[hook(25, k)][hook(24, j)][hook(23, i)][hook(22, 4)] = uzik1 * (-xvel * r2 + yvel * r1) + qs[hook(32, k)][hook(31, j)][hook(30, i)] * t2 + 2.5 * ac2u * t1 + zvel * t3;
}