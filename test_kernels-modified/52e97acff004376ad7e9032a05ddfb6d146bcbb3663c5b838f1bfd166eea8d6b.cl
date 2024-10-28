//{"E_loc":9,"Ep":8,"Es":7,"KirchP_gl":14,"KirchS_gl":13,"a_glo":4,"b_glo":5,"beamOEglo":10,"beam_OE_loc_path":12,"c_glo":6,"chbar":2,"cosGamma":3,"fullnrays":1,"imageLength":0,"oe_surface_normal":11}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant double fourPi = 12.566370614359172;
constant double2 cmp0 = (double2)(0, 0);
constant double2 cmpi1 = (double2)(0, 1);
double2 prod_c(double2 a, double2 b) {
  return (double2)(a.x * b.x - a.y * b.y, a.y * b.x + a.x * b.y);
}
double2 conj_c(double2 a) {
  return (double2)(a.x, -a.y);
}
double abs_c(double2 a) {
  return sqrt(a.x * a.x + a.y * a.y);
}
double abs_c2(double2 a) {
  return (a.x * a.x + a.y * a.y);
}

kernel void integrate_fraunhofer(const unsigned int imageLength, const unsigned int fullnrays, const double chbar, global double* cosGamma, global double* a_glo, global double* b_glo, global double* c_glo, global double2* Es, global double2* Ep, global double* E_loc, global double3* beamOEglo, global double3* oe_surface_normal, global double* beam_OE_loc_path, global double2* KirchS_gl, global double2* KirchP_gl)

{
  unsigned int i;

  double3 beam_angle_glo;
  double2 gi, KirchS_loc, KirchP_loc;
  double pathAfter, cosAlpha, cr;
  unsigned int ii_screen = get_global_id(0);

  double k, phase;

  KirchS_loc = (double2)(0, 0);
  KirchP_loc = KirchS_loc;

  beam_angle_glo.x = a_glo[hook(4, ii_screen)];
  beam_angle_glo.y = b_glo[hook(5, ii_screen)];
  beam_angle_glo.z = c_glo[hook(6, ii_screen)];

  for (i = 0; i < fullnrays; i++) {
    pathAfter = -dot(beam_angle_glo, beamOEglo[hook(10, i)]);
    cosAlpha = dot(beam_angle_glo, oe_surface_normal[hook(11, i)]);
    k = E_loc[hook(9, i)] / chbar * 1.e7;

    phase = k * (pathAfter + beam_OE_loc_path[hook(12, i)]);
    cr = (cosAlpha + cosGamma[hook(3, i)]) / pathAfter;
    gi = (double2)(cr * cos(phase), cr * sin(phase));
    KirchS_loc += prod_c(gi, Es[hook(7, i)]);
    KirchP_loc += prod_c(gi, Ep[hook(8, i)]);
  }
  mem_fence(0x01);

  KirchS_gl[hook(13, ii_screen)] = -prod_c(cmpi1 * k / fourPi, KirchS_loc);
  KirchP_gl[hook(14, ii_screen)] = -prod_c(cmpi1 * k / fourPi, KirchP_loc);
  mem_fence(0x01);
}