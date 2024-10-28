//{"K":4,"no_inputs":6,"p_bias":2,"p_maps":0,"p_output":3,"p_weights":1,"stride":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void conv_3d_relu(const global float* restrict p_maps, const global float* restrict p_weights, const global float* restrict p_bias, global float* restrict p_output, const unsigned int K, const unsigned int stride, const unsigned int no_inputs) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);
  const int z = get_global_id(2);

  const int out_width = get_global_size(0);
  const int out_height = get_global_size(1);
  const int in_width = out_width + K - 1;
  const int in_height = out_height + K - 1;

  int wstart = x * stride;
  int hstart = y * stride;
  int wend = wstart + K;
  int hend = hstart + K;

  const int filter_start = z * K * K * no_inputs;
  int F = (int)K;
  float pix, w;
  float4 sum4 = 0.0;
  float zero = 0.0;
  float sum = 0.0;
  for (unsigned int map = 0; map < no_inputs; map++) {
    for (unsigned int r = 0; r < K; r++) {
      const int fstart = filter_start + map * K * K + r * K;
      const int map_start = ((map * in_height) + hstart + r) * in_width + wstart;
      int c = 0;
      int c4 = 0;

      while (c <= F - 4) {
        float4 filter4 = vload4(c4, p_weights + fstart);
        float4 data4 = vload4(c4, p_maps + map_start);
        sum4 += filter4 * data4;
        c += 4;
        c4++;
      }

      for (int c1 = c; c1 < K; c1++) {
        sum4.x += p_weights[hook(1, fstart + c1)] * p_maps[hook(0, map_start + c1)];
      }
    }
  }
  sum = sum4.x + sum4.y + sum4.z + sum4.w + p_bias[hook(2, z)];
  p_output[hook(3, ((z * out_height) + y) * out_width + x)] = fmax(zero, sum);
}