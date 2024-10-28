//{"dia":1,"m":0,"matrix_dim":4,"offset":5,"peri_col":3,"peri_row":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void lud_perimeter(global float* m, local float* dia, local float* peri_row, local float* peri_col, int matrix_dim, int offset) {
  int i, j, array_offset;
  int idx;

  int bx = get_group_id(0);
  int tx = get_local_id(0);

  if (tx < 16) {
    idx = tx;
    array_offset = offset * matrix_dim + offset;
    for (i = 0; i < 16 / 2; i++) {
      dia[hook(1, i * 16 + idx)] = m[hook(0, array_offset + idx)];
      array_offset += matrix_dim;
    }

    array_offset = offset * matrix_dim + offset;
    for (i = 0; i < 16; i++) {
      peri_row[hook(2, i * 16 + idx)] = m[hook(0, array_offset + (bx + 1) * 16 + idx)];
      array_offset += matrix_dim;
    }

  } else {
    idx = tx - 16;

    array_offset = (offset + 16 / 2) * matrix_dim + offset;
    for (i = 16 / 2; i < 16; i++) {
      dia[hook(1, i * 16 + idx)] = m[hook(0, array_offset + idx)];
      array_offset += matrix_dim;
    }

    array_offset = (offset + (bx + 1) * 16) * matrix_dim + offset;
    for (i = 0; i < 16; i++) {
      peri_col[hook(3, i * 16 + idx)] = m[hook(0, array_offset + idx)];
      array_offset += matrix_dim;
    }
  }
  barrier(0x01);

  if (tx < 16) {
    idx = tx;
    for (i = 1; i < 16; i++) {
      for (j = 0; j < i; j++)
        peri_row[hook(2, i * 16 + idx)] -= dia[hook(1, i * 16 + j)] * peri_row[hook(2, j * 16 + idx)];
    }
  } else {
    idx = tx - 16;
    for (i = 0; i < 16; i++) {
      for (j = 0; j < i; j++)
        peri_col[hook(3, idx * 16 + i)] -= peri_col[hook(3, idx * 16 + j)] * dia[hook(1, j * 16 + i)];
      peri_col[hook(3, idx * 16 + i)] /= dia[hook(1, i * 16 + i)];
    }
  }

  barrier(0x01);

  if (tx < 16) {
    idx = tx;
    array_offset = (offset + 1) * matrix_dim + offset;
    for (i = 1; i < 16; i++) {
      m[hook(0, array_offset + (bx + 1) * 16 + idx)] = peri_row[hook(2, i * 16 + idx)];
      array_offset += matrix_dim;
    }
  } else {
    idx = tx - 16;
    array_offset = (offset + (bx + 1) * 16) * matrix_dim + offset;
    for (i = 0; i < 16; i++) {
      m[hook(0, array_offset + idx)] = peri_col[hook(3, i * 16 + idx)];
      array_offset += matrix_dim;
    }
  }
}