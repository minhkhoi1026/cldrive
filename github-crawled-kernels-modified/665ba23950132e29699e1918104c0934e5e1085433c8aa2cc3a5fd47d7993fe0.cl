//{"DT":11,"E_X":6,"E_Y":7,"J_X":12,"J_Y":13,"L_MAX_X":9,"L_MAX_Y":10,"NSP":4,"fact":5,"hx":8,"pos_x":0,"pos_y":1,"vel_x":2,"vel_y":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void D_Motion(global double* pos_x, global double* pos_y, global double* vel_x, global double* vel_y, int NSP, double fact, global double* E_X, global double* E_Y, double hx, double L_MAX_X, double L_MAX_Y, double DT, int J_X, int J_Y) {
  int j_x, j_y;
  double temp_x, temp_y, Ep_X, Ep_Y;
  double jr_x, jr_y;
  int i = get_global_id(0);
  if (i < NSP) {
    jr_x = pos_x[hook(0, i)] / hx;
    j_x = ((int)jr_x);
    temp_x = jr_x - ((double)j_x);
    jr_y = pos_y[hook(1, i)] / hx;
    j_y = ((int)jr_y);
    temp_y = jr_y - ((double)j_y);

    Ep_X = (1 - temp_x) * (1 - temp_y) * E_X[hook(6, j_x * J_Y + j_y)] + temp_x * (1 - temp_y) * E_X[hook(6, (j_x + 1) * J_Y + j_y)] + (1 - temp_x) * temp_y * E_X[hook(6, j_x * J_Y + (j_y + 1))] + temp_x * temp_y * E_X[hook(6, (j_x + 1) * J_Y + (j_y + 1))];

    Ep_Y = (1 - temp_x) * (1 - temp_y) * E_Y[hook(7, j_x * J_Y + j_y)] + temp_x * (1 - temp_y) * E_Y[hook(7, (j_x + 1) * J_Y + j_y)] + (1 - temp_x) * temp_y * E_Y[hook(7, j_x * J_Y + (j_y + 1))] + temp_x * temp_y * E_Y[hook(7, (j_x + 1) * J_Y + (j_y + 1))];

    vel_x[hook(2, i)] += (DT * fact) * Ep_X;
    vel_y[hook(3, i)] += (DT * fact) * Ep_Y;
    pos_x[hook(0, i)] += vel_x[hook(2, i)] * DT;
    pos_y[hook(1, i)] += vel_y[hook(3, i)] * DT;

    if (pos_x[hook(0, i)] < 0) {
      pos_x[hook(0, i)] = -pos_x[hook(0, i)];
      vel_x[hook(2, i)] = -vel_x[hook(2, i)];
    }

    while (pos_y[hook(1, i)] > L_MAX_Y)
      pos_y[hook(1, i)] = pos_y[hook(1, i)] - L_MAX_Y;

    while (pos_y[hook(1, i)] < 0.0)
      pos_y[hook(1, i)] = L_MAX_Y + pos_y[hook(1, i)];
  }
}