//{"cols":1,"dst_step":3,"dst_y":13,"mat_dst":2,"mat_src0":4,"mat_src1":6,"mat_src2":8,"rows":0,"src0_step":5,"src0_y":10,"src1_step":7,"src1_y":11,"src2_step":9,"src2_y":12}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void merge_vector_C3_D2_1(int rows, int cols, global ushort* mat_dst, int dst_step, global ushort* mat_src0, int src0_step, global ushort* mat_src1, int src1_step, global ushort* mat_src2, int src2_step) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  if ((x < cols) && (y < rows)) {
    global ushort2* src0_y = (global ushort2*)((global char*)mat_src0 + y * src0_step);
    global ushort2* src1_y = (global ushort2*)((global char*)mat_src1 + y * src1_step);
    global ushort2* src2_y = (global ushort2*)((global char*)mat_src2 + y * src0_step);

    global ushort2* dst_y = (global ushort2*)((global char*)mat_dst + y * dst_step);

    ushort2 value0 = src0_y[hook(10, x)];
    ushort2 value1 = src1_y[hook(11, x)];
    ushort2 value2 = src2_y[hook(12, x)];

    dst_y[hook(13, 3 * x + 0)] = (ushort2)(value0.x, value1.x);
    dst_y[hook(13, 3 * x + 1)] = (ushort2)(value2.x, value0.y);
    dst_y[hook(13, 3 * x + 2)] = (ushort2)(value1.y, value2.y);
  }
}