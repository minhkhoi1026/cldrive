//{"cols":1,"dst_step":3,"dst_y":10,"mat_dst":2,"mat_src0":4,"mat_src1":6,"rows":0,"src0_step":5,"src0_y":8,"src1_step":7,"src1_y":9}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void merge_vector_C2_D4_1(int rows, int cols, global int* mat_dst, int dst_step, global int* mat_src0, int src0_step, global int* mat_src1, int src1_step) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  if ((x < cols) && (y < rows)) {
    global int* src0_y = (global int*)((global uchar*)mat_src0 + y * src0_step);
    global int* src1_y = (global int*)((global uchar*)mat_src1 + y * src1_step);
    global int2* dst_y = (global int2*)((global uchar*)mat_dst + y * dst_step);

    int value1 = src0_y[hook(8, x)];
    int value2 = src1_y[hook(9, x)];

    int2 value;
    value.even = value1;
    value.odd = value2;

    dst_y[hook(10, x)] = value;
  }
}