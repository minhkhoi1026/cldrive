//{"coupling":1,"deriv":3,"param":2,"state":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void dfun(global float* state, global float* coupling, global float* param, global float* deriv) {
  int i = get_global_id(0), n = get_global_size(0);

  float x = state[hook(0, i)];

  float c = coupling[hook(1, i)];
  float gamma = param[hook(2, i)];
  deriv[hook(3, i)] = gamma * x + x;
}