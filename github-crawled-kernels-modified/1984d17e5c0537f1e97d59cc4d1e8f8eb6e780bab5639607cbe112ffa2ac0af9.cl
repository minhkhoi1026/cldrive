//{"cols":12,"dst":9,"dst_offset":11,"dst_step":10,"mask":6,"mask_offset":8,"mask_step":7,"rows":13,"src1":0,"src1_offset":2,"src1_step":1,"src2":3,"src2_offset":5,"src2_step":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void arithm_binary_op_mat_mask(global T* src1, int src1_step, int src1_offset, global T* src2, int src2_step, int src2_offset, global uchar* mask, int mask_step, int mask_offset, global T* dst, int dst_step, int dst_offset, int cols, int rows) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  if (x < cols && y < rows) {
    int mask_index = mad24(y, mask_step, x + mask_offset);
    if (mask[hook(6, mask_index)]) {
      int src1_index = mad24(y, src1_step, x + src1_offset);
      int src2_index = mad24(y, src2_step, x + src2_offset);
      int dst_index = mad24(y, dst_step, dst_offset + x);
    }
  }
}