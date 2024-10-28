//{"ablock":8,"ablock[0]":7,"ablock[1]":10,"ablock[2]":11,"ablock[3]":12,"ablock[4]":13,"avec":9,"bblock":17,"bblock[0]":16,"bblock[1]":19,"bblock[2]":21,"bblock[3]":23,"bblock[4]":25,"bvec":6,"c":33,"c[0]":32,"c[1]":34,"c[2]":35,"c[3]":36,"c[4]":37,"cblock":15,"cblock[0]":14,"cblock[1]":18,"cblock[2]":20,"cblock[3]":22,"cblock[4]":24,"fjac":44,"fjac[i + 1]":75,"fjac[i + 1][0]":74,"fjac[i + 1][1]":79,"fjac[i + 1][2]":82,"fjac[i + 1][3]":85,"fjac[i + 1][4]":88,"fjac[i - 1]":43,"fjac[i - 1][0]":42,"fjac[i - 1][1]":49,"fjac[i - 1][2]":52,"fjac[i - 1][3]":55,"fjac[i - 1][4]":58,"g_fjac":0,"g_lhs":2,"g_njac":1,"gp0":3,"gp1":4,"gp2":5,"lhs":27,"lhs[0]":26,"lhs[1]":28,"lhs[2]":29,"lhs[3]":30,"lhs[4]":31,"lhs[i]":41,"lhs[i][0]":40,"lhs[i][0][0]":39,"lhs[i][0][1]":48,"lhs[i][0][2]":51,"lhs[i][0][3]":54,"lhs[i][0][4]":57,"lhs[i][1]":61,"lhs[i][1][0]":60,"lhs[i][1][1]":64,"lhs[i][1][2]":66,"lhs[i][1][3]":68,"lhs[i][1][4]":70,"lhs[i][2]":73,"lhs[i][2][0]":72,"lhs[i][2][1]":78,"lhs[i][2][2]":81,"lhs[i][2][3]":84,"lhs[i][2][4]":87,"njac":47,"njac[i + 1]":77,"njac[i + 1][0]":76,"njac[i + 1][1]":80,"njac[i + 1][2]":83,"njac[i + 1][3]":86,"njac[i + 1][4]":89,"njac[i - 1]":46,"njac[i - 1][0]":45,"njac[i - 1][1]":50,"njac[i - 1][2]":53,"njac[i - 1][3]":56,"njac[i - 1][4]":59,"njac[i]":63,"njac[i][0]":62,"njac[i][1]":65,"njac[i][2]":67,"njac[i][3]":69,"njac[i][4]":71,"r":38}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void matvec_sub(global double ablock[5][5], global double avec[5], global double bvec[5]) {
  bvec[hook(6, 0)] = bvec[hook(6, 0)] - ablock[hook(8, 0)][hook(7, 0)] * avec[hook(9, 0)] - ablock[hook(8, 1)][hook(10, 0)] * avec[hook(9, 1)] - ablock[hook(8, 2)][hook(11, 0)] * avec[hook(9, 2)] - ablock[hook(8, 3)][hook(12, 0)] * avec[hook(9, 3)] - ablock[hook(8, 4)][hook(13, 0)] * avec[hook(9, 4)];
  bvec[hook(6, 1)] = bvec[hook(6, 1)] - ablock[hook(8, 0)][hook(7, 1)] * avec[hook(9, 0)] - ablock[hook(8, 1)][hook(10, 1)] * avec[hook(9, 1)] - ablock[hook(8, 2)][hook(11, 1)] * avec[hook(9, 2)] - ablock[hook(8, 3)][hook(12, 1)] * avec[hook(9, 3)] - ablock[hook(8, 4)][hook(13, 1)] * avec[hook(9, 4)];
  bvec[hook(6, 2)] = bvec[hook(6, 2)] - ablock[hook(8, 0)][hook(7, 2)] * avec[hook(9, 0)] - ablock[hook(8, 1)][hook(10, 2)] * avec[hook(9, 1)] - ablock[hook(8, 2)][hook(11, 2)] * avec[hook(9, 2)] - ablock[hook(8, 3)][hook(12, 2)] * avec[hook(9, 3)] - ablock[hook(8, 4)][hook(13, 2)] * avec[hook(9, 4)];
  bvec[hook(6, 3)] = bvec[hook(6, 3)] - ablock[hook(8, 0)][hook(7, 3)] * avec[hook(9, 0)] - ablock[hook(8, 1)][hook(10, 3)] * avec[hook(9, 1)] - ablock[hook(8, 2)][hook(11, 3)] * avec[hook(9, 2)] - ablock[hook(8, 3)][hook(12, 3)] * avec[hook(9, 3)] - ablock[hook(8, 4)][hook(13, 3)] * avec[hook(9, 4)];
  bvec[hook(6, 4)] = bvec[hook(6, 4)] - ablock[hook(8, 0)][hook(7, 4)] * avec[hook(9, 0)] - ablock[hook(8, 1)][hook(10, 4)] * avec[hook(9, 1)] - ablock[hook(8, 2)][hook(11, 4)] * avec[hook(9, 2)] - ablock[hook(8, 3)][hook(12, 4)] * avec[hook(9, 3)] - ablock[hook(8, 4)][hook(13, 4)] * avec[hook(9, 4)];
}

