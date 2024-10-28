//{"cols":1,"dst_step":3,"dst_y":13,"mat_dst":2,"mat_src0":4,"mat_src1":6,"mat_src2":8,"rows":0,"src0_step":5,"src0_y":10,"src1_step":7,"src1_y":11,"src2_step":9,"src2_y":12}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void merge_vector_C3_D0_1(int rows, int cols, global uchar* mat_dst, int dst_step, global uchar* mat_src0, int src0_step, global uchar* mat_src1, int src1_step, global uchar* mat_src2, int src2_step) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  if ((x < cols) && (y < rows)) {
    global uchar4* src0_y = (global uchar4*)(mat_src0 + y * src0_step);
    global uchar4* src1_y = (global uchar4*)(mat_src1 + y * src1_step);
    global uchar4* src2_y = (global uchar4*)(mat_src2 + y * src0_step);

    global uchar4* dst_y = (global uchar4*)(mat_dst + y * dst_step);

    uchar4 value0 = src0_y[hook(10, x)];
    uchar4 value1 = src1_y[hook(11, x)];
    uchar4 value2 = src2_y[hook(12, x)];

    dst_y[hook(13, 3 * x + 0)] = (uchar4)(value0.s0, value1.s0, value2.s0, value0.s1);

    dst_y[hook(13, 3 * x + 1)] = (uchar4)(value1.s1, value2.s1, value0.s2, value1.s2);

    dst_y[hook(13, 3 * x + 2)] = (uchar4)(value2.s2, value0.s3, value1.s3, value2.s3);
  }
}