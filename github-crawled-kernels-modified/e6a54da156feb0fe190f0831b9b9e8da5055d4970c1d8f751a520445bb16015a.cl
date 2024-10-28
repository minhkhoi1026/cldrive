//{"gd":2,"grid":0,"hist":4,"lut":3,"mask0":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void clEqualize(global float4* grid, float4 mask0, int gd, local float* lut, local float4* hist) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  int gw = get_global_size(0);
  int gh = get_global_size(1);

  float total;

  total = 0;
  for (int z = 0; z < gd; z++) {
    hist[hook(4, z)] = grid[hook(0, z * gw * gh + y * gw + x)];
    total += hist[hook(4, z)].w;
  }
  barrier(0x01);

  float4 mask1;
  mask1.x = mask0.x == 0.0f ? 1.0 : 0.0;
  mask1.y = mask0.y == 0.0f ? 1.0 : 0.0;
  mask1.z = mask0.z == 0.0f ? 1.0 : 0.0;
  mask1.w = mask0.w == 0.0f ? 1.0 : 0.0;

  if (total != 0.0f) {
    float sum = 0;
    for (int z = 0; z < gd; z++) {
      sum += hist[hook(4, z)].w;
      lut[hook(3, z)] = sum / total;
    }

    for (int z = 0; z < gd; z++) {
      float4 float3 = hist[hook(4, z)];
      float3 = float3 * mask1 + mask0 * (float4)(lut[hook(3, z)] * float3.w);
      float3.w = hist[hook(4, z)].w;
      grid[hook(0, z * gw * gh + y * gw + x)] = float3;
    }
  }
}