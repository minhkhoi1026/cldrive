//{"cols":1,"dst_step":3,"dst_y":16,"mat_dst":2,"mat_src0":4,"mat_src1":6,"mat_src2":8,"mat_src3":10,"rows":0,"src0_step":5,"src0_y":12,"src1_step":7,"src1_y":13,"src2_step":9,"src2_y":14,"src3_step":11,"src3_y":15}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void merge_vector_C4_D5_1(int rows, int cols, global float* mat_dst, int dst_step, global float* mat_src0, int src0_step, global float* mat_src1, int src1_step, global float* mat_src2, int src2_step, global float* mat_src3, int src3_step) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  if ((x < cols) && (y < rows)) {
    global float* src0_y = (global float*)((global uchar*)mat_src0 + y * src0_step);
    global float* src1_y = (global float*)((global uchar*)mat_src1 + y * src1_step);
    global float* src2_y = (global float*)((global uchar*)mat_src2 + y * src0_step);
    global float* src3_y = (global float*)((global uchar*)mat_src3 + y * src1_step);

    global float4* dst_y = (global float4*)((global uchar*)mat_dst + y * dst_step);

    float value0 = src0_y[hook(12, x)];
    float value1 = src1_y[hook(13, x)];
    float value2 = src2_y[hook(14, x)];
    float value3 = src3_y[hook(15, x)];

    dst_y[hook(16, x)] = (float4)(value0, value1, value2, value3);
  }
}