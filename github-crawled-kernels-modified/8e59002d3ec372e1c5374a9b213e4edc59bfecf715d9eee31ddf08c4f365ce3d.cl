//{"cols":10,"dst1":3,"dst1_offset":5,"dst1_step":4,"dst2":6,"dst2_offset":8,"dst2_step":7,"rows":9,"src":0,"src_offset":2,"src_step":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void arithm_polarToCart_D5(global float* src, int src_step, int src_offset, global float* dst1, int dst1_step, int dst1_offset, global float* dst2, int dst2_step, int dst2_offset, int rows, int cols) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  if (x < cols && y < rows) {
    int src_index = mad24(y, src_step, x + src_offset);

    int dst1_index = mad24(y, dst1_step, x + dst1_offset);
    int dst2_index = mad24(y, dst2_step, x + dst2_offset);

    float y = src[hook(0, src_index)];

    float alpha = y;

    float a = cos(alpha);
    float b = sin(alpha);

    dst1[hook(3, dst1_index)] = a;
    dst2[hook(6, dst2_index)] = b;
  }
}