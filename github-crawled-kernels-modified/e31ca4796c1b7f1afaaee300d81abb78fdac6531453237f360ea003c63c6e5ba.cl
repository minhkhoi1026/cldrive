//{"ce":9,"ce[m]":8,"dtemp":7,"g_ce":1,"g_rms":2,"g_u":0,"gp0":4,"gp1":5,"gp2":6,"l_rms":3,"rms":17,"rms_local":10,"rms_other":16,"u":14,"u[k]":13,"u[k][j]":12,"u[k][j][i]":11,"u_exact":15}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void exact_solution(double xi, double eta, double zeta, double dtemp[5], constant double* g_ce) {
  int m;
  constant double(*ce)[13] = (constant double(*)[13])g_ce;

  for (m = 0; m < 5; m++) {
    dtemp[hook(7, m)] = ce[hook(9, m)][hook(8, 0)] + xi * (ce[hook(9, m)][hook(8, 1)] + xi * (ce[hook(9, m)][hook(8, 4)] + xi * (ce[hook(9, m)][hook(8, 7)] + xi * ce[hook(9, m)][hook(8, 10)]))) + eta * (ce[hook(9, m)][hook(8, 2)] + eta * (ce[hook(9, m)][hook(8, 5)] + eta * (ce[hook(9, m)][hook(8, 8)] + eta * ce[hook(9, m)][hook(8, 11)]))) + zeta * (ce[hook(9, m)][hook(8, 3)] + zeta * (ce[hook(9, m)][hook(8, 6)] + zeta * (ce[hook(9, m)][hook(8, 9)] + zeta * ce[hook(9, m)][hook(8, 12)])));
  }
}

kernel void error_norm(global double* g_u, constant double* g_ce, global double* g_rms, local double* l_rms, int gp0, int gp1, int gp2) {
  int i, j, k, m, lid;
  double xi, eta, zeta, u_exact[5], add;
  local double* rms_local;

  k = get_global_id(0) + 1;
  lid = get_local_id(0);
  rms_local = &l_rms[hook(3, lid * 5)];

  for (m = 0; m < 5; m++) {
    rms_local[hook(10, m)] = 0.0;
  }

  if (k < gp2) {
    global double(*u)[(64 / 2 * 2) + 1][(64 / 2 * 2) + 1][5] = (global double(*)[(64 / 2 * 2) + 1][(64 / 2 * 2) + 1][5]) g_u;

    zeta = (double)k * (1.0 / (double)(64 - 1));
    for (j = 0; j < gp1; j++) {
      eta = (double)j * (1.0 / (double)(64 - 1));
      for (i = 0; i < gp0; i++) {
        xi = (double)i * (1.0 / (double)(64 - 1));
        exact_solution(xi, eta, zeta, u_exact, g_ce);

        for (m = 0; m < 5; m++) {
          add = u[hook(14, k)][hook(13, j)][hook(12, i)][hook(11, m)] - u_exact[hook(15, m)];
          rms_local[hook(10, m)] = rms_local[hook(10, m)] + add * add;
        }
      }
    }
  }

  barrier(0x01);

  if (lid == 0) {
    for (i = 1; i < get_local_size(0); i++) {
      local double* rms_other = &l_rms[hook(3, i * 5)];
      for (m = 0; m < 5; m++) {
        rms_local[hook(10, m)] += rms_other[hook(16, m)];
      }
    }

    global double* rms = &g_rms[hook(2, get_group_id(0) * 5)];
    for (m = 0; m < 5; m++) {
      rms[hook(17, m)] = rms_local[hook(10, m)];
    }
  }
}