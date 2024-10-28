//{"ablock":10,"ablock[0]":9,"ablock[1]":12,"ablock[2]":13,"ablock[3]":14,"ablock[4]":15,"avec":11,"bblock":19,"bblock[0]":18,"bblock[1]":21,"bblock[2]":23,"bblock[3]":25,"bblock[4]":27,"bvec":8,"c":35,"c[0]":34,"c[1]":36,"c[2]":37,"c[3]":38,"c[4]":39,"cblock":17,"cblock[0]":16,"cblock[1]":20,"cblock[2]":22,"cblock[3]":24,"cblock[4]":26,"fjac":68,"fjac[k]":67,"fjac[k][0]":66,"fjac[k][1]":69,"fjac[k][2]":70,"fjac[k][3]":71,"fjac[k][4]":72,"g_fjac":3,"g_matrix":44,"g_matrix[0]":43,"g_matrix[1]":46,"g_matrix[2]":48,"g_matrix[3]":50,"g_matrix[4]":52,"g_njac":4,"g_qs":0,"g_square":1,"g_u":2,"g_vector":60,"gp0":5,"gp1":6,"gp2":7,"lhs":29,"lhs[0]":28,"lhs[1]":30,"lhs[2]":31,"lhs[3]":32,"lhs[4]":33,"njac":81,"njac[k]":80,"njac[k][0]":79,"njac[k][1]":82,"njac[k][2]":83,"njac[k][3]":84,"njac[k][4]":85,"p_matrix":42,"p_matrix[0]":41,"p_matrix[1]":45,"p_matrix[2]":47,"p_matrix[3]":49,"p_matrix[4]":51,"p_source":54,"p_source[0]":53,"p_source[1]":55,"p_source[2]":56,"p_source[3]":57,"p_source[4]":58,"p_u":65,"p_vector":59,"qs":75,"qs[k]":74,"qs[k][j]":73,"r":40,"square":78,"square[k]":77,"square[k][j]":76,"u":64,"u[k]":63,"u[k][j]":62,"u[k][j][i]":61}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void p_matvec_sub(double ablock[5][5], double avec[5], double bvec[5]) {
  bvec[hook(8, 0)] = bvec[hook(8, 0)] - ablock[hook(10, 0)][hook(9, 0)] * avec[hook(11, 0)] - ablock[hook(10, 1)][hook(12, 0)] * avec[hook(11, 1)] - ablock[hook(10, 2)][hook(13, 0)] * avec[hook(11, 2)] - ablock[hook(10, 3)][hook(14, 0)] * avec[hook(11, 3)] - ablock[hook(10, 4)][hook(15, 0)] * avec[hook(11, 4)];
  bvec[hook(8, 1)] = bvec[hook(8, 1)] - ablock[hook(10, 0)][hook(9, 1)] * avec[hook(11, 0)] - ablock[hook(10, 1)][hook(12, 1)] * avec[hook(11, 1)] - ablock[hook(10, 2)][hook(13, 1)] * avec[hook(11, 2)] - ablock[hook(10, 3)][hook(14, 1)] * avec[hook(11, 3)] - ablock[hook(10, 4)][hook(15, 1)] * avec[hook(11, 4)];
  bvec[hook(8, 2)] = bvec[hook(8, 2)] - ablock[hook(10, 0)][hook(9, 2)] * avec[hook(11, 0)] - ablock[hook(10, 1)][hook(12, 2)] * avec[hook(11, 1)] - ablock[hook(10, 2)][hook(13, 2)] * avec[hook(11, 2)] - ablock[hook(10, 3)][hook(14, 2)] * avec[hook(11, 3)] - ablock[hook(10, 4)][hook(15, 2)] * avec[hook(11, 4)];
  bvec[hook(8, 3)] = bvec[hook(8, 3)] - ablock[hook(10, 0)][hook(9, 3)] * avec[hook(11, 0)] - ablock[hook(10, 1)][hook(12, 3)] * avec[hook(11, 1)] - ablock[hook(10, 2)][hook(13, 3)] * avec[hook(11, 2)] - ablock[hook(10, 3)][hook(14, 3)] * avec[hook(11, 3)] - ablock[hook(10, 4)][hook(15, 3)] * avec[hook(11, 4)];
  bvec[hook(8, 4)] = bvec[hook(8, 4)] - ablock[hook(10, 0)][hook(9, 4)] * avec[hook(11, 0)] - ablock[hook(10, 1)][hook(12, 4)] * avec[hook(11, 1)] - ablock[hook(10, 2)][hook(13, 4)] * avec[hook(11, 2)] - ablock[hook(10, 3)][hook(14, 4)] * avec[hook(11, 3)] - ablock[hook(10, 4)][hook(15, 4)] * avec[hook(11, 4)];
}

