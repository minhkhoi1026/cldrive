//{"F":11,"F[0]":10,"F[1]":12,"F[2]":13,"F[3]":14,"F[k]":20,"G":16,"G[0]":15,"G[1]":17,"G[2]":18,"G[3]":19,"G[k]":21,"H":9,"H0":3,"K":1,"X":5,"Y":4,"alpha":8,"dx":7,"dy":6,"p":2,"w_n":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float wenoM(float fgm1, float fg, float fgp1);
float wenoP(float fgm1, float fg, float fgp1);
float wenoM(float fgm1, float fg, float fgp1) {
  float alpha0 = (1.0 / 3.0) / ((10e-6 + ((fg - fgm1) * (fg - fgm1))) * (10e-6 + ((fg - fgm1) * (fg - fgm1))));
  float alpha1 = (2.0 / 3.0) / ((10e-6 + ((fgp1 - fg) * (fgp1 - fg))) * (10e-6 + ((fgp1 - fg) * (fgp1 - fg))));

  float sum = alpha0 + alpha1;

  return ((alpha0 / sum) * (0.5 * (-fgm1 + 3 * fg)) + (alpha1 / sum) * (0.5 * (fg + fgp1)));
}

float wenoP(float fgm1, float fg, float fgp1) {
  float alpha0 = (2.0 / 3.0) / ((10e-6 + ((fg - fgm1) * (fg - fgm1))) * (10e-6 + ((fg - fgm1) * (fg - fgm1))));
  float alpha1 = (1.0 / 3.0) / ((10e-6 + ((fgp1 - fg) * (fgp1 - fg))) * (10e-6 + ((fgp1 - fg) * (fgp1 - fg))));

  float sum = alpha0 + alpha1;

  return ((alpha0 / sum) * (0.5 * (fg + fgm1)) + (alpha1 / sum) * (0.5 * (-fgp1 + 3 * fg)));
}

