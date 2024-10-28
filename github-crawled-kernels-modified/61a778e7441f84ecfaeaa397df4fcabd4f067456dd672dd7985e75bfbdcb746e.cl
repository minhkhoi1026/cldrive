//{"D":0,"T":1,"constMem":2,"gamma_obs":4,"observations":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void EM_gamma_obs(const int D, const int T, constant float* constMem, global const float* observations, global float* gamma_obs) {
  size_t gx = get_global_id(0);
  size_t gy = get_global_id(1);

  size_t id = gy * T + gx;

  if (gx < T && gy < D)
    gamma_obs[hook(4, id)] = observations[hook(3, id)] * constMem[hook(2, gx)];
}