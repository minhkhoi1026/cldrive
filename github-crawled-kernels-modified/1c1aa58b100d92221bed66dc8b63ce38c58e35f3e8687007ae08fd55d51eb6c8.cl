//{"cols":2,"elements_per_row":4,"gradient":1,"luma":0,"rows":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline int bayerSampleOffset(int step, int rows, int x, int y) {
  return mad24(y, step, x) + ((y % 2) + (x % 2)) * rows * step;
}

kernel void computeGradient(global const float* luma, global float* gradient, const int cols, const int rows, const int elements_per_row) {
  int gidx = get_global_id(0) + 2, gidy = get_global_id(1) + 2;
  if (gidx >= cols - 2 || gidy >= rows - 2) {
    return;
  }
  int offset = mad24(gidy, elements_per_row, gidx);
  luma += offset;

  const float v_grad = fabs(luma[hook(0, elements_per_row)] - luma[hook(0, -elements_per_row)]);
  const float h_grad = fabs(luma[hook(0, 1)] - luma[hook(0, -1)]);

  const float cur_val = luma[hook(0, 0)];
  const float v_grad_p = fabs(cur_val - luma[hook(0, -2 * elements_per_row)]);
  const float h_grad_p = fabs(cur_val - luma[hook(0, -2)]);
  const float v_grad_n = fabs(cur_val - luma[hook(0, 2 * elements_per_row)]);
  const float h_grad_n = fabs(cur_val - luma[hook(0, 2)]);

  const float horiz_grad = 0.5f * h_grad + 0.25f * (h_grad_p + h_grad_n);
  const float verti_grad = 0.5f * v_grad + 0.25f * (v_grad_p + v_grad_n);
  const bool is_vertical_greater = (horiz_grad < verti_grad) && ((verti_grad - horiz_grad) > 1e-5);

  gradient[hook(1, offset + elements_per_row * rows)] = is_vertical_greater ? 0.06f : 0.57f;
  gradient[hook(1, offset)] = is_vertical_greater ? 0.57f : 0.06f;
}