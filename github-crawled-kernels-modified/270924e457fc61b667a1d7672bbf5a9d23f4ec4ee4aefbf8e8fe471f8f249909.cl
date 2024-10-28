//{"a_b":16,"a_g":15,"a_r":14,"cov_Ip_b":11,"cov_Ip_g":10,"cov_Ip_r":9,"height":13,"mean_Ib":2,"mean_Ig":1,"mean_Ir":0,"mean_cv":17,"var_Ibb":8,"var_Igb":7,"var_Igg":6,"var_Irb":5,"var_Irg":4,"var_Irr":3,"width":12}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void cent_filter_8U(global const uchar* mean_Ir, global const uchar* mean_Ig, global const uchar* mean_Ib, global const uchar* var_Irr, global const uchar* var_Irg, global const uchar* var_Irb, global const uchar* var_Igg, global const uchar* var_Igb, global const uchar* var_Ibb, global const uchar* cov_Ip_r, global const uchar* cov_Ip_g, global const uchar* cov_Ip_b, const int width, const int height, global uchar* a_r, global uchar* a_g, global uchar* a_b, global uchar* mean_cv) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);
  const int d = get_global_id(2);
  const int eps = 1;

  const int offset3D = (((d * height) + y) * width) + x;
  const int offset2D = (y * width) + x;

  uchar c0 = cov_Ip_r[hook(9, offset3D)];
  uchar c1 = cov_Ip_g[hook(10, offset3D)];
  uchar c2 = cov_Ip_b[hook(11, offset3D)];
  uchar a11 = var_Irr[hook(3, offset2D)] + eps;
  uchar a12 = var_Irg[hook(4, offset2D)];
  uchar a13 = var_Irb[hook(5, offset2D)];
  uchar a21 = var_Irg[hook(4, offset2D)];
  uchar a22 = var_Igg[hook(6, offset2D)] + eps;
  uchar a23 = var_Igb[hook(7, offset2D)];
  uchar a31 = var_Irb[hook(5, offset2D)];
  uchar a32 = var_Igb[hook(7, offset2D)];
  uchar a33 = var_Ibb[hook(8, offset2D)] + eps;

  uchar DET = 1 / (a11 * (a33 * a22 - a32 * a23) - a21 * (a33 * a12 - a32 * a13) + a31 * (a23 * a12 - a22 * a13));

  a_r[hook(14, offset3D)] = DET * (c0 * (a33 * a22 - a32 * a23) + c1 * (a31 * a23 - a33 * a21) + c2 * (a32 * a21 - a31 * a22));
  a_g[hook(15, offset3D)] = DET * (c0 * (a32 * a13 - a33 * a12) + c1 * (a33 * a11 - a31 * a13) + c2 * (a31 * a12 - a32 * a11));
  a_b[hook(16, offset3D)] = DET * (c0 * (a23 * a12 - a22 * a13) + c1 * (a21 * a13 - a23 * a11) + c2 * (a22 * a11 - a21 * a12));

  mean_cv[hook(17, offset3D)] = mean_cv[hook(17, offset3D)] - ((a_r[hook(14, offset3D)] * mean_Ir[hook(0, offset2D)]) + (a_g[hook(15, offset3D)] * mean_Ig[hook(1, offset2D)]) + (a_b[hook(16, offset3D)] * mean_Ib[hook(2, offset2D)]));
}