//{"K":3,"K1":4,"K2":5,"filt":1,"in":0,"in_local":7,"out":2,"pBias":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void convolve(const global float* in, constant float* filt, global float* out, const int K, const int K1, const int K2, const global float* pBias) {
  const int W = get_global_size(0);
  const int H = get_global_size(1);

  const int x = get_global_id(0);
  const int y = get_global_id(1);

  local float in_local[28 * 28];

  in_local[hook(7, x * W + y)] = in[hook(0, x * W + y)];
  barrier(0x01);

  float sum = 0;
  int c = 0;

  for (int r = 0; r < K; r++) {
    for (c = 0; c < K; c++) {
      sum += filt[hook(1, r * K + c)] * in_local[hook(7, ((y + r) * W + x) + c)];
    }
  }
  out[hook(2, y * W + x)] = sum + *pBias;
}