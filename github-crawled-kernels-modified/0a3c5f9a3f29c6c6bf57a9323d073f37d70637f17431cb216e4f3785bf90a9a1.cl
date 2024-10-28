//{"coupling":1,"deriv":3,"param":2,"state":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void dfun(global float* state, global float* coupling, global float* param, global float* deriv) {
  int i = get_global_id(0), n = get_global_size(0);

  float y0 = state[hook(0, i * 6)], y1 = state[hook(0, i * 6 + 1)], y2 = state[hook(0, i * 6 + 2)], y3 = state[hook(0, i * 6 + 3)], y4 = state[hook(0, i * 6 + 4)], y5 = state[hook(0, i * 6 + 5)];
  float c = coupling[hook(1, i)];
  ;

  float nu_max = param[hook(2, 0 * n + i)];
  float r = param[hook(2, 1 * n + i)];
  float v0 = param[hook(2, 2 * n + i)];
  float a = param[hook(2, 3 * n + i)];
  float a_1 = param[hook(2, 4 * n + i)];
  float a_2 = param[hook(2, 5 * n + i)];
  float a_3 = param[hook(2, 6 * n + i)];
  float a_4 = param[hook(2, 7 * n + i)];
  float A = param[hook(2, 8 * n + i)];
  float b = param[hook(2, 9 * n + i)];
  float B = param[hook(2, 10 * n + i)];
  float J = param[hook(2, 11 * n + i)];
  float mu = param[hook(2, 12 * n + i)];

  float src = y1 - y2;

  float sigm_y1_y2 = 2.0 * nu_max / (1.0 + exp(r * (v0 - (y1 - y2))));
  float sigm_y0_1 = 2.0 * nu_max / (1.0 + exp(r * (v0 - (a_1 * J * y0))));
  float sigm_y0_3 = 2.0 * nu_max / (1.0 + exp(r * (v0 - (a_3 * J * y0))));
  deriv[hook(3, 0 * n + i)] = y3;
  deriv[hook(3, 1 * n + i)] = y4;
  deriv[hook(3, 2 * n + i)] = y5;
  deriv[hook(3, 3 * n + i)] = A * a * sigm_y1_y2 - 2.0 * a * y3 - a * a * y0;
  deriv[hook(3, 4 * n + i)] = A * a * (mu + a_2 * J * sigm_y0_1 + c + src) - 2.0 * a * y4 - a * a * y1;
  deriv[hook(3, 5 * n + i)] = B * b * (a_4 * J * sigm_y0_3) - 2.0 * b * y5 - b * b * y2;
}