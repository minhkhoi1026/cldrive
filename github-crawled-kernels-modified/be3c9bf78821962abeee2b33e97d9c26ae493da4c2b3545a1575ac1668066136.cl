//{"dia":1,"m":0,"matrix_dim":4,"offset":5,"peri_col":3,"peri_row":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void lud_perimeter(global float* m, local float* dia, local float* peri_row, local float* peri_col, int matrix_dim, int offset) {
  int bx = get_group_id(0);
  int tx = get_local_id(0);

  if (tx < 64) {
    int idx = tx;
    int array_offset = offset * matrix_dim + offset;
    for (int i = 0; i < 64 / 2; ++i) {
      dia[hook(1, i * 64 + idx)] = m[hook(0, array_offset + idx)];
      array_offset += matrix_dim;
    }
    array_offset = offset * matrix_dim + offset;
    for (int i = 0; i < 64; ++i) {
      peri_row[hook(2, i * 64 + idx)] = m[hook(0, array_offset + (bx + 1) * 64 + idx)];
      array_offset += matrix_dim;
    }
  } else {
    int idx = tx - 64;
    int array_offset = (offset + 64 / 2) * matrix_dim + offset;
    for (int i = 64 / 2; i < 64; ++i) {
      dia[hook(1, i * 64 + idx)] = m[hook(0, array_offset + idx)];
      array_offset += matrix_dim;
    }
    array_offset = (offset + (bx + 1) * 64) * matrix_dim + offset;
    for (int i = 0; i < 64; ++i) {
      peri_col[hook(3, i * 64 + idx)] = m[hook(0, array_offset + idx)];
      array_offset += matrix_dim;
    }
  }

  barrier(0x01);

  if (tx < 64) {
    int idx = tx;
    for (int i = 1; i < 64; ++i) {
      for (int j = 0; j < i; ++j) {
        peri_row[hook(2, i * 64 + idx)] -= dia[hook(1, i * 64 + j)] * peri_row[hook(2, j * 64 + idx)];
      }
    }
  } else {
    int idx = tx - 64;
    for (int i = 0; i < 64; ++i) {
      for (int j = 0; j < i; ++j) {
        peri_col[hook(3, idx * 64 + i)] -= peri_col[hook(3, idx * 64 + j)] * dia[hook(1, j * 64 + i)];
      }
      peri_col[hook(3, idx * 64 + i)] /= dia[hook(1, i * 64 + i)];
    }
  }

  barrier(0x01);

  if (tx < 64) {
    int idx = tx;
    int array_offset = (offset + 1) * matrix_dim + offset;
    for (int i = 1; i < 64; ++i) {
      m[hook(0, array_offset + (bx + 1) * 64 + idx)] = peri_row[hook(2, i * 64 + idx)];
      array_offset += matrix_dim;
    }
  } else {
    int idx = tx - 64;
    int array_offset = (offset + (bx + 1) * 64) * matrix_dim + offset;
    for (int i = 0; i < 64; ++i) {
      m[hook(0, array_offset + idx)] = peri_col[hook(3, i * 64 + idx)];
      array_offset += matrix_dim;
    }
  }
}