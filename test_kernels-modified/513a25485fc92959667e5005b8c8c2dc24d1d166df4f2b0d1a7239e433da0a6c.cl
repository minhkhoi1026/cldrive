//{"dia":4,"dia[i]":3,"dia[j]":11,"m":0,"matrix_dim":1,"offset":2,"peri_col":8,"peri_col[i]":7,"peri_col[idx]":10,"peri_row":6,"peri_row[i]":5,"peri_row[j]":9}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void lud_perimeter(global float* m, int matrix_dim, int offset) {
  local float dia[64][64];
  local float peri_row[64][64];
  local float peri_col[64][64];

  int i, j, array_offset;
  int idx;

  if (get_local_id(0) < 64) {
    idx = get_local_id(0);

    array_offset = offset * matrix_dim + offset;
    for (i = 0; i < 64 / 2; i++) {
      dia[hook(4, i)][hook(3, idx)] = m[hook(0, array_offset + idx)];
      array_offset += matrix_dim;
    }

    array_offset = offset * matrix_dim + offset;
    for (i = 0; i < 64; i++) {
      peri_row[hook(6, i)][hook(5, idx)] = m[hook(0, array_offset + (get_group_id(0) + 1) * 64 + idx)];
      array_offset += matrix_dim;
    }

  } else {
    idx = get_local_id(0) - 64;

    array_offset = (offset + 64 / 2) * matrix_dim + offset;
    for (i = 64 / 2; i < 64; i++) {
      dia[hook(4, i)][hook(3, idx)] = m[hook(0, array_offset + idx)];
      array_offset += matrix_dim;
    }

    array_offset = (offset + (get_group_id(0) + 1) * 64) * matrix_dim + offset;
    for (i = 0; i < 64; i++) {
      peri_col[hook(8, i)][hook(7, idx)] = m[hook(0, array_offset + idx)];
      array_offset += matrix_dim;
    }
  }
  barrier(0x01);

  if (get_local_id(0) < 64) {
    idx = get_local_id(0);
    for (i = 1; i < 64; i++) {
      for (j = 0; j < i; j++)
        peri_row[hook(6, i)][hook(5, idx)] -= dia[hook(4, i)][hook(3, j)] * peri_row[hook(6, j)][hook(9, idx)];
    }

    array_offset = (offset + 1) * matrix_dim + offset;
    for (i = 1; i < 64; i++) {
      m[hook(0, array_offset + (get_group_id(0) + 1) * 64 + idx)] = peri_row[hook(6, i)][hook(5, idx)];
      array_offset += matrix_dim;
    }
  } else {
    idx = get_local_id(0) - 64;
    for (i = 0; i < 64; i++) {
      for (j = 0; j < i; j++)
        peri_col[hook(8, idx)][hook(10, i)] -= peri_col[hook(8, idx)][hook(10, j)] * dia[hook(4, j)][hook(11, i)];
      peri_col[hook(8, idx)][hook(10, i)] /= dia[hook(4, i)][hook(3, i)];
    }

    barrier(0x01);

    array_offset = (offset + (get_group_id(0) + 1) * 64) * matrix_dim + offset;
    for (i = 0; i < 64; i++) {
      m[hook(0, array_offset + idx)] = peri_col[hook(8, i)][hook(7, idx)];
      array_offset += matrix_dim;
    }
  }
}