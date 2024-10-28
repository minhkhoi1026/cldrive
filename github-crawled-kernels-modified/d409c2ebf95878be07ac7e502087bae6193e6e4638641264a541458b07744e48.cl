//{"g_rhs":0,"gp0":1,"gp1":2,"gp2":3,"rhs":7,"rhs[k]":6,"rhs[k][j]":5,"rhs[k][j][i]":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compute_rhs6(global double* g_rhs, int gp0, int gp1, int gp2) {
  int i, j, k, m;

  k = get_global_id(2) + 1;
  j = get_global_id(1) + 1;
  i = get_global_id(0) + 1;
  if (k > (gp2 - 2) || j > (gp1 - 2) || i > (gp0 - 2))
    return;

  global double(*rhs)[64 / 2 * 2 + 1][64 / 2 * 2 + 1][5] = (global double(*)[64 / 2 * 2 + 1][64 / 2 * 2 + 1][5]) g_rhs;

  for (m = 0; m < 5; m++) {
    rhs[hook(7, k)][hook(6, j)][hook(5, i)][hook(4, m)] = rhs[hook(7, k)][hook(6, j)][hook(5, i)][hook(4, m)] * 0.0008;
  }
}