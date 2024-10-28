//{"input":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t sampler = 0 | 2 | 0x10;
kernel void blur(read_only image2d_t input, write_only image2d_t output) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  float4 sum = 0.f;
  for (int j = -2; j <= 2; j++) {
    for (int i = -2; i <= 2; i++) {
      sum += read_imagef(input, sampler, (int2)(x + i, y + j));
    }
  }
  write_imagef(output, (int2)(x, y), sum / 25.f);
}