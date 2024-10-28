//{"cols":13,"dst1":6,"dst1_offset":8,"dst1_step":7,"dst2":9,"dst2_offset":11,"dst2_step":10,"rows":12,"src1":0,"src1_offset":2,"src1_step":1,"src2":3,"src2_offset":5,"src2_step":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void arithm_polarToCart_mag_D5(global float* src1, int src1_step, int src1_offset, global float* src2, int src2_step, int src2_offset, global float* dst1, int dst1_step, int dst1_offset, global float* dst2, int dst2_step, int dst2_offset, int rows, int cols) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  if (x < cols && y < rows) {
    int src1_index = mad24(y, src1_step, x + src1_offset);
    int src2_index = mad24(y, src2_step, x + src2_offset);

    int dst1_index = mad24(y, dst1_step, x + dst1_offset);
    int dst2_index = mad24(y, dst2_step, x + dst2_offset);

    float x = src1[hook(0, src1_index)];
    float y = src2[hook(3, src2_index)];

    float alpha = y;

    float a = cos(alpha) * x;
    float b = sin(alpha) * x;

    dst1[hook(6, dst1_index)] = a;
    dst2[hook(9, dst2_index)] = b;
  }
}