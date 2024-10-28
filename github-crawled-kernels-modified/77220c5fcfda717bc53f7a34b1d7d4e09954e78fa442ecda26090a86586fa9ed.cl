//{"ablock":7,"ablock[0]":6,"ablock[1]":9,"ablock[2]":10,"ablock[3]":11,"ablock[4]":12,"avec":8,"bblock":16,"bblock[0]":15,"bblock[1]":18,"bblock[2]":20,"bblock[3]":22,"bblock[4]":24,"bvec":5,"c":32,"c[0]":31,"c[1]":33,"c[2]":34,"c[3]":35,"c[4]":36,"cblock":14,"cblock[0]":13,"cblock[1]":17,"cblock[2]":19,"cblock[3]":21,"cblock[4]":23,"g_lhs":1,"g_rhs":0,"gp0":2,"gp1":3,"gp2":4,"lhs":26,"lhs[0]":25,"lhs[1]":27,"lhs[2]":28,"lhs[3]":29,"lhs[4]":30,"lhs[j - 1]":44,"lhs[j]":41,"lhs[j][2]":51,"lhs[j][2][n]":50,"lhs[jsize - 1]":48,"lhs[jsize]":45,"r":37,"rhs":40,"rhs[k]":39,"rhs[k][0]":38,"rhs[k][j + 1]":53,"rhs[k][j + 1][i]":52,"rhs[k][j - 1]":42,"rhs[k][j]":43,"rhs[k][j][i]":49,"rhs[k][jsize - 1]":46,"rhs[k][jsize]":47}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void matvec_sub(global double ablock[5][5], global double avec[5], global double bvec[5]) {
  bvec[hook(5, 0)] = bvec[hook(5, 0)] - ablock[hook(7, 0)][hook(6, 0)] * avec[hook(8, 0)] - ablock[hook(7, 1)][hook(9, 0)] * avec[hook(8, 1)] - ablock[hook(7, 2)][hook(10, 0)] * avec[hook(8, 2)] - ablock[hook(7, 3)][hook(11, 0)] * avec[hook(8, 3)] - ablock[hook(7, 4)][hook(12, 0)] * avec[hook(8, 4)];
  bvec[hook(5, 1)] = bvec[hook(5, 1)] - ablock[hook(7, 0)][hook(6, 1)] * avec[hook(8, 0)] - ablock[hook(7, 1)][hook(9, 1)] * avec[hook(8, 1)] - ablock[hook(7, 2)][hook(10, 1)] * avec[hook(8, 2)] - ablock[hook(7, 3)][hook(11, 1)] * avec[hook(8, 3)] - ablock[hook(7, 4)][hook(12, 1)] * avec[hook(8, 4)];
  bvec[hook(5, 2)] = bvec[hook(5, 2)] - ablock[hook(7, 0)][hook(6, 2)] * avec[hook(8, 0)] - ablock[hook(7, 1)][hook(9, 2)] * avec[hook(8, 1)] - ablock[hook(7, 2)][hook(10, 2)] * avec[hook(8, 2)] - ablock[hook(7, 3)][hook(11, 2)] * avec[hook(8, 3)] - ablock[hook(7, 4)][hook(12, 2)] * avec[hook(8, 4)];
  bvec[hook(5, 3)] = bvec[hook(5, 3)] - ablock[hook(7, 0)][hook(6, 3)] * avec[hook(8, 0)] - ablock[hook(7, 1)][hook(9, 3)] * avec[hook(8, 1)] - ablock[hook(7, 2)][hook(10, 3)] * avec[hook(8, 2)] - ablock[hook(7, 3)][hook(11, 3)] * avec[hook(8, 3)] - ablock[hook(7, 4)][hook(12, 3)] * avec[hook(8, 4)];
  bvec[hook(5, 4)] = bvec[hook(5, 4)] - ablock[hook(7, 0)][hook(6, 4)] * avec[hook(8, 0)] - ablock[hook(7, 1)][hook(9, 4)] * avec[hook(8, 1)] - ablock[hook(7, 2)][hook(10, 4)] * avec[hook(8, 2)] - ablock[hook(7, 3)][hook(11, 4)] * avec[hook(8, 3)] - ablock[hook(7, 4)][hook(12, 4)] * avec[hook(8, 4)];
}

