//{"T":3,"bufferT":2,"gamma_obs":1,"observationsT":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void EM_gammaobs(global const float* observationsT, global float* gamma_obs, constant float* bufferT, const int T) {
  unsigned int gx = get_global_id(0);
  unsigned int gy = get_global_id(1);

  unsigned int id = gy * T + gx;

  gamma_obs[hook(1, id)] = observationsT[hook(0, id)] * bufferT[hook(2, gx)];
}