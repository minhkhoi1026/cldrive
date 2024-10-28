//{"grid":1,"image":0,"mask":4,"sh":3,"sw":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void clSplit(read_only image2d_t image, global float4* grid, int sw, int sh, float4 mask) {
  const sampler_t sampler = 0 | 0x10 | 4;
  int gx = get_global_id(0);
  int gy = get_global_id(1);
  int gz = get_global_id(2);
  int gw = get_global_size(0);
  int gh = get_global_size(1);
  int gd = get_global_size(2);

  float4 slice = (float4)0;
  for (int x = 0; x < sw; x++) {
    for (int y = 0; y < sh; y++) {
      float4 RGBA = read_imagef(image, sampler, (int2)(x + gx * sw, y + gy * sh));
      int z = dot(RGBA, mask) * (gd - 1) + 0.5;
      if (z == gz) {
        RGBA.w = 1.0;
        slice += RGBA;
      }
    }
  }

  int index = gz * gw * gh + gy * gw + gx;
  grid[hook(1, index)] = slice;
}