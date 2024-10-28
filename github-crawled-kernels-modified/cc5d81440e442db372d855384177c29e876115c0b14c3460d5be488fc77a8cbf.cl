//{"ablock":6,"ablock[0]":5,"ablock[1]":8,"ablock[2]":9,"ablock[3]":10,"ablock[4]":11,"avec":7,"bblock":15,"bblock[0]":14,"bblock[1]":17,"bblock[2]":19,"bblock[3]":21,"bblock[4]":23,"bvec":4,"c":31,"c[0]":30,"c[1]":32,"c[2]":33,"c[3]":34,"c[4]":35,"cblock":13,"cblock[0]":12,"cblock[1]":16,"cblock[2]":18,"cblock[3]":20,"cblock[4]":22,"g_lhs":0,"g_matrix":40,"g_matrix[0]":39,"g_matrix[1]":42,"g_matrix[2]":44,"g_matrix[3]":46,"g_matrix[4]":48,"g_vector":56,"gp0":1,"gp1":2,"gp2":3,"lhs":25,"lhs[0]":24,"lhs[1]":26,"lhs[2]":27,"lhs[3]":28,"lhs[4]":29,"lhs[j]":59,"lhs[j][0]":58,"lhs[j][0][n]":57,"lhs[j][1]":61,"lhs[j][1][n]":60,"lhs[j][2]":63,"lhs[j][2][n]":62,"p_matrix":38,"p_matrix[0]":37,"p_matrix[1]":41,"p_matrix[2]":43,"p_matrix[3]":45,"p_matrix[4]":47,"p_source":50,"p_source[0]":49,"p_source[1]":51,"p_source[2]":52,"p_source[3]":53,"p_source[4]":54,"p_vector":55,"r":36}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void p_matvec_sub(double ablock[5][5], double avec[5], double bvec[5]) {
  bvec[hook(4, 0)] = bvec[hook(4, 0)] - ablock[hook(6, 0)][hook(5, 0)] * avec[hook(7, 0)] - ablock[hook(6, 1)][hook(8, 0)] * avec[hook(7, 1)] - ablock[hook(6, 2)][hook(9, 0)] * avec[hook(7, 2)] - ablock[hook(6, 3)][hook(10, 0)] * avec[hook(7, 3)] - ablock[hook(6, 4)][hook(11, 0)] * avec[hook(7, 4)];
  bvec[hook(4, 1)] = bvec[hook(4, 1)] - ablock[hook(6, 0)][hook(5, 1)] * avec[hook(7, 0)] - ablock[hook(6, 1)][hook(8, 1)] * avec[hook(7, 1)] - ablock[hook(6, 2)][hook(9, 1)] * avec[hook(7, 2)] - ablock[hook(6, 3)][hook(10, 1)] * avec[hook(7, 3)] - ablock[hook(6, 4)][hook(11, 1)] * avec[hook(7, 4)];
  bvec[hook(4, 2)] = bvec[hook(4, 2)] - ablock[hook(6, 0)][hook(5, 2)] * avec[hook(7, 0)] - ablock[hook(6, 1)][hook(8, 2)] * avec[hook(7, 1)] - ablock[hook(6, 2)][hook(9, 2)] * avec[hook(7, 2)] - ablock[hook(6, 3)][hook(10, 2)] * avec[hook(7, 3)] - ablock[hook(6, 4)][hook(11, 2)] * avec[hook(7, 4)];
  bvec[hook(4, 3)] = bvec[hook(4, 3)] - ablock[hook(6, 0)][hook(5, 3)] * avec[hook(7, 0)] - ablock[hook(6, 1)][hook(8, 3)] * avec[hook(7, 1)] - ablock[hook(6, 2)][hook(9, 3)] * avec[hook(7, 2)] - ablock[hook(6, 3)][hook(10, 3)] * avec[hook(7, 3)] - ablock[hook(6, 4)][hook(11, 3)] * avec[hook(7, 4)];
  bvec[hook(4, 4)] = bvec[hook(4, 4)] - ablock[hook(6, 0)][hook(5, 4)] * avec[hook(7, 0)] - ablock[hook(6, 1)][hook(8, 4)] * avec[hook(7, 1)] - ablock[hook(6, 2)][hook(9, 4)] * avec[hook(7, 2)] - ablock[hook(6, 3)][hook(10, 4)] * avec[hook(7, 3)] - ablock[hook(6, 4)][hook(11, 4)] * avec[hook(7, 4)];
}

