//{"cols":14,"dst_offset":2,"dst_step":1,"dst_step1":15,"mat_dst":0,"mat_src0":3,"mat_src1":6,"mat_src2":9,"offset_cols":12,"rows":13,"src0_offset":5,"src0_step":4,"src1_offset":8,"src1_step":7,"src2_offset":11,"src2_step":10}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void merge_vector_C3_D3(global short* mat_dst, int dst_step, int dst_offset, global short* mat_src0, int src0_step, int src0_offset, global short* mat_src1, int src1_step, int src1_offset, global short* mat_src2, int src2_step, int src2_offset, int offset_cols, int rows, int cols, int dst_step1) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  if ((x < cols) && (y < rows)) {
    x = x << 1;

    int src0_index = mad24(y, src0_step, (x << 1) + src0_offset - offset_cols);
    int src1_index = mad24(y, src1_step, (x << 1) + src1_offset - offset_cols);
    int src2_index = mad24(y, src2_step, (x << 1) + src2_offset - offset_cols);

    int dst_start = mad24(y, dst_step, dst_offset);
    int dst_end = mad24(y, dst_step, dst_offset + dst_step1);
    int dst_index = mad24(y, dst_step, dst_offset + 6 * x - offset_cols * 6);

    short data0_0 = *((global short*)((global char*)mat_src0 + src0_index + 0));
    short data0_1 = *((global short*)((global char*)mat_src0 + src0_index + 2));

    short data1_0 = *((global short*)((global char*)mat_src1 + src1_index + 0));
    short data1_1 = *((global short*)((global char*)mat_src1 + src1_index + 2));

    short data2_0 = *((global short*)((global char*)mat_src2 + src2_index + 0));
    short data2_1 = *((global short*)((global char*)mat_src2 + src2_index + 2));

    short2 tmp_data0 = (short2)(data0_0, data1_0);
    short2 tmp_data1 = (short2)(data2_0, data0_1);
    short2 tmp_data2 = (short2)(data1_1, data2_1);

    short2 dst_data0 = *((global short2*)((global char*)mat_dst + dst_index + 0));
    short2 dst_data1 = *((global short2*)((global char*)mat_dst + dst_index + 4));
    short2 dst_data2 = *((global short2*)((global char*)mat_dst + dst_index + 8));

    tmp_data0.x = ((dst_index + 0 >= dst_start) && (dst_index + 0 < dst_end)) ? tmp_data0.x : dst_data0.x;
    tmp_data0.y = ((dst_index + 2 >= dst_start) && (dst_index + 2 < dst_end)) ? tmp_data0.y : dst_data0.y;

    tmp_data1.x = ((dst_index + 4 >= dst_start) && (dst_index + 4 < dst_end)) ? tmp_data1.x : dst_data1.x;
    tmp_data1.y = ((dst_index + 6 >= dst_start) && (dst_index + 6 < dst_end)) ? tmp_data1.y : dst_data1.y;

    tmp_data2.x = ((dst_index + 8 >= dst_start) && (dst_index + 8 < dst_end)) ? tmp_data2.x : dst_data2.x;
    tmp_data2.y = ((dst_index + 10 >= dst_start) && (dst_index + 10 < dst_end)) ? tmp_data2.y : dst_data2.y;

    *((global short2*)((global char*)mat_dst + dst_index + 0)) = tmp_data0;
    *((global short2*)((global char*)mat_dst + dst_index + 4)) = tmp_data1;
    *((global short2*)((global char*)mat_dst + dst_index + 8)) = tmp_data2;
  }
}