//{"cols":9,"dst":6,"dst_offset":8,"dst_step":7,"rows":10,"src1":0,"src1_offset":2,"src1_step":1,"src2":3,"src2_offset":5,"src2_step":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void arithm_binary_op_mat(global T* src1, int src1_step, int src1_offset, global T* src2, int src2_step, int src2_offset, global T* dst, int dst_step, int dst_offset, int cols, int rows) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  if (x < cols && y < rows) {
    int src1_index = mad24(y, src1_step, x + src1_offset);
    int src2_index = mad24(y, src2_step, x + src2_offset);
    int dst_index = mad24(y, dst_step, x + dst_offset);
  }
}