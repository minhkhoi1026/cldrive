//{"ablock":11,"ablock[0]":10,"ablock[1]":13,"ablock[2]":14,"ablock[3]":15,"ablock[4]":16,"avec":12,"bblock":20,"bblock[0]":19,"bblock[1]":22,"bblock[2]":24,"bblock[3]":26,"bblock[4]":28,"bvec":9,"c":36,"c[0]":35,"c[1]":37,"c[2]":38,"c[3]":39,"c[4]":40,"cblock":18,"cblock[0]":17,"cblock[1]":21,"cblock[2]":23,"cblock[3]":25,"cblock[4]":27,"fjac":47,"fjac[j]":46,"fjac[j][0]":45,"fjac[j][1]":48,"fjac[j][2]":49,"fjac[j][3]":50,"fjac[j][4]":51,"g_fjac":4,"g_njac":5,"g_qs":0,"g_rho_i":1,"g_square":2,"g_u":3,"gp0":6,"gp1":7,"gp2":8,"lhs":30,"lhs[0]":29,"lhs[1]":31,"lhs[2]":32,"lhs[3]":33,"lhs[4]":34,"njac":64,"njac[j]":63,"njac[j][0]":62,"njac[j][1]":65,"njac[j][2]":66,"njac[j][3]":67,"njac[j][4]":68,"qs":58,"qs[k]":57,"qs[k][j]":56,"r":41,"rho_i":44,"rho_i[k]":43,"rho_i[k][j]":42,"square":61,"square[k]":60,"square[k][j]":59,"u":55,"u[k]":54,"u[k][j]":53,"u[k][j][i]":52}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void matvec_sub(global double ablock[5][5], global double avec[5], global double bvec[5]) {
  bvec[hook(9, 0)] = bvec[hook(9, 0)] - ablock[hook(11, 0)][hook(10, 0)] * avec[hook(12, 0)] - ablock[hook(11, 1)][hook(13, 0)] * avec[hook(12, 1)] - ablock[hook(11, 2)][hook(14, 0)] * avec[hook(12, 2)] - ablock[hook(11, 3)][hook(15, 0)] * avec[hook(12, 3)] - ablock[hook(11, 4)][hook(16, 0)] * avec[hook(12, 4)];
  bvec[hook(9, 1)] = bvec[hook(9, 1)] - ablock[hook(11, 0)][hook(10, 1)] * avec[hook(12, 0)] - ablock[hook(11, 1)][hook(13, 1)] * avec[hook(12, 1)] - ablock[hook(11, 2)][hook(14, 1)] * avec[hook(12, 2)] - ablock[hook(11, 3)][hook(15, 1)] * avec[hook(12, 3)] - ablock[hook(11, 4)][hook(16, 1)] * avec[hook(12, 4)];
  bvec[hook(9, 2)] = bvec[hook(9, 2)] - ablock[hook(11, 0)][hook(10, 2)] * avec[hook(12, 0)] - ablock[hook(11, 1)][hook(13, 2)] * avec[hook(12, 1)] - ablock[hook(11, 2)][hook(14, 2)] * avec[hook(12, 2)] - ablock[hook(11, 3)][hook(15, 2)] * avec[hook(12, 3)] - ablock[hook(11, 4)][hook(16, 2)] * avec[hook(12, 4)];
  bvec[hook(9, 3)] = bvec[hook(9, 3)] - ablock[hook(11, 0)][hook(10, 3)] * avec[hook(12, 0)] - ablock[hook(11, 1)][hook(13, 3)] * avec[hook(12, 1)] - ablock[hook(11, 2)][hook(14, 3)] * avec[hook(12, 2)] - ablock[hook(11, 3)][hook(15, 3)] * avec[hook(12, 3)] - ablock[hook(11, 4)][hook(16, 3)] * avec[hook(12, 4)];
  bvec[hook(9, 4)] = bvec[hook(9, 4)] - ablock[hook(11, 0)][hook(10, 4)] * avec[hook(12, 0)] - ablock[hook(11, 1)][hook(13, 4)] * avec[hook(12, 1)] - ablock[hook(11, 2)][hook(14, 4)] * avec[hook(12, 2)] - ablock[hook(11, 3)][hook(15, 4)] * avec[hook(12, 3)] - ablock[hook(11, 4)][hook(16, 4)] * avec[hook(12, 4)];
}

