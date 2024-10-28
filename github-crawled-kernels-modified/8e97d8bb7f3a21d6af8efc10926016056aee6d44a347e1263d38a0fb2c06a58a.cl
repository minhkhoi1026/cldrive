//{"ablock":11,"ablock[0]":10,"ablock[1]":13,"ablock[2]":14,"ablock[3]":15,"ablock[4]":16,"avec":12,"bblock":20,"bblock[0]":19,"bblock[1]":22,"bblock[2]":24,"bblock[3]":26,"bblock[4]":28,"bvec":9,"c":36,"c[0]":35,"c[1]":37,"c[2]":38,"c[3]":39,"c[4]":40,"cblock":18,"cblock[0]":17,"cblock[1]":21,"cblock[2]":23,"cblock[3]":25,"cblock[4]":27,"fjac":72,"fjac[j]":71,"fjac[j][0]":70,"fjac[j][1]":73,"fjac[j][2]":74,"fjac[j][3]":75,"fjac[j][4]":76,"g_fjac":4,"g_matrix":45,"g_matrix[0]":44,"g_matrix[1]":47,"g_matrix[2]":49,"g_matrix[3]":51,"g_matrix[4]":53,"g_njac":5,"g_qs":0,"g_rho_i":1,"g_square":2,"g_u":3,"g_vector":61,"gp0":6,"gp1":7,"gp2":8,"lhs":30,"lhs[0]":29,"lhs[1]":31,"lhs[2]":32,"lhs[3]":33,"lhs[4]":34,"njac":85,"njac[j]":84,"njac[j][0]":83,"njac[j][1]":86,"njac[j][2]":87,"njac[j][3]":88,"njac[j][4]":89,"p_matrix":43,"p_matrix[0]":42,"p_matrix[1]":46,"p_matrix[2]":48,"p_matrix[3]":50,"p_matrix[4]":52,"p_source":55,"p_source[0]":54,"p_source[1]":56,"p_source[2]":57,"p_source[3]":58,"p_source[4]":59,"p_u":65,"p_vector":60,"qs":79,"qs[k]":78,"qs[k][j]":77,"r":41,"rho_i":64,"rho_i[k]":63,"rho_i[k][j]":62,"square":82,"square[k]":81,"square[k][j]":80,"u":69,"u[k]":68,"u[k][j]":67,"u[k][j][i]":66}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void p_matvec_sub(double ablock[5][5], double avec[5], double bvec[5]) {
  bvec[hook(9, 0)] = bvec[hook(9, 0)] - ablock[hook(11, 0)][hook(10, 0)] * avec[hook(12, 0)] - ablock[hook(11, 1)][hook(13, 0)] * avec[hook(12, 1)] - ablock[hook(11, 2)][hook(14, 0)] * avec[hook(12, 2)] - ablock[hook(11, 3)][hook(15, 0)] * avec[hook(12, 3)] - ablock[hook(11, 4)][hook(16, 0)] * avec[hook(12, 4)];
  bvec[hook(9, 1)] = bvec[hook(9, 1)] - ablock[hook(11, 0)][hook(10, 1)] * avec[hook(12, 0)] - ablock[hook(11, 1)][hook(13, 1)] * avec[hook(12, 1)] - ablock[hook(11, 2)][hook(14, 1)] * avec[hook(12, 2)] - ablock[hook(11, 3)][hook(15, 1)] * avec[hook(12, 3)] - ablock[hook(11, 4)][hook(16, 1)] * avec[hook(12, 4)];
  bvec[hook(9, 2)] = bvec[hook(9, 2)] - ablock[hook(11, 0)][hook(10, 2)] * avec[hook(12, 0)] - ablock[hook(11, 1)][hook(13, 2)] * avec[hook(12, 1)] - ablock[hook(11, 2)][hook(14, 2)] * avec[hook(12, 2)] - ablock[hook(11, 3)][hook(15, 2)] * avec[hook(12, 3)] - ablock[hook(11, 4)][hook(16, 2)] * avec[hook(12, 4)];
  bvec[hook(9, 3)] = bvec[hook(9, 3)] - ablock[hook(11, 0)][hook(10, 3)] * avec[hook(12, 0)] - ablock[hook(11, 1)][hook(13, 3)] * avec[hook(12, 1)] - ablock[hook(11, 2)][hook(14, 3)] * avec[hook(12, 2)] - ablock[hook(11, 3)][hook(15, 3)] * avec[hook(12, 3)] - ablock[hook(11, 4)][hook(16, 3)] * avec[hook(12, 4)];
  bvec[hook(9, 4)] = bvec[hook(9, 4)] - ablock[hook(11, 0)][hook(10, 4)] * avec[hook(12, 0)] - ablock[hook(11, 1)][hook(13, 4)] * avec[hook(12, 1)] - ablock[hook(11, 2)][hook(14, 4)] * avec[hook(12, 2)] - ablock[hook(11, 3)][hook(15, 4)] * avec[hook(12, 3)] - ablock[hook(11, 4)][hook(16, 4)] * avec[hook(12, 4)];
}

