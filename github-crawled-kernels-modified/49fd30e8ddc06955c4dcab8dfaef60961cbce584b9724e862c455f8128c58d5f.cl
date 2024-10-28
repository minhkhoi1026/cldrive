//{"forcing":12,"forcing[k]":11,"forcing[k][j]":10,"forcing[k][j][i]":9,"g_forcing":0,"g_rhs":1,"nx2":2,"ny2":3,"nz2":4,"rhs":8,"rhs[k]":7,"rhs[k][j]":6,"rhs[k][j][i]":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compute_rhs2(global const double* g_forcing, global double* g_rhs, int nx2, int ny2, int nz2) {
  int i, j, k, m;

  k = get_global_id(2);
  j = get_global_id(1);
  i = get_global_id(0);
  if (k > (nz2 + 1) || j > (ny2 + 1) || i > (nx2 + 1))
    return;

  global double(*forcing)[(64 / 2 * 2) + 1][(64 / 2 * 2) + 1][5] = (global double(*)[(64 / 2 * 2) + 1][(64 / 2 * 2) + 1][5]) g_forcing;
  global double(*rhs)[(64 / 2 * 2) + 1][(64 / 2 * 2) + 1][5] = (global double(*)[(64 / 2 * 2) + 1][(64 / 2 * 2) + 1][5]) g_rhs;

  for (m = 0; m < 5; m++) {
    rhs[hook(8, k)][hook(7, j)][hook(6, i)][hook(5, m)] = forcing[hook(12, k)][hook(11, j)][hook(10, i)][hook(9, m)];
  }
}