void matmul_sub(global double ablock[5][5], global double bblock[5][5], global double cblock[5][5]) {
  cblock[hook(15, 0)][hook(14, 0)] = cblock[hook(15, 0)][hook(14, 0)] - ablock[hook(8, 0)][hook(7, 0)] * bblock[hook(17, 0)][hook(16, 0)] - ablock[hook(8, 1)][hook(10, 0)] * bblock[hook(17, 0)][hook(16, 1)] - ablock[hook(8, 2)][hook(11, 0)] * bblock[hook(17, 0)][hook(16, 2)] - ablock[hook(8, 3)][hook(12, 0)] * bblock[hook(17, 0)][hook(16, 3)] - ablock[hook(8, 4)][hook(13, 0)] * bblock[hook(17, 0)][hook(16, 4)];
  cblock[hook(15, 0)][hook(14, 1)] = cblock[hook(15, 0)][hook(14, 1)] - ablock[hook(8, 0)][hook(7, 1)] * bblock[hook(17, 0)][hook(16, 0)] - ablock[hook(8, 1)][hook(10, 1)] * bblock[hook(17, 0)][hook(16, 1)] - ablock[hook(8, 2)][hook(11, 1)] * bblock[hook(17, 0)][hook(16, 2)] - ablock[hook(8, 3)][hook(12, 1)] * bblock[hook(17, 0)][hook(16, 3)] - ablock[hook(8, 4)][hook(13, 1)] * bblock[hook(17, 0)][hook(16, 4)];
  cblock[hook(15, 0)][hook(14, 2)] = cblock[hook(15, 0)][hook(14, 2)] - ablock[hook(8, 0)][hook(7, 2)] * bblock[hook(17, 0)][hook(16, 0)] - ablock[hook(8, 1)][hook(10, 2)] * bblock[hook(17, 0)][hook(16, 1)] - ablock[hook(8, 2)][hook(11, 2)] * bblock[hook(17, 0)][hook(16, 2)] - ablock[hook(8, 3)][hook(12, 2)] * bblock[hook(17, 0)][hook(16, 3)] - ablock[hook(8, 4)][hook(13, 2)] * bblock[hook(17, 0)][hook(16, 4)];
  cblock[hook(15, 0)][hook(14, 3)] = cblock[hook(15, 0)][hook(14, 3)] - ablock[hook(8, 0)][hook(7, 3)] * bblock[hook(17, 0)][hook(16, 0)] - ablock[hook(8, 1)][hook(10, 3)] * bblock[hook(17, 0)][hook(16, 1)] - ablock[hook(8, 2)][hook(11, 3)] * bblock[hook(17, 0)][hook(16, 2)] - ablock[hook(8, 3)][hook(12, 3)] * bblock[hook(17, 0)][hook(16, 3)] - ablock[hook(8, 4)][hook(13, 3)] * bblock[hook(17, 0)][hook(16, 4)];
  cblock[hook(15, 0)][hook(14, 4)] = cblock[hook(15, 0)][hook(14, 4)] - ablock[hook(8, 0)][hook(7, 4)] * bblock[hook(17, 0)][hook(16, 0)] - ablock[hook(8, 1)][hook(10, 4)] * bblock[hook(17, 0)][hook(16, 1)] - ablock[hook(8, 2)][hook(11, 4)] * bblock[hook(17, 0)][hook(16, 2)] - ablock[hook(8, 3)][hook(12, 4)] * bblock[hook(17, 0)][hook(16, 3)] - ablock[hook(8, 4)][hook(13, 4)] * bblock[hook(17, 0)][hook(16, 4)];
  cblock[hook(15, 1)][hook(18, 0)] = cblock[hook(15, 1)][hook(18, 0)] - ablock[hook(8, 0)][hook(7, 0)] * bblock[hook(17, 1)][hook(19, 0)] - ablock[hook(8, 1)][hook(10, 0)] * bblock[hook(17, 1)][hook(19, 1)] - ablock[hook(8, 2)][hook(11, 0)] * bblock[hook(17, 1)][hook(19, 2)] - ablock[hook(8, 3)][hook(12, 0)] * bblock[hook(17, 1)][hook(19, 3)] - ablock[hook(8, 4)][hook(13, 0)] * bblock[hook(17, 1)][hook(19, 4)];
  cblock[hook(15, 1)][hook(18, 1)] = cblock[hook(15, 1)][hook(18, 1)] - ablock[hook(8, 0)][hook(7, 1)] * bblock[hook(17, 1)][hook(19, 0)] - ablock[hook(8, 1)][hook(10, 1)] * bblock[hook(17, 1)][hook(19, 1)] - ablock[hook(8, 2)][hook(11, 1)] * bblock[hook(17, 1)][hook(19, 2)] - ablock[hook(8, 3)][hook(12, 1)] * bblock[hook(17, 1)][hook(19, 3)] - ablock[hook(8, 4)][hook(13, 1)] * bblock[hook(17, 1)][hook(19, 4)];
  cblock[hook(15, 1)][hook(18, 2)] = cblock[hook(15, 1)][hook(18, 2)] - ablock[hook(8, 0)][hook(7, 2)] * bblock[hook(17, 1)][hook(19, 0)] - ablock[hook(8, 1)][hook(10, 2)] * bblock[hook(17, 1)][hook(19, 1)] - ablock[hook(8, 2)][hook(11, 2)] * bblock[hook(17, 1)][hook(19, 2)] - ablock[hook(8, 3)][hook(12, 2)] * bblock[hook(17, 1)][hook(19, 3)] - ablock[hook(8, 4)][hook(13, 2)] * bblock[hook(17, 1)][hook(19, 4)];
  cblock[hook(15, 1)][hook(18, 3)] = cblock[hook(15, 1)][hook(18, 3)] - ablock[hook(8, 0)][hook(7, 3)] * bblock[hook(17, 1)][hook(19, 0)] - ablock[hook(8, 1)][hook(10, 3)] * bblock[hook(17, 1)][hook(19, 1)] - ablock[hook(8, 2)][hook(11, 3)] * bblock[hook(17, 1)][hook(19, 2)] - ablock[hook(8, 3)][hook(12, 3)] * bblock[hook(17, 1)][hook(19, 3)] - ablock[hook(8, 4)][hook(13, 3)] * bblock[hook(17, 1)][hook(19, 4)];
  cblock[hook(15, 1)][hook(18, 4)] = cblock[hook(15, 1)][hook(18, 4)] - ablock[hook(8, 0)][hook(7, 4)] * bblock[hook(17, 1)][hook(19, 0)] - ablock[hook(8, 1)][hook(10, 4)] * bblock[hook(17, 1)][hook(19, 1)] - ablock[hook(8, 2)][hook(11, 4)] * bblock[hook(17, 1)][hook(19, 2)] - ablock[hook(8, 3)][hook(12, 4)] * bblock[hook(17, 1)][hook(19, 3)] - ablock[hook(8, 4)][hook(13, 4)] * bblock[hook(17, 1)][hook(19, 4)];
  cblock[hook(15, 2)][hook(20, 0)] = cblock[hook(15, 2)][hook(20, 0)] - ablock[hook(8, 0)][hook(7, 0)] * bblock[hook(17, 2)][hook(21, 0)] - ablock[hook(8, 1)][hook(10, 0)] * bblock[hook(17, 2)][hook(21, 1)] - ablock[hook(8, 2)][hook(11, 0)] * bblock[hook(17, 2)][hook(21, 2)] - ablock[hook(8, 3)][hook(12, 0)] * bblock[hook(17, 2)][hook(21, 3)] - ablock[hook(8, 4)][hook(13, 0)] * bblock[hook(17, 2)][hook(21, 4)];
  cblock[hook(15, 2)][hook(20, 1)] = cblock[hook(15, 2)][hook(20, 1)] - ablock[hook(8, 0)][hook(7, 1)] * bblock[hook(17, 2)][hook(21, 0)] - ablock[hook(8, 1)][hook(10, 1)] * bblock[hook(17, 2)][hook(21, 1)] - ablock[hook(8, 2)][hook(11, 1)] * bblock[hook(17, 2)][hook(21, 2)] - ablock[hook(8, 3)][hook(12, 1)] * bblock[hook(17, 2)][hook(21, 3)] - ablock[hook(8, 4)][hook(13, 1)] * bblock[hook(17, 2)][hook(21, 4)];
  cblock[hook(15, 2)][hook(20, 2)] = cblock[hook(15, 2)][hook(20, 2)] - ablock[hook(8, 0)][hook(7, 2)] * bblock[hook(17, 2)][hook(21, 0)] - ablock[hook(8, 1)][hook(10, 2)] * bblock[hook(17, 2)][hook(21, 1)] - ablock[hook(8, 2)][hook(11, 2)] * bblock[hook(17, 2)][hook(21, 2)] - ablock[hook(8, 3)][hook(12, 2)] * bblock[hook(17, 2)][hook(21, 3)] - ablock[hook(8, 4)][hook(13, 2)] * bblock[hook(17, 2)][hook(21, 4)];
  cblock[hook(15, 2)][hook(20, 3)] = cblock[hook(15, 2)][hook(20, 3)] - ablock[hook(8, 0)][hook(7, 3)] * bblock[hook(17, 2)][hook(21, 0)] - ablock[hook(8, 1)][hook(10, 3)] * bblock[hook(17, 2)][hook(21, 1)] - ablock[hook(8, 2)][hook(11, 3)] * bblock[hook(17, 2)][hook(21, 2)] - ablock[hook(8, 3)][hook(12, 3)] * bblock[hook(17, 2)][hook(21, 3)] - ablock[hook(8, 4)][hook(13, 3)] * bblock[hook(17, 2)][hook(21, 4)];
  cblock[hook(15, 2)][hook(20, 4)] = cblock[hook(15, 2)][hook(20, 4)] - ablock[hook(8, 0)][hook(7, 4)] * bblock[hook(17, 2)][hook(21, 0)] - ablock[hook(8, 1)][hook(10, 4)] * bblock[hook(17, 2)][hook(21, 1)] - ablock[hook(8, 2)][hook(11, 4)] * bblock[hook(17, 2)][hook(21, 2)] - ablock[hook(8, 3)][hook(12, 4)] * bblock[hook(17, 2)][hook(21, 3)] - ablock[hook(8, 4)][hook(13, 4)] * bblock[hook(17, 2)][hook(21, 4)];
  cblock[hook(15, 3)][hook(22, 0)] = cblock[hook(15, 3)][hook(22, 0)] - ablock[hook(8, 0)][hook(7, 0)] * bblock[hook(17, 3)][hook(23, 0)] - ablock[hook(8, 1)][hook(10, 0)] * bblock[hook(17, 3)][hook(23, 1)] - ablock[hook(8, 2)][hook(11, 0)] * bblock[hook(17, 3)][hook(23, 2)] - ablock[hook(8, 3)][hook(12, 0)] * bblock[hook(17, 3)][hook(23, 3)] - ablock[hook(8, 4)][hook(13, 0)] * bblock[hook(17, 3)][hook(23, 4)];
  cblock[hook(15, 3)][hook(22, 1)] = cblock[hook(15, 3)][hook(22, 1)] - ablock[hook(8, 0)][hook(7, 1)] * bblock[hook(17, 3)][hook(23, 0)] - ablock[hook(8, 1)][hook(10, 1)] * bblock[hook(17, 3)][hook(23, 1)] - ablock[hook(8, 2)][hook(11, 1)] * bblock[hook(17, 3)][hook(23, 2)] - ablock[hook(8, 3)][hook(12, 1)] * bblock[hook(17, 3)][hook(23, 3)] - ablock[hook(8, 4)][hook(13, 1)] * bblock[hook(17, 3)][hook(23, 4)];
  cblock[hook(15, 3)][hook(22, 2)] = cblock[hook(15, 3)][hook(22, 2)] - ablock[hook(8, 0)][hook(7, 2)] * bblock[hook(17, 3)][hook(23, 0)] - ablock[hook(8, 1)][hook(10, 2)] * bblock[hook(17, 3)][hook(23, 1)] - ablock[hook(8, 2)][hook(11, 2)] * bblock[hook(17, 3)][hook(23, 2)] - ablock[hook(8, 3)][hook(12, 2)] * bblock[hook(17, 3)][hook(23, 3)] - ablock[hook(8, 4)][hook(13, 2)] * bblock[hook(17, 3)][hook(23, 4)];
  cblock[hook(15, 3)][hook(22, 3)] = cblock[hook(15, 3)][hook(22, 3)] - ablock[hook(8, 0)][hook(7, 3)] * bblock[hook(17, 3)][hook(23, 0)] - ablock[hook(8, 1)][hook(10, 3)] * bblock[hook(17, 3)][hook(23, 1)] - ablock[hook(8, 2)][hook(11, 3)] * bblock[hook(17, 3)][hook(23, 2)] - ablock[hook(8, 3)][hook(12, 3)] * bblock[hook(17, 3)][hook(23, 3)] - ablock[hook(8, 4)][hook(13, 3)] * bblock[hook(17, 3)][hook(23, 4)];
  cblock[hook(15, 3)][hook(22, 4)] = cblock[hook(15, 3)][hook(22, 4)] - ablock[hook(8, 0)][hook(7, 4)] * bblock[hook(17, 3)][hook(23, 0)] - ablock[hook(8, 1)][hook(10, 4)] * bblock[hook(17, 3)][hook(23, 1)] - ablock[hook(8, 2)][hook(11, 4)] * bblock[hook(17, 3)][hook(23, 2)] - ablock[hook(8, 3)][hook(12, 4)] * bblock[hook(17, 3)][hook(23, 3)] - ablock[hook(8, 4)][hook(13, 4)] * bblock[hook(17, 3)][hook(23, 4)];
  cblock[hook(15, 4)][hook(24, 0)] = cblock[hook(15, 4)][hook(24, 0)] - ablock[hook(8, 0)][hook(7, 0)] * bblock[hook(17, 4)][hook(25, 0)] - ablock[hook(8, 1)][hook(10, 0)] * bblock[hook(17, 4)][hook(25, 1)] - ablock[hook(8, 2)][hook(11, 0)] * bblock[hook(17, 4)][hook(25, 2)] - ablock[hook(8, 3)][hook(12, 0)] * bblock[hook(17, 4)][hook(25, 3)] - ablock[hook(8, 4)][hook(13, 0)] * bblock[hook(17, 4)][hook(25, 4)];
  cblock[hook(15, 4)][hook(24, 1)] = cblock[hook(15, 4)][hook(24, 1)] - ablock[hook(8, 0)][hook(7, 1)] * bblock[hook(17, 4)][hook(25, 0)] - ablock[hook(8, 1)][hook(10, 1)] * bblock[hook(17, 4)][hook(25, 1)] - ablock[hook(8, 2)][hook(11, 1)] * bblock[hook(17, 4)][hook(25, 2)] - ablock[hook(8, 3)][hook(12, 1)] * bblock[hook(17, 4)][hook(25, 3)] - ablock[hook(8, 4)][hook(13, 1)] * bblock[hook(17, 4)][hook(25, 4)];
  cblock[hook(15, 4)][hook(24, 2)] = cblock[hook(15, 4)][hook(24, 2)] - ablock[hook(8, 0)][hook(7, 2)] * bblock[hook(17, 4)][hook(25, 0)] - ablock[hook(8, 1)][hook(10, 2)] * bblock[hook(17, 4)][hook(25, 1)] - ablock[hook(8, 2)][hook(11, 2)] * bblock[hook(17, 4)][hook(25, 2)] - ablock[hook(8, 3)][hook(12, 2)] * bblock[hook(17, 4)][hook(25, 3)] - ablock[hook(8, 4)][hook(13, 2)] * bblock[hook(17, 4)][hook(25, 4)];
  cblock[hook(15, 4)][hook(24, 3)] = cblock[hook(15, 4)][hook(24, 3)] - ablock[hook(8, 0)][hook(7, 3)] * bblock[hook(17, 4)][hook(25, 0)] - ablock[hook(8, 1)][hook(10, 3)] * bblock[hook(17, 4)][hook(25, 1)] - ablock[hook(8, 2)][hook(11, 3)] * bblock[hook(17, 4)][hook(25, 2)] - ablock[hook(8, 3)][hook(12, 3)] * bblock[hook(17, 4)][hook(25, 3)] - ablock[hook(8, 4)][hook(13, 3)] * bblock[hook(17, 4)][hook(25, 4)];
  cblock[hook(15, 4)][hook(24, 4)] = cblock[hook(15, 4)][hook(24, 4)] - ablock[hook(8, 0)][hook(7, 4)] * bblock[hook(17, 4)][hook(25, 0)] - ablock[hook(8, 1)][hook(10, 4)] * bblock[hook(17, 4)][hook(25, 1)] - ablock[hook(8, 2)][hook(11, 4)] * bblock[hook(17, 4)][hook(25, 2)] - ablock[hook(8, 3)][hook(12, 4)] * bblock[hook(17, 4)][hook(25, 3)] - ablock[hook(8, 4)][hook(13, 4)] * bblock[hook(17, 4)][hook(25, 4)];
}