void matmul_sub(global double ablock[5][5], global double bblock[5][5], global double cblock[5][5]) {
  cblock[hook(14, 0)][hook(13, 0)] = cblock[hook(14, 0)][hook(13, 0)] - ablock[hook(7, 0)][hook(6, 0)] * bblock[hook(16, 0)][hook(15, 0)] - ablock[hook(7, 1)][hook(9, 0)] * bblock[hook(16, 0)][hook(15, 1)] - ablock[hook(7, 2)][hook(10, 0)] * bblock[hook(16, 0)][hook(15, 2)] - ablock[hook(7, 3)][hook(11, 0)] * bblock[hook(16, 0)][hook(15, 3)] - ablock[hook(7, 4)][hook(12, 0)] * bblock[hook(16, 0)][hook(15, 4)];
  cblock[hook(14, 0)][hook(13, 1)] = cblock[hook(14, 0)][hook(13, 1)] - ablock[hook(7, 0)][hook(6, 1)] * bblock[hook(16, 0)][hook(15, 0)] - ablock[hook(7, 1)][hook(9, 1)] * bblock[hook(16, 0)][hook(15, 1)] - ablock[hook(7, 2)][hook(10, 1)] * bblock[hook(16, 0)][hook(15, 2)] - ablock[hook(7, 3)][hook(11, 1)] * bblock[hook(16, 0)][hook(15, 3)] - ablock[hook(7, 4)][hook(12, 1)] * bblock[hook(16, 0)][hook(15, 4)];
  cblock[hook(14, 0)][hook(13, 2)] = cblock[hook(14, 0)][hook(13, 2)] - ablock[hook(7, 0)][hook(6, 2)] * bblock[hook(16, 0)][hook(15, 0)] - ablock[hook(7, 1)][hook(9, 2)] * bblock[hook(16, 0)][hook(15, 1)] - ablock[hook(7, 2)][hook(10, 2)] * bblock[hook(16, 0)][hook(15, 2)] - ablock[hook(7, 3)][hook(11, 2)] * bblock[hook(16, 0)][hook(15, 3)] - ablock[hook(7, 4)][hook(12, 2)] * bblock[hook(16, 0)][hook(15, 4)];
  cblock[hook(14, 0)][hook(13, 3)] = cblock[hook(14, 0)][hook(13, 3)] - ablock[hook(7, 0)][hook(6, 3)] * bblock[hook(16, 0)][hook(15, 0)] - ablock[hook(7, 1)][hook(9, 3)] * bblock[hook(16, 0)][hook(15, 1)] - ablock[hook(7, 2)][hook(10, 3)] * bblock[hook(16, 0)][hook(15, 2)] - ablock[hook(7, 3)][hook(11, 3)] * bblock[hook(16, 0)][hook(15, 3)] - ablock[hook(7, 4)][hook(12, 3)] * bblock[hook(16, 0)][hook(15, 4)];
  cblock[hook(14, 0)][hook(13, 4)] = cblock[hook(14, 0)][hook(13, 4)] - ablock[hook(7, 0)][hook(6, 4)] * bblock[hook(16, 0)][hook(15, 0)] - ablock[hook(7, 1)][hook(9, 4)] * bblock[hook(16, 0)][hook(15, 1)] - ablock[hook(7, 2)][hook(10, 4)] * bblock[hook(16, 0)][hook(15, 2)] - ablock[hook(7, 3)][hook(11, 4)] * bblock[hook(16, 0)][hook(15, 3)] - ablock[hook(7, 4)][hook(12, 4)] * bblock[hook(16, 0)][hook(15, 4)];
  cblock[hook(14, 1)][hook(17, 0)] = cblock[hook(14, 1)][hook(17, 0)] - ablock[hook(7, 0)][hook(6, 0)] * bblock[hook(16, 1)][hook(18, 0)] - ablock[hook(7, 1)][hook(9, 0)] * bblock[hook(16, 1)][hook(18, 1)] - ablock[hook(7, 2)][hook(10, 0)] * bblock[hook(16, 1)][hook(18, 2)] - ablock[hook(7, 3)][hook(11, 0)] * bblock[hook(16, 1)][hook(18, 3)] - ablock[hook(7, 4)][hook(12, 0)] * bblock[hook(16, 1)][hook(18, 4)];
  cblock[hook(14, 1)][hook(17, 1)] = cblock[hook(14, 1)][hook(17, 1)] - ablock[hook(7, 0)][hook(6, 1)] * bblock[hook(16, 1)][hook(18, 0)] - ablock[hook(7, 1)][hook(9, 1)] * bblock[hook(16, 1)][hook(18, 1)] - ablock[hook(7, 2)][hook(10, 1)] * bblock[hook(16, 1)][hook(18, 2)] - ablock[hook(7, 3)][hook(11, 1)] * bblock[hook(16, 1)][hook(18, 3)] - ablock[hook(7, 4)][hook(12, 1)] * bblock[hook(16, 1)][hook(18, 4)];
  cblock[hook(14, 1)][hook(17, 2)] = cblock[hook(14, 1)][hook(17, 2)] - ablock[hook(7, 0)][hook(6, 2)] * bblock[hook(16, 1)][hook(18, 0)] - ablock[hook(7, 1)][hook(9, 2)] * bblock[hook(16, 1)][hook(18, 1)] - ablock[hook(7, 2)][hook(10, 2)] * bblock[hook(16, 1)][hook(18, 2)] - ablock[hook(7, 3)][hook(11, 2)] * bblock[hook(16, 1)][hook(18, 3)] - ablock[hook(7, 4)][hook(12, 2)] * bblock[hook(16, 1)][hook(18, 4)];
  cblock[hook(14, 1)][hook(17, 3)] = cblock[hook(14, 1)][hook(17, 3)] - ablock[hook(7, 0)][hook(6, 3)] * bblock[hook(16, 1)][hook(18, 0)] - ablock[hook(7, 1)][hook(9, 3)] * bblock[hook(16, 1)][hook(18, 1)] - ablock[hook(7, 2)][hook(10, 3)] * bblock[hook(16, 1)][hook(18, 2)] - ablock[hook(7, 3)][hook(11, 3)] * bblock[hook(16, 1)][hook(18, 3)] - ablock[hook(7, 4)][hook(12, 3)] * bblock[hook(16, 1)][hook(18, 4)];
  cblock[hook(14, 1)][hook(17, 4)] = cblock[hook(14, 1)][hook(17, 4)] - ablock[hook(7, 0)][hook(6, 4)] * bblock[hook(16, 1)][hook(18, 0)] - ablock[hook(7, 1)][hook(9, 4)] * bblock[hook(16, 1)][hook(18, 1)] - ablock[hook(7, 2)][hook(10, 4)] * bblock[hook(16, 1)][hook(18, 2)] - ablock[hook(7, 3)][hook(11, 4)] * bblock[hook(16, 1)][hook(18, 3)] - ablock[hook(7, 4)][hook(12, 4)] * bblock[hook(16, 1)][hook(18, 4)];
  cblock[hook(14, 2)][hook(19, 0)] = cblock[hook(14, 2)][hook(19, 0)] - ablock[hook(7, 0)][hook(6, 0)] * bblock[hook(16, 2)][hook(20, 0)] - ablock[hook(7, 1)][hook(9, 0)] * bblock[hook(16, 2)][hook(20, 1)] - ablock[hook(7, 2)][hook(10, 0)] * bblock[hook(16, 2)][hook(20, 2)] - ablock[hook(7, 3)][hook(11, 0)] * bblock[hook(16, 2)][hook(20, 3)] - ablock[hook(7, 4)][hook(12, 0)] * bblock[hook(16, 2)][hook(20, 4)];
  cblock[hook(14, 2)][hook(19, 1)] = cblock[hook(14, 2)][hook(19, 1)] - ablock[hook(7, 0)][hook(6, 1)] * bblock[hook(16, 2)][hook(20, 0)] - ablock[hook(7, 1)][hook(9, 1)] * bblock[hook(16, 2)][hook(20, 1)] - ablock[hook(7, 2)][hook(10, 1)] * bblock[hook(16, 2)][hook(20, 2)] - ablock[hook(7, 3)][hook(11, 1)] * bblock[hook(16, 2)][hook(20, 3)] - ablock[hook(7, 4)][hook(12, 1)] * bblock[hook(16, 2)][hook(20, 4)];
  cblock[hook(14, 2)][hook(19, 2)] = cblock[hook(14, 2)][hook(19, 2)] - ablock[hook(7, 0)][hook(6, 2)] * bblock[hook(16, 2)][hook(20, 0)] - ablock[hook(7, 1)][hook(9, 2)] * bblock[hook(16, 2)][hook(20, 1)] - ablock[hook(7, 2)][hook(10, 2)] * bblock[hook(16, 2)][hook(20, 2)] - ablock[hook(7, 3)][hook(11, 2)] * bblock[hook(16, 2)][hook(20, 3)] - ablock[hook(7, 4)][hook(12, 2)] * bblock[hook(16, 2)][hook(20, 4)];
  cblock[hook(14, 2)][hook(19, 3)] = cblock[hook(14, 2)][hook(19, 3)] - ablock[hook(7, 0)][hook(6, 3)] * bblock[hook(16, 2)][hook(20, 0)] - ablock[hook(7, 1)][hook(9, 3)] * bblock[hook(16, 2)][hook(20, 1)] - ablock[hook(7, 2)][hook(10, 3)] * bblock[hook(16, 2)][hook(20, 2)] - ablock[hook(7, 3)][hook(11, 3)] * bblock[hook(16, 2)][hook(20, 3)] - ablock[hook(7, 4)][hook(12, 3)] * bblock[hook(16, 2)][hook(20, 4)];
  cblock[hook(14, 2)][hook(19, 4)] = cblock[hook(14, 2)][hook(19, 4)] - ablock[hook(7, 0)][hook(6, 4)] * bblock[hook(16, 2)][hook(20, 0)] - ablock[hook(7, 1)][hook(9, 4)] * bblock[hook(16, 2)][hook(20, 1)] - ablock[hook(7, 2)][hook(10, 4)] * bblock[hook(16, 2)][hook(20, 2)] - ablock[hook(7, 3)][hook(11, 4)] * bblock[hook(16, 2)][hook(20, 3)] - ablock[hook(7, 4)][hook(12, 4)] * bblock[hook(16, 2)][hook(20, 4)];
  cblock[hook(14, 3)][hook(21, 0)] = cblock[hook(14, 3)][hook(21, 0)] - ablock[hook(7, 0)][hook(6, 0)] * bblock[hook(16, 3)][hook(22, 0)] - ablock[hook(7, 1)][hook(9, 0)] * bblock[hook(16, 3)][hook(22, 1)] - ablock[hook(7, 2)][hook(10, 0)] * bblock[hook(16, 3)][hook(22, 2)] - ablock[hook(7, 3)][hook(11, 0)] * bblock[hook(16, 3)][hook(22, 3)] - ablock[hook(7, 4)][hook(12, 0)] * bblock[hook(16, 3)][hook(22, 4)];
  cblock[hook(14, 3)][hook(21, 1)] = cblock[hook(14, 3)][hook(21, 1)] - ablock[hook(7, 0)][hook(6, 1)] * bblock[hook(16, 3)][hook(22, 0)] - ablock[hook(7, 1)][hook(9, 1)] * bblock[hook(16, 3)][hook(22, 1)] - ablock[hook(7, 2)][hook(10, 1)] * bblock[hook(16, 3)][hook(22, 2)] - ablock[hook(7, 3)][hook(11, 1)] * bblock[hook(16, 3)][hook(22, 3)] - ablock[hook(7, 4)][hook(12, 1)] * bblock[hook(16, 3)][hook(22, 4)];
  cblock[hook(14, 3)][hook(21, 2)] = cblock[hook(14, 3)][hook(21, 2)] - ablock[hook(7, 0)][hook(6, 2)] * bblock[hook(16, 3)][hook(22, 0)] - ablock[hook(7, 1)][hook(9, 2)] * bblock[hook(16, 3)][hook(22, 1)] - ablock[hook(7, 2)][hook(10, 2)] * bblock[hook(16, 3)][hook(22, 2)] - ablock[hook(7, 3)][hook(11, 2)] * bblock[hook(16, 3)][hook(22, 3)] - ablock[hook(7, 4)][hook(12, 2)] * bblock[hook(16, 3)][hook(22, 4)];
  cblock[hook(14, 3)][hook(21, 3)] = cblock[hook(14, 3)][hook(21, 3)] - ablock[hook(7, 0)][hook(6, 3)] * bblock[hook(16, 3)][hook(22, 0)] - ablock[hook(7, 1)][hook(9, 3)] * bblock[hook(16, 3)][hook(22, 1)] - ablock[hook(7, 2)][hook(10, 3)] * bblock[hook(16, 3)][hook(22, 2)] - ablock[hook(7, 3)][hook(11, 3)] * bblock[hook(16, 3)][hook(22, 3)] - ablock[hook(7, 4)][hook(12, 3)] * bblock[hook(16, 3)][hook(22, 4)];
  cblock[hook(14, 3)][hook(21, 4)] = cblock[hook(14, 3)][hook(21, 4)] - ablock[hook(7, 0)][hook(6, 4)] * bblock[hook(16, 3)][hook(22, 0)] - ablock[hook(7, 1)][hook(9, 4)] * bblock[hook(16, 3)][hook(22, 1)] - ablock[hook(7, 2)][hook(10, 4)] * bblock[hook(16, 3)][hook(22, 2)] - ablock[hook(7, 3)][hook(11, 4)] * bblock[hook(16, 3)][hook(22, 3)] - ablock[hook(7, 4)][hook(12, 4)] * bblock[hook(16, 3)][hook(22, 4)];
  cblock[hook(14, 4)][hook(23, 0)] = cblock[hook(14, 4)][hook(23, 0)] - ablock[hook(7, 0)][hook(6, 0)] * bblock[hook(16, 4)][hook(24, 0)] - ablock[hook(7, 1)][hook(9, 0)] * bblock[hook(16, 4)][hook(24, 1)] - ablock[hook(7, 2)][hook(10, 0)] * bblock[hook(16, 4)][hook(24, 2)] - ablock[hook(7, 3)][hook(11, 0)] * bblock[hook(16, 4)][hook(24, 3)] - ablock[hook(7, 4)][hook(12, 0)] * bblock[hook(16, 4)][hook(24, 4)];
  cblock[hook(14, 4)][hook(23, 1)] = cblock[hook(14, 4)][hook(23, 1)] - ablock[hook(7, 0)][hook(6, 1)] * bblock[hook(16, 4)][hook(24, 0)] - ablock[hook(7, 1)][hook(9, 1)] * bblock[hook(16, 4)][hook(24, 1)] - ablock[hook(7, 2)][hook(10, 1)] * bblock[hook(16, 4)][hook(24, 2)] - ablock[hook(7, 3)][hook(11, 1)] * bblock[hook(16, 4)][hook(24, 3)] - ablock[hook(7, 4)][hook(12, 1)] * bblock[hook(16, 4)][hook(24, 4)];
  cblock[hook(14, 4)][hook(23, 2)] = cblock[hook(14, 4)][hook(23, 2)] - ablock[hook(7, 0)][hook(6, 2)] * bblock[hook(16, 4)][hook(24, 0)] - ablock[hook(7, 1)][hook(9, 2)] * bblock[hook(16, 4)][hook(24, 1)] - ablock[hook(7, 2)][hook(10, 2)] * bblock[hook(16, 4)][hook(24, 2)] - ablock[hook(7, 3)][hook(11, 2)] * bblock[hook(16, 4)][hook(24, 3)] - ablock[hook(7, 4)][hook(12, 2)] * bblock[hook(16, 4)][hook(24, 4)];
  cblock[hook(14, 4)][hook(23, 3)] = cblock[hook(14, 4)][hook(23, 3)] - ablock[hook(7, 0)][hook(6, 3)] * bblock[hook(16, 4)][hook(24, 0)] - ablock[hook(7, 1)][hook(9, 3)] * bblock[hook(16, 4)][hook(24, 1)] - ablock[hook(7, 2)][hook(10, 3)] * bblock[hook(16, 4)][hook(24, 2)] - ablock[hook(7, 3)][hook(11, 3)] * bblock[hook(16, 4)][hook(24, 3)] - ablock[hook(7, 4)][hook(12, 3)] * bblock[hook(16, 4)][hook(24, 4)];
  cblock[hook(14, 4)][hook(23, 4)] = cblock[hook(14, 4)][hook(23, 4)] - ablock[hook(7, 0)][hook(6, 4)] * bblock[hook(16, 4)][hook(24, 0)] - ablock[hook(7, 1)][hook(9, 4)] * bblock[hook(16, 4)][hook(24, 1)] - ablock[hook(7, 2)][hook(10, 4)] * bblock[hook(16, 4)][hook(24, 2)] - ablock[hook(7, 3)][hook(11, 4)] * bblock[hook(16, 4)][hook(24, 3)] - ablock[hook(7, 4)][hook(12, 4)] * bblock[hook(16, 4)][hook(24, 4)];
}

