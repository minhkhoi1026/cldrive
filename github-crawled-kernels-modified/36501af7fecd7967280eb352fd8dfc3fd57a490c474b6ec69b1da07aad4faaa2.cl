//{"input":0,"mask":3,"mask[i + 1]":2,"mask[j + 1]":4,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t sampler = 0 | 2 | 0x10;
constant float mask[3][3] = {{-1, -2, -1}, {0, 0, 0}, {1, 2, 1}};

kernel void sobel(read_only image2d_t input, write_only image2d_t output) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  float g_x = 0.f;
  float g_y = 0.f;
  for (int j = -1; j <= 1; j++) {
    for (int i = -1; i <= 1; i++) {
      float4 p = read_imagef(input, sampler, (int2)(x + i, y + j));
      g_x += (p.x * 0.299f + p.y * 0.587f + p.z * 0.114f) * mask[hook(3, i + 1)][hook(2, j + 1)];
      g_y += (p.x * 0.299f + p.y * 0.587f + p.z * 0.114f) * mask[hook(3, j + 1)][hook(4, i + 1)];
    }
  }
  float g_mag = sqrt(g_x * g_x + g_y * g_y);
  write_imagef(output, (int2)(x, y), (float4)(g_mag, g_mag, g_mag, 1));
}