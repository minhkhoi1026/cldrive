//{"depth":6,"grid":1,"grid_chunk":11,"grid_chunk[k]":10,"grid_chunk[k][get_local_id(1)]":9,"grid_chunk[s - d]":21,"grid_chunk[s - d][get_local_id(1)]":20,"grid_chunk[z.w - d]":19,"grid_chunk[z.w - d][get_local_id(1)]":18,"grid_chunk[z.x - d]":13,"grid_chunk[z.x - d][get_local_id(1)]":12,"grid_chunk[z.y - d]":15,"grid_chunk[z.y - d][get_local_id(1)]":14,"grid_chunk[z.z - d]":17,"grid_chunk[z.z - d][get_local_id(1)]":16,"height":3,"input":0,"r_sigma":8,"s_sigma":7,"sh":5,"sw":4,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
__attribute__((reqd_work_group_size(8, 8, 1))) kernel void bilateral_downsample(global const float4* input, global float8* grid, int width, int height, int sw, int sh, int depth, int s_sigma, float r_sigma) {
  const int gid_x = get_global_id(0);
  const int gid_y = get_global_id(1);

  local float8 grid_chunk[7][8][8];

  if (gid_x > sw || gid_y > sh)
    return;

  for (int d = 0; d < depth; d += 7) {
    for (int k = 0; k < 7; k++) {
      grid_chunk[hook(11, k)][hook(10, get_local_id(1))][hook(9, get_local_id(0))] = (float8)(0.0f);
    }

    barrier(0x01);

    for (int ry = 0; ry < s_sigma; ry++)
      for (int rx = 0; rx < s_sigma; rx++) {
        const int x = clamp(gid_x * s_sigma - s_sigma / 2 + rx, 0, width - 1);
        const int y = clamp(gid_y * s_sigma - s_sigma / 2 + ry, 0, height - 1);

        const float4 val = input[hook(0, y * width + x)];

        const int4 z = convert_int4(val * (1.0f / r_sigma) + 0.5f);

        int4 inbounds = (z >= d & z < d + 7);

        if (inbounds.x)
          grid_chunk[hook(11, z.x - d)][hook(13, get_local_id(1))][hook(12, get_local_id(0))].s01 += (float2)(val.x, 1.0f);
        if (inbounds.y)
          grid_chunk[hook(11, z.y - d)][hook(15, get_local_id(1))][hook(14, get_local_id(0))].s23 += (float2)(val.y, 1.0f);
        if (inbounds.z)
          grid_chunk[hook(11, z.z - d)][hook(17, get_local_id(1))][hook(16, get_local_id(0))].s45 += (float2)(val.z, 1.0f);
        if (inbounds.w)
          grid_chunk[hook(11, z.w - d)][hook(19, get_local_id(1))][hook(18, get_local_id(0))].s67 += (float2)(val.w, 1.0f);

        barrier(0x01);
      }

    for (int s = d, e = d + min(7, depth - d); s < e; s++) {
      grid[hook(1, gid_x + sw * (gid_y + s * sh))] = grid_chunk[hook(11, s - d)][hook(21, get_local_id(1))][hook(20, get_local_id(0))];
    }
  }
}