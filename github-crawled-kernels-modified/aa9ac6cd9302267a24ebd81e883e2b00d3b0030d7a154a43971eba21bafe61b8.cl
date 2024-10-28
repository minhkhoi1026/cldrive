//{"cols":7,"dst":3,"dst_offset":5,"dst_step":4,"dst_step1":8,"rows":6,"src1":0,"src1_offset":2,"src1_step":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void arithm_bitwise_not_D3(global short* src1, int src1_step, int src1_offset, global short* dst, int dst_step, int dst_offset, int rows, int cols, int dst_step1) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  if (x < cols && y < rows) {
    x = x << 2;

    int src1_index = mad24(y, src1_step, (x << 1) + src1_offset - (((dst_offset >> 1) & 3) << 1));

    int dst_start = mad24(y, dst_step, dst_offset);
    int dst_end = mad24(y, dst_step, dst_offset + dst_step1);
    int dst_index = mad24(y, dst_step, dst_offset + (x << 1) & (int)0xfffffff8);

    short4 src1_data = vload4(0, (global short*)((global char*)src1 + src1_index));

    short4 dst_data = *((global short4*)((global char*)dst + dst_index));
    short4 tmp_data = ~src1_data;

    dst_data.x = ((dst_index + 0 >= dst_start) && (dst_index + 0 < dst_end)) ? tmp_data.x : dst_data.x;
    dst_data.y = ((dst_index + 2 >= dst_start) && (dst_index + 2 < dst_end)) ? tmp_data.y : dst_data.y;
    dst_data.z = ((dst_index + 4 >= dst_start) && (dst_index + 4 < dst_end)) ? tmp_data.z : dst_data.z;
    dst_data.w = ((dst_index + 6 >= dst_start) && (dst_index + 6 < dst_end)) ? tmp_data.w : dst_data.w;

    *((global short4*)((global char*)dst + dst_index)) = dst_data;
  }
}