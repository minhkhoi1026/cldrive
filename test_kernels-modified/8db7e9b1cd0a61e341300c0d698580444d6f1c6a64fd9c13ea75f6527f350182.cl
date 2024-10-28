//{"coupling":1,"deriv":3,"param":2,"state":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void dfun(global float* state, global float* coupling, global float* param, global float* deriv) {
  int i = get_global_id(0), n = get_global_size(0);
  int n_param = 12;

  float v1 = state[hook(0, 0 * n + i)], y1 = state[hook(0, 1 * n + i)], v2 = state[hook(0, 2 * n + i)], y2 = state[hook(0, 3 * n + i)], v3 = state[hook(0, 4 * n + i)], y3 = state[hook(0, 5 * n + i)], v4 = state[hook(0, 6 * n + i)], y4 = state[hook(0, 7 * n + i)], v5 = state[hook(0, 8 * n + i)], y5 = state[hook(0, 9 * n + i)], v6 = state[hook(0, 10 * n + i)], v7 = state[hook(0, 11 * n + i)], c = coupling[hook(1, i)];

  float He = param[hook(2, 0 * n + i)];
  float Hi = param[hook(2, 1 * n + i)];
  float ke = param[hook(2, 2 * n + i)];
  float ki = param[hook(2, 3 * n + i)];
  float e0 = param[hook(2, 4 * n + i)];
  float rho_2 = param[hook(2, 5 * n + i)];
  float rho_1 = param[hook(2, 6 * n + i)];
  float gamma_1 = param[hook(2, 7 * n + i)];
  float gamma_2 = param[hook(2, 8 * n + i)];
  float gamma_3 = param[hook(2, 9 * n + i)];
  float gamma_4 = param[hook(2, 10 * n + i)];
  float gamma_5 = param[hook(2, 11 * n + i)];
  float P = param[hook(2, 12 * n + i)];
  float U = param[hook(2, 13 * n + i)];
  float Q = param[hook(2, 14 * n + i)];
  float Heke = param[hook(2, 15 * n + i)];
  float Hiki = param[hook(2, 16 * n + i)];
  float ke_2 = param[hook(2, 17 * n + i)];
  float ki_2 = param[hook(2, 18 * n + i)];
  float keke = param[hook(2, 19 * n + i)];
  float kiki = param[hook(2, 20 * n + i)];
  float gamma_1T = param[hook(2, 21 * n + i)];
  float gamma_2T = param[hook(2, 22 * n + i)];
  float gamma_3T = param[hook(2, 23 * n + i)];

  float locol_coupling = 1;

  float coupled_input = c + 6 * locol_coupling;

  deriv[hook(3, 0 * n + i)] = y1;
  deriv[hook(3, 1 * n + i)] = Heke * (gamma_1 * (rho_1 * (rho_2 - v2 - v3) > 709 ? 0 : 2 * e0 / (1 + rho_1 * (rho_2 - v2 - v3))) + gamma_1T * (U + coupled_input)) - ke_2 * y1 - keke * v1;

  deriv[hook(3, 2 * n + i)] = y2;
  deriv[hook(3, 3 * n + i)] = Heke * (gamma_2 * (rho_1 * (rho_2 - v1) > 709 ? 0 : 2 * e0 / (1 + rho_1 * (rho_2 - v1))) + gamma_2T * (P + coupled_input)) - ke_2 * y2 - keke * v2;

  deriv[hook(3, 4 * n + i)] = y3;
  deriv[hook(3, 5 * n + i)] = Hiki * (gamma_4 * (rho_1 * (rho_2 - v4 - v5) > 709 ? 0 : 2 * e0 / (1 + rho_1 * (rho_2 - v4 - v5)))) - ki_2 * y3 - kiki * v3;
  deriv[hook(3, 6 * n + i)] = y4;

  deriv[hook(3, 7 * n + i)] = Heke * (gamma_3 * (rho_1 * (rho_2 - v2 - v3) > 709 ? 0 : 2 * e0 / (1 + rho_1 * (rho_2 - v2 - v3))) + gamma_3T * (Q + coupled_input)) - ke_2 * y4 - keke * v4;
  deriv[hook(3, 8 * n + i)] = y5;

  deriv[hook(3, 9 * n + i)] = Hiki * (gamma_5 * (rho_1 * (rho_2 - v4 - v5) > 709 ? 0 : 2 * e0 / (1 + rho_1 * (rho_2 - v4 - v5)))) - ki_2 * y5 - keke * v5;

  deriv[hook(3, 10 * n + i)] = y2 - y3;

  deriv[hook(3, 11 * n + i)] = y4 - y5;
}