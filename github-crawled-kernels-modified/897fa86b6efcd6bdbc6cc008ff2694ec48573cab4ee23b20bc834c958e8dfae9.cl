//{"ablock":7,"ablock[0]":6,"ablock[1]":9,"ablock[2]":10,"ablock[3]":11,"ablock[4]":12,"avec":8,"bblock":16,"bblock[0]":15,"bblock[1]":18,"bblock[2]":20,"bblock[3]":22,"bblock[4]":24,"bvec":5,"c":32,"c[0]":31,"c[1]":33,"c[2]":34,"c[3]":35,"c[4]":36,"cblock":14,"cblock[0]":13,"cblock[1]":17,"cblock[2]":19,"cblock[3]":21,"cblock[4]":23,"g_matrix":41,"g_matrix[0]":40,"g_matrix[1]":43,"g_matrix[2]":45,"g_matrix[3]":47,"g_matrix[4]":49,"g_rhs":1,"g_u":0,"g_vector":57,"gp0":2,"gp1":3,"gp2":4,"lhs":26,"lhs[0]":25,"lhs[1]":27,"lhs[2]":28,"lhs[3]":29,"lhs[4]":30,"p_matrix":39,"p_matrix[0]":38,"p_matrix[1]":42,"p_matrix[2]":44,"p_matrix[3]":46,"p_matrix[4]":48,"p_source":51,"p_source[0]":50,"p_source[1]":52,"p_source[2]":53,"p_source[3]":54,"p_source[4]":55,"p_vector":56,"r":37,"rhs":65,"rhs[k]":64,"rhs[k][j]":63,"rhs[k][j][i]":62,"u":61,"u[k]":60,"u[k][j]":59,"u[k][j][i]":58}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void p_matvec_sub(double ablock[5][5], double avec[5], double bvec[5]) {
  bvec[hook(5, 0)] = bvec[hook(5, 0)] - ablock[hook(7, 0)][hook(6, 0)] * avec[hook(8, 0)] - ablock[hook(7, 1)][hook(9, 0)] * avec[hook(8, 1)] - ablock[hook(7, 2)][hook(10, 0)] * avec[hook(8, 2)] - ablock[hook(7, 3)][hook(11, 0)] * avec[hook(8, 3)] - ablock[hook(7, 4)][hook(12, 0)] * avec[hook(8, 4)];
  bvec[hook(5, 1)] = bvec[hook(5, 1)] - ablock[hook(7, 0)][hook(6, 1)] * avec[hook(8, 0)] - ablock[hook(7, 1)][hook(9, 1)] * avec[hook(8, 1)] - ablock[hook(7, 2)][hook(10, 1)] * avec[hook(8, 2)] - ablock[hook(7, 3)][hook(11, 1)] * avec[hook(8, 3)] - ablock[hook(7, 4)][hook(12, 1)] * avec[hook(8, 4)];
  bvec[hook(5, 2)] = bvec[hook(5, 2)] - ablock[hook(7, 0)][hook(6, 2)] * avec[hook(8, 0)] - ablock[hook(7, 1)][hook(9, 2)] * avec[hook(8, 1)] - ablock[hook(7, 2)][hook(10, 2)] * avec[hook(8, 2)] - ablock[hook(7, 3)][hook(11, 2)] * avec[hook(8, 3)] - ablock[hook(7, 4)][hook(12, 2)] * avec[hook(8, 4)];
  bvec[hook(5, 3)] = bvec[hook(5, 3)] - ablock[hook(7, 0)][hook(6, 3)] * avec[hook(8, 0)] - ablock[hook(7, 1)][hook(9, 3)] * avec[hook(8, 1)] - ablock[hook(7, 2)][hook(10, 3)] * avec[hook(8, 2)] - ablock[hook(7, 3)][hook(11, 3)] * avec[hook(8, 3)] - ablock[hook(7, 4)][hook(12, 3)] * avec[hook(8, 4)];
  bvec[hook(5, 4)] = bvec[hook(5, 4)] - ablock[hook(7, 0)][hook(6, 4)] * avec[hook(8, 0)] - ablock[hook(7, 1)][hook(9, 4)] * avec[hook(8, 1)] - ablock[hook(7, 2)][hook(10, 4)] * avec[hook(8, 2)] - ablock[hook(7, 3)][hook(11, 4)] * avec[hook(8, 3)] - ablock[hook(7, 4)][hook(12, 4)] * avec[hook(8, 4)];
}

