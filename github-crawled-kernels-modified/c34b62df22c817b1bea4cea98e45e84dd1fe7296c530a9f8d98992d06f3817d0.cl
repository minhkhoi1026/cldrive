//{"V":3,"Xq":4,"csf_sa":5,"csf_sr_par":6,"la":0,"rod_sensitivity":7,"s_A":1,"s_R":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void jointRodConeSens_rodSens(constant double* la, global double* s_A, global double* s_R, global double* V, global double* Xq, constant double* csf_sa, constant double* csf_sr_par, double rod_sensitivity) {
  int pos = get_global_id(0);
  int lastIndex = get_global_size(0) - 1;

  double cvi_sens_drop = csf_sa[hook(5, 1)];
  double cvi_trans_slope = csf_sa[hook(5, 2)];
  double cvi_low_slope = csf_sa[hook(5, 3)];

  double peak_l = csf_sr_par[hook(6, 0)];
  double low_s = csf_sr_par[hook(6, 1)];
  double low_exp = csf_sr_par[hook(6, 2)];
  double high_s = csf_sr_par[hook(6, 3)];
  double high_exp = csf_sr_par[hook(6, 4)];
  double rod_sens = csf_sr_par[hook(6, 5)];

  s_A[hook(1, pos)] = csf_sa[hook(5, 0)] * pow(pow((cvi_sens_drop / la[hook(0, pos)]), cvi_trans_slope) + 1.0, -cvi_low_slope);

  if (la[hook(0, pos)] > peak_l)
    s_R[hook(2, pos)] = exp(-pow(fabs(log10(la[hook(0, pos)] / peak_l)), high_exp) / high_s) * rod_sens;
  else
    s_R[hook(2, pos)] = exp(-pow(fabs(log10(la[hook(0, pos)] / peak_l)), low_exp) / low_s) * rod_sens;

  s_R[hook(2, pos)] = (s_R[hook(2, pos)] * pow(10.0, rod_sens)) * pow(10.0, rod_sensitivity);

  V[hook(3, pos)] = max(s_A[hook(1, pos)] - s_R[hook(2, pos)], 1e-3);
  Xq[hook(4, pos)] = min(la[hook(0, pos)] * 2.0, la[hook(0, lastIndex)]);

  return;
}