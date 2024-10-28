//{"A_local":4,"B_local":5,"accumulator":1,"matrix":0,"start_row":3,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
__attribute((reqd_work_group_size(16, 16, 1))) __attribute((num_simd_work_items(4))) kernel void gbc(global float* restrict matrix, global float* restrict accumulator, int width, int start_row) {
  int i, j;

  local float A_local[16 * 16];
  local float B_local[16 * 16];

  int global_col = get_global_id(0);
  int global_row = get_global_id(1);
  int num_rows = get_global_size(1);

  int local_col = get_local_id(0);
  int local_row = get_local_id(1);

  float acc = accumulator[hook(1, global_row * 16 + global_col)];
  float sum = 0;

  for (i = 0; i < width; i += 16) {
    A_local[hook(4, local_row * 16 + local_col)] = matrix[hook(0, (start_row + local_row) * width + local_col + i)];
    B_local[hook(5, local_row * 16 + local_col)] = matrix[hook(0, global_row * width + local_col + i)];
    barrier(0x01);
    for (int j = 0; j < 16; ++j) {
      sum += A_local[hook(4, local_col * 16 + j)] * B_local[hook(5, local_row * 16 + j)];
    }
    barrier(0x01);
  }

  if (sum < 0)
    sum = 0;
  acc += sum;

  accumulator[hook(1, global_row * 16 + global_col)] = acc;
}