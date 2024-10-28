//{"m":0,"matrix_dim":1,"offset":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void lud_perimeter(global float* m, int matrix_dim, int offset) {
  int i, j, array_offset;

  int array_offset_peri;
  int idx;
  if (get_local_id(0) < 64) {
    idx = get_local_id(0);

    array_offset = offset * matrix_dim + offset;

    for (i = 1; i < 64; i++) {
      for (j = 0; j < i; j++)
        m[hook(0, array_offset + i * matrix_dim + (get_group_id(0) + 1) * 64 + idx)] -= m[hook(0, array_offset + i * matrix_dim + j)] * m[hook(0, array_offset + j * matrix_dim + (get_group_id(0) + 1) * 64 + idx)];
    }

  } else {
    idx = get_local_id(0) - 64;

    array_offset_peri = (offset + (get_group_id(0) + 1) * 64) * matrix_dim + offset;

    array_offset = offset * matrix_dim + offset;

    for (i = 0; i < 64; i++) {
      for (j = 0; j < i; j++)
        m[hook(0, array_offset_peri + idx * matrix_dim + i)] -= m[hook(0, array_offset_peri + idx * matrix_dim + j)] * m[hook(0, array_offset + j * matrix_dim + i)];

      m[hook(0, array_offset_peri + idx * matrix_dim + i)] /= m[hook(0, array_offset + i * matrix_dim + i)];
    }
  }
}