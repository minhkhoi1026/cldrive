//{"d_step":6,"dx":4,"dy":5,"src_col":1,"src_ptr":0,"src_row":2,"src_step":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void centeredGradientKernel(global const float* src_ptr, int src_col, int src_row, int src_step, global float* dx, global float* dy, int d_step) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  if ((x < src_col) && (y < src_row)) {
    int src_x1 = (x + 1) < (src_col - 1) ? (x + 1) : (src_col - 1);
    int src_x2 = (x - 1) > 0 ? (x - 1) : 0;
    dx[hook(4, y * d_step + x)] = 0.5f * (src_ptr[hook(0, y * src_step + src_x1)] - src_ptr[hook(0, y * src_step + src_x2)]);

    int src_y1 = (y + 1) < (src_row - 1) ? (y + 1) : (src_row - 1);
    int src_y2 = (y - 1) > 0 ? (y - 1) : 0;
    dy[hook(5, y * d_step + x)] = 0.5f * (src_ptr[hook(0, src_y1 * src_step + x)] - src_ptr[hook(0, src_y2 * src_step + x)]);
  }
}