void p_matmul_sub(double ablock[5][5], double bblock[5][5], double cblock[5][5]) {
  cblock[hook(13, 0)][hook(12, 0)] = cblock[hook(13, 0)][hook(12, 0)] - ablock[hook(6, 0)][hook(5, 0)] * bblock[hook(15, 0)][hook(14, 0)] - ablock[hook(6, 1)][hook(8, 0)] * bblock[hook(15, 0)][hook(14, 1)] - ablock[hook(6, 2)][hook(9, 0)] * bblock[hook(15, 0)][hook(14, 2)] - ablock[hook(6, 3)][hook(10, 0)] * bblock[hook(15, 0)][hook(14, 3)] - ablock[hook(6, 4)][hook(11, 0)] * bblock[hook(15, 0)][hook(14, 4)];
  cblock[hook(13, 0)][hook(12, 1)] = cblock[hook(13, 0)][hook(12, 1)] - ablock[hook(6, 0)][hook(5, 1)] * bblock[hook(15, 0)][hook(14, 0)] - ablock[hook(6, 1)][hook(8, 1)] * bblock[hook(15, 0)][hook(14, 1)] - ablock[hook(6, 2)][hook(9, 1)] * bblock[hook(15, 0)][hook(14, 2)] - ablock[hook(6, 3)][hook(10, 1)] * bblock[hook(15, 0)][hook(14, 3)] - ablock[hook(6, 4)][hook(11, 1)] * bblock[hook(15, 0)][hook(14, 4)];
  cblock[hook(13, 0)][hook(12, 2)] = cblock[hook(13, 0)][hook(12, 2)] - ablock[hook(6, 0)][hook(5, 2)] * bblock[hook(15, 0)][hook(14, 0)] - ablock[hook(6, 1)][hook(8, 2)] * bblock[hook(15, 0)][hook(14, 1)] - ablock[hook(6, 2)][hook(9, 2)] * bblock[hook(15, 0)][hook(14, 2)] - ablock[hook(6, 3)][hook(10, 2)] * bblock[hook(15, 0)][hook(14, 3)] - ablock[hook(6, 4)][hook(11, 2)] * bblock[hook(15, 0)][hook(14, 4)];
  cblock[hook(13, 0)][hook(12, 3)] = cblock[hook(13, 0)][hook(12, 3)] - ablock[hook(6, 0)][hook(5, 3)] * bblock[hook(15, 0)][hook(14, 0)] - ablock[hook(6, 1)][hook(8, 3)] * bblock[hook(15, 0)][hook(14, 1)] - ablock[hook(6, 2)][hook(9, 3)] * bblock[hook(15, 0)][hook(14, 2)] - ablock[hook(6, 3)][hook(10, 3)] * bblock[hook(15, 0)][hook(14, 3)] - ablock[hook(6, 4)][hook(11, 3)] * bblock[hook(15, 0)][hook(14, 4)];
  cblock[hook(13, 0)][hook(12, 4)] = cblock[hook(13, 0)][hook(12, 4)] - ablock[hook(6, 0)][hook(5, 4)] * bblock[hook(15, 0)][hook(14, 0)] - ablock[hook(6, 1)][hook(8, 4)] * bblock[hook(15, 0)][hook(14, 1)] - ablock[hook(6, 2)][hook(9, 4)] * bblock[hook(15, 0)][hook(14, 2)] - ablock[hook(6, 3)][hook(10, 4)] * bblock[hook(15, 0)][hook(14, 3)] - ablock[hook(6, 4)][hook(11, 4)] * bblock[hook(15, 0)][hook(14, 4)];
  cblock[hook(13, 1)][hook(16, 0)] = cblock[hook(13, 1)][hook(16, 0)] - ablock[hook(6, 0)][hook(5, 0)] * bblock[hook(15, 1)][hook(17, 0)] - ablock[hook(6, 1)][hook(8, 0)] * bblock[hook(15, 1)][hook(17, 1)] - ablock[hook(6, 2)][hook(9, 0)] * bblock[hook(15, 1)][hook(17, 2)] - ablock[hook(6, 3)][hook(10, 0)] * bblock[hook(15, 1)][hook(17, 3)] - ablock[hook(6, 4)][hook(11, 0)] * bblock[hook(15, 1)][hook(17, 4)];
  cblock[hook(13, 1)][hook(16, 1)] = cblock[hook(13, 1)][hook(16, 1)] - ablock[hook(6, 0)][hook(5, 1)] * bblock[hook(15, 1)][hook(17, 0)] - ablock[hook(6, 1)][hook(8, 1)] * bblock[hook(15, 1)][hook(17, 1)] - ablock[hook(6, 2)][hook(9, 1)] * bblock[hook(15, 1)][hook(17, 2)] - ablock[hook(6, 3)][hook(10, 1)] * bblock[hook(15, 1)][hook(17, 3)] - ablock[hook(6, 4)][hook(11, 1)] * bblock[hook(15, 1)][hook(17, 4)];
  cblock[hook(13, 1)][hook(16, 2)] = cblock[hook(13, 1)][hook(16, 2)] - ablock[hook(6, 0)][hook(5, 2)] * bblock[hook(15, 1)][hook(17, 0)] - ablock[hook(6, 1)][hook(8, 2)] * bblock[hook(15, 1)][hook(17, 1)] - ablock[hook(6, 2)][hook(9, 2)] * bblock[hook(15, 1)][hook(17, 2)] - ablock[hook(6, 3)][hook(10, 2)] * bblock[hook(15, 1)][hook(17, 3)] - ablock[hook(6, 4)][hook(11, 2)] * bblock[hook(15, 1)][hook(17, 4)];
  cblock[hook(13, 1)][hook(16, 3)] = cblock[hook(13, 1)][hook(16, 3)] - ablock[hook(6, 0)][hook(5, 3)] * bblock[hook(15, 1)][hook(17, 0)] - ablock[hook(6, 1)][hook(8, 3)] * bblock[hook(15, 1)][hook(17, 1)] - ablock[hook(6, 2)][hook(9, 3)] * bblock[hook(15, 1)][hook(17, 2)] - ablock[hook(6, 3)][hook(10, 3)] * bblock[hook(15, 1)][hook(17, 3)] - ablock[hook(6, 4)][hook(11, 3)] * bblock[hook(15, 1)][hook(17, 4)];
  cblock[hook(13, 1)][hook(16, 4)] = cblock[hook(13, 1)][hook(16, 4)] - ablock[hook(6, 0)][hook(5, 4)] * bblock[hook(15, 1)][hook(17, 0)] - ablock[hook(6, 1)][hook(8, 4)] * bblock[hook(15, 1)][hook(17, 1)] - ablock[hook(6, 2)][hook(9, 4)] * bblock[hook(15, 1)][hook(17, 2)] - ablock[hook(6, 3)][hook(10, 4)] * bblock[hook(15, 1)][hook(17, 3)] - ablock[hook(6, 4)][hook(11, 4)] * bblock[hook(15, 1)][hook(17, 4)];
  cblock[hook(13, 2)][hook(18, 0)] = cblock[hook(13, 2)][hook(18, 0)] - ablock[hook(6, 0)][hook(5, 0)] * bblock[hook(15, 2)][hook(19, 0)] - ablock[hook(6, 1)][hook(8, 0)] * bblock[hook(15, 2)][hook(19, 1)] - ablock[hook(6, 2)][hook(9, 0)] * bblock[hook(15, 2)][hook(19, 2)] - ablock[hook(6, 3)][hook(10, 0)] * bblock[hook(15, 2)][hook(19, 3)] - ablock[hook(6, 4)][hook(11, 0)] * bblock[hook(15, 2)][hook(19, 4)];
  cblock[hook(13, 2)][hook(18, 1)] = cblock[hook(13, 2)][hook(18, 1)] - ablock[hook(6, 0)][hook(5, 1)] * bblock[hook(15, 2)][hook(19, 0)] - ablock[hook(6, 1)][hook(8, 1)] * bblock[hook(15, 2)][hook(19, 1)] - ablock[hook(6, 2)][hook(9, 1)] * bblock[hook(15, 2)][hook(19, 2)] - ablock[hook(6, 3)][hook(10, 1)] * bblock[hook(15, 2)][hook(19, 3)] - ablock[hook(6, 4)][hook(11, 1)] * bblock[hook(15, 2)][hook(19, 4)];
  cblock[hook(13, 2)][hook(18, 2)] = cblock[hook(13, 2)][hook(18, 2)] - ablock[hook(6, 0)][hook(5, 2)] * bblock[hook(15, 2)][hook(19, 0)] - ablock[hook(6, 1)][hook(8, 2)] * bblock[hook(15, 2)][hook(19, 1)] - ablock[hook(6, 2)][hook(9, 2)] * bblock[hook(15, 2)][hook(19, 2)] - ablock[hook(6, 3)][hook(10, 2)] * bblock[hook(15, 2)][hook(19, 3)] - ablock[hook(6, 4)][hook(11, 2)] * bblock[hook(15, 2)][hook(19, 4)];
  cblock[hook(13, 2)][hook(18, 3)] = cblock[hook(13, 2)][hook(18, 3)] - ablock[hook(6, 0)][hook(5, 3)] * bblock[hook(15, 2)][hook(19, 0)] - ablock[hook(6, 1)][hook(8, 3)] * bblock[hook(15, 2)][hook(19, 1)] - ablock[hook(6, 2)][hook(9, 3)] * bblock[hook(15, 2)][hook(19, 2)] - ablock[hook(6, 3)][hook(10, 3)] * bblock[hook(15, 2)][hook(19, 3)] - ablock[hook(6, 4)][hook(11, 3)] * bblock[hook(15, 2)][hook(19, 4)];
  cblock[hook(13, 2)][hook(18, 4)] = cblock[hook(13, 2)][hook(18, 4)] - ablock[hook(6, 0)][hook(5, 4)] * bblock[hook(15, 2)][hook(19, 0)] - ablock[hook(6, 1)][hook(8, 4)] * bblock[hook(15, 2)][hook(19, 1)] - ablock[hook(6, 2)][hook(9, 4)] * bblock[hook(15, 2)][hook(19, 2)] - ablock[hook(6, 3)][hook(10, 4)] * bblock[hook(15, 2)][hook(19, 3)] - ablock[hook(6, 4)][hook(11, 4)] * bblock[hook(15, 2)][hook(19, 4)];
  cblock[hook(13, 3)][hook(20, 0)] = cblock[hook(13, 3)][hook(20, 0)] - ablock[hook(6, 0)][hook(5, 0)] * bblock[hook(15, 3)][hook(21, 0)] - ablock[hook(6, 1)][hook(8, 0)] * bblock[hook(15, 3)][hook(21, 1)] - ablock[hook(6, 2)][hook(9, 0)] * bblock[hook(15, 3)][hook(21, 2)] - ablock[hook(6, 3)][hook(10, 0)] * bblock[hook(15, 3)][hook(21, 3)] - ablock[hook(6, 4)][hook(11, 0)] * bblock[hook(15, 3)][hook(21, 4)];
  cblock[hook(13, 3)][hook(20, 1)] = cblock[hook(13, 3)][hook(20, 1)] - ablock[hook(6, 0)][hook(5, 1)] * bblock[hook(15, 3)][hook(21, 0)] - ablock[hook(6, 1)][hook(8, 1)] * bblock[hook(15, 3)][hook(21, 1)] - ablock[hook(6, 2)][hook(9, 1)] * bblock[hook(15, 3)][hook(21, 2)] - ablock[hook(6, 3)][hook(10, 1)] * bblock[hook(15, 3)][hook(21, 3)] - ablock[hook(6, 4)][hook(11, 1)] * bblock[hook(15, 3)][hook(21, 4)];
  cblock[hook(13, 3)][hook(20, 2)] = cblock[hook(13, 3)][hook(20, 2)] - ablock[hook(6, 0)][hook(5, 2)] * bblock[hook(15, 3)][hook(21, 0)] - ablock[hook(6, 1)][hook(8, 2)] * bblock[hook(15, 3)][hook(21, 1)] - ablock[hook(6, 2)][hook(9, 2)] * bblock[hook(15, 3)][hook(21, 2)] - ablock[hook(6, 3)][hook(10, 2)] * bblock[hook(15, 3)][hook(21, 3)] - ablock[hook(6, 4)][hook(11, 2)] * bblock[hook(15, 3)][hook(21, 4)];
  cblock[hook(13, 3)][hook(20, 3)] = cblock[hook(13, 3)][hook(20, 3)] - ablock[hook(6, 0)][hook(5, 3)] * bblock[hook(15, 3)][hook(21, 0)] - ablock[hook(6, 1)][hook(8, 3)] * bblock[hook(15, 3)][hook(21, 1)] - ablock[hook(6, 2)][hook(9, 3)] * bblock[hook(15, 3)][hook(21, 2)] - ablock[hook(6, 3)][hook(10, 3)] * bblock[hook(15, 3)][hook(21, 3)] - ablock[hook(6, 4)][hook(11, 3)] * bblock[hook(15, 3)][hook(21, 4)];
  cblock[hook(13, 3)][hook(20, 4)] = cblock[hook(13, 3)][hook(20, 4)] - ablock[hook(6, 0)][hook(5, 4)] * bblock[hook(15, 3)][hook(21, 0)] - ablock[hook(6, 1)][hook(8, 4)] * bblock[hook(15, 3)][hook(21, 1)] - ablock[hook(6, 2)][hook(9, 4)] * bblock[hook(15, 3)][hook(21, 2)] - ablock[hook(6, 3)][hook(10, 4)] * bblock[hook(15, 3)][hook(21, 3)] - ablock[hook(6, 4)][hook(11, 4)] * bblock[hook(15, 3)][hook(21, 4)];
  cblock[hook(13, 4)][hook(22, 0)] = cblock[hook(13, 4)][hook(22, 0)] - ablock[hook(6, 0)][hook(5, 0)] * bblock[hook(15, 4)][hook(23, 0)] - ablock[hook(6, 1)][hook(8, 0)] * bblock[hook(15, 4)][hook(23, 1)] - ablock[hook(6, 2)][hook(9, 0)] * bblock[hook(15, 4)][hook(23, 2)] - ablock[hook(6, 3)][hook(10, 0)] * bblock[hook(15, 4)][hook(23, 3)] - ablock[hook(6, 4)][hook(11, 0)] * bblock[hook(15, 4)][hook(23, 4)];
  cblock[hook(13, 4)][hook(22, 1)] = cblock[hook(13, 4)][hook(22, 1)] - ablock[hook(6, 0)][hook(5, 1)] * bblock[hook(15, 4)][hook(23, 0)] - ablock[hook(6, 1)][hook(8, 1)] * bblock[hook(15, 4)][hook(23, 1)] - ablock[hook(6, 2)][hook(9, 1)] * bblock[hook(15, 4)][hook(23, 2)] - ablock[hook(6, 3)][hook(10, 1)] * bblock[hook(15, 4)][hook(23, 3)] - ablock[hook(6, 4)][hook(11, 1)] * bblock[hook(15, 4)][hook(23, 4)];
  cblock[hook(13, 4)][hook(22, 2)] = cblock[hook(13, 4)][hook(22, 2)] - ablock[hook(6, 0)][hook(5, 2)] * bblock[hook(15, 4)][hook(23, 0)] - ablock[hook(6, 1)][hook(8, 2)] * bblock[hook(15, 4)][hook(23, 1)] - ablock[hook(6, 2)][hook(9, 2)] * bblock[hook(15, 4)][hook(23, 2)] - ablock[hook(6, 3)][hook(10, 2)] * bblock[hook(15, 4)][hook(23, 3)] - ablock[hook(6, 4)][hook(11, 2)] * bblock[hook(15, 4)][hook(23, 4)];
  cblock[hook(13, 4)][hook(22, 3)] = cblock[hook(13, 4)][hook(22, 3)] - ablock[hook(6, 0)][hook(5, 3)] * bblock[hook(15, 4)][hook(23, 0)] - ablock[hook(6, 1)][hook(8, 3)] * bblock[hook(15, 4)][hook(23, 1)] - ablock[hook(6, 2)][hook(9, 3)] * bblock[hook(15, 4)][hook(23, 2)] - ablock[hook(6, 3)][hook(10, 3)] * bblock[hook(15, 4)][hook(23, 3)] - ablock[hook(6, 4)][hook(11, 3)] * bblock[hook(15, 4)][hook(23, 4)];
  cblock[hook(13, 4)][hook(22, 4)] = cblock[hook(13, 4)][hook(22, 4)] - ablock[hook(6, 0)][hook(5, 4)] * bblock[hook(15, 4)][hook(23, 0)] - ablock[hook(6, 1)][hook(8, 4)] * bblock[hook(15, 4)][hook(23, 1)] - ablock[hook(6, 2)][hook(9, 4)] * bblock[hook(15, 4)][hook(23, 2)] - ablock[hook(6, 3)][hook(10, 4)] * bblock[hook(15, 4)][hook(23, 3)] - ablock[hook(6, 4)][hook(11, 4)] * bblock[hook(15, 4)][hook(23, 4)];
}

