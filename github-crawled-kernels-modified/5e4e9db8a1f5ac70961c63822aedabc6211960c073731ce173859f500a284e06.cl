//{"grid":1,"height":3,"input":0,"r_sigma":7,"s_sigma":6,"sh":5,"sw":4,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void bilateral_downsample(global const float4* input, global float2* grid, int width, int height, int sw, int sh, int s_sigma, float r_sigma) {
  const int gid_x = get_global_id(0);
  const int gid_y = get_global_id(1);

  for (int ry = 0; ry < s_sigma; ry++)
    for (int rx = 0; rx < s_sigma; rx++) {
      const int x = clamp(gid_x * s_sigma - s_sigma / 2 + rx, 0, width - 1);
      const int y = clamp(gid_y * s_sigma - s_sigma / 2 + ry, 0, height - 1);

      const float4 val = input[hook(0, y * width + x)];

      const int4 z = convert_int4(val * (1.0f / r_sigma) + 0.5f);

      grid[hook(1, 4 * (gid_x + sw * (gid_y + z.x * sh)) + 0)] += (float2)(val.x, 1.0f);
      grid[hook(1, 4 * (gid_x + sw * (gid_y + z.y * sh)) + 1)] += (float2)(val.y, 1.0f);
      grid[hook(1, 4 * (gid_x + sw * (gid_y + z.z * sh)) + 2)] += (float2)(val.z, 1.0f);
      grid[hook(1, 4 * (gid_x + sw * (gid_y + z.w * sh)) + 3)] += (float2)(val.w, 1.0f);

      barrier(0x02);
    }
}