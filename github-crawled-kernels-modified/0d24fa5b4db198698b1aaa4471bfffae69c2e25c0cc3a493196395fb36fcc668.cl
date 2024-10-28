//{"ablock":10,"ablock[0]":9,"ablock[1]":12,"ablock[2]":13,"ablock[3]":14,"ablock[4]":15,"avec":11,"bblock":19,"bblock[0]":18,"bblock[1]":21,"bblock[2]":23,"bblock[3]":25,"bblock[4]":27,"bvec":8,"c":35,"c[0]":34,"c[1]":36,"c[2]":37,"c[3]":38,"c[4]":39,"cblock":17,"cblock[0]":16,"cblock[1]":20,"cblock[2]":22,"cblock[3]":24,"cblock[4]":26,"fjac":47,"fjac[k]":46,"fjac[k][0]":45,"fjac[k][1]":48,"fjac[k][2]":49,"fjac[k][3]":50,"fjac[k][4]":51,"g_fjac":3,"g_njac":4,"g_qs":0,"g_square":1,"g_u":2,"gp0":5,"gp1":6,"gp2":7,"lhs":29,"lhs[0]":28,"lhs[1]":30,"lhs[2]":31,"lhs[3]":32,"lhs[4]":33,"njac":60,"njac[k]":59,"njac[k][0]":58,"njac[k][1]":61,"njac[k][2]":62,"njac[k][3]":63,"njac[k][4]":64,"qs":54,"qs[k]":53,"qs[k][j]":52,"r":40,"square":57,"square[k]":56,"square[k][j]":55,"u":44,"u[k]":43,"u[k][j]":42,"u[k][j][i]":41}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void matvec_sub(global double ablock[5][5], global double avec[5], global double bvec[5]) {
  bvec[hook(8, 0)] = bvec[hook(8, 0)] - ablock[hook(10, 0)][hook(9, 0)] * avec[hook(11, 0)] - ablock[hook(10, 1)][hook(12, 0)] * avec[hook(11, 1)] - ablock[hook(10, 2)][hook(13, 0)] * avec[hook(11, 2)] - ablock[hook(10, 3)][hook(14, 0)] * avec[hook(11, 3)] - ablock[hook(10, 4)][hook(15, 0)] * avec[hook(11, 4)];
  bvec[hook(8, 1)] = bvec[hook(8, 1)] - ablock[hook(10, 0)][hook(9, 1)] * avec[hook(11, 0)] - ablock[hook(10, 1)][hook(12, 1)] * avec[hook(11, 1)] - ablock[hook(10, 2)][hook(13, 1)] * avec[hook(11, 2)] - ablock[hook(10, 3)][hook(14, 1)] * avec[hook(11, 3)] - ablock[hook(10, 4)][hook(15, 1)] * avec[hook(11, 4)];
  bvec[hook(8, 2)] = bvec[hook(8, 2)] - ablock[hook(10, 0)][hook(9, 2)] * avec[hook(11, 0)] - ablock[hook(10, 1)][hook(12, 2)] * avec[hook(11, 1)] - ablock[hook(10, 2)][hook(13, 2)] * avec[hook(11, 2)] - ablock[hook(10, 3)][hook(14, 2)] * avec[hook(11, 3)] - ablock[hook(10, 4)][hook(15, 2)] * avec[hook(11, 4)];
  bvec[hook(8, 3)] = bvec[hook(8, 3)] - ablock[hook(10, 0)][hook(9, 3)] * avec[hook(11, 0)] - ablock[hook(10, 1)][hook(12, 3)] * avec[hook(11, 1)] - ablock[hook(10, 2)][hook(13, 3)] * avec[hook(11, 2)] - ablock[hook(10, 3)][hook(14, 3)] * avec[hook(11, 3)] - ablock[hook(10, 4)][hook(15, 3)] * avec[hook(11, 4)];
  bvec[hook(8, 4)] = bvec[hook(8, 4)] - ablock[hook(10, 0)][hook(9, 4)] * avec[hook(11, 0)] - ablock[hook(10, 1)][hook(12, 4)] * avec[hook(11, 1)] - ablock[hook(10, 2)][hook(13, 4)] * avec[hook(11, 2)] - ablock[hook(10, 3)][hook(14, 4)] * avec[hook(11, 3)] - ablock[hook(10, 4)][hook(15, 4)] * avec[hook(11, 4)];
}

