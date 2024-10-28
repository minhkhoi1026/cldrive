//{"coupling":1,"deriv":3,"param":2,"state":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void dfun(global float* state, global float* coupling, global float* param, global float* deriv) {
  int i = get_global_id(0), n = get_global_size(0);
  float V = state[hook(0, 0 * n + i)], W = param[hook(2, 1 * n + i)], Z = param[hook(2, 2 * n + i)];

  float c_0 = coupling[hook(1, i)];

  float gCa = param[hook(2, 0 * n + i)];
  float gK = param[hook(2, 1 * n + i)];
  float gL = param[hook(2, 2 * n + i)];
  float phi = param[hook(2, 3 * n + i)];
  float gNa = param[hook(2, 4 * n + i)];
  float TK = param[hook(2, 5 * n + i)];
  float TCa = param[hook(2, 6 * n + i)];
  float TNa = param[hook(2, 7 * n + i)];
  float VCa = param[hook(2, 8 * n + i)];
  float VK = param[hook(2, 9 * n + i)];
  float VL = param[hook(2, 10 * n + i)];
  float VNa = param[hook(2, 11 * n + i)];
  float d_K = param[hook(2, 12 * n + i)];
  float tau_K = param[hook(2, 13 * n + i)];
  float d_Na = param[hook(2, 14 * n + i)];
  float d_Ca = param[hook(2, 15 * n + i)];
  float aei = param[hook(2, 16 * n + i)];
  float aie = param[hook(2, 17 * n + i)];
  float b = param[hook(2, 18 * n + i)];
  float C = param[hook(2, 19 * n + i)];
  float ane = param[hook(2, 20 * n + i)];
  float ani = param[hook(2, 21 * n + i)];
  float aee = param[hook(2, 22 * n + i)];
  float Iext = param[hook(2, 23 * n + i)];
  float rNMDA = param[hook(2, 24 * n + i)];
  float VT = param[hook(2, 25 * n + i)];
  float d_V = param[hook(2, 26 * n + i)];
  float ZT = param[hook(2, 27 * n + i)];
  float d_Z = param[hook(2, 28 * n + i)];
  float QV_max = param[hook(2, 29 * n + i)];
  float QZ_max = param[hook(2, 30 * n + i)];
  float t_scale = param[hook(2, 31 * n + i)];

  float local_coupling = 1;
  float m_Ca = 0.5 * (1 + tan((V - TCa) / d_Ca));
  float m_Na = 0.5 * (1 + tan((V - TNa) / d_Na));
  float m_K = 0.5 * (1 + tan((V - TK) / d_K));

  float QV = 0.5 * QV_max * (1 + tan((V - VT) / d_V));
  float QZ = 0.5 * QZ_max * (1 + tan((Z - ZT) / d_Z));
  float lc_0 = local_coupling * QV;
  deriv[hook(3, 0)] = t_scale * (-(gCa + (1.0 - C) * (rNMDA * aee) * (QV + lc_0) + C * rNMDA * aee * c_0) * m_Ca * (V - VCa) - gK * W * (V - VK) - gL * (V - VL) - (gNa * m_Na + (1.0 - C) * aee * (QV + lc_0) + C * aee * c_0) * (V - VNa) - aie * Z * QZ + ane * Iext);
  deriv[hook(3, 1)] = t_scale * phi * (m_K - W) / tau_K;
  deriv[hook(3, 2)] = t_scale * b * (ani * Iext + aei * V * QV);
}