void matmul_sub(global double ablock[5][5], global double bblock[5][5], global double cblock[5][5]) {
  cblock[hook(18, 0)][hook(17, 0)] = cblock[hook(18, 0)][hook(17, 0)] - ablock[hook(11, 0)][hook(10, 0)] * bblock[hook(20, 0)][hook(19, 0)] - ablock[hook(11, 1)][hook(13, 0)] * bblock[hook(20, 0)][hook(19, 1)] - ablock[hook(11, 2)][hook(14, 0)] * bblock[hook(20, 0)][hook(19, 2)] - ablock[hook(11, 3)][hook(15, 0)] * bblock[hook(20, 0)][hook(19, 3)] - ablock[hook(11, 4)][hook(16, 0)] * bblock[hook(20, 0)][hook(19, 4)];
  cblock[hook(18, 0)][hook(17, 1)] = cblock[hook(18, 0)][hook(17, 1)] - ablock[hook(11, 0)][hook(10, 1)] * bblock[hook(20, 0)][hook(19, 0)] - ablock[hook(11, 1)][hook(13, 1)] * bblock[hook(20, 0)][hook(19, 1)] - ablock[hook(11, 2)][hook(14, 1)] * bblock[hook(20, 0)][hook(19, 2)] - ablock[hook(11, 3)][hook(15, 1)] * bblock[hook(20, 0)][hook(19, 3)] - ablock[hook(11, 4)][hook(16, 1)] * bblock[hook(20, 0)][hook(19, 4)];
  cblock[hook(18, 0)][hook(17, 2)] = cblock[hook(18, 0)][hook(17, 2)] - ablock[hook(11, 0)][hook(10, 2)] * bblock[hook(20, 0)][hook(19, 0)] - ablock[hook(11, 1)][hook(13, 2)] * bblock[hook(20, 0)][hook(19, 1)] - ablock[hook(11, 2)][hook(14, 2)] * bblock[hook(20, 0)][hook(19, 2)] - ablock[hook(11, 3)][hook(15, 2)] * bblock[hook(20, 0)][hook(19, 3)] - ablock[hook(11, 4)][hook(16, 2)] * bblock[hook(20, 0)][hook(19, 4)];
  cblock[hook(18, 0)][hook(17, 3)] = cblock[hook(18, 0)][hook(17, 3)] - ablock[hook(11, 0)][hook(10, 3)] * bblock[hook(20, 0)][hook(19, 0)] - ablock[hook(11, 1)][hook(13, 3)] * bblock[hook(20, 0)][hook(19, 1)] - ablock[hook(11, 2)][hook(14, 3)] * bblock[hook(20, 0)][hook(19, 2)] - ablock[hook(11, 3)][hook(15, 3)] * bblock[hook(20, 0)][hook(19, 3)] - ablock[hook(11, 4)][hook(16, 3)] * bblock[hook(20, 0)][hook(19, 4)];
  cblock[hook(18, 0)][hook(17, 4)] = cblock[hook(18, 0)][hook(17, 4)] - ablock[hook(11, 0)][hook(10, 4)] * bblock[hook(20, 0)][hook(19, 0)] - ablock[hook(11, 1)][hook(13, 4)] * bblock[hook(20, 0)][hook(19, 1)] - ablock[hook(11, 2)][hook(14, 4)] * bblock[hook(20, 0)][hook(19, 2)] - ablock[hook(11, 3)][hook(15, 4)] * bblock[hook(20, 0)][hook(19, 3)] - ablock[hook(11, 4)][hook(16, 4)] * bblock[hook(20, 0)][hook(19, 4)];
  cblock[hook(18, 1)][hook(21, 0)] = cblock[hook(18, 1)][hook(21, 0)] - ablock[hook(11, 0)][hook(10, 0)] * bblock[hook(20, 1)][hook(22, 0)] - ablock[hook(11, 1)][hook(13, 0)] * bblock[hook(20, 1)][hook(22, 1)] - ablock[hook(11, 2)][hook(14, 0)] * bblock[hook(20, 1)][hook(22, 2)] - ablock[hook(11, 3)][hook(15, 0)] * bblock[hook(20, 1)][hook(22, 3)] - ablock[hook(11, 4)][hook(16, 0)] * bblock[hook(20, 1)][hook(22, 4)];
  cblock[hook(18, 1)][hook(21, 1)] = cblock[hook(18, 1)][hook(21, 1)] - ablock[hook(11, 0)][hook(10, 1)] * bblock[hook(20, 1)][hook(22, 0)] - ablock[hook(11, 1)][hook(13, 1)] * bblock[hook(20, 1)][hook(22, 1)] - ablock[hook(11, 2)][hook(14, 1)] * bblock[hook(20, 1)][hook(22, 2)] - ablock[hook(11, 3)][hook(15, 1)] * bblock[hook(20, 1)][hook(22, 3)] - ablock[hook(11, 4)][hook(16, 1)] * bblock[hook(20, 1)][hook(22, 4)];
  cblock[hook(18, 1)][hook(21, 2)] = cblock[hook(18, 1)][hook(21, 2)] - ablock[hook(11, 0)][hook(10, 2)] * bblock[hook(20, 1)][hook(22, 0)] - ablock[hook(11, 1)][hook(13, 2)] * bblock[hook(20, 1)][hook(22, 1)] - ablock[hook(11, 2)][hook(14, 2)] * bblock[hook(20, 1)][hook(22, 2)] - ablock[hook(11, 3)][hook(15, 2)] * bblock[hook(20, 1)][hook(22, 3)] - ablock[hook(11, 4)][hook(16, 2)] * bblock[hook(20, 1)][hook(22, 4)];
  cblock[hook(18, 1)][hook(21, 3)] = cblock[hook(18, 1)][hook(21, 3)] - ablock[hook(11, 0)][hook(10, 3)] * bblock[hook(20, 1)][hook(22, 0)] - ablock[hook(11, 1)][hook(13, 3)] * bblock[hook(20, 1)][hook(22, 1)] - ablock[hook(11, 2)][hook(14, 3)] * bblock[hook(20, 1)][hook(22, 2)] - ablock[hook(11, 3)][hook(15, 3)] * bblock[hook(20, 1)][hook(22, 3)] - ablock[hook(11, 4)][hook(16, 3)] * bblock[hook(20, 1)][hook(22, 4)];
  cblock[hook(18, 1)][hook(21, 4)] = cblock[hook(18, 1)][hook(21, 4)] - ablock[hook(11, 0)][hook(10, 4)] * bblock[hook(20, 1)][hook(22, 0)] - ablock[hook(11, 1)][hook(13, 4)] * bblock[hook(20, 1)][hook(22, 1)] - ablock[hook(11, 2)][hook(14, 4)] * bblock[hook(20, 1)][hook(22, 2)] - ablock[hook(11, 3)][hook(15, 4)] * bblock[hook(20, 1)][hook(22, 3)] - ablock[hook(11, 4)][hook(16, 4)] * bblock[hook(20, 1)][hook(22, 4)];
  cblock[hook(18, 2)][hook(23, 0)] = cblock[hook(18, 2)][hook(23, 0)] - ablock[hook(11, 0)][hook(10, 0)] * bblock[hook(20, 2)][hook(24, 0)] - ablock[hook(11, 1)][hook(13, 0)] * bblock[hook(20, 2)][hook(24, 1)] - ablock[hook(11, 2)][hook(14, 0)] * bblock[hook(20, 2)][hook(24, 2)] - ablock[hook(11, 3)][hook(15, 0)] * bblock[hook(20, 2)][hook(24, 3)] - ablock[hook(11, 4)][hook(16, 0)] * bblock[hook(20, 2)][hook(24, 4)];
  cblock[hook(18, 2)][hook(23, 1)] = cblock[hook(18, 2)][hook(23, 1)] - ablock[hook(11, 0)][hook(10, 1)] * bblock[hook(20, 2)][hook(24, 0)] - ablock[hook(11, 1)][hook(13, 1)] * bblock[hook(20, 2)][hook(24, 1)] - ablock[hook(11, 2)][hook(14, 1)] * bblock[hook(20, 2)][hook(24, 2)] - ablock[hook(11, 3)][hook(15, 1)] * bblock[hook(20, 2)][hook(24, 3)] - ablock[hook(11, 4)][hook(16, 1)] * bblock[hook(20, 2)][hook(24, 4)];
  cblock[hook(18, 2)][hook(23, 2)] = cblock[hook(18, 2)][hook(23, 2)] - ablock[hook(11, 0)][hook(10, 2)] * bblock[hook(20, 2)][hook(24, 0)] - ablock[hook(11, 1)][hook(13, 2)] * bblock[hook(20, 2)][hook(24, 1)] - ablock[hook(11, 2)][hook(14, 2)] * bblock[hook(20, 2)][hook(24, 2)] - ablock[hook(11, 3)][hook(15, 2)] * bblock[hook(20, 2)][hook(24, 3)] - ablock[hook(11, 4)][hook(16, 2)] * bblock[hook(20, 2)][hook(24, 4)];
  cblock[hook(18, 2)][hook(23, 3)] = cblock[hook(18, 2)][hook(23, 3)] - ablock[hook(11, 0)][hook(10, 3)] * bblock[hook(20, 2)][hook(24, 0)] - ablock[hook(11, 1)][hook(13, 3)] * bblock[hook(20, 2)][hook(24, 1)] - ablock[hook(11, 2)][hook(14, 3)] * bblock[hook(20, 2)][hook(24, 2)] - ablock[hook(11, 3)][hook(15, 3)] * bblock[hook(20, 2)][hook(24, 3)] - ablock[hook(11, 4)][hook(16, 3)] * bblock[hook(20, 2)][hook(24, 4)];
  cblock[hook(18, 2)][hook(23, 4)] = cblock[hook(18, 2)][hook(23, 4)] - ablock[hook(11, 0)][hook(10, 4)] * bblock[hook(20, 2)][hook(24, 0)] - ablock[hook(11, 1)][hook(13, 4)] * bblock[hook(20, 2)][hook(24, 1)] - ablock[hook(11, 2)][hook(14, 4)] * bblock[hook(20, 2)][hook(24, 2)] - ablock[hook(11, 3)][hook(15, 4)] * bblock[hook(20, 2)][hook(24, 3)] - ablock[hook(11, 4)][hook(16, 4)] * bblock[hook(20, 2)][hook(24, 4)];
  cblock[hook(18, 3)][hook(25, 0)] = cblock[hook(18, 3)][hook(25, 0)] - ablock[hook(11, 0)][hook(10, 0)] * bblock[hook(20, 3)][hook(26, 0)] - ablock[hook(11, 1)][hook(13, 0)] * bblock[hook(20, 3)][hook(26, 1)] - ablock[hook(11, 2)][hook(14, 0)] * bblock[hook(20, 3)][hook(26, 2)] - ablock[hook(11, 3)][hook(15, 0)] * bblock[hook(20, 3)][hook(26, 3)] - ablock[hook(11, 4)][hook(16, 0)] * bblock[hook(20, 3)][hook(26, 4)];
  cblock[hook(18, 3)][hook(25, 1)] = cblock[hook(18, 3)][hook(25, 1)] - ablock[hook(11, 0)][hook(10, 1)] * bblock[hook(20, 3)][hook(26, 0)] - ablock[hook(11, 1)][hook(13, 1)] * bblock[hook(20, 3)][hook(26, 1)] - ablock[hook(11, 2)][hook(14, 1)] * bblock[hook(20, 3)][hook(26, 2)] - ablock[hook(11, 3)][hook(15, 1)] * bblock[hook(20, 3)][hook(26, 3)] - ablock[hook(11, 4)][hook(16, 1)] * bblock[hook(20, 3)][hook(26, 4)];
  cblock[hook(18, 3)][hook(25, 2)] = cblock[hook(18, 3)][hook(25, 2)] - ablock[hook(11, 0)][hook(10, 2)] * bblock[hook(20, 3)][hook(26, 0)] - ablock[hook(11, 1)][hook(13, 2)] * bblock[hook(20, 3)][hook(26, 1)] - ablock[hook(11, 2)][hook(14, 2)] * bblock[hook(20, 3)][hook(26, 2)] - ablock[hook(11, 3)][hook(15, 2)] * bblock[hook(20, 3)][hook(26, 3)] - ablock[hook(11, 4)][hook(16, 2)] * bblock[hook(20, 3)][hook(26, 4)];
  cblock[hook(18, 3)][hook(25, 3)] = cblock[hook(18, 3)][hook(25, 3)] - ablock[hook(11, 0)][hook(10, 3)] * bblock[hook(20, 3)][hook(26, 0)] - ablock[hook(11, 1)][hook(13, 3)] * bblock[hook(20, 3)][hook(26, 1)] - ablock[hook(11, 2)][hook(14, 3)] * bblock[hook(20, 3)][hook(26, 2)] - ablock[hook(11, 3)][hook(15, 3)] * bblock[hook(20, 3)][hook(26, 3)] - ablock[hook(11, 4)][hook(16, 3)] * bblock[hook(20, 3)][hook(26, 4)];
  cblock[hook(18, 3)][hook(25, 4)] = cblock[hook(18, 3)][hook(25, 4)] - ablock[hook(11, 0)][hook(10, 4)] * bblock[hook(20, 3)][hook(26, 0)] - ablock[hook(11, 1)][hook(13, 4)] * bblock[hook(20, 3)][hook(26, 1)] - ablock[hook(11, 2)][hook(14, 4)] * bblock[hook(20, 3)][hook(26, 2)] - ablock[hook(11, 3)][hook(15, 4)] * bblock[hook(20, 3)][hook(26, 3)] - ablock[hook(11, 4)][hook(16, 4)] * bblock[hook(20, 3)][hook(26, 4)];
  cblock[hook(18, 4)][hook(27, 0)] = cblock[hook(18, 4)][hook(27, 0)] - ablock[hook(11, 0)][hook(10, 0)] * bblock[hook(20, 4)][hook(28, 0)] - ablock[hook(11, 1)][hook(13, 0)] * bblock[hook(20, 4)][hook(28, 1)] - ablock[hook(11, 2)][hook(14, 0)] * bblock[hook(20, 4)][hook(28, 2)] - ablock[hook(11, 3)][hook(15, 0)] * bblock[hook(20, 4)][hook(28, 3)] - ablock[hook(11, 4)][hook(16, 0)] * bblock[hook(20, 4)][hook(28, 4)];
  cblock[hook(18, 4)][hook(27, 1)] = cblock[hook(18, 4)][hook(27, 1)] - ablock[hook(11, 0)][hook(10, 1)] * bblock[hook(20, 4)][hook(28, 0)] - ablock[hook(11, 1)][hook(13, 1)] * bblock[hook(20, 4)][hook(28, 1)] - ablock[hook(11, 2)][hook(14, 1)] * bblock[hook(20, 4)][hook(28, 2)] - ablock[hook(11, 3)][hook(15, 1)] * bblock[hook(20, 4)][hook(28, 3)] - ablock[hook(11, 4)][hook(16, 1)] * bblock[hook(20, 4)][hook(28, 4)];
  cblock[hook(18, 4)][hook(27, 2)] = cblock[hook(18, 4)][hook(27, 2)] - ablock[hook(11, 0)][hook(10, 2)] * bblock[hook(20, 4)][hook(28, 0)] - ablock[hook(11, 1)][hook(13, 2)] * bblock[hook(20, 4)][hook(28, 1)] - ablock[hook(11, 2)][hook(14, 2)] * bblock[hook(20, 4)][hook(28, 2)] - ablock[hook(11, 3)][hook(15, 2)] * bblock[hook(20, 4)][hook(28, 3)] - ablock[hook(11, 4)][hook(16, 2)] * bblock[hook(20, 4)][hook(28, 4)];
  cblock[hook(18, 4)][hook(27, 3)] = cblock[hook(18, 4)][hook(27, 3)] - ablock[hook(11, 0)][hook(10, 3)] * bblock[hook(20, 4)][hook(28, 0)] - ablock[hook(11, 1)][hook(13, 3)] * bblock[hook(20, 4)][hook(28, 1)] - ablock[hook(11, 2)][hook(14, 3)] * bblock[hook(20, 4)][hook(28, 2)] - ablock[hook(11, 3)][hook(15, 3)] * bblock[hook(20, 4)][hook(28, 3)] - ablock[hook(11, 4)][hook(16, 3)] * bblock[hook(20, 4)][hook(28, 4)];
  cblock[hook(18, 4)][hook(27, 4)] = cblock[hook(18, 4)][hook(27, 4)] - ablock[hook(11, 0)][hook(10, 4)] * bblock[hook(20, 4)][hook(28, 0)] - ablock[hook(11, 1)][hook(13, 4)] * bblock[hook(20, 4)][hook(28, 1)] - ablock[hook(11, 2)][hook(14, 4)] * bblock[hook(20, 4)][hook(28, 2)] - ablock[hook(11, 3)][hook(15, 4)] * bblock[hook(20, 4)][hook(28, 3)] - ablock[hook(11, 4)][hook(16, 4)] * bblock[hook(20, 4)][hook(28, 4)];
}

