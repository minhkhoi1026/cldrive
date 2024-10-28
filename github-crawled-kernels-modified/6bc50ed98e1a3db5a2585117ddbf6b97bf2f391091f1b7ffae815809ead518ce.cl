//{"cols":7,"dst":3,"dst_offset":5,"dst_step":4,"dst_step1":8,"rows":6,"src":0,"src_offset":2,"src_step":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void arithm_bitwise_not_D5(global char* src, int src_step, int src_offset, global char* dst, int dst_step, int dst_offset, int rows, int cols, int dst_step1) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  if (x < cols && y < rows) {
    int src_index = mad24(y, src_step, (x << 2) + src_offset);
    int dst_index = mad24(y, dst_step, (x << 2) + dst_offset);

    char4 data;

    data = *((global char4*)((global char*)src + src_index));
    data = ~data;

    *((global char4*)((global char*)dst + dst_index)) = data;
  }
}