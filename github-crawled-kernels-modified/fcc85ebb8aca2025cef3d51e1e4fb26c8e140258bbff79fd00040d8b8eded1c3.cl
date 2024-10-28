//{"<recovery-expr>()":9,"<recovery-expr>(dst)":10,"<recovery-expr>(title)":8,"dst":1,"dst_offset":7,"dst_step":5,"src":0,"src_cols":2,"src_offset":6,"src_rows":3,"src_step":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void transpose(global const T* src, global T* dst, int src_cols, int src_rows, int src_step, int dst_step, int src_offset, int dst_offset) {
  int gp_x = get_group_id(0), gp_y = get_group_id(1);
  int gs_x = get_num_groups(0), gs_y = get_num_groups(1);

  int groupId_x, groupId_y;

  if (src_rows == src_cols) {
    groupId_y = gp_x;
    groupId_x = (gp_x + gp_y) % gs_x;
  } else {
    int bid = gp_x + gs_x * gp_y;
    groupId_y = bid % gs_y;
    groupId_x = ((bid / gs_y) + groupId_y) % gs_x;
  }

  int lx = get_local_id(0);
  int ly = get_local_id(1);

  int x = groupId_x * 32 + lx;
  int y = groupId_y * 32 + ly;

  int x_index = groupId_y * 32 + lx;
  int y_index = groupId_x * 32 + ly;

  local T title[32 * 32];

  if (x < src_cols && y < src_rows) {
    int index_src = mad24(y, src_step, x);

    for (int i = 0; i < 32; i += 8) {
      if (y + i < src_rows) {
        title[hook(8, (ly + i) * 32 + lx)] = src[hook(9, src_offset + index_src)];
        index_src = mad24(8, src_step, index_src);
      }
    }
  }

  barrier(0x01);

  if (x_index < src_rows && y_index < src_cols) {
    int index_dst = mad24(y_index, dst_step, x_index);

    for (int i = 0; i < 32; i += 8) {
      if ((y_index + i) < src_cols) {
        dst[hook(10, dst_offset + index_dst)] = title[hook(9, lx * 32 + ly + i)];
        index_dst += dst_step * 8;
      }
    }
  }
}