void binvcrhs(global double lhs[5][5], global double c[5][5], global double r[5]) {
  double pivot, coeff;

  pivot = 1.00 / lhs[hook(27, 0)][hook(26, 0)];
  lhs[hook(27, 1)][hook(28, 0)] = lhs[hook(27, 1)][hook(28, 0)] * pivot;
  lhs[hook(27, 2)][hook(29, 0)] = lhs[hook(27, 2)][hook(29, 0)] * pivot;
  lhs[hook(27, 3)][hook(30, 0)] = lhs[hook(27, 3)][hook(30, 0)] * pivot;
  lhs[hook(27, 4)][hook(31, 0)] = lhs[hook(27, 4)][hook(31, 0)] * pivot;
  c[hook(33, 0)][hook(32, 0)] = c[hook(33, 0)][hook(32, 0)] * pivot;
  c[hook(33, 1)][hook(34, 0)] = c[hook(33, 1)][hook(34, 0)] * pivot;
  c[hook(33, 2)][hook(35, 0)] = c[hook(33, 2)][hook(35, 0)] * pivot;
  c[hook(33, 3)][hook(36, 0)] = c[hook(33, 3)][hook(36, 0)] * pivot;
  c[hook(33, 4)][hook(37, 0)] = c[hook(33, 4)][hook(37, 0)] * pivot;
  r[hook(38, 0)] = r[hook(38, 0)] * pivot;

  coeff = lhs[hook(27, 0)][hook(26, 1)];
  lhs[hook(27, 1)][hook(28, 1)] = lhs[hook(27, 1)][hook(28, 1)] - coeff * lhs[hook(27, 1)][hook(28, 0)];
  lhs[hook(27, 2)][hook(29, 1)] = lhs[hook(27, 2)][hook(29, 1)] - coeff * lhs[hook(27, 2)][hook(29, 0)];
  lhs[hook(27, 3)][hook(30, 1)] = lhs[hook(27, 3)][hook(30, 1)] - coeff * lhs[hook(27, 3)][hook(30, 0)];
  lhs[hook(27, 4)][hook(31, 1)] = lhs[hook(27, 4)][hook(31, 1)] - coeff * lhs[hook(27, 4)][hook(31, 0)];
  c[hook(33, 0)][hook(32, 1)] = c[hook(33, 0)][hook(32, 1)] - coeff * c[hook(33, 0)][hook(32, 0)];
  c[hook(33, 1)][hook(34, 1)] = c[hook(33, 1)][hook(34, 1)] - coeff * c[hook(33, 1)][hook(34, 0)];
  c[hook(33, 2)][hook(35, 1)] = c[hook(33, 2)][hook(35, 1)] - coeff * c[hook(33, 2)][hook(35, 0)];
  c[hook(33, 3)][hook(36, 1)] = c[hook(33, 3)][hook(36, 1)] - coeff * c[hook(33, 3)][hook(36, 0)];
  c[hook(33, 4)][hook(37, 1)] = c[hook(33, 4)][hook(37, 1)] - coeff * c[hook(33, 4)][hook(37, 0)];
  r[hook(38, 1)] = r[hook(38, 1)] - coeff * r[hook(38, 0)];

  coeff = lhs[hook(27, 0)][hook(26, 2)];
  lhs[hook(27, 1)][hook(28, 2)] = lhs[hook(27, 1)][hook(28, 2)] - coeff * lhs[hook(27, 1)][hook(28, 0)];
  lhs[hook(27, 2)][hook(29, 2)] = lhs[hook(27, 2)][hook(29, 2)] - coeff * lhs[hook(27, 2)][hook(29, 0)];
  lhs[hook(27, 3)][hook(30, 2)] = lhs[hook(27, 3)][hook(30, 2)] - coeff * lhs[hook(27, 3)][hook(30, 0)];
  lhs[hook(27, 4)][hook(31, 2)] = lhs[hook(27, 4)][hook(31, 2)] - coeff * lhs[hook(27, 4)][hook(31, 0)];
  c[hook(33, 0)][hook(32, 2)] = c[hook(33, 0)][hook(32, 2)] - coeff * c[hook(33, 0)][hook(32, 0)];
  c[hook(33, 1)][hook(34, 2)] = c[hook(33, 1)][hook(34, 2)] - coeff * c[hook(33, 1)][hook(34, 0)];
  c[hook(33, 2)][hook(35, 2)] = c[hook(33, 2)][hook(35, 2)] - coeff * c[hook(33, 2)][hook(35, 0)];
  c[hook(33, 3)][hook(36, 2)] = c[hook(33, 3)][hook(36, 2)] - coeff * c[hook(33, 3)][hook(36, 0)];
  c[hook(33, 4)][hook(37, 2)] = c[hook(33, 4)][hook(37, 2)] - coeff * c[hook(33, 4)][hook(37, 0)];
  r[hook(38, 2)] = r[hook(38, 2)] - coeff * r[hook(38, 0)];

  coeff = lhs[hook(27, 0)][hook(26, 3)];
  lhs[hook(27, 1)][hook(28, 3)] = lhs[hook(27, 1)][hook(28, 3)] - coeff * lhs[hook(27, 1)][hook(28, 0)];
  lhs[hook(27, 2)][hook(29, 3)] = lhs[hook(27, 2)][hook(29, 3)] - coeff * lhs[hook(27, 2)][hook(29, 0)];
  lhs[hook(27, 3)][hook(30, 3)] = lhs[hook(27, 3)][hook(30, 3)] - coeff * lhs[hook(27, 3)][hook(30, 0)];
  lhs[hook(27, 4)][hook(31, 3)] = lhs[hook(27, 4)][hook(31, 3)] - coeff * lhs[hook(27, 4)][hook(31, 0)];
  c[hook(33, 0)][hook(32, 3)] = c[hook(33, 0)][hook(32, 3)] - coeff * c[hook(33, 0)][hook(32, 0)];
  c[hook(33, 1)][hook(34, 3)] = c[hook(33, 1)][hook(34, 3)] - coeff * c[hook(33, 1)][hook(34, 0)];
  c[hook(33, 2)][hook(35, 3)] = c[hook(33, 2)][hook(35, 3)] - coeff * c[hook(33, 2)][hook(35, 0)];
  c[hook(33, 3)][hook(36, 3)] = c[hook(33, 3)][hook(36, 3)] - coeff * c[hook(33, 3)][hook(36, 0)];
  c[hook(33, 4)][hook(37, 3)] = c[hook(33, 4)][hook(37, 3)] - coeff * c[hook(33, 4)][hook(37, 0)];
  r[hook(38, 3)] = r[hook(38, 3)] - coeff * r[hook(38, 0)];

  coeff = lhs[hook(27, 0)][hook(26, 4)];
  lhs[hook(27, 1)][hook(28, 4)] = lhs[hook(27, 1)][hook(28, 4)] - coeff * lhs[hook(27, 1)][hook(28, 0)];
  lhs[hook(27, 2)][hook(29, 4)] = lhs[hook(27, 2)][hook(29, 4)] - coeff * lhs[hook(27, 2)][hook(29, 0)];
  lhs[hook(27, 3)][hook(30, 4)] = lhs[hook(27, 3)][hook(30, 4)] - coeff * lhs[hook(27, 3)][hook(30, 0)];
  lhs[hook(27, 4)][hook(31, 4)] = lhs[hook(27, 4)][hook(31, 4)] - coeff * lhs[hook(27, 4)][hook(31, 0)];
  c[hook(33, 0)][hook(32, 4)] = c[hook(33, 0)][hook(32, 4)] - coeff * c[hook(33, 0)][hook(32, 0)];
  c[hook(33, 1)][hook(34, 4)] = c[hook(33, 1)][hook(34, 4)] - coeff * c[hook(33, 1)][hook(34, 0)];
  c[hook(33, 2)][hook(35, 4)] = c[hook(33, 2)][hook(35, 4)] - coeff * c[hook(33, 2)][hook(35, 0)];
  c[hook(33, 3)][hook(36, 4)] = c[hook(33, 3)][hook(36, 4)] - coeff * c[hook(33, 3)][hook(36, 0)];
  c[hook(33, 4)][hook(37, 4)] = c[hook(33, 4)][hook(37, 4)] - coeff * c[hook(33, 4)][hook(37, 0)];
  r[hook(38, 4)] = r[hook(38, 4)] - coeff * r[hook(38, 0)];

  pivot = 1.00 / lhs[hook(27, 1)][hook(28, 1)];
  lhs[hook(27, 2)][hook(29, 1)] = lhs[hook(27, 2)][hook(29, 1)] * pivot;
  lhs[hook(27, 3)][hook(30, 1)] = lhs[hook(27, 3)][hook(30, 1)] * pivot;
  lhs[hook(27, 4)][hook(31, 1)] = lhs[hook(27, 4)][hook(31, 1)] * pivot;
  c[hook(33, 0)][hook(32, 1)] = c[hook(33, 0)][hook(32, 1)] * pivot;
  c[hook(33, 1)][hook(34, 1)] = c[hook(33, 1)][hook(34, 1)] * pivot;
  c[hook(33, 2)][hook(35, 1)] = c[hook(33, 2)][hook(35, 1)] * pivot;
  c[hook(33, 3)][hook(36, 1)] = c[hook(33, 3)][hook(36, 1)] * pivot;
  c[hook(33, 4)][hook(37, 1)] = c[hook(33, 4)][hook(37, 1)] * pivot;
  r[hook(38, 1)] = r[hook(38, 1)] * pivot;

  coeff = lhs[hook(27, 1)][hook(28, 0)];
  lhs[hook(27, 2)][hook(29, 0)] = lhs[hook(27, 2)][hook(29, 0)] - coeff * lhs[hook(27, 2)][hook(29, 1)];
  lhs[hook(27, 3)][hook(30, 0)] = lhs[hook(27, 3)][hook(30, 0)] - coeff * lhs[hook(27, 3)][hook(30, 1)];
  lhs[hook(27, 4)][hook(31, 0)] = lhs[hook(27, 4)][hook(31, 0)] - coeff * lhs[hook(27, 4)][hook(31, 1)];
  c[hook(33, 0)][hook(32, 0)] = c[hook(33, 0)][hook(32, 0)] - coeff * c[hook(33, 0)][hook(32, 1)];
  c[hook(33, 1)][hook(34, 0)] = c[hook(33, 1)][hook(34, 0)] - coeff * c[hook(33, 1)][hook(34, 1)];
  c[hook(33, 2)][hook(35, 0)] = c[hook(33, 2)][hook(35, 0)] - coeff * c[hook(33, 2)][hook(35, 1)];
  c[hook(33, 3)][hook(36, 0)] = c[hook(33, 3)][hook(36, 0)] - coeff * c[hook(33, 3)][hook(36, 1)];
  c[hook(33, 4)][hook(37, 0)] = c[hook(33, 4)][hook(37, 0)] - coeff * c[hook(33, 4)][hook(37, 1)];
  r[hook(38, 0)] = r[hook(38, 0)] - coeff * r[hook(38, 1)];

  coeff = lhs[hook(27, 1)][hook(28, 2)];
  lhs[hook(27, 2)][hook(29, 2)] = lhs[hook(27, 2)][hook(29, 2)] - coeff * lhs[hook(27, 2)][hook(29, 1)];
  lhs[hook(27, 3)][hook(30, 2)] = lhs[hook(27, 3)][hook(30, 2)] - coeff * lhs[hook(27, 3)][hook(30, 1)];
  lhs[hook(27, 4)][hook(31, 2)] = lhs[hook(27, 4)][hook(31, 2)] - coeff * lhs[hook(27, 4)][hook(31, 1)];
  c[hook(33, 0)][hook(32, 2)] = c[hook(33, 0)][hook(32, 2)] - coeff * c[hook(33, 0)][hook(32, 1)];
  c[hook(33, 1)][hook(34, 2)] = c[hook(33, 1)][hook(34, 2)] - coeff * c[hook(33, 1)][hook(34, 1)];
  c[hook(33, 2)][hook(35, 2)] = c[hook(33, 2)][hook(35, 2)] - coeff * c[hook(33, 2)][hook(35, 1)];
  c[hook(33, 3)][hook(36, 2)] = c[hook(33, 3)][hook(36, 2)] - coeff * c[hook(33, 3)][hook(36, 1)];
  c[hook(33, 4)][hook(37, 2)] = c[hook(33, 4)][hook(37, 2)] - coeff * c[hook(33, 4)][hook(37, 1)];
  r[hook(38, 2)] = r[hook(38, 2)] - coeff * r[hook(38, 1)];

  coeff = lhs[hook(27, 1)][hook(28, 3)];
  lhs[hook(27, 2)][hook(29, 3)] = lhs[hook(27, 2)][hook(29, 3)] - coeff * lhs[hook(27, 2)][hook(29, 1)];
  lhs[hook(27, 3)][hook(30, 3)] = lhs[hook(27, 3)][hook(30, 3)] - coeff * lhs[hook(27, 3)][hook(30, 1)];
  lhs[hook(27, 4)][hook(31, 3)] = lhs[hook(27, 4)][hook(31, 3)] - coeff * lhs[hook(27, 4)][hook(31, 1)];
  c[hook(33, 0)][hook(32, 3)] = c[hook(33, 0)][hook(32, 3)] - coeff * c[hook(33, 0)][hook(32, 1)];
  c[hook(33, 1)][hook(34, 3)] = c[hook(33, 1)][hook(34, 3)] - coeff * c[hook(33, 1)][hook(34, 1)];
  c[hook(33, 2)][hook(35, 3)] = c[hook(33, 2)][hook(35, 3)] - coeff * c[hook(33, 2)][hook(35, 1)];
  c[hook(33, 3)][hook(36, 3)] = c[hook(33, 3)][hook(36, 3)] - coeff * c[hook(33, 3)][hook(36, 1)];
  c[hook(33, 4)][hook(37, 3)] = c[hook(33, 4)][hook(37, 3)] - coeff * c[hook(33, 4)][hook(37, 1)];
  r[hook(38, 3)] = r[hook(38, 3)] - coeff * r[hook(38, 1)];

  coeff = lhs[hook(27, 1)][hook(28, 4)];
  lhs[hook(27, 2)][hook(29, 4)] = lhs[hook(27, 2)][hook(29, 4)] - coeff * lhs[hook(27, 2)][hook(29, 1)];
  lhs[hook(27, 3)][hook(30, 4)] = lhs[hook(27, 3)][hook(30, 4)] - coeff * lhs[hook(27, 3)][hook(30, 1)];
  lhs[hook(27, 4)][hook(31, 4)] = lhs[hook(27, 4)][hook(31, 4)] - coeff * lhs[hook(27, 4)][hook(31, 1)];
  c[hook(33, 0)][hook(32, 4)] = c[hook(33, 0)][hook(32, 4)] - coeff * c[hook(33, 0)][hook(32, 1)];
  c[hook(33, 1)][hook(34, 4)] = c[hook(33, 1)][hook(34, 4)] - coeff * c[hook(33, 1)][hook(34, 1)];
  c[hook(33, 2)][hook(35, 4)] = c[hook(33, 2)][hook(35, 4)] - coeff * c[hook(33, 2)][hook(35, 1)];
  c[hook(33, 3)][hook(36, 4)] = c[hook(33, 3)][hook(36, 4)] - coeff * c[hook(33, 3)][hook(36, 1)];
  c[hook(33, 4)][hook(37, 4)] = c[hook(33, 4)][hook(37, 4)] - coeff * c[hook(33, 4)][hook(37, 1)];
  r[hook(38, 4)] = r[hook(38, 4)] - coeff * r[hook(38, 1)];

  pivot = 1.00 / lhs[hook(27, 2)][hook(29, 2)];
  lhs[hook(27, 3)][hook(30, 2)] = lhs[hook(27, 3)][hook(30, 2)] * pivot;
  lhs[hook(27, 4)][hook(31, 2)] = lhs[hook(27, 4)][hook(31, 2)] * pivot;
  c[hook(33, 0)][hook(32, 2)] = c[hook(33, 0)][hook(32, 2)] * pivot;
  c[hook(33, 1)][hook(34, 2)] = c[hook(33, 1)][hook(34, 2)] * pivot;
  c[hook(33, 2)][hook(35, 2)] = c[hook(33, 2)][hook(35, 2)] * pivot;
  c[hook(33, 3)][hook(36, 2)] = c[hook(33, 3)][hook(36, 2)] * pivot;
  c[hook(33, 4)][hook(37, 2)] = c[hook(33, 4)][hook(37, 2)] * pivot;
  r[hook(38, 2)] = r[hook(38, 2)] * pivot;

  coeff = lhs[hook(27, 2)][hook(29, 0)];
  lhs[hook(27, 3)][hook(30, 0)] = lhs[hook(27, 3)][hook(30, 0)] - coeff * lhs[hook(27, 3)][hook(30, 2)];
  lhs[hook(27, 4)][hook(31, 0)] = lhs[hook(27, 4)][hook(31, 0)] - coeff * lhs[hook(27, 4)][hook(31, 2)];
  c[hook(33, 0)][hook(32, 0)] = c[hook(33, 0)][hook(32, 0)] - coeff * c[hook(33, 0)][hook(32, 2)];
  c[hook(33, 1)][hook(34, 0)] = c[hook(33, 1)][hook(34, 0)] - coeff * c[hook(33, 1)][hook(34, 2)];
  c[hook(33, 2)][hook(35, 0)] = c[hook(33, 2)][hook(35, 0)] - coeff * c[hook(33, 2)][hook(35, 2)];
  c[hook(33, 3)][hook(36, 0)] = c[hook(33, 3)][hook(36, 0)] - coeff * c[hook(33, 3)][hook(36, 2)];
  c[hook(33, 4)][hook(37, 0)] = c[hook(33, 4)][hook(37, 0)] - coeff * c[hook(33, 4)][hook(37, 2)];
  r[hook(38, 0)] = r[hook(38, 0)] - coeff * r[hook(38, 2)];

  coeff = lhs[hook(27, 2)][hook(29, 1)];
  lhs[hook(27, 3)][hook(30, 1)] = lhs[hook(27, 3)][hook(30, 1)] - coeff * lhs[hook(27, 3)][hook(30, 2)];
  lhs[hook(27, 4)][hook(31, 1)] = lhs[hook(27, 4)][hook(31, 1)] - coeff * lhs[hook(27, 4)][hook(31, 2)];
  c[hook(33, 0)][hook(32, 1)] = c[hook(33, 0)][hook(32, 1)] - coeff * c[hook(33, 0)][hook(32, 2)];
  c[hook(33, 1)][hook(34, 1)] = c[hook(33, 1)][hook(34, 1)] - coeff * c[hook(33, 1)][hook(34, 2)];
  c[hook(33, 2)][hook(35, 1)] = c[hook(33, 2)][hook(35, 1)] - coeff * c[hook(33, 2)][hook(35, 2)];
  c[hook(33, 3)][hook(36, 1)] = c[hook(33, 3)][hook(36, 1)] - coeff * c[hook(33, 3)][hook(36, 2)];
  c[hook(33, 4)][hook(37, 1)] = c[hook(33, 4)][hook(37, 1)] - coeff * c[hook(33, 4)][hook(37, 2)];
  r[hook(38, 1)] = r[hook(38, 1)] - coeff * r[hook(38, 2)];

  coeff = lhs[hook(27, 2)][hook(29, 3)];
  lhs[hook(27, 3)][hook(30, 3)] = lhs[hook(27, 3)][hook(30, 3)] - coeff * lhs[hook(27, 3)][hook(30, 2)];
  lhs[hook(27, 4)][hook(31, 3)] = lhs[hook(27, 4)][hook(31, 3)] - coeff * lhs[hook(27, 4)][hook(31, 2)];
  c[hook(33, 0)][hook(32, 3)] = c[hook(33, 0)][hook(32, 3)] - coeff * c[hook(33, 0)][hook(32, 2)];
  c[hook(33, 1)][hook(34, 3)] = c[hook(33, 1)][hook(34, 3)] - coeff * c[hook(33, 1)][hook(34, 2)];
  c[hook(33, 2)][hook(35, 3)] = c[hook(33, 2)][hook(35, 3)] - coeff * c[hook(33, 2)][hook(35, 2)];
  c[hook(33, 3)][hook(36, 3)] = c[hook(33, 3)][hook(36, 3)] - coeff * c[hook(33, 3)][hook(36, 2)];
  c[hook(33, 4)][hook(37, 3)] = c[hook(33, 4)][hook(37, 3)] - coeff * c[hook(33, 4)][hook(37, 2)];
  r[hook(38, 3)] = r[hook(38, 3)] - coeff * r[hook(38, 2)];

  coeff = lhs[hook(27, 2)][hook(29, 4)];
  lhs[hook(27, 3)][hook(30, 4)] = lhs[hook(27, 3)][hook(30, 4)] - coeff * lhs[hook(27, 3)][hook(30, 2)];
  lhs[hook(27, 4)][hook(31, 4)] = lhs[hook(27, 4)][hook(31, 4)] - coeff * lhs[hook(27, 4)][hook(31, 2)];
  c[hook(33, 0)][hook(32, 4)] = c[hook(33, 0)][hook(32, 4)] - coeff * c[hook(33, 0)][hook(32, 2)];
  c[hook(33, 1)][hook(34, 4)] = c[hook(33, 1)][hook(34, 4)] - coeff * c[hook(33, 1)][hook(34, 2)];
  c[hook(33, 2)][hook(35, 4)] = c[hook(33, 2)][hook(35, 4)] - coeff * c[hook(33, 2)][hook(35, 2)];
  c[hook(33, 3)][hook(36, 4)] = c[hook(33, 3)][hook(36, 4)] - coeff * c[hook(33, 3)][hook(36, 2)];
  c[hook(33, 4)][hook(37, 4)] = c[hook(33, 4)][hook(37, 4)] - coeff * c[hook(33, 4)][hook(37, 2)];
  r[hook(38, 4)] = r[hook(38, 4)] - coeff * r[hook(38, 2)];

  pivot = 1.00 / lhs[hook(27, 3)][hook(30, 3)];
  lhs[hook(27, 4)][hook(31, 3)] = lhs[hook(27, 4)][hook(31, 3)] * pivot;
  c[hook(33, 0)][hook(32, 3)] = c[hook(33, 0)][hook(32, 3)] * pivot;
  c[hook(33, 1)][hook(34, 3)] = c[hook(33, 1)][hook(34, 3)] * pivot;
  c[hook(33, 2)][hook(35, 3)] = c[hook(33, 2)][hook(35, 3)] * pivot;
  c[hook(33, 3)][hook(36, 3)] = c[hook(33, 3)][hook(36, 3)] * pivot;
  c[hook(33, 4)][hook(37, 3)] = c[hook(33, 4)][hook(37, 3)] * pivot;
  r[hook(38, 3)] = r[hook(38, 3)] * pivot;

  coeff = lhs[hook(27, 3)][hook(30, 0)];
  lhs[hook(27, 4)][hook(31, 0)] = lhs[hook(27, 4)][hook(31, 0)] - coeff * lhs[hook(27, 4)][hook(31, 3)];
  c[hook(33, 0)][hook(32, 0)] = c[hook(33, 0)][hook(32, 0)] - coeff * c[hook(33, 0)][hook(32, 3)];
  c[hook(33, 1)][hook(34, 0)] = c[hook(33, 1)][hook(34, 0)] - coeff * c[hook(33, 1)][hook(34, 3)];
  c[hook(33, 2)][hook(35, 0)] = c[hook(33, 2)][hook(35, 0)] - coeff * c[hook(33, 2)][hook(35, 3)];
  c[hook(33, 3)][hook(36, 0)] = c[hook(33, 3)][hook(36, 0)] - coeff * c[hook(33, 3)][hook(36, 3)];
  c[hook(33, 4)][hook(37, 0)] = c[hook(33, 4)][hook(37, 0)] - coeff * c[hook(33, 4)][hook(37, 3)];
  r[hook(38, 0)] = r[hook(38, 0)] - coeff * r[hook(38, 3)];

  coeff = lhs[hook(27, 3)][hook(30, 1)];
  lhs[hook(27, 4)][hook(31, 1)] = lhs[hook(27, 4)][hook(31, 1)] - coeff * lhs[hook(27, 4)][hook(31, 3)];
  c[hook(33, 0)][hook(32, 1)] = c[hook(33, 0)][hook(32, 1)] - coeff * c[hook(33, 0)][hook(32, 3)];
  c[hook(33, 1)][hook(34, 1)] = c[hook(33, 1)][hook(34, 1)] - coeff * c[hook(33, 1)][hook(34, 3)];
  c[hook(33, 2)][hook(35, 1)] = c[hook(33, 2)][hook(35, 1)] - coeff * c[hook(33, 2)][hook(35, 3)];
  c[hook(33, 3)][hook(36, 1)] = c[hook(33, 3)][hook(36, 1)] - coeff * c[hook(33, 3)][hook(36, 3)];
  c[hook(33, 4)][hook(37, 1)] = c[hook(33, 4)][hook(37, 1)] - coeff * c[hook(33, 4)][hook(37, 3)];
  r[hook(38, 1)] = r[hook(38, 1)] - coeff * r[hook(38, 3)];

  coeff = lhs[hook(27, 3)][hook(30, 2)];
  lhs[hook(27, 4)][hook(31, 2)] = lhs[hook(27, 4)][hook(31, 2)] - coeff * lhs[hook(27, 4)][hook(31, 3)];
  c[hook(33, 0)][hook(32, 2)] = c[hook(33, 0)][hook(32, 2)] - coeff * c[hook(33, 0)][hook(32, 3)];
  c[hook(33, 1)][hook(34, 2)] = c[hook(33, 1)][hook(34, 2)] - coeff * c[hook(33, 1)][hook(34, 3)];
  c[hook(33, 2)][hook(35, 2)] = c[hook(33, 2)][hook(35, 2)] - coeff * c[hook(33, 2)][hook(35, 3)];
  c[hook(33, 3)][hook(36, 2)] = c[hook(33, 3)][hook(36, 2)] - coeff * c[hook(33, 3)][hook(36, 3)];
  c[hook(33, 4)][hook(37, 2)] = c[hook(33, 4)][hook(37, 2)] - coeff * c[hook(33, 4)][hook(37, 3)];
  r[hook(38, 2)] = r[hook(38, 2)] - coeff * r[hook(38, 3)];

  coeff = lhs[hook(27, 3)][hook(30, 4)];
  lhs[hook(27, 4)][hook(31, 4)] = lhs[hook(27, 4)][hook(31, 4)] - coeff * lhs[hook(27, 4)][hook(31, 3)];
  c[hook(33, 0)][hook(32, 4)] = c[hook(33, 0)][hook(32, 4)] - coeff * c[hook(33, 0)][hook(32, 3)];
  c[hook(33, 1)][hook(34, 4)] = c[hook(33, 1)][hook(34, 4)] - coeff * c[hook(33, 1)][hook(34, 3)];
  c[hook(33, 2)][hook(35, 4)] = c[hook(33, 2)][hook(35, 4)] - coeff * c[hook(33, 2)][hook(35, 3)];
  c[hook(33, 3)][hook(36, 4)] = c[hook(33, 3)][hook(36, 4)] - coeff * c[hook(33, 3)][hook(36, 3)];
  c[hook(33, 4)][hook(37, 4)] = c[hook(33, 4)][hook(37, 4)] - coeff * c[hook(33, 4)][hook(37, 3)];
  r[hook(38, 4)] = r[hook(38, 4)] - coeff * r[hook(38, 3)];

  pivot = 1.00 / lhs[hook(27, 4)][hook(31, 4)];
  c[hook(33, 0)][hook(32, 4)] = c[hook(33, 0)][hook(32, 4)] * pivot;
  c[hook(33, 1)][hook(34, 4)] = c[hook(33, 1)][hook(34, 4)] * pivot;
  c[hook(33, 2)][hook(35, 4)] = c[hook(33, 2)][hook(35, 4)] * pivot;
  c[hook(33, 3)][hook(36, 4)] = c[hook(33, 3)][hook(36, 4)] * pivot;
  c[hook(33, 4)][hook(37, 4)] = c[hook(33, 4)][hook(37, 4)] * pivot;
  r[hook(38, 4)] = r[hook(38, 4)] * pivot;

  coeff = lhs[hook(27, 4)][hook(31, 0)];
  c[hook(33, 0)][hook(32, 0)] = c[hook(33, 0)][hook(32, 0)] - coeff * c[hook(33, 0)][hook(32, 4)];
  c[hook(33, 1)][hook(34, 0)] = c[hook(33, 1)][hook(34, 0)] - coeff * c[hook(33, 1)][hook(34, 4)];
  c[hook(33, 2)][hook(35, 0)] = c[hook(33, 2)][hook(35, 0)] - coeff * c[hook(33, 2)][hook(35, 4)];
  c[hook(33, 3)][hook(36, 0)] = c[hook(33, 3)][hook(36, 0)] - coeff * c[hook(33, 3)][hook(36, 4)];
  c[hook(33, 4)][hook(37, 0)] = c[hook(33, 4)][hook(37, 0)] - coeff * c[hook(33, 4)][hook(37, 4)];
  r[hook(38, 0)] = r[hook(38, 0)] - coeff * r[hook(38, 4)];

  coeff = lhs[hook(27, 4)][hook(31, 1)];
  c[hook(33, 0)][hook(32, 1)] = c[hook(33, 0)][hook(32, 1)] - coeff * c[hook(33, 0)][hook(32, 4)];
  c[hook(33, 1)][hook(34, 1)] = c[hook(33, 1)][hook(34, 1)] - coeff * c[hook(33, 1)][hook(34, 4)];
  c[hook(33, 2)][hook(35, 1)] = c[hook(33, 2)][hook(35, 1)] - coeff * c[hook(33, 2)][hook(35, 4)];
  c[hook(33, 3)][hook(36, 1)] = c[hook(33, 3)][hook(36, 1)] - coeff * c[hook(33, 3)][hook(36, 4)];
  c[hook(33, 4)][hook(37, 1)] = c[hook(33, 4)][hook(37, 1)] - coeff * c[hook(33, 4)][hook(37, 4)];
  r[hook(38, 1)] = r[hook(38, 1)] - coeff * r[hook(38, 4)];

  coeff = lhs[hook(27, 4)][hook(31, 2)];
  c[hook(33, 0)][hook(32, 2)] = c[hook(33, 0)][hook(32, 2)] - coeff * c[hook(33, 0)][hook(32, 4)];
  c[hook(33, 1)][hook(34, 2)] = c[hook(33, 1)][hook(34, 2)] - coeff * c[hook(33, 1)][hook(34, 4)];
  c[hook(33, 2)][hook(35, 2)] = c[hook(33, 2)][hook(35, 2)] - coeff * c[hook(33, 2)][hook(35, 4)];
  c[hook(33, 3)][hook(36, 2)] = c[hook(33, 3)][hook(36, 2)] - coeff * c[hook(33, 3)][hook(36, 4)];
  c[hook(33, 4)][hook(37, 2)] = c[hook(33, 4)][hook(37, 2)] - coeff * c[hook(33, 4)][hook(37, 4)];
  r[hook(38, 2)] = r[hook(38, 2)] - coeff * r[hook(38, 4)];

  coeff = lhs[hook(27, 4)][hook(31, 3)];
  c[hook(33, 0)][hook(32, 3)] = c[hook(33, 0)][hook(32, 3)] - coeff * c[hook(33, 0)][hook(32, 4)];
  c[hook(33, 1)][hook(34, 3)] = c[hook(33, 1)][hook(34, 3)] - coeff * c[hook(33, 1)][hook(34, 4)];
  c[hook(33, 2)][hook(35, 3)] = c[hook(33, 2)][hook(35, 3)] - coeff * c[hook(33, 2)][hook(35, 4)];
  c[hook(33, 3)][hook(36, 3)] = c[hook(33, 3)][hook(36, 3)] - coeff * c[hook(33, 3)][hook(36, 4)];
  c[hook(33, 4)][hook(37, 3)] = c[hook(33, 4)][hook(37, 3)] - coeff * c[hook(33, 4)][hook(37, 4)];
  r[hook(38, 3)] = r[hook(38, 3)] - coeff * r[hook(38, 4)];
}

