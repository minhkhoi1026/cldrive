//{"m":0,"matrix_dim":1,"offset":2,"shadow":4,"shadow[get_local_id(0)]":5,"shadow[i + 1]":7,"shadow[i]":3,"shadow[j]":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void lud_diagonal(global float* m, int matrix_dim, int offset) {
  int i, j;
  local float shadow[64][64];

  int array_offset = offset * matrix_dim + offset;
  for (i = 0; i < 64; i++) {
    shadow[hook(4, i)][hook(3, get_local_id(0))] = m[hook(0, array_offset + get_local_id(0))];
    array_offset += matrix_dim;
  }
  barrier(0x01);

  for (i = 0; i < 64 - 1; i++) {
    if (get_local_id(0) > i) {
      for (j = 0; j < i; j++)
        shadow[hook(4, get_local_id(0))][hook(5, i)] -= shadow[hook(4, get_local_id(0))][hook(5, j)] * shadow[hook(4, j)][hook(6, i)];
      shadow[hook(4, get_local_id(0))][hook(5, i)] /= shadow[hook(4, i)][hook(3, i)];

      barrier(0x01);

      for (j = 0; j < i + 1; j++)
        shadow[hook(4, i + 1)][hook(7, get_local_id(0))] -= shadow[hook(4, i + 1)][hook(7, j)] * shadow[hook(4, j)][hook(6, get_local_id(0))];

      barrier(0x01);
    }
  }

  array_offset = (offset + 1) * matrix_dim + offset;
  for (i = 1; i < 64; i++) {
    m[hook(0, array_offset + get_local_id(0))] = shadow[hook(4, i)][hook(3, get_local_id(0))];
    array_offset += matrix_dim;
  }
}