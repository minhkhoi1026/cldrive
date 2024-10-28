//{"input":0,"m":3,"m[i + 1]":2,"m[j + 1]":4,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t sampler = 0 | 2 | 0x10;
kernel void filter(read_only image2d_t input, write_only image2d_t output) {
  const int2 p = {get_global_id(0), get_global_id(1)};
  float m[3][3] = {{-1, -2, -1}, {0, 0, 0}, {1, 2, 1}};
  float2 t = {0.f, 0.f};
  for (int j = -1; j <= 1; j++) {
    for (int i = -1; i <= 1; i++) {
      float4 pix = read_imagef(input, sampler, (int2)(p.x + i, p.y + j));
      t.x += (pix.x * 0.299f + pix.y * 0.587f + pix.z * 0.114f) * m[hook(3, i + 1)][hook(2, j + 1)];
      t.y += (pix.x * 0.299f + pix.y * 0.587f + pix.z * 0.114f) * m[hook(3, j + 1)][hook(4, i + 1)];
    }
  }
  float o = sqrt(t.x * t.x + t.y * t.y);
  write_imagef(output, p, (float4)(o, o, o, 1.0f));
}