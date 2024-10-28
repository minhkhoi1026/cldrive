//{"m":0,"matrix_dim":1,"offset":2,"peri_col":6,"peri_col[get_local_id(1)]":5,"peri_row":4,"peri_row[get_local_id(1)]":3,"peri_row[i]":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void lud_internal(global float* m, int matrix_dim, int offset) {
  local float peri_row[64][64];
  local float peri_col[64][64];

  int i;
  float sum;

  int global_row_id = offset + (get_group_id(1) + 1) * 64;
  int global_col_id = offset + (get_group_id(0) + 1) * 64;

  peri_row[hook(4, get_local_id(1))][hook(3, get_local_id(0))] = m[hook(0, (offset + get_local_id(1)) * matrix_dim + global_col_id + get_local_id(0))];
  peri_col[hook(6, get_local_id(1))][hook(5, get_local_id(0))] = m[hook(0, (global_row_id + get_local_id(1)) * matrix_dim + offset + get_local_id(0))];

  barrier(0x01);

  sum = 0;
  for (i = 0; i < 64; i++)
    sum += peri_col[hook(6, get_local_id(1))][hook(5, i)] * peri_row[hook(4, i)][hook(7, get_local_id(0))];
  m[hook(0, (global_row_id + get_local_id(1)) * matrix_dim + global_col_id + get_local_id(0))] -= sum;
}