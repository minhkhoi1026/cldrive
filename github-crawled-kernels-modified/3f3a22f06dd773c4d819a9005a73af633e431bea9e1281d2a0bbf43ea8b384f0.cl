//{"input":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t sampler = 0 | 2 | 0x10;
kernel void bilateral(read_only image2d_t input, write_only image2d_t output) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  float coeff = 0.f;
  float4 sum = 0.f;
  float4 center = read_imagef(input, sampler, (int2)(x, y));

  for (int j = -2; j <= 2; j++) {
    for (int i = -2; i <= 2; i++) {
      float norm, weight;
      float4 pixel = read_imagef(input, sampler, (int2)(x + i, y + j));

      norm = sqrt((float)(i * i) + (float)(j * j)) * (1.f / 3.f);
      weight = native_exp(-0.5f * (norm * norm));

      norm = fast_distance(pixel.xyz, center.xyz) * (1.f / 0.2f);
      weight *= native_exp(-0.5f * (norm * norm));

      coeff += weight;
      sum += weight * pixel;
    }
  }

  sum /= coeff;
  sum.w = center.w;

  write_imagef(output, (int2)(x, y), sum);
}