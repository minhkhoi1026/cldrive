//{"coupling":1,"deriv":3,"param":2,"state":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void dfun(global float* state, global float* coupling, global float* param, global float* deriv) {
  int i = get_global_id(0), n = get_global_size(0);

  float V = state[hook(0, i * 2)], W = state[hook(0, i * 2 + 1)];

  float c_0 = coupling[hook(1, i)];
  float tau = param[hook(2, n + i)], a = param[hook(2, 2 * n + i)], b = param[hook(2, 3 * n + i)], c = param[hook(2, 4 * n + i)], I = param[hook(2, 5 * n + i)], d = param[hook(2, 6 * n + i)], e = param[hook(2, 7 * n + i)], f = param[hook(2, 8 * n + i)], g = param[hook(2, 9 * n + i)], alpha = param[hook(2, 10 * n + i)], beta = param[hook(2, 11 * n + i)], gamma = param[hook(2, 12 * n + i)];

  deriv[hook(3, 0 * n + i)] = d * tau * (alpha * W - f * V * V * V + e * V * V + g * V + gamma * I + gamma * c_0);
  deriv[hook(3, 1 * n + i)] = d * (a + b * V + c * V * V - beta * W) / tau;
}