void binvcrhs(global double lhs[5][5], global double c[5][5], global double r[5]) {
  double pivot, coeff;

  pivot = 1.00 / lhs[hook(30, 0)][hook(29, 0)];
  lhs[hook(30, 1)][hook(31, 0)] = lhs[hook(30, 1)][hook(31, 0)] * pivot;
  lhs[hook(30, 2)][hook(32, 0)] = lhs[hook(30, 2)][hook(32, 0)] * pivot;
  lhs[hook(30, 3)][hook(33, 0)] = lhs[hook(30, 3)][hook(33, 0)] * pivot;
  lhs[hook(30, 4)][hook(34, 0)] = lhs[hook(30, 4)][hook(34, 0)] * pivot;
  c[hook(36, 0)][hook(35, 0)] = c[hook(36, 0)][hook(35, 0)] * pivot;
  c[hook(36, 1)][hook(37, 0)] = c[hook(36, 1)][hook(37, 0)] * pivot;
  c[hook(36, 2)][hook(38, 0)] = c[hook(36, 2)][hook(38, 0)] * pivot;
  c[hook(36, 3)][hook(39, 0)] = c[hook(36, 3)][hook(39, 0)] * pivot;
  c[hook(36, 4)][hook(40, 0)] = c[hook(36, 4)][hook(40, 0)] * pivot;
  r[hook(41, 0)] = r[hook(41, 0)] * pivot;

  coeff = lhs[hook(30, 0)][hook(29, 1)];
  lhs[hook(30, 1)][hook(31, 1)] = lhs[hook(30, 1)][hook(31, 1)] - coeff * lhs[hook(30, 1)][hook(31, 0)];
  lhs[hook(30, 2)][hook(32, 1)] = lhs[hook(30, 2)][hook(32, 1)] - coeff * lhs[hook(30, 2)][hook(32, 0)];
  lhs[hook(30, 3)][hook(33, 1)] = lhs[hook(30, 3)][hook(33, 1)] - coeff * lhs[hook(30, 3)][hook(33, 0)];
  lhs[hook(30, 4)][hook(34, 1)] = lhs[hook(30, 4)][hook(34, 1)] - coeff * lhs[hook(30, 4)][hook(34, 0)];
  c[hook(36, 0)][hook(35, 1)] = c[hook(36, 0)][hook(35, 1)] - coeff * c[hook(36, 0)][hook(35, 0)];
  c[hook(36, 1)][hook(37, 1)] = c[hook(36, 1)][hook(37, 1)] - coeff * c[hook(36, 1)][hook(37, 0)];
  c[hook(36, 2)][hook(38, 1)] = c[hook(36, 2)][hook(38, 1)] - coeff * c[hook(36, 2)][hook(38, 0)];
  c[hook(36, 3)][hook(39, 1)] = c[hook(36, 3)][hook(39, 1)] - coeff * c[hook(36, 3)][hook(39, 0)];
  c[hook(36, 4)][hook(40, 1)] = c[hook(36, 4)][hook(40, 1)] - coeff * c[hook(36, 4)][hook(40, 0)];
  r[hook(41, 1)] = r[hook(41, 1)] - coeff * r[hook(41, 0)];

  coeff = lhs[hook(30, 0)][hook(29, 2)];
  lhs[hook(30, 1)][hook(31, 2)] = lhs[hook(30, 1)][hook(31, 2)] - coeff * lhs[hook(30, 1)][hook(31, 0)];
  lhs[hook(30, 2)][hook(32, 2)] = lhs[hook(30, 2)][hook(32, 2)] - coeff * lhs[hook(30, 2)][hook(32, 0)];
  lhs[hook(30, 3)][hook(33, 2)] = lhs[hook(30, 3)][hook(33, 2)] - coeff * lhs[hook(30, 3)][hook(33, 0)];
  lhs[hook(30, 4)][hook(34, 2)] = lhs[hook(30, 4)][hook(34, 2)] - coeff * lhs[hook(30, 4)][hook(34, 0)];
  c[hook(36, 0)][hook(35, 2)] = c[hook(36, 0)][hook(35, 2)] - coeff * c[hook(36, 0)][hook(35, 0)];
  c[hook(36, 1)][hook(37, 2)] = c[hook(36, 1)][hook(37, 2)] - coeff * c[hook(36, 1)][hook(37, 0)];
  c[hook(36, 2)][hook(38, 2)] = c[hook(36, 2)][hook(38, 2)] - coeff * c[hook(36, 2)][hook(38, 0)];
  c[hook(36, 3)][hook(39, 2)] = c[hook(36, 3)][hook(39, 2)] - coeff * c[hook(36, 3)][hook(39, 0)];
  c[hook(36, 4)][hook(40, 2)] = c[hook(36, 4)][hook(40, 2)] - coeff * c[hook(36, 4)][hook(40, 0)];
  r[hook(41, 2)] = r[hook(41, 2)] - coeff * r[hook(41, 0)];

  coeff = lhs[hook(30, 0)][hook(29, 3)];
  lhs[hook(30, 1)][hook(31, 3)] = lhs[hook(30, 1)][hook(31, 3)] - coeff * lhs[hook(30, 1)][hook(31, 0)];
  lhs[hook(30, 2)][hook(32, 3)] = lhs[hook(30, 2)][hook(32, 3)] - coeff * lhs[hook(30, 2)][hook(32, 0)];
  lhs[hook(30, 3)][hook(33, 3)] = lhs[hook(30, 3)][hook(33, 3)] - coeff * lhs[hook(30, 3)][hook(33, 0)];
  lhs[hook(30, 4)][hook(34, 3)] = lhs[hook(30, 4)][hook(34, 3)] - coeff * lhs[hook(30, 4)][hook(34, 0)];
  c[hook(36, 0)][hook(35, 3)] = c[hook(36, 0)][hook(35, 3)] - coeff * c[hook(36, 0)][hook(35, 0)];
  c[hook(36, 1)][hook(37, 3)] = c[hook(36, 1)][hook(37, 3)] - coeff * c[hook(36, 1)][hook(37, 0)];
  c[hook(36, 2)][hook(38, 3)] = c[hook(36, 2)][hook(38, 3)] - coeff * c[hook(36, 2)][hook(38, 0)];
  c[hook(36, 3)][hook(39, 3)] = c[hook(36, 3)][hook(39, 3)] - coeff * c[hook(36, 3)][hook(39, 0)];
  c[hook(36, 4)][hook(40, 3)] = c[hook(36, 4)][hook(40, 3)] - coeff * c[hook(36, 4)][hook(40, 0)];
  r[hook(41, 3)] = r[hook(41, 3)] - coeff * r[hook(41, 0)];

  coeff = lhs[hook(30, 0)][hook(29, 4)];
  lhs[hook(30, 1)][hook(31, 4)] = lhs[hook(30, 1)][hook(31, 4)] - coeff * lhs[hook(30, 1)][hook(31, 0)];
  lhs[hook(30, 2)][hook(32, 4)] = lhs[hook(30, 2)][hook(32, 4)] - coeff * lhs[hook(30, 2)][hook(32, 0)];
  lhs[hook(30, 3)][hook(33, 4)] = lhs[hook(30, 3)][hook(33, 4)] - coeff * lhs[hook(30, 3)][hook(33, 0)];
  lhs[hook(30, 4)][hook(34, 4)] = lhs[hook(30, 4)][hook(34, 4)] - coeff * lhs[hook(30, 4)][hook(34, 0)];
  c[hook(36, 0)][hook(35, 4)] = c[hook(36, 0)][hook(35, 4)] - coeff * c[hook(36, 0)][hook(35, 0)];
  c[hook(36, 1)][hook(37, 4)] = c[hook(36, 1)][hook(37, 4)] - coeff * c[hook(36, 1)][hook(37, 0)];
  c[hook(36, 2)][hook(38, 4)] = c[hook(36, 2)][hook(38, 4)] - coeff * c[hook(36, 2)][hook(38, 0)];
  c[hook(36, 3)][hook(39, 4)] = c[hook(36, 3)][hook(39, 4)] - coeff * c[hook(36, 3)][hook(39, 0)];
  c[hook(36, 4)][hook(40, 4)] = c[hook(36, 4)][hook(40, 4)] - coeff * c[hook(36, 4)][hook(40, 0)];
  r[hook(41, 4)] = r[hook(41, 4)] - coeff * r[hook(41, 0)];

  pivot = 1.00 / lhs[hook(30, 1)][hook(31, 1)];
  lhs[hook(30, 2)][hook(32, 1)] = lhs[hook(30, 2)][hook(32, 1)] * pivot;
  lhs[hook(30, 3)][hook(33, 1)] = lhs[hook(30, 3)][hook(33, 1)] * pivot;
  lhs[hook(30, 4)][hook(34, 1)] = lhs[hook(30, 4)][hook(34, 1)] * pivot;
  c[hook(36, 0)][hook(35, 1)] = c[hook(36, 0)][hook(35, 1)] * pivot;
  c[hook(36, 1)][hook(37, 1)] = c[hook(36, 1)][hook(37, 1)] * pivot;
  c[hook(36, 2)][hook(38, 1)] = c[hook(36, 2)][hook(38, 1)] * pivot;
  c[hook(36, 3)][hook(39, 1)] = c[hook(36, 3)][hook(39, 1)] * pivot;
  c[hook(36, 4)][hook(40, 1)] = c[hook(36, 4)][hook(40, 1)] * pivot;
  r[hook(41, 1)] = r[hook(41, 1)] * pivot;

  coeff = lhs[hook(30, 1)][hook(31, 0)];
  lhs[hook(30, 2)][hook(32, 0)] = lhs[hook(30, 2)][hook(32, 0)] - coeff * lhs[hook(30, 2)][hook(32, 1)];
  lhs[hook(30, 3)][hook(33, 0)] = lhs[hook(30, 3)][hook(33, 0)] - coeff * lhs[hook(30, 3)][hook(33, 1)];
  lhs[hook(30, 4)][hook(34, 0)] = lhs[hook(30, 4)][hook(34, 0)] - coeff * lhs[hook(30, 4)][hook(34, 1)];
  c[hook(36, 0)][hook(35, 0)] = c[hook(36, 0)][hook(35, 0)] - coeff * c[hook(36, 0)][hook(35, 1)];
  c[hook(36, 1)][hook(37, 0)] = c[hook(36, 1)][hook(37, 0)] - coeff * c[hook(36, 1)][hook(37, 1)];
  c[hook(36, 2)][hook(38, 0)] = c[hook(36, 2)][hook(38, 0)] - coeff * c[hook(36, 2)][hook(38, 1)];
  c[hook(36, 3)][hook(39, 0)] = c[hook(36, 3)][hook(39, 0)] - coeff * c[hook(36, 3)][hook(39, 1)];
  c[hook(36, 4)][hook(40, 0)] = c[hook(36, 4)][hook(40, 0)] - coeff * c[hook(36, 4)][hook(40, 1)];
  r[hook(41, 0)] = r[hook(41, 0)] - coeff * r[hook(41, 1)];

  coeff = lhs[hook(30, 1)][hook(31, 2)];
  lhs[hook(30, 2)][hook(32, 2)] = lhs[hook(30, 2)][hook(32, 2)] - coeff * lhs[hook(30, 2)][hook(32, 1)];
  lhs[hook(30, 3)][hook(33, 2)] = lhs[hook(30, 3)][hook(33, 2)] - coeff * lhs[hook(30, 3)][hook(33, 1)];
  lhs[hook(30, 4)][hook(34, 2)] = lhs[hook(30, 4)][hook(34, 2)] - coeff * lhs[hook(30, 4)][hook(34, 1)];
  c[hook(36, 0)][hook(35, 2)] = c[hook(36, 0)][hook(35, 2)] - coeff * c[hook(36, 0)][hook(35, 1)];
  c[hook(36, 1)][hook(37, 2)] = c[hook(36, 1)][hook(37, 2)] - coeff * c[hook(36, 1)][hook(37, 1)];
  c[hook(36, 2)][hook(38, 2)] = c[hook(36, 2)][hook(38, 2)] - coeff * c[hook(36, 2)][hook(38, 1)];
  c[hook(36, 3)][hook(39, 2)] = c[hook(36, 3)][hook(39, 2)] - coeff * c[hook(36, 3)][hook(39, 1)];
  c[hook(36, 4)][hook(40, 2)] = c[hook(36, 4)][hook(40, 2)] - coeff * c[hook(36, 4)][hook(40, 1)];
  r[hook(41, 2)] = r[hook(41, 2)] - coeff * r[hook(41, 1)];

  coeff = lhs[hook(30, 1)][hook(31, 3)];
  lhs[hook(30, 2)][hook(32, 3)] = lhs[hook(30, 2)][hook(32, 3)] - coeff * lhs[hook(30, 2)][hook(32, 1)];
  lhs[hook(30, 3)][hook(33, 3)] = lhs[hook(30, 3)][hook(33, 3)] - coeff * lhs[hook(30, 3)][hook(33, 1)];
  lhs[hook(30, 4)][hook(34, 3)] = lhs[hook(30, 4)][hook(34, 3)] - coeff * lhs[hook(30, 4)][hook(34, 1)];
  c[hook(36, 0)][hook(35, 3)] = c[hook(36, 0)][hook(35, 3)] - coeff * c[hook(36, 0)][hook(35, 1)];
  c[hook(36, 1)][hook(37, 3)] = c[hook(36, 1)][hook(37, 3)] - coeff * c[hook(36, 1)][hook(37, 1)];
  c[hook(36, 2)][hook(38, 3)] = c[hook(36, 2)][hook(38, 3)] - coeff * c[hook(36, 2)][hook(38, 1)];
  c[hook(36, 3)][hook(39, 3)] = c[hook(36, 3)][hook(39, 3)] - coeff * c[hook(36, 3)][hook(39, 1)];
  c[hook(36, 4)][hook(40, 3)] = c[hook(36, 4)][hook(40, 3)] - coeff * c[hook(36, 4)][hook(40, 1)];
  r[hook(41, 3)] = r[hook(41, 3)] - coeff * r[hook(41, 1)];

  coeff = lhs[hook(30, 1)][hook(31, 4)];
  lhs[hook(30, 2)][hook(32, 4)] = lhs[hook(30, 2)][hook(32, 4)] - coeff * lhs[hook(30, 2)][hook(32, 1)];
  lhs[hook(30, 3)][hook(33, 4)] = lhs[hook(30, 3)][hook(33, 4)] - coeff * lhs[hook(30, 3)][hook(33, 1)];
  lhs[hook(30, 4)][hook(34, 4)] = lhs[hook(30, 4)][hook(34, 4)] - coeff * lhs[hook(30, 4)][hook(34, 1)];
  c[hook(36, 0)][hook(35, 4)] = c[hook(36, 0)][hook(35, 4)] - coeff * c[hook(36, 0)][hook(35, 1)];
  c[hook(36, 1)][hook(37, 4)] = c[hook(36, 1)][hook(37, 4)] - coeff * c[hook(36, 1)][hook(37, 1)];
  c[hook(36, 2)][hook(38, 4)] = c[hook(36, 2)][hook(38, 4)] - coeff * c[hook(36, 2)][hook(38, 1)];
  c[hook(36, 3)][hook(39, 4)] = c[hook(36, 3)][hook(39, 4)] - coeff * c[hook(36, 3)][hook(39, 1)];
  c[hook(36, 4)][hook(40, 4)] = c[hook(36, 4)][hook(40, 4)] - coeff * c[hook(36, 4)][hook(40, 1)];
  r[hook(41, 4)] = r[hook(41, 4)] - coeff * r[hook(41, 1)];

  pivot = 1.00 / lhs[hook(30, 2)][hook(32, 2)];
  lhs[hook(30, 3)][hook(33, 2)] = lhs[hook(30, 3)][hook(33, 2)] * pivot;
  lhs[hook(30, 4)][hook(34, 2)] = lhs[hook(30, 4)][hook(34, 2)] * pivot;
  c[hook(36, 0)][hook(35, 2)] = c[hook(36, 0)][hook(35, 2)] * pivot;
  c[hook(36, 1)][hook(37, 2)] = c[hook(36, 1)][hook(37, 2)] * pivot;
  c[hook(36, 2)][hook(38, 2)] = c[hook(36, 2)][hook(38, 2)] * pivot;
  c[hook(36, 3)][hook(39, 2)] = c[hook(36, 3)][hook(39, 2)] * pivot;
  c[hook(36, 4)][hook(40, 2)] = c[hook(36, 4)][hook(40, 2)] * pivot;
  r[hook(41, 2)] = r[hook(41, 2)] * pivot;

  coeff = lhs[hook(30, 2)][hook(32, 0)];
  lhs[hook(30, 3)][hook(33, 0)] = lhs[hook(30, 3)][hook(33, 0)] - coeff * lhs[hook(30, 3)][hook(33, 2)];
  lhs[hook(30, 4)][hook(34, 0)] = lhs[hook(30, 4)][hook(34, 0)] - coeff * lhs[hook(30, 4)][hook(34, 2)];
  c[hook(36, 0)][hook(35, 0)] = c[hook(36, 0)][hook(35, 0)] - coeff * c[hook(36, 0)][hook(35, 2)];
  c[hook(36, 1)][hook(37, 0)] = c[hook(36, 1)][hook(37, 0)] - coeff * c[hook(36, 1)][hook(37, 2)];
  c[hook(36, 2)][hook(38, 0)] = c[hook(36, 2)][hook(38, 0)] - coeff * c[hook(36, 2)][hook(38, 2)];
  c[hook(36, 3)][hook(39, 0)] = c[hook(36, 3)][hook(39, 0)] - coeff * c[hook(36, 3)][hook(39, 2)];
  c[hook(36, 4)][hook(40, 0)] = c[hook(36, 4)][hook(40, 0)] - coeff * c[hook(36, 4)][hook(40, 2)];
  r[hook(41, 0)] = r[hook(41, 0)] - coeff * r[hook(41, 2)];

  coeff = lhs[hook(30, 2)][hook(32, 1)];
  lhs[hook(30, 3)][hook(33, 1)] = lhs[hook(30, 3)][hook(33, 1)] - coeff * lhs[hook(30, 3)][hook(33, 2)];
  lhs[hook(30, 4)][hook(34, 1)] = lhs[hook(30, 4)][hook(34, 1)] - coeff * lhs[hook(30, 4)][hook(34, 2)];
  c[hook(36, 0)][hook(35, 1)] = c[hook(36, 0)][hook(35, 1)] - coeff * c[hook(36, 0)][hook(35, 2)];
  c[hook(36, 1)][hook(37, 1)] = c[hook(36, 1)][hook(37, 1)] - coeff * c[hook(36, 1)][hook(37, 2)];
  c[hook(36, 2)][hook(38, 1)] = c[hook(36, 2)][hook(38, 1)] - coeff * c[hook(36, 2)][hook(38, 2)];
  c[hook(36, 3)][hook(39, 1)] = c[hook(36, 3)][hook(39, 1)] - coeff * c[hook(36, 3)][hook(39, 2)];
  c[hook(36, 4)][hook(40, 1)] = c[hook(36, 4)][hook(40, 1)] - coeff * c[hook(36, 4)][hook(40, 2)];
  r[hook(41, 1)] = r[hook(41, 1)] - coeff * r[hook(41, 2)];

  coeff = lhs[hook(30, 2)][hook(32, 3)];
  lhs[hook(30, 3)][hook(33, 3)] = lhs[hook(30, 3)][hook(33, 3)] - coeff * lhs[hook(30, 3)][hook(33, 2)];
  lhs[hook(30, 4)][hook(34, 3)] = lhs[hook(30, 4)][hook(34, 3)] - coeff * lhs[hook(30, 4)][hook(34, 2)];
  c[hook(36, 0)][hook(35, 3)] = c[hook(36, 0)][hook(35, 3)] - coeff * c[hook(36, 0)][hook(35, 2)];
  c[hook(36, 1)][hook(37, 3)] = c[hook(36, 1)][hook(37, 3)] - coeff * c[hook(36, 1)][hook(37, 2)];
  c[hook(36, 2)][hook(38, 3)] = c[hook(36, 2)][hook(38, 3)] - coeff * c[hook(36, 2)][hook(38, 2)];
  c[hook(36, 3)][hook(39, 3)] = c[hook(36, 3)][hook(39, 3)] - coeff * c[hook(36, 3)][hook(39, 2)];
  c[hook(36, 4)][hook(40, 3)] = c[hook(36, 4)][hook(40, 3)] - coeff * c[hook(36, 4)][hook(40, 2)];
  r[hook(41, 3)] = r[hook(41, 3)] - coeff * r[hook(41, 2)];

  coeff = lhs[hook(30, 2)][hook(32, 4)];
  lhs[hook(30, 3)][hook(33, 4)] = lhs[hook(30, 3)][hook(33, 4)] - coeff * lhs[hook(30, 3)][hook(33, 2)];
  lhs[hook(30, 4)][hook(34, 4)] = lhs[hook(30, 4)][hook(34, 4)] - coeff * lhs[hook(30, 4)][hook(34, 2)];
  c[hook(36, 0)][hook(35, 4)] = c[hook(36, 0)][hook(35, 4)] - coeff * c[hook(36, 0)][hook(35, 2)];
  c[hook(36, 1)][hook(37, 4)] = c[hook(36, 1)][hook(37, 4)] - coeff * c[hook(36, 1)][hook(37, 2)];
  c[hook(36, 2)][hook(38, 4)] = c[hook(36, 2)][hook(38, 4)] - coeff * c[hook(36, 2)][hook(38, 2)];
  c[hook(36, 3)][hook(39, 4)] = c[hook(36, 3)][hook(39, 4)] - coeff * c[hook(36, 3)][hook(39, 2)];
  c[hook(36, 4)][hook(40, 4)] = c[hook(36, 4)][hook(40, 4)] - coeff * c[hook(36, 4)][hook(40, 2)];
  r[hook(41, 4)] = r[hook(41, 4)] - coeff * r[hook(41, 2)];

  pivot = 1.00 / lhs[hook(30, 3)][hook(33, 3)];
  lhs[hook(30, 4)][hook(34, 3)] = lhs[hook(30, 4)][hook(34, 3)] * pivot;
  c[hook(36, 0)][hook(35, 3)] = c[hook(36, 0)][hook(35, 3)] * pivot;
  c[hook(36, 1)][hook(37, 3)] = c[hook(36, 1)][hook(37, 3)] * pivot;
  c[hook(36, 2)][hook(38, 3)] = c[hook(36, 2)][hook(38, 3)] * pivot;
  c[hook(36, 3)][hook(39, 3)] = c[hook(36, 3)][hook(39, 3)] * pivot;
  c[hook(36, 4)][hook(40, 3)] = c[hook(36, 4)][hook(40, 3)] * pivot;
  r[hook(41, 3)] = r[hook(41, 3)] * pivot;

  coeff = lhs[hook(30, 3)][hook(33, 0)];
  lhs[hook(30, 4)][hook(34, 0)] = lhs[hook(30, 4)][hook(34, 0)] - coeff * lhs[hook(30, 4)][hook(34, 3)];
  c[hook(36, 0)][hook(35, 0)] = c[hook(36, 0)][hook(35, 0)] - coeff * c[hook(36, 0)][hook(35, 3)];
  c[hook(36, 1)][hook(37, 0)] = c[hook(36, 1)][hook(37, 0)] - coeff * c[hook(36, 1)][hook(37, 3)];
  c[hook(36, 2)][hook(38, 0)] = c[hook(36, 2)][hook(38, 0)] - coeff * c[hook(36, 2)][hook(38, 3)];
  c[hook(36, 3)][hook(39, 0)] = c[hook(36, 3)][hook(39, 0)] - coeff * c[hook(36, 3)][hook(39, 3)];
  c[hook(36, 4)][hook(40, 0)] = c[hook(36, 4)][hook(40, 0)] - coeff * c[hook(36, 4)][hook(40, 3)];
  r[hook(41, 0)] = r[hook(41, 0)] - coeff * r[hook(41, 3)];

  coeff = lhs[hook(30, 3)][hook(33, 1)];
  lhs[hook(30, 4)][hook(34, 1)] = lhs[hook(30, 4)][hook(34, 1)] - coeff * lhs[hook(30, 4)][hook(34, 3)];
  c[hook(36, 0)][hook(35, 1)] = c[hook(36, 0)][hook(35, 1)] - coeff * c[hook(36, 0)][hook(35, 3)];
  c[hook(36, 1)][hook(37, 1)] = c[hook(36, 1)][hook(37, 1)] - coeff * c[hook(36, 1)][hook(37, 3)];
  c[hook(36, 2)][hook(38, 1)] = c[hook(36, 2)][hook(38, 1)] - coeff * c[hook(36, 2)][hook(38, 3)];
  c[hook(36, 3)][hook(39, 1)] = c[hook(36, 3)][hook(39, 1)] - coeff * c[hook(36, 3)][hook(39, 3)];
  c[hook(36, 4)][hook(40, 1)] = c[hook(36, 4)][hook(40, 1)] - coeff * c[hook(36, 4)][hook(40, 3)];
  r[hook(41, 1)] = r[hook(41, 1)] - coeff * r[hook(41, 3)];

  coeff = lhs[hook(30, 3)][hook(33, 2)];
  lhs[hook(30, 4)][hook(34, 2)] = lhs[hook(30, 4)][hook(34, 2)] - coeff * lhs[hook(30, 4)][hook(34, 3)];
  c[hook(36, 0)][hook(35, 2)] = c[hook(36, 0)][hook(35, 2)] - coeff * c[hook(36, 0)][hook(35, 3)];
  c[hook(36, 1)][hook(37, 2)] = c[hook(36, 1)][hook(37, 2)] - coeff * c[hook(36, 1)][hook(37, 3)];
  c[hook(36, 2)][hook(38, 2)] = c[hook(36, 2)][hook(38, 2)] - coeff * c[hook(36, 2)][hook(38, 3)];
  c[hook(36, 3)][hook(39, 2)] = c[hook(36, 3)][hook(39, 2)] - coeff * c[hook(36, 3)][hook(39, 3)];
  c[hook(36, 4)][hook(40, 2)] = c[hook(36, 4)][hook(40, 2)] - coeff * c[hook(36, 4)][hook(40, 3)];
  r[hook(41, 2)] = r[hook(41, 2)] - coeff * r[hook(41, 3)];

  coeff = lhs[hook(30, 3)][hook(33, 4)];
  lhs[hook(30, 4)][hook(34, 4)] = lhs[hook(30, 4)][hook(34, 4)] - coeff * lhs[hook(30, 4)][hook(34, 3)];
  c[hook(36, 0)][hook(35, 4)] = c[hook(36, 0)][hook(35, 4)] - coeff * c[hook(36, 0)][hook(35, 3)];
  c[hook(36, 1)][hook(37, 4)] = c[hook(36, 1)][hook(37, 4)] - coeff * c[hook(36, 1)][hook(37, 3)];
  c[hook(36, 2)][hook(38, 4)] = c[hook(36, 2)][hook(38, 4)] - coeff * c[hook(36, 2)][hook(38, 3)];
  c[hook(36, 3)][hook(39, 4)] = c[hook(36, 3)][hook(39, 4)] - coeff * c[hook(36, 3)][hook(39, 3)];
  c[hook(36, 4)][hook(40, 4)] = c[hook(36, 4)][hook(40, 4)] - coeff * c[hook(36, 4)][hook(40, 3)];
  r[hook(41, 4)] = r[hook(41, 4)] - coeff * r[hook(41, 3)];

  pivot = 1.00 / lhs[hook(30, 4)][hook(34, 4)];
  c[hook(36, 0)][hook(35, 4)] = c[hook(36, 0)][hook(35, 4)] * pivot;
  c[hook(36, 1)][hook(37, 4)] = c[hook(36, 1)][hook(37, 4)] * pivot;
  c[hook(36, 2)][hook(38, 4)] = c[hook(36, 2)][hook(38, 4)] * pivot;
  c[hook(36, 3)][hook(39, 4)] = c[hook(36, 3)][hook(39, 4)] * pivot;
  c[hook(36, 4)][hook(40, 4)] = c[hook(36, 4)][hook(40, 4)] * pivot;
  r[hook(41, 4)] = r[hook(41, 4)] * pivot;

  coeff = lhs[hook(30, 4)][hook(34, 0)];
  c[hook(36, 0)][hook(35, 0)] = c[hook(36, 0)][hook(35, 0)] - coeff * c[hook(36, 0)][hook(35, 4)];
  c[hook(36, 1)][hook(37, 0)] = c[hook(36, 1)][hook(37, 0)] - coeff * c[hook(36, 1)][hook(37, 4)];
  c[hook(36, 2)][hook(38, 0)] = c[hook(36, 2)][hook(38, 0)] - coeff * c[hook(36, 2)][hook(38, 4)];
  c[hook(36, 3)][hook(39, 0)] = c[hook(36, 3)][hook(39, 0)] - coeff * c[hook(36, 3)][hook(39, 4)];
  c[hook(36, 4)][hook(40, 0)] = c[hook(36, 4)][hook(40, 0)] - coeff * c[hook(36, 4)][hook(40, 4)];
  r[hook(41, 0)] = r[hook(41, 0)] - coeff * r[hook(41, 4)];

  coeff = lhs[hook(30, 4)][hook(34, 1)];
  c[hook(36, 0)][hook(35, 1)] = c[hook(36, 0)][hook(35, 1)] - coeff * c[hook(36, 0)][hook(35, 4)];
  c[hook(36, 1)][hook(37, 1)] = c[hook(36, 1)][hook(37, 1)] - coeff * c[hook(36, 1)][hook(37, 4)];
  c[hook(36, 2)][hook(38, 1)] = c[hook(36, 2)][hook(38, 1)] - coeff * c[hook(36, 2)][hook(38, 4)];
  c[hook(36, 3)][hook(39, 1)] = c[hook(36, 3)][hook(39, 1)] - coeff * c[hook(36, 3)][hook(39, 4)];
  c[hook(36, 4)][hook(40, 1)] = c[hook(36, 4)][hook(40, 1)] - coeff * c[hook(36, 4)][hook(40, 4)];
  r[hook(41, 1)] = r[hook(41, 1)] - coeff * r[hook(41, 4)];

  coeff = lhs[hook(30, 4)][hook(34, 2)];
  c[hook(36, 0)][hook(35, 2)] = c[hook(36, 0)][hook(35, 2)] - coeff * c[hook(36, 0)][hook(35, 4)];
  c[hook(36, 1)][hook(37, 2)] = c[hook(36, 1)][hook(37, 2)] - coeff * c[hook(36, 1)][hook(37, 4)];
  c[hook(36, 2)][hook(38, 2)] = c[hook(36, 2)][hook(38, 2)] - coeff * c[hook(36, 2)][hook(38, 4)];
  c[hook(36, 3)][hook(39, 2)] = c[hook(36, 3)][hook(39, 2)] - coeff * c[hook(36, 3)][hook(39, 4)];
  c[hook(36, 4)][hook(40, 2)] = c[hook(36, 4)][hook(40, 2)] - coeff * c[hook(36, 4)][hook(40, 4)];
  r[hook(41, 2)] = r[hook(41, 2)] - coeff * r[hook(41, 4)];

  coeff = lhs[hook(30, 4)][hook(34, 3)];
  c[hook(36, 0)][hook(35, 3)] = c[hook(36, 0)][hook(35, 3)] - coeff * c[hook(36, 0)][hook(35, 4)];
  c[hook(36, 1)][hook(37, 3)] = c[hook(36, 1)][hook(37, 3)] - coeff * c[hook(36, 1)][hook(37, 4)];
  c[hook(36, 2)][hook(38, 3)] = c[hook(36, 2)][hook(38, 3)] - coeff * c[hook(36, 2)][hook(38, 4)];
  c[hook(36, 3)][hook(39, 3)] = c[hook(36, 3)][hook(39, 3)] - coeff * c[hook(36, 3)][hook(39, 4)];
  c[hook(36, 4)][hook(40, 3)] = c[hook(36, 4)][hook(40, 3)] - coeff * c[hook(36, 4)][hook(40, 4)];
  r[hook(41, 3)] = r[hook(41, 3)] - coeff * r[hook(41, 4)];
}

