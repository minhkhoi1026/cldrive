//{"m":0,"matrix_dim":3,"offset":4,"peri_col":2,"peri_row":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void lud_internal(global float* m, local float* peri_row, local float* peri_col, int matrix_dim, int offset) {
  int bx = get_group_id(0);
  int by = get_group_id(1);
  int tx = get_local_id(0);
  int ty = get_local_id(1);
  int global_row_id = offset + (by + 1) * 64;
  int global_col_id = offset + (bx + 1) * 64;

  peri_row[hook(1, ty * 64 + tx)] = m[hook(0, (offset + ty) * matrix_dim + global_col_id + tx)];
  peri_col[hook(2, ty * 64 + tx)] = m[hook(0, (global_row_id + ty) * matrix_dim + offset + tx)];

  barrier(0x01);

  float sum = 0;
  for (int i = 0; i < 64; ++i) {
    sum += peri_col[hook(2, ty * 64 + i)] * peri_row[hook(1, i * 64 + tx)];
  }
  m[hook(0, (global_row_id + ty) * matrix_dim + global_col_id + tx)] -= sum;
}