//{"coupling":1,"deriv":3,"param":2,"state":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void dfun(global float* state, global float* coupling, global float* param, global float* deriv) {
  int i = get_global_id(0), n = get_global_size(0);

  float E = state[hook(0, 0 * n + i)], I = state[hook(0, 1 * n + i)];

  float c_0 = coupling[hook(1, i)];

  float c_ee = param[hook(2, 0 * n + i)];
  float c_ei = param[hook(2, 1 * n + i)];
  float c_ie = param[hook(2, 2 * n + i)];
  float c_ii = param[hook(2, 3 * n + i)];
  float tau_e = param[hook(2, 4 * n + i)];
  float tau_i = param[hook(2, 5 * n + i)];
  float a_e = param[hook(2, 6 * n + i)];
  float b_e = param[hook(2, 7 * n + i)];
  float c_e = param[hook(2, 8 * n + i)];
  float a_i = param[hook(2, 9 * n + i)];
  float b_i = param[hook(2, 10 * n + i)];
  float c_i = param[hook(2, 11 * n + i)];
  float r_e = param[hook(2, 12 * n + i)];
  float r_i = param[hook(2, 13 * n + i)];
  float k_e = param[hook(2, 14 * n + i)];
  float k_i = param[hook(2, 15 * n + i)];
  float P = param[hook(2, 16 * n + i)];
  float Q = param[hook(2, 17 * n + i)];
  float theta_e = param[hook(2, 18 * n + i)];
  float theta_i = param[hook(2, 19 * n + i)];
  float alpha_e = param[hook(2, 20 * n + i)];
  float alpha_i = param[hook(2, 21 * n + i)];

  float local_coupling = 1;
  float lc_0 = local_coupling * E;
  float lc_1 = local_coupling * I;

  float x_e = alpha_e * (c_ee * E - c_ei * I + P - theta_e + c_0 + lc_0 + lc_1);
  float x_i = alpha_i * (c_ie * E - c_ii * I + Q - theta_i + lc_0 + lc_1);

  float s_e = c_e / (1.0 + exp(-a_e * (x_e - b_e)));
  float s_i = c_i / (1.0 + exp(-a_i * (x_i - b_i)));

  deriv[hook(3, 0 * n + i)] = (-E + (k_e - r_e * E) * s_e) / tau_e;
  deriv[hook(3, 1 * n + i)] = (-I + (k_i - r_i * I) * s_i) / tau_i;
}