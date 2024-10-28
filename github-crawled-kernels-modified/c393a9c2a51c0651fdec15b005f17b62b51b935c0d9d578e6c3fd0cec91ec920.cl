//{"K":3,"bias":4,"filt":1,"in":0,"out":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void conv_2d(global float* in, constant float* filt, global float* out, const int K, const float bias) {
  const int W = get_global_size(0);

  const int x = get_global_id(0);
  const int y = get_global_id(1);

  float sum = 0;
  int c = 0;

  __attribute__((opencl_unroll_hint)) for (int r = 0; r < K; r++) {
    __attribute__((opencl_unroll_hint)) for (c = 0; c < K; c++) {
      sum += filt[hook(1, r * K + c)] * in[hook(0, (y + r) * (W + K - 1) + x + c)];
    }
  }
  out[hook(2, y * W + x)] = sum + bias;
}