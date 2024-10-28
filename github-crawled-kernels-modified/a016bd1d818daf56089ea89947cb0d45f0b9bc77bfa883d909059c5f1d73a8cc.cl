//{"NxNr":0,"c1_m":2,"c2_m":3,"c3_m":4,"dt_inv":1,"e0":29,"e0[k]":28,"e1":27,"e1[0]":34,"e1[1]":35,"e1[2]":36,"e1[k]":26,"e_x_m":5,"e_y_m":6,"e_z_m":7,"g0":31,"g0[k]":30,"g1":33,"g1[0]":37,"g1[1]":38,"g1[2]":39,"g1[k]":32,"g_x_m":8,"g_y_m":9,"g_z_m":10,"j0":21,"j0[k]":20,"j_x_m":11,"j_y_m":12,"j_z_m":13,"n0":23,"n0[k]":22,"n0_x_m":14,"n0_y_m":15,"n0_z_m":16,"n1":25,"n1[k]":24,"n1_x_m":17,"n1_y_m":18,"n1_z_m":19}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void advance_e_g_m(constant unsigned int* NxNr, constant double* dt_inv, global double* c1_m, global double* c2_m, global double* c3_m, global double2* e_x_m, global double2* e_y_m, global double2* e_z_m, global double2* g_x_m, global double2* g_y_m, global double2* g_z_m, global double2* j_x_m, global double2* j_y_m, global double2* j_z_m, global double2* n0_x_m, global double2* n0_y_m, global double2* n0_z_m, global double2* n1_x_m, global double2* n1_y_m, global double2* n1_z_m) {
  unsigned int i_grid = (unsigned int)get_global_id(0);
  if (i_grid < *NxNr) {
    double e0[3][2] = {{e_x_m[hook(5, i_grid)].s0, e_x_m[hook(5, i_grid)].s1}, {e_y_m[hook(6, i_grid)].s0, e_y_m[hook(6, i_grid)].s1}, {e_z_m[hook(7, i_grid)].s0, e_z_m[hook(7, i_grid)].s1}};

    double g0[3][2] = {{g_x_m[hook(8, i_grid)].s0, g_x_m[hook(8, i_grid)].s1}, {g_y_m[hook(9, i_grid)].s0, g_y_m[hook(9, i_grid)].s1}, {g_z_m[hook(10, i_grid)].s0, g_z_m[hook(10, i_grid)].s1}};

    double j0[3][2] = {{j_x_m[hook(11, i_grid)].s0, j_x_m[hook(11, i_grid)].s1}, {j_y_m[hook(12, i_grid)].s0, j_y_m[hook(12, i_grid)].s1}, {j_z_m[hook(13, i_grid)].s0, j_z_m[hook(13, i_grid)].s1}};

    double n0[3][2] = {{n0_x_m[hook(14, i_grid)].s0, n0_x_m[hook(14, i_grid)].s1}, {n0_y_m[hook(15, i_grid)].s0, n0_y_m[hook(15, i_grid)].s1}, {n0_z_m[hook(16, i_grid)].s0, n0_z_m[hook(16, i_grid)].s1}};

    double n1[3][2] = {{n1_x_m[hook(17, i_grid)].s0, n1_x_m[hook(17, i_grid)].s1}, {n1_y_m[hook(18, i_grid)].s0, n1_y_m[hook(18, i_grid)].s1}, {n1_z_m[hook(19, i_grid)].s0, n1_z_m[hook(19, i_grid)].s1}};

    double c1 = c1_m[hook(2, i_grid)];
    double c2 = c2_m[hook(3, i_grid)];
    double c3 = c3_m[hook(4, i_grid)];

    double dt_inv_loc = *dt_inv;
    double e1[3][2], g1[3][2];

    double pi2 = 2 * 3.14159265358979323846f;

    for (int k = 0; k < 3; k++) {
      for (int i = 0; i < 2; i++) {
        j0[hook(21, k)][hook(20, i)] *= pi2;
        n0[hook(23, k)][hook(22, i)] *= pi2;
        n1[hook(25, k)][hook(24, i)] *= pi2;
      }
    }

    for (int k = 0; k < 3; k++) {
      for (int i = 0; i < 2; i++) {
        e1[hook(27, k)][hook(26, i)] = c1 * e0[hook(29, k)][hook(28, i)] + c2 * c3 * (g0[hook(31, k)][hook(30, i)] - j0[hook(21, k)][hook(20, i)]) + c3 * (c1 * n0[hook(23, k)][hook(22, i)] - n1[hook(25, k)][hook(24, i)] - (n0[hook(23, k)][hook(22, i)] - n1[hook(25, k)][hook(24, i)]) * dt_inv_loc * c2 * c3);

        g1[hook(33, k)][hook(32, i)] = -c2 * e0[hook(29, k)][hook(28, i)] + c1 * (g0[hook(31, k)][hook(30, i)] - j0[hook(21, k)][hook(20, i)]) + j0[hook(21, k)][hook(20, i)] + c3 * (dt_inv_loc * (1. - c1) * (n0[hook(23, k)][hook(22, i)] - n1[hook(25, k)][hook(24, i)]) - c2 * n0[hook(23, k)][hook(22, i)]);
      }
    }
    e_x_m[hook(5, i_grid)] = (double2){e1[hook(27, 0)][hook(34, 0)], e1[hook(27, 0)][hook(34, 1)]};
    e_y_m[hook(6, i_grid)] = (double2){e1[hook(27, 1)][hook(35, 0)], e1[hook(27, 1)][hook(35, 1)]};
    e_z_m[hook(7, i_grid)] = (double2){e1[hook(27, 2)][hook(36, 0)], e1[hook(27, 2)][hook(36, 1)]};

    g_x_m[hook(8, i_grid)] = (double2){g1[hook(33, 0)][hook(37, 0)], g1[hook(33, 0)][hook(37, 1)]};
    g_y_m[hook(9, i_grid)] = (double2){g1[hook(33, 1)][hook(38, 0)], g1[hook(33, 1)][hook(38, 1)]};
    g_z_m[hook(10, i_grid)] = (double2){g1[hook(33, 2)][hook(39, 0)], g1[hook(33, 2)][hook(39, 1)]};
  }
}