void binvrhs(global double lhs[5][5], global double r[5]) {
  double pivot, coeff;

  pivot = 1.00 / lhs[hook(27, 0)][hook(26, 0)];
  lhs[hook(27, 1)][hook(28, 0)] = lhs[hook(27, 1)][hook(28, 0)] * pivot;
  lhs[hook(27, 2)][hook(29, 0)] = lhs[hook(27, 2)][hook(29, 0)] * pivot;
  lhs[hook(27, 3)][hook(30, 0)] = lhs[hook(27, 3)][hook(30, 0)] * pivot;
  lhs[hook(27, 4)][hook(31, 0)] = lhs[hook(27, 4)][hook(31, 0)] * pivot;
  r[hook(38, 0)] = r[hook(38, 0)] * pivot;

  coeff = lhs[hook(27, 0)][hook(26, 1)];
  lhs[hook(27, 1)][hook(28, 1)] = lhs[hook(27, 1)][hook(28, 1)] - coeff * lhs[hook(27, 1)][hook(28, 0)];
  lhs[hook(27, 2)][hook(29, 1)] = lhs[hook(27, 2)][hook(29, 1)] - coeff * lhs[hook(27, 2)][hook(29, 0)];
  lhs[hook(27, 3)][hook(30, 1)] = lhs[hook(27, 3)][hook(30, 1)] - coeff * lhs[hook(27, 3)][hook(30, 0)];
  lhs[hook(27, 4)][hook(31, 1)] = lhs[hook(27, 4)][hook(31, 1)] - coeff * lhs[hook(27, 4)][hook(31, 0)];
  r[hook(38, 1)] = r[hook(38, 1)] - coeff * r[hook(38, 0)];

  coeff = lhs[hook(27, 0)][hook(26, 2)];
  lhs[hook(27, 1)][hook(28, 2)] = lhs[hook(27, 1)][hook(28, 2)] - coeff * lhs[hook(27, 1)][hook(28, 0)];
  lhs[hook(27, 2)][hook(29, 2)] = lhs[hook(27, 2)][hook(29, 2)] - coeff * lhs[hook(27, 2)][hook(29, 0)];
  lhs[hook(27, 3)][hook(30, 2)] = lhs[hook(27, 3)][hook(30, 2)] - coeff * lhs[hook(27, 3)][hook(30, 0)];
  lhs[hook(27, 4)][hook(31, 2)] = lhs[hook(27, 4)][hook(31, 2)] - coeff * lhs[hook(27, 4)][hook(31, 0)];
  r[hook(38, 2)] = r[hook(38, 2)] - coeff * r[hook(38, 0)];

  coeff = lhs[hook(27, 0)][hook(26, 3)];
  lhs[hook(27, 1)][hook(28, 3)] = lhs[hook(27, 1)][hook(28, 3)] - coeff * lhs[hook(27, 1)][hook(28, 0)];
  lhs[hook(27, 2)][hook(29, 3)] = lhs[hook(27, 2)][hook(29, 3)] - coeff * lhs[hook(27, 2)][hook(29, 0)];
  lhs[hook(27, 3)][hook(30, 3)] = lhs[hook(27, 3)][hook(30, 3)] - coeff * lhs[hook(27, 3)][hook(30, 0)];
  lhs[hook(27, 4)][hook(31, 3)] = lhs[hook(27, 4)][hook(31, 3)] - coeff * lhs[hook(27, 4)][hook(31, 0)];
  r[hook(38, 3)] = r[hook(38, 3)] - coeff * r[hook(38, 0)];

  coeff = lhs[hook(27, 0)][hook(26, 4)];
  lhs[hook(27, 1)][hook(28, 4)] = lhs[hook(27, 1)][hook(28, 4)] - coeff * lhs[hook(27, 1)][hook(28, 0)];
  lhs[hook(27, 2)][hook(29, 4)] = lhs[hook(27, 2)][hook(29, 4)] - coeff * lhs[hook(27, 2)][hook(29, 0)];
  lhs[hook(27, 3)][hook(30, 4)] = lhs[hook(27, 3)][hook(30, 4)] - coeff * lhs[hook(27, 3)][hook(30, 0)];
  lhs[hook(27, 4)][hook(31, 4)] = lhs[hook(27, 4)][hook(31, 4)] - coeff * lhs[hook(27, 4)][hook(31, 0)];
  r[hook(38, 4)] = r[hook(38, 4)] - coeff * r[hook(38, 0)];

  pivot = 1.00 / lhs[hook(27, 1)][hook(28, 1)];
  lhs[hook(27, 2)][hook(29, 1)] = lhs[hook(27, 2)][hook(29, 1)] * pivot;
  lhs[hook(27, 3)][hook(30, 1)] = lhs[hook(27, 3)][hook(30, 1)] * pivot;
  lhs[hook(27, 4)][hook(31, 1)] = lhs[hook(27, 4)][hook(31, 1)] * pivot;
  r[hook(38, 1)] = r[hook(38, 1)] * pivot;

  coeff = lhs[hook(27, 1)][hook(28, 0)];
  lhs[hook(27, 2)][hook(29, 0)] = lhs[hook(27, 2)][hook(29, 0)] - coeff * lhs[hook(27, 2)][hook(29, 1)];
  lhs[hook(27, 3)][hook(30, 0)] = lhs[hook(27, 3)][hook(30, 0)] - coeff * lhs[hook(27, 3)][hook(30, 1)];
  lhs[hook(27, 4)][hook(31, 0)] = lhs[hook(27, 4)][hook(31, 0)] - coeff * lhs[hook(27, 4)][hook(31, 1)];
  r[hook(38, 0)] = r[hook(38, 0)] - coeff * r[hook(38, 1)];

  coeff = lhs[hook(27, 1)][hook(28, 2)];
  lhs[hook(27, 2)][hook(29, 2)] = lhs[hook(27, 2)][hook(29, 2)] - coeff * lhs[hook(27, 2)][hook(29, 1)];
  lhs[hook(27, 3)][hook(30, 2)] = lhs[hook(27, 3)][hook(30, 2)] - coeff * lhs[hook(27, 3)][hook(30, 1)];
  lhs[hook(27, 4)][hook(31, 2)] = lhs[hook(27, 4)][hook(31, 2)] - coeff * lhs[hook(27, 4)][hook(31, 1)];
  r[hook(38, 2)] = r[hook(38, 2)] - coeff * r[hook(38, 1)];

  coeff = lhs[hook(27, 1)][hook(28, 3)];
  lhs[hook(27, 2)][hook(29, 3)] = lhs[hook(27, 2)][hook(29, 3)] - coeff * lhs[hook(27, 2)][hook(29, 1)];
  lhs[hook(27, 3)][hook(30, 3)] = lhs[hook(27, 3)][hook(30, 3)] - coeff * lhs[hook(27, 3)][hook(30, 1)];
  lhs[hook(27, 4)][hook(31, 3)] = lhs[hook(27, 4)][hook(31, 3)] - coeff * lhs[hook(27, 4)][hook(31, 1)];
  r[hook(38, 3)] = r[hook(38, 3)] - coeff * r[hook(38, 1)];

  coeff = lhs[hook(27, 1)][hook(28, 4)];
  lhs[hook(27, 2)][hook(29, 4)] = lhs[hook(27, 2)][hook(29, 4)] - coeff * lhs[hook(27, 2)][hook(29, 1)];
  lhs[hook(27, 3)][hook(30, 4)] = lhs[hook(27, 3)][hook(30, 4)] - coeff * lhs[hook(27, 3)][hook(30, 1)];
  lhs[hook(27, 4)][hook(31, 4)] = lhs[hook(27, 4)][hook(31, 4)] - coeff * lhs[hook(27, 4)][hook(31, 1)];
  r[hook(38, 4)] = r[hook(38, 4)] - coeff * r[hook(38, 1)];

  pivot = 1.00 / lhs[hook(27, 2)][hook(29, 2)];
  lhs[hook(27, 3)][hook(30, 2)] = lhs[hook(27, 3)][hook(30, 2)] * pivot;
  lhs[hook(27, 4)][hook(31, 2)] = lhs[hook(27, 4)][hook(31, 2)] * pivot;
  r[hook(38, 2)] = r[hook(38, 2)] * pivot;

  coeff = lhs[hook(27, 2)][hook(29, 0)];
  lhs[hook(27, 3)][hook(30, 0)] = lhs[hook(27, 3)][hook(30, 0)] - coeff * lhs[hook(27, 3)][hook(30, 2)];
  lhs[hook(27, 4)][hook(31, 0)] = lhs[hook(27, 4)][hook(31, 0)] - coeff * lhs[hook(27, 4)][hook(31, 2)];
  r[hook(38, 0)] = r[hook(38, 0)] - coeff * r[hook(38, 2)];

  coeff = lhs[hook(27, 2)][hook(29, 1)];
  lhs[hook(27, 3)][hook(30, 1)] = lhs[hook(27, 3)][hook(30, 1)] - coeff * lhs[hook(27, 3)][hook(30, 2)];
  lhs[hook(27, 4)][hook(31, 1)] = lhs[hook(27, 4)][hook(31, 1)] - coeff * lhs[hook(27, 4)][hook(31, 2)];
  r[hook(38, 1)] = r[hook(38, 1)] - coeff * r[hook(38, 2)];

  coeff = lhs[hook(27, 2)][hook(29, 3)];
  lhs[hook(27, 3)][hook(30, 3)] = lhs[hook(27, 3)][hook(30, 3)] - coeff * lhs[hook(27, 3)][hook(30, 2)];
  lhs[hook(27, 4)][hook(31, 3)] = lhs[hook(27, 4)][hook(31, 3)] - coeff * lhs[hook(27, 4)][hook(31, 2)];
  r[hook(38, 3)] = r[hook(38, 3)] - coeff * r[hook(38, 2)];

  coeff = lhs[hook(27, 2)][hook(29, 4)];
  lhs[hook(27, 3)][hook(30, 4)] = lhs[hook(27, 3)][hook(30, 4)] - coeff * lhs[hook(27, 3)][hook(30, 2)];
  lhs[hook(27, 4)][hook(31, 4)] = lhs[hook(27, 4)][hook(31, 4)] - coeff * lhs[hook(27, 4)][hook(31, 2)];
  r[hook(38, 4)] = r[hook(38, 4)] - coeff * r[hook(38, 2)];

  pivot = 1.00 / lhs[hook(27, 3)][hook(30, 3)];
  lhs[hook(27, 4)][hook(31, 3)] = lhs[hook(27, 4)][hook(31, 3)] * pivot;
  r[hook(38, 3)] = r[hook(38, 3)] * pivot;

  coeff = lhs[hook(27, 3)][hook(30, 0)];
  lhs[hook(27, 4)][hook(31, 0)] = lhs[hook(27, 4)][hook(31, 0)] - coeff * lhs[hook(27, 4)][hook(31, 3)];
  r[hook(38, 0)] = r[hook(38, 0)] - coeff * r[hook(38, 3)];

  coeff = lhs[hook(27, 3)][hook(30, 1)];
  lhs[hook(27, 4)][hook(31, 1)] = lhs[hook(27, 4)][hook(31, 1)] - coeff * lhs[hook(27, 4)][hook(31, 3)];
  r[hook(38, 1)] = r[hook(38, 1)] - coeff * r[hook(38, 3)];

  coeff = lhs[hook(27, 3)][hook(30, 2)];
  lhs[hook(27, 4)][hook(31, 2)] = lhs[hook(27, 4)][hook(31, 2)] - coeff * lhs[hook(27, 4)][hook(31, 3)];
  r[hook(38, 2)] = r[hook(38, 2)] - coeff * r[hook(38, 3)];

  coeff = lhs[hook(27, 3)][hook(30, 4)];
  lhs[hook(27, 4)][hook(31, 4)] = lhs[hook(27, 4)][hook(31, 4)] - coeff * lhs[hook(27, 4)][hook(31, 3)];
  r[hook(38, 4)] = r[hook(38, 4)] - coeff * r[hook(38, 3)];

  pivot = 1.00 / lhs[hook(27, 4)][hook(31, 4)];
  r[hook(38, 4)] = r[hook(38, 4)] * pivot;

  coeff = lhs[hook(27, 4)][hook(31, 0)];
  r[hook(38, 0)] = r[hook(38, 0)] - coeff * r[hook(38, 4)];

  coeff = lhs[hook(27, 4)][hook(31, 1)];
  r[hook(38, 1)] = r[hook(38, 1)] - coeff * r[hook(38, 4)];

  coeff = lhs[hook(27, 4)][hook(31, 2)];
  r[hook(38, 2)] = r[hook(38, 2)] - coeff * r[hook(38, 4)];

  coeff = lhs[hook(27, 4)][hook(31, 3)];
  r[hook(38, 3)] = r[hook(38, 3)] - coeff * r[hook(38, 4)];
}