void p_matmul_sub(double ablock[5][5], double bblock[5][5], double cblock[5][5]) {
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

void p_binvcrhs(double lhs[5][5], double c[5][5], double r[5]) {
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

void p_binvrhs(double lhs[5][5], double r[5]) {
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

void load_matrix(double p_matrix[5][5], global double g_matrix[5][5]) {
  p_matrix[hook(39, 0)][hook(38, 0)] = g_matrix[hook(41, 0)][hook(40, 0)];
  p_matrix[hook(39, 0)][hook(38, 1)] = g_matrix[hook(41, 0)][hook(40, 1)];
  p_matrix[hook(39, 0)][hook(38, 2)] = g_matrix[hook(41, 0)][hook(40, 2)];
  p_matrix[hook(39, 0)][hook(38, 3)] = g_matrix[hook(41, 0)][hook(40, 3)];
  p_matrix[hook(39, 0)][hook(38, 4)] = g_matrix[hook(41, 0)][hook(40, 4)];
  p_matrix[hook(39, 1)][hook(42, 0)] = g_matrix[hook(41, 1)][hook(43, 0)];
  p_matrix[hook(39, 1)][hook(42, 1)] = g_matrix[hook(41, 1)][hook(43, 1)];
  p_matrix[hook(39, 1)][hook(42, 2)] = g_matrix[hook(41, 1)][hook(43, 2)];
  p_matrix[hook(39, 1)][hook(42, 3)] = g_matrix[hook(41, 1)][hook(43, 3)];
  p_matrix[hook(39, 1)][hook(42, 4)] = g_matrix[hook(41, 1)][hook(43, 4)];
  p_matrix[hook(39, 2)][hook(44, 0)] = g_matrix[hook(41, 2)][hook(45, 0)];
  p_matrix[hook(39, 2)][hook(44, 1)] = g_matrix[hook(41, 2)][hook(45, 1)];
  p_matrix[hook(39, 2)][hook(44, 2)] = g_matrix[hook(41, 2)][hook(45, 2)];
  p_matrix[hook(39, 2)][hook(44, 3)] = g_matrix[hook(41, 2)][hook(45, 3)];
  p_matrix[hook(39, 2)][hook(44, 4)] = g_matrix[hook(41, 2)][hook(45, 4)];
  p_matrix[hook(39, 3)][hook(46, 0)] = g_matrix[hook(41, 3)][hook(47, 0)];
  p_matrix[hook(39, 3)][hook(46, 1)] = g_matrix[hook(41, 3)][hook(47, 1)];
  p_matrix[hook(39, 3)][hook(46, 2)] = g_matrix[hook(41, 3)][hook(47, 2)];
  p_matrix[hook(39, 3)][hook(46, 3)] = g_matrix[hook(41, 3)][hook(47, 3)];
  p_matrix[hook(39, 3)][hook(46, 4)] = g_matrix[hook(41, 3)][hook(47, 4)];
  p_matrix[hook(39, 4)][hook(48, 0)] = g_matrix[hook(41, 4)][hook(49, 0)];
  p_matrix[hook(39, 4)][hook(48, 1)] = g_matrix[hook(41, 4)][hook(49, 1)];
  p_matrix[hook(39, 4)][hook(48, 2)] = g_matrix[hook(41, 4)][hook(49, 2)];
  p_matrix[hook(39, 4)][hook(48, 3)] = g_matrix[hook(41, 4)][hook(49, 3)];
  p_matrix[hook(39, 4)][hook(48, 4)] = g_matrix[hook(41, 4)][hook(49, 4)];
}

void save_matrix(global double g_matrix[5][5], double p_matrix[5][5]) {
  g_matrix[hook(41, 0)][hook(40, 0)] = p_matrix[hook(39, 0)][hook(38, 0)];
  g_matrix[hook(41, 0)][hook(40, 1)] = p_matrix[hook(39, 0)][hook(38, 1)];
  g_matrix[hook(41, 0)][hook(40, 2)] = p_matrix[hook(39, 0)][hook(38, 2)];
  g_matrix[hook(41, 0)][hook(40, 3)] = p_matrix[hook(39, 0)][hook(38, 3)];
  g_matrix[hook(41, 0)][hook(40, 4)] = p_matrix[hook(39, 0)][hook(38, 4)];
  g_matrix[hook(41, 1)][hook(43, 0)] = p_matrix[hook(39, 1)][hook(42, 0)];
  g_matrix[hook(41, 1)][hook(43, 1)] = p_matrix[hook(39, 1)][hook(42, 1)];
  g_matrix[hook(41, 1)][hook(43, 2)] = p_matrix[hook(39, 1)][hook(42, 2)];
  g_matrix[hook(41, 1)][hook(43, 3)] = p_matrix[hook(39, 1)][hook(42, 3)];
  g_matrix[hook(41, 1)][hook(43, 4)] = p_matrix[hook(39, 1)][hook(42, 4)];
  g_matrix[hook(41, 2)][hook(45, 0)] = p_matrix[hook(39, 2)][hook(44, 0)];
  g_matrix[hook(41, 2)][hook(45, 1)] = p_matrix[hook(39, 2)][hook(44, 1)];
  g_matrix[hook(41, 2)][hook(45, 2)] = p_matrix[hook(39, 2)][hook(44, 2)];
  g_matrix[hook(41, 2)][hook(45, 3)] = p_matrix[hook(39, 2)][hook(44, 3)];
  g_matrix[hook(41, 2)][hook(45, 4)] = p_matrix[hook(39, 2)][hook(44, 4)];
  g_matrix[hook(41, 3)][hook(47, 0)] = p_matrix[hook(39, 3)][hook(46, 0)];
  g_matrix[hook(41, 3)][hook(47, 1)] = p_matrix[hook(39, 3)][hook(46, 1)];
  g_matrix[hook(41, 3)][hook(47, 2)] = p_matrix[hook(39, 3)][hook(46, 2)];
  g_matrix[hook(41, 3)][hook(47, 3)] = p_matrix[hook(39, 3)][hook(46, 3)];
  g_matrix[hook(41, 3)][hook(47, 4)] = p_matrix[hook(39, 3)][hook(46, 4)];
  g_matrix[hook(41, 4)][hook(49, 0)] = p_matrix[hook(39, 4)][hook(48, 0)];
  g_matrix[hook(41, 4)][hook(49, 1)] = p_matrix[hook(39, 4)][hook(48, 1)];
  g_matrix[hook(41, 4)][hook(49, 2)] = p_matrix[hook(39, 4)][hook(48, 2)];
  g_matrix[hook(41, 4)][hook(49, 3)] = p_matrix[hook(39, 4)][hook(48, 3)];
  g_matrix[hook(41, 4)][hook(49, 4)] = p_matrix[hook(39, 4)][hook(48, 4)];
}

void copy_matrix(double p_matrix[5][5], double p_source[5][5]) {
  p_matrix[hook(39, 0)][hook(38, 0)] = p_source[hook(51, 0)][hook(50, 0)];
  p_matrix[hook(39, 0)][hook(38, 1)] = p_source[hook(51, 0)][hook(50, 1)];
  p_matrix[hook(39, 0)][hook(38, 2)] = p_source[hook(51, 0)][hook(50, 2)];
  p_matrix[hook(39, 0)][hook(38, 3)] = p_source[hook(51, 0)][hook(50, 3)];
  p_matrix[hook(39, 0)][hook(38, 4)] = p_source[hook(51, 0)][hook(50, 4)];
  p_matrix[hook(39, 1)][hook(42, 0)] = p_source[hook(51, 1)][hook(52, 0)];
  p_matrix[hook(39, 1)][hook(42, 1)] = p_source[hook(51, 1)][hook(52, 1)];
  p_matrix[hook(39, 1)][hook(42, 2)] = p_source[hook(51, 1)][hook(52, 2)];
  p_matrix[hook(39, 1)][hook(42, 3)] = p_source[hook(51, 1)][hook(52, 3)];
  p_matrix[hook(39, 1)][hook(42, 4)] = p_source[hook(51, 1)][hook(52, 4)];
  p_matrix[hook(39, 2)][hook(44, 0)] = p_source[hook(51, 2)][hook(53, 0)];
  p_matrix[hook(39, 2)][hook(44, 1)] = p_source[hook(51, 2)][hook(53, 1)];
  p_matrix[hook(39, 2)][hook(44, 2)] = p_source[hook(51, 2)][hook(53, 2)];
  p_matrix[hook(39, 2)][hook(44, 3)] = p_source[hook(51, 2)][hook(53, 3)];
  p_matrix[hook(39, 2)][hook(44, 4)] = p_source[hook(51, 2)][hook(53, 4)];
  p_matrix[hook(39, 3)][hook(46, 0)] = p_source[hook(51, 3)][hook(54, 0)];
  p_matrix[hook(39, 3)][hook(46, 1)] = p_source[hook(51, 3)][hook(54, 1)];
  p_matrix[hook(39, 3)][hook(46, 2)] = p_source[hook(51, 3)][hook(54, 2)];
  p_matrix[hook(39, 3)][hook(46, 3)] = p_source[hook(51, 3)][hook(54, 3)];
  p_matrix[hook(39, 3)][hook(46, 4)] = p_source[hook(51, 3)][hook(54, 4)];
  p_matrix[hook(39, 4)][hook(48, 0)] = p_source[hook(51, 4)][hook(55, 0)];
  p_matrix[hook(39, 4)][hook(48, 1)] = p_source[hook(51, 4)][hook(55, 1)];
  p_matrix[hook(39, 4)][hook(48, 2)] = p_source[hook(51, 4)][hook(55, 2)];
  p_matrix[hook(39, 4)][hook(48, 3)] = p_source[hook(51, 4)][hook(55, 3)];
  p_matrix[hook(39, 4)][hook(48, 4)] = p_source[hook(51, 4)][hook(55, 4)];
}

void load_vector(double p_vector[5], global double g_vector[5]) {
  p_vector[hook(56, 0)] = g_vector[hook(57, 0)];
  p_vector[hook(56, 1)] = g_vector[hook(57, 1)];
  p_vector[hook(56, 2)] = g_vector[hook(57, 2)];
  p_vector[hook(56, 3)] = g_vector[hook(57, 3)];
  p_vector[hook(56, 4)] = g_vector[hook(57, 4)];
}

void save_vector(global double g_vector[5], double p_vector[5]) {
  g_vector[hook(57, 0)] = p_vector[hook(56, 0)];
  g_vector[hook(57, 1)] = p_vector[hook(56, 1)];
  g_vector[hook(57, 2)] = p_vector[hook(56, 2)];
  g_vector[hook(57, 3)] = p_vector[hook(56, 3)];
  g_vector[hook(57, 4)] = p_vector[hook(56, 4)];
}

void copy_vector(double p_vector[5], double p_source[5]) {
  p_vector[hook(56, 0)] = p_source[hook(51, 0)];
  p_vector[hook(56, 1)] = p_source[hook(51, 1)];
  p_vector[hook(56, 2)] = p_source[hook(51, 2)];
  p_vector[hook(56, 3)] = p_source[hook(51, 3)];
  p_vector[hook(56, 4)] = p_source[hook(51, 4)];
}

kernel void add(global double* g_u, global double* g_rhs, int gp0, int gp1, int gp2) {
  int i, j, k, m;

  k = get_global_id(2) + 1;
  j = get_global_id(1) + 1;
  i = get_global_id(0) + 1;
  if (k > (gp2 - 2) || j > (gp1 - 2) || i > (gp0 - 2))
    return;

  global double(*u)[64 / 2 * 2 + 1][64 / 2 * 2 + 1][5] = (global double(*)[64 / 2 * 2 + 1][64 / 2 * 2 + 1][5]) g_u;
  global double(*rhs)[64 / 2 * 2 + 1][64 / 2 * 2 + 1][5] = (global double(*)[64 / 2 * 2 + 1][64 / 2 * 2 + 1][5]) g_rhs;

  for (m = 0; m < 5; m++) {
    u[hook(61, k)][hook(60, j)][hook(59, i)][hook(58, m)] = u[hook(61, k)][hook(60, j)][hook(59, i)][hook(58, m)] + rhs[hook(65, k)][hook(64, j)][hook(63, i)][hook(62, m)];
  }
}