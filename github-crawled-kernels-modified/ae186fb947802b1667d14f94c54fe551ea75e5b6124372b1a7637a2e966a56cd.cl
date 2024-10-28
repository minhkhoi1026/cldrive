//{"N":2,"T":3,"gammaT":0,"gamma_state_sum":1,"lds":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void EM_gammastatesum(global const float* gammaT, global float* gamma_state_sum, const int N, const int T) {
  local float lds[272];

  unsigned int gx = get_global_id(0);
  unsigned int gy = get_global_id(1);
  unsigned int lx = get_local_id(0);
  unsigned int ly = get_local_id(1);

  size_t m = T / 16;

  int i, col;
  float data;
  size_t offset = gy * T;

  data = gammaT[hook(0, offset + gx)];

  for (i = 1; i < m; ++i) {
    col = i * 16 + gx;
    data += gammaT[hook(0, offset + col)];
  }

  lds[hook(4, ly * (16 + 1) + lx)] = data;

  barrier(0x01);

  if (gx == 0) {
    int start = ly * (16 + 1);
    data = lds[hook(4, start)] + lds[hook(4, start + 1)] + lds[hook(4, start + 2)] + lds[hook(4, start + 3)] + lds[hook(4, start + 4)] + lds[hook(4, start + 5)] + lds[hook(4, start + 6)] + lds[hook(4, start + 7)] + lds[hook(4, start + 8)] + lds[hook(4, start + 9)] + lds[hook(4, start + 10)] + lds[hook(4, start + 11)] + lds[hook(4, start + 12)] + lds[hook(4, start + 13)] + lds[hook(4, start + 14)] + lds[hook(4, start + 15)];
    gamma_state_sum[hook(1, gy)] = data;
  }
}