void p_matmul_sub(double ablock[5][5], double bblock[5][5], double cblock[5][5]) {
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

void p_binvcrhs(double lhs[5][5], double c[5][5], double r[5]) {
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

void p_binvrhs(double lhs[5][5], double r[5]) {
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

void load_matrix(double p_matrix[5][5], global double g_matrix[5][5]) {
  p_matrix[hook(43, 0)][hook(42, 0)] = g_matrix[hook(45, 0)][hook(44, 0)];
  p_matrix[hook(43, 0)][hook(42, 1)] = g_matrix[hook(45, 0)][hook(44, 1)];
  p_matrix[hook(43, 0)][hook(42, 2)] = g_matrix[hook(45, 0)][hook(44, 2)];
  p_matrix[hook(43, 0)][hook(42, 3)] = g_matrix[hook(45, 0)][hook(44, 3)];
  p_matrix[hook(43, 0)][hook(42, 4)] = g_matrix[hook(45, 0)][hook(44, 4)];
  p_matrix[hook(43, 1)][hook(46, 0)] = g_matrix[hook(45, 1)][hook(47, 0)];
  p_matrix[hook(43, 1)][hook(46, 1)] = g_matrix[hook(45, 1)][hook(47, 1)];
  p_matrix[hook(43, 1)][hook(46, 2)] = g_matrix[hook(45, 1)][hook(47, 2)];
  p_matrix[hook(43, 1)][hook(46, 3)] = g_matrix[hook(45, 1)][hook(47, 3)];
  p_matrix[hook(43, 1)][hook(46, 4)] = g_matrix[hook(45, 1)][hook(47, 4)];
  p_matrix[hook(43, 2)][hook(48, 0)] = g_matrix[hook(45, 2)][hook(49, 0)];
  p_matrix[hook(43, 2)][hook(48, 1)] = g_matrix[hook(45, 2)][hook(49, 1)];
  p_matrix[hook(43, 2)][hook(48, 2)] = g_matrix[hook(45, 2)][hook(49, 2)];
  p_matrix[hook(43, 2)][hook(48, 3)] = g_matrix[hook(45, 2)][hook(49, 3)];
  p_matrix[hook(43, 2)][hook(48, 4)] = g_matrix[hook(45, 2)][hook(49, 4)];
  p_matrix[hook(43, 3)][hook(50, 0)] = g_matrix[hook(45, 3)][hook(51, 0)];
  p_matrix[hook(43, 3)][hook(50, 1)] = g_matrix[hook(45, 3)][hook(51, 1)];
  p_matrix[hook(43, 3)][hook(50, 2)] = g_matrix[hook(45, 3)][hook(51, 2)];
  p_matrix[hook(43, 3)][hook(50, 3)] = g_matrix[hook(45, 3)][hook(51, 3)];
  p_matrix[hook(43, 3)][hook(50, 4)] = g_matrix[hook(45, 3)][hook(51, 4)];
  p_matrix[hook(43, 4)][hook(52, 0)] = g_matrix[hook(45, 4)][hook(53, 0)];
  p_matrix[hook(43, 4)][hook(52, 1)] = g_matrix[hook(45, 4)][hook(53, 1)];
  p_matrix[hook(43, 4)][hook(52, 2)] = g_matrix[hook(45, 4)][hook(53, 2)];
  p_matrix[hook(43, 4)][hook(52, 3)] = g_matrix[hook(45, 4)][hook(53, 3)];
  p_matrix[hook(43, 4)][hook(52, 4)] = g_matrix[hook(45, 4)][hook(53, 4)];
}

void save_matrix(global double g_matrix[5][5], double p_matrix[5][5]) {
  g_matrix[hook(45, 0)][hook(44, 0)] = p_matrix[hook(43, 0)][hook(42, 0)];
  g_matrix[hook(45, 0)][hook(44, 1)] = p_matrix[hook(43, 0)][hook(42, 1)];
  g_matrix[hook(45, 0)][hook(44, 2)] = p_matrix[hook(43, 0)][hook(42, 2)];
  g_matrix[hook(45, 0)][hook(44, 3)] = p_matrix[hook(43, 0)][hook(42, 3)];
  g_matrix[hook(45, 0)][hook(44, 4)] = p_matrix[hook(43, 0)][hook(42, 4)];
  g_matrix[hook(45, 1)][hook(47, 0)] = p_matrix[hook(43, 1)][hook(46, 0)];
  g_matrix[hook(45, 1)][hook(47, 1)] = p_matrix[hook(43, 1)][hook(46, 1)];
  g_matrix[hook(45, 1)][hook(47, 2)] = p_matrix[hook(43, 1)][hook(46, 2)];
  g_matrix[hook(45, 1)][hook(47, 3)] = p_matrix[hook(43, 1)][hook(46, 3)];
  g_matrix[hook(45, 1)][hook(47, 4)] = p_matrix[hook(43, 1)][hook(46, 4)];
  g_matrix[hook(45, 2)][hook(49, 0)] = p_matrix[hook(43, 2)][hook(48, 0)];
  g_matrix[hook(45, 2)][hook(49, 1)] = p_matrix[hook(43, 2)][hook(48, 1)];
  g_matrix[hook(45, 2)][hook(49, 2)] = p_matrix[hook(43, 2)][hook(48, 2)];
  g_matrix[hook(45, 2)][hook(49, 3)] = p_matrix[hook(43, 2)][hook(48, 3)];
  g_matrix[hook(45, 2)][hook(49, 4)] = p_matrix[hook(43, 2)][hook(48, 4)];
  g_matrix[hook(45, 3)][hook(51, 0)] = p_matrix[hook(43, 3)][hook(50, 0)];
  g_matrix[hook(45, 3)][hook(51, 1)] = p_matrix[hook(43, 3)][hook(50, 1)];
  g_matrix[hook(45, 3)][hook(51, 2)] = p_matrix[hook(43, 3)][hook(50, 2)];
  g_matrix[hook(45, 3)][hook(51, 3)] = p_matrix[hook(43, 3)][hook(50, 3)];
  g_matrix[hook(45, 3)][hook(51, 4)] = p_matrix[hook(43, 3)][hook(50, 4)];
  g_matrix[hook(45, 4)][hook(53, 0)] = p_matrix[hook(43, 4)][hook(52, 0)];
  g_matrix[hook(45, 4)][hook(53, 1)] = p_matrix[hook(43, 4)][hook(52, 1)];
  g_matrix[hook(45, 4)][hook(53, 2)] = p_matrix[hook(43, 4)][hook(52, 2)];
  g_matrix[hook(45, 4)][hook(53, 3)] = p_matrix[hook(43, 4)][hook(52, 3)];
  g_matrix[hook(45, 4)][hook(53, 4)] = p_matrix[hook(43, 4)][hook(52, 4)];
}

void copy_matrix(double p_matrix[5][5], double p_source[5][5]) {
  p_matrix[hook(43, 0)][hook(42, 0)] = p_source[hook(55, 0)][hook(54, 0)];
  p_matrix[hook(43, 0)][hook(42, 1)] = p_source[hook(55, 0)][hook(54, 1)];
  p_matrix[hook(43, 0)][hook(42, 2)] = p_source[hook(55, 0)][hook(54, 2)];
  p_matrix[hook(43, 0)][hook(42, 3)] = p_source[hook(55, 0)][hook(54, 3)];
  p_matrix[hook(43, 0)][hook(42, 4)] = p_source[hook(55, 0)][hook(54, 4)];
  p_matrix[hook(43, 1)][hook(46, 0)] = p_source[hook(55, 1)][hook(56, 0)];
  p_matrix[hook(43, 1)][hook(46, 1)] = p_source[hook(55, 1)][hook(56, 1)];
  p_matrix[hook(43, 1)][hook(46, 2)] = p_source[hook(55, 1)][hook(56, 2)];
  p_matrix[hook(43, 1)][hook(46, 3)] = p_source[hook(55, 1)][hook(56, 3)];
  p_matrix[hook(43, 1)][hook(46, 4)] = p_source[hook(55, 1)][hook(56, 4)];
  p_matrix[hook(43, 2)][hook(48, 0)] = p_source[hook(55, 2)][hook(57, 0)];
  p_matrix[hook(43, 2)][hook(48, 1)] = p_source[hook(55, 2)][hook(57, 1)];
  p_matrix[hook(43, 2)][hook(48, 2)] = p_source[hook(55, 2)][hook(57, 2)];
  p_matrix[hook(43, 2)][hook(48, 3)] = p_source[hook(55, 2)][hook(57, 3)];
  p_matrix[hook(43, 2)][hook(48, 4)] = p_source[hook(55, 2)][hook(57, 4)];
  p_matrix[hook(43, 3)][hook(50, 0)] = p_source[hook(55, 3)][hook(58, 0)];
  p_matrix[hook(43, 3)][hook(50, 1)] = p_source[hook(55, 3)][hook(58, 1)];
  p_matrix[hook(43, 3)][hook(50, 2)] = p_source[hook(55, 3)][hook(58, 2)];
  p_matrix[hook(43, 3)][hook(50, 3)] = p_source[hook(55, 3)][hook(58, 3)];
  p_matrix[hook(43, 3)][hook(50, 4)] = p_source[hook(55, 3)][hook(58, 4)];
  p_matrix[hook(43, 4)][hook(52, 0)] = p_source[hook(55, 4)][hook(59, 0)];
  p_matrix[hook(43, 4)][hook(52, 1)] = p_source[hook(55, 4)][hook(59, 1)];
  p_matrix[hook(43, 4)][hook(52, 2)] = p_source[hook(55, 4)][hook(59, 2)];
  p_matrix[hook(43, 4)][hook(52, 3)] = p_source[hook(55, 4)][hook(59, 3)];
  p_matrix[hook(43, 4)][hook(52, 4)] = p_source[hook(55, 4)][hook(59, 4)];
}

void load_vector(double p_vector[5], global double g_vector[5]) {
  p_vector[hook(60, 0)] = g_vector[hook(61, 0)];
  p_vector[hook(60, 1)] = g_vector[hook(61, 1)];
  p_vector[hook(60, 2)] = g_vector[hook(61, 2)];
  p_vector[hook(60, 3)] = g_vector[hook(61, 3)];
  p_vector[hook(60, 4)] = g_vector[hook(61, 4)];
}

void save_vector(global double g_vector[5], double p_vector[5]) {
  g_vector[hook(61, 0)] = p_vector[hook(60, 0)];
  g_vector[hook(61, 1)] = p_vector[hook(60, 1)];
  g_vector[hook(61, 2)] = p_vector[hook(60, 2)];
  g_vector[hook(61, 3)] = p_vector[hook(60, 3)];
  g_vector[hook(61, 4)] = p_vector[hook(60, 4)];
}

void copy_vector(double p_vector[5], double p_source[5]) {
  p_vector[hook(60, 0)] = p_source[hook(55, 0)];
  p_vector[hook(60, 1)] = p_source[hook(55, 1)];
  p_vector[hook(60, 2)] = p_source[hook(55, 2)];
  p_vector[hook(60, 3)] = p_source[hook(55, 3)];
  p_vector[hook(60, 4)] = p_source[hook(55, 4)];
}

kernel void y_solve1(global double* g_qs, global double* g_rho_i, global double* g_square, global double* g_u, global double* g_fjac, global double* g_njac, int gp0, int gp1, int gp2) {
  int i, j, k;
  double tmp1, tmp2, tmp3;
  double p_u[5];

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

  tmp1 = rho_i[hook(64, k)][hook(63, j)][hook(62, i)];
  tmp2 = tmp1 * tmp1;
  tmp3 = tmp1 * tmp2;
  p_u[hook(65, 0)] = u[hook(69, k)][hook(68, j)][hook(67, i)][hook(66, 0)];
  p_u[hook(65, 1)] = u[hook(69, k)][hook(68, j)][hook(67, i)][hook(66, 1)];
  p_u[hook(65, 2)] = u[hook(69, k)][hook(68, j)][hook(67, i)][hook(66, 2)];
  p_u[hook(65, 3)] = u[hook(69, k)][hook(68, j)][hook(67, i)][hook(66, 3)];
  p_u[hook(65, 4)] = u[hook(69, k)][hook(68, j)][hook(67, i)][hook(66, 4)];

  fjac[hook(72, j)][hook(71, 0)][hook(70, 0)] = 0.0;
  fjac[hook(72, j)][hook(71, 1)][hook(73, 0)] = 0.0;
  fjac[hook(72, j)][hook(71, 2)][hook(74, 0)] = 1.0;
  fjac[hook(72, j)][hook(71, 3)][hook(75, 0)] = 0.0;
  fjac[hook(72, j)][hook(71, 4)][hook(76, 0)] = 0.0;

  fjac[hook(72, j)][hook(71, 0)][hook(70, 1)] = -(p_u[hook(65, 1)] * p_u[hook(65, 2)]) * tmp2;
  fjac[hook(72, j)][hook(71, 1)][hook(73, 1)] = p_u[hook(65, 2)] * tmp1;
  fjac[hook(72, j)][hook(71, 2)][hook(74, 1)] = p_u[hook(65, 1)] * tmp1;
  fjac[hook(72, j)][hook(71, 3)][hook(75, 1)] = 0.0;
  fjac[hook(72, j)][hook(71, 4)][hook(76, 1)] = 0.0;

  fjac[hook(72, j)][hook(71, 0)][hook(70, 2)] = -(p_u[hook(65, 2)] * p_u[hook(65, 2)] * tmp2) + 0.4 * qs[hook(79, k)][hook(78, j)][hook(77, i)];
  fjac[hook(72, j)][hook(71, 1)][hook(73, 2)] = -0.4 * p_u[hook(65, 1)] * tmp1;
  fjac[hook(72, j)][hook(71, 2)][hook(74, 2)] = (2.0 - 0.4) * p_u[hook(65, 2)] * tmp1;
  fjac[hook(72, j)][hook(71, 3)][hook(75, 2)] = -0.4 * p_u[hook(65, 3)] * tmp1;
  fjac[hook(72, j)][hook(71, 4)][hook(76, 2)] = 0.4;

  fjac[hook(72, j)][hook(71, 0)][hook(70, 3)] = -(p_u[hook(65, 2)] * p_u[hook(65, 3)]) * tmp2;
  fjac[hook(72, j)][hook(71, 1)][hook(73, 3)] = 0.0;
  fjac[hook(72, j)][hook(71, 2)][hook(74, 3)] = p_u[hook(65, 3)] * tmp1;
  fjac[hook(72, j)][hook(71, 3)][hook(75, 3)] = p_u[hook(65, 2)] * tmp1;
  fjac[hook(72, j)][hook(71, 4)][hook(76, 3)] = 0.0;

  fjac[hook(72, j)][hook(71, 0)][hook(70, 4)] = (0.4 * 2.0 * square[hook(82, k)][hook(81, j)][hook(80, i)] - 1.4 * p_u[hook(65, 4)]) * p_u[hook(65, 2)] * tmp2;
  fjac[hook(72, j)][hook(71, 1)][hook(73, 4)] = -0.4 * p_u[hook(65, 1)] * p_u[hook(65, 2)] * tmp2;
  fjac[hook(72, j)][hook(71, 2)][hook(74, 4)] = 1.4 * p_u[hook(65, 4)] * tmp1 - 0.4 * (qs[hook(79, k)][hook(78, j)][hook(77, i)] + p_u[hook(65, 2)] * p_u[hook(65, 2)] * tmp2);
  fjac[hook(72, j)][hook(71, 3)][hook(75, 4)] = -0.4 * (p_u[hook(65, 2)] * p_u[hook(65, 3)]) * tmp2;
  fjac[hook(72, j)][hook(71, 4)][hook(76, 4)] = 1.4 * p_u[hook(65, 2)] * tmp1;

  njac[hook(85, j)][hook(84, 0)][hook(83, 0)] = 0.0;
  njac[hook(85, j)][hook(84, 1)][hook(86, 0)] = 0.0;
  njac[hook(85, j)][hook(84, 2)][hook(87, 0)] = 0.0;
  njac[hook(85, j)][hook(84, 3)][hook(88, 0)] = 0.0;
  njac[hook(85, j)][hook(84, 4)][hook(89, 0)] = 0.0;

  njac[hook(85, j)][hook(84, 0)][hook(83, 1)] = -(0.1 * 1.0) * tmp2 * p_u[hook(65, 1)];
  njac[hook(85, j)][hook(84, 1)][hook(86, 1)] = (0.1 * 1.0) * tmp1;
  njac[hook(85, j)][hook(84, 2)][hook(87, 1)] = 0.0;
  njac[hook(85, j)][hook(84, 3)][hook(88, 1)] = 0.0;
  njac[hook(85, j)][hook(84, 4)][hook(89, 1)] = 0.0;

  njac[hook(85, j)][hook(84, 0)][hook(83, 2)] = -(4.0 / 3.0) * (0.1 * 1.0) * tmp2 * p_u[hook(65, 2)];
  njac[hook(85, j)][hook(84, 1)][hook(86, 2)] = 0.0;
  njac[hook(85, j)][hook(84, 2)][hook(87, 2)] = (4.0 / 3.0) * (0.1 * 1.0) * tmp1;
  njac[hook(85, j)][hook(84, 3)][hook(88, 2)] = 0.0;
  njac[hook(85, j)][hook(84, 4)][hook(89, 2)] = 0.0;

  njac[hook(85, j)][hook(84, 0)][hook(83, 3)] = -(0.1 * 1.0) * tmp2 * p_u[hook(65, 3)];
  njac[hook(85, j)][hook(84, 1)][hook(86, 3)] = 0.0;
  njac[hook(85, j)][hook(84, 2)][hook(87, 3)] = 0.0;
  njac[hook(85, j)][hook(84, 3)][hook(88, 3)] = (0.1 * 1.0) * tmp1;
  njac[hook(85, j)][hook(84, 4)][hook(89, 3)] = 0.0;

  njac[hook(85, j)][hook(84, 0)][hook(83, 4)] = -((0.1 * 1.0) - ((1.4 * 1.4) * (0.1 * 1.0))) * tmp3 * (p_u[hook(65, 1)] * p_u[hook(65, 1)]) - ((4.0 / 3.0) * (0.1 * 1.0) - ((1.4 * 1.4) * (0.1 * 1.0))) * tmp3 * (p_u[hook(65, 2)] * p_u[hook(65, 2)]) - ((0.1 * 1.0) - ((1.4 * 1.4) * (0.1 * 1.0))) * tmp3 * (p_u[hook(65, 3)] * p_u[hook(65, 3)]) - ((1.4 * 1.4) * (0.1 * 1.0)) * tmp2 * p_u[hook(65, 4)];

  njac[hook(85, j)][hook(84, 1)][hook(86, 4)] = ((0.1 * 1.0) - ((1.4 * 1.4) * (0.1 * 1.0))) * tmp2 * p_u[hook(65, 1)];
  njac[hook(85, j)][hook(84, 2)][hook(87, 4)] = ((4.0 / 3.0) * (0.1 * 1.0) - ((1.4 * 1.4) * (0.1 * 1.0))) * tmp2 * p_u[hook(65, 2)];
  njac[hook(85, j)][hook(84, 3)][hook(88, 4)] = ((0.1 * 1.0) - ((1.4 * 1.4) * (0.1 * 1.0))) * tmp2 * p_u[hook(65, 3)];
  njac[hook(85, j)][hook(84, 4)][hook(89, 4)] = (((1.4 * 1.4) * (0.1 * 1.0))) * tmp1;
}