void p_binvcrhs(double lhs[5][5], double c[5][5], double r[5]) {
  double pivot, coeff;

  pivot = 1.00 / lhs[hook(25, 0)][hook(24, 0)];
  lhs[hook(25, 1)][hook(26, 0)] = lhs[hook(25, 1)][hook(26, 0)] * pivot;
  lhs[hook(25, 2)][hook(27, 0)] = lhs[hook(25, 2)][hook(27, 0)] * pivot;
  lhs[hook(25, 3)][hook(28, 0)] = lhs[hook(25, 3)][hook(28, 0)] * pivot;
  lhs[hook(25, 4)][hook(29, 0)] = lhs[hook(25, 4)][hook(29, 0)] * pivot;
  c[hook(31, 0)][hook(30, 0)] = c[hook(31, 0)][hook(30, 0)] * pivot;
  c[hook(31, 1)][hook(32, 0)] = c[hook(31, 1)][hook(32, 0)] * pivot;
  c[hook(31, 2)][hook(33, 0)] = c[hook(31, 2)][hook(33, 0)] * pivot;
  c[hook(31, 3)][hook(34, 0)] = c[hook(31, 3)][hook(34, 0)] * pivot;
  c[hook(31, 4)][hook(35, 0)] = c[hook(31, 4)][hook(35, 0)] * pivot;
  r[hook(36, 0)] = r[hook(36, 0)] * pivot;

  coeff = lhs[hook(25, 0)][hook(24, 1)];
  lhs[hook(25, 1)][hook(26, 1)] = lhs[hook(25, 1)][hook(26, 1)] - coeff * lhs[hook(25, 1)][hook(26, 0)];
  lhs[hook(25, 2)][hook(27, 1)] = lhs[hook(25, 2)][hook(27, 1)] - coeff * lhs[hook(25, 2)][hook(27, 0)];
  lhs[hook(25, 3)][hook(28, 1)] = lhs[hook(25, 3)][hook(28, 1)] - coeff * lhs[hook(25, 3)][hook(28, 0)];
  lhs[hook(25, 4)][hook(29, 1)] = lhs[hook(25, 4)][hook(29, 1)] - coeff * lhs[hook(25, 4)][hook(29, 0)];
  c[hook(31, 0)][hook(30, 1)] = c[hook(31, 0)][hook(30, 1)] - coeff * c[hook(31, 0)][hook(30, 0)];
  c[hook(31, 1)][hook(32, 1)] = c[hook(31, 1)][hook(32, 1)] - coeff * c[hook(31, 1)][hook(32, 0)];
  c[hook(31, 2)][hook(33, 1)] = c[hook(31, 2)][hook(33, 1)] - coeff * c[hook(31, 2)][hook(33, 0)];
  c[hook(31, 3)][hook(34, 1)] = c[hook(31, 3)][hook(34, 1)] - coeff * c[hook(31, 3)][hook(34, 0)];
  c[hook(31, 4)][hook(35, 1)] = c[hook(31, 4)][hook(35, 1)] - coeff * c[hook(31, 4)][hook(35, 0)];
  r[hook(36, 1)] = r[hook(36, 1)] - coeff * r[hook(36, 0)];

  coeff = lhs[hook(25, 0)][hook(24, 2)];
  lhs[hook(25, 1)][hook(26, 2)] = lhs[hook(25, 1)][hook(26, 2)] - coeff * lhs[hook(25, 1)][hook(26, 0)];
  lhs[hook(25, 2)][hook(27, 2)] = lhs[hook(25, 2)][hook(27, 2)] - coeff * lhs[hook(25, 2)][hook(27, 0)];
  lhs[hook(25, 3)][hook(28, 2)] = lhs[hook(25, 3)][hook(28, 2)] - coeff * lhs[hook(25, 3)][hook(28, 0)];
  lhs[hook(25, 4)][hook(29, 2)] = lhs[hook(25, 4)][hook(29, 2)] - coeff * lhs[hook(25, 4)][hook(29, 0)];
  c[hook(31, 0)][hook(30, 2)] = c[hook(31, 0)][hook(30, 2)] - coeff * c[hook(31, 0)][hook(30, 0)];
  c[hook(31, 1)][hook(32, 2)] = c[hook(31, 1)][hook(32, 2)] - coeff * c[hook(31, 1)][hook(32, 0)];
  c[hook(31, 2)][hook(33, 2)] = c[hook(31, 2)][hook(33, 2)] - coeff * c[hook(31, 2)][hook(33, 0)];
  c[hook(31, 3)][hook(34, 2)] = c[hook(31, 3)][hook(34, 2)] - coeff * c[hook(31, 3)][hook(34, 0)];
  c[hook(31, 4)][hook(35, 2)] = c[hook(31, 4)][hook(35, 2)] - coeff * c[hook(31, 4)][hook(35, 0)];
  r[hook(36, 2)] = r[hook(36, 2)] - coeff * r[hook(36, 0)];

  coeff = lhs[hook(25, 0)][hook(24, 3)];
  lhs[hook(25, 1)][hook(26, 3)] = lhs[hook(25, 1)][hook(26, 3)] - coeff * lhs[hook(25, 1)][hook(26, 0)];
  lhs[hook(25, 2)][hook(27, 3)] = lhs[hook(25, 2)][hook(27, 3)] - coeff * lhs[hook(25, 2)][hook(27, 0)];
  lhs[hook(25, 3)][hook(28, 3)] = lhs[hook(25, 3)][hook(28, 3)] - coeff * lhs[hook(25, 3)][hook(28, 0)];
  lhs[hook(25, 4)][hook(29, 3)] = lhs[hook(25, 4)][hook(29, 3)] - coeff * lhs[hook(25, 4)][hook(29, 0)];
  c[hook(31, 0)][hook(30, 3)] = c[hook(31, 0)][hook(30, 3)] - coeff * c[hook(31, 0)][hook(30, 0)];
  c[hook(31, 1)][hook(32, 3)] = c[hook(31, 1)][hook(32, 3)] - coeff * c[hook(31, 1)][hook(32, 0)];
  c[hook(31, 2)][hook(33, 3)] = c[hook(31, 2)][hook(33, 3)] - coeff * c[hook(31, 2)][hook(33, 0)];
  c[hook(31, 3)][hook(34, 3)] = c[hook(31, 3)][hook(34, 3)] - coeff * c[hook(31, 3)][hook(34, 0)];
  c[hook(31, 4)][hook(35, 3)] = c[hook(31, 4)][hook(35, 3)] - coeff * c[hook(31, 4)][hook(35, 0)];
  r[hook(36, 3)] = r[hook(36, 3)] - coeff * r[hook(36, 0)];

  coeff = lhs[hook(25, 0)][hook(24, 4)];
  lhs[hook(25, 1)][hook(26, 4)] = lhs[hook(25, 1)][hook(26, 4)] - coeff * lhs[hook(25, 1)][hook(26, 0)];
  lhs[hook(25, 2)][hook(27, 4)] = lhs[hook(25, 2)][hook(27, 4)] - coeff * lhs[hook(25, 2)][hook(27, 0)];
  lhs[hook(25, 3)][hook(28, 4)] = lhs[hook(25, 3)][hook(28, 4)] - coeff * lhs[hook(25, 3)][hook(28, 0)];
  lhs[hook(25, 4)][hook(29, 4)] = lhs[hook(25, 4)][hook(29, 4)] - coeff * lhs[hook(25, 4)][hook(29, 0)];
  c[hook(31, 0)][hook(30, 4)] = c[hook(31, 0)][hook(30, 4)] - coeff * c[hook(31, 0)][hook(30, 0)];
  c[hook(31, 1)][hook(32, 4)] = c[hook(31, 1)][hook(32, 4)] - coeff * c[hook(31, 1)][hook(32, 0)];
  c[hook(31, 2)][hook(33, 4)] = c[hook(31, 2)][hook(33, 4)] - coeff * c[hook(31, 2)][hook(33, 0)];
  c[hook(31, 3)][hook(34, 4)] = c[hook(31, 3)][hook(34, 4)] - coeff * c[hook(31, 3)][hook(34, 0)];
  c[hook(31, 4)][hook(35, 4)] = c[hook(31, 4)][hook(35, 4)] - coeff * c[hook(31, 4)][hook(35, 0)];
  r[hook(36, 4)] = r[hook(36, 4)] - coeff * r[hook(36, 0)];

  pivot = 1.00 / lhs[hook(25, 1)][hook(26, 1)];
  lhs[hook(25, 2)][hook(27, 1)] = lhs[hook(25, 2)][hook(27, 1)] * pivot;
  lhs[hook(25, 3)][hook(28, 1)] = lhs[hook(25, 3)][hook(28, 1)] * pivot;
  lhs[hook(25, 4)][hook(29, 1)] = lhs[hook(25, 4)][hook(29, 1)] * pivot;
  c[hook(31, 0)][hook(30, 1)] = c[hook(31, 0)][hook(30, 1)] * pivot;
  c[hook(31, 1)][hook(32, 1)] = c[hook(31, 1)][hook(32, 1)] * pivot;
  c[hook(31, 2)][hook(33, 1)] = c[hook(31, 2)][hook(33, 1)] * pivot;
  c[hook(31, 3)][hook(34, 1)] = c[hook(31, 3)][hook(34, 1)] * pivot;
  c[hook(31, 4)][hook(35, 1)] = c[hook(31, 4)][hook(35, 1)] * pivot;
  r[hook(36, 1)] = r[hook(36, 1)] * pivot;

  coeff = lhs[hook(25, 1)][hook(26, 0)];
  lhs[hook(25, 2)][hook(27, 0)] = lhs[hook(25, 2)][hook(27, 0)] - coeff * lhs[hook(25, 2)][hook(27, 1)];
  lhs[hook(25, 3)][hook(28, 0)] = lhs[hook(25, 3)][hook(28, 0)] - coeff * lhs[hook(25, 3)][hook(28, 1)];
  lhs[hook(25, 4)][hook(29, 0)] = lhs[hook(25, 4)][hook(29, 0)] - coeff * lhs[hook(25, 4)][hook(29, 1)];
  c[hook(31, 0)][hook(30, 0)] = c[hook(31, 0)][hook(30, 0)] - coeff * c[hook(31, 0)][hook(30, 1)];
  c[hook(31, 1)][hook(32, 0)] = c[hook(31, 1)][hook(32, 0)] - coeff * c[hook(31, 1)][hook(32, 1)];
  c[hook(31, 2)][hook(33, 0)] = c[hook(31, 2)][hook(33, 0)] - coeff * c[hook(31, 2)][hook(33, 1)];
  c[hook(31, 3)][hook(34, 0)] = c[hook(31, 3)][hook(34, 0)] - coeff * c[hook(31, 3)][hook(34, 1)];
  c[hook(31, 4)][hook(35, 0)] = c[hook(31, 4)][hook(35, 0)] - coeff * c[hook(31, 4)][hook(35, 1)];
  r[hook(36, 0)] = r[hook(36, 0)] - coeff * r[hook(36, 1)];

  coeff = lhs[hook(25, 1)][hook(26, 2)];
  lhs[hook(25, 2)][hook(27, 2)] = lhs[hook(25, 2)][hook(27, 2)] - coeff * lhs[hook(25, 2)][hook(27, 1)];
  lhs[hook(25, 3)][hook(28, 2)] = lhs[hook(25, 3)][hook(28, 2)] - coeff * lhs[hook(25, 3)][hook(28, 1)];
  lhs[hook(25, 4)][hook(29, 2)] = lhs[hook(25, 4)][hook(29, 2)] - coeff * lhs[hook(25, 4)][hook(29, 1)];
  c[hook(31, 0)][hook(30, 2)] = c[hook(31, 0)][hook(30, 2)] - coeff * c[hook(31, 0)][hook(30, 1)];
  c[hook(31, 1)][hook(32, 2)] = c[hook(31, 1)][hook(32, 2)] - coeff * c[hook(31, 1)][hook(32, 1)];
  c[hook(31, 2)][hook(33, 2)] = c[hook(31, 2)][hook(33, 2)] - coeff * c[hook(31, 2)][hook(33, 1)];
  c[hook(31, 3)][hook(34, 2)] = c[hook(31, 3)][hook(34, 2)] - coeff * c[hook(31, 3)][hook(34, 1)];
  c[hook(31, 4)][hook(35, 2)] = c[hook(31, 4)][hook(35, 2)] - coeff * c[hook(31, 4)][hook(35, 1)];
  r[hook(36, 2)] = r[hook(36, 2)] - coeff * r[hook(36, 1)];

  coeff = lhs[hook(25, 1)][hook(26, 3)];
  lhs[hook(25, 2)][hook(27, 3)] = lhs[hook(25, 2)][hook(27, 3)] - coeff * lhs[hook(25, 2)][hook(27, 1)];
  lhs[hook(25, 3)][hook(28, 3)] = lhs[hook(25, 3)][hook(28, 3)] - coeff * lhs[hook(25, 3)][hook(28, 1)];
  lhs[hook(25, 4)][hook(29, 3)] = lhs[hook(25, 4)][hook(29, 3)] - coeff * lhs[hook(25, 4)][hook(29, 1)];
  c[hook(31, 0)][hook(30, 3)] = c[hook(31, 0)][hook(30, 3)] - coeff * c[hook(31, 0)][hook(30, 1)];
  c[hook(31, 1)][hook(32, 3)] = c[hook(31, 1)][hook(32, 3)] - coeff * c[hook(31, 1)][hook(32, 1)];
  c[hook(31, 2)][hook(33, 3)] = c[hook(31, 2)][hook(33, 3)] - coeff * c[hook(31, 2)][hook(33, 1)];
  c[hook(31, 3)][hook(34, 3)] = c[hook(31, 3)][hook(34, 3)] - coeff * c[hook(31, 3)][hook(34, 1)];
  c[hook(31, 4)][hook(35, 3)] = c[hook(31, 4)][hook(35, 3)] - coeff * c[hook(31, 4)][hook(35, 1)];
  r[hook(36, 3)] = r[hook(36, 3)] - coeff * r[hook(36, 1)];

  coeff = lhs[hook(25, 1)][hook(26, 4)];
  lhs[hook(25, 2)][hook(27, 4)] = lhs[hook(25, 2)][hook(27, 4)] - coeff * lhs[hook(25, 2)][hook(27, 1)];
  lhs[hook(25, 3)][hook(28, 4)] = lhs[hook(25, 3)][hook(28, 4)] - coeff * lhs[hook(25, 3)][hook(28, 1)];
  lhs[hook(25, 4)][hook(29, 4)] = lhs[hook(25, 4)][hook(29, 4)] - coeff * lhs[hook(25, 4)][hook(29, 1)];
  c[hook(31, 0)][hook(30, 4)] = c[hook(31, 0)][hook(30, 4)] - coeff * c[hook(31, 0)][hook(30, 1)];
  c[hook(31, 1)][hook(32, 4)] = c[hook(31, 1)][hook(32, 4)] - coeff * c[hook(31, 1)][hook(32, 1)];
  c[hook(31, 2)][hook(33, 4)] = c[hook(31, 2)][hook(33, 4)] - coeff * c[hook(31, 2)][hook(33, 1)];
  c[hook(31, 3)][hook(34, 4)] = c[hook(31, 3)][hook(34, 4)] - coeff * c[hook(31, 3)][hook(34, 1)];
  c[hook(31, 4)][hook(35, 4)] = c[hook(31, 4)][hook(35, 4)] - coeff * c[hook(31, 4)][hook(35, 1)];
  r[hook(36, 4)] = r[hook(36, 4)] - coeff * r[hook(36, 1)];

  pivot = 1.00 / lhs[hook(25, 2)][hook(27, 2)];
  lhs[hook(25, 3)][hook(28, 2)] = lhs[hook(25, 3)][hook(28, 2)] * pivot;
  lhs[hook(25, 4)][hook(29, 2)] = lhs[hook(25, 4)][hook(29, 2)] * pivot;
  c[hook(31, 0)][hook(30, 2)] = c[hook(31, 0)][hook(30, 2)] * pivot;
  c[hook(31, 1)][hook(32, 2)] = c[hook(31, 1)][hook(32, 2)] * pivot;
  c[hook(31, 2)][hook(33, 2)] = c[hook(31, 2)][hook(33, 2)] * pivot;
  c[hook(31, 3)][hook(34, 2)] = c[hook(31, 3)][hook(34, 2)] * pivot;
  c[hook(31, 4)][hook(35, 2)] = c[hook(31, 4)][hook(35, 2)] * pivot;
  r[hook(36, 2)] = r[hook(36, 2)] * pivot;

  coeff = lhs[hook(25, 2)][hook(27, 0)];
  lhs[hook(25, 3)][hook(28, 0)] = lhs[hook(25, 3)][hook(28, 0)] - coeff * lhs[hook(25, 3)][hook(28, 2)];
  lhs[hook(25, 4)][hook(29, 0)] = lhs[hook(25, 4)][hook(29, 0)] - coeff * lhs[hook(25, 4)][hook(29, 2)];
  c[hook(31, 0)][hook(30, 0)] = c[hook(31, 0)][hook(30, 0)] - coeff * c[hook(31, 0)][hook(30, 2)];
  c[hook(31, 1)][hook(32, 0)] = c[hook(31, 1)][hook(32, 0)] - coeff * c[hook(31, 1)][hook(32, 2)];
  c[hook(31, 2)][hook(33, 0)] = c[hook(31, 2)][hook(33, 0)] - coeff * c[hook(31, 2)][hook(33, 2)];
  c[hook(31, 3)][hook(34, 0)] = c[hook(31, 3)][hook(34, 0)] - coeff * c[hook(31, 3)][hook(34, 2)];
  c[hook(31, 4)][hook(35, 0)] = c[hook(31, 4)][hook(35, 0)] - coeff * c[hook(31, 4)][hook(35, 2)];
  r[hook(36, 0)] = r[hook(36, 0)] - coeff * r[hook(36, 2)];

  coeff = lhs[hook(25, 2)][hook(27, 1)];
  lhs[hook(25, 3)][hook(28, 1)] = lhs[hook(25, 3)][hook(28, 1)] - coeff * lhs[hook(25, 3)][hook(28, 2)];
  lhs[hook(25, 4)][hook(29, 1)] = lhs[hook(25, 4)][hook(29, 1)] - coeff * lhs[hook(25, 4)][hook(29, 2)];
  c[hook(31, 0)][hook(30, 1)] = c[hook(31, 0)][hook(30, 1)] - coeff * c[hook(31, 0)][hook(30, 2)];
  c[hook(31, 1)][hook(32, 1)] = c[hook(31, 1)][hook(32, 1)] - coeff * c[hook(31, 1)][hook(32, 2)];
  c[hook(31, 2)][hook(33, 1)] = c[hook(31, 2)][hook(33, 1)] - coeff * c[hook(31, 2)][hook(33, 2)];
  c[hook(31, 3)][hook(34, 1)] = c[hook(31, 3)][hook(34, 1)] - coeff * c[hook(31, 3)][hook(34, 2)];
  c[hook(31, 4)][hook(35, 1)] = c[hook(31, 4)][hook(35, 1)] - coeff * c[hook(31, 4)][hook(35, 2)];
  r[hook(36, 1)] = r[hook(36, 1)] - coeff * r[hook(36, 2)];

  coeff = lhs[hook(25, 2)][hook(27, 3)];
  lhs[hook(25, 3)][hook(28, 3)] = lhs[hook(25, 3)][hook(28, 3)] - coeff * lhs[hook(25, 3)][hook(28, 2)];
  lhs[hook(25, 4)][hook(29, 3)] = lhs[hook(25, 4)][hook(29, 3)] - coeff * lhs[hook(25, 4)][hook(29, 2)];
  c[hook(31, 0)][hook(30, 3)] = c[hook(31, 0)][hook(30, 3)] - coeff * c[hook(31, 0)][hook(30, 2)];
  c[hook(31, 1)][hook(32, 3)] = c[hook(31, 1)][hook(32, 3)] - coeff * c[hook(31, 1)][hook(32, 2)];
  c[hook(31, 2)][hook(33, 3)] = c[hook(31, 2)][hook(33, 3)] - coeff * c[hook(31, 2)][hook(33, 2)];
  c[hook(31, 3)][hook(34, 3)] = c[hook(31, 3)][hook(34, 3)] - coeff * c[hook(31, 3)][hook(34, 2)];
  c[hook(31, 4)][hook(35, 3)] = c[hook(31, 4)][hook(35, 3)] - coeff * c[hook(31, 4)][hook(35, 2)];
  r[hook(36, 3)] = r[hook(36, 3)] - coeff * r[hook(36, 2)];

  coeff = lhs[hook(25, 2)][hook(27, 4)];
  lhs[hook(25, 3)][hook(28, 4)] = lhs[hook(25, 3)][hook(28, 4)] - coeff * lhs[hook(25, 3)][hook(28, 2)];
  lhs[hook(25, 4)][hook(29, 4)] = lhs[hook(25, 4)][hook(29, 4)] - coeff * lhs[hook(25, 4)][hook(29, 2)];
  c[hook(31, 0)][hook(30, 4)] = c[hook(31, 0)][hook(30, 4)] - coeff * c[hook(31, 0)][hook(30, 2)];
  c[hook(31, 1)][hook(32, 4)] = c[hook(31, 1)][hook(32, 4)] - coeff * c[hook(31, 1)][hook(32, 2)];
  c[hook(31, 2)][hook(33, 4)] = c[hook(31, 2)][hook(33, 4)] - coeff * c[hook(31, 2)][hook(33, 2)];
  c[hook(31, 3)][hook(34, 4)] = c[hook(31, 3)][hook(34, 4)] - coeff * c[hook(31, 3)][hook(34, 2)];
  c[hook(31, 4)][hook(35, 4)] = c[hook(31, 4)][hook(35, 4)] - coeff * c[hook(31, 4)][hook(35, 2)];
  r[hook(36, 4)] = r[hook(36, 4)] - coeff * r[hook(36, 2)];

  pivot = 1.00 / lhs[hook(25, 3)][hook(28, 3)];
  lhs[hook(25, 4)][hook(29, 3)] = lhs[hook(25, 4)][hook(29, 3)] * pivot;
  c[hook(31, 0)][hook(30, 3)] = c[hook(31, 0)][hook(30, 3)] * pivot;
  c[hook(31, 1)][hook(32, 3)] = c[hook(31, 1)][hook(32, 3)] * pivot;
  c[hook(31, 2)][hook(33, 3)] = c[hook(31, 2)][hook(33, 3)] * pivot;
  c[hook(31, 3)][hook(34, 3)] = c[hook(31, 3)][hook(34, 3)] * pivot;
  c[hook(31, 4)][hook(35, 3)] = c[hook(31, 4)][hook(35, 3)] * pivot;
  r[hook(36, 3)] = r[hook(36, 3)] * pivot;

  coeff = lhs[hook(25, 3)][hook(28, 0)];
  lhs[hook(25, 4)][hook(29, 0)] = lhs[hook(25, 4)][hook(29, 0)] - coeff * lhs[hook(25, 4)][hook(29, 3)];
  c[hook(31, 0)][hook(30, 0)] = c[hook(31, 0)][hook(30, 0)] - coeff * c[hook(31, 0)][hook(30, 3)];
  c[hook(31, 1)][hook(32, 0)] = c[hook(31, 1)][hook(32, 0)] - coeff * c[hook(31, 1)][hook(32, 3)];
  c[hook(31, 2)][hook(33, 0)] = c[hook(31, 2)][hook(33, 0)] - coeff * c[hook(31, 2)][hook(33, 3)];
  c[hook(31, 3)][hook(34, 0)] = c[hook(31, 3)][hook(34, 0)] - coeff * c[hook(31, 3)][hook(34, 3)];
  c[hook(31, 4)][hook(35, 0)] = c[hook(31, 4)][hook(35, 0)] - coeff * c[hook(31, 4)][hook(35, 3)];
  r[hook(36, 0)] = r[hook(36, 0)] - coeff * r[hook(36, 3)];

  coeff = lhs[hook(25, 3)][hook(28, 1)];
  lhs[hook(25, 4)][hook(29, 1)] = lhs[hook(25, 4)][hook(29, 1)] - coeff * lhs[hook(25, 4)][hook(29, 3)];
  c[hook(31, 0)][hook(30, 1)] = c[hook(31, 0)][hook(30, 1)] - coeff * c[hook(31, 0)][hook(30, 3)];
  c[hook(31, 1)][hook(32, 1)] = c[hook(31, 1)][hook(32, 1)] - coeff * c[hook(31, 1)][hook(32, 3)];
  c[hook(31, 2)][hook(33, 1)] = c[hook(31, 2)][hook(33, 1)] - coeff * c[hook(31, 2)][hook(33, 3)];
  c[hook(31, 3)][hook(34, 1)] = c[hook(31, 3)][hook(34, 1)] - coeff * c[hook(31, 3)][hook(34, 3)];
  c[hook(31, 4)][hook(35, 1)] = c[hook(31, 4)][hook(35, 1)] - coeff * c[hook(31, 4)][hook(35, 3)];
  r[hook(36, 1)] = r[hook(36, 1)] - coeff * r[hook(36, 3)];

  coeff = lhs[hook(25, 3)][hook(28, 2)];
  lhs[hook(25, 4)][hook(29, 2)] = lhs[hook(25, 4)][hook(29, 2)] - coeff * lhs[hook(25, 4)][hook(29, 3)];
  c[hook(31, 0)][hook(30, 2)] = c[hook(31, 0)][hook(30, 2)] - coeff * c[hook(31, 0)][hook(30, 3)];
  c[hook(31, 1)][hook(32, 2)] = c[hook(31, 1)][hook(32, 2)] - coeff * c[hook(31, 1)][hook(32, 3)];
  c[hook(31, 2)][hook(33, 2)] = c[hook(31, 2)][hook(33, 2)] - coeff * c[hook(31, 2)][hook(33, 3)];
  c[hook(31, 3)][hook(34, 2)] = c[hook(31, 3)][hook(34, 2)] - coeff * c[hook(31, 3)][hook(34, 3)];
  c[hook(31, 4)][hook(35, 2)] = c[hook(31, 4)][hook(35, 2)] - coeff * c[hook(31, 4)][hook(35, 3)];
  r[hook(36, 2)] = r[hook(36, 2)] - coeff * r[hook(36, 3)];

  coeff = lhs[hook(25, 3)][hook(28, 4)];
  lhs[hook(25, 4)][hook(29, 4)] = lhs[hook(25, 4)][hook(29, 4)] - coeff * lhs[hook(25, 4)][hook(29, 3)];
  c[hook(31, 0)][hook(30, 4)] = c[hook(31, 0)][hook(30, 4)] - coeff * c[hook(31, 0)][hook(30, 3)];
  c[hook(31, 1)][hook(32, 4)] = c[hook(31, 1)][hook(32, 4)] - coeff * c[hook(31, 1)][hook(32, 3)];
  c[hook(31, 2)][hook(33, 4)] = c[hook(31, 2)][hook(33, 4)] - coeff * c[hook(31, 2)][hook(33, 3)];
  c[hook(31, 3)][hook(34, 4)] = c[hook(31, 3)][hook(34, 4)] - coeff * c[hook(31, 3)][hook(34, 3)];
  c[hook(31, 4)][hook(35, 4)] = c[hook(31, 4)][hook(35, 4)] - coeff * c[hook(31, 4)][hook(35, 3)];
  r[hook(36, 4)] = r[hook(36, 4)] - coeff * r[hook(36, 3)];

  pivot = 1.00 / lhs[hook(25, 4)][hook(29, 4)];
  c[hook(31, 0)][hook(30, 4)] = c[hook(31, 0)][hook(30, 4)] * pivot;
  c[hook(31, 1)][hook(32, 4)] = c[hook(31, 1)][hook(32, 4)] * pivot;
  c[hook(31, 2)][hook(33, 4)] = c[hook(31, 2)][hook(33, 4)] * pivot;
  c[hook(31, 3)][hook(34, 4)] = c[hook(31, 3)][hook(34, 4)] * pivot;
  c[hook(31, 4)][hook(35, 4)] = c[hook(31, 4)][hook(35, 4)] * pivot;
  r[hook(36, 4)] = r[hook(36, 4)] * pivot;

  coeff = lhs[hook(25, 4)][hook(29, 0)];
  c[hook(31, 0)][hook(30, 0)] = c[hook(31, 0)][hook(30, 0)] - coeff * c[hook(31, 0)][hook(30, 4)];
  c[hook(31, 1)][hook(32, 0)] = c[hook(31, 1)][hook(32, 0)] - coeff * c[hook(31, 1)][hook(32, 4)];
  c[hook(31, 2)][hook(33, 0)] = c[hook(31, 2)][hook(33, 0)] - coeff * c[hook(31, 2)][hook(33, 4)];
  c[hook(31, 3)][hook(34, 0)] = c[hook(31, 3)][hook(34, 0)] - coeff * c[hook(31, 3)][hook(34, 4)];
  c[hook(31, 4)][hook(35, 0)] = c[hook(31, 4)][hook(35, 0)] - coeff * c[hook(31, 4)][hook(35, 4)];
  r[hook(36, 0)] = r[hook(36, 0)] - coeff * r[hook(36, 4)];

  coeff = lhs[hook(25, 4)][hook(29, 1)];
  c[hook(31, 0)][hook(30, 1)] = c[hook(31, 0)][hook(30, 1)] - coeff * c[hook(31, 0)][hook(30, 4)];
  c[hook(31, 1)][hook(32, 1)] = c[hook(31, 1)][hook(32, 1)] - coeff * c[hook(31, 1)][hook(32, 4)];
  c[hook(31, 2)][hook(33, 1)] = c[hook(31, 2)][hook(33, 1)] - coeff * c[hook(31, 2)][hook(33, 4)];
  c[hook(31, 3)][hook(34, 1)] = c[hook(31, 3)][hook(34, 1)] - coeff * c[hook(31, 3)][hook(34, 4)];
  c[hook(31, 4)][hook(35, 1)] = c[hook(31, 4)][hook(35, 1)] - coeff * c[hook(31, 4)][hook(35, 4)];
  r[hook(36, 1)] = r[hook(36, 1)] - coeff * r[hook(36, 4)];

  coeff = lhs[hook(25, 4)][hook(29, 2)];
  c[hook(31, 0)][hook(30, 2)] = c[hook(31, 0)][hook(30, 2)] - coeff * c[hook(31, 0)][hook(30, 4)];
  c[hook(31, 1)][hook(32, 2)] = c[hook(31, 1)][hook(32, 2)] - coeff * c[hook(31, 1)][hook(32, 4)];
  c[hook(31, 2)][hook(33, 2)] = c[hook(31, 2)][hook(33, 2)] - coeff * c[hook(31, 2)][hook(33, 4)];
  c[hook(31, 3)][hook(34, 2)] = c[hook(31, 3)][hook(34, 2)] - coeff * c[hook(31, 3)][hook(34, 4)];
  c[hook(31, 4)][hook(35, 2)] = c[hook(31, 4)][hook(35, 2)] - coeff * c[hook(31, 4)][hook(35, 4)];
  r[hook(36, 2)] = r[hook(36, 2)] - coeff * r[hook(36, 4)];

  coeff = lhs[hook(25, 4)][hook(29, 3)];
  c[hook(31, 0)][hook(30, 3)] = c[hook(31, 0)][hook(30, 3)] - coeff * c[hook(31, 0)][hook(30, 4)];
  c[hook(31, 1)][hook(32, 3)] = c[hook(31, 1)][hook(32, 3)] - coeff * c[hook(31, 1)][hook(32, 4)];
  c[hook(31, 2)][hook(33, 3)] = c[hook(31, 2)][hook(33, 3)] - coeff * c[hook(31, 2)][hook(33, 4)];
  c[hook(31, 3)][hook(34, 3)] = c[hook(31, 3)][hook(34, 3)] - coeff * c[hook(31, 3)][hook(34, 4)];
  c[hook(31, 4)][hook(35, 3)] = c[hook(31, 4)][hook(35, 3)] - coeff * c[hook(31, 4)][hook(35, 4)];
  r[hook(36, 3)] = r[hook(36, 3)] - coeff * r[hook(36, 4)];
}

