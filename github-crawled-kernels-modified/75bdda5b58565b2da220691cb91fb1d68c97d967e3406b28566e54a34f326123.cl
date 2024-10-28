//{"buf":15,"buf[i]":14,"buf[im1]":25,"buf[ip1]":24,"ce":11,"ce[m]":10,"cuf":16,"dtemp":9,"forcing":21,"forcing[k]":20,"forcing[k][j]":19,"forcing[k][j][i]":18,"g_buf":2,"g_ce":5,"g_cuf":3,"g_forcing":0,"g_q":4,"g_ue":1,"gp0":6,"gp1":7,"gp2":8,"q":17,"ue":13,"ue[i + 1]":26,"ue[i + 2]":27,"ue[i - 1]":28,"ue[i - 2]":29,"ue[i]":12,"ue[im1]":23,"ue[ip1]":22}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void exact_solution(double xi, double eta, double zeta, double dtemp[5], constant double* g_ce) {
  int m;
  constant double(*ce)[13] = (constant double(*)[13])g_ce;

  for (m = 0; m < 5; m++) {
    dtemp[hook(9, m)] = ce[hook(11, m)][hook(10, 0)] + xi * (ce[hook(11, m)][hook(10, 1)] + xi * (ce[hook(11, m)][hook(10, 4)] + xi * (ce[hook(11, m)][hook(10, 7)] + xi * ce[hook(11, m)][hook(10, 10)]))) + eta * (ce[hook(11, m)][hook(10, 2)] + eta * (ce[hook(11, m)][hook(10, 5)] + eta * (ce[hook(11, m)][hook(10, 8)] + eta * ce[hook(11, m)][hook(10, 11)]))) + zeta * (ce[hook(11, m)][hook(10, 3)] + zeta * (ce[hook(11, m)][hook(10, 6)] + zeta * (ce[hook(11, m)][hook(10, 9)] + zeta * ce[hook(11, m)][hook(10, 12)])));
  }
}

