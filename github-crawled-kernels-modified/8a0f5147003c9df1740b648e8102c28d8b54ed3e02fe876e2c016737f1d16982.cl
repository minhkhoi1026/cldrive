//{"alpha":7,"alpha_is_zero":11,"apply_eltwise":12,"beta":8,"c":1,"cc":0,"co":9,"eltwise_alpha":13,"eltwise_beta":14,"eltwise_scale":15,"ldc":6,"m":4,"n":5,"offset_c":3,"offset_co":10,"trc":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void gen12lp_gemm_scale_x8x8s32(global int* cc, global int* c, char trc, int offset_c, int m, int n, int ldc, float alpha, float beta, global int* co, int offset_co, int alpha_is_zero, int apply_eltwise, float eltwise_alpha, float eltwise_beta, float eltwise_scale) {
  int idx = get_group_id(0);
  int idy = get_group_id(1);
  int lid = get_local_id(0);
  int j;
  int offset_cc = 0;
  int offset_x = 0;
  int ldcc = m;

  m -= 32 * idx;
  if (m > 32)
    m = 32;
  n -= 16 * idy;
  if (n > 16)
    n = 16;
  m -= 32 * lid / 16;
  if ((m <= 0) || (n <= 0))
    return;
  offset_cc = 32 * idx + 32 * lid / 16 + 16 * idy * ldcc;
  offset_c += 32 * idx + 32 * lid / 16 + 16 * idy * ldc;
  if (trc == 'C')
    offset_co += 32 * idx + 32 * lid / 16;
  if (trc == 'R')
    offset_co += 16 * idy;
  for (j = 0; j < n; j++) {
    if (m > 0) {
      float val = (alpha_is_zero ? 0 : alpha) * cc[hook(0, offset_cc + 0)] + beta * c[hook(1, offset_c + 0)];
      ;
      c[hook(1, offset_c)] = convert_int_sat_rte(val + (co ? co[hook(9, offset_co + offset_x)] : 0));
      if (trc == 'C') {
        offset_x++;
      }
    }
    if (m > 1) {
      float val = (alpha_is_zero ? 0 : alpha) * cc[hook(0, offset_cc + 1)] + beta * c[hook(1, offset_c + 1)];
      ;
      c[hook(1, offset_c + 1)] = convert_int_sat_rte(val + (co ? co[hook(9, offset_co + offset_x)] : 0));
    }

    offset_cc += ldcc;
    offset_c += ldc;
    if (trc == 'C')
      offset_x = 0;
    if (trc == 'R')
      offset_x++;
  }
}