//{"Cap":5,"Rx":6,"Ry":7,"Rz":8,"grid_cols":3,"grid_rows":4,"power":0,"step":9,"temp_dst":2,"temp_src":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void hotspot(global float* restrict power, global float* restrict temp_src, global float* restrict temp_dst, int grid_cols, int grid_rows, float Cap, float Rx, float Ry, float Rz, float step) {
  float step_div_Cap = step / Cap;
  float Rx_1 = 1 / Rx;
  float Ry_1 = 1 / Ry;
  float Rz_1 = 1 / Rz;

  for (int r = 0; r < grid_rows; ++r) {
    for (int c = 0; c < grid_cols; ++c) {
      int index = c + r * grid_cols;
      int offset_n = (r == grid_rows - 1) ? 0 : grid_cols;
      int offset_s = (r == 0) ? 0 : -grid_cols;
      int offset_e = (c == grid_cols - 1) ? 0 : 1;
      int offset_w = (c == 0) ? 0 : -1;

      float v = power[hook(0, index)] + (temp_src[hook(1, index + offset_n)] + temp_src[hook(1, index + offset_s)] - 2.0f * temp_src[hook(1, index)]) * Ry_1 + (temp_src[hook(1, index + offset_e)] + temp_src[hook(1, index + offset_w)] - 2.0f * temp_src[hook(1, index)]) * Rx_1 + ((80.0f) - temp_src[hook(1, index)]) * Rz_1;

      float delta = step_div_Cap * v;

      temp_dst[hook(2, index)] = temp_src[hook(1, index)] + delta;
    }
  }
}