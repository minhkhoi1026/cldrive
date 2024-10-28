//{"cols":9,"dst":6,"dst_offset1":8,"dst_step1":7,"rows":10,"src1":0,"src1_offset1":2,"src1_step1":1,"src2":3,"src2_offset1":5,"src2_step1":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void arithm_phase_inradians_D5(global float* src1, int src1_step1, int src1_offset1, global float* src2, int src2_step1, int src2_offset1, global float* dst, int dst_step1, int dst_offset1, int cols, int rows) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  if (x < cols && y < rows) {
    int src1_index = mad24(y, src1_step1, x + src1_offset1);
    int src2_index = mad24(y, src2_step1, x + src2_offset1);
    int dst_index = mad24(y, dst_step1, x + dst_offset1);

    float data1 = src1[hook(0, src1_index)];
    float data2 = src2[hook(3, src2_index)];
    float tmp = atan2(data2, data1);

    if (tmp < 0)
      tmp += (2 * 3.14159265358979323846264338327950288f);

    dst[hook(6, dst_index)] = tmp;
  }
}