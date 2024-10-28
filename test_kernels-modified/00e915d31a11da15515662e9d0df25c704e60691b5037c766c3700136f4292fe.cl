//{"coupling":1,"deriv":3,"param":2,"state":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void dfun(global float* state, global float* coupling, global float* param, global float* deriv) {
  int i = get_global_id(0), n = get_global_size(0);

  float y0 = state[hook(0, 0 * n + i)], y1 = param[hook(2, 1 * n + i)], y2 = state[hook(0, 2 * n + i)], y3 = param[hook(2, 4 * n + i)], y4 = state[hook(0, 4 * n + i)], y5 = param[hook(2, 5 * n + i)];

  float c_pop1 = coupling[hook(1, 0 * n + i)];
  float c_pop2 = coupling[hook(1, 1 * n + i)];

  float x0 = param[hook(2, 0 * n + i)];
  float Iext = param[hook(2, 1 * n + i)];
  float Iext2 = param[hook(2, 2 * n + i)];
  float a = param[hook(2, 3 * n + i)];
  float b = param[hook(2, 4 * n + i)];
  float slope = param[hook(2, 5 * n + i)];
  float tt = param[hook(2, 6 * n + i)];
  float Kvf = param[hook(2, 7 * n + i)];
  float c = param[hook(2, 8 * n + i)];
  float d = param[hook(2, 9 * n + i)];
  float r = param[hook(2, 10 * n + i)];
  float Ks = param[hook(2, 11 * n + i)];
  float Kf = param[hook(2, 12 * n + i)];
  float aa = param[hook(2, 13 * n + i)];
  float tau = param[hook(2, 14 * n + i)];

  float temp_ydot0, temp_ydot2, temp_ydot4;
  if (y0 < 0.0) {
    temp_ydot0 = -a * y0 * y0 + b * y0;
  } else {
    temp_ydot0 = slope - y3 + 0.6 * (y2 - 4.0) * (y2 - 4.0);
  }

  deriv[hook(3, 0)] = tt * (y1 - y2 + Iext + Kvf + c_pop1 + temp_ydot0 * y0);
  deriv[hook(3, 1)] = tt * (c - d * y0 * y0 - y1);

  if (y2 < 0.0) {
    temp_ydot2 = -0.1 * pow(y2, 7);
  } else {
    temp_ydot2 = 0.0;
  }
  deriv[hook(3, 2)] = tt * (r * (4 * (y0 - x0) - y2 + temp_ydot2 + Ks * c_pop1));

  deriv[hook(3, 3)] = tt * (-y4 + y3 - pow(y3, 3) + Iext2 + 2 * y5 - 0.3 * (y2 - 3.5) + Kf * c_pop2);

  if (y3 < -0.25) {
    temp_ydot4 = 0.0;
  } else {
    temp_ydot4 = aa * (y3 + 0.25);
  }
  deriv[hook(3, 4)] = tt * ((-y4 + temp_ydot4) / tau);
  deriv[hook(3, 5)] = tt * (-0.01 * (y5 - 0.1 * y0));
}