void p_binvrhs(double lhs[5][5], double r[5]) {
  double pivot, coeff;

  pivot = 1.00 / lhs[hook(25, 0)][hook(24, 0)];
  lhs[hook(25, 1)][hook(26, 0)] = lhs[hook(25, 1)][hook(26, 0)] * pivot;
  lhs[hook(25, 2)][hook(27, 0)] = lhs[hook(25, 2)][hook(27, 0)] * pivot;
  lhs[hook(25, 3)][hook(28, 0)] = lhs[hook(25, 3)][hook(28, 0)] * pivot;
  lhs[hook(25, 4)][hook(29, 0)] = lhs[hook(25, 4)][hook(29, 0)] * pivot;
  r[hook(36, 0)] = r[hook(36, 0)] * pivot;

  coeff = lhs[hook(25, 0)][hook(24, 1)];
  lhs[hook(25, 1)][hook(26, 1)] = lhs[hook(25, 1)][hook(26, 1)] - coeff * lhs[hook(25, 1)][hook(26, 0)];
  lhs[hook(25, 2)][hook(27, 1)] = lhs[hook(25, 2)][hook(27, 1)] - coeff * lhs[hook(25, 2)][hook(27, 0)];
  lhs[hook(25, 3)][hook(28, 1)] = lhs[hook(25, 3)][hook(28, 1)] - coeff * lhs[hook(25, 3)][hook(28, 0)];
  lhs[hook(25, 4)][hook(29, 1)] = lhs[hook(25, 4)][hook(29, 1)] - coeff * lhs[hook(25, 4)][hook(29, 0)];
  r[hook(36, 1)] = r[hook(36, 1)] - coeff * r[hook(36, 0)];

  coeff = lhs[hook(25, 0)][hook(24, 2)];
  lhs[hook(25, 1)][hook(26, 2)] = lhs[hook(25, 1)][hook(26, 2)] - coeff * lhs[hook(25, 1)][hook(26, 0)];
  lhs[hook(25, 2)][hook(27, 2)] = lhs[hook(25, 2)][hook(27, 2)] - coeff * lhs[hook(25, 2)][hook(27, 0)];
  lhs[hook(25, 3)][hook(28, 2)] = lhs[hook(25, 3)][hook(28, 2)] - coeff * lhs[hook(25, 3)][hook(28, 0)];
  lhs[hook(25, 4)][hook(29, 2)] = lhs[hook(25, 4)][hook(29, 2)] - coeff * lhs[hook(25, 4)][hook(29, 0)];
  r[hook(36, 2)] = r[hook(36, 2)] - coeff * r[hook(36, 0)];

  coeff = lhs[hook(25, 0)][hook(24, 3)];
  lhs[hook(25, 1)][hook(26, 3)] = lhs[hook(25, 1)][hook(26, 3)] - coeff * lhs[hook(25, 1)][hook(26, 0)];
  lhs[hook(25, 2)][hook(27, 3)] = lhs[hook(25, 2)][hook(27, 3)] - coeff * lhs[hook(25, 2)][hook(27, 0)];
  lhs[hook(25, 3)][hook(28, 3)] = lhs[hook(25, 3)][hook(28, 3)] - coeff * lhs[hook(25, 3)][hook(28, 0)];
  lhs[hook(25, 4)][hook(29, 3)] = lhs[hook(25, 4)][hook(29, 3)] - coeff * lhs[hook(25, 4)][hook(29, 0)];
  r[hook(36, 3)] = r[hook(36, 3)] - coeff * r[hook(36, 0)];

  coeff = lhs[hook(25, 0)][hook(24, 4)];
  lhs[hook(25, 1)][hook(26, 4)] = lhs[hook(25, 1)][hook(26, 4)] - coeff * lhs[hook(25, 1)][hook(26, 0)];
  lhs[hook(25, 2)][hook(27, 4)] = lhs[hook(25, 2)][hook(27, 4)] - coeff * lhs[hook(25, 2)][hook(27, 0)];
  lhs[hook(25, 3)][hook(28, 4)] = lhs[hook(25, 3)][hook(28, 4)] - coeff * lhs[hook(25, 3)][hook(28, 0)];
  lhs[hook(25, 4)][hook(29, 4)] = lhs[hook(25, 4)][hook(29, 4)] - coeff * lhs[hook(25, 4)][hook(29, 0)];
  r[hook(36, 4)] = r[hook(36, 4)] - coeff * r[hook(36, 0)];

  pivot = 1.00 / lhs[hook(25, 1)][hook(26, 1)];
  lhs[hook(25, 2)][hook(27, 1)] = lhs[hook(25, 2)][hook(27, 1)] * pivot;
  lhs[hook(25, 3)][hook(28, 1)] = lhs[hook(25, 3)][hook(28, 1)] * pivot;
  lhs[hook(25, 4)][hook(29, 1)] = lhs[hook(25, 4)][hook(29, 1)] * pivot;
  r[hook(36, 1)] = r[hook(36, 1)] * pivot;

  coeff = lhs[hook(25, 1)][hook(26, 0)];
  lhs[hook(25, 2)][hook(27, 0)] = lhs[hook(25, 2)][hook(27, 0)] - coeff * lhs[hook(25, 2)][hook(27, 1)];
  lhs[hook(25, 3)][hook(28, 0)] = lhs[hook(25, 3)][hook(28, 0)] - coeff * lhs[hook(25, 3)][hook(28, 1)];
  lhs[hook(25, 4)][hook(29, 0)] = lhs[hook(25, 4)][hook(29, 0)] - coeff * lhs[hook(25, 4)][hook(29, 1)];
  r[hook(36, 0)] = r[hook(36, 0)] - coeff * r[hook(36, 1)];

  coeff = lhs[hook(25, 1)][hook(26, 2)];
  lhs[hook(25, 2)][hook(27, 2)] = lhs[hook(25, 2)][hook(27, 2)] - coeff * lhs[hook(25, 2)][hook(27, 1)];
  lhs[hook(25, 3)][hook(28, 2)] = lhs[hook(25, 3)][hook(28, 2)] - coeff * lhs[hook(25, 3)][hook(28, 1)];
  lhs[hook(25, 4)][hook(29, 2)] = lhs[hook(25, 4)][hook(29, 2)] - coeff * lhs[hook(25, 4)][hook(29, 1)];
  r[hook(36, 2)] = r[hook(36, 2)] - coeff * r[hook(36, 1)];

  coeff = lhs[hook(25, 1)][hook(26, 3)];
  lhs[hook(25, 2)][hook(27, 3)] = lhs[hook(25, 2)][hook(27, 3)] - coeff * lhs[hook(25, 2)][hook(27, 1)];
  lhs[hook(25, 3)][hook(28, 3)] = lhs[hook(25, 3)][hook(28, 3)] - coeff * lhs[hook(25, 3)][hook(28, 1)];
  lhs[hook(25, 4)][hook(29, 3)] = lhs[hook(25, 4)][hook(29, 3)] - coeff * lhs[hook(25, 4)][hook(29, 1)];
  r[hook(36, 3)] = r[hook(36, 3)] - coeff * r[hook(36, 1)];

  coeff = lhs[hook(25, 1)][hook(26, 4)];
  lhs[hook(25, 2)][hook(27, 4)] = lhs[hook(25, 2)][hook(27, 4)] - coeff * lhs[hook(25, 2)][hook(27, 1)];
  lhs[hook(25, 3)][hook(28, 4)] = lhs[hook(25, 3)][hook(28, 4)] - coeff * lhs[hook(25, 3)][hook(28, 1)];
  lhs[hook(25, 4)][hook(29, 4)] = lhs[hook(25, 4)][hook(29, 4)] - coeff * lhs[hook(25, 4)][hook(29, 1)];
  r[hook(36, 4)] = r[hook(36, 4)] - coeff * r[hook(36, 1)];

  pivot = 1.00 / lhs[hook(25, 2)][hook(27, 2)];
  lhs[hook(25, 3)][hook(28, 2)] = lhs[hook(25, 3)][hook(28, 2)] * pivot;
  lhs[hook(25, 4)][hook(29, 2)] = lhs[hook(25, 4)][hook(29, 2)] * pivot;
  r[hook(36, 2)] = r[hook(36, 2)] * pivot;

  coeff = lhs[hook(25, 2)][hook(27, 0)];
  lhs[hook(25, 3)][hook(28, 0)] = lhs[hook(25, 3)][hook(28, 0)] - coeff * lhs[hook(25, 3)][hook(28, 2)];
  lhs[hook(25, 4)][hook(29, 0)] = lhs[hook(25, 4)][hook(29, 0)] - coeff * lhs[hook(25, 4)][hook(29, 2)];
  r[hook(36, 0)] = r[hook(36, 0)] - coeff * r[hook(36, 2)];

  coeff = lhs[hook(25, 2)][hook(27, 1)];
  lhs[hook(25, 3)][hook(28, 1)] = lhs[hook(25, 3)][hook(28, 1)] - coeff * lhs[hook(25, 3)][hook(28, 2)];
  lhs[hook(25, 4)][hook(29, 1)] = lhs[hook(25, 4)][hook(29, 1)] - coeff * lhs[hook(25, 4)][hook(29, 2)];
  r[hook(36, 1)] = r[hook(36, 1)] - coeff * r[hook(36, 2)];

  coeff = lhs[hook(25, 2)][hook(27, 3)];
  lhs[hook(25, 3)][hook(28, 3)] = lhs[hook(25, 3)][hook(28, 3)] - coeff * lhs[hook(25, 3)][hook(28, 2)];
  lhs[hook(25, 4)][hook(29, 3)] = lhs[hook(25, 4)][hook(29, 3)] - coeff * lhs[hook(25, 4)][hook(29, 2)];
  r[hook(36, 3)] = r[hook(36, 3)] - coeff * r[hook(36, 2)];

  coeff = lhs[hook(25, 2)][hook(27, 4)];
  lhs[hook(25, 3)][hook(28, 4)] = lhs[hook(25, 3)][hook(28, 4)] - coeff * lhs[hook(25, 3)][hook(28, 2)];
  lhs[hook(25, 4)][hook(29, 4)] = lhs[hook(25, 4)][hook(29, 4)] - coeff * lhs[hook(25, 4)][hook(29, 2)];
  r[hook(36, 4)] = r[hook(36, 4)] - coeff * r[hook(36, 2)];

  pivot = 1.00 / lhs[hook(25, 3)][hook(28, 3)];
  lhs[hook(25, 4)][hook(29, 3)] = lhs[hook(25, 4)][hook(29, 3)] * pivot;
  r[hook(36, 3)] = r[hook(36, 3)] * pivot;

  coeff = lhs[hook(25, 3)][hook(28, 0)];
  lhs[hook(25, 4)][hook(29, 0)] = lhs[hook(25, 4)][hook(29, 0)] - coeff * lhs[hook(25, 4)][hook(29, 3)];
  r[hook(36, 0)] = r[hook(36, 0)] - coeff * r[hook(36, 3)];

  coeff = lhs[hook(25, 3)][hook(28, 1)];
  lhs[hook(25, 4)][hook(29, 1)] = lhs[hook(25, 4)][hook(29, 1)] - coeff * lhs[hook(25, 4)][hook(29, 3)];
  r[hook(36, 1)] = r[hook(36, 1)] - coeff * r[hook(36, 3)];

  coeff = lhs[hook(25, 3)][hook(28, 2)];
  lhs[hook(25, 4)][hook(29, 2)] = lhs[hook(25, 4)][hook(29, 2)] - coeff * lhs[hook(25, 4)][hook(29, 3)];
  r[hook(36, 2)] = r[hook(36, 2)] - coeff * r[hook(36, 3)];

  coeff = lhs[hook(25, 3)][hook(28, 4)];
  lhs[hook(25, 4)][hook(29, 4)] = lhs[hook(25, 4)][hook(29, 4)] - coeff * lhs[hook(25, 4)][hook(29, 3)];
  r[hook(36, 4)] = r[hook(36, 4)] - coeff * r[hook(36, 3)];

  pivot = 1.00 / lhs[hook(25, 4)][hook(29, 4)];
  r[hook(36, 4)] = r[hook(36, 4)] * pivot;

  coeff = lhs[hook(25, 4)][hook(29, 0)];
  r[hook(36, 0)] = r[hook(36, 0)] - coeff * r[hook(36, 4)];

  coeff = lhs[hook(25, 4)][hook(29, 1)];
  r[hook(36, 1)] = r[hook(36, 1)] - coeff * r[hook(36, 4)];

  coeff = lhs[hook(25, 4)][hook(29, 2)];
  r[hook(36, 2)] = r[hook(36, 2)] - coeff * r[hook(36, 4)];

  coeff = lhs[hook(25, 4)][hook(29, 3)];
  r[hook(36, 3)] = r[hook(36, 3)] - coeff * r[hook(36, 4)];
}