kernel void x_solve3(global double* g_fjac, global double* g_njac, global double* g_lhs, int gp0, int gp1, int gp2) {
  int i, j, k;
  double tmp1, tmp2;

  k = get_global_id(2) + 1;
  j = get_global_id(1) + 1;
  i = get_global_id(0) + 1;
  if (k > (gp2 - 2) || j > (gp1 - 2) || i > (gp0 - 2))
    return;

  int my_id = (k - 1) * (gp1 - 2) + (j - 1);
  int my_offset = my_id * (64 + 1) * 5 * 5;
  global double(*fjac)[5][5] = (global double(*)[5][5]) & g_fjac[hook(0, my_offset)];
  global double(*njac)[5][5] = (global double(*)[5][5]) & g_njac[hook(1, my_offset)];

  my_offset = my_id * (64 + 1) * 3 * 5 * 5;
  global double(*lhs)[3][5][5] = (global double(*)[3][5][5]) & g_lhs[hook(2, my_offset)];

  tmp1 = 0.0008 * (1.0 / ((1.0 / (double)(64 - 1)) * (1.0 / (double)(64 - 1))));
  tmp2 = 0.0008 * (1.0 / (2.0 * (1.0 / (double)(64 - 1))));

  lhs[hook(27, i)][hook(41, 0)][hook(40, 0)][hook(39, 0)] = -tmp2 * fjac[hook(44, i - 1)][hook(43, 0)][hook(42, 0)] - tmp1 * njac[hook(47, i - 1)][hook(46, 0)][hook(45, 0)] - tmp1 * 0.75;
  lhs[hook(27, i)][hook(41, 0)][hook(40, 1)][hook(48, 0)] = -tmp2 * fjac[hook(44, i - 1)][hook(43, 1)][hook(49, 0)] - tmp1 * njac[hook(47, i - 1)][hook(46, 1)][hook(50, 0)];
  lhs[hook(27, i)][hook(41, 0)][hook(40, 2)][hook(51, 0)] = -tmp2 * fjac[hook(44, i - 1)][hook(43, 2)][hook(52, 0)] - tmp1 * njac[hook(47, i - 1)][hook(46, 2)][hook(53, 0)];
  lhs[hook(27, i)][hook(41, 0)][hook(40, 3)][hook(54, 0)] = -tmp2 * fjac[hook(44, i - 1)][hook(43, 3)][hook(55, 0)] - tmp1 * njac[hook(47, i - 1)][hook(46, 3)][hook(56, 0)];
  lhs[hook(27, i)][hook(41, 0)][hook(40, 4)][hook(57, 0)] = -tmp2 * fjac[hook(44, i - 1)][hook(43, 4)][hook(58, 0)] - tmp1 * njac[hook(47, i - 1)][hook(46, 4)][hook(59, 0)];

  lhs[hook(27, i)][hook(41, 0)][hook(40, 0)][hook(39, 1)] = -tmp2 * fjac[hook(44, i - 1)][hook(43, 0)][hook(42, 1)] - tmp1 * njac[hook(47, i - 1)][hook(46, 0)][hook(45, 1)];
  lhs[hook(27, i)][hook(41, 0)][hook(40, 1)][hook(48, 1)] = -tmp2 * fjac[hook(44, i - 1)][hook(43, 1)][hook(49, 1)] - tmp1 * njac[hook(47, i - 1)][hook(46, 1)][hook(50, 1)] - tmp1 * 0.75;
  lhs[hook(27, i)][hook(41, 0)][hook(40, 2)][hook(51, 1)] = -tmp2 * fjac[hook(44, i - 1)][hook(43, 2)][hook(52, 1)] - tmp1 * njac[hook(47, i - 1)][hook(46, 2)][hook(53, 1)];
  lhs[hook(27, i)][hook(41, 0)][hook(40, 3)][hook(54, 1)] = -tmp2 * fjac[hook(44, i - 1)][hook(43, 3)][hook(55, 1)] - tmp1 * njac[hook(47, i - 1)][hook(46, 3)][hook(56, 1)];
  lhs[hook(27, i)][hook(41, 0)][hook(40, 4)][hook(57, 1)] = -tmp2 * fjac[hook(44, i - 1)][hook(43, 4)][hook(58, 1)] - tmp1 * njac[hook(47, i - 1)][hook(46, 4)][hook(59, 1)];

  lhs[hook(27, i)][hook(41, 0)][hook(40, 0)][hook(39, 2)] = -tmp2 * fjac[hook(44, i - 1)][hook(43, 0)][hook(42, 2)] - tmp1 * njac[hook(47, i - 1)][hook(46, 0)][hook(45, 2)];
  lhs[hook(27, i)][hook(41, 0)][hook(40, 1)][hook(48, 2)] = -tmp2 * fjac[hook(44, i - 1)][hook(43, 1)][hook(49, 2)] - tmp1 * njac[hook(47, i - 1)][hook(46, 1)][hook(50, 2)];
  lhs[hook(27, i)][hook(41, 0)][hook(40, 2)][hook(51, 2)] = -tmp2 * fjac[hook(44, i - 1)][hook(43, 2)][hook(52, 2)] - tmp1 * njac[hook(47, i - 1)][hook(46, 2)][hook(53, 2)] - tmp1 * 0.75;
  lhs[hook(27, i)][hook(41, 0)][hook(40, 3)][hook(54, 2)] = -tmp2 * fjac[hook(44, i - 1)][hook(43, 3)][hook(55, 2)] - tmp1 * njac[hook(47, i - 1)][hook(46, 3)][hook(56, 2)];
  lhs[hook(27, i)][hook(41, 0)][hook(40, 4)][hook(57, 2)] = -tmp2 * fjac[hook(44, i - 1)][hook(43, 4)][hook(58, 2)] - tmp1 * njac[hook(47, i - 1)][hook(46, 4)][hook(59, 2)];

  lhs[hook(27, i)][hook(41, 0)][hook(40, 0)][hook(39, 3)] = -tmp2 * fjac[hook(44, i - 1)][hook(43, 0)][hook(42, 3)] - tmp1 * njac[hook(47, i - 1)][hook(46, 0)][hook(45, 3)];
  lhs[hook(27, i)][hook(41, 0)][hook(40, 1)][hook(48, 3)] = -tmp2 * fjac[hook(44, i - 1)][hook(43, 1)][hook(49, 3)] - tmp1 * njac[hook(47, i - 1)][hook(46, 1)][hook(50, 3)];
  lhs[hook(27, i)][hook(41, 0)][hook(40, 2)][hook(51, 3)] = -tmp2 * fjac[hook(44, i - 1)][hook(43, 2)][hook(52, 3)] - tmp1 * njac[hook(47, i - 1)][hook(46, 2)][hook(53, 3)];
  lhs[hook(27, i)][hook(41, 0)][hook(40, 3)][hook(54, 3)] = -tmp2 * fjac[hook(44, i - 1)][hook(43, 3)][hook(55, 3)] - tmp1 * njac[hook(47, i - 1)][hook(46, 3)][hook(56, 3)] - tmp1 * 0.75;
  lhs[hook(27, i)][hook(41, 0)][hook(40, 4)][hook(57, 3)] = -tmp2 * fjac[hook(44, i - 1)][hook(43, 4)][hook(58, 3)] - tmp1 * njac[hook(47, i - 1)][hook(46, 4)][hook(59, 3)];

  lhs[hook(27, i)][hook(41, 0)][hook(40, 0)][hook(39, 4)] = -tmp2 * fjac[hook(44, i - 1)][hook(43, 0)][hook(42, 4)] - tmp1 * njac[hook(47, i - 1)][hook(46, 0)][hook(45, 4)];
  lhs[hook(27, i)][hook(41, 0)][hook(40, 1)][hook(48, 4)] = -tmp2 * fjac[hook(44, i - 1)][hook(43, 1)][hook(49, 4)] - tmp1 * njac[hook(47, i - 1)][hook(46, 1)][hook(50, 4)];
  lhs[hook(27, i)][hook(41, 0)][hook(40, 2)][hook(51, 4)] = -tmp2 * fjac[hook(44, i - 1)][hook(43, 2)][hook(52, 4)] - tmp1 * njac[hook(47, i - 1)][hook(46, 2)][hook(53, 4)];
  lhs[hook(27, i)][hook(41, 0)][hook(40, 3)][hook(54, 4)] = -tmp2 * fjac[hook(44, i - 1)][hook(43, 3)][hook(55, 4)] - tmp1 * njac[hook(47, i - 1)][hook(46, 3)][hook(56, 4)];
  lhs[hook(27, i)][hook(41, 0)][hook(40, 4)][hook(57, 4)] = -tmp2 * fjac[hook(44, i - 1)][hook(43, 4)][hook(58, 4)] - tmp1 * njac[hook(47, i - 1)][hook(46, 4)][hook(59, 4)] - tmp1 * 0.75;

  lhs[hook(27, i)][hook(41, 1)][hook(61, 0)][hook(60, 0)] = 1.0 + tmp1 * 2.0 * njac[hook(47, i)][hook(63, 0)][hook(62, 0)] + tmp1 * 2.0 * 0.75;
  lhs[hook(27, i)][hook(41, 1)][hook(61, 1)][hook(64, 0)] = tmp1 * 2.0 * njac[hook(47, i)][hook(63, 1)][hook(65, 0)];
  lhs[hook(27, i)][hook(41, 1)][hook(61, 2)][hook(66, 0)] = tmp1 * 2.0 * njac[hook(47, i)][hook(63, 2)][hook(67, 0)];
  lhs[hook(27, i)][hook(41, 1)][hook(61, 3)][hook(68, 0)] = tmp1 * 2.0 * njac[hook(47, i)][hook(63, 3)][hook(69, 0)];
  lhs[hook(27, i)][hook(41, 1)][hook(61, 4)][hook(70, 0)] = tmp1 * 2.0 * njac[hook(47, i)][hook(63, 4)][hook(71, 0)];

  lhs[hook(27, i)][hook(41, 1)][hook(61, 0)][hook(60, 1)] = tmp1 * 2.0 * njac[hook(47, i)][hook(63, 0)][hook(62, 1)];
  lhs[hook(27, i)][hook(41, 1)][hook(61, 1)][hook(64, 1)] = 1.0 + tmp1 * 2.0 * njac[hook(47, i)][hook(63, 1)][hook(65, 1)] + tmp1 * 2.0 * 0.75;
  lhs[hook(27, i)][hook(41, 1)][hook(61, 2)][hook(66, 1)] = tmp1 * 2.0 * njac[hook(47, i)][hook(63, 2)][hook(67, 1)];
  lhs[hook(27, i)][hook(41, 1)][hook(61, 3)][hook(68, 1)] = tmp1 * 2.0 * njac[hook(47, i)][hook(63, 3)][hook(69, 1)];
  lhs[hook(27, i)][hook(41, 1)][hook(61, 4)][hook(70, 1)] = tmp1 * 2.0 * njac[hook(47, i)][hook(63, 4)][hook(71, 1)];

  lhs[hook(27, i)][hook(41, 1)][hook(61, 0)][hook(60, 2)] = tmp1 * 2.0 * njac[hook(47, i)][hook(63, 0)][hook(62, 2)];
  lhs[hook(27, i)][hook(41, 1)][hook(61, 1)][hook(64, 2)] = tmp1 * 2.0 * njac[hook(47, i)][hook(63, 1)][hook(65, 2)];
  lhs[hook(27, i)][hook(41, 1)][hook(61, 2)][hook(66, 2)] = 1.0 + tmp1 * 2.0 * njac[hook(47, i)][hook(63, 2)][hook(67, 2)] + tmp1 * 2.0 * 0.75;
  lhs[hook(27, i)][hook(41, 1)][hook(61, 3)][hook(68, 2)] = tmp1 * 2.0 * njac[hook(47, i)][hook(63, 3)][hook(69, 2)];
  lhs[hook(27, i)][hook(41, 1)][hook(61, 4)][hook(70, 2)] = tmp1 * 2.0 * njac[hook(47, i)][hook(63, 4)][hook(71, 2)];

  lhs[hook(27, i)][hook(41, 1)][hook(61, 0)][hook(60, 3)] = tmp1 * 2.0 * njac[hook(47, i)][hook(63, 0)][hook(62, 3)];
  lhs[hook(27, i)][hook(41, 1)][hook(61, 1)][hook(64, 3)] = tmp1 * 2.0 * njac[hook(47, i)][hook(63, 1)][hook(65, 3)];
  lhs[hook(27, i)][hook(41, 1)][hook(61, 2)][hook(66, 3)] = tmp1 * 2.0 * njac[hook(47, i)][hook(63, 2)][hook(67, 3)];
  lhs[hook(27, i)][hook(41, 1)][hook(61, 3)][hook(68, 3)] = 1.0 + tmp1 * 2.0 * njac[hook(47, i)][hook(63, 3)][hook(69, 3)] + tmp1 * 2.0 * 0.75;
  lhs[hook(27, i)][hook(41, 1)][hook(61, 4)][hook(70, 3)] = tmp1 * 2.0 * njac[hook(47, i)][hook(63, 4)][hook(71, 3)];

  lhs[hook(27, i)][hook(41, 1)][hook(61, 0)][hook(60, 4)] = tmp1 * 2.0 * njac[hook(47, i)][hook(63, 0)][hook(62, 4)];
  lhs[hook(27, i)][hook(41, 1)][hook(61, 1)][hook(64, 4)] = tmp1 * 2.0 * njac[hook(47, i)][hook(63, 1)][hook(65, 4)];
  lhs[hook(27, i)][hook(41, 1)][hook(61, 2)][hook(66, 4)] = tmp1 * 2.0 * njac[hook(47, i)][hook(63, 2)][hook(67, 4)];
  lhs[hook(27, i)][hook(41, 1)][hook(61, 3)][hook(68, 4)] = tmp1 * 2.0 * njac[hook(47, i)][hook(63, 3)][hook(69, 4)];
  lhs[hook(27, i)][hook(41, 1)][hook(61, 4)][hook(70, 4)] = 1.0 + tmp1 * 2.0 * njac[hook(47, i)][hook(63, 4)][hook(71, 4)] + tmp1 * 2.0 * 0.75;

  lhs[hook(27, i)][hook(41, 2)][hook(73, 0)][hook(72, 0)] = tmp2 * fjac[hook(44, i + 1)][hook(75, 0)][hook(74, 0)] - tmp1 * njac[hook(47, i + 1)][hook(77, 0)][hook(76, 0)] - tmp1 * 0.75;
  lhs[hook(27, i)][hook(41, 2)][hook(73, 1)][hook(78, 0)] = tmp2 * fjac[hook(44, i + 1)][hook(75, 1)][hook(79, 0)] - tmp1 * njac[hook(47, i + 1)][hook(77, 1)][hook(80, 0)];
  lhs[hook(27, i)][hook(41, 2)][hook(73, 2)][hook(81, 0)] = tmp2 * fjac[hook(44, i + 1)][hook(75, 2)][hook(82, 0)] - tmp1 * njac[hook(47, i + 1)][hook(77, 2)][hook(83, 0)];
  lhs[hook(27, i)][hook(41, 2)][hook(73, 3)][hook(84, 0)] = tmp2 * fjac[hook(44, i + 1)][hook(75, 3)][hook(85, 0)] - tmp1 * njac[hook(47, i + 1)][hook(77, 3)][hook(86, 0)];
  lhs[hook(27, i)][hook(41, 2)][hook(73, 4)][hook(87, 0)] = tmp2 * fjac[hook(44, i + 1)][hook(75, 4)][hook(88, 0)] - tmp1 * njac[hook(47, i + 1)][hook(77, 4)][hook(89, 0)];

  lhs[hook(27, i)][hook(41, 2)][hook(73, 0)][hook(72, 1)] = tmp2 * fjac[hook(44, i + 1)][hook(75, 0)][hook(74, 1)] - tmp1 * njac[hook(47, i + 1)][hook(77, 0)][hook(76, 1)];
  lhs[hook(27, i)][hook(41, 2)][hook(73, 1)][hook(78, 1)] = tmp2 * fjac[hook(44, i + 1)][hook(75, 1)][hook(79, 1)] - tmp1 * njac[hook(47, i + 1)][hook(77, 1)][hook(80, 1)] - tmp1 * 0.75;
  lhs[hook(27, i)][hook(41, 2)][hook(73, 2)][hook(81, 1)] = tmp2 * fjac[hook(44, i + 1)][hook(75, 2)][hook(82, 1)] - tmp1 * njac[hook(47, i + 1)][hook(77, 2)][hook(83, 1)];
  lhs[hook(27, i)][hook(41, 2)][hook(73, 3)][hook(84, 1)] = tmp2 * fjac[hook(44, i + 1)][hook(75, 3)][hook(85, 1)] - tmp1 * njac[hook(47, i + 1)][hook(77, 3)][hook(86, 1)];
  lhs[hook(27, i)][hook(41, 2)][hook(73, 4)][hook(87, 1)] = tmp2 * fjac[hook(44, i + 1)][hook(75, 4)][hook(88, 1)] - tmp1 * njac[hook(47, i + 1)][hook(77, 4)][hook(89, 1)];

  lhs[hook(27, i)][hook(41, 2)][hook(73, 0)][hook(72, 2)] = tmp2 * fjac[hook(44, i + 1)][hook(75, 0)][hook(74, 2)] - tmp1 * njac[hook(47, i + 1)][hook(77, 0)][hook(76, 2)];
  lhs[hook(27, i)][hook(41, 2)][hook(73, 1)][hook(78, 2)] = tmp2 * fjac[hook(44, i + 1)][hook(75, 1)][hook(79, 2)] - tmp1 * njac[hook(47, i + 1)][hook(77, 1)][hook(80, 2)];
  lhs[hook(27, i)][hook(41, 2)][hook(73, 2)][hook(81, 2)] = tmp2 * fjac[hook(44, i + 1)][hook(75, 2)][hook(82, 2)] - tmp1 * njac[hook(47, i + 1)][hook(77, 2)][hook(83, 2)] - tmp1 * 0.75;
  lhs[hook(27, i)][hook(41, 2)][hook(73, 3)][hook(84, 2)] = tmp2 * fjac[hook(44, i + 1)][hook(75, 3)][hook(85, 2)] - tmp1 * njac[hook(47, i + 1)][hook(77, 3)][hook(86, 2)];
  lhs[hook(27, i)][hook(41, 2)][hook(73, 4)][hook(87, 2)] = tmp2 * fjac[hook(44, i + 1)][hook(75, 4)][hook(88, 2)] - tmp1 * njac[hook(47, i + 1)][hook(77, 4)][hook(89, 2)];

  lhs[hook(27, i)][hook(41, 2)][hook(73, 0)][hook(72, 3)] = tmp2 * fjac[hook(44, i + 1)][hook(75, 0)][hook(74, 3)] - tmp1 * njac[hook(47, i + 1)][hook(77, 0)][hook(76, 3)];
  lhs[hook(27, i)][hook(41, 2)][hook(73, 1)][hook(78, 3)] = tmp2 * fjac[hook(44, i + 1)][hook(75, 1)][hook(79, 3)] - tmp1 * njac[hook(47, i + 1)][hook(77, 1)][hook(80, 3)];
  lhs[hook(27, i)][hook(41, 2)][hook(73, 2)][hook(81, 3)] = tmp2 * fjac[hook(44, i + 1)][hook(75, 2)][hook(82, 3)] - tmp1 * njac[hook(47, i + 1)][hook(77, 2)][hook(83, 3)];
  lhs[hook(27, i)][hook(41, 2)][hook(73, 3)][hook(84, 3)] = tmp2 * fjac[hook(44, i + 1)][hook(75, 3)][hook(85, 3)] - tmp1 * njac[hook(47, i + 1)][hook(77, 3)][hook(86, 3)] - tmp1 * 0.75;
  lhs[hook(27, i)][hook(41, 2)][hook(73, 4)][hook(87, 3)] = tmp2 * fjac[hook(44, i + 1)][hook(75, 4)][hook(88, 3)] - tmp1 * njac[hook(47, i + 1)][hook(77, 4)][hook(89, 3)];

  lhs[hook(27, i)][hook(41, 2)][hook(73, 0)][hook(72, 4)] = tmp2 * fjac[hook(44, i + 1)][hook(75, 0)][hook(74, 4)] - tmp1 * njac[hook(47, i + 1)][hook(77, 0)][hook(76, 4)];
  lhs[hook(27, i)][hook(41, 2)][hook(73, 1)][hook(78, 4)] = tmp2 * fjac[hook(44, i + 1)][hook(75, 1)][hook(79, 4)] - tmp1 * njac[hook(47, i + 1)][hook(77, 1)][hook(80, 4)];
  lhs[hook(27, i)][hook(41, 2)][hook(73, 2)][hook(81, 4)] = tmp2 * fjac[hook(44, i + 1)][hook(75, 2)][hook(82, 4)] - tmp1 * njac[hook(47, i + 1)][hook(77, 2)][hook(83, 4)];
  lhs[hook(27, i)][hook(41, 2)][hook(73, 3)][hook(84, 4)] = tmp2 * fjac[hook(44, i + 1)][hook(75, 3)][hook(85, 4)] - tmp1 * njac[hook(47, i + 1)][hook(77, 3)][hook(86, 4)];
  lhs[hook(27, i)][hook(41, 2)][hook(73, 4)][hook(87, 4)] = tmp2 * fjac[hook(44, i + 1)][hook(75, 4)][hook(88, 4)] - tmp1 * njac[hook(47, i + 1)][hook(77, 4)][hook(89, 4)] - tmp1 * 0.75;
}