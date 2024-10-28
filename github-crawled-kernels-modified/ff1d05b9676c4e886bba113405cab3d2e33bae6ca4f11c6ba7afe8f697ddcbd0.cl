//{"Ep":6,"Es":5,"KirchA_gl":12,"KirchB_gl":13,"KirchC_gl":14,"KirchP_gl":11,"KirchS_gl":10,"beamOEglo":8,"cosGamma":4,"fullnrays":0,"k":7,"oe_surface_normal":9,"x_glo":1,"y_glo":2,"z_glo":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant const float twoPi = (float)6.283185307179586476;
constant const float invTwoPi = (float)(1. / 6.283185307179586476);
constant const float invFourPi = (float)0.07957747154594767;
constant float2 cmp0 = (float2)(0, 0);
constant float2 cmpi1 = (float2)(0, 1);
constant const float2 cfactor = (float2)(0, -0.07957747154594767);
float2 prod_c(float2 a, float2 b) {
  return (float2)(a.x * b.x - a.y * b.y, a.y * b.x + a.x * b.y);
}
float2 prod_c_d(float2 a, float2 b) {
  return (float2)(a.x * b.x - a.y * b.y, a.y * b.x + a.x * b.y);
}
float to2pi(float val) {
  return val - trunc(val * invTwoPi) * twoPi;
}
kernel void integrate_kirchhoff(

    const unsigned int fullnrays, global float* x_glo, global float* y_glo, global float* z_glo, global float* cosGamma, global float2* Es, global float2* Ep, global float* k, global float3* beamOEglo, global float3* oe_surface_normal,

    global float2* KirchS_gl, global float2* KirchP_gl, global float2* KirchA_gl, global float2* KirchB_gl, global float2* KirchC_gl) {
  unsigned int i;

  float3 beam_coord_glo, beam_angle_glo;
  float2 gi, giEs, giEp, cfactor;
  float2 KirchS_loc, KirchP_loc;
  float2 KirchA_loc, KirchB_loc, KirchC_loc;
  float pathAfter, cosAlpha, cr, sinphase, cosphase;
  unsigned int ii_screen = get_global_id(0);
  float phase;
  float invPathAfter, kip;

  KirchS_loc = cmp0;
  KirchP_loc = cmp0;
  KirchA_loc = cmp0;
  KirchB_loc = cmp0;
  KirchC_loc = cmp0;

  beam_coord_glo.x = x_glo[hook(1, ii_screen)];
  beam_coord_glo.y = y_glo[hook(2, ii_screen)];
  beam_coord_glo.z = z_glo[hook(3, ii_screen)];
  for (i = 0; i < fullnrays; i++) {
    beam_angle_glo = beam_coord_glo - beamOEglo[hook(8, i)];
    pathAfter = length(beam_angle_glo);
    invPathAfter = 1. / pathAfter;

    cosAlpha = dot(beam_angle_glo, oe_surface_normal[hook(9, i)]) * invPathAfter;
    phase = k[hook(7, i)] * pathAfter;

    kip = k[hook(7, i)] * invPathAfter;
    cr = kip * (cosAlpha + cosGamma[hook(4, i)]);
    sinphase = sincos(phase, &cosphase);
    gi = (float2)(cr * cosphase, cr * sinphase);
    giEs = prod_c(gi, Es[hook(5, i)]);
    giEp = prod_c(gi, Ep[hook(6, i)]);
    KirchS_loc += giEs;
    KirchP_loc += giEp;
    gi = k[hook(7, i)] * kip * (giEs + giEp);
    KirchA_loc += prod_c(gi, beam_angle_glo.x);
    KirchB_loc += prod_c(gi, beam_angle_glo.y);
    KirchC_loc += prod_c(gi, beam_angle_glo.z);
  }
  mem_fence(0x01);

  cfactor = -cmpi1 * invFourPi;
  KirchS_gl[hook(10, ii_screen)] = prod_c(cfactor, KirchS_loc);
  KirchP_gl[hook(11, ii_screen)] = prod_c(cfactor, KirchP_loc);
  KirchA_gl[hook(12, ii_screen)] = KirchA_loc * invFourPi;
  KirchB_gl[hook(13, ii_screen)] = KirchB_loc * invFourPi;
  KirchC_gl[hook(14, ii_screen)] = KirchC_loc * invFourPi;

  mem_fence(0x01);
}