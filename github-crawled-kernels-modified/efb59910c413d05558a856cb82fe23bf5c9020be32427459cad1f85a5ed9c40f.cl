//{"cols":1,"dst_step":3,"dst_y":13,"mat_dst":2,"mat_src0":4,"mat_src1":6,"mat_src2":8,"rows":0,"src0_step":5,"src0_y":10,"src1_step":7,"src1_y":11,"src2_step":9,"src2_y":12}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void merge_vector_C3_D5_1(int rows, int cols, global float* mat_dst, int dst_step, global float* mat_src0, int src0_step, global float* mat_src1, int src1_step, global float* mat_src2, int src2_step) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  if ((x < cols) && (y < rows)) {
    global float* src0_y = (global float*)((global char*)mat_src0 + y * src0_step);
    global float* src1_y = (global float*)((global char*)mat_src1 + y * src1_step);
    global float* src2_y = (global float*)((global char*)mat_src2 + y * src0_step);

    global float* dst_y = (global float*)((global char*)mat_dst + y * dst_step);

    float value0 = src0_y[hook(10, x)];
    float value1 = src1_y[hook(11, x)];
    float value2 = src2_y[hook(12, x)];

    dst_y[hook(13, 3 * x + 0)] = value0;
    dst_y[hook(13, 3 * x + 1)] = value1;
    dst_y[hook(13, 3 * x + 2)] = value2;
  }
}