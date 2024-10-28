//{"RKLOW":1,"T":0,"TCONV":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ratt10_kernel(global const float* T, global float* RKLOW, float TCONV) {
  const float TEMP = T[hook(0, get_global_id(0))] * TCONV;
  const float ALOGT = log(TEMP);

  (RKLOW[hook(1, (((1) - 1) * (4)) + (get_global_id(0)))]) = exp(4.22794408e1f - 9.e-1f * ALOGT + ((8.55468335e2f) * (1.0f / (TEMP))));
  (RKLOW[hook(1, (((2) - 1) * (4)) + (get_global_id(0)))]) = exp(6.37931383e1f - 3.42e0f * ALOGT - ((4.24463259e4f) * (1.0f / (TEMP))));
  (RKLOW[hook(1, (((3) - 1) * (4)) + (get_global_id(0)))]) = exp(6.54619238e1f - 3.74e0f * ALOGT - ((9.74227469e2f) * (1.0f / (TEMP))));
  (RKLOW[hook(1, (((4) - 1) * (4)) + (get_global_id(0)))]) = exp(5.55621468e1f - 2.57e0f * ALOGT - ((7.17083751e2f) * (1.0f / (TEMP))));
  (RKLOW[hook(1, (((5) - 1) * (4)) + (get_global_id(0)))]) = exp(6.33329483e1f - 3.14e0f * ALOGT - ((6.18956501e2f) * (1.0f / (TEMP))));
  (RKLOW[hook(1, (((6) - 1) * (4)) + (get_global_id(0)))]) = exp(7.69748493e1f - 5.11e0f * ALOGT - ((3.57032226e3f) * (1.0f / (TEMP))));
  (RKLOW[hook(1, (((7) - 1) * (4)) + (get_global_id(0)))]) = exp(6.98660102e1f - 4.8e0f * ALOGT - ((2.79788467e3f) * (1.0f / (TEMP))));
  (RKLOW[hook(1, (((8) - 1) * (4)) + (get_global_id(0)))]) = exp(7.68923562e1f - 4.76e0f * ALOGT - ((1.22784867e3f) * (1.0f / (TEMP))));
  (RKLOW[hook(1, (((9) - 1) * (4)) + (get_global_id(0)))]) = exp(1.11312542e2f - 9.588e0f * ALOGT - ((2.566405e3f) * (1.0f / (TEMP))));
  (RKLOW[hook(1, (((10) - 1) * (4)) + (get_global_id(0)))]) = exp(1.15700234e2f - 9.67e0f * ALOGT - ((3.13000767e3f) * (1.0f / (TEMP))));
  (RKLOW[hook(1, (((11) - 1) * (4)) + (get_global_id(0)))]) = exp(3.54348644e1f - 6.4e-1f * ALOGT - ((2.50098684e4f) * (1.0f / (TEMP))));
  (RKLOW[hook(1, (((12) - 1) * (4)) + (get_global_id(0)))]) = exp(6.3111756e1f - 3.4e0f * ALOGT - ((1.80145126e4f) * (1.0f / (TEMP))));
  (RKLOW[hook(1, (((13) - 1) * (4)) + (get_global_id(0)))]) = exp(9.57409899e1f - 7.64e0f * ALOGT - ((5.98827834e3f) * (1.0f / (TEMP))));
  (RKLOW[hook(1, (((14) - 1) * (4)) + (get_global_id(0)))]) = exp(6.9414025e1f - 3.86e0f * ALOGT - ((1.67067934e3f) * (1.0f / (TEMP))));
  (RKLOW[hook(1, (((15) - 1) * (4)) + (get_global_id(0)))]) = exp(1.35001549e2f - 1.194e1f * ALOGT - ((4.9163262e3f) * (1.0f / (TEMP))));
  (RKLOW[hook(1, (((16) - 1) * (4)) + (get_global_id(0)))]) = exp(9.14494773e1f - 7.297e0f * ALOGT - ((2.36511834e3f) * (1.0f / (TEMP))));
  (RKLOW[hook(1, (((17) - 1) * (4)) + (get_global_id(0)))]) = exp(1.17075165e2f - 9.31e0f * ALOGT - ((5.02512164e4f) * (1.0f / (TEMP))));
  (RKLOW[hook(1, (((18) - 1) * (4)) + (get_global_id(0)))]) = exp(9.68908955e1f - 7.62e0f * ALOGT - ((3.50742017e3f) * (1.0f / (TEMP))));
  (RKLOW[hook(1, (((19) - 1) * (4)) + (get_global_id(0)))]) = exp(9.50941235e1f - 7.08e0f * ALOGT - ((3.36400342e3f) * (1.0f / (TEMP))));
  (RKLOW[hook(1, (((20) - 1) * (4)) + (get_global_id(0)))]) = exp(1.38440285e2f - 1.2e1f * ALOGT - ((3.00309643e3f) * (1.0f / (TEMP))));
  (RKLOW[hook(1, (((21) - 1) * (4)) + (get_global_id(0)))]) = exp(8.93324137e1f - 6.66e0f * ALOGT - ((3.52251667e3f) * (1.0f / (TEMP))));
}