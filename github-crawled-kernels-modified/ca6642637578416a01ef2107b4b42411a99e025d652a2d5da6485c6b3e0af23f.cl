//{"m":0,"matrix_dim":2,"offset":3,"shadow":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void lud_diagonal(global float* m, local float* shadow, int matrix_dim, int offset) {
  int tx = get_local_id(0);
  int array_offset = offset * matrix_dim + offset;

  for (int i = 0; i < 64; ++i) {
    shadow[hook(1, i * 64 + tx)] = m[hook(0, array_offset + tx)];
    array_offset += matrix_dim;
  }

  barrier(0x01);

  for (int i = 0; i < 64 - 1; ++i) {
    if (tx > i) {
      for (int j = 0; j < i; ++j) {
        shadow[hook(1, tx * 64 + i)] -= shadow[hook(1, tx * 64 + j)] * shadow[hook(1, j * 64 + i)];
      }
      shadow[hook(1, tx * 64 + i)] /= shadow[hook(1, i * 64 + i)];
    }

    barrier(0x01);

    if (tx > i) {
      for (int j = 0; j < i + 1; ++j) {
        shadow[hook(1, (i + 1) * 64 + tx)] -= shadow[hook(1, (i + 1) * 64 + j)] * shadow[hook(1, j * 64 + tx)];
      }
    }
    barrier(0x01);
  }

  array_offset = (offset + 1) * matrix_dim + offset;
  for (int i = 1; i < 64; ++i) {
    m[hook(0, array_offset + tx)] = shadow[hook(1, i * 64 + tx)];
    array_offset += matrix_dim;
  }
}