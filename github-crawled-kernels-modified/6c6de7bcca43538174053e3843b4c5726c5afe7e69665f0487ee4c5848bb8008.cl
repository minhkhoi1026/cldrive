//{"cols":10,"dst_offset":2,"dst_step":1,"dst_step1":11,"mat_dst":0,"mat_src0":3,"mat_src1":6,"rows":9,"src0_offset":5,"src0_step":4,"src1_offset":8,"src1_step":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void merge_vector_C2_D5(global float* mat_dst, int dst_step, int dst_offset, global float* mat_src0, int src0_step, int src0_offset, global float* mat_src1, int src1_step, int src1_offset, int rows, int cols, int dst_step1) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  if ((x < cols) && (y < rows)) {
    int src0_index = mad24(y, src0_step, src0_offset);
    int src1_index = mad24(y, src1_step, src1_offset);
    int dst_index = mad24(y, dst_step, dst_offset);

    float src0 = *((global float*)((global uchar*)mat_src0 + src0_index + (x << 2)));
    float src1 = *((global float*)((global uchar*)mat_src1 + src1_index + (x << 2)));

    *((global float2*)((global uchar*)mat_dst + dst_index + (x << 3))) = (float2)(src0, src1);
  }
}