void matmul_sub(global double ablock[5][5], global double bblock[5][5], global double cblock[5][5]) {
  cblock[hook(17, 0)][hook(16, 0)] = cblock[hook(17, 0)][hook(16, 0)] - ablock[hook(10, 0)][hook(9, 0)] * bblock[hook(19, 0)][hook(18, 0)] - ablock[hook(10, 1)][hook(12, 0)] * bblock[hook(19, 0)][hook(18, 1)] - ablock[hook(10, 2)][hook(13, 0)] * bblock[hook(19, 0)][hook(18, 2)] - ablock[hook(10, 3)][hook(14, 0)] * bblock[hook(19, 0)][hook(18, 3)] - ablock[hook(10, 4)][hook(15, 0)] * bblock[hook(19, 0)][hook(18, 4)];
  cblock[hook(17, 0)][hook(16, 1)] = cblock[hook(17, 0)][hook(16, 1)] - ablock[hook(10, 0)][hook(9, 1)] * bblock[hook(19, 0)][hook(18, 0)] - ablock[hook(10, 1)][hook(12, 1)] * bblock[hook(19, 0)][hook(18, 1)] - ablock[hook(10, 2)][hook(13, 1)] * bblock[hook(19, 0)][hook(18, 2)] - ablock[hook(10, 3)][hook(14, 1)] * bblock[hook(19, 0)][hook(18, 3)] - ablock[hook(10, 4)][hook(15, 1)] * bblock[hook(19, 0)][hook(18, 4)];
  cblock[hook(17, 0)][hook(16, 2)] = cblock[hook(17, 0)][hook(16, 2)] - ablock[hook(10, 0)][hook(9, 2)] * bblock[hook(19, 0)][hook(18, 0)] - ablock[hook(10, 1)][hook(12, 2)] * bblock[hook(19, 0)][hook(18, 1)] - ablock[hook(10, 2)][hook(13, 2)] * bblock[hook(19, 0)][hook(18, 2)] - ablock[hook(10, 3)][hook(14, 2)] * bblock[hook(19, 0)][hook(18, 3)] - ablock[hook(10, 4)][hook(15, 2)] * bblock[hook(19, 0)][hook(18, 4)];
  cblock[hook(17, 0)][hook(16, 3)] = cblock[hook(17, 0)][hook(16, 3)] - ablock[hook(10, 0)][hook(9, 3)] * bblock[hook(19, 0)][hook(18, 0)] - ablock[hook(10, 1)][hook(12, 3)] * bblock[hook(19, 0)][hook(18, 1)] - ablock[hook(10, 2)][hook(13, 3)] * bblock[hook(19, 0)][hook(18, 2)] - ablock[hook(10, 3)][hook(14, 3)] * bblock[hook(19, 0)][hook(18, 3)] - ablock[hook(10, 4)][hook(15, 3)] * bblock[hook(19, 0)][hook(18, 4)];
  cblock[hook(17, 0)][hook(16, 4)] = cblock[hook(17, 0)][hook(16, 4)] - ablock[hook(10, 0)][hook(9, 4)] * bblock[hook(19, 0)][hook(18, 0)] - ablock[hook(10, 1)][hook(12, 4)] * bblock[hook(19, 0)][hook(18, 1)] - ablock[hook(10, 2)][hook(13, 4)] * bblock[hook(19, 0)][hook(18, 2)] - ablock[hook(10, 3)][hook(14, 4)] * bblock[hook(19, 0)][hook(18, 3)] - ablock[hook(10, 4)][hook(15, 4)] * bblock[hook(19, 0)][hook(18, 4)];
  cblock[hook(17, 1)][hook(20, 0)] = cblock[hook(17, 1)][hook(20, 0)] - ablock[hook(10, 0)][hook(9, 0)] * bblock[hook(19, 1)][hook(21, 0)] - ablock[hook(10, 1)][hook(12, 0)] * bblock[hook(19, 1)][hook(21, 1)] - ablock[hook(10, 2)][hook(13, 0)] * bblock[hook(19, 1)][hook(21, 2)] - ablock[hook(10, 3)][hook(14, 0)] * bblock[hook(19, 1)][hook(21, 3)] - ablock[hook(10, 4)][hook(15, 0)] * bblock[hook(19, 1)][hook(21, 4)];
  cblock[hook(17, 1)][hook(20, 1)] = cblock[hook(17, 1)][hook(20, 1)] - ablock[hook(10, 0)][hook(9, 1)] * bblock[hook(19, 1)][hook(21, 0)] - ablock[hook(10, 1)][hook(12, 1)] * bblock[hook(19, 1)][hook(21, 1)] - ablock[hook(10, 2)][hook(13, 1)] * bblock[hook(19, 1)][hook(21, 2)] - ablock[hook(10, 3)][hook(14, 1)] * bblock[hook(19, 1)][hook(21, 3)] - ablock[hook(10, 4)][hook(15, 1)] * bblock[hook(19, 1)][hook(21, 4)];
  cblock[hook(17, 1)][hook(20, 2)] = cblock[hook(17, 1)][hook(20, 2)] - ablock[hook(10, 0)][hook(9, 2)] * bblock[hook(19, 1)][hook(21, 0)] - ablock[hook(10, 1)][hook(12, 2)] * bblock[hook(19, 1)][hook(21, 1)] - ablock[hook(10, 2)][hook(13, 2)] * bblock[hook(19, 1)][hook(21, 2)] - ablock[hook(10, 3)][hook(14, 2)] * bblock[hook(19, 1)][hook(21, 3)] - ablock[hook(10, 4)][hook(15, 2)] * bblock[hook(19, 1)][hook(21, 4)];
  cblock[hook(17, 1)][hook(20, 3)] = cblock[hook(17, 1)][hook(20, 3)] - ablock[hook(10, 0)][hook(9, 3)] * bblock[hook(19, 1)][hook(21, 0)] - ablock[hook(10, 1)][hook(12, 3)] * bblock[hook(19, 1)][hook(21, 1)] - ablock[hook(10, 2)][hook(13, 3)] * bblock[hook(19, 1)][hook(21, 2)] - ablock[hook(10, 3)][hook(14, 3)] * bblock[hook(19, 1)][hook(21, 3)] - ablock[hook(10, 4)][hook(15, 3)] * bblock[hook(19, 1)][hook(21, 4)];
  cblock[hook(17, 1)][hook(20, 4)] = cblock[hook(17, 1)][hook(20, 4)] - ablock[hook(10, 0)][hook(9, 4)] * bblock[hook(19, 1)][hook(21, 0)] - ablock[hook(10, 1)][hook(12, 4)] * bblock[hook(19, 1)][hook(21, 1)] - ablock[hook(10, 2)][hook(13, 4)] * bblock[hook(19, 1)][hook(21, 2)] - ablock[hook(10, 3)][hook(14, 4)] * bblock[hook(19, 1)][hook(21, 3)] - ablock[hook(10, 4)][hook(15, 4)] * bblock[hook(19, 1)][hook(21, 4)];
  cblock[hook(17, 2)][hook(22, 0)] = cblock[hook(17, 2)][hook(22, 0)] - ablock[hook(10, 0)][hook(9, 0)] * bblock[hook(19, 2)][hook(23, 0)] - ablock[hook(10, 1)][hook(12, 0)] * bblock[hook(19, 2)][hook(23, 1)] - ablock[hook(10, 2)][hook(13, 0)] * bblock[hook(19, 2)][hook(23, 2)] - ablock[hook(10, 3)][hook(14, 0)] * bblock[hook(19, 2)][hook(23, 3)] - ablock[hook(10, 4)][hook(15, 0)] * bblock[hook(19, 2)][hook(23, 4)];
  cblock[hook(17, 2)][hook(22, 1)] = cblock[hook(17, 2)][hook(22, 1)] - ablock[hook(10, 0)][hook(9, 1)] * bblock[hook(19, 2)][hook(23, 0)] - ablock[hook(10, 1)][hook(12, 1)] * bblock[hook(19, 2)][hook(23, 1)] - ablock[hook(10, 2)][hook(13, 1)] * bblock[hook(19, 2)][hook(23, 2)] - ablock[hook(10, 3)][hook(14, 1)] * bblock[hook(19, 2)][hook(23, 3)] - ablock[hook(10, 4)][hook(15, 1)] * bblock[hook(19, 2)][hook(23, 4)];
  cblock[hook(17, 2)][hook(22, 2)] = cblock[hook(17, 2)][hook(22, 2)] - ablock[hook(10, 0)][hook(9, 2)] * bblock[hook(19, 2)][hook(23, 0)] - ablock[hook(10, 1)][hook(12, 2)] * bblock[hook(19, 2)][hook(23, 1)] - ablock[hook(10, 2)][hook(13, 2)] * bblock[hook(19, 2)][hook(23, 2)] - ablock[hook(10, 3)][hook(14, 2)] * bblock[hook(19, 2)][hook(23, 3)] - ablock[hook(10, 4)][hook(15, 2)] * bblock[hook(19, 2)][hook(23, 4)];
  cblock[hook(17, 2)][hook(22, 3)] = cblock[hook(17, 2)][hook(22, 3)] - ablock[hook(10, 0)][hook(9, 3)] * bblock[hook(19, 2)][hook(23, 0)] - ablock[hook(10, 1)][hook(12, 3)] * bblock[hook(19, 2)][hook(23, 1)] - ablock[hook(10, 2)][hook(13, 3)] * bblock[hook(19, 2)][hook(23, 2)] - ablock[hook(10, 3)][hook(14, 3)] * bblock[hook(19, 2)][hook(23, 3)] - ablock[hook(10, 4)][hook(15, 3)] * bblock[hook(19, 2)][hook(23, 4)];
  cblock[hook(17, 2)][hook(22, 4)] = cblock[hook(17, 2)][hook(22, 4)] - ablock[hook(10, 0)][hook(9, 4)] * bblock[hook(19, 2)][hook(23, 0)] - ablock[hook(10, 1)][hook(12, 4)] * bblock[hook(19, 2)][hook(23, 1)] - ablock[hook(10, 2)][hook(13, 4)] * bblock[hook(19, 2)][hook(23, 2)] - ablock[hook(10, 3)][hook(14, 4)] * bblock[hook(19, 2)][hook(23, 3)] - ablock[hook(10, 4)][hook(15, 4)] * bblock[hook(19, 2)][hook(23, 4)];
  cblock[hook(17, 3)][hook(24, 0)] = cblock[hook(17, 3)][hook(24, 0)] - ablock[hook(10, 0)][hook(9, 0)] * bblock[hook(19, 3)][hook(25, 0)] - ablock[hook(10, 1)][hook(12, 0)] * bblock[hook(19, 3)][hook(25, 1)] - ablock[hook(10, 2)][hook(13, 0)] * bblock[hook(19, 3)][hook(25, 2)] - ablock[hook(10, 3)][hook(14, 0)] * bblock[hook(19, 3)][hook(25, 3)] - ablock[hook(10, 4)][hook(15, 0)] * bblock[hook(19, 3)][hook(25, 4)];
  cblock[hook(17, 3)][hook(24, 1)] = cblock[hook(17, 3)][hook(24, 1)] - ablock[hook(10, 0)][hook(9, 1)] * bblock[hook(19, 3)][hook(25, 0)] - ablock[hook(10, 1)][hook(12, 1)] * bblock[hook(19, 3)][hook(25, 1)] - ablock[hook(10, 2)][hook(13, 1)] * bblock[hook(19, 3)][hook(25, 2)] - ablock[hook(10, 3)][hook(14, 1)] * bblock[hook(19, 3)][hook(25, 3)] - ablock[hook(10, 4)][hook(15, 1)] * bblock[hook(19, 3)][hook(25, 4)];
  cblock[hook(17, 3)][hook(24, 2)] = cblock[hook(17, 3)][hook(24, 2)] - ablock[hook(10, 0)][hook(9, 2)] * bblock[hook(19, 3)][hook(25, 0)] - ablock[hook(10, 1)][hook(12, 2)] * bblock[hook(19, 3)][hook(25, 1)] - ablock[hook(10, 2)][hook(13, 2)] * bblock[hook(19, 3)][hook(25, 2)] - ablock[hook(10, 3)][hook(14, 2)] * bblock[hook(19, 3)][hook(25, 3)] - ablock[hook(10, 4)][hook(15, 2)] * bblock[hook(19, 3)][hook(25, 4)];
  cblock[hook(17, 3)][hook(24, 3)] = cblock[hook(17, 3)][hook(24, 3)] - ablock[hook(10, 0)][hook(9, 3)] * bblock[hook(19, 3)][hook(25, 0)] - ablock[hook(10, 1)][hook(12, 3)] * bblock[hook(19, 3)][hook(25, 1)] - ablock[hook(10, 2)][hook(13, 3)] * bblock[hook(19, 3)][hook(25, 2)] - ablock[hook(10, 3)][hook(14, 3)] * bblock[hook(19, 3)][hook(25, 3)] - ablock[hook(10, 4)][hook(15, 3)] * bblock[hook(19, 3)][hook(25, 4)];
  cblock[hook(17, 3)][hook(24, 4)] = cblock[hook(17, 3)][hook(24, 4)] - ablock[hook(10, 0)][hook(9, 4)] * bblock[hook(19, 3)][hook(25, 0)] - ablock[hook(10, 1)][hook(12, 4)] * bblock[hook(19, 3)][hook(25, 1)] - ablock[hook(10, 2)][hook(13, 4)] * bblock[hook(19, 3)][hook(25, 2)] - ablock[hook(10, 3)][hook(14, 4)] * bblock[hook(19, 3)][hook(25, 3)] - ablock[hook(10, 4)][hook(15, 4)] * bblock[hook(19, 3)][hook(25, 4)];
  cblock[hook(17, 4)][hook(26, 0)] = cblock[hook(17, 4)][hook(26, 0)] - ablock[hook(10, 0)][hook(9, 0)] * bblock[hook(19, 4)][hook(27, 0)] - ablock[hook(10, 1)][hook(12, 0)] * bblock[hook(19, 4)][hook(27, 1)] - ablock[hook(10, 2)][hook(13, 0)] * bblock[hook(19, 4)][hook(27, 2)] - ablock[hook(10, 3)][hook(14, 0)] * bblock[hook(19, 4)][hook(27, 3)] - ablock[hook(10, 4)][hook(15, 0)] * bblock[hook(19, 4)][hook(27, 4)];
  cblock[hook(17, 4)][hook(26, 1)] = cblock[hook(17, 4)][hook(26, 1)] - ablock[hook(10, 0)][hook(9, 1)] * bblock[hook(19, 4)][hook(27, 0)] - ablock[hook(10, 1)][hook(12, 1)] * bblock[hook(19, 4)][hook(27, 1)] - ablock[hook(10, 2)][hook(13, 1)] * bblock[hook(19, 4)][hook(27, 2)] - ablock[hook(10, 3)][hook(14, 1)] * bblock[hook(19, 4)][hook(27, 3)] - ablock[hook(10, 4)][hook(15, 1)] * bblock[hook(19, 4)][hook(27, 4)];
  cblock[hook(17, 4)][hook(26, 2)] = cblock[hook(17, 4)][hook(26, 2)] - ablock[hook(10, 0)][hook(9, 2)] * bblock[hook(19, 4)][hook(27, 0)] - ablock[hook(10, 1)][hook(12, 2)] * bblock[hook(19, 4)][hook(27, 1)] - ablock[hook(10, 2)][hook(13, 2)] * bblock[hook(19, 4)][hook(27, 2)] - ablock[hook(10, 3)][hook(14, 2)] * bblock[hook(19, 4)][hook(27, 3)] - ablock[hook(10, 4)][hook(15, 2)] * bblock[hook(19, 4)][hook(27, 4)];
  cblock[hook(17, 4)][hook(26, 3)] = cblock[hook(17, 4)][hook(26, 3)] - ablock[hook(10, 0)][hook(9, 3)] * bblock[hook(19, 4)][hook(27, 0)] - ablock[hook(10, 1)][hook(12, 3)] * bblock[hook(19, 4)][hook(27, 1)] - ablock[hook(10, 2)][hook(13, 3)] * bblock[hook(19, 4)][hook(27, 2)] - ablock[hook(10, 3)][hook(14, 3)] * bblock[hook(19, 4)][hook(27, 3)] - ablock[hook(10, 4)][hook(15, 3)] * bblock[hook(19, 4)][hook(27, 4)];
  cblock[hook(17, 4)][hook(26, 4)] = cblock[hook(17, 4)][hook(26, 4)] - ablock[hook(10, 0)][hook(9, 4)] * bblock[hook(19, 4)][hook(27, 0)] - ablock[hook(10, 1)][hook(12, 4)] * bblock[hook(19, 4)][hook(27, 1)] - ablock[hook(10, 2)][hook(13, 4)] * bblock[hook(19, 4)][hook(27, 2)] - ablock[hook(10, 3)][hook(14, 4)] * bblock[hook(19, 4)][hook(27, 3)] - ablock[hook(10, 4)][hook(15, 4)] * bblock[hook(19, 4)][hook(27, 4)];
}

