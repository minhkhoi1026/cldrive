//{"<recovery-expr>()":9,"<recovery-expr>(dst)":8,"<recovery-expr>(src)":10,"dst":1,"dst_offset":7,"dst_step":5,"src":0,"src_cols":2,"src_offset":6,"src_rows":3,"src_step":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void transpose_inplace(global T* src, global T* dst, int src_cols, int src_rows, int src_step, int dst_step, int src_offset, int dst_offset) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  if (y < src_rows && x < y) {
    int srcIdx = mad24(y, src_step, src_offset + x);
    int dstIdx = mad24(x, dst_step, dst_offset + y);

    T tmp = dst[dstIdx];
    dst[hook(8, dstIdx)] = src[hook(9, srcIdx)];
    src[hook(10, srcIdx)] = tmp;
  }
}