void load_matrix(double p_matrix[5][5], global double g_matrix[5][5]) {
  p_matrix[hook(38, 0)][hook(37, 0)] = g_matrix[hook(40, 0)][hook(39, 0)];
  p_matrix[hook(38, 0)][hook(37, 1)] = g_matrix[hook(40, 0)][hook(39, 1)];
  p_matrix[hook(38, 0)][hook(37, 2)] = g_matrix[hook(40, 0)][hook(39, 2)];
  p_matrix[hook(38, 0)][hook(37, 3)] = g_matrix[hook(40, 0)][hook(39, 3)];
  p_matrix[hook(38, 0)][hook(37, 4)] = g_matrix[hook(40, 0)][hook(39, 4)];
  p_matrix[hook(38, 1)][hook(41, 0)] = g_matrix[hook(40, 1)][hook(42, 0)];
  p_matrix[hook(38, 1)][hook(41, 1)] = g_matrix[hook(40, 1)][hook(42, 1)];
  p_matrix[hook(38, 1)][hook(41, 2)] = g_matrix[hook(40, 1)][hook(42, 2)];
  p_matrix[hook(38, 1)][hook(41, 3)] = g_matrix[hook(40, 1)][hook(42, 3)];
  p_matrix[hook(38, 1)][hook(41, 4)] = g_matrix[hook(40, 1)][hook(42, 4)];
  p_matrix[hook(38, 2)][hook(43, 0)] = g_matrix[hook(40, 2)][hook(44, 0)];
  p_matrix[hook(38, 2)][hook(43, 1)] = g_matrix[hook(40, 2)][hook(44, 1)];
  p_matrix[hook(38, 2)][hook(43, 2)] = g_matrix[hook(40, 2)][hook(44, 2)];
  p_matrix[hook(38, 2)][hook(43, 3)] = g_matrix[hook(40, 2)][hook(44, 3)];
  p_matrix[hook(38, 2)][hook(43, 4)] = g_matrix[hook(40, 2)][hook(44, 4)];
  p_matrix[hook(38, 3)][hook(45, 0)] = g_matrix[hook(40, 3)][hook(46, 0)];
  p_matrix[hook(38, 3)][hook(45, 1)] = g_matrix[hook(40, 3)][hook(46, 1)];
  p_matrix[hook(38, 3)][hook(45, 2)] = g_matrix[hook(40, 3)][hook(46, 2)];
  p_matrix[hook(38, 3)][hook(45, 3)] = g_matrix[hook(40, 3)][hook(46, 3)];
  p_matrix[hook(38, 3)][hook(45, 4)] = g_matrix[hook(40, 3)][hook(46, 4)];
  p_matrix[hook(38, 4)][hook(47, 0)] = g_matrix[hook(40, 4)][hook(48, 0)];
  p_matrix[hook(38, 4)][hook(47, 1)] = g_matrix[hook(40, 4)][hook(48, 1)];
  p_matrix[hook(38, 4)][hook(47, 2)] = g_matrix[hook(40, 4)][hook(48, 2)];
  p_matrix[hook(38, 4)][hook(47, 3)] = g_matrix[hook(40, 4)][hook(48, 3)];
  p_matrix[hook(38, 4)][hook(47, 4)] = g_matrix[hook(40, 4)][hook(48, 4)];
}

