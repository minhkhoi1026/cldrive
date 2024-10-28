//{"<recovery-expr>(dst)":10,"cols":7,"dst":3,"dst_offset":5,"dst_step":4,"rows":6,"src":0,"src_offset":2,"src_step":1,"thread_cols":9,"thread_rows":8}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void arithm_flip_rows_cols(global T* src, int src_step, int src_offset, global T* dst, int dst_step, int dst_offset, int rows, int cols, int thread_rows, int thread_cols) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  if (x < cols && y < thread_rows) {
    int src_index_0 = mad24(y, src_step, x + src_offset);
    int dst_index_0 = mad24(rows - y - 1, dst_step, cols - x - 1 + dst_offset);

    int src_index_1 = mad24(rows - y - 1, src_step, cols - x - 1 + src_offset);
    int dst_index_1 = mad24(y, dst_step, x + dst_offset);

    T data0 = src[src_index_0], data1 = src[src_index_1];

    dst[hook(10, dst_index_0)] = data0;
    dst[hook(10, dst_index_1)] = data1;
  }
}