//{"m":0,"matrix_dim":2,"offset":3,"shadow":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void lud_diagonal(global float* m, local float* shadow, int matrix_dim, int offset) {
  int i, j;
  int tx = get_local_id(0);

  int array_offset = offset * matrix_dim + offset;
  for (i = 0; i < 16; i++) {
    shadow[hook(1, i * 16 + tx)] = m[hook(0, array_offset + tx)];
    array_offset += matrix_dim;
  }

  barrier(0x01);

  for (i = 0; i < 16 - 1; i++) {
    if (tx > i) {
      for (j = 0; j < i; j++)
        shadow[hook(1, tx * 16 + i)] -= shadow[hook(1, tx * 16 + j)] * shadow[hook(1, j * 16 + i)];
      shadow[hook(1, tx * 16 + i)] /= shadow[hook(1, i * 16 + i)];
    }

    barrier(0x01);
    if (tx > i) {
      for (j = 0; j < i + 1; j++)
        shadow[hook(1, (i + 1) * 16 + tx)] -= shadow[hook(1, (i + 1) * 16 + j)] * shadow[hook(1, j * 16 + tx)];
    }

    barrier(0x01);
  }

  array_offset = (offset + 1) * matrix_dim + offset;
  for (i = 1; i < 16; i++) {
    m[hook(0, array_offset + tx)] = shadow[hook(1, i * 16 + tx)];
    array_offset += matrix_dim;
  }
}