void save_matrix(global double g_matrix[5][5], double p_matrix[5][5]) {
  g_matrix[hook(40, 0)][hook(39, 0)] = p_matrix[hook(38, 0)][hook(37, 0)];
  g_matrix[hook(40, 0)][hook(39, 1)] = p_matrix[hook(38, 0)][hook(37, 1)];
  g_matrix[hook(40, 0)][hook(39, 2)] = p_matrix[hook(38, 0)][hook(37, 2)];
  g_matrix[hook(40, 0)][hook(39, 3)] = p_matrix[hook(38, 0)][hook(37, 3)];
  g_matrix[hook(40, 0)][hook(39, 4)] = p_matrix[hook(38, 0)][hook(37, 4)];
  g_matrix[hook(40, 1)][hook(42, 0)] = p_matrix[hook(38, 1)][hook(41, 0)];
  g_matrix[hook(40, 1)][hook(42, 1)] = p_matrix[hook(38, 1)][hook(41, 1)];
  g_matrix[hook(40, 1)][hook(42, 2)] = p_matrix[hook(38, 1)][hook(41, 2)];
  g_matrix[hook(40, 1)][hook(42, 3)] = p_matrix[hook(38, 1)][hook(41, 3)];
  g_matrix[hook(40, 1)][hook(42, 4)] = p_matrix[hook(38, 1)][hook(41, 4)];
  g_matrix[hook(40, 2)][hook(44, 0)] = p_matrix[hook(38, 2)][hook(43, 0)];
  g_matrix[hook(40, 2)][hook(44, 1)] = p_matrix[hook(38, 2)][hook(43, 1)];
  g_matrix[hook(40, 2)][hook(44, 2)] = p_matrix[hook(38, 2)][hook(43, 2)];
  g_matrix[hook(40, 2)][hook(44, 3)] = p_matrix[hook(38, 2)][hook(43, 3)];
  g_matrix[hook(40, 2)][hook(44, 4)] = p_matrix[hook(38, 2)][hook(43, 4)];
  g_matrix[hook(40, 3)][hook(46, 0)] = p_matrix[hook(38, 3)][hook(45, 0)];
  g_matrix[hook(40, 3)][hook(46, 1)] = p_matrix[hook(38, 3)][hook(45, 1)];
  g_matrix[hook(40, 3)][hook(46, 2)] = p_matrix[hook(38, 3)][hook(45, 2)];
  g_matrix[hook(40, 3)][hook(46, 3)] = p_matrix[hook(38, 3)][hook(45, 3)];
  g_matrix[hook(40, 3)][hook(46, 4)] = p_matrix[hook(38, 3)][hook(45, 4)];
  g_matrix[hook(40, 4)][hook(48, 0)] = p_matrix[hook(38, 4)][hook(47, 0)];
  g_matrix[hook(40, 4)][hook(48, 1)] = p_matrix[hook(38, 4)][hook(47, 1)];
  g_matrix[hook(40, 4)][hook(48, 2)] = p_matrix[hook(38, 4)][hook(47, 2)];
  g_matrix[hook(40, 4)][hook(48, 3)] = p_matrix[hook(38, 4)][hook(47, 3)];
  g_matrix[hook(40, 4)][hook(48, 4)] = p_matrix[hook(38, 4)][hook(47, 4)];
}