kernel void rhs(global float* w_n, global float* K, global float* p, global float* H0, const int Y, const int X, const float dy, const float dx, const float alpha) {
  int i = get_global_id(0);
  int j = get_global_id(1);

  if ((i < 2) || (i >= X - 2))
    return;
  if ((j < 2) || (j >= Y - 2))
    return;

  float F[4][5], G[4][5], H[4];
  int ix = 2;
  float p_prime_x = (p[hook(2, (j * X) + i + 1)] - p[hook(2, (j * X) + i - 1)]) / (2 * dx);
  float p_prime_y = (p[hook(2, ((j + 1) * X) + i)] - p[hook(2, ((j - 1) * X) + i)]) / (2 * dy);

  H[hook(9, 0)] = H0[hook(3, (j * X) + i)];
  H[hook(9, 1)] = -p_prime_x;
  H[hook(9, 2)] = -p_prime_y;
  H[hook(9, 3)] = 0;

  for (int q = -2; q <= 2; q++) {
    F[hook(11, 0)][hook(10, ix + q)] = w_n[hook(0, (0 * X * Y) + (j * X) + i + q)] * (w_n[hook(0, (1 * X * Y) + (j * X) + i + q)] / w_n[hook(0, (0 * X * Y) + (j * X) + i + q)]);
    F[hook(11, 1)][hook(12, ix + q)] = w_n[hook(0, (0 * X * Y) + (j * X) + i + q)] * ((w_n[hook(0, (1 * X * Y) + (j * X) + i + q)] / w_n[hook(0, (0 * X * Y) + (j * X) + i + q)]) * (w_n[hook(0, (1 * X * Y) + (j * X) + i + q)] / w_n[hook(0, (0 * X * Y) + (j * X) + i + q)]));

    F[hook(11, 2)][hook(13, ix + q)] = w_n[hook(0, (0 * X * Y) + (j * X) + i + q)] * (w_n[hook(0, (1 * X * Y) + (j * X) + i + q)] / w_n[hook(0, (0 * X * Y) + (j * X) + i + q)]) * (w_n[hook(0, (2 * X * Y) + (j * X) + i + q)] / w_n[hook(0, (0 * X * Y) + (j * X) + i + q)]);
    F[hook(11, 3)][hook(14, ix + q)] = w_n[hook(0, (0 * X * Y) + (j * X) + i + q)] * (w_n[hook(0, (1 * X * Y) + (j * X) + i + q)] / w_n[hook(0, (0 * X * Y) + (j * X) + i + q)]) * (w_n[hook(0, (3 * X * Y) + (j * X) + i + q)] / w_n[hook(0, (0 * X * Y) + (j * X) + i + q)]);

    G[hook(16, 0)][hook(15, ix + q)] = w_n[hook(0, (0 * X * Y) + ((j + q) * X) + i)] * (w_n[hook(0, (2 * X * Y) + ((j + q) * X) + i)] / w_n[hook(0, (0 * X * Y) + ((j + q) * X) + i)]);
    G[hook(16, 1)][hook(17, ix + q)] = w_n[hook(0, (0 * X * Y) + ((j + q) * X) + i)] * (w_n[hook(0, (2 * X * Y) + ((j + q) * X) + i)] / w_n[hook(0, (0 * X * Y) + ((j + q) * X) + i)]) * (w_n[hook(0, (1 * X * Y) + ((j + q) * X) + i)] / w_n[hook(0, (0 * X * Y) + ((j + q) * X) + i)]);
    G[hook(16, 2)][hook(18, ix + q)] = w_n[hook(0, (0 * X * Y) + ((j + q) * X) + i)] * ((w_n[hook(0, (2 * X * Y) + ((j + q) * X) + i)] / w_n[hook(0, (0 * X * Y) + ((j + q) * X) + i)]) * (w_n[hook(0, (2 * X * Y) + ((j + q) * X) + i)] / w_n[hook(0, (0 * X * Y) + ((j + q) * X) + i)]));

    G[hook(16, 3)][hook(19, ix + q)] = w_n[hook(0, (0 * X * Y) + ((j + q) * X) + i)] * (w_n[hook(0, (2 * X * Y) + ((j + q) * X) + i)] / w_n[hook(0, (0 * X * Y) + ((j + q) * X) + i)]) * (w_n[hook(0, (3 * X * Y) + ((j + q) * X) + i)] / w_n[hook(0, (0 * X * Y) + ((j + q) * X) + i)]);
  }

  for (int k = 0; k < 4; k++) {
    int ii, jj;
    float fgm1, fg, fgp1, vm1f, vm2f, vp1f, vp2f, vm1g, vm2g, vp1g, vp2g;

    ii = i - 1;
    ix = 2 - 1;
    fgm1 = 0.5 * (F[hook(11, k)][hook(20, ix - 1)] + alpha * w_n[hook(0, (k * X * Y) + (j * X) + ii - 1)]);
    fg = 0.5 * (F[hook(11, k)][hook(20, ix)] + alpha * w_n[hook(0, (k * X * Y) + (j * X) + ii)]);
    fgp1 = 0.5 * (F[hook(11, k)][hook(20, ix + 1)] + alpha * w_n[hook(0, (k * X * Y) + (j * X) + ii + 1)]);

    vm1f = wenoM(fgm1, fg, fgp1);

    ii++;
    ix++;
    fgm1 = 0.5 * (F[hook(11, k)][hook(20, ix - 1)] - alpha * w_n[hook(0, (k * X * Y) + (j * X) + ii - 1)]);
    fg = 0.5 * (F[hook(11, k)][hook(20, ix)] - alpha * w_n[hook(0, (k * X * Y) + (j * X) + ii)]);
    fgp1 = 0.5 * (F[hook(11, k)][hook(20, ix + 1)] - alpha * w_n[hook(0, (k * X * Y) + (j * X) + ii + 1)]);

    vp1f = wenoP(fgm1, fg, fgp1);

    fgm1 = 0.5 * (F[hook(11, k)][hook(20, ix - 1)] + alpha * w_n[hook(0, (k * X * Y) + (j * X) + ii - 1)]);
    fg = 0.5 * (F[hook(11, k)][hook(20, ix)] + alpha * w_n[hook(0, (k * X * Y) + (j * X) + ii)]);
    fgp1 = 0.5 * (F[hook(11, k)][hook(20, ix + 1)] + alpha * w_n[hook(0, (k * X * Y) + (j * X) + ii + 1)]);

    vm2f = wenoM(fgm1, fg, fgp1);

    ii++;
    ix++;
    fgm1 = 0.5 * (F[hook(11, k)][hook(20, ix - 1)] - alpha * w_n[hook(0, (k * X * Y) + (j * X) + ii - 1)]);
    fg = 0.5 * (F[hook(11, k)][hook(20, ix)] - alpha * w_n[hook(0, (k * X * Y) + (j * X) + ii)]);
    fgp1 = 0.5 * (F[hook(11, k)][hook(20, ix + 1)] - alpha * w_n[hook(0, (k * X * Y) + (j * X) + ii + 1)]);

    vp2f = wenoP(fgm1, fg, fgp1);

    jj = j - 1;
    ix = 2 - 1;
    fgm1 = 0.5 * (G[hook(16, k)][hook(21, ix - 1)] + alpha * w_n[hook(0, (k * X * Y) + ((jj - 1) * X) + i)]);
    fg = 0.5 * (G[hook(16, k)][hook(21, ix)] + alpha * w_n[hook(0, (k * X * Y) + ((jj) * X) + i)]);
    fgp1 = 0.5 * (G[hook(16, k)][hook(21, ix + 1)] + alpha * w_n[hook(0, (k * X * Y) + ((jj + 1) * X) + i)]);

    vm1g = wenoM(fgm1, fg, fgp1);

    jj++;
    ix++;
    fgm1 = 0.5 * (G[hook(16, k)][hook(21, ix - 1)] - alpha * w_n[hook(0, (k * X * Y) + ((jj - 1) * X) + i)]);
    fg = 0.5 * (G[hook(16, k)][hook(21, ix)] - alpha * w_n[hook(0, (k * X * Y) + ((jj) * X) + i)]);
    fgp1 = 0.5 * (G[hook(16, k)][hook(21, ix + 1)] - alpha * w_n[hook(0, (k * X * Y) + ((jj + 1) * X) + i)]);

    vp1g = wenoP(fgm1, fg, fgp1);

    fgm1 = 0.5 * (G[hook(16, k)][hook(21, ix - 1)] + alpha * w_n[hook(0, (k * X * Y) + ((jj - 1) * X) + i)]);
    fg = 0.5 * (G[hook(16, k)][hook(21, ix)] + alpha * w_n[hook(0, (k * X * Y) + ((jj) * X) + i)]);
    fgp1 = 0.5 * (G[hook(16, k)][hook(21, ix + 1)] + alpha * w_n[hook(0, (k * X * Y) + ((jj + 1) * X) + i)]);

    vm2g = wenoM(fgm1, fg, fgp1);

    jj++;
    ix++;
    fgm1 = 0.5 * (G[hook(16, k)][hook(21, ix - 1)] - alpha * w_n[hook(0, (k * X * Y) + ((jj - 1) * X) + i)]);
    fg = 0.5 * (G[hook(16, k)][hook(21, ix)] - alpha * w_n[hook(0, (k * X * Y) + ((jj) * X) + i)]);
    fgp1 = 0.5 * (G[hook(16, k)][hook(21, ix + 1)] - alpha * w_n[hook(0, (k * X * Y) + ((jj + 1) * X) + i)]);

    vp2g = wenoP(fgm1, fg, fgp1);

    K[hook(1, (k * X * Y) + (j * X) + i)] = (vm1f + vp1f - vm2f - vp2f) / dx + (vm1g + vp1g - vm2g - vp2g) / dy + H[hook(9, k)];
  }
}