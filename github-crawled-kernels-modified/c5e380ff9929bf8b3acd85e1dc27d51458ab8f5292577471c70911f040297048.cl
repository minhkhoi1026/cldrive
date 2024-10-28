//{"cols":1,"dst_step":3,"dst_y":10,"mat_dst":2,"mat_src0":4,"mat_src1":6,"rows":0,"src0_step":5,"src0_y":8,"src1_step":7,"src1_y":9}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void merge_vector_C2_D0_1(int rows, int cols, global uchar* mat_dst, int dst_step, global uchar* mat_src0, int src0_step, global uchar* mat_src1, int src1_step) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  if ((x < cols) && (y < rows)) {
    global uchar4* src0_y = (global uchar4*)(mat_src0 + y * src0_step);
    global uchar4* src1_y = (global uchar4*)(mat_src1 + y * src1_step);
    global uchar8* dst_y = (global uchar8*)(mat_dst + y * dst_step);

    uchar4 value1 = src0_y[hook(8, x)];
    uchar4 value2 = src1_y[hook(9, x)];

    uchar8 value;
    value.even = value1;
    value.odd = value2;

    dst_y[hook(10, x)] = value;
  }
}