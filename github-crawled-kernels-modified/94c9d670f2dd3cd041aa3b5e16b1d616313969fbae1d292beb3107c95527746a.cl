//{"g_rhs":1,"g_u":0,"nx2":2,"ny2":3,"nz2":4,"rhs":12,"rhs[k]":11,"rhs[k][j]":10,"rhs[k][j][i]":9,"u":8,"u[k]":7,"u[k][j]":6,"u[k][j][i]":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void add(global double* g_u, global double* g_rhs, int nx2, int ny2, int nz2) {
  int i, j, k, m;

  k = get_global_id(2) + 1;
  j = get_global_id(1) + 1;
  i = get_global_id(0) + 1;
  if (k > nz2 || j > ny2 || i > nx2)
    return;

  global double(*u)[(64 / 2 * 2) + 1][(64 / 2 * 2) + 1][5] = (global double(*)[(64 / 2 * 2) + 1][(64 / 2 * 2) + 1][5]) g_u;
  global double(*rhs)[(64 / 2 * 2) + 1][(64 / 2 * 2) + 1][5] = (global double(*)[(64 / 2 * 2) + 1][(64 / 2 * 2) + 1][5]) g_rhs;

  for (m = 0; m < 5; m++) {
    u[hook(8, k)][hook(7, j)][hook(6, i)][hook(5, m)] = u[hook(8, k)][hook(7, j)][hook(6, i)][hook(5, m)] + rhs[hook(12, k)][hook(11, j)][hook(10, i)][hook(9, m)];
  }
}