void binvcrhs(global double lhs[5][5], global double c[5][5], global double r[5]) {
  double pivot, coeff;

  pivot = 1.00 / lhs[hook(29, 0)][hook(28, 0)];
  lhs[hook(29, 1)][hook(30, 0)] = lhs[hook(29, 1)][hook(30, 0)] * pivot;
  lhs[hook(29, 2)][hook(31, 0)] = lhs[hook(29, 2)][hook(31, 0)] * pivot;
  lhs[hook(29, 3)][hook(32, 0)] = lhs[hook(29, 3)][hook(32, 0)] * pivot;
  lhs[hook(29, 4)][hook(33, 0)] = lhs[hook(29, 4)][hook(33, 0)] * pivot;
  c[hook(35, 0)][hook(34, 0)] = c[hook(35, 0)][hook(34, 0)] * pivot;
  c[hook(35, 1)][hook(36, 0)] = c[hook(35, 1)][hook(36, 0)] * pivot;
  c[hook(35, 2)][hook(37, 0)] = c[hook(35, 2)][hook(37, 0)] * pivot;
  c[hook(35, 3)][hook(38, 0)] = c[hook(35, 3)][hook(38, 0)] * pivot;
  c[hook(35, 4)][hook(39, 0)] = c[hook(35, 4)][hook(39, 0)] * pivot;
  r[hook(40, 0)] = r[hook(40, 0)] * pivot;

  coeff = lhs[hook(29, 0)][hook(28, 1)];
  lhs[hook(29, 1)][hook(30, 1)] = lhs[hook(29, 1)][hook(30, 1)] - coeff * lhs[hook(29, 1)][hook(30, 0)];
  lhs[hook(29, 2)][hook(31, 1)] = lhs[hook(29, 2)][hook(31, 1)] - coeff * lhs[hook(29, 2)][hook(31, 0)];
  lhs[hook(29, 3)][hook(32, 1)] = lhs[hook(29, 3)][hook(32, 1)] - coeff * lhs[hook(29, 3)][hook(32, 0)];
  lhs[hook(29, 4)][hook(33, 1)] = lhs[hook(29, 4)][hook(33, 1)] - coeff * lhs[hook(29, 4)][hook(33, 0)];
  c[hook(35, 0)][hook(34, 1)] = c[hook(35, 0)][hook(34, 1)] - coeff * c[hook(35, 0)][hook(34, 0)];
  c[hook(35, 1)][hook(36, 1)] = c[hook(35, 1)][hook(36, 1)] - coeff * c[hook(35, 1)][hook(36, 0)];
  c[hook(35, 2)][hook(37, 1)] = c[hook(35, 2)][hook(37, 1)] - coeff * c[hook(35, 2)][hook(37, 0)];
  c[hook(35, 3)][hook(38, 1)] = c[hook(35, 3)][hook(38, 1)] - coeff * c[hook(35, 3)][hook(38, 0)];
  c[hook(35, 4)][hook(39, 1)] = c[hook(35, 4)][hook(39, 1)] - coeff * c[hook(35, 4)][hook(39, 0)];
  r[hook(40, 1)] = r[hook(40, 1)] - coeff * r[hook(40, 0)];

  coeff = lhs[hook(29, 0)][hook(28, 2)];
  lhs[hook(29, 1)][hook(30, 2)] = lhs[hook(29, 1)][hook(30, 2)] - coeff * lhs[hook(29, 1)][hook(30, 0)];
  lhs[hook(29, 2)][hook(31, 2)] = lhs[hook(29, 2)][hook(31, 2)] - coeff * lhs[hook(29, 2)][hook(31, 0)];
  lhs[hook(29, 3)][hook(32, 2)] = lhs[hook(29, 3)][hook(32, 2)] - coeff * lhs[hook(29, 3)][hook(32, 0)];
  lhs[hook(29, 4)][hook(33, 2)] = lhs[hook(29, 4)][hook(33, 2)] - coeff * lhs[hook(29, 4)][hook(33, 0)];
  c[hook(35, 0)][hook(34, 2)] = c[hook(35, 0)][hook(34, 2)] - coeff * c[hook(35, 0)][hook(34, 0)];
  c[hook(35, 1)][hook(36, 2)] = c[hook(35, 1)][hook(36, 2)] - coeff * c[hook(35, 1)][hook(36, 0)];
  c[hook(35, 2)][hook(37, 2)] = c[hook(35, 2)][hook(37, 2)] - coeff * c[hook(35, 2)][hook(37, 0)];
  c[hook(35, 3)][hook(38, 2)] = c[hook(35, 3)][hook(38, 2)] - coeff * c[hook(35, 3)][hook(38, 0)];
  c[hook(35, 4)][hook(39, 2)] = c[hook(35, 4)][hook(39, 2)] - coeff * c[hook(35, 4)][hook(39, 0)];
  r[hook(40, 2)] = r[hook(40, 2)] - coeff * r[hook(40, 0)];

  coeff = lhs[hook(29, 0)][hook(28, 3)];
  lhs[hook(29, 1)][hook(30, 3)] = lhs[hook(29, 1)][hook(30, 3)] - coeff * lhs[hook(29, 1)][hook(30, 0)];
  lhs[hook(29, 2)][hook(31, 3)] = lhs[hook(29, 2)][hook(31, 3)] - coeff * lhs[hook(29, 2)][hook(31, 0)];
  lhs[hook(29, 3)][hook(32, 3)] = lhs[hook(29, 3)][hook(32, 3)] - coeff * lhs[hook(29, 3)][hook(32, 0)];
  lhs[hook(29, 4)][hook(33, 3)] = lhs[hook(29, 4)][hook(33, 3)] - coeff * lhs[hook(29, 4)][hook(33, 0)];
  c[hook(35, 0)][hook(34, 3)] = c[hook(35, 0)][hook(34, 3)] - coeff * c[hook(35, 0)][hook(34, 0)];
  c[hook(35, 1)][hook(36, 3)] = c[hook(35, 1)][hook(36, 3)] - coeff * c[hook(35, 1)][hook(36, 0)];
  c[hook(35, 2)][hook(37, 3)] = c[hook(35, 2)][hook(37, 3)] - coeff * c[hook(35, 2)][hook(37, 0)];
  c[hook(35, 3)][hook(38, 3)] = c[hook(35, 3)][hook(38, 3)] - coeff * c[hook(35, 3)][hook(38, 0)];
  c[hook(35, 4)][hook(39, 3)] = c[hook(35, 4)][hook(39, 3)] - coeff * c[hook(35, 4)][hook(39, 0)];
  r[hook(40, 3)] = r[hook(40, 3)] - coeff * r[hook(40, 0)];

  coeff = lhs[hook(29, 0)][hook(28, 4)];
  lhs[hook(29, 1)][hook(30, 4)] = lhs[hook(29, 1)][hook(30, 4)] - coeff * lhs[hook(29, 1)][hook(30, 0)];
  lhs[hook(29, 2)][hook(31, 4)] = lhs[hook(29, 2)][hook(31, 4)] - coeff * lhs[hook(29, 2)][hook(31, 0)];
  lhs[hook(29, 3)][hook(32, 4)] = lhs[hook(29, 3)][hook(32, 4)] - coeff * lhs[hook(29, 3)][hook(32, 0)];
  lhs[hook(29, 4)][hook(33, 4)] = lhs[hook(29, 4)][hook(33, 4)] - coeff * lhs[hook(29, 4)][hook(33, 0)];
  c[hook(35, 0)][hook(34, 4)] = c[hook(35, 0)][hook(34, 4)] - coeff * c[hook(35, 0)][hook(34, 0)];
  c[hook(35, 1)][hook(36, 4)] = c[hook(35, 1)][hook(36, 4)] - coeff * c[hook(35, 1)][hook(36, 0)];
  c[hook(35, 2)][hook(37, 4)] = c[hook(35, 2)][hook(37, 4)] - coeff * c[hook(35, 2)][hook(37, 0)];
  c[hook(35, 3)][hook(38, 4)] = c[hook(35, 3)][hook(38, 4)] - coeff * c[hook(35, 3)][hook(38, 0)];
  c[hook(35, 4)][hook(39, 4)] = c[hook(35, 4)][hook(39, 4)] - coeff * c[hook(35, 4)][hook(39, 0)];
  r[hook(40, 4)] = r[hook(40, 4)] - coeff * r[hook(40, 0)];

  pivot = 1.00 / lhs[hook(29, 1)][hook(30, 1)];
  lhs[hook(29, 2)][hook(31, 1)] = lhs[hook(29, 2)][hook(31, 1)] * pivot;
  lhs[hook(29, 3)][hook(32, 1)] = lhs[hook(29, 3)][hook(32, 1)] * pivot;
  lhs[hook(29, 4)][hook(33, 1)] = lhs[hook(29, 4)][hook(33, 1)] * pivot;
  c[hook(35, 0)][hook(34, 1)] = c[hook(35, 0)][hook(34, 1)] * pivot;
  c[hook(35, 1)][hook(36, 1)] = c[hook(35, 1)][hook(36, 1)] * pivot;
  c[hook(35, 2)][hook(37, 1)] = c[hook(35, 2)][hook(37, 1)] * pivot;
  c[hook(35, 3)][hook(38, 1)] = c[hook(35, 3)][hook(38, 1)] * pivot;
  c[hook(35, 4)][hook(39, 1)] = c[hook(35, 4)][hook(39, 1)] * pivot;
  r[hook(40, 1)] = r[hook(40, 1)] * pivot;

  coeff = lhs[hook(29, 1)][hook(30, 0)];
  lhs[hook(29, 2)][hook(31, 0)] = lhs[hook(29, 2)][hook(31, 0)] - coeff * lhs[hook(29, 2)][hook(31, 1)];
  lhs[hook(29, 3)][hook(32, 0)] = lhs[hook(29, 3)][hook(32, 0)] - coeff * lhs[hook(29, 3)][hook(32, 1)];
  lhs[hook(29, 4)][hook(33, 0)] = lhs[hook(29, 4)][hook(33, 0)] - coeff * lhs[hook(29, 4)][hook(33, 1)];
  c[hook(35, 0)][hook(34, 0)] = c[hook(35, 0)][hook(34, 0)] - coeff * c[hook(35, 0)][hook(34, 1)];
  c[hook(35, 1)][hook(36, 0)] = c[hook(35, 1)][hook(36, 0)] - coeff * c[hook(35, 1)][hook(36, 1)];
  c[hook(35, 2)][hook(37, 0)] = c[hook(35, 2)][hook(37, 0)] - coeff * c[hook(35, 2)][hook(37, 1)];
  c[hook(35, 3)][hook(38, 0)] = c[hook(35, 3)][hook(38, 0)] - coeff * c[hook(35, 3)][hook(38, 1)];
  c[hook(35, 4)][hook(39, 0)] = c[hook(35, 4)][hook(39, 0)] - coeff * c[hook(35, 4)][hook(39, 1)];
  r[hook(40, 0)] = r[hook(40, 0)] - coeff * r[hook(40, 1)];

  coeff = lhs[hook(29, 1)][hook(30, 2)];
  lhs[hook(29, 2)][hook(31, 2)] = lhs[hook(29, 2)][hook(31, 2)] - coeff * lhs[hook(29, 2)][hook(31, 1)];
  lhs[hook(29, 3)][hook(32, 2)] = lhs[hook(29, 3)][hook(32, 2)] - coeff * lhs[hook(29, 3)][hook(32, 1)];
  lhs[hook(29, 4)][hook(33, 2)] = lhs[hook(29, 4)][hook(33, 2)] - coeff * lhs[hook(29, 4)][hook(33, 1)];
  c[hook(35, 0)][hook(34, 2)] = c[hook(35, 0)][hook(34, 2)] - coeff * c[hook(35, 0)][hook(34, 1)];
  c[hook(35, 1)][hook(36, 2)] = c[hook(35, 1)][hook(36, 2)] - coeff * c[hook(35, 1)][hook(36, 1)];
  c[hook(35, 2)][hook(37, 2)] = c[hook(35, 2)][hook(37, 2)] - coeff * c[hook(35, 2)][hook(37, 1)];
  c[hook(35, 3)][hook(38, 2)] = c[hook(35, 3)][hook(38, 2)] - coeff * c[hook(35, 3)][hook(38, 1)];
  c[hook(35, 4)][hook(39, 2)] = c[hook(35, 4)][hook(39, 2)] - coeff * c[hook(35, 4)][hook(39, 1)];
  r[hook(40, 2)] = r[hook(40, 2)] - coeff * r[hook(40, 1)];

  coeff = lhs[hook(29, 1)][hook(30, 3)];
  lhs[hook(29, 2)][hook(31, 3)] = lhs[hook(29, 2)][hook(31, 3)] - coeff * lhs[hook(29, 2)][hook(31, 1)];
  lhs[hook(29, 3)][hook(32, 3)] = lhs[hook(29, 3)][hook(32, 3)] - coeff * lhs[hook(29, 3)][hook(32, 1)];
  lhs[hook(29, 4)][hook(33, 3)] = lhs[hook(29, 4)][hook(33, 3)] - coeff * lhs[hook(29, 4)][hook(33, 1)];
  c[hook(35, 0)][hook(34, 3)] = c[hook(35, 0)][hook(34, 3)] - coeff * c[hook(35, 0)][hook(34, 1)];
  c[hook(35, 1)][hook(36, 3)] = c[hook(35, 1)][hook(36, 3)] - coeff * c[hook(35, 1)][hook(36, 1)];
  c[hook(35, 2)][hook(37, 3)] = c[hook(35, 2)][hook(37, 3)] - coeff * c[hook(35, 2)][hook(37, 1)];
  c[hook(35, 3)][hook(38, 3)] = c[hook(35, 3)][hook(38, 3)] - coeff * c[hook(35, 3)][hook(38, 1)];
  c[hook(35, 4)][hook(39, 3)] = c[hook(35, 4)][hook(39, 3)] - coeff * c[hook(35, 4)][hook(39, 1)];
  r[hook(40, 3)] = r[hook(40, 3)] - coeff * r[hook(40, 1)];

  coeff = lhs[hook(29, 1)][hook(30, 4)];
  lhs[hook(29, 2)][hook(31, 4)] = lhs[hook(29, 2)][hook(31, 4)] - coeff * lhs[hook(29, 2)][hook(31, 1)];
  lhs[hook(29, 3)][hook(32, 4)] = lhs[hook(29, 3)][hook(32, 4)] - coeff * lhs[hook(29, 3)][hook(32, 1)];
  lhs[hook(29, 4)][hook(33, 4)] = lhs[hook(29, 4)][hook(33, 4)] - coeff * lhs[hook(29, 4)][hook(33, 1)];
  c[hook(35, 0)][hook(34, 4)] = c[hook(35, 0)][hook(34, 4)] - coeff * c[hook(35, 0)][hook(34, 1)];
  c[hook(35, 1)][hook(36, 4)] = c[hook(35, 1)][hook(36, 4)] - coeff * c[hook(35, 1)][hook(36, 1)];
  c[hook(35, 2)][hook(37, 4)] = c[hook(35, 2)][hook(37, 4)] - coeff * c[hook(35, 2)][hook(37, 1)];
  c[hook(35, 3)][hook(38, 4)] = c[hook(35, 3)][hook(38, 4)] - coeff * c[hook(35, 3)][hook(38, 1)];
  c[hook(35, 4)][hook(39, 4)] = c[hook(35, 4)][hook(39, 4)] - coeff * c[hook(35, 4)][hook(39, 1)];
  r[hook(40, 4)] = r[hook(40, 4)] - coeff * r[hook(40, 1)];

  pivot = 1.00 / lhs[hook(29, 2)][hook(31, 2)];
  lhs[hook(29, 3)][hook(32, 2)] = lhs[hook(29, 3)][hook(32, 2)] * pivot;
  lhs[hook(29, 4)][hook(33, 2)] = lhs[hook(29, 4)][hook(33, 2)] * pivot;
  c[hook(35, 0)][hook(34, 2)] = c[hook(35, 0)][hook(34, 2)] * pivot;
  c[hook(35, 1)][hook(36, 2)] = c[hook(35, 1)][hook(36, 2)] * pivot;
  c[hook(35, 2)][hook(37, 2)] = c[hook(35, 2)][hook(37, 2)] * pivot;
  c[hook(35, 3)][hook(38, 2)] = c[hook(35, 3)][hook(38, 2)] * pivot;
  c[hook(35, 4)][hook(39, 2)] = c[hook(35, 4)][hook(39, 2)] * pivot;
  r[hook(40, 2)] = r[hook(40, 2)] * pivot;

  coeff = lhs[hook(29, 2)][hook(31, 0)];
  lhs[hook(29, 3)][hook(32, 0)] = lhs[hook(29, 3)][hook(32, 0)] - coeff * lhs[hook(29, 3)][hook(32, 2)];
  lhs[hook(29, 4)][hook(33, 0)] = lhs[hook(29, 4)][hook(33, 0)] - coeff * lhs[hook(29, 4)][hook(33, 2)];
  c[hook(35, 0)][hook(34, 0)] = c[hook(35, 0)][hook(34, 0)] - coeff * c[hook(35, 0)][hook(34, 2)];
  c[hook(35, 1)][hook(36, 0)] = c[hook(35, 1)][hook(36, 0)] - coeff * c[hook(35, 1)][hook(36, 2)];
  c[hook(35, 2)][hook(37, 0)] = c[hook(35, 2)][hook(37, 0)] - coeff * c[hook(35, 2)][hook(37, 2)];
  c[hook(35, 3)][hook(38, 0)] = c[hook(35, 3)][hook(38, 0)] - coeff * c[hook(35, 3)][hook(38, 2)];
  c[hook(35, 4)][hook(39, 0)] = c[hook(35, 4)][hook(39, 0)] - coeff * c[hook(35, 4)][hook(39, 2)];
  r[hook(40, 0)] = r[hook(40, 0)] - coeff * r[hook(40, 2)];

  coeff = lhs[hook(29, 2)][hook(31, 1)];
  lhs[hook(29, 3)][hook(32, 1)] = lhs[hook(29, 3)][hook(32, 1)] - coeff * lhs[hook(29, 3)][hook(32, 2)];
  lhs[hook(29, 4)][hook(33, 1)] = lhs[hook(29, 4)][hook(33, 1)] - coeff * lhs[hook(29, 4)][hook(33, 2)];
  c[hook(35, 0)][hook(34, 1)] = c[hook(35, 0)][hook(34, 1)] - coeff * c[hook(35, 0)][hook(34, 2)];
  c[hook(35, 1)][hook(36, 1)] = c[hook(35, 1)][hook(36, 1)] - coeff * c[hook(35, 1)][hook(36, 2)];
  c[hook(35, 2)][hook(37, 1)] = c[hook(35, 2)][hook(37, 1)] - coeff * c[hook(35, 2)][hook(37, 2)];
  c[hook(35, 3)][hook(38, 1)] = c[hook(35, 3)][hook(38, 1)] - coeff * c[hook(35, 3)][hook(38, 2)];
  c[hook(35, 4)][hook(39, 1)] = c[hook(35, 4)][hook(39, 1)] - coeff * c[hook(35, 4)][hook(39, 2)];
  r[hook(40, 1)] = r[hook(40, 1)] - coeff * r[hook(40, 2)];

  coeff = lhs[hook(29, 2)][hook(31, 3)];
  lhs[hook(29, 3)][hook(32, 3)] = lhs[hook(29, 3)][hook(32, 3)] - coeff * lhs[hook(29, 3)][hook(32, 2)];
  lhs[hook(29, 4)][hook(33, 3)] = lhs[hook(29, 4)][hook(33, 3)] - coeff * lhs[hook(29, 4)][hook(33, 2)];
  c[hook(35, 0)][hook(34, 3)] = c[hook(35, 0)][hook(34, 3)] - coeff * c[hook(35, 0)][hook(34, 2)];
  c[hook(35, 1)][hook(36, 3)] = c[hook(35, 1)][hook(36, 3)] - coeff * c[hook(35, 1)][hook(36, 2)];
  c[hook(35, 2)][hook(37, 3)] = c[hook(35, 2)][hook(37, 3)] - coeff * c[hook(35, 2)][hook(37, 2)];
  c[hook(35, 3)][hook(38, 3)] = c[hook(35, 3)][hook(38, 3)] - coeff * c[hook(35, 3)][hook(38, 2)];
  c[hook(35, 4)][hook(39, 3)] = c[hook(35, 4)][hook(39, 3)] - coeff * c[hook(35, 4)][hook(39, 2)];
  r[hook(40, 3)] = r[hook(40, 3)] - coeff * r[hook(40, 2)];

  coeff = lhs[hook(29, 2)][hook(31, 4)];
  lhs[hook(29, 3)][hook(32, 4)] = lhs[hook(29, 3)][hook(32, 4)] - coeff * lhs[hook(29, 3)][hook(32, 2)];
  lhs[hook(29, 4)][hook(33, 4)] = lhs[hook(29, 4)][hook(33, 4)] - coeff * lhs[hook(29, 4)][hook(33, 2)];
  c[hook(35, 0)][hook(34, 4)] = c[hook(35, 0)][hook(34, 4)] - coeff * c[hook(35, 0)][hook(34, 2)];
  c[hook(35, 1)][hook(36, 4)] = c[hook(35, 1)][hook(36, 4)] - coeff * c[hook(35, 1)][hook(36, 2)];
  c[hook(35, 2)][hook(37, 4)] = c[hook(35, 2)][hook(37, 4)] - coeff * c[hook(35, 2)][hook(37, 2)];
  c[hook(35, 3)][hook(38, 4)] = c[hook(35, 3)][hook(38, 4)] - coeff * c[hook(35, 3)][hook(38, 2)];
  c[hook(35, 4)][hook(39, 4)] = c[hook(35, 4)][hook(39, 4)] - coeff * c[hook(35, 4)][hook(39, 2)];
  r[hook(40, 4)] = r[hook(40, 4)] - coeff * r[hook(40, 2)];

  pivot = 1.00 / lhs[hook(29, 3)][hook(32, 3)];
  lhs[hook(29, 4)][hook(33, 3)] = lhs[hook(29, 4)][hook(33, 3)] * pivot;
  c[hook(35, 0)][hook(34, 3)] = c[hook(35, 0)][hook(34, 3)] * pivot;
  c[hook(35, 1)][hook(36, 3)] = c[hook(35, 1)][hook(36, 3)] * pivot;
  c[hook(35, 2)][hook(37, 3)] = c[hook(35, 2)][hook(37, 3)] * pivot;
  c[hook(35, 3)][hook(38, 3)] = c[hook(35, 3)][hook(38, 3)] * pivot;
  c[hook(35, 4)][hook(39, 3)] = c[hook(35, 4)][hook(39, 3)] * pivot;
  r[hook(40, 3)] = r[hook(40, 3)] * pivot;

  coeff = lhs[hook(29, 3)][hook(32, 0)];
  lhs[hook(29, 4)][hook(33, 0)] = lhs[hook(29, 4)][hook(33, 0)] - coeff * lhs[hook(29, 4)][hook(33, 3)];
  c[hook(35, 0)][hook(34, 0)] = c[hook(35, 0)][hook(34, 0)] - coeff * c[hook(35, 0)][hook(34, 3)];
  c[hook(35, 1)][hook(36, 0)] = c[hook(35, 1)][hook(36, 0)] - coeff * c[hook(35, 1)][hook(36, 3)];
  c[hook(35, 2)][hook(37, 0)] = c[hook(35, 2)][hook(37, 0)] - coeff * c[hook(35, 2)][hook(37, 3)];
  c[hook(35, 3)][hook(38, 0)] = c[hook(35, 3)][hook(38, 0)] - coeff * c[hook(35, 3)][hook(38, 3)];
  c[hook(35, 4)][hook(39, 0)] = c[hook(35, 4)][hook(39, 0)] - coeff * c[hook(35, 4)][hook(39, 3)];
  r[hook(40, 0)] = r[hook(40, 0)] - coeff * r[hook(40, 3)];

  coeff = lhs[hook(29, 3)][hook(32, 1)];
  lhs[hook(29, 4)][hook(33, 1)] = lhs[hook(29, 4)][hook(33, 1)] - coeff * lhs[hook(29, 4)][hook(33, 3)];
  c[hook(35, 0)][hook(34, 1)] = c[hook(35, 0)][hook(34, 1)] - coeff * c[hook(35, 0)][hook(34, 3)];
  c[hook(35, 1)][hook(36, 1)] = c[hook(35, 1)][hook(36, 1)] - coeff * c[hook(35, 1)][hook(36, 3)];
  c[hook(35, 2)][hook(37, 1)] = c[hook(35, 2)][hook(37, 1)] - coeff * c[hook(35, 2)][hook(37, 3)];
  c[hook(35, 3)][hook(38, 1)] = c[hook(35, 3)][hook(38, 1)] - coeff * c[hook(35, 3)][hook(38, 3)];
  c[hook(35, 4)][hook(39, 1)] = c[hook(35, 4)][hook(39, 1)] - coeff * c[hook(35, 4)][hook(39, 3)];
  r[hook(40, 1)] = r[hook(40, 1)] - coeff * r[hook(40, 3)];

  coeff = lhs[hook(29, 3)][hook(32, 2)];
  lhs[hook(29, 4)][hook(33, 2)] = lhs[hook(29, 4)][hook(33, 2)] - coeff * lhs[hook(29, 4)][hook(33, 3)];
  c[hook(35, 0)][hook(34, 2)] = c[hook(35, 0)][hook(34, 2)] - coeff * c[hook(35, 0)][hook(34, 3)];
  c[hook(35, 1)][hook(36, 2)] = c[hook(35, 1)][hook(36, 2)] - coeff * c[hook(35, 1)][hook(36, 3)];
  c[hook(35, 2)][hook(37, 2)] = c[hook(35, 2)][hook(37, 2)] - coeff * c[hook(35, 2)][hook(37, 3)];
  c[hook(35, 3)][hook(38, 2)] = c[hook(35, 3)][hook(38, 2)] - coeff * c[hook(35, 3)][hook(38, 3)];
  c[hook(35, 4)][hook(39, 2)] = c[hook(35, 4)][hook(39, 2)] - coeff * c[hook(35, 4)][hook(39, 3)];
  r[hook(40, 2)] = r[hook(40, 2)] - coeff * r[hook(40, 3)];

  coeff = lhs[hook(29, 3)][hook(32, 4)];
  lhs[hook(29, 4)][hook(33, 4)] = lhs[hook(29, 4)][hook(33, 4)] - coeff * lhs[hook(29, 4)][hook(33, 3)];
  c[hook(35, 0)][hook(34, 4)] = c[hook(35, 0)][hook(34, 4)] - coeff * c[hook(35, 0)][hook(34, 3)];
  c[hook(35, 1)][hook(36, 4)] = c[hook(35, 1)][hook(36, 4)] - coeff * c[hook(35, 1)][hook(36, 3)];
  c[hook(35, 2)][hook(37, 4)] = c[hook(35, 2)][hook(37, 4)] - coeff * c[hook(35, 2)][hook(37, 3)];
  c[hook(35, 3)][hook(38, 4)] = c[hook(35, 3)][hook(38, 4)] - coeff * c[hook(35, 3)][hook(38, 3)];
  c[hook(35, 4)][hook(39, 4)] = c[hook(35, 4)][hook(39, 4)] - coeff * c[hook(35, 4)][hook(39, 3)];
  r[hook(40, 4)] = r[hook(40, 4)] - coeff * r[hook(40, 3)];

  pivot = 1.00 / lhs[hook(29, 4)][hook(33, 4)];
  c[hook(35, 0)][hook(34, 4)] = c[hook(35, 0)][hook(34, 4)] * pivot;
  c[hook(35, 1)][hook(36, 4)] = c[hook(35, 1)][hook(36, 4)] * pivot;
  c[hook(35, 2)][hook(37, 4)] = c[hook(35, 2)][hook(37, 4)] * pivot;
  c[hook(35, 3)][hook(38, 4)] = c[hook(35, 3)][hook(38, 4)] * pivot;
  c[hook(35, 4)][hook(39, 4)] = c[hook(35, 4)][hook(39, 4)] * pivot;
  r[hook(40, 4)] = r[hook(40, 4)] * pivot;

  coeff = lhs[hook(29, 4)][hook(33, 0)];
  c[hook(35, 0)][hook(34, 0)] = c[hook(35, 0)][hook(34, 0)] - coeff * c[hook(35, 0)][hook(34, 4)];
  c[hook(35, 1)][hook(36, 0)] = c[hook(35, 1)][hook(36, 0)] - coeff * c[hook(35, 1)][hook(36, 4)];
  c[hook(35, 2)][hook(37, 0)] = c[hook(35, 2)][hook(37, 0)] - coeff * c[hook(35, 2)][hook(37, 4)];
  c[hook(35, 3)][hook(38, 0)] = c[hook(35, 3)][hook(38, 0)] - coeff * c[hook(35, 3)][hook(38, 4)];
  c[hook(35, 4)][hook(39, 0)] = c[hook(35, 4)][hook(39, 0)] - coeff * c[hook(35, 4)][hook(39, 4)];
  r[hook(40, 0)] = r[hook(40, 0)] - coeff * r[hook(40, 4)];

  coeff = lhs[hook(29, 4)][hook(33, 1)];
  c[hook(35, 0)][hook(34, 1)] = c[hook(35, 0)][hook(34, 1)] - coeff * c[hook(35, 0)][hook(34, 4)];
  c[hook(35, 1)][hook(36, 1)] = c[hook(35, 1)][hook(36, 1)] - coeff * c[hook(35, 1)][hook(36, 4)];
  c[hook(35, 2)][hook(37, 1)] = c[hook(35, 2)][hook(37, 1)] - coeff * c[hook(35, 2)][hook(37, 4)];
  c[hook(35, 3)][hook(38, 1)] = c[hook(35, 3)][hook(38, 1)] - coeff * c[hook(35, 3)][hook(38, 4)];
  c[hook(35, 4)][hook(39, 1)] = c[hook(35, 4)][hook(39, 1)] - coeff * c[hook(35, 4)][hook(39, 4)];
  r[hook(40, 1)] = r[hook(40, 1)] - coeff * r[hook(40, 4)];

  coeff = lhs[hook(29, 4)][hook(33, 2)];
  c[hook(35, 0)][hook(34, 2)] = c[hook(35, 0)][hook(34, 2)] - coeff * c[hook(35, 0)][hook(34, 4)];
  c[hook(35, 1)][hook(36, 2)] = c[hook(35, 1)][hook(36, 2)] - coeff * c[hook(35, 1)][hook(36, 4)];
  c[hook(35, 2)][hook(37, 2)] = c[hook(35, 2)][hook(37, 2)] - coeff * c[hook(35, 2)][hook(37, 4)];
  c[hook(35, 3)][hook(38, 2)] = c[hook(35, 3)][hook(38, 2)] - coeff * c[hook(35, 3)][hook(38, 4)];
  c[hook(35, 4)][hook(39, 2)] = c[hook(35, 4)][hook(39, 2)] - coeff * c[hook(35, 4)][hook(39, 4)];
  r[hook(40, 2)] = r[hook(40, 2)] - coeff * r[hook(40, 4)];

  coeff = lhs[hook(29, 4)][hook(33, 3)];
  c[hook(35, 0)][hook(34, 3)] = c[hook(35, 0)][hook(34, 3)] - coeff * c[hook(35, 0)][hook(34, 4)];
  c[hook(35, 1)][hook(36, 3)] = c[hook(35, 1)][hook(36, 3)] - coeff * c[hook(35, 1)][hook(36, 4)];
  c[hook(35, 2)][hook(37, 3)] = c[hook(35, 2)][hook(37, 3)] - coeff * c[hook(35, 2)][hook(37, 4)];
  c[hook(35, 3)][hook(38, 3)] = c[hook(35, 3)][hook(38, 3)] - coeff * c[hook(35, 3)][hook(38, 4)];
  c[hook(35, 4)][hook(39, 3)] = c[hook(35, 4)][hook(39, 3)] - coeff * c[hook(35, 4)][hook(39, 4)];
  r[hook(40, 3)] = r[hook(40, 3)] - coeff * r[hook(40, 4)];
}