void p_matmul_sub(double ablock[5][5], double bblock[5][5], double cblock[5][5]) {
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

void p_binvcrhs(double lhs[5][5], double c[5][5], double r[5]) {
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

void p_binvrhs(double lhs[5][5], double r[5]) {
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

void load_matrix(double p_matrix[5][5], global double g_matrix[5][5]) {
  p_matrix[hook(42, 0)][hook(41, 0)] = g_matrix[hook(44, 0)][hook(43, 0)];
  p_matrix[hook(42, 0)][hook(41, 1)] = g_matrix[hook(44, 0)][hook(43, 1)];
  p_matrix[hook(42, 0)][hook(41, 2)] = g_matrix[hook(44, 0)][hook(43, 2)];
  p_matrix[hook(42, 0)][hook(41, 3)] = g_matrix[hook(44, 0)][hook(43, 3)];
  p_matrix[hook(42, 0)][hook(41, 4)] = g_matrix[hook(44, 0)][hook(43, 4)];
  p_matrix[hook(42, 1)][hook(45, 0)] = g_matrix[hook(44, 1)][hook(46, 0)];
  p_matrix[hook(42, 1)][hook(45, 1)] = g_matrix[hook(44, 1)][hook(46, 1)];
  p_matrix[hook(42, 1)][hook(45, 2)] = g_matrix[hook(44, 1)][hook(46, 2)];
  p_matrix[hook(42, 1)][hook(45, 3)] = g_matrix[hook(44, 1)][hook(46, 3)];
  p_matrix[hook(42, 1)][hook(45, 4)] = g_matrix[hook(44, 1)][hook(46, 4)];
  p_matrix[hook(42, 2)][hook(47, 0)] = g_matrix[hook(44, 2)][hook(48, 0)];
  p_matrix[hook(42, 2)][hook(47, 1)] = g_matrix[hook(44, 2)][hook(48, 1)];
  p_matrix[hook(42, 2)][hook(47, 2)] = g_matrix[hook(44, 2)][hook(48, 2)];
  p_matrix[hook(42, 2)][hook(47, 3)] = g_matrix[hook(44, 2)][hook(48, 3)];
  p_matrix[hook(42, 2)][hook(47, 4)] = g_matrix[hook(44, 2)][hook(48, 4)];
  p_matrix[hook(42, 3)][hook(49, 0)] = g_matrix[hook(44, 3)][hook(50, 0)];
  p_matrix[hook(42, 3)][hook(49, 1)] = g_matrix[hook(44, 3)][hook(50, 1)];
  p_matrix[hook(42, 3)][hook(49, 2)] = g_matrix[hook(44, 3)][hook(50, 2)];
  p_matrix[hook(42, 3)][hook(49, 3)] = g_matrix[hook(44, 3)][hook(50, 3)];
  p_matrix[hook(42, 3)][hook(49, 4)] = g_matrix[hook(44, 3)][hook(50, 4)];
  p_matrix[hook(42, 4)][hook(51, 0)] = g_matrix[hook(44, 4)][hook(52, 0)];
  p_matrix[hook(42, 4)][hook(51, 1)] = g_matrix[hook(44, 4)][hook(52, 1)];
  p_matrix[hook(42, 4)][hook(51, 2)] = g_matrix[hook(44, 4)][hook(52, 2)];
  p_matrix[hook(42, 4)][hook(51, 3)] = g_matrix[hook(44, 4)][hook(52, 3)];
  p_matrix[hook(42, 4)][hook(51, 4)] = g_matrix[hook(44, 4)][hook(52, 4)];
}

void save_matrix(global double g_matrix[5][5], double p_matrix[5][5]) {
  g_matrix[hook(44, 0)][hook(43, 0)] = p_matrix[hook(42, 0)][hook(41, 0)];
  g_matrix[hook(44, 0)][hook(43, 1)] = p_matrix[hook(42, 0)][hook(41, 1)];
  g_matrix[hook(44, 0)][hook(43, 2)] = p_matrix[hook(42, 0)][hook(41, 2)];
  g_matrix[hook(44, 0)][hook(43, 3)] = p_matrix[hook(42, 0)][hook(41, 3)];
  g_matrix[hook(44, 0)][hook(43, 4)] = p_matrix[hook(42, 0)][hook(41, 4)];
  g_matrix[hook(44, 1)][hook(46, 0)] = p_matrix[hook(42, 1)][hook(45, 0)];
  g_matrix[hook(44, 1)][hook(46, 1)] = p_matrix[hook(42, 1)][hook(45, 1)];
  g_matrix[hook(44, 1)][hook(46, 2)] = p_matrix[hook(42, 1)][hook(45, 2)];
  g_matrix[hook(44, 1)][hook(46, 3)] = p_matrix[hook(42, 1)][hook(45, 3)];
  g_matrix[hook(44, 1)][hook(46, 4)] = p_matrix[hook(42, 1)][hook(45, 4)];
  g_matrix[hook(44, 2)][hook(48, 0)] = p_matrix[hook(42, 2)][hook(47, 0)];
  g_matrix[hook(44, 2)][hook(48, 1)] = p_matrix[hook(42, 2)][hook(47, 1)];
  g_matrix[hook(44, 2)][hook(48, 2)] = p_matrix[hook(42, 2)][hook(47, 2)];
  g_matrix[hook(44, 2)][hook(48, 3)] = p_matrix[hook(42, 2)][hook(47, 3)];
  g_matrix[hook(44, 2)][hook(48, 4)] = p_matrix[hook(42, 2)][hook(47, 4)];
  g_matrix[hook(44, 3)][hook(50, 0)] = p_matrix[hook(42, 3)][hook(49, 0)];
  g_matrix[hook(44, 3)][hook(50, 1)] = p_matrix[hook(42, 3)][hook(49, 1)];
  g_matrix[hook(44, 3)][hook(50, 2)] = p_matrix[hook(42, 3)][hook(49, 2)];
  g_matrix[hook(44, 3)][hook(50, 3)] = p_matrix[hook(42, 3)][hook(49, 3)];
  g_matrix[hook(44, 3)][hook(50, 4)] = p_matrix[hook(42, 3)][hook(49, 4)];
  g_matrix[hook(44, 4)][hook(52, 0)] = p_matrix[hook(42, 4)][hook(51, 0)];
  g_matrix[hook(44, 4)][hook(52, 1)] = p_matrix[hook(42, 4)][hook(51, 1)];
  g_matrix[hook(44, 4)][hook(52, 2)] = p_matrix[hook(42, 4)][hook(51, 2)];
  g_matrix[hook(44, 4)][hook(52, 3)] = p_matrix[hook(42, 4)][hook(51, 3)];
  g_matrix[hook(44, 4)][hook(52, 4)] = p_matrix[hook(42, 4)][hook(51, 4)];
}

void copy_matrix(double p_matrix[5][5], double p_source[5][5]) {
  p_matrix[hook(42, 0)][hook(41, 0)] = p_source[hook(54, 0)][hook(53, 0)];
  p_matrix[hook(42, 0)][hook(41, 1)] = p_source[hook(54, 0)][hook(53, 1)];
  p_matrix[hook(42, 0)][hook(41, 2)] = p_source[hook(54, 0)][hook(53, 2)];
  p_matrix[hook(42, 0)][hook(41, 3)] = p_source[hook(54, 0)][hook(53, 3)];
  p_matrix[hook(42, 0)][hook(41, 4)] = p_source[hook(54, 0)][hook(53, 4)];
  p_matrix[hook(42, 1)][hook(45, 0)] = p_source[hook(54, 1)][hook(55, 0)];
  p_matrix[hook(42, 1)][hook(45, 1)] = p_source[hook(54, 1)][hook(55, 1)];
  p_matrix[hook(42, 1)][hook(45, 2)] = p_source[hook(54, 1)][hook(55, 2)];
  p_matrix[hook(42, 1)][hook(45, 3)] = p_source[hook(54, 1)][hook(55, 3)];
  p_matrix[hook(42, 1)][hook(45, 4)] = p_source[hook(54, 1)][hook(55, 4)];
  p_matrix[hook(42, 2)][hook(47, 0)] = p_source[hook(54, 2)][hook(56, 0)];
  p_matrix[hook(42, 2)][hook(47, 1)] = p_source[hook(54, 2)][hook(56, 1)];
  p_matrix[hook(42, 2)][hook(47, 2)] = p_source[hook(54, 2)][hook(56, 2)];
  p_matrix[hook(42, 2)][hook(47, 3)] = p_source[hook(54, 2)][hook(56, 3)];
  p_matrix[hook(42, 2)][hook(47, 4)] = p_source[hook(54, 2)][hook(56, 4)];
  p_matrix[hook(42, 3)][hook(49, 0)] = p_source[hook(54, 3)][hook(57, 0)];
  p_matrix[hook(42, 3)][hook(49, 1)] = p_source[hook(54, 3)][hook(57, 1)];
  p_matrix[hook(42, 3)][hook(49, 2)] = p_source[hook(54, 3)][hook(57, 2)];
  p_matrix[hook(42, 3)][hook(49, 3)] = p_source[hook(54, 3)][hook(57, 3)];
  p_matrix[hook(42, 3)][hook(49, 4)] = p_source[hook(54, 3)][hook(57, 4)];
  p_matrix[hook(42, 4)][hook(51, 0)] = p_source[hook(54, 4)][hook(58, 0)];
  p_matrix[hook(42, 4)][hook(51, 1)] = p_source[hook(54, 4)][hook(58, 1)];
  p_matrix[hook(42, 4)][hook(51, 2)] = p_source[hook(54, 4)][hook(58, 2)];
  p_matrix[hook(42, 4)][hook(51, 3)] = p_source[hook(54, 4)][hook(58, 3)];
  p_matrix[hook(42, 4)][hook(51, 4)] = p_source[hook(54, 4)][hook(58, 4)];
}

void load_vector(double p_vector[5], global double g_vector[5]) {
  p_vector[hook(59, 0)] = g_vector[hook(60, 0)];
  p_vector[hook(59, 1)] = g_vector[hook(60, 1)];
  p_vector[hook(59, 2)] = g_vector[hook(60, 2)];
  p_vector[hook(59, 3)] = g_vector[hook(60, 3)];
  p_vector[hook(59, 4)] = g_vector[hook(60, 4)];
}

void save_vector(global double g_vector[5], double p_vector[5]) {
  g_vector[hook(60, 0)] = p_vector[hook(59, 0)];
  g_vector[hook(60, 1)] = p_vector[hook(59, 1)];
  g_vector[hook(60, 2)] = p_vector[hook(59, 2)];
  g_vector[hook(60, 3)] = p_vector[hook(59, 3)];
  g_vector[hook(60, 4)] = p_vector[hook(59, 4)];
}

void copy_vector(double p_vector[5], double p_source[5]) {
  p_vector[hook(59, 0)] = p_source[hook(54, 0)];
  p_vector[hook(59, 1)] = p_source[hook(54, 1)];
  p_vector[hook(59, 2)] = p_source[hook(54, 2)];
  p_vector[hook(59, 3)] = p_source[hook(54, 3)];
  p_vector[hook(59, 4)] = p_source[hook(54, 4)];
}

kernel void z_solve1(global double* g_qs, global double* g_square, global double* g_u, global double* g_fjac, global double* g_njac, int gp0, int gp1, int gp2) {
  int i, j, k;
  double tmp1, tmp2, tmp3;
  double p_u[5];

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

  tmp1 = 1.0 / u[hook(64, k)][hook(63, j)][hook(62, i)][hook(61, 0)];
  tmp2 = tmp1 * tmp1;
  tmp3 = tmp1 * tmp2;
  p_u[hook(65, 0)] = u[hook(64, k)][hook(63, j)][hook(62, i)][hook(61, 0)];
  p_u[hook(65, 1)] = u[hook(64, k)][hook(63, j)][hook(62, i)][hook(61, 1)];
  p_u[hook(65, 2)] = u[hook(64, k)][hook(63, j)][hook(62, i)][hook(61, 2)];
  p_u[hook(65, 3)] = u[hook(64, k)][hook(63, j)][hook(62, i)][hook(61, 3)];
  p_u[hook(65, 4)] = u[hook(64, k)][hook(63, j)][hook(62, i)][hook(61, 4)];

  fjac[hook(68, k)][hook(67, 0)][hook(66, 0)] = 0.0;
  fjac[hook(68, k)][hook(67, 1)][hook(69, 0)] = 0.0;
  fjac[hook(68, k)][hook(67, 2)][hook(70, 0)] = 0.0;
  fjac[hook(68, k)][hook(67, 3)][hook(71, 0)] = 1.0;
  fjac[hook(68, k)][hook(67, 4)][hook(72, 0)] = 0.0;

  fjac[hook(68, k)][hook(67, 0)][hook(66, 1)] = -(p_u[hook(65, 1)] * p_u[hook(65, 3)]) * tmp2;
  fjac[hook(68, k)][hook(67, 1)][hook(69, 1)] = p_u[hook(65, 3)] * tmp1;
  fjac[hook(68, k)][hook(67, 2)][hook(70, 1)] = 0.0;
  fjac[hook(68, k)][hook(67, 3)][hook(71, 1)] = p_u[hook(65, 1)] * tmp1;
  fjac[hook(68, k)][hook(67, 4)][hook(72, 1)] = 0.0;

  fjac[hook(68, k)][hook(67, 0)][hook(66, 2)] = -(p_u[hook(65, 2)] * p_u[hook(65, 3)]) * tmp2;
  fjac[hook(68, k)][hook(67, 1)][hook(69, 2)] = 0.0;
  fjac[hook(68, k)][hook(67, 2)][hook(70, 2)] = p_u[hook(65, 3)] * tmp1;
  fjac[hook(68, k)][hook(67, 3)][hook(71, 2)] = p_u[hook(65, 2)] * tmp1;
  fjac[hook(68, k)][hook(67, 4)][hook(72, 2)] = 0.0;

  fjac[hook(68, k)][hook(67, 0)][hook(66, 3)] = -(p_u[hook(65, 3)] * p_u[hook(65, 3)] * tmp2) + 0.4 * qs[hook(75, k)][hook(74, j)][hook(73, i)];
  fjac[hook(68, k)][hook(67, 1)][hook(69, 3)] = -0.4 * p_u[hook(65, 1)] * tmp1;
  fjac[hook(68, k)][hook(67, 2)][hook(70, 3)] = -0.4 * p_u[hook(65, 2)] * tmp1;
  fjac[hook(68, k)][hook(67, 3)][hook(71, 3)] = (2.0 - 0.4) * p_u[hook(65, 3)] * tmp1;
  fjac[hook(68, k)][hook(67, 4)][hook(72, 3)] = 0.4;

  fjac[hook(68, k)][hook(67, 0)][hook(66, 4)] = (0.4 * 2.0 * square[hook(78, k)][hook(77, j)][hook(76, i)] - 1.4 * p_u[hook(65, 4)]) * p_u[hook(65, 3)] * tmp2;
  fjac[hook(68, k)][hook(67, 1)][hook(69, 4)] = -0.4 * (p_u[hook(65, 1)] * p_u[hook(65, 3)]) * tmp2;
  fjac[hook(68, k)][hook(67, 2)][hook(70, 4)] = -0.4 * (p_u[hook(65, 2)] * p_u[hook(65, 3)]) * tmp2;
  fjac[hook(68, k)][hook(67, 3)][hook(71, 4)] = 1.4 * (p_u[hook(65, 4)] * tmp1) - 0.4 * (qs[hook(75, k)][hook(74, j)][hook(73, i)] + p_u[hook(65, 3)] * p_u[hook(65, 3)] * tmp2);
  fjac[hook(68, k)][hook(67, 4)][hook(72, 4)] = 1.4 * p_u[hook(65, 3)] * tmp1;

  njac[hook(81, k)][hook(80, 0)][hook(79, 0)] = 0.0;
  njac[hook(81, k)][hook(80, 1)][hook(82, 0)] = 0.0;
  njac[hook(81, k)][hook(80, 2)][hook(83, 0)] = 0.0;
  njac[hook(81, k)][hook(80, 3)][hook(84, 0)] = 0.0;
  njac[hook(81, k)][hook(80, 4)][hook(85, 0)] = 0.0;

  njac[hook(81, k)][hook(80, 0)][hook(79, 1)] = -(0.1 * 1.0) * tmp2 * p_u[hook(65, 1)];
  njac[hook(81, k)][hook(80, 1)][hook(82, 1)] = (0.1 * 1.0) * tmp1;
  njac[hook(81, k)][hook(80, 2)][hook(83, 1)] = 0.0;
  njac[hook(81, k)][hook(80, 3)][hook(84, 1)] = 0.0;
  njac[hook(81, k)][hook(80, 4)][hook(85, 1)] = 0.0;

  njac[hook(81, k)][hook(80, 0)][hook(79, 2)] = -(0.1 * 1.0) * tmp2 * p_u[hook(65, 2)];
  njac[hook(81, k)][hook(80, 1)][hook(82, 2)] = 0.0;
  njac[hook(81, k)][hook(80, 2)][hook(83, 2)] = (0.1 * 1.0) * tmp1;
  njac[hook(81, k)][hook(80, 3)][hook(84, 2)] = 0.0;
  njac[hook(81, k)][hook(80, 4)][hook(85, 2)] = 0.0;

  njac[hook(81, k)][hook(80, 0)][hook(79, 3)] = -(4.0 / 3.0) * (0.1 * 1.0) * tmp2 * p_u[hook(65, 3)];
  njac[hook(81, k)][hook(80, 1)][hook(82, 3)] = 0.0;
  njac[hook(81, k)][hook(80, 2)][hook(83, 3)] = 0.0;
  njac[hook(81, k)][hook(80, 3)][hook(84, 3)] = (4.0 / 3.0) * 0.1 * 1.0 * tmp1;
  njac[hook(81, k)][hook(80, 4)][hook(85, 3)] = 0.0;

  njac[hook(81, k)][hook(80, 0)][hook(79, 4)] = -((0.1 * 1.0) - ((1.4 * 1.4) * (0.1 * 1.0))) * tmp3 * (p_u[hook(65, 1)] * p_u[hook(65, 1)]) - ((0.1 * 1.0) - ((1.4 * 1.4) * (0.1 * 1.0))) * tmp3 * (p_u[hook(65, 2)] * p_u[hook(65, 2)]) - ((4.0 / 3.0) * (0.1 * 1.0) - ((1.4 * 1.4) * (0.1 * 1.0))) * tmp3 * (p_u[hook(65, 3)] * p_u[hook(65, 3)]) - ((1.4 * 1.4) * (0.1 * 1.0)) * tmp2 * p_u[hook(65, 4)];

  njac[hook(81, k)][hook(80, 1)][hook(82, 4)] = ((0.1 * 1.0) - ((1.4 * 1.4) * (0.1 * 1.0))) * tmp2 * p_u[hook(65, 1)];
  njac[hook(81, k)][hook(80, 2)][hook(83, 4)] = ((0.1 * 1.0) - ((1.4 * 1.4) * (0.1 * 1.0))) * tmp2 * p_u[hook(65, 2)];
  njac[hook(81, k)][hook(80, 3)][hook(84, 4)] = ((4.0 / 3.0) * (0.1 * 1.0) - ((1.4 * 1.4) * (0.1 * 1.0))) * tmp2 * p_u[hook(65, 3)];
  njac[hook(81, k)][hook(80, 4)][hook(85, 4)] = (((1.4 * 1.4) * (0.1 * 1.0))) * tmp1;
}