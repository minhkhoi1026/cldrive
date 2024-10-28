//{"m":0,"matrix_dim":1,"offset":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void lud_internal(global float* m, int matrix_dim, int offset) {
  int i;
  float sum;

  int global_row_id = offset + (get_group_id(1) + 1) * 64;
  int global_col_id = offset + (get_group_id(0) + 1) * 64;

  sum = 0;
  for (i = 0; i < 64; i++)
    sum += m[hook(0, (global_row_id + get_local_id(1)) * matrix_dim + offset + i)] * m[hook(0, (offset + i) * matrix_dim + global_col_id + get_local_id(0))];
  m[hook(0, (global_row_id + get_local_id(1)) * matrix_dim + global_col_id + get_local_id(0))] -= sum;
}