//{"N":0,"alpha_d":3,"b_d":1,"beta_d":5,"ones_d":4,"pi_d":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void FWD_init_alpha(const int N, global const float* b_d, global const float* pi_d, global float* alpha_d, global float* ones_d, global float* beta_d) {
  unsigned int idx = get_global_id(0);
  if (idx < N) {
    alpha_d[hook(3, idx)] = pi_d[hook(2, idx)] * b_d[hook(1, idx)];
    beta_d[hook(5, idx)] = ones_d[hook(4, idx)] = 1.0f;
  }
}