void binvcrhs(global double lhs[5][5], global double c[5][5], global double r[5]) {
  double pivot, coeff;

  pivot = 1.00 / lhs[hook(26, 0)][hook(25, 0)];
  lhs[hook(26, 1)][hook(27, 0)] = lhs[hook(26, 1)][hook(27, 0)] * pivot;
  lhs[hook(26, 2)][hook(28, 0)] = lhs[hook(26, 2)][hook(28, 0)] * pivot;
  lhs[hook(26, 3)][hook(29, 0)] = lhs[hook(26, 3)][hook(29, 0)] * pivot;
  lhs[hook(26, 4)][hook(30, 0)] = lhs[hook(26, 4)][hook(30, 0)] * pivot;
  c[hook(32, 0)][hook(31, 0)] = c[hook(32, 0)][hook(31, 0)] * pivot;
  c[hook(32, 1)][hook(33, 0)] = c[hook(32, 1)][hook(33, 0)] * pivot;
  c[hook(32, 2)][hook(34, 0)] = c[hook(32, 2)][hook(34, 0)] * pivot;
  c[hook(32, 3)][hook(35, 0)] = c[hook(32, 3)][hook(35, 0)] * pivot;
  c[hook(32, 4)][hook(36, 0)] = c[hook(32, 4)][hook(36, 0)] * pivot;
  r[hook(37, 0)] = r[hook(37, 0)] * pivot;

  coeff = lhs[hook(26, 0)][hook(25, 1)];
  lhs[hook(26, 1)][hook(27, 1)] = lhs[hook(26, 1)][hook(27, 1)] - coeff * lhs[hook(26, 1)][hook(27, 0)];
  lhs[hook(26, 2)][hook(28, 1)] = lhs[hook(26, 2)][hook(28, 1)] - coeff * lhs[hook(26, 2)][hook(28, 0)];
  lhs[hook(26, 3)][hook(29, 1)] = lhs[hook(26, 3)][hook(29, 1)] - coeff * lhs[hook(26, 3)][hook(29, 0)];
  lhs[hook(26, 4)][hook(30, 1)] = lhs[hook(26, 4)][hook(30, 1)] - coeff * lhs[hook(26, 4)][hook(30, 0)];
  c[hook(32, 0)][hook(31, 1)] = c[hook(32, 0)][hook(31, 1)] - coeff * c[hook(32, 0)][hook(31, 0)];
  c[hook(32, 1)][hook(33, 1)] = c[hook(32, 1)][hook(33, 1)] - coeff * c[hook(32, 1)][hook(33, 0)];
  c[hook(32, 2)][hook(34, 1)] = c[hook(32, 2)][hook(34, 1)] - coeff * c[hook(32, 2)][hook(34, 0)];
  c[hook(32, 3)][hook(35, 1)] = c[hook(32, 3)][hook(35, 1)] - coeff * c[hook(32, 3)][hook(35, 0)];
  c[hook(32, 4)][hook(36, 1)] = c[hook(32, 4)][hook(36, 1)] - coeff * c[hook(32, 4)][hook(36, 0)];
  r[hook(37, 1)] = r[hook(37, 1)] - coeff * r[hook(37, 0)];

  coeff = lhs[hook(26, 0)][hook(25, 2)];
  lhs[hook(26, 1)][hook(27, 2)] = lhs[hook(26, 1)][hook(27, 2)] - coeff * lhs[hook(26, 1)][hook(27, 0)];
  lhs[hook(26, 2)][hook(28, 2)] = lhs[hook(26, 2)][hook(28, 2)] - coeff * lhs[hook(26, 2)][hook(28, 0)];
  lhs[hook(26, 3)][hook(29, 2)] = lhs[hook(26, 3)][hook(29, 2)] - coeff * lhs[hook(26, 3)][hook(29, 0)];
  lhs[hook(26, 4)][hook(30, 2)] = lhs[hook(26, 4)][hook(30, 2)] - coeff * lhs[hook(26, 4)][hook(30, 0)];
  c[hook(32, 0)][hook(31, 2)] = c[hook(32, 0)][hook(31, 2)] - coeff * c[hook(32, 0)][hook(31, 0)];
  c[hook(32, 1)][hook(33, 2)] = c[hook(32, 1)][hook(33, 2)] - coeff * c[hook(32, 1)][hook(33, 0)];
  c[hook(32, 2)][hook(34, 2)] = c[hook(32, 2)][hook(34, 2)] - coeff * c[hook(32, 2)][hook(34, 0)];
  c[hook(32, 3)][hook(35, 2)] = c[hook(32, 3)][hook(35, 2)] - coeff * c[hook(32, 3)][hook(35, 0)];
  c[hook(32, 4)][hook(36, 2)] = c[hook(32, 4)][hook(36, 2)] - coeff * c[hook(32, 4)][hook(36, 0)];
  r[hook(37, 2)] = r[hook(37, 2)] - coeff * r[hook(37, 0)];

  coeff = lhs[hook(26, 0)][hook(25, 3)];
  lhs[hook(26, 1)][hook(27, 3)] = lhs[hook(26, 1)][hook(27, 3)] - coeff * lhs[hook(26, 1)][hook(27, 0)];
  lhs[hook(26, 2)][hook(28, 3)] = lhs[hook(26, 2)][hook(28, 3)] - coeff * lhs[hook(26, 2)][hook(28, 0)];
  lhs[hook(26, 3)][hook(29, 3)] = lhs[hook(26, 3)][hook(29, 3)] - coeff * lhs[hook(26, 3)][hook(29, 0)];
  lhs[hook(26, 4)][hook(30, 3)] = lhs[hook(26, 4)][hook(30, 3)] - coeff * lhs[hook(26, 4)][hook(30, 0)];
  c[hook(32, 0)][hook(31, 3)] = c[hook(32, 0)][hook(31, 3)] - coeff * c[hook(32, 0)][hook(31, 0)];
  c[hook(32, 1)][hook(33, 3)] = c[hook(32, 1)][hook(33, 3)] - coeff * c[hook(32, 1)][hook(33, 0)];
  c[hook(32, 2)][hook(34, 3)] = c[hook(32, 2)][hook(34, 3)] - coeff * c[hook(32, 2)][hook(34, 0)];
  c[hook(32, 3)][hook(35, 3)] = c[hook(32, 3)][hook(35, 3)] - coeff * c[hook(32, 3)][hook(35, 0)];
  c[hook(32, 4)][hook(36, 3)] = c[hook(32, 4)][hook(36, 3)] - coeff * c[hook(32, 4)][hook(36, 0)];
  r[hook(37, 3)] = r[hook(37, 3)] - coeff * r[hook(37, 0)];

  coeff = lhs[hook(26, 0)][hook(25, 4)];
  lhs[hook(26, 1)][hook(27, 4)] = lhs[hook(26, 1)][hook(27, 4)] - coeff * lhs[hook(26, 1)][hook(27, 0)];
  lhs[hook(26, 2)][hook(28, 4)] = lhs[hook(26, 2)][hook(28, 4)] - coeff * lhs[hook(26, 2)][hook(28, 0)];
  lhs[hook(26, 3)][hook(29, 4)] = lhs[hook(26, 3)][hook(29, 4)] - coeff * lhs[hook(26, 3)][hook(29, 0)];
  lhs[hook(26, 4)][hook(30, 4)] = lhs[hook(26, 4)][hook(30, 4)] - coeff * lhs[hook(26, 4)][hook(30, 0)];
  c[hook(32, 0)][hook(31, 4)] = c[hook(32, 0)][hook(31, 4)] - coeff * c[hook(32, 0)][hook(31, 0)];
  c[hook(32, 1)][hook(33, 4)] = c[hook(32, 1)][hook(33, 4)] - coeff * c[hook(32, 1)][hook(33, 0)];
  c[hook(32, 2)][hook(34, 4)] = c[hook(32, 2)][hook(34, 4)] - coeff * c[hook(32, 2)][hook(34, 0)];
  c[hook(32, 3)][hook(35, 4)] = c[hook(32, 3)][hook(35, 4)] - coeff * c[hook(32, 3)][hook(35, 0)];
  c[hook(32, 4)][hook(36, 4)] = c[hook(32, 4)][hook(36, 4)] - coeff * c[hook(32, 4)][hook(36, 0)];
  r[hook(37, 4)] = r[hook(37, 4)] - coeff * r[hook(37, 0)];

  pivot = 1.00 / lhs[hook(26, 1)][hook(27, 1)];
  lhs[hook(26, 2)][hook(28, 1)] = lhs[hook(26, 2)][hook(28, 1)] * pivot;
  lhs[hook(26, 3)][hook(29, 1)] = lhs[hook(26, 3)][hook(29, 1)] * pivot;
  lhs[hook(26, 4)][hook(30, 1)] = lhs[hook(26, 4)][hook(30, 1)] * pivot;
  c[hook(32, 0)][hook(31, 1)] = c[hook(32, 0)][hook(31, 1)] * pivot;
  c[hook(32, 1)][hook(33, 1)] = c[hook(32, 1)][hook(33, 1)] * pivot;
  c[hook(32, 2)][hook(34, 1)] = c[hook(32, 2)][hook(34, 1)] * pivot;
  c[hook(32, 3)][hook(35, 1)] = c[hook(32, 3)][hook(35, 1)] * pivot;
  c[hook(32, 4)][hook(36, 1)] = c[hook(32, 4)][hook(36, 1)] * pivot;
  r[hook(37, 1)] = r[hook(37, 1)] * pivot;

  coeff = lhs[hook(26, 1)][hook(27, 0)];
  lhs[hook(26, 2)][hook(28, 0)] = lhs[hook(26, 2)][hook(28, 0)] - coeff * lhs[hook(26, 2)][hook(28, 1)];
  lhs[hook(26, 3)][hook(29, 0)] = lhs[hook(26, 3)][hook(29, 0)] - coeff * lhs[hook(26, 3)][hook(29, 1)];
  lhs[hook(26, 4)][hook(30, 0)] = lhs[hook(26, 4)][hook(30, 0)] - coeff * lhs[hook(26, 4)][hook(30, 1)];
  c[hook(32, 0)][hook(31, 0)] = c[hook(32, 0)][hook(31, 0)] - coeff * c[hook(32, 0)][hook(31, 1)];
  c[hook(32, 1)][hook(33, 0)] = c[hook(32, 1)][hook(33, 0)] - coeff * c[hook(32, 1)][hook(33, 1)];
  c[hook(32, 2)][hook(34, 0)] = c[hook(32, 2)][hook(34, 0)] - coeff * c[hook(32, 2)][hook(34, 1)];
  c[hook(32, 3)][hook(35, 0)] = c[hook(32, 3)][hook(35, 0)] - coeff * c[hook(32, 3)][hook(35, 1)];
  c[hook(32, 4)][hook(36, 0)] = c[hook(32, 4)][hook(36, 0)] - coeff * c[hook(32, 4)][hook(36, 1)];
  r[hook(37, 0)] = r[hook(37, 0)] - coeff * r[hook(37, 1)];

  coeff = lhs[hook(26, 1)][hook(27, 2)];
  lhs[hook(26, 2)][hook(28, 2)] = lhs[hook(26, 2)][hook(28, 2)] - coeff * lhs[hook(26, 2)][hook(28, 1)];
  lhs[hook(26, 3)][hook(29, 2)] = lhs[hook(26, 3)][hook(29, 2)] - coeff * lhs[hook(26, 3)][hook(29, 1)];
  lhs[hook(26, 4)][hook(30, 2)] = lhs[hook(26, 4)][hook(30, 2)] - coeff * lhs[hook(26, 4)][hook(30, 1)];
  c[hook(32, 0)][hook(31, 2)] = c[hook(32, 0)][hook(31, 2)] - coeff * c[hook(32, 0)][hook(31, 1)];
  c[hook(32, 1)][hook(33, 2)] = c[hook(32, 1)][hook(33, 2)] - coeff * c[hook(32, 1)][hook(33, 1)];
  c[hook(32, 2)][hook(34, 2)] = c[hook(32, 2)][hook(34, 2)] - coeff * c[hook(32, 2)][hook(34, 1)];
  c[hook(32, 3)][hook(35, 2)] = c[hook(32, 3)][hook(35, 2)] - coeff * c[hook(32, 3)][hook(35, 1)];
  c[hook(32, 4)][hook(36, 2)] = c[hook(32, 4)][hook(36, 2)] - coeff * c[hook(32, 4)][hook(36, 1)];
  r[hook(37, 2)] = r[hook(37, 2)] - coeff * r[hook(37, 1)];

  coeff = lhs[hook(26, 1)][hook(27, 3)];
  lhs[hook(26, 2)][hook(28, 3)] = lhs[hook(26, 2)][hook(28, 3)] - coeff * lhs[hook(26, 2)][hook(28, 1)];
  lhs[hook(26, 3)][hook(29, 3)] = lhs[hook(26, 3)][hook(29, 3)] - coeff * lhs[hook(26, 3)][hook(29, 1)];
  lhs[hook(26, 4)][hook(30, 3)] = lhs[hook(26, 4)][hook(30, 3)] - coeff * lhs[hook(26, 4)][hook(30, 1)];
  c[hook(32, 0)][hook(31, 3)] = c[hook(32, 0)][hook(31, 3)] - coeff * c[hook(32, 0)][hook(31, 1)];
  c[hook(32, 1)][hook(33, 3)] = c[hook(32, 1)][hook(33, 3)] - coeff * c[hook(32, 1)][hook(33, 1)];
  c[hook(32, 2)][hook(34, 3)] = c[hook(32, 2)][hook(34, 3)] - coeff * c[hook(32, 2)][hook(34, 1)];
  c[hook(32, 3)][hook(35, 3)] = c[hook(32, 3)][hook(35, 3)] - coeff * c[hook(32, 3)][hook(35, 1)];
  c[hook(32, 4)][hook(36, 3)] = c[hook(32, 4)][hook(36, 3)] - coeff * c[hook(32, 4)][hook(36, 1)];
  r[hook(37, 3)] = r[hook(37, 3)] - coeff * r[hook(37, 1)];

  coeff = lhs[hook(26, 1)][hook(27, 4)];
  lhs[hook(26, 2)][hook(28, 4)] = lhs[hook(26, 2)][hook(28, 4)] - coeff * lhs[hook(26, 2)][hook(28, 1)];
  lhs[hook(26, 3)][hook(29, 4)] = lhs[hook(26, 3)][hook(29, 4)] - coeff * lhs[hook(26, 3)][hook(29, 1)];
  lhs[hook(26, 4)][hook(30, 4)] = lhs[hook(26, 4)][hook(30, 4)] - coeff * lhs[hook(26, 4)][hook(30, 1)];
  c[hook(32, 0)][hook(31, 4)] = c[hook(32, 0)][hook(31, 4)] - coeff * c[hook(32, 0)][hook(31, 1)];
  c[hook(32, 1)][hook(33, 4)] = c[hook(32, 1)][hook(33, 4)] - coeff * c[hook(32, 1)][hook(33, 1)];
  c[hook(32, 2)][hook(34, 4)] = c[hook(32, 2)][hook(34, 4)] - coeff * c[hook(32, 2)][hook(34, 1)];
  c[hook(32, 3)][hook(35, 4)] = c[hook(32, 3)][hook(35, 4)] - coeff * c[hook(32, 3)][hook(35, 1)];
  c[hook(32, 4)][hook(36, 4)] = c[hook(32, 4)][hook(36, 4)] - coeff * c[hook(32, 4)][hook(36, 1)];
  r[hook(37, 4)] = r[hook(37, 4)] - coeff * r[hook(37, 1)];

  pivot = 1.00 / lhs[hook(26, 2)][hook(28, 2)];
  lhs[hook(26, 3)][hook(29, 2)] = lhs[hook(26, 3)][hook(29, 2)] * pivot;
  lhs[hook(26, 4)][hook(30, 2)] = lhs[hook(26, 4)][hook(30, 2)] * pivot;
  c[hook(32, 0)][hook(31, 2)] = c[hook(32, 0)][hook(31, 2)] * pivot;
  c[hook(32, 1)][hook(33, 2)] = c[hook(32, 1)][hook(33, 2)] * pivot;
  c[hook(32, 2)][hook(34, 2)] = c[hook(32, 2)][hook(34, 2)] * pivot;
  c[hook(32, 3)][hook(35, 2)] = c[hook(32, 3)][hook(35, 2)] * pivot;
  c[hook(32, 4)][hook(36, 2)] = c[hook(32, 4)][hook(36, 2)] * pivot;
  r[hook(37, 2)] = r[hook(37, 2)] * pivot;

  coeff = lhs[hook(26, 2)][hook(28, 0)];
  lhs[hook(26, 3)][hook(29, 0)] = lhs[hook(26, 3)][hook(29, 0)] - coeff * lhs[hook(26, 3)][hook(29, 2)];
  lhs[hook(26, 4)][hook(30, 0)] = lhs[hook(26, 4)][hook(30, 0)] - coeff * lhs[hook(26, 4)][hook(30, 2)];
  c[hook(32, 0)][hook(31, 0)] = c[hook(32, 0)][hook(31, 0)] - coeff * c[hook(32, 0)][hook(31, 2)];
  c[hook(32, 1)][hook(33, 0)] = c[hook(32, 1)][hook(33, 0)] - coeff * c[hook(32, 1)][hook(33, 2)];
  c[hook(32, 2)][hook(34, 0)] = c[hook(32, 2)][hook(34, 0)] - coeff * c[hook(32, 2)][hook(34, 2)];
  c[hook(32, 3)][hook(35, 0)] = c[hook(32, 3)][hook(35, 0)] - coeff * c[hook(32, 3)][hook(35, 2)];
  c[hook(32, 4)][hook(36, 0)] = c[hook(32, 4)][hook(36, 0)] - coeff * c[hook(32, 4)][hook(36, 2)];
  r[hook(37, 0)] = r[hook(37, 0)] - coeff * r[hook(37, 2)];

  coeff = lhs[hook(26, 2)][hook(28, 1)];
  lhs[hook(26, 3)][hook(29, 1)] = lhs[hook(26, 3)][hook(29, 1)] - coeff * lhs[hook(26, 3)][hook(29, 2)];
  lhs[hook(26, 4)][hook(30, 1)] = lhs[hook(26, 4)][hook(30, 1)] - coeff * lhs[hook(26, 4)][hook(30, 2)];
  c[hook(32, 0)][hook(31, 1)] = c[hook(32, 0)][hook(31, 1)] - coeff * c[hook(32, 0)][hook(31, 2)];
  c[hook(32, 1)][hook(33, 1)] = c[hook(32, 1)][hook(33, 1)] - coeff * c[hook(32, 1)][hook(33, 2)];
  c[hook(32, 2)][hook(34, 1)] = c[hook(32, 2)][hook(34, 1)] - coeff * c[hook(32, 2)][hook(34, 2)];
  c[hook(32, 3)][hook(35, 1)] = c[hook(32, 3)][hook(35, 1)] - coeff * c[hook(32, 3)][hook(35, 2)];
  c[hook(32, 4)][hook(36, 1)] = c[hook(32, 4)][hook(36, 1)] - coeff * c[hook(32, 4)][hook(36, 2)];
  r[hook(37, 1)] = r[hook(37, 1)] - coeff * r[hook(37, 2)];

  coeff = lhs[hook(26, 2)][hook(28, 3)];
  lhs[hook(26, 3)][hook(29, 3)] = lhs[hook(26, 3)][hook(29, 3)] - coeff * lhs[hook(26, 3)][hook(29, 2)];
  lhs[hook(26, 4)][hook(30, 3)] = lhs[hook(26, 4)][hook(30, 3)] - coeff * lhs[hook(26, 4)][hook(30, 2)];
  c[hook(32, 0)][hook(31, 3)] = c[hook(32, 0)][hook(31, 3)] - coeff * c[hook(32, 0)][hook(31, 2)];
  c[hook(32, 1)][hook(33, 3)] = c[hook(32, 1)][hook(33, 3)] - coeff * c[hook(32, 1)][hook(33, 2)];
  c[hook(32, 2)][hook(34, 3)] = c[hook(32, 2)][hook(34, 3)] - coeff * c[hook(32, 2)][hook(34, 2)];
  c[hook(32, 3)][hook(35, 3)] = c[hook(32, 3)][hook(35, 3)] - coeff * c[hook(32, 3)][hook(35, 2)];
  c[hook(32, 4)][hook(36, 3)] = c[hook(32, 4)][hook(36, 3)] - coeff * c[hook(32, 4)][hook(36, 2)];
  r[hook(37, 3)] = r[hook(37, 3)] - coeff * r[hook(37, 2)];

  coeff = lhs[hook(26, 2)][hook(28, 4)];
  lhs[hook(26, 3)][hook(29, 4)] = lhs[hook(26, 3)][hook(29, 4)] - coeff * lhs[hook(26, 3)][hook(29, 2)];
  lhs[hook(26, 4)][hook(30, 4)] = lhs[hook(26, 4)][hook(30, 4)] - coeff * lhs[hook(26, 4)][hook(30, 2)];
  c[hook(32, 0)][hook(31, 4)] = c[hook(32, 0)][hook(31, 4)] - coeff * c[hook(32, 0)][hook(31, 2)];
  c[hook(32, 1)][hook(33, 4)] = c[hook(32, 1)][hook(33, 4)] - coeff * c[hook(32, 1)][hook(33, 2)];
  c[hook(32, 2)][hook(34, 4)] = c[hook(32, 2)][hook(34, 4)] - coeff * c[hook(32, 2)][hook(34, 2)];
  c[hook(32, 3)][hook(35, 4)] = c[hook(32, 3)][hook(35, 4)] - coeff * c[hook(32, 3)][hook(35, 2)];
  c[hook(32, 4)][hook(36, 4)] = c[hook(32, 4)][hook(36, 4)] - coeff * c[hook(32, 4)][hook(36, 2)];
  r[hook(37, 4)] = r[hook(37, 4)] - coeff * r[hook(37, 2)];

  pivot = 1.00 / lhs[hook(26, 3)][hook(29, 3)];
  lhs[hook(26, 4)][hook(30, 3)] = lhs[hook(26, 4)][hook(30, 3)] * pivot;
  c[hook(32, 0)][hook(31, 3)] = c[hook(32, 0)][hook(31, 3)] * pivot;
  c[hook(32, 1)][hook(33, 3)] = c[hook(32, 1)][hook(33, 3)] * pivot;
  c[hook(32, 2)][hook(34, 3)] = c[hook(32, 2)][hook(34, 3)] * pivot;
  c[hook(32, 3)][hook(35, 3)] = c[hook(32, 3)][hook(35, 3)] * pivot;
  c[hook(32, 4)][hook(36, 3)] = c[hook(32, 4)][hook(36, 3)] * pivot;
  r[hook(37, 3)] = r[hook(37, 3)] * pivot;

  coeff = lhs[hook(26, 3)][hook(29, 0)];
  lhs[hook(26, 4)][hook(30, 0)] = lhs[hook(26, 4)][hook(30, 0)] - coeff * lhs[hook(26, 4)][hook(30, 3)];
  c[hook(32, 0)][hook(31, 0)] = c[hook(32, 0)][hook(31, 0)] - coeff * c[hook(32, 0)][hook(31, 3)];
  c[hook(32, 1)][hook(33, 0)] = c[hook(32, 1)][hook(33, 0)] - coeff * c[hook(32, 1)][hook(33, 3)];
  c[hook(32, 2)][hook(34, 0)] = c[hook(32, 2)][hook(34, 0)] - coeff * c[hook(32, 2)][hook(34, 3)];
  c[hook(32, 3)][hook(35, 0)] = c[hook(32, 3)][hook(35, 0)] - coeff * c[hook(32, 3)][hook(35, 3)];
  c[hook(32, 4)][hook(36, 0)] = c[hook(32, 4)][hook(36, 0)] - coeff * c[hook(32, 4)][hook(36, 3)];
  r[hook(37, 0)] = r[hook(37, 0)] - coeff * r[hook(37, 3)];

  coeff = lhs[hook(26, 3)][hook(29, 1)];
  lhs[hook(26, 4)][hook(30, 1)] = lhs[hook(26, 4)][hook(30, 1)] - coeff * lhs[hook(26, 4)][hook(30, 3)];
  c[hook(32, 0)][hook(31, 1)] = c[hook(32, 0)][hook(31, 1)] - coeff * c[hook(32, 0)][hook(31, 3)];
  c[hook(32, 1)][hook(33, 1)] = c[hook(32, 1)][hook(33, 1)] - coeff * c[hook(32, 1)][hook(33, 3)];
  c[hook(32, 2)][hook(34, 1)] = c[hook(32, 2)][hook(34, 1)] - coeff * c[hook(32, 2)][hook(34, 3)];
  c[hook(32, 3)][hook(35, 1)] = c[hook(32, 3)][hook(35, 1)] - coeff * c[hook(32, 3)][hook(35, 3)];
  c[hook(32, 4)][hook(36, 1)] = c[hook(32, 4)][hook(36, 1)] - coeff * c[hook(32, 4)][hook(36, 3)];
  r[hook(37, 1)] = r[hook(37, 1)] - coeff * r[hook(37, 3)];

  coeff = lhs[hook(26, 3)][hook(29, 2)];
  lhs[hook(26, 4)][hook(30, 2)] = lhs[hook(26, 4)][hook(30, 2)] - coeff * lhs[hook(26, 4)][hook(30, 3)];
  c[hook(32, 0)][hook(31, 2)] = c[hook(32, 0)][hook(31, 2)] - coeff * c[hook(32, 0)][hook(31, 3)];
  c[hook(32, 1)][hook(33, 2)] = c[hook(32, 1)][hook(33, 2)] - coeff * c[hook(32, 1)][hook(33, 3)];
  c[hook(32, 2)][hook(34, 2)] = c[hook(32, 2)][hook(34, 2)] - coeff * c[hook(32, 2)][hook(34, 3)];
  c[hook(32, 3)][hook(35, 2)] = c[hook(32, 3)][hook(35, 2)] - coeff * c[hook(32, 3)][hook(35, 3)];
  c[hook(32, 4)][hook(36, 2)] = c[hook(32, 4)][hook(36, 2)] - coeff * c[hook(32, 4)][hook(36, 3)];
  r[hook(37, 2)] = r[hook(37, 2)] - coeff * r[hook(37, 3)];

  coeff = lhs[hook(26, 3)][hook(29, 4)];
  lhs[hook(26, 4)][hook(30, 4)] = lhs[hook(26, 4)][hook(30, 4)] - coeff * lhs[hook(26, 4)][hook(30, 3)];
  c[hook(32, 0)][hook(31, 4)] = c[hook(32, 0)][hook(31, 4)] - coeff * c[hook(32, 0)][hook(31, 3)];
  c[hook(32, 1)][hook(33, 4)] = c[hook(32, 1)][hook(33, 4)] - coeff * c[hook(32, 1)][hook(33, 3)];
  c[hook(32, 2)][hook(34, 4)] = c[hook(32, 2)][hook(34, 4)] - coeff * c[hook(32, 2)][hook(34, 3)];
  c[hook(32, 3)][hook(35, 4)] = c[hook(32, 3)][hook(35, 4)] - coeff * c[hook(32, 3)][hook(35, 3)];
  c[hook(32, 4)][hook(36, 4)] = c[hook(32, 4)][hook(36, 4)] - coeff * c[hook(32, 4)][hook(36, 3)];
  r[hook(37, 4)] = r[hook(37, 4)] - coeff * r[hook(37, 3)];

  pivot = 1.00 / lhs[hook(26, 4)][hook(30, 4)];
  c[hook(32, 0)][hook(31, 4)] = c[hook(32, 0)][hook(31, 4)] * pivot;
  c[hook(32, 1)][hook(33, 4)] = c[hook(32, 1)][hook(33, 4)] * pivot;
  c[hook(32, 2)][hook(34, 4)] = c[hook(32, 2)][hook(34, 4)] * pivot;
  c[hook(32, 3)][hook(35, 4)] = c[hook(32, 3)][hook(35, 4)] * pivot;
  c[hook(32, 4)][hook(36, 4)] = c[hook(32, 4)][hook(36, 4)] * pivot;
  r[hook(37, 4)] = r[hook(37, 4)] * pivot;

  coeff = lhs[hook(26, 4)][hook(30, 0)];
  c[hook(32, 0)][hook(31, 0)] = c[hook(32, 0)][hook(31, 0)] - coeff * c[hook(32, 0)][hook(31, 4)];
  c[hook(32, 1)][hook(33, 0)] = c[hook(32, 1)][hook(33, 0)] - coeff * c[hook(32, 1)][hook(33, 4)];
  c[hook(32, 2)][hook(34, 0)] = c[hook(32, 2)][hook(34, 0)] - coeff * c[hook(32, 2)][hook(34, 4)];
  c[hook(32, 3)][hook(35, 0)] = c[hook(32, 3)][hook(35, 0)] - coeff * c[hook(32, 3)][hook(35, 4)];
  c[hook(32, 4)][hook(36, 0)] = c[hook(32, 4)][hook(36, 0)] - coeff * c[hook(32, 4)][hook(36, 4)];
  r[hook(37, 0)] = r[hook(37, 0)] - coeff * r[hook(37, 4)];

  coeff = lhs[hook(26, 4)][hook(30, 1)];
  c[hook(32, 0)][hook(31, 1)] = c[hook(32, 0)][hook(31, 1)] - coeff * c[hook(32, 0)][hook(31, 4)];
  c[hook(32, 1)][hook(33, 1)] = c[hook(32, 1)][hook(33, 1)] - coeff * c[hook(32, 1)][hook(33, 4)];
  c[hook(32, 2)][hook(34, 1)] = c[hook(32, 2)][hook(34, 1)] - coeff * c[hook(32, 2)][hook(34, 4)];
  c[hook(32, 3)][hook(35, 1)] = c[hook(32, 3)][hook(35, 1)] - coeff * c[hook(32, 3)][hook(35, 4)];
  c[hook(32, 4)][hook(36, 1)] = c[hook(32, 4)][hook(36, 1)] - coeff * c[hook(32, 4)][hook(36, 4)];
  r[hook(37, 1)] = r[hook(37, 1)] - coeff * r[hook(37, 4)];

  coeff = lhs[hook(26, 4)][hook(30, 2)];
  c[hook(32, 0)][hook(31, 2)] = c[hook(32, 0)][hook(31, 2)] - coeff * c[hook(32, 0)][hook(31, 4)];
  c[hook(32, 1)][hook(33, 2)] = c[hook(32, 1)][hook(33, 2)] - coeff * c[hook(32, 1)][hook(33, 4)];
  c[hook(32, 2)][hook(34, 2)] = c[hook(32, 2)][hook(34, 2)] - coeff * c[hook(32, 2)][hook(34, 4)];
  c[hook(32, 3)][hook(35, 2)] = c[hook(32, 3)][hook(35, 2)] - coeff * c[hook(32, 3)][hook(35, 4)];
  c[hook(32, 4)][hook(36, 2)] = c[hook(32, 4)][hook(36, 2)] - coeff * c[hook(32, 4)][hook(36, 4)];
  r[hook(37, 2)] = r[hook(37, 2)] - coeff * r[hook(37, 4)];

  coeff = lhs[hook(26, 4)][hook(30, 3)];
  c[hook(32, 0)][hook(31, 3)] = c[hook(32, 0)][hook(31, 3)] - coeff * c[hook(32, 0)][hook(31, 4)];
  c[hook(32, 1)][hook(33, 3)] = c[hook(32, 1)][hook(33, 3)] - coeff * c[hook(32, 1)][hook(33, 4)];
  c[hook(32, 2)][hook(34, 3)] = c[hook(32, 2)][hook(34, 3)] - coeff * c[hook(32, 2)][hook(34, 4)];
  c[hook(32, 3)][hook(35, 3)] = c[hook(32, 3)][hook(35, 3)] - coeff * c[hook(32, 3)][hook(35, 4)];
  c[hook(32, 4)][hook(36, 3)] = c[hook(32, 4)][hook(36, 3)] - coeff * c[hook(32, 4)][hook(36, 4)];
  r[hook(37, 3)] = r[hook(37, 3)] - coeff * r[hook(37, 4)];
}

