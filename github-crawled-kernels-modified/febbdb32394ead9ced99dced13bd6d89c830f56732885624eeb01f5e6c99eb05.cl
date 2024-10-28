//{"cols":10,"dst_offset":2,"dst_step":1,"dst_step1":11,"mat_dst":0,"mat_src0":3,"mat_src1":6,"rows":9,"src0_offset":5,"src0_step":4,"src1_offset":8,"src1_step":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void merge_vector_C2_D0(global uchar* mat_dst, int dst_step, int dst_offset, global uchar* mat_src0, int src0_step, int src0_offset, global uchar* mat_src1, int src1_step, int src1_offset, int rows, int cols, int dst_step1) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  if ((x < cols) && (y < rows)) {
    x = x << 1;

    int src0_index = mad24(y, src0_step, src0_offset + x - ((dst_offset & 3) >> 1));
    int src1_index = mad24(y, src1_step, src1_offset + x - ((dst_offset & 3) >> 1));

    int dst_start = mad24(y, dst_step, dst_offset);
    int dst_end = mad24(y, dst_step, dst_offset + dst_step1);
    int dst_index = mad24(y, dst_step, dst_offset + (x << 1) & (int)0xfffffffc);

    global uchar4* dst = (global uchar4*)(mat_dst + dst_index);
    global uchar* src0 = mat_src0 + src0_index;
    global uchar* src1 = src0 + 1;
    global uchar* src2 = mat_src1 + src1_index;
    global uchar* src3 = src2 + 1;

    uchar4 dst_data = *dst;
    uchar data_0 = *(src0);
    uchar data_1 = *(src1);
    uchar data_2 = *(src2);
    uchar data_3 = *(src3);

    uchar4 tmp_data = (uchar4)(data_0, data_2, data_1, data_3);

    tmp_data.xy = dst_index + 0 >= dst_start ? tmp_data.xy : dst_data.xy;
    tmp_data.zw = dst_index + 2 < dst_end ? tmp_data.zw : dst_data.zw;

    *dst = tmp_data;
  }
}