//{"column_indices":2,"m":0,"row_offsets":1,"total":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ordered_count(int m, global int* row_offsets, global int* column_indices, global int* total) {
  int src = get_global_id(0);
  int num = 0;
  if (src < m) {
    int row_begin_src = row_offsets[hook(1, src)];
    int row_end_src = row_offsets[hook(1, src + 1)];
    for (int offset_src = row_begin_src; offset_src < row_end_src; ++offset_src) {
      int dst = column_indices[hook(2, offset_src)];
      if (dst > src)
        break;
      int it = row_begin_src;
      int row_begin_dst = row_offsets[hook(1, dst)];
      int row_end_dst = row_offsets[hook(1, dst + 1)];
      for (int offset_dst = row_begin_dst; offset_dst < row_end_dst; ++offset_dst) {
        int dst_dst = column_indices[hook(2, offset_dst)];
        if (dst_dst > dst)
          break;
        while (column_indices[hook(2, it)] < dst_dst)
          it++;
        if (dst_dst == column_indices[hook(2, it)])
          num++;
      }
    }
    atomic_add(total, num);
  }
}