void binvrhs(global double lhs[5][5], global double r[5]) {
  double pivot, coeff;

  pivot = 1.00 / lhs[hook(26, 0)][hook(25, 0)];
  lhs[hook(26, 1)][hook(27, 0)] = lhs[hook(26, 1)][hook(27, 0)] * pivot;
  lhs[hook(26, 2)][hook(28, 0)] = lhs[hook(26, 2)][hook(28, 0)] * pivot;
  lhs[hook(26, 3)][hook(29, 0)] = lhs[hook(26, 3)][hook(29, 0)] * pivot;
  lhs[hook(26, 4)][hook(30, 0)] = lhs[hook(26, 4)][hook(30, 0)] * pivot;
  r[hook(37, 0)] = r[hook(37, 0)] * pivot;

  coeff = lhs[hook(26, 0)][hook(25, 1)];
  lhs[hook(26, 1)][hook(27, 1)] = lhs[hook(26, 1)][hook(27, 1)] - coeff * lhs[hook(26, 1)][hook(27, 0)];
  lhs[hook(26, 2)][hook(28, 1)] = lhs[hook(26, 2)][hook(28, 1)] - coeff * lhs[hook(26, 2)][hook(28, 0)];
  lhs[hook(26, 3)][hook(29, 1)] = lhs[hook(26, 3)][hook(29, 1)] - coeff * lhs[hook(26, 3)][hook(29, 0)];
  lhs[hook(26, 4)][hook(30, 1)] = lhs[hook(26, 4)][hook(30, 1)] - coeff * lhs[hook(26, 4)][hook(30, 0)];
  r[hook(37, 1)] = r[hook(37, 1)] - coeff * r[hook(37, 0)];

  coeff = lhs[hook(26, 0)][hook(25, 2)];
  lhs[hook(26, 1)][hook(27, 2)] = lhs[hook(26, 1)][hook(27, 2)] - coeff * lhs[hook(26, 1)][hook(27, 0)];
  lhs[hook(26, 2)][hook(28, 2)] = lhs[hook(26, 2)][hook(28, 2)] - coeff * lhs[hook(26, 2)][hook(28, 0)];
  lhs[hook(26, 3)][hook(29, 2)] = lhs[hook(26, 3)][hook(29, 2)] - coeff * lhs[hook(26, 3)][hook(29, 0)];
  lhs[hook(26, 4)][hook(30, 2)] = lhs[hook(26, 4)][hook(30, 2)] - coeff * lhs[hook(26, 4)][hook(30, 0)];
  r[hook(37, 2)] = r[hook(37, 2)] - coeff * r[hook(37, 0)];

  coeff = lhs[hook(26, 0)][hook(25, 3)];
  lhs[hook(26, 1)][hook(27, 3)] = lhs[hook(26, 1)][hook(27, 3)] - coeff * lhs[hook(26, 1)][hook(27, 0)];
  lhs[hook(26, 2)][hook(28, 3)] = lhs[hook(26, 2)][hook(28, 3)] - coeff * lhs[hook(26, 2)][hook(28, 0)];
  lhs[hook(26, 3)][hook(29, 3)] = lhs[hook(26, 3)][hook(29, 3)] - coeff * lhs[hook(26, 3)][hook(29, 0)];
  lhs[hook(26, 4)][hook(30, 3)] = lhs[hook(26, 4)][hook(30, 3)] - coeff * lhs[hook(26, 4)][hook(30, 0)];
  r[hook(37, 3)] = r[hook(37, 3)] - coeff * r[hook(37, 0)];

  coeff = lhs[hook(26, 0)][hook(25, 4)];
  lhs[hook(26, 1)][hook(27, 4)] = lhs[hook(26, 1)][hook(27, 4)] - coeff * lhs[hook(26, 1)][hook(27, 0)];
  lhs[hook(26, 2)][hook(28, 4)] = lhs[hook(26, 2)][hook(28, 4)] - coeff * lhs[hook(26, 2)][hook(28, 0)];
  lhs[hook(26, 3)][hook(29, 4)] = lhs[hook(26, 3)][hook(29, 4)] - coeff * lhs[hook(26, 3)][hook(29, 0)];
  lhs[hook(26, 4)][hook(30, 4)] = lhs[hook(26, 4)][hook(30, 4)] - coeff * lhs[hook(26, 4)][hook(30, 0)];
  r[hook(37, 4)] = r[hook(37, 4)] - coeff * r[hook(37, 0)];

  pivot = 1.00 / lhs[hook(26, 1)][hook(27, 1)];
  lhs[hook(26, 2)][hook(28, 1)] = lhs[hook(26, 2)][hook(28, 1)] * pivot;
  lhs[hook(26, 3)][hook(29, 1)] = lhs[hook(26, 3)][hook(29, 1)] * pivot;
  lhs[hook(26, 4)][hook(30, 1)] = lhs[hook(26, 4)][hook(30, 1)] * pivot;
  r[hook(37, 1)] = r[hook(37, 1)] * pivot;

  coeff = lhs[hook(26, 1)][hook(27, 0)];
  lhs[hook(26, 2)][hook(28, 0)] = lhs[hook(26, 2)][hook(28, 0)] - coeff * lhs[hook(26, 2)][hook(28, 1)];
  lhs[hook(26, 3)][hook(29, 0)] = lhs[hook(26, 3)][hook(29, 0)] - coeff * lhs[hook(26, 3)][hook(29, 1)];
  lhs[hook(26, 4)][hook(30, 0)] = lhs[hook(26, 4)][hook(30, 0)] - coeff * lhs[hook(26, 4)][hook(30, 1)];
  r[hook(37, 0)] = r[hook(37, 0)] - coeff * r[hook(37, 1)];

  coeff = lhs[hook(26, 1)][hook(27, 2)];
  lhs[hook(26, 2)][hook(28, 2)] = lhs[hook(26, 2)][hook(28, 2)] - coeff * lhs[hook(26, 2)][hook(28, 1)];
  lhs[hook(26, 3)][hook(29, 2)] = lhs[hook(26, 3)][hook(29, 2)] - coeff * lhs[hook(26, 3)][hook(29, 1)];
  lhs[hook(26, 4)][hook(30, 2)] = lhs[hook(26, 4)][hook(30, 2)] - coeff * lhs[hook(26, 4)][hook(30, 1)];
  r[hook(37, 2)] = r[hook(37, 2)] - coeff * r[hook(37, 1)];

  coeff = lhs[hook(26, 1)][hook(27, 3)];
  lhs[hook(26, 2)][hook(28, 3)] = lhs[hook(26, 2)][hook(28, 3)] - coeff * lhs[hook(26, 2)][hook(28, 1)];
  lhs[hook(26, 3)][hook(29, 3)] = lhs[hook(26, 3)][hook(29, 3)] - coeff * lhs[hook(26, 3)][hook(29, 1)];
  lhs[hook(26, 4)][hook(30, 3)] = lhs[hook(26, 4)][hook(30, 3)] - coeff * lhs[hook(26, 4)][hook(30, 1)];
  r[hook(37, 3)] = r[hook(37, 3)] - coeff * r[hook(37, 1)];

  coeff = lhs[hook(26, 1)][hook(27, 4)];
  lhs[hook(26, 2)][hook(28, 4)] = lhs[hook(26, 2)][hook(28, 4)] - coeff * lhs[hook(26, 2)][hook(28, 1)];
  lhs[hook(26, 3)][hook(29, 4)] = lhs[hook(26, 3)][hook(29, 4)] - coeff * lhs[hook(26, 3)][hook(29, 1)];
  lhs[hook(26, 4)][hook(30, 4)] = lhs[hook(26, 4)][hook(30, 4)] - coeff * lhs[hook(26, 4)][hook(30, 1)];
  r[hook(37, 4)] = r[hook(37, 4)] - coeff * r[hook(37, 1)];

  pivot = 1.00 / lhs[hook(26, 2)][hook(28, 2)];
  lhs[hook(26, 3)][hook(29, 2)] = lhs[hook(26, 3)][hook(29, 2)] * pivot;
  lhs[hook(26, 4)][hook(30, 2)] = lhs[hook(26, 4)][hook(30, 2)] * pivot;
  r[hook(37, 2)] = r[hook(37, 2)] * pivot;

  coeff = lhs[hook(26, 2)][hook(28, 0)];
  lhs[hook(26, 3)][hook(29, 0)] = lhs[hook(26, 3)][hook(29, 0)] - coeff * lhs[hook(26, 3)][hook(29, 2)];
  lhs[hook(26, 4)][hook(30, 0)] = lhs[hook(26, 4)][hook(30, 0)] - coeff * lhs[hook(26, 4)][hook(30, 2)];
  r[hook(37, 0)] = r[hook(37, 0)] - coeff * r[hook(37, 2)];

  coeff = lhs[hook(26, 2)][hook(28, 1)];
  lhs[hook(26, 3)][hook(29, 1)] = lhs[hook(26, 3)][hook(29, 1)] - coeff * lhs[hook(26, 3)][hook(29, 2)];
  lhs[hook(26, 4)][hook(30, 1)] = lhs[hook(26, 4)][hook(30, 1)] - coeff * lhs[hook(26, 4)][hook(30, 2)];
  r[hook(37, 1)] = r[hook(37, 1)] - coeff * r[hook(37, 2)];

  coeff = lhs[hook(26, 2)][hook(28, 3)];
  lhs[hook(26, 3)][hook(29, 3)] = lhs[hook(26, 3)][hook(29, 3)] - coeff * lhs[hook(26, 3)][hook(29, 2)];
  lhs[hook(26, 4)][hook(30, 3)] = lhs[hook(26, 4)][hook(30, 3)] - coeff * lhs[hook(26, 4)][hook(30, 2)];
  r[hook(37, 3)] = r[hook(37, 3)] - coeff * r[hook(37, 2)];

  coeff = lhs[hook(26, 2)][hook(28, 4)];
  lhs[hook(26, 3)][hook(29, 4)] = lhs[hook(26, 3)][hook(29, 4)] - coeff * lhs[hook(26, 3)][hook(29, 2)];
  lhs[hook(26, 4)][hook(30, 4)] = lhs[hook(26, 4)][hook(30, 4)] - coeff * lhs[hook(26, 4)][hook(30, 2)];
  r[hook(37, 4)] = r[hook(37, 4)] - coeff * r[hook(37, 2)];

  pivot = 1.00 / lhs[hook(26, 3)][hook(29, 3)];
  lhs[hook(26, 4)][hook(30, 3)] = lhs[hook(26, 4)][hook(30, 3)] * pivot;
  r[hook(37, 3)] = r[hook(37, 3)] * pivot;

  coeff = lhs[hook(26, 3)][hook(29, 0)];
  lhs[hook(26, 4)][hook(30, 0)] = lhs[hook(26, 4)][hook(30, 0)] - coeff * lhs[hook(26, 4)][hook(30, 3)];
  r[hook(37, 0)] = r[hook(37, 0)] - coeff * r[hook(37, 3)];

  coeff = lhs[hook(26, 3)][hook(29, 1)];
  lhs[hook(26, 4)][hook(30, 1)] = lhs[hook(26, 4)][hook(30, 1)] - coeff * lhs[hook(26, 4)][hook(30, 3)];
  r[hook(37, 1)] = r[hook(37, 1)] - coeff * r[hook(37, 3)];

  coeff = lhs[hook(26, 3)][hook(29, 2)];
  lhs[hook(26, 4)][hook(30, 2)] = lhs[hook(26, 4)][hook(30, 2)] - coeff * lhs[hook(26, 4)][hook(30, 3)];
  r[hook(37, 2)] = r[hook(37, 2)] - coeff * r[hook(37, 3)];

  coeff = lhs[hook(26, 3)][hook(29, 4)];
  lhs[hook(26, 4)][hook(30, 4)] = lhs[hook(26, 4)][hook(30, 4)] - coeff * lhs[hook(26, 4)][hook(30, 3)];
  r[hook(37, 4)] = r[hook(37, 4)] - coeff * r[hook(37, 3)];

  pivot = 1.00 / lhs[hook(26, 4)][hook(30, 4)];
  r[hook(37, 4)] = r[hook(37, 4)] * pivot;

  coeff = lhs[hook(26, 4)][hook(30, 0)];
  r[hook(37, 0)] = r[hook(37, 0)] - coeff * r[hook(37, 4)];

  coeff = lhs[hook(26, 4)][hook(30, 1)];
  r[hook(37, 1)] = r[hook(37, 1)] - coeff * r[hook(37, 4)];

  coeff = lhs[hook(26, 4)][hook(30, 2)];
  r[hook(37, 2)] = r[hook(37, 2)] - coeff * r[hook(37, 4)];

  coeff = lhs[hook(26, 4)][hook(30, 3)];
  r[hook(37, 3)] = r[hook(37, 3)] - coeff * r[hook(37, 4)];
}

