//{"dest":2,"grid":3,"mask":1,"srce":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void clSlice(read_only image2d_t srce, float4 mask, write_only image2d_t dest, read_only image3d_t grid) {
  const sampler_t srceSampler = 0 | 0x10 | 4;
  int x = get_global_id(0);
  int y = get_global_id(1);
  float4 RGBA = read_imagef(srce, srceSampler, (int2)(x, y));

  float w = get_global_size(0);
  float h = get_global_size(1);
  const sampler_t gridSampler = 1 | 0x20 | 4;
  float4 GRID = read_imagef(grid, gridSampler, (float4)(x / w, y / h, dot(RGBA, mask), 0));

  GRID.xyz /= GRID.w;
  GRID.w = 1.0;
  write_imagef(dest, (int2)(x, y), GRID);
}