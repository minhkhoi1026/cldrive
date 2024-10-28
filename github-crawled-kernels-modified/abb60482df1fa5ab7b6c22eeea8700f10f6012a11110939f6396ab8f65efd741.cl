//{"g_rhs":0,"nx2":1,"ny2":2,"nz2":3,"rhs":7,"rhs[k]":6,"rhs[k][j]":5,"rhs[k][j][i]":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void pinvr(global double* g_rhs, int nx2, int ny2, int nz2) {
  int i, j, k;
  double r1, r2, r3, r4, r5, t1, t2;

  k = get_global_id(2) + 1;
  j = get_global_id(1) + 1;
  i = get_global_id(0) + 1;
  if (k > nz2 || j > ny2 || i > nx2)
    return;

  global double(*rhs)[(64 / 2 * 2) + 1][(64 / 2 * 2) + 1][5] = (global double(*)[(64 / 2 * 2) + 1][(64 / 2 * 2) + 1][5]) g_rhs;

  r1 = rhs[hook(7, k)][hook(6, j)][hook(5, i)][hook(4, 0)];
  r2 = rhs[hook(7, k)][hook(6, j)][hook(5, i)][hook(4, 1)];
  r3 = rhs[hook(7, k)][hook(6, j)][hook(5, i)][hook(4, 2)];
  r4 = rhs[hook(7, k)][hook(6, j)][hook(5, i)][hook(4, 3)];
  r5 = rhs[hook(7, k)][hook(6, j)][hook(5, i)][hook(4, 4)];

  t1 = sqrt(0.5) * r1;
  t2 = 0.5 * (r4 + r5);

  rhs[hook(7, k)][hook(6, j)][hook(5, i)][hook(4, 0)] = sqrt(0.5) * (r4 - r5);
  rhs[hook(7, k)][hook(6, j)][hook(5, i)][hook(4, 1)] = -r3;
  rhs[hook(7, k)][hook(6, j)][hook(5, i)][hook(4, 2)] = r2;
  rhs[hook(7, k)][hook(6, j)][hook(5, i)][hook(4, 3)] = -t1 + t2;
  rhs[hook(7, k)][hook(6, j)][hook(5, i)][hook(4, 4)] = t1 + t2;
}