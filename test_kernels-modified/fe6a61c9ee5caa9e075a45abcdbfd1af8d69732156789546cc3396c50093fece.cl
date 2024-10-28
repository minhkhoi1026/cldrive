//{"m":0,"matrix_dim":1,"offset":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void lud_diagonal(global float* m, int matrix_dim, int offset) {
  int i, j;
  int array_offset = offset * matrix_dim + offset;

  for (i = 0; i < 64; i++) {
    if (get_local_id(0) > i) {
      for (j = 0; j < i; j++)
        m[hook(0, array_offset + get_local_id(0) * matrix_dim + i)] -= m[hook(0, array_offset + get_local_id(0) * matrix_dim + j)] * m[hook(0, array_offset + j * matrix_dim + i)];
      m[hook(0, array_offset + get_local_id(0) * matrix_dim + i)] /= m[hook(0, array_offset + i * matrix_dim + i)];
    }
    barrier(0x02);
    if (get_local_id(0) > i) {
      for (j = 0; j < i + 1; j++)
        m[hook(0, array_offset + (i + 1) * matrix_dim + get_local_id(0))] -= m[hook(0, array_offset + (i + 1) * matrix_dim + j)] * m[hook(0, array_offset + j * matrix_dim + get_local_id(0))];
    }
    barrier(0x02);
  }
}