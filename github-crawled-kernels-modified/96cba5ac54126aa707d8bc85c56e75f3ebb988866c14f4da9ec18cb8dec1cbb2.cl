//{"cols":7,"dst":3,"dst_offset":5,"dst_step":4,"dst_step1":8,"rows":6,"src1":0,"src1_offset":2,"src1_step":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void arithm_bitwise_not_D4(global int* src1, int src1_step, int src1_offset, global int* dst, int dst_step, int dst_offset, int rows, int cols, int dst_step1) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  if (x < cols && y < rows) {
    int src1_index = mad24(y, src1_step, (x << 2) + src1_offset);
    int dst_index = mad24(y, dst_step, (x << 2) + dst_offset);

    int data1 = *((global int*)((global char*)src1 + src1_index));
    int tmp = ~data1;

    *((global int*)((global char*)dst + dst_index)) = tmp;
  }
}