kernel void exact_rhs2(global double* g_forcing, global double* g_ue, global double* g_buf, global double* g_cuf, global double* g_q, constant double* g_ce, int gp0, int gp1, int gp2) {
  double dtemp[5], xi, eta, zeta, dtpp;
  int m, i, j, k, ip1, im1;

  k = get_global_id(1) + 1;
  j = get_global_id(0) + 1;
  if (k > (gp2 - 2) || j > (gp1 - 2))
    return;

  int my_id = (k - 1) * gp1 + (j - 1);
  int my_offset1 = my_id * 64 * 5;
  int my_offset2 = my_id * 64;

  global double(*forcing)[64 / 2 * 2 + 1][64 / 2 * 2 + 1][5] = (global double(*)[64 / 2 * 2 + 1][64 / 2 * 2 + 1][5]) g_forcing;
  global double(*ue)[5] = (global double(*)[5]) & g_ue[hook(1, my_offset1)];
  global double(*buf)[5] = (global double(*)[5]) & g_buf[hook(2, my_offset1)];
  global double* cuf = (global double*)&g_cuf[hook(3, my_offset2)];
  global double* q = (global double*)&g_q[hook(4, my_offset2)];

  zeta = (double)k * (1.0 / (double)(64 - 1));
  eta = (double)j * (1.0 / (double)(64 - 1));

  for (i = 0; i < gp0; i++) {
    xi = (double)i * (1.0 / (double)(64 - 1));

    exact_solution(xi, eta, zeta, dtemp, g_ce);
    for (m = 0; m < 5; m++) {
      ue[hook(13, i)][hook(12, m)] = dtemp[hook(9, m)];
    }

    dtpp = 1.0 / dtemp[hook(9, 0)];

    for (m = 1; m < 5; m++) {
      buf[hook(15, i)][hook(14, m)] = dtpp * dtemp[hook(9, m)];
    }

    cuf[hook(16, i)] = buf[hook(15, i)][hook(14, 1)] * buf[hook(15, i)][hook(14, 1)];
    buf[hook(15, i)][hook(14, 0)] = cuf[hook(16, i)] + buf[hook(15, i)][hook(14, 2)] * buf[hook(15, i)][hook(14, 2)] + buf[hook(15, i)][hook(14, 3)] * buf[hook(15, i)][hook(14, 3)];
    q[hook(17, i)] = 0.5 * (buf[hook(15, i)][hook(14, 1)] * ue[hook(13, i)][hook(12, 1)] + buf[hook(15, i)][hook(14, 2)] * ue[hook(13, i)][hook(12, 2)] + buf[hook(15, i)][hook(14, 3)] * ue[hook(13, i)][hook(12, 3)]);
  }

  for (i = 1; i <= gp0 - 2; i++) {
    im1 = i - 1;
    ip1 = i + 1;

    forcing[hook(21, k)][hook(20, j)][hook(19, i)][hook(18, 0)] = forcing[hook(21, k)][hook(20, j)][hook(19, i)][hook(18, 0)] - (1.0 / (2.0 * (1.0 / (double)(64 - 1)))) * (ue[hook(13, ip1)][hook(22, 1)] - ue[hook(13, im1)][hook(23, 1)]) + (0.75 * (1.0 / ((1.0 / (double)(64 - 1)) * (1.0 / (double)(64 - 1))))) * (ue[hook(13, ip1)][hook(22, 0)] - 2.0 * ue[hook(13, i)][hook(12, 0)] + ue[hook(13, im1)][hook(23, 0)]);

    forcing[hook(21, k)][hook(20, j)][hook(19, i)][hook(18, 1)] = forcing[hook(21, k)][hook(20, j)][hook(19, i)][hook(18, 1)] - (1.0 / (2.0 * (1.0 / (double)(64 - 1)))) * ((ue[hook(13, ip1)][hook(22, 1)] * buf[hook(15, ip1)][hook(24, 1)] + 0.4 * (ue[hook(13, ip1)][hook(22, 4)] - q[hook(17, ip1)])) - (ue[hook(13, im1)][hook(23, 1)] * buf[hook(15, im1)][hook(25, 1)] + 0.4 * (ue[hook(13, im1)][hook(23, 4)] - q[hook(17, im1)]))) + (((0.1 * 1.0) * (1.0 / (1.0 / (double)(64 - 1)))) * (4.0 / 3.0) * (1.0 / (1.0 / (double)(64 - 1)))) * (buf[hook(15, ip1)][hook(24, 1)] - 2.0 * buf[hook(15, i)][hook(14, 1)] + buf[hook(15, im1)][hook(25, 1)]) + (0.75 * (1.0 / ((1.0 / (double)(64 - 1)) * (1.0 / (double)(64 - 1))))) * (ue[hook(13, ip1)][hook(22, 1)] - 2.0 * ue[hook(13, i)][hook(12, 1)] + ue[hook(13, im1)][hook(23, 1)]);

    forcing[hook(21, k)][hook(20, j)][hook(19, i)][hook(18, 2)] = forcing[hook(21, k)][hook(20, j)][hook(19, i)][hook(18, 2)] - (1.0 / (2.0 * (1.0 / (double)(64 - 1)))) * (ue[hook(13, ip1)][hook(22, 2)] * buf[hook(15, ip1)][hook(24, 1)] - ue[hook(13, im1)][hook(23, 2)] * buf[hook(15, im1)][hook(25, 1)]) + (((0.1 * 1.0) * (1.0 / (1.0 / (double)(64 - 1)))) * (1.0 / (1.0 / (double)(64 - 1)))) * (buf[hook(15, ip1)][hook(24, 2)] - 2.0 * buf[hook(15, i)][hook(14, 2)] + buf[hook(15, im1)][hook(25, 2)]) + (0.75 * (1.0 / ((1.0 / (double)(64 - 1)) * (1.0 / (double)(64 - 1))))) * (ue[hook(13, ip1)][hook(22, 2)] - 2.0 * ue[hook(13, i)][hook(12, 2)] + ue[hook(13, im1)][hook(23, 2)]);

    forcing[hook(21, k)][hook(20, j)][hook(19, i)][hook(18, 3)] = forcing[hook(21, k)][hook(20, j)][hook(19, i)][hook(18, 3)] - (1.0 / (2.0 * (1.0 / (double)(64 - 1)))) * (ue[hook(13, ip1)][hook(22, 3)] * buf[hook(15, ip1)][hook(24, 1)] - ue[hook(13, im1)][hook(23, 3)] * buf[hook(15, im1)][hook(25, 1)]) + (((0.1 * 1.0) * (1.0 / (1.0 / (double)(64 - 1)))) * (1.0 / (1.0 / (double)(64 - 1)))) * (buf[hook(15, ip1)][hook(24, 3)] - 2.0 * buf[hook(15, i)][hook(14, 3)] + buf[hook(15, im1)][hook(25, 3)]) + (0.75 * (1.0 / ((1.0 / (double)(64 - 1)) * (1.0 / (double)(64 - 1))))) * (ue[hook(13, ip1)][hook(22, 3)] - 2.0 * ue[hook(13, i)][hook(12, 3)] + ue[hook(13, im1)][hook(23, 3)]);

    forcing[hook(21, k)][hook(20, j)][hook(19, i)][hook(18, 4)] = forcing[hook(21, k)][hook(20, j)][hook(19, i)][hook(18, 4)] - (1.0 / (2.0 * (1.0 / (double)(64 - 1)))) * (buf[hook(15, ip1)][hook(24, 1)] * (1.4 * ue[hook(13, ip1)][hook(22, 4)] - 0.4 * q[hook(17, ip1)]) - buf[hook(15, im1)][hook(25, 1)] * (1.4 * ue[hook(13, im1)][hook(23, 4)] - 0.4 * q[hook(17, im1)])) + 0.5 * (((0.1 * 1.0) * (1.0 / (1.0 / (double)(64 - 1)))) * (1.0 - (1.4 * 1.4)) * (1.0 / (1.0 / (double)(64 - 1)))) * (buf[hook(15, ip1)][hook(24, 0)] - 2.0 * buf[hook(15, i)][hook(14, 0)] + buf[hook(15, im1)][hook(25, 0)]) + (((0.1 * 1.0) * (1.0 / (1.0 / (double)(64 - 1)))) * (1.0 / 6.0) * (1.0 / (1.0 / (double)(64 - 1)))) * (cuf[hook(16, ip1)] - 2.0 * cuf[hook(16, i)] + cuf[hook(16, im1)]) + (((0.1 * 1.0) * (1.0 / (1.0 / (double)(64 - 1)))) * (1.4 * 1.4) * (1.0 / (1.0 / (double)(64 - 1)))) * (buf[hook(15, ip1)][hook(24, 4)] - 2.0 * buf[hook(15, i)][hook(14, 4)] + buf[hook(15, im1)][hook(25, 4)]) + (0.75 * (1.0 / ((1.0 / (double)(64 - 1)) * (1.0 / (double)(64 - 1))))) * (ue[hook(13, ip1)][hook(22, 4)] - 2.0 * ue[hook(13, i)][hook(12, 4)] + ue[hook(13, im1)][hook(23, 4)]);
  }

  for (m = 0; m < 5; m++) {
    i = 1;
    forcing[hook(21, k)][hook(20, j)][hook(19, i)][hook(18, m)] = forcing[hook(21, k)][hook(20, j)][hook(19, i)][hook(18, m)] - (0.25 * ((0.75) > (((0.75) > (1.0) ? (0.75) : (1.0))) ? (0.75) : (((0.75) > (1.0) ? (0.75) : (1.0))))) * (5.0 * ue[hook(13, i)][hook(12, m)] - 4.0 * ue[hook(13, i + 1)][hook(26, m)] + ue[hook(13, i + 2)][hook(27, m)]);
    i = 2;
    forcing[hook(21, k)][hook(20, j)][hook(19, i)][hook(18, m)] = forcing[hook(21, k)][hook(20, j)][hook(19, i)][hook(18, m)] - (0.25 * ((0.75) > (((0.75) > (1.0) ? (0.75) : (1.0))) ? (0.75) : (((0.75) > (1.0) ? (0.75) : (1.0))))) * (-4.0 * ue[hook(13, i - 1)][hook(28, m)] + 6.0 * ue[hook(13, i)][hook(12, m)] - 4.0 * ue[hook(13, i + 1)][hook(26, m)] + ue[hook(13, i + 2)][hook(27, m)]);
  }

  for (m = 0; m < 5; m++) {
    for (i = 3; i <= gp0 - 4; i++) {
      forcing[hook(21, k)][hook(20, j)][hook(19, i)][hook(18, m)] = forcing[hook(21, k)][hook(20, j)][hook(19, i)][hook(18, m)] - (0.25 * ((0.75) > (((0.75) > (1.0) ? (0.75) : (1.0))) ? (0.75) : (((0.75) > (1.0) ? (0.75) : (1.0))))) * (ue[hook(13, i - 2)][hook(29, m)] - 4.0 * ue[hook(13, i - 1)][hook(28, m)] + 6.0 * ue[hook(13, i)][hook(12, m)] - 4.0 * ue[hook(13, i + 1)][hook(26, m)] + ue[hook(13, i + 2)][hook(27, m)]);
    }
  }

  for (m = 0; m < 5; m++) {
    i = gp0 - 3;
    forcing[hook(21, k)][hook(20, j)][hook(19, i)][hook(18, m)] = forcing[hook(21, k)][hook(20, j)][hook(19, i)][hook(18, m)] - (0.25 * ((0.75) > (((0.75) > (1.0) ? (0.75) : (1.0))) ? (0.75) : (((0.75) > (1.0) ? (0.75) : (1.0))))) * (ue[hook(13, i - 2)][hook(29, m)] - 4.0 * ue[hook(13, i - 1)][hook(28, m)] + 6.0 * ue[hook(13, i)][hook(12, m)] - 4.0 * ue[hook(13, i + 1)][hook(26, m)]);
    i = gp0 - 2;
    forcing[hook(21, k)][hook(20, j)][hook(19, i)][hook(18, m)] = forcing[hook(21, k)][hook(20, j)][hook(19, i)][hook(18, m)] - (0.25 * ((0.75) > (((0.75) > (1.0) ? (0.75) : (1.0))) ? (0.75) : (((0.75) > (1.0) ? (0.75) : (1.0))))) * (ue[hook(13, i - 2)][hook(29, m)] - 4.0 * ue[hook(13, i - 1)][hook(28, m)] + 5.0 * ue[hook(13, i)][hook(12, m)]);
  }
}