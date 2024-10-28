//{"coupling":1,"deriv":3,"param":2,"state":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void dfun(global float* state, global float* coupling, global float* param, global float* deriv) {
  int i = get_global_id(0), n = get_global_size(0);

  float3 xi = vload3(i, state), eta = vload3(i, state + 3 * n), alpha = vload3(i, state + 6 * n), beta = vload3(i, state + 9 * n);

  float c_0 = coupling[hook(1, i)];

  float tau = param[hook(2, i)];
  float b = param[hook(2, n + i)];
  float K11 = param[hook(2, 2 * n + i)];
  float K12 = param[hook(2, 3 * n + i)];
  float K21 = param[hook(2, 4 * n + i)];

  float3 e_i = vload3(i, param + 5 * n);
  float3 f_i = vload3(i, param + 8 * n);
  float3 IE_i = vload3(i, param + 11 * n);
  float3 II_i = vload3(i, param + 14 * n);
  float3 m_i = vload3(i, param + 17 * n);
  float3 n_i = vload3(i, param + 20 * n);

  float3 Aik_0 = vload3(i, param + 23 * n);
  float3 Aik_1 = vload3(i, param + 23 * n + 3);
  float3 Aik_2 = vload3(i, param + 23 * n + 6);

  float3 Bik_0 = vload3(i, param + 32 * n);
  float3 Bik_1 = vload3(i, param + 32 * n + 3);
  float3 Bik_2 = vload3(i, param + 32 * n + 6);

  float3 Cik_0 = vload3(i, param + 41 * n);
  float3 Cik_1 = vload3(i, param + 41 * n + 3);
  float3 Cik_2 = vload3(i, param + 41 * n + 6);

  float local_coupling = 0;

  float3 deriv1 = tau * (xi - e_i * pow(xi, 3) - eta) + K11 * ((float3)(dot(xi, Aik_0), dot(xi, Aik_1), dot(xi, Aik_2)) - xi) - K12 * ((float)(dot(alpha, Bik_0), dot(alpha, Bik_1), dot(alpha, Bik_2)) - xi) + tau * (IE_i + c_0 + local_coupling * xi);

  float3 deriv2 = (xi - b * eta + m_i) / tau;
  float3 deriv3 = tau * (alpha - f_i * pow(alpha, 3) / 3 - beta) + K21 * ((float3)(dot(xi, Cik_0), dot(xi, Cik_1), dot(xi, Cik_2)) - alpha) + tau * (II_i + c_0 + local_coupling * xi);
  float3 deriv4 = (alpha - b * beta + n_i) / tau;

  vstore3(deriv1, i, deriv);
  vstore3(deriv2, i, deriv + 3 * n);
  vstore3(deriv3, i, deriv + 6 * n);
  vstore3(deriv4, i, deriv + 9 * n);
}