kernel void y_solve(global double* g_rhs, global double* g_lhs, int gp0, int gp1, int gp2) {
  int i, j, k, m, n, jsize;

  k = get_global_id(1) + 1;
  i = get_global_id(0) + 1;
  if (k > (gp2 - 2) || i > (gp0 - 2))
    return;

  global double(*rhs)[64 / 2 * 2 + 1][64 / 2 * 2 + 1][5] = (global double(*)[64 / 2 * 2 + 1][64 / 2 * 2 + 1][5]) g_rhs;

  int my_id = (k - 1) * (gp0 - 2) + (i - 1);
  int my_offset = my_id * (64 + 1) * 3 * 5 * 5;
  global double(*lhs)[3][5][5] = (global double(*)[3][5][5]) & g_lhs[hook(1, my_offset)];

  jsize = gp1 - 1;
  binvcrhs(lhs[hook(26, 0)][hook(25, 1)], lhs[hook(26, 0)][hook(25, 2)], rhs[hook(40, k)][hook(39, 0)][hook(38, i)]);

  for (j = 1; j <= jsize - 1; j++) {
    matvec_sub(lhs[hook(26, j)][hook(41, 0)], rhs[hook(40, k)][hook(39, j - 1)][hook(42, i)], rhs[hook(40, k)][hook(39, j)][hook(43, i)]);

    matmul_sub(lhs[hook(26, j)][hook(41, 0)], lhs[hook(26, j - 1)][hook(44, 2)], lhs[hook(26, j)][hook(41, 1)]);

    binvcrhs(lhs[hook(26, j)][hook(41, 1)], lhs[hook(26, j)][hook(41, 2)], rhs[hook(40, k)][hook(39, j)][hook(43, i)]);
  }

  matvec_sub(lhs[hook(26, jsize)][hook(45, 0)], rhs[hook(40, k)][hook(39, jsize - 1)][hook(46, i)], rhs[hook(40, k)][hook(39, jsize)][hook(47, i)]);

  matmul_sub(lhs[hook(26, jsize)][hook(45, 0)], lhs[hook(26, jsize - 1)][hook(48, 2)], lhs[hook(26, jsize)][hook(45, 1)]);

  binvrhs(lhs[hook(26, jsize)][hook(45, 1)], rhs[hook(40, k)][hook(39, jsize)][hook(47, i)]);

  for (j = jsize - 1; j >= 0; j--) {
    for (m = 0; m < 5; m++) {
      for (n = 0; n < 5; n++) {
        rhs[hook(40, k)][hook(39, j)][hook(43, i)][hook(49, m)] = rhs[hook(40, k)][hook(39, j)][hook(43, i)][hook(49, m)] - lhs[hook(26, j)][hook(41, 2)][hook(51, n)][hook(50, m)] * rhs[hook(40, k)][hook(39, j + 1)][hook(53, i)][hook(52, n)];
      }
    }
  }
}