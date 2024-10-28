//{"Rx_1":6,"Ry_1":7,"Rz_1":8,"grid_cols":3,"grid_rows":4,"power":0,"step_div_Cap":5,"temp_dst":2,"temp_src":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
__attribute__((max_global_work_dim(0))) kernel void hotspot(global float* restrict power, global float* restrict temp_src, global float* restrict temp_dst, int grid_cols, int grid_rows, float step_div_Cap, float Rx_1, float Ry_1, float Rz_1) {
  for (int row = 0; row < grid_rows; ++row) {
    for (int col = 0; col < grid_cols; ++col) {
      int index = col + row * grid_cols;
      float c = temp_src[hook(1, index)];

      float n = (row == grid_rows - 1) ? c : temp_src[hook(1, index + grid_cols)];
      float s = (row == 0) ? c : temp_src[hook(1, index - grid_cols)];
      float e = (col == grid_cols - 1) ? c : temp_src[hook(1, index + 1)];
      float w = (col == 0) ? c : temp_src[hook(1, index - 1)];

      float v = power[hook(0, index)] + (n + s - 2.0f * c) * Ry_1 + (e + w - 2.0f * c) * Rx_1 + ((80.0f) - c) * Rz_1;
      float delta = step_div_Cap * v;
      temp_dst[hook(2, index)] = c + delta;
    }
  }
}