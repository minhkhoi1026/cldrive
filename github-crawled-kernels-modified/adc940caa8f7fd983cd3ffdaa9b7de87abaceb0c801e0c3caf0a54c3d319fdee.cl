//{"cols":7,"dst":3,"dst_offset":5,"dst_step":4,"dst_step1":8,"rows":6,"src1":0,"src1_offset":2,"src1_step":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void arithm_bitwise_not_D1(global char* src1, int src1_step, int src1_offset, global char* dst, int dst_step, int dst_offset, int rows, int cols, int dst_step1) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  if (x < cols && y < rows) {
    x = x << 2;
    int src1_index = mad24(y, src1_step, x + src1_offset);

    int dst_end = mad24(y, dst_step, dst_offset + dst_step1);
    int dst_index = mad24(y, dst_step, dst_offset + x);

    char4 src1_data = vload4(0, src1 + src1_index);
    char4 dst_data = vload4(0, dst + dst_index);
    char4 tmp_data = ~src1_data;

    dst_data.x = dst_index + 0 < dst_end ? tmp_data.x : dst_data.x;
    dst_data.y = dst_index + 1 < dst_end ? tmp_data.y : dst_data.y;
    dst_data.z = dst_index + 2 < dst_end ? tmp_data.z : dst_data.z;
    dst_data.w = dst_index + 3 < dst_end ? tmp_data.w : dst_data.w;

    vstore4(dst_data, 0, dst + dst_index);
  }
}