void binvrhs(global double lhs[5][5], global double r[5]) {
  double pivot, coeff;

  pivot = 1.00 / lhs[hook(30, 0)][hook(29, 0)];
  lhs[hook(30, 1)][hook(31, 0)] = lhs[hook(30, 1)][hook(31, 0)] * pivot;
  lhs[hook(30, 2)][hook(32, 0)] = lhs[hook(30, 2)][hook(32, 0)] * pivot;
  lhs[hook(30, 3)][hook(33, 0)] = lhs[hook(30, 3)][hook(33, 0)] * pivot;
  lhs[hook(30, 4)][hook(34, 0)] = lhs[hook(30, 4)][hook(34, 0)] * pivot;
  r[hook(41, 0)] = r[hook(41, 0)] * pivot;

  coeff = lhs[hook(30, 0)][hook(29, 1)];
  lhs[hook(30, 1)][hook(31, 1)] = lhs[hook(30, 1)][hook(31, 1)] - coeff * lhs[hook(30, 1)][hook(31, 0)];
  lhs[hook(30, 2)][hook(32, 1)] = lhs[hook(30, 2)][hook(32, 1)] - coeff * lhs[hook(30, 2)][hook(32, 0)];
  lhs[hook(30, 3)][hook(33, 1)] = lhs[hook(30, 3)][hook(33, 1)] - coeff * lhs[hook(30, 3)][hook(33, 0)];
  lhs[hook(30, 4)][hook(34, 1)] = lhs[hook(30, 4)][hook(34, 1)] - coeff * lhs[hook(30, 4)][hook(34, 0)];
  r[hook(41, 1)] = r[hook(41, 1)] - coeff * r[hook(41, 0)];

  coeff = lhs[hook(30, 0)][hook(29, 2)];
  lhs[hook(30, 1)][hook(31, 2)] = lhs[hook(30, 1)][hook(31, 2)] - coeff * lhs[hook(30, 1)][hook(31, 0)];
  lhs[hook(30, 2)][hook(32, 2)] = lhs[hook(30, 2)][hook(32, 2)] - coeff * lhs[hook(30, 2)][hook(32, 0)];
  lhs[hook(30, 3)][hook(33, 2)] = lhs[hook(30, 3)][hook(33, 2)] - coeff * lhs[hook(30, 3)][hook(33, 0)];
  lhs[hook(30, 4)][hook(34, 2)] = lhs[hook(30, 4)][hook(34, 2)] - coeff * lhs[hook(30, 4)][hook(34, 0)];
  r[hook(41, 2)] = r[hook(41, 2)] - coeff * r[hook(41, 0)];

  coeff = lhs[hook(30, 0)][hook(29, 3)];
  lhs[hook(30, 1)][hook(31, 3)] = lhs[hook(30, 1)][hook(31, 3)] - coeff * lhs[hook(30, 1)][hook(31, 0)];
  lhs[hook(30, 2)][hook(32, 3)] = lhs[hook(30, 2)][hook(32, 3)] - coeff * lhs[hook(30, 2)][hook(32, 0)];
  lhs[hook(30, 3)][hook(33, 3)] = lhs[hook(30, 3)][hook(33, 3)] - coeff * lhs[hook(30, 3)][hook(33, 0)];
  lhs[hook(30, 4)][hook(34, 3)] = lhs[hook(30, 4)][hook(34, 3)] - coeff * lhs[hook(30, 4)][hook(34, 0)];
  r[hook(41, 3)] = r[hook(41, 3)] - coeff * r[hook(41, 0)];

  coeff = lhs[hook(30, 0)][hook(29, 4)];
  lhs[hook(30, 1)][hook(31, 4)] = lhs[hook(30, 1)][hook(31, 4)] - coeff * lhs[hook(30, 1)][hook(31, 0)];
  lhs[hook(30, 2)][hook(32, 4)] = lhs[hook(30, 2)][hook(32, 4)] - coeff * lhs[hook(30, 2)][hook(32, 0)];
  lhs[hook(30, 3)][hook(33, 4)] = lhs[hook(30, 3)][hook(33, 4)] - coeff * lhs[hook(30, 3)][hook(33, 0)];
  lhs[hook(30, 4)][hook(34, 4)] = lhs[hook(30, 4)][hook(34, 4)] - coeff * lhs[hook(30, 4)][hook(34, 0)];
  r[hook(41, 4)] = r[hook(41, 4)] - coeff * r[hook(41, 0)];

  pivot = 1.00 / lhs[hook(30, 1)][hook(31, 1)];
  lhs[hook(30, 2)][hook(32, 1)] = lhs[hook(30, 2)][hook(32, 1)] * pivot;
  lhs[hook(30, 3)][hook(33, 1)] = lhs[hook(30, 3)][hook(33, 1)] * pivot;
  lhs[hook(30, 4)][hook(34, 1)] = lhs[hook(30, 4)][hook(34, 1)] * pivot;
  r[hook(41, 1)] = r[hook(41, 1)] * pivot;

  coeff = lhs[hook(30, 1)][hook(31, 0)];
  lhs[hook(30, 2)][hook(32, 0)] = lhs[hook(30, 2)][hook(32, 0)] - coeff * lhs[hook(30, 2)][hook(32, 1)];
  lhs[hook(30, 3)][hook(33, 0)] = lhs[hook(30, 3)][hook(33, 0)] - coeff * lhs[hook(30, 3)][hook(33, 1)];
  lhs[hook(30, 4)][hook(34, 0)] = lhs[hook(30, 4)][hook(34, 0)] - coeff * lhs[hook(30, 4)][hook(34, 1)];
  r[hook(41, 0)] = r[hook(41, 0)] - coeff * r[hook(41, 1)];

  coeff = lhs[hook(30, 1)][hook(31, 2)];
  lhs[hook(30, 2)][hook(32, 2)] = lhs[hook(30, 2)][hook(32, 2)] - coeff * lhs[hook(30, 2)][hook(32, 1)];
  lhs[hook(30, 3)][hook(33, 2)] = lhs[hook(30, 3)][hook(33, 2)] - coeff * lhs[hook(30, 3)][hook(33, 1)];
  lhs[hook(30, 4)][hook(34, 2)] = lhs[hook(30, 4)][hook(34, 2)] - coeff * lhs[hook(30, 4)][hook(34, 1)];
  r[hook(41, 2)] = r[hook(41, 2)] - coeff * r[hook(41, 1)];

  coeff = lhs[hook(30, 1)][hook(31, 3)];
  lhs[hook(30, 2)][hook(32, 3)] = lhs[hook(30, 2)][hook(32, 3)] - coeff * lhs[hook(30, 2)][hook(32, 1)];
  lhs[hook(30, 3)][hook(33, 3)] = lhs[hook(30, 3)][hook(33, 3)] - coeff * lhs[hook(30, 3)][hook(33, 1)];
  lhs[hook(30, 4)][hook(34, 3)] = lhs[hook(30, 4)][hook(34, 3)] - coeff * lhs[hook(30, 4)][hook(34, 1)];
  r[hook(41, 3)] = r[hook(41, 3)] - coeff * r[hook(41, 1)];

  coeff = lhs[hook(30, 1)][hook(31, 4)];
  lhs[hook(30, 2)][hook(32, 4)] = lhs[hook(30, 2)][hook(32, 4)] - coeff * lhs[hook(30, 2)][hook(32, 1)];
  lhs[hook(30, 3)][hook(33, 4)] = lhs[hook(30, 3)][hook(33, 4)] - coeff * lhs[hook(30, 3)][hook(33, 1)];
  lhs[hook(30, 4)][hook(34, 4)] = lhs[hook(30, 4)][hook(34, 4)] - coeff * lhs[hook(30, 4)][hook(34, 1)];
  r[hook(41, 4)] = r[hook(41, 4)] - coeff * r[hook(41, 1)];

  pivot = 1.00 / lhs[hook(30, 2)][hook(32, 2)];
  lhs[hook(30, 3)][hook(33, 2)] = lhs[hook(30, 3)][hook(33, 2)] * pivot;
  lhs[hook(30, 4)][hook(34, 2)] = lhs[hook(30, 4)][hook(34, 2)] * pivot;
  r[hook(41, 2)] = r[hook(41, 2)] * pivot;

  coeff = lhs[hook(30, 2)][hook(32, 0)];
  lhs[hook(30, 3)][hook(33, 0)] = lhs[hook(30, 3)][hook(33, 0)] - coeff * lhs[hook(30, 3)][hook(33, 2)];
  lhs[hook(30, 4)][hook(34, 0)] = lhs[hook(30, 4)][hook(34, 0)] - coeff * lhs[hook(30, 4)][hook(34, 2)];
  r[hook(41, 0)] = r[hook(41, 0)] - coeff * r[hook(41, 2)];

  coeff = lhs[hook(30, 2)][hook(32, 1)];
  lhs[hook(30, 3)][hook(33, 1)] = lhs[hook(30, 3)][hook(33, 1)] - coeff * lhs[hook(30, 3)][hook(33, 2)];
  lhs[hook(30, 4)][hook(34, 1)] = lhs[hook(30, 4)][hook(34, 1)] - coeff * lhs[hook(30, 4)][hook(34, 2)];
  r[hook(41, 1)] = r[hook(41, 1)] - coeff * r[hook(41, 2)];

  coeff = lhs[hook(30, 2)][hook(32, 3)];
  lhs[hook(30, 3)][hook(33, 3)] = lhs[hook(30, 3)][hook(33, 3)] - coeff * lhs[hook(30, 3)][hook(33, 2)];
  lhs[hook(30, 4)][hook(34, 3)] = lhs[hook(30, 4)][hook(34, 3)] - coeff * lhs[hook(30, 4)][hook(34, 2)];
  r[hook(41, 3)] = r[hook(41, 3)] - coeff * r[hook(41, 2)];

  coeff = lhs[hook(30, 2)][hook(32, 4)];
  lhs[hook(30, 3)][hook(33, 4)] = lhs[hook(30, 3)][hook(33, 4)] - coeff * lhs[hook(30, 3)][hook(33, 2)];
  lhs[hook(30, 4)][hook(34, 4)] = lhs[hook(30, 4)][hook(34, 4)] - coeff * lhs[hook(30, 4)][hook(34, 2)];
  r[hook(41, 4)] = r[hook(41, 4)] - coeff * r[hook(41, 2)];

  pivot = 1.00 / lhs[hook(30, 3)][hook(33, 3)];
  lhs[hook(30, 4)][hook(34, 3)] = lhs[hook(30, 4)][hook(34, 3)] * pivot;
  r[hook(41, 3)] = r[hook(41, 3)] * pivot;

  coeff = lhs[hook(30, 3)][hook(33, 0)];
  lhs[hook(30, 4)][hook(34, 0)] = lhs[hook(30, 4)][hook(34, 0)] - coeff * lhs[hook(30, 4)][hook(34, 3)];
  r[hook(41, 0)] = r[hook(41, 0)] - coeff * r[hook(41, 3)];

  coeff = lhs[hook(30, 3)][hook(33, 1)];
  lhs[hook(30, 4)][hook(34, 1)] = lhs[hook(30, 4)][hook(34, 1)] - coeff * lhs[hook(30, 4)][hook(34, 3)];
  r[hook(41, 1)] = r[hook(41, 1)] - coeff * r[hook(41, 3)];

  coeff = lhs[hook(30, 3)][hook(33, 2)];
  lhs[hook(30, 4)][hook(34, 2)] = lhs[hook(30, 4)][hook(34, 2)] - coeff * lhs[hook(30, 4)][hook(34, 3)];
  r[hook(41, 2)] = r[hook(41, 2)] - coeff * r[hook(41, 3)];

  coeff = lhs[hook(30, 3)][hook(33, 4)];
  lhs[hook(30, 4)][hook(34, 4)] = lhs[hook(30, 4)][hook(34, 4)] - coeff * lhs[hook(30, 4)][hook(34, 3)];
  r[hook(41, 4)] = r[hook(41, 4)] - coeff * r[hook(41, 3)];

  pivot = 1.00 / lhs[hook(30, 4)][hook(34, 4)];
  r[hook(41, 4)] = r[hook(41, 4)] * pivot;

  coeff = lhs[hook(30, 4)][hook(34, 0)];
  r[hook(41, 0)] = r[hook(41, 0)] - coeff * r[hook(41, 4)];

  coeff = lhs[hook(30, 4)][hook(34, 1)];
  r[hook(41, 1)] = r[hook(41, 1)] - coeff * r[hook(41, 4)];

  coeff = lhs[hook(30, 4)][hook(34, 2)];
  r[hook(41, 2)] = r[hook(41, 2)] - coeff * r[hook(41, 4)];

  coeff = lhs[hook(30, 4)][hook(34, 3)];
  r[hook(41, 3)] = r[hook(41, 3)] - coeff * r[hook(41, 4)];
}

