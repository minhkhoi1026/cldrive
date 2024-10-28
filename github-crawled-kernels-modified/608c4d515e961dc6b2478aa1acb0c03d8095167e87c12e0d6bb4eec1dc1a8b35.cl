//{"cols":16,"dst_offset":2,"dst_step":1,"dst_step1":17,"mat_dst":0,"mat_src0":3,"mat_src1":6,"mat_src2":9,"mat_src3":12,"rows":15,"src0_offset":5,"src0_step":4,"src1_offset":8,"src1_step":7,"src2_offset":11,"src2_step":10,"src3_offset":14,"src3_step":13}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void merge_vector_C4_D3(global short* mat_dst, int dst_step, int dst_offset, global short* mat_src0, int src0_step, int src0_offset, global short* mat_src1, int src1_step, int src1_offset, global short* mat_src2, int src2_step, int src2_offset, global short* mat_src3, int src3_step, int src3_offset, int rows, int cols, int dst_step1) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  if ((x < cols) && (y < rows)) {
    int src0_index = mad24(y, src0_step, src0_offset);
    int src1_index = mad24(y, src1_step, src1_offset);
    int src2_index = mad24(y, src2_step, src2_offset);
    int src3_index = mad24(y, src3_step, src3_offset);
    int dst_index = mad24(y, dst_step, dst_offset);

    short src0 = *((global short*)((global uchar*)mat_src0 + src0_index + (x << 1)));
    short src1 = *((global short*)((global uchar*)mat_src1 + src1_index + (x << 1)));
    short src2 = *((global short*)((global uchar*)mat_src2 + src2_index + (x << 1)));
    short src3 = *((global short*)((global uchar*)mat_src3 + src3_index + (x << 1)));

    *((global short4*)((global uchar*)mat_dst + dst_index + (x << 3))) = (short4)(src0, src1, src2, src3);
  }
}