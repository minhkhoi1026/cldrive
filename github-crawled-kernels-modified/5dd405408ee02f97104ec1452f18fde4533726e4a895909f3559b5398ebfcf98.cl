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

  float2 sum2 = 0;
  float2 filter2;
  float2 in2;

  for (int r = 0; r < K; r++) {
    int c = 0;
    int c2 = 0;
    while (c <= K - 2) {
      filter2 = vload2(c2, filt + r * K);
      in2 = vload2(c2, in + (r + y) * (W + K - 1) + x);
      sum2 += in2 * filter2;
      c += 2;
      c2++;
    }
    for (; c < K; c++) {
      sum2.x += filt[hook(1, r * K + c)] * in[hook(0, (y + r) * (W + K - 1) + x + c)];
    }
  }
  out[hook(2, y * W + x)] = sum2.x + sum2.y + bias;
}