//{"input":0,"mask":3,"mask[i + 1]":2,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t sampler = 0 | 2 | 0x10;
constant float mask[3][3] = {{-1, -1, -1}, {-1, 8, -1}, {-1, -1, -1}};

kernel void sharpen(read_only image2d_t input, write_only image2d_t output) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  float4 value = 0.f;
  for (int j = -1; j <= 1; j++) {
    for (int i = -1; i <= 1; i++) {
      value += read_imagef(input, sampler, (int2)(x + i, y + j)) * mask[hook(3, i + 1)][hook(2, j + 1)];
    }
  }
  float4 orig = read_imagef(input, sampler, (int2)(x, y));
  write_imagef(output, (int2)(x, y), orig + value / 8);
}