void binvrhs(global double lhs[5][5], global double r[5]) {
  double pivot, coeff;

  pivot = 1.00 / lhs[hook(29, 0)][hook(28, 0)];
  lhs[hook(29, 1)][hook(30, 0)] = lhs[hook(29, 1)][hook(30, 0)] * pivot;
  lhs[hook(29, 2)][hook(31, 0)] = lhs[hook(29, 2)][hook(31, 0)] * pivot;
  lhs[hook(29, 3)][hook(32, 0)] = lhs[hook(29, 3)][hook(32, 0)] * pivot;
  lhs[hook(29, 4)][hook(33, 0)] = lhs[hook(29, 4)][hook(33, 0)] * pivot;
  r[hook(40, 0)] = r[hook(40, 0)] * pivot;

  coeff = lhs[hook(29, 0)][hook(28, 1)];
  lhs[hook(29, 1)][hook(30, 1)] = lhs[hook(29, 1)][hook(30, 1)] - coeff * lhs[hook(29, 1)][hook(30, 0)];
  lhs[hook(29, 2)][hook(31, 1)] = lhs[hook(29, 2)][hook(31, 1)] - coeff * lhs[hook(29, 2)][hook(31, 0)];
  lhs[hook(29, 3)][hook(32, 1)] = lhs[hook(29, 3)][hook(32, 1)] - coeff * lhs[hook(29, 3)][hook(32, 0)];
  lhs[hook(29, 4)][hook(33, 1)] = lhs[hook(29, 4)][hook(33, 1)] - coeff * lhs[hook(29, 4)][hook(33, 0)];
  r[hook(40, 1)] = r[hook(40, 1)] - coeff * r[hook(40, 0)];

  coeff = lhs[hook(29, 0)][hook(28, 2)];
  lhs[hook(29, 1)][hook(30, 2)] = lhs[hook(29, 1)][hook(30, 2)] - coeff * lhs[hook(29, 1)][hook(30, 0)];
  lhs[hook(29, 2)][hook(31, 2)] = lhs[hook(29, 2)][hook(31, 2)] - coeff * lhs[hook(29, 2)][hook(31, 0)];
  lhs[hook(29, 3)][hook(32, 2)] = lhs[hook(29, 3)][hook(32, 2)] - coeff * lhs[hook(29, 3)][hook(32, 0)];
  lhs[hook(29, 4)][hook(33, 2)] = lhs[hook(29, 4)][hook(33, 2)] - coeff * lhs[hook(29, 4)][hook(33, 0)];
  r[hook(40, 2)] = r[hook(40, 2)] - coeff * r[hook(40, 0)];

  coeff = lhs[hook(29, 0)][hook(28, 3)];
  lhs[hook(29, 1)][hook(30, 3)] = lhs[hook(29, 1)][hook(30, 3)] - coeff * lhs[hook(29, 1)][hook(30, 0)];
  lhs[hook(29, 2)][hook(31, 3)] = lhs[hook(29, 2)][hook(31, 3)] - coeff * lhs[hook(29, 2)][hook(31, 0)];
  lhs[hook(29, 3)][hook(32, 3)] = lhs[hook(29, 3)][hook(32, 3)] - coeff * lhs[hook(29, 3)][hook(32, 0)];
  lhs[hook(29, 4)][hook(33, 3)] = lhs[hook(29, 4)][hook(33, 3)] - coeff * lhs[hook(29, 4)][hook(33, 0)];
  r[hook(40, 3)] = r[hook(40, 3)] - coeff * r[hook(40, 0)];

  coeff = lhs[hook(29, 0)][hook(28, 4)];
  lhs[hook(29, 1)][hook(30, 4)] = lhs[hook(29, 1)][hook(30, 4)] - coeff * lhs[hook(29, 1)][hook(30, 0)];
  lhs[hook(29, 2)][hook(31, 4)] = lhs[hook(29, 2)][hook(31, 4)] - coeff * lhs[hook(29, 2)][hook(31, 0)];
  lhs[hook(29, 3)][hook(32, 4)] = lhs[hook(29, 3)][hook(32, 4)] - coeff * lhs[hook(29, 3)][hook(32, 0)];
  lhs[hook(29, 4)][hook(33, 4)] = lhs[hook(29, 4)][hook(33, 4)] - coeff * lhs[hook(29, 4)][hook(33, 0)];
  r[hook(40, 4)] = r[hook(40, 4)] - coeff * r[hook(40, 0)];

  pivot = 1.00 / lhs[hook(29, 1)][hook(30, 1)];
  lhs[hook(29, 2)][hook(31, 1)] = lhs[hook(29, 2)][hook(31, 1)] * pivot;
  lhs[hook(29, 3)][hook(32, 1)] = lhs[hook(29, 3)][hook(32, 1)] * pivot;
  lhs[hook(29, 4)][hook(33, 1)] = lhs[hook(29, 4)][hook(33, 1)] * pivot;
  r[hook(40, 1)] = r[hook(40, 1)] * pivot;

  coeff = lhs[hook(29, 1)][hook(30, 0)];
  lhs[hook(29, 2)][hook(31, 0)] = lhs[hook(29, 2)][hook(31, 0)] - coeff * lhs[hook(29, 2)][hook(31, 1)];
  lhs[hook(29, 3)][hook(32, 0)] = lhs[hook(29, 3)][hook(32, 0)] - coeff * lhs[hook(29, 3)][hook(32, 1)];
  lhs[hook(29, 4)][hook(33, 0)] = lhs[hook(29, 4)][hook(33, 0)] - coeff * lhs[hook(29, 4)][hook(33, 1)];
  r[hook(40, 0)] = r[hook(40, 0)] - coeff * r[hook(40, 1)];

  coeff = lhs[hook(29, 1)][hook(30, 2)];
  lhs[hook(29, 2)][hook(31, 2)] = lhs[hook(29, 2)][hook(31, 2)] - coeff * lhs[hook(29, 2)][hook(31, 1)];
  lhs[hook(29, 3)][hook(32, 2)] = lhs[hook(29, 3)][hook(32, 2)] - coeff * lhs[hook(29, 3)][hook(32, 1)];
  lhs[hook(29, 4)][hook(33, 2)] = lhs[hook(29, 4)][hook(33, 2)] - coeff * lhs[hook(29, 4)][hook(33, 1)];
  r[hook(40, 2)] = r[hook(40, 2)] - coeff * r[hook(40, 1)];

  coeff = lhs[hook(29, 1)][hook(30, 3)];
  lhs[hook(29, 2)][hook(31, 3)] = lhs[hook(29, 2)][hook(31, 3)] - coeff * lhs[hook(29, 2)][hook(31, 1)];
  lhs[hook(29, 3)][hook(32, 3)] = lhs[hook(29, 3)][hook(32, 3)] - coeff * lhs[hook(29, 3)][hook(32, 1)];
  lhs[hook(29, 4)][hook(33, 3)] = lhs[hook(29, 4)][hook(33, 3)] - coeff * lhs[hook(29, 4)][hook(33, 1)];
  r[hook(40, 3)] = r[hook(40, 3)] - coeff * r[hook(40, 1)];

  coeff = lhs[hook(29, 1)][hook(30, 4)];
  lhs[hook(29, 2)][hook(31, 4)] = lhs[hook(29, 2)][hook(31, 4)] - coeff * lhs[hook(29, 2)][hook(31, 1)];
  lhs[hook(29, 3)][hook(32, 4)] = lhs[hook(29, 3)][hook(32, 4)] - coeff * lhs[hook(29, 3)][hook(32, 1)];
  lhs[hook(29, 4)][hook(33, 4)] = lhs[hook(29, 4)][hook(33, 4)] - coeff * lhs[hook(29, 4)][hook(33, 1)];
  r[hook(40, 4)] = r[hook(40, 4)] - coeff * r[hook(40, 1)];

  pivot = 1.00 / lhs[hook(29, 2)][hook(31, 2)];
  lhs[hook(29, 3)][hook(32, 2)] = lhs[hook(29, 3)][hook(32, 2)] * pivot;
  lhs[hook(29, 4)][hook(33, 2)] = lhs[hook(29, 4)][hook(33, 2)] * pivot;
  r[hook(40, 2)] = r[hook(40, 2)] * pivot;

  coeff = lhs[hook(29, 2)][hook(31, 0)];
  lhs[hook(29, 3)][hook(32, 0)] = lhs[hook(29, 3)][hook(32, 0)] - coeff * lhs[hook(29, 3)][hook(32, 2)];
  lhs[hook(29, 4)][hook(33, 0)] = lhs[hook(29, 4)][hook(33, 0)] - coeff * lhs[hook(29, 4)][hook(33, 2)];
  r[hook(40, 0)] = r[hook(40, 0)] - coeff * r[hook(40, 2)];

  coeff = lhs[hook(29, 2)][hook(31, 1)];
  lhs[hook(29, 3)][hook(32, 1)] = lhs[hook(29, 3)][hook(32, 1)] - coeff * lhs[hook(29, 3)][hook(32, 2)];
  lhs[hook(29, 4)][hook(33, 1)] = lhs[hook(29, 4)][hook(33, 1)] - coeff * lhs[hook(29, 4)][hook(33, 2)];
  r[hook(40, 1)] = r[hook(40, 1)] - coeff * r[hook(40, 2)];

  coeff = lhs[hook(29, 2)][hook(31, 3)];
  lhs[hook(29, 3)][hook(32, 3)] = lhs[hook(29, 3)][hook(32, 3)] - coeff * lhs[hook(29, 3)][hook(32, 2)];
  lhs[hook(29, 4)][hook(33, 3)] = lhs[hook(29, 4)][hook(33, 3)] - coeff * lhs[hook(29, 4)][hook(33, 2)];
  r[hook(40, 3)] = r[hook(40, 3)] - coeff * r[hook(40, 2)];

  coeff = lhs[hook(29, 2)][hook(31, 4)];
  lhs[hook(29, 3)][hook(32, 4)] = lhs[hook(29, 3)][hook(32, 4)] - coeff * lhs[hook(29, 3)][hook(32, 2)];
  lhs[hook(29, 4)][hook(33, 4)] = lhs[hook(29, 4)][hook(33, 4)] - coeff * lhs[hook(29, 4)][hook(33, 2)];
  r[hook(40, 4)] = r[hook(40, 4)] - coeff * r[hook(40, 2)];

  pivot = 1.00 / lhs[hook(29, 3)][hook(32, 3)];
  lhs[hook(29, 4)][hook(33, 3)] = lhs[hook(29, 4)][hook(33, 3)] * pivot;
  r[hook(40, 3)] = r[hook(40, 3)] * pivot;

  coeff = lhs[hook(29, 3)][hook(32, 0)];
  lhs[hook(29, 4)][hook(33, 0)] = lhs[hook(29, 4)][hook(33, 0)] - coeff * lhs[hook(29, 4)][hook(33, 3)];
  r[hook(40, 0)] = r[hook(40, 0)] - coeff * r[hook(40, 3)];

  coeff = lhs[hook(29, 3)][hook(32, 1)];
  lhs[hook(29, 4)][hook(33, 1)] = lhs[hook(29, 4)][hook(33, 1)] - coeff * lhs[hook(29, 4)][hook(33, 3)];
  r[hook(40, 1)] = r[hook(40, 1)] - coeff * r[hook(40, 3)];

  coeff = lhs[hook(29, 3)][hook(32, 2)];
  lhs[hook(29, 4)][hook(33, 2)] = lhs[hook(29, 4)][hook(33, 2)] - coeff * lhs[hook(29, 4)][hook(33, 3)];
  r[hook(40, 2)] = r[hook(40, 2)] - coeff * r[hook(40, 3)];

  coeff = lhs[hook(29, 3)][hook(32, 4)];
  lhs[hook(29, 4)][hook(33, 4)] = lhs[hook(29, 4)][hook(33, 4)] - coeff * lhs[hook(29, 4)][hook(33, 3)];
  r[hook(40, 4)] = r[hook(40, 4)] - coeff * r[hook(40, 3)];

  pivot = 1.00 / lhs[hook(29, 4)][hook(33, 4)];
  r[hook(40, 4)] = r[hook(40, 4)] * pivot;

  coeff = lhs[hook(29, 4)][hook(33, 0)];
  r[hook(40, 0)] = r[hook(40, 0)] - coeff * r[hook(40, 4)];

  coeff = lhs[hook(29, 4)][hook(33, 1)];
  r[hook(40, 1)] = r[hook(40, 1)] - coeff * r[hook(40, 4)];

  coeff = lhs[hook(29, 4)][hook(33, 2)];
  r[hook(40, 2)] = r[hook(40, 2)] - coeff * r[hook(40, 4)];

  coeff = lhs[hook(29, 4)][hook(33, 3)];
  r[hook(40, 3)] = r[hook(40, 3)] - coeff * r[hook(40, 4)];
}

