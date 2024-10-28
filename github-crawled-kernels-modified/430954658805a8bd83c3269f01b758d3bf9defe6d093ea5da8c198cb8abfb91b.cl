//{"bias":6,"dst":1,"filter":3,"filter_size":4,"filter_size_half":5,"sampler":2,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void conv2D_horizontal(read_only image2d_t src, write_only image2d_t dst, sampler_t sampler, constant float* filter, const int filter_size, const int filter_size_half, float4 bias) {
  int2 coords_dst = (int2)(get_global_id(0), get_global_id(1));
  int2 coords_src = coords_dst + (int2)(filter_size_half, 0);

  float4 sum = (float4)(0.0f, 0.0f, 0.0f, 0.0f);

  for (int i = 0; i < filter_size; ++i) {
    float4 float3 = read_imagef(src, sampler, coords_src - (int2)(i, 0));
    sum += float3 * filter[hook(3, i)];
  }

  sum = clamp(sum + bias, 0.0f, 1.0f);
  sum.w = 1.0f;

  write_imagef(dst, coords_dst, sum);
}