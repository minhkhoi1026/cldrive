//{"FATMDFX":8,"FATMDFY":9,"FATMDFZ":10,"U0":0,"U1":1,"VP0":2,"g_W":5,"k0":6,"k1":7,"nnoi":4,"stride":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_cte(global float* U0, global float* U1, global float* VP0, unsigned int stride, unsigned int nnoi, constant float* g_W, unsigned int k0, unsigned int k1, float FATMDFX, float FATMDFY, float FATMDFZ) {
  unsigned int index = get_global_id(1) * nnoi + get_global_id(0) + k0 * stride;

  unsigned int k;

  for (k = k0; k < k1; ++k) {
    if (VP0[hook(2, index)] > 0.0f) {
      U1[hook(1, index)] = 2.0f * U0[hook(0, index)] - U1[hook(1, index)] + FATMDFX * VP0[hook(2, index)] * VP0[hook(2, index)] * (+g_W[hook(5, 6)] * (U0[hook(0, index - 6)] + U0[hook(0, index + 6)]) + g_W[hook(5, 5)] * (U0[hook(0, index - 5)] + U0[hook(0, index + 5)]) + g_W[hook(5, 4)] * (U0[hook(0, index - 4)] + U0[hook(0, index + 4)]) + g_W[hook(5, 3)] * (U0[hook(0, index - 3)] + U0[hook(0, index + 3)]) + g_W[hook(5, 2)] * (U0[hook(0, index - 2)] + U0[hook(0, index + 2)]) + g_W[hook(5, 1)] * (U0[hook(0, index - 1)] + U0[hook(0, index + 1)]) + g_W[hook(5, 0)] * U0[hook(0, index)]) + FATMDFY * VP0[hook(2, index)] * VP0[hook(2, index)] * (+g_W[hook(5, 6)] * (U0[hook(0, index - 6 * nnoi)] + U0[hook(0, index + 6 * nnoi)]) + g_W[hook(5, 5)] * (U0[hook(0, index - 5 * nnoi)] + U0[hook(0, index + 5 * nnoi)]) + g_W[hook(5, 4)] * (U0[hook(0, index - 4 * nnoi)] + U0[hook(0, index + 4 * nnoi)]) + g_W[hook(5, 3)] * (U0[hook(0, index - 3 * nnoi)] + U0[hook(0, index + 3 * nnoi)]) + g_W[hook(5, 2)] * (U0[hook(0, index - 2 * nnoi)] + U0[hook(0, index + 2 * nnoi)]) + g_W[hook(5, 1)] * (U0[hook(0, index - nnoi)] + U0[hook(0, index + nnoi)]) + g_W[hook(5, 0)] * U0[hook(0, index)]) + FATMDFZ * VP0[hook(2, index)] * VP0[hook(2, index)] * (+g_W[hook(5, 6)] * (U0[hook(0, index + 6 * stride)] + U0[hook(0, index - 6 * stride)]) + g_W[hook(5, 5)] * (U0[hook(0, index + 5 * stride)] + U0[hook(0, index - 5 * stride)]) + g_W[hook(5, 4)] * (U0[hook(0, index + 4 * stride)] + U0[hook(0, index - 4 * stride)]) + g_W[hook(5, 3)] * (U0[hook(0, index + 3 * stride)] + U0[hook(0, index - 3 * stride)]) + g_W[hook(5, 2)] * (U0[hook(0, index + 2 * stride)] + U0[hook(0, index - 2 * stride)]) + g_W[hook(5, 1)] * (U0[hook(0, index + stride)] + U0[hook(0, index - stride)]) + g_W[hook(5, 0)] * U0[hook(0, index)]);
    }
    index += stride;
  }
}