kernel void z_solve1(global double* g_qs, global double* g_square, global double* g_u, global double* g_fjac, global double* g_njac, int gp0, int gp1, int gp2) {
  int i, j, k;
  double tmp1, tmp2, tmp3;

  j = get_global_id(2) + 1;
  i = get_global_id(1) + 1;
  k = get_global_id(0);
  if (j > (gp1 - 2) || i > (gp0 - 2) || k >= gp2)
    return;

  global double(*qs)[64 / 2 * 2 + 1][64 / 2 * 2 + 1] = (global double(*)[64 / 2 * 2 + 1][64 / 2 * 2 + 1]) g_qs;
  global double(*square)[64 / 2 * 2 + 1][64 / 2 * 2 + 1] = (global double(*)[64 / 2 * 2 + 1][64 / 2 * 2 + 1]) g_square;
  global double(*u)[64 / 2 * 2 + 1][64 / 2 * 2 + 1][5] = (global double(*)[64 / 2 * 2 + 1][64 / 2 * 2 + 1][5]) g_u;

  int my_id = (j - 1) * (gp0 - 2) + (i - 1);
  int my_offset = my_id * (64 + 1) * 5 * 5;
  global double(*fjac)[5][5] = (global double(*)[5][5]) & g_fjac[hook(3, my_offset)];
  global double(*njac)[5][5] = (global double(*)[5][5]) & g_njac[hook(4, my_offset)];

  tmp1 = 1.0 / u[hook(44, k)][hook(43, j)][hook(42, i)][hook(41, 0)];
  tmp2 = tmp1 * tmp1;
  tmp3 = tmp1 * tmp2;

  fjac[hook(47, k)][hook(46, 0)][hook(45, 0)] = 0.0;
  fjac[hook(47, k)][hook(46, 1)][hook(48, 0)] = 0.0;
  fjac[hook(47, k)][hook(46, 2)][hook(49, 0)] = 0.0;
  fjac[hook(47, k)][hook(46, 3)][hook(50, 0)] = 1.0;
  fjac[hook(47, k)][hook(46, 4)][hook(51, 0)] = 0.0;

  fjac[hook(47, k)][hook(46, 0)][hook(45, 1)] = -(u[hook(44, k)][hook(43, j)][hook(42, i)][hook(41, 1)] * u[hook(44, k)][hook(43, j)][hook(42, i)][hook(41, 3)]) * tmp2;
  fjac[hook(47, k)][hook(46, 1)][hook(48, 1)] = u[hook(44, k)][hook(43, j)][hook(42, i)][hook(41, 3)] * tmp1;
  fjac[hook(47, k)][hook(46, 2)][hook(49, 1)] = 0.0;
  fjac[hook(47, k)][hook(46, 3)][hook(50, 1)] = u[hook(44, k)][hook(43, j)][hook(42, i)][hook(41, 1)] * tmp1;
  fjac[hook(47, k)][hook(46, 4)][hook(51, 1)] = 0.0;

  fjac[hook(47, k)][hook(46, 0)][hook(45, 2)] = -(u[hook(44, k)][hook(43, j)][hook(42, i)][hook(41, 2)] * u[hook(44, k)][hook(43, j)][hook(42, i)][hook(41, 3)]) * tmp2;
  fjac[hook(47, k)][hook(46, 1)][hook(48, 2)] = 0.0;
  fjac[hook(47, k)][hook(46, 2)][hook(49, 2)] = u[hook(44, k)][hook(43, j)][hook(42, i)][hook(41, 3)] * tmp1;
  fjac[hook(47, k)][hook(46, 3)][hook(50, 2)] = u[hook(44, k)][hook(43, j)][hook(42, i)][hook(41, 2)] * tmp1;
  fjac[hook(47, k)][hook(46, 4)][hook(51, 2)] = 0.0;

  fjac[hook(47, k)][hook(46, 0)][hook(45, 3)] = -(u[hook(44, k)][hook(43, j)][hook(42, i)][hook(41, 3)] * u[hook(44, k)][hook(43, j)][hook(42, i)][hook(41, 3)] * tmp2) + 0.4 * qs[hook(54, k)][hook(53, j)][hook(52, i)];
  fjac[hook(47, k)][hook(46, 1)][hook(48, 3)] = -0.4 * u[hook(44, k)][hook(43, j)][hook(42, i)][hook(41, 1)] * tmp1;
  fjac[hook(47, k)][hook(46, 2)][hook(49, 3)] = -0.4 * u[hook(44, k)][hook(43, j)][hook(42, i)][hook(41, 2)] * tmp1;
  fjac[hook(47, k)][hook(46, 3)][hook(50, 3)] = (2.0 - 0.4) * u[hook(44, k)][hook(43, j)][hook(42, i)][hook(41, 3)] * tmp1;
  fjac[hook(47, k)][hook(46, 4)][hook(51, 3)] = 0.4;

  fjac[hook(47, k)][hook(46, 0)][hook(45, 4)] = (0.4 * 2.0 * square[hook(57, k)][hook(56, j)][hook(55, i)] - 1.4 * u[hook(44, k)][hook(43, j)][hook(42, i)][hook(41, 4)]) * u[hook(44, k)][hook(43, j)][hook(42, i)][hook(41, 3)] * tmp2;
  fjac[hook(47, k)][hook(46, 1)][hook(48, 4)] = -0.4 * (u[hook(44, k)][hook(43, j)][hook(42, i)][hook(41, 1)] * u[hook(44, k)][hook(43, j)][hook(42, i)][hook(41, 3)]) * tmp2;
  fjac[hook(47, k)][hook(46, 2)][hook(49, 4)] = -0.4 * (u[hook(44, k)][hook(43, j)][hook(42, i)][hook(41, 2)] * u[hook(44, k)][hook(43, j)][hook(42, i)][hook(41, 3)]) * tmp2;
  fjac[hook(47, k)][hook(46, 3)][hook(50, 4)] = 1.4 * (u[hook(44, k)][hook(43, j)][hook(42, i)][hook(41, 4)] * tmp1) - 0.4 * (qs[hook(54, k)][hook(53, j)][hook(52, i)] + u[hook(44, k)][hook(43, j)][hook(42, i)][hook(41, 3)] * u[hook(44, k)][hook(43, j)][hook(42, i)][hook(41, 3)] * tmp2);
  fjac[hook(47, k)][hook(46, 4)][hook(51, 4)] = 1.4 * u[hook(44, k)][hook(43, j)][hook(42, i)][hook(41, 3)] * tmp1;

  njac[hook(60, k)][hook(59, 0)][hook(58, 0)] = 0.0;
  njac[hook(60, k)][hook(59, 1)][hook(61, 0)] = 0.0;
  njac[hook(60, k)][hook(59, 2)][hook(62, 0)] = 0.0;
  njac[hook(60, k)][hook(59, 3)][hook(63, 0)] = 0.0;
  njac[hook(60, k)][hook(59, 4)][hook(64, 0)] = 0.0;

  njac[hook(60, k)][hook(59, 0)][hook(58, 1)] = -(0.1 * 1.0) * tmp2 * u[hook(44, k)][hook(43, j)][hook(42, i)][hook(41, 1)];
  njac[hook(60, k)][hook(59, 1)][hook(61, 1)] = (0.1 * 1.0) * tmp1;
  njac[hook(60, k)][hook(59, 2)][hook(62, 1)] = 0.0;
  njac[hook(60, k)][hook(59, 3)][hook(63, 1)] = 0.0;
  njac[hook(60, k)][hook(59, 4)][hook(64, 1)] = 0.0;

  njac[hook(60, k)][hook(59, 0)][hook(58, 2)] = -(0.1 * 1.0) * tmp2 * u[hook(44, k)][hook(43, j)][hook(42, i)][hook(41, 2)];
  njac[hook(60, k)][hook(59, 1)][hook(61, 2)] = 0.0;
  njac[hook(60, k)][hook(59, 2)][hook(62, 2)] = (0.1 * 1.0) * tmp1;
  njac[hook(60, k)][hook(59, 3)][hook(63, 2)] = 0.0;
  njac[hook(60, k)][hook(59, 4)][hook(64, 2)] = 0.0;

  njac[hook(60, k)][hook(59, 0)][hook(58, 3)] = -(4.0 / 3.0) * (0.1 * 1.0) * tmp2 * u[hook(44, k)][hook(43, j)][hook(42, i)][hook(41, 3)];
  njac[hook(60, k)][hook(59, 1)][hook(61, 3)] = 0.0;
  njac[hook(60, k)][hook(59, 2)][hook(62, 3)] = 0.0;
  njac[hook(60, k)][hook(59, 3)][hook(63, 3)] = (4.0 / 3.0) * 0.1 * 1.0 * tmp1;
  njac[hook(60, k)][hook(59, 4)][hook(64, 3)] = 0.0;

  njac[hook(60, k)][hook(59, 0)][hook(58, 4)] = -((0.1 * 1.0) - ((1.4 * 1.4) * (0.1 * 1.0))) * tmp3 * (u[hook(44, k)][hook(43, j)][hook(42, i)][hook(41, 1)] * u[hook(44, k)][hook(43, j)][hook(42, i)][hook(41, 1)]) - ((0.1 * 1.0) - ((1.4 * 1.4) * (0.1 * 1.0))) * tmp3 * (u[hook(44, k)][hook(43, j)][hook(42, i)][hook(41, 2)] * u[hook(44, k)][hook(43, j)][hook(42, i)][hook(41, 2)]) - ((4.0 / 3.0) * (0.1 * 1.0) - ((1.4 * 1.4) * (0.1 * 1.0))) * tmp3 * (u[hook(44, k)][hook(43, j)][hook(42, i)][hook(41, 3)] * u[hook(44, k)][hook(43, j)][hook(42, i)][hook(41, 3)]) - ((1.4 * 1.4) * (0.1 * 1.0)) * tmp2 * u[hook(44, k)][hook(43, j)][hook(42, i)][hook(41, 4)];

  njac[hook(60, k)][hook(59, 1)][hook(61, 4)] = ((0.1 * 1.0) - ((1.4 * 1.4) * (0.1 * 1.0))) * tmp2 * u[hook(44, k)][hook(43, j)][hook(42, i)][hook(41, 1)];
  njac[hook(60, k)][hook(59, 2)][hook(62, 4)] = ((0.1 * 1.0) - ((1.4 * 1.4) * (0.1 * 1.0))) * tmp2 * u[hook(44, k)][hook(43, j)][hook(42, i)][hook(41, 2)];
  njac[hook(60, k)][hook(59, 3)][hook(63, 4)] = ((4.0 / 3.0) * (0.1 * 1.0) - ((1.4 * 1.4) * (0.1 * 1.0))) * tmp2 * u[hook(44, k)][hook(43, j)][hook(42, i)][hook(41, 3)];
  njac[hook(60, k)][hook(59, 4)][hook(64, 4)] = (((1.4 * 1.4) * (0.1 * 1.0))) * tmp1;
}