kernel void y_solve1(global double* g_qs, global double* g_rho_i, global double* g_square, global double* g_u, global double* g_fjac, global double* g_njac, int gp0, int gp1, int gp2) {
  int i, j, k;
  double tmp1, tmp2, tmp3;

  k = get_global_id(2) + 1;
  i = get_global_id(1) + 1;
  j = get_global_id(0);
  if (k > (gp2 - 2) || i > (gp0 - 2) || j >= gp1)
    return;

  global double(*qs)[64 / 2 * 2 + 1][64 / 2 * 2 + 1] = (global double(*)[64 / 2 * 2 + 1][64 / 2 * 2 + 1]) g_qs;
  global double(*rho_i)[64 / 2 * 2 + 1][64 / 2 * 2 + 1] = (global double(*)[64 / 2 * 2 + 1][64 / 2 * 2 + 1]) g_rho_i;
  global double(*square)[64 / 2 * 2 + 1][64 / 2 * 2 + 1] = (global double(*)[64 / 2 * 2 + 1][64 / 2 * 2 + 1]) g_square;
  global double(*u)[64 / 2 * 2 + 1][64 / 2 * 2 + 1][5] = (global double(*)[64 / 2 * 2 + 1][64 / 2 * 2 + 1][5]) g_u;

  int my_id = (k - 1) * (gp0 - 2) + (i - 1);
  int my_offset = my_id * (64 + 1) * 5 * 5;
  global double(*fjac)[5][5] = (global double(*)[5][5]) & g_fjac[hook(4, my_offset)];
  global double(*njac)[5][5] = (global double(*)[5][5]) & g_njac[hook(5, my_offset)];

  tmp1 = rho_i[hook(44, k)][hook(43, j)][hook(42, i)];
  tmp2 = tmp1 * tmp1;
  tmp3 = tmp1 * tmp2;

  fjac[hook(47, j)][hook(46, 0)][hook(45, 0)] = 0.0;
  fjac[hook(47, j)][hook(46, 1)][hook(48, 0)] = 0.0;
  fjac[hook(47, j)][hook(46, 2)][hook(49, 0)] = 1.0;
  fjac[hook(47, j)][hook(46, 3)][hook(50, 0)] = 0.0;
  fjac[hook(47, j)][hook(46, 4)][hook(51, 0)] = 0.0;

  fjac[hook(47, j)][hook(46, 0)][hook(45, 1)] = -(u[hook(55, k)][hook(54, j)][hook(53, i)][hook(52, 1)] * u[hook(55, k)][hook(54, j)][hook(53, i)][hook(52, 2)]) * tmp2;
  fjac[hook(47, j)][hook(46, 1)][hook(48, 1)] = u[hook(55, k)][hook(54, j)][hook(53, i)][hook(52, 2)] * tmp1;
  fjac[hook(47, j)][hook(46, 2)][hook(49, 1)] = u[hook(55, k)][hook(54, j)][hook(53, i)][hook(52, 1)] * tmp1;
  fjac[hook(47, j)][hook(46, 3)][hook(50, 1)] = 0.0;
  fjac[hook(47, j)][hook(46, 4)][hook(51, 1)] = 0.0;

  fjac[hook(47, j)][hook(46, 0)][hook(45, 2)] = -(u[hook(55, k)][hook(54, j)][hook(53, i)][hook(52, 2)] * u[hook(55, k)][hook(54, j)][hook(53, i)][hook(52, 2)] * tmp2) + 0.4 * qs[hook(58, k)][hook(57, j)][hook(56, i)];
  fjac[hook(47, j)][hook(46, 1)][hook(48, 2)] = -0.4 * u[hook(55, k)][hook(54, j)][hook(53, i)][hook(52, 1)] * tmp1;
  fjac[hook(47, j)][hook(46, 2)][hook(49, 2)] = (2.0 - 0.4) * u[hook(55, k)][hook(54, j)][hook(53, i)][hook(52, 2)] * tmp1;
  fjac[hook(47, j)][hook(46, 3)][hook(50, 2)] = -0.4 * u[hook(55, k)][hook(54, j)][hook(53, i)][hook(52, 3)] * tmp1;
  fjac[hook(47, j)][hook(46, 4)][hook(51, 2)] = 0.4;

  fjac[hook(47, j)][hook(46, 0)][hook(45, 3)] = -(u[hook(55, k)][hook(54, j)][hook(53, i)][hook(52, 2)] * u[hook(55, k)][hook(54, j)][hook(53, i)][hook(52, 3)]) * tmp2;
  fjac[hook(47, j)][hook(46, 1)][hook(48, 3)] = 0.0;
  fjac[hook(47, j)][hook(46, 2)][hook(49, 3)] = u[hook(55, k)][hook(54, j)][hook(53, i)][hook(52, 3)] * tmp1;
  fjac[hook(47, j)][hook(46, 3)][hook(50, 3)] = u[hook(55, k)][hook(54, j)][hook(53, i)][hook(52, 2)] * tmp1;
  fjac[hook(47, j)][hook(46, 4)][hook(51, 3)] = 0.0;

  fjac[hook(47, j)][hook(46, 0)][hook(45, 4)] = (0.4 * 2.0 * square[hook(61, k)][hook(60, j)][hook(59, i)] - 1.4 * u[hook(55, k)][hook(54, j)][hook(53, i)][hook(52, 4)]) * u[hook(55, k)][hook(54, j)][hook(53, i)][hook(52, 2)] * tmp2;
  fjac[hook(47, j)][hook(46, 1)][hook(48, 4)] = -0.4 * u[hook(55, k)][hook(54, j)][hook(53, i)][hook(52, 1)] * u[hook(55, k)][hook(54, j)][hook(53, i)][hook(52, 2)] * tmp2;
  fjac[hook(47, j)][hook(46, 2)][hook(49, 4)] = 1.4 * u[hook(55, k)][hook(54, j)][hook(53, i)][hook(52, 4)] * tmp1 - 0.4 * (qs[hook(58, k)][hook(57, j)][hook(56, i)] + u[hook(55, k)][hook(54, j)][hook(53, i)][hook(52, 2)] * u[hook(55, k)][hook(54, j)][hook(53, i)][hook(52, 2)] * tmp2);
  fjac[hook(47, j)][hook(46, 3)][hook(50, 4)] = -0.4 * (u[hook(55, k)][hook(54, j)][hook(53, i)][hook(52, 2)] * u[hook(55, k)][hook(54, j)][hook(53, i)][hook(52, 3)]) * tmp2;
  fjac[hook(47, j)][hook(46, 4)][hook(51, 4)] = 1.4 * u[hook(55, k)][hook(54, j)][hook(53, i)][hook(52, 2)] * tmp1;

  njac[hook(64, j)][hook(63, 0)][hook(62, 0)] = 0.0;
  njac[hook(64, j)][hook(63, 1)][hook(65, 0)] = 0.0;
  njac[hook(64, j)][hook(63, 2)][hook(66, 0)] = 0.0;
  njac[hook(64, j)][hook(63, 3)][hook(67, 0)] = 0.0;
  njac[hook(64, j)][hook(63, 4)][hook(68, 0)] = 0.0;

  njac[hook(64, j)][hook(63, 0)][hook(62, 1)] = -(0.1 * 1.0) * tmp2 * u[hook(55, k)][hook(54, j)][hook(53, i)][hook(52, 1)];
  njac[hook(64, j)][hook(63, 1)][hook(65, 1)] = (0.1 * 1.0) * tmp1;
  njac[hook(64, j)][hook(63, 2)][hook(66, 1)] = 0.0;
  njac[hook(64, j)][hook(63, 3)][hook(67, 1)] = 0.0;
  njac[hook(64, j)][hook(63, 4)][hook(68, 1)] = 0.0;

  njac[hook(64, j)][hook(63, 0)][hook(62, 2)] = -(4.0 / 3.0) * (0.1 * 1.0) * tmp2 * u[hook(55, k)][hook(54, j)][hook(53, i)][hook(52, 2)];
  njac[hook(64, j)][hook(63, 1)][hook(65, 2)] = 0.0;
  njac[hook(64, j)][hook(63, 2)][hook(66, 2)] = (4.0 / 3.0) * (0.1 * 1.0) * tmp1;
  njac[hook(64, j)][hook(63, 3)][hook(67, 2)] = 0.0;
  njac[hook(64, j)][hook(63, 4)][hook(68, 2)] = 0.0;

  njac[hook(64, j)][hook(63, 0)][hook(62, 3)] = -(0.1 * 1.0) * tmp2 * u[hook(55, k)][hook(54, j)][hook(53, i)][hook(52, 3)];
  njac[hook(64, j)][hook(63, 1)][hook(65, 3)] = 0.0;
  njac[hook(64, j)][hook(63, 2)][hook(66, 3)] = 0.0;
  njac[hook(64, j)][hook(63, 3)][hook(67, 3)] = (0.1 * 1.0) * tmp1;
  njac[hook(64, j)][hook(63, 4)][hook(68, 3)] = 0.0;

  njac[hook(64, j)][hook(63, 0)][hook(62, 4)] = -((0.1 * 1.0) - ((1.4 * 1.4) * (0.1 * 1.0))) * tmp3 * (u[hook(55, k)][hook(54, j)][hook(53, i)][hook(52, 1)] * u[hook(55, k)][hook(54, j)][hook(53, i)][hook(52, 1)]) - ((4.0 / 3.0) * (0.1 * 1.0) - ((1.4 * 1.4) * (0.1 * 1.0))) * tmp3 * (u[hook(55, k)][hook(54, j)][hook(53, i)][hook(52, 2)] * u[hook(55, k)][hook(54, j)][hook(53, i)][hook(52, 2)]) - ((0.1 * 1.0) - ((1.4 * 1.4) * (0.1 * 1.0))) * tmp3 * (u[hook(55, k)][hook(54, j)][hook(53, i)][hook(52, 3)] * u[hook(55, k)][hook(54, j)][hook(53, i)][hook(52, 3)]) - ((1.4 * 1.4) * (0.1 * 1.0)) * tmp2 * u[hook(55, k)][hook(54, j)][hook(53, i)][hook(52, 4)];

  njac[hook(64, j)][hook(63, 1)][hook(65, 4)] = ((0.1 * 1.0) - ((1.4 * 1.4) * (0.1 * 1.0))) * tmp2 * u[hook(55, k)][hook(54, j)][hook(53, i)][hook(52, 1)];
  njac[hook(64, j)][hook(63, 2)][hook(66, 4)] = ((4.0 / 3.0) * (0.1 * 1.0) - ((1.4 * 1.4) * (0.1 * 1.0))) * tmp2 * u[hook(55, k)][hook(54, j)][hook(53, i)][hook(52, 2)];
  njac[hook(64, j)][hook(63, 3)][hook(67, 4)] = ((0.1 * 1.0) - ((1.4 * 1.4) * (0.1 * 1.0))) * tmp2 * u[hook(55, k)][hook(54, j)][hook(53, i)][hook(52, 3)];
  njac[hook(64, j)][hook(63, 4)][hook(68, 4)] = (((1.4 * 1.4) * (0.1 * 1.0))) * tmp1;
}