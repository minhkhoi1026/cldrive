//{"ce":8,"ce[m]":7,"dtemp":6,"g_rhs":0,"g_rms":1,"l_rms":2,"nx2":3,"ny2":4,"nz2":5,"rhs":13,"rhs[k]":12,"rhs[k][j]":11,"rhs[k][j][i]":10,"rms":15,"rms_local":9,"rms_other":14}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void exact_solution(double xi, double eta, double zeta, double dtemp[5], constant double* g_ce) {
  int m;
  constant double(*ce)[13] = (constant double(*)[13])g_ce;

  for (m = 0; m < 5; m++) {
    dtemp[hook(6, m)] = ce[hook(8, m)][hook(7, 0)] + xi * (ce[hook(8, m)][hook(7, 1)] + xi * (ce[hook(8, m)][hook(7, 4)] + xi * (ce[hook(8, m)][hook(7, 7)] + xi * ce[hook(8, m)][hook(7, 10)]))) + eta * (ce[hook(8, m)][hook(7, 2)] + eta * (ce[hook(8, m)][hook(7, 5)] + eta * (ce[hook(8, m)][hook(7, 8)] + eta * ce[hook(8, m)][hook(7, 11)]))) + zeta * (ce[hook(8, m)][hook(7, 3)] + zeta * (ce[hook(8, m)][hook(7, 6)] + zeta * (ce[hook(8, m)][hook(7, 9)] + zeta * ce[hook(8, m)][hook(7, 12)])));
  }
}

kernel void rhs_norm(global double* g_rhs, global double* g_rms, local double* l_rms, int nx2, int ny2, int nz2) {
  int i, j, k, m, lid;
  double add;
  local double* rms_local;

  k = get_global_id(0) + 1;
  lid = get_local_id(0);
  rms_local = &l_rms[hook(2, lid * 5)];

  for (m = 0; m < 5; m++) {
    rms_local[hook(9, m)] = 0.0;
  }

  if (k <= nz2) {
    global double(*rhs)[(64 / 2 * 2) + 1][(64 / 2 * 2) + 1][5] = (global double(*)[(64 / 2 * 2) + 1][(64 / 2 * 2) + 1][5]) g_rhs;

    for (j = 1; j <= ny2; j++) {
      for (i = 1; i <= nx2; i++) {
        for (m = 0; m < 5; m++) {
          add = rhs[hook(13, k)][hook(12, j)][hook(11, i)][hook(10, m)];
          rms_local[hook(9, m)] = rms_local[hook(9, m)] + add * add;
        }
      }
    }
  }

  barrier(0x01);

  if (lid == 0) {
    for (i = 1; i < get_local_size(0); i++) {
      local double* rms_other = &l_rms[hook(2, i * 5)];
      for (m = 0; m < 5; m++) {
        rms_local[hook(9, m)] += rms_other[hook(14, m)];
      }
    }

    global double* rms = &g_rms[hook(1, get_group_id(0) * 5)];
    for (m = 0; m < 5; m++) {
      rms[hook(15, m)] = rms_local[hook(9, m)];
    }
  }
}