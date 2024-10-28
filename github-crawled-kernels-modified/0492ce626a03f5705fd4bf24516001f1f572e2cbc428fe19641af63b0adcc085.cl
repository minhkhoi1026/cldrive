//{"cols":14,"dst_offset":2,"dst_step":1,"dst_step1":15,"mat_dst":0,"mat_src0":3,"mat_src1":6,"mat_src2":9,"offset_cols":12,"rows":13,"src0_offset":5,"src0_step":4,"src1_offset":8,"src1_step":7,"src2_offset":11,"src2_step":10}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void merge_vector_C3_D5(global float* mat_dst, int dst_step, int dst_offset, global float* mat_src0, int src0_step, int src0_offset, global float* mat_src1, int src1_step, int src1_offset, global float* mat_src2, int src2_step, int src2_offset, int offset_cols, int rows, int cols, int dst_step1) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  if ((x < cols) && (y < rows)) {
    int src0_index = mad24(y, src0_step, src0_offset);
    int src1_index = mad24(y, src1_step, src1_offset);
    int src2_index = mad24(y, src2_step, src2_offset);

    int dst_index = mad24(y, dst_step, dst_offset);

    global float* src0 = (global float*)((global uchar*)mat_src0 + src0_index + (x << 2));
    global float* src1 = (global float*)((global uchar*)mat_src1 + src1_index + (x << 2));
    global float* src2 = (global float*)((global uchar*)mat_src2 + src2_index + (x << 2));

    global float* dist0 = (global float*)((global uchar*)mat_dst + dst_index + 3 * (x << 2));
    global float* dist1 = dist0 + 1;
    global float* dist2 = dist0 + 2;

    float src0_data = *src0;
    float src1_data = *src1;
    float src2_data = *src2;

    *dist0 = src0_data;
    *dist1 = src1_data;
    *dist2 = src2_data;
  }
}