void copy_matrix(double p_matrix[5][5], double p_source[5][5]) {
  p_matrix[hook(38, 0)][hook(37, 0)] = p_source[hook(50, 0)][hook(49, 0)];
  p_matrix[hook(38, 0)][hook(37, 1)] = p_source[hook(50, 0)][hook(49, 1)];
  p_matrix[hook(38, 0)][hook(37, 2)] = p_source[hook(50, 0)][hook(49, 2)];
  p_matrix[hook(38, 0)][hook(37, 3)] = p_source[hook(50, 0)][hook(49, 3)];
  p_matrix[hook(38, 0)][hook(37, 4)] = p_source[hook(50, 0)][hook(49, 4)];
  p_matrix[hook(38, 1)][hook(41, 0)] = p_source[hook(50, 1)][hook(51, 0)];
  p_matrix[hook(38, 1)][hook(41, 1)] = p_source[hook(50, 1)][hook(51, 1)];
  p_matrix[hook(38, 1)][hook(41, 2)] = p_source[hook(50, 1)][hook(51, 2)];
  p_matrix[hook(38, 1)][hook(41, 3)] = p_source[hook(50, 1)][hook(51, 3)];
  p_matrix[hook(38, 1)][hook(41, 4)] = p_source[hook(50, 1)][hook(51, 4)];
  p_matrix[hook(38, 2)][hook(43, 0)] = p_source[hook(50, 2)][hook(52, 0)];
  p_matrix[hook(38, 2)][hook(43, 1)] = p_source[hook(50, 2)][hook(52, 1)];
  p_matrix[hook(38, 2)][hook(43, 2)] = p_source[hook(50, 2)][hook(52, 2)];
  p_matrix[hook(38, 2)][hook(43, 3)] = p_source[hook(50, 2)][hook(52, 3)];
  p_matrix[hook(38, 2)][hook(43, 4)] = p_source[hook(50, 2)][hook(52, 4)];
  p_matrix[hook(38, 3)][hook(45, 0)] = p_source[hook(50, 3)][hook(53, 0)];
  p_matrix[hook(38, 3)][hook(45, 1)] = p_source[hook(50, 3)][hook(53, 1)];
  p_matrix[hook(38, 3)][hook(45, 2)] = p_source[hook(50, 3)][hook(53, 2)];
  p_matrix[hook(38, 3)][hook(45, 3)] = p_source[hook(50, 3)][hook(53, 3)];
  p_matrix[hook(38, 3)][hook(45, 4)] = p_source[hook(50, 3)][hook(53, 4)];
  p_matrix[hook(38, 4)][hook(47, 0)] = p_source[hook(50, 4)][hook(54, 0)];
  p_matrix[hook(38, 4)][hook(47, 1)] = p_source[hook(50, 4)][hook(54, 1)];
  p_matrix[hook(38, 4)][hook(47, 2)] = p_source[hook(50, 4)][hook(54, 2)];
  p_matrix[hook(38, 4)][hook(47, 3)] = p_source[hook(50, 4)][hook(54, 3)];
  p_matrix[hook(38, 4)][hook(47, 4)] = p_source[hook(50, 4)][hook(54, 4)];
}

