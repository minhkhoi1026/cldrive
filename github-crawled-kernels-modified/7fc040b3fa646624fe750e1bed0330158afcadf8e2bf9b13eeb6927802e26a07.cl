//{"a_height":3,"matrix_a":0,"matrix_b":1,"matrix_c":2,"start":4,"tile_a":6,"tile_a[tile_row]":5,"tile_b":8,"tile_b[k]":9,"tile_b[tile_row]":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void fully_forward2(global float* matrix_a, global float* matrix_b, global float* matrix_c, const unsigned int a_height, const unsigned int start) {
  const unsigned int a_width = 128;
  const unsigned int b_height = a_width;
  const unsigned int b_width = 10;
  const unsigned int c_height = a_height;
  const unsigned int c_width = b_width;

  const unsigned int matrix_c_row = get_group_id(0) * get_local_size(0) + get_local_id(1);
  const unsigned int matrix_c_col = get_local_id(0);

  local float tile_a[32][32];
  local float tile_b[32][32];
  const unsigned int tile_row = get_local_id(1);
  const unsigned int tile_col = get_local_id(0);

  float c = 0;

  for (unsigned int tile = 0; tile < 128 / 32; tile++) {
    if ((matrix_c_row < a_height) && (tile * 32 + tile_col < a_width)) {
      tile_a[hook(6, tile_row)][hook(5, tile_col)] = matrix_a[hook(0, matrix_c_row * a_width + tile * 32 + tile_col + start * a_width)];
    } else {
      tile_a[hook(6, tile_row)][hook(5, tile_col)] = 0.0f;
    }
    if ((tile * 32 + tile_row < b_height) && (matrix_c_col < b_width)) {
      tile_b[hook(8, tile_row)][hook(7, tile_col)] = matrix_b[hook(1, (tile * 32 + tile_row) * b_width + matrix_c_col)];
    } else {
      tile_b[hook(8, tile_row)][hook(7, tile_col)] = 0.0f;
    }

    barrier(0x01);
    for (unsigned int k = 0; k < 32; k++) {
      c += tile_a[hook(6, tile_row)][hook(5, k)] * tile_b[hook(8, k)][hook(9, tile_col)];
    }
    barrier(0x01);
  }

  if ((matrix_c_row < c_height) && (matrix_c_col < c_width)) {
    matrix_c[hook(2, matrix_c_row * c_width + matrix_c_col + start * c_width)] = c;
  }
}