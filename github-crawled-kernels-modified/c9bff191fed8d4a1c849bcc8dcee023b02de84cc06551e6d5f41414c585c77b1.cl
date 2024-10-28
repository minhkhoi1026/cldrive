//{"d_cost":2,"d_left":0,"d_right":1,"height":4,"right_buf":5,"width":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void matching_cost_kernel_128(global const ulong* d_left, global const ulong* d_right, global uchar* d_cost, int width, int height) {
  int loc_x = get_local_id(0);
  int loc_y = get_local_id(1);
  int gr_x = get_group_id(0);

  local ulong right_buf[(128 + 128) * 2];
  short y = gr_x * 2 + loc_y;
  short sh_offset = (128 + 128) * loc_y;
  {
    if (y < height && loc_x < width)
      right_buf[hook(5, sh_offset + loc_x)] = d_right[hook(1, y * width + loc_x)];
    else
      right_buf[hook(5, sh_offset + loc_x)] = 0;
    for (short x = 0; x < 128; x++) {
      if (y < height && x < width) {
        ulong left_val = d_left[hook(0, y * width + x)];

        ulong right_val = x < loc_x ? 0 : right_buf[hook(5, sh_offset + x - loc_x)];
        int dst_idx = y * (width * 128) + x * 128 + loc_x;
        d_cost[hook(2, dst_idx)] = popcount(left_val ^ right_val);
      }
    }
  }

  for (short x = 128; x < width; x += 128) {
    {
      right_buf[hook(5, sh_offset + loc_x + 128)] = d_right[hook(1, y * width + (x + loc_x))];
      for (short xoff = 0; xoff < 128; xoff++) {
        if (y < height && x + xoff < width) {
          ulong left_val = d_left[hook(0, y * width + x + xoff)];

          ulong right_val = right_buf[hook(5, sh_offset + 128 + xoff - loc_x)];
          int dst_idx = y * (width * 128) + (x + xoff) * 128 + loc_x;
          d_cost[hook(2, dst_idx)] = popcount(left_val ^ right_val);
        }
      }

      right_buf[hook(5, sh_offset + loc_x + 0)] = right_buf[hook(5, sh_offset + loc_x + 128)];
    }
  }
}