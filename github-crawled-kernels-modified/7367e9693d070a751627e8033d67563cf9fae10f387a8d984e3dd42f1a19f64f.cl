//{"image":16,"p11":5,"p11_step":6,"p12":7,"p21":8,"p22":9,"taut":10,"u1":0,"u1_col":1,"u1_offset_x":12,"u1_offset_y":13,"u1_row":2,"u1_step":3,"u2":4,"u2_offset_x":14,"u2_offset_y":15,"u2_step":11}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline float bicubicCoeff(float x_) {
  float x = fabs(x_);
  if (x <= 1.0f)
    return x * x * (1.5f * x - 2.5f) + 1.0f;
  else if (x < 2.0f)
    return x * (x * (-0.5f * x + 2.5f) - 4.0f) + 2.0f;
  else
    return 0.0f;
}

inline float readImage(global const float* image, int x, int y, int rows, int cols, int elemCntPerRow) {
  int i0 = clamp(x, 0, cols - 1);
  int j0 = clamp(y, 0, rows - 1);

  return image[hook(16, j0 * elemCntPerRow + i0)];
}

kernel void estimateDualVariablesKernel(global const float* u1, int u1_col, int u1_row, int u1_step, global const float* u2, global float* p11, int p11_step, global float* p12, global float* p21, global float* p22, float taut, int u2_step, int u1_offset_x, int u1_offset_y, int u2_offset_x, int u2_offset_y) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  if (x < u1_col && y < u1_row) {
    int src_x1 = (x + 1) < (u1_col - 1) ? (x + 1) : (u1_col - 1);
    float u1x = u1[hook(0, (y + u1_offset_y) * u1_step + src_x1 + u1_offset_x)] - u1[hook(0, (y + u1_offset_y) * u1_step + x + u1_offset_x)];

    int src_y1 = (y + 1) < (u1_row - 1) ? (y + 1) : (u1_row - 1);
    float u1y = u1[hook(0, (src_y1 + u1_offset_y) * u1_step + x + u1_offset_x)] - u1[hook(0, (y + u1_offset_y) * u1_step + x + u1_offset_x)];

    int src_x2 = (x + 1) < (u1_col - 1) ? (x + 1) : (u1_col - 1);
    float u2x = u2[hook(4, (y + u2_offset_y) * u2_step + src_x2 + u2_offset_x)] - u2[hook(4, (y + u2_offset_y) * u2_step + x + u2_offset_x)];

    int src_y2 = (y + 1) < (u1_row - 1) ? (y + 1) : (u1_row - 1);
    float u2y = u2[hook(4, (src_y2 + u2_offset_y) * u2_step + x + u2_offset_x)] - u2[hook(4, (y + u2_offset_y) * u2_step + x + u2_offset_x)];

    float g1 = hypot(u1x, u1y);
    float g2 = hypot(u2x, u2y);

    float ng1 = 1.0f + taut * g1;
    float ng2 = 1.0f + taut * g2;

    p11[hook(5, y * p11_step + x)] = (p11[hook(5, y * p11_step + x)] + taut * u1x) / ng1;
    p12[hook(7, y * p11_step + x)] = (p12[hook(7, y * p11_step + x)] + taut * u1y) / ng1;
    p21[hook(8, y * p11_step + x)] = (p21[hook(8, y * p11_step + x)] + taut * u2x) / ng2;
    p22[hook(9, y * p11_step + x)] = (p22[hook(9, y * p11_step + x)] + taut * u2y) / ng2;
  }
}