void load_vector(double p_vector[5], global double g_vector[5]) {
  p_vector[hook(55, 0)] = g_vector[hook(56, 0)];
  p_vector[hook(55, 1)] = g_vector[hook(56, 1)];
  p_vector[hook(55, 2)] = g_vector[hook(56, 2)];
  p_vector[hook(55, 3)] = g_vector[hook(56, 3)];
  p_vector[hook(55, 4)] = g_vector[hook(56, 4)];
}

void save_vector(global double g_vector[5], double p_vector[5]) {
  g_vector[hook(56, 0)] = p_vector[hook(55, 0)];
  g_vector[hook(56, 1)] = p_vector[hook(55, 1)];
  g_vector[hook(56, 2)] = p_vector[hook(55, 2)];
  g_vector[hook(56, 3)] = p_vector[hook(55, 3)];
  g_vector[hook(56, 4)] = p_vector[hook(55, 4)];
}

void copy_vector(double p_vector[5], double p_source[5]) {
  p_vector[hook(55, 0)] = p_source[hook(50, 0)];
  p_vector[hook(55, 1)] = p_source[hook(50, 1)];
  p_vector[hook(55, 2)] = p_source[hook(50, 2)];
  p_vector[hook(55, 3)] = p_source[hook(50, 3)];
  p_vector[hook(55, 4)] = p_source[hook(50, 4)];
}

kernel void y_solve2(global double* g_lhs, int gp0, int gp1, int gp2) {
  int i, j, k, n, m;

  k = get_global_id(2) + 1;
  i = get_global_id(1) + 1;
  if (k > (gp2 - 2) || i > (gp0 - 2))
    return;

  j = get_global_id(0);
  if (j == 1)
    j = gp1 - 1;

  int my_id = (k - 1) * (gp0 - 2) + (i - 1);
  int my_offset = my_id * (64 + 1) * 3 * 5 * 5;
  global double(*lhs)[3][5][5] = (global double(*)[3][5][5]) & g_lhs[hook(0, my_offset)];

  for (n = 0; n < 5; n++) {
    for (m = 0; m < 5; m++) {
      lhs[hook(25, j)][hook(59, 0)][hook(58, n)][hook(57, m)] = 0.0;
      lhs[hook(25, j)][hook(59, 1)][hook(61, n)][hook(60, m)] = 0.0;
      lhs[hook(25, j)][hook(59, 2)][hook(63, n)][hook(62, m)] = 0.0;
    }
    lhs[hook(25, j)][hook(59, 1)][hook(61, n)][hook(60, n)] = 1.0;
  }
}