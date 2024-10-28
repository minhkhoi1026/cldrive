//{"factor":2,"input":0,"m":4,"m[1]":5,"m[i + 1]":3,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t sampler = 0 | 2 | 0x10;
kernel void filter(read_only image2d_t input, write_only image2d_t output, double factor) {
  const int2 p = {get_global_id(0), get_global_id(1)};
  float m[3][3] = {{-1, -1, -1}, {-1, 8, -1}, {-1, -1, -1}};
  float4 value = 0.f;
  for (int j = -1; j <= 1; j++) {
    for (int i = -1; i <= 1; i++) {
      value += read_imagef(input, sampler, (int2)(p.x + i, p.y + j)) * m[hook(4, i + 1)][hook(3, j + 1)] * (float)factor;
    }
  }
  float4 orig = read_imagef(input, sampler, (int2)(p.x, p.y));
  write_imagef(output, (int2)(p.x, p.y), orig + value / m[hook(4, 1)][hook(5, 1)]);
}