//{"a_height":3,"matrix_a":0,"matrix_b":1,"matrix_c":2,"start":4,"tile_a":6,"tile_a[tile_row1]":5,"tile_a[tile_row2]":7,"tile_b1":9,"tile_b1[k]":20,"tile_b1[tile_row1]":8,"tile_b1[tile_row2]":16,"tile_b2":11,"tile_b2[k]":21,"tile_b2[tile_row1]":10,"tile_b2[tile_row2]":17,"tile_b3":13,"tile_b3[k]":22,"tile_b3[tile_row1]":12,"tile_b3[tile_row2]":18,"tile_b4":15,"tile_b4[k]":23,"tile_b4[tile_row1]":14,"tile_b4[tile_row2]":19}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void fully_forward1(global float* matrix_a, global float* matrix_b, global float* matrix_c, const unsigned int a_height, const unsigned int start) {
  const unsigned int a_width = 1024;
  const unsigned int b_width = 128;
  const unsigned int c_height = a_height;
  const unsigned int c_width = b_width;

  const unsigned int matrix_c_row1 = get_group_id(0) * 32 + get_local_id(1);
  const unsigned int matrix_c_row2 = matrix_c_row1 + 16;

  const unsigned int matrix_c_col1 = get_local_id(0);
  const unsigned int matrix_c_col2 = matrix_c_col1 + 16;
  const unsigned int matrix_c_col3 = matrix_c_col2 + 16;
  const unsigned int matrix_c_col4 = matrix_c_col3 + 16;
  const unsigned int matrix_c_col5 = matrix_c_col4 + 16;
  const unsigned int matrix_c_col6 = matrix_c_col5 + 16;
  const unsigned int matrix_c_col7 = matrix_c_col6 + 16;
  const unsigned int matrix_c_col8 = matrix_c_col7 + 16;

  local float tile_a[32][32];
  local float tile_b1[32][32];
  local float tile_b2[32][32];
  local float tile_b3[32][32];
  local float tile_b4[32][32];

  const unsigned int tile_row1 = get_local_id(1);
  const unsigned int tile_row2 = tile_row1 + 16;
  const unsigned int tile_col1 = get_local_id(0);
  const unsigned int tile_col2 = tile_col1 + 16;

  float c_01 = 0;
  float c_02 = 0;
  float c_03 = 0;
  float c_04 = 0;
  float c_05 = 0;
  float c_06 = 0;
  float c_07 = 0;
  float c_08 = 0;
  float c_09 = 0;
  float c_10 = 0;
  float c_11 = 0;
  float c_12 = 0;
  float c_13 = 0;
  float c_14 = 0;
  float c_15 = 0;
  float c_16 = 0;

  for (unsigned int tile = 0; tile < (1024 / 32); tile++) {
    if (matrix_c_row2 < a_height) {
      const unsigned int matrix_a_start = start * a_width;
      const unsigned int matrix_a_row1_start = matrix_c_row1 * a_width;
      const unsigned int matrix_a_row2_start = matrix_c_row2 * a_width;
      const unsigned int matrix_a_col_start = tile * 32;
      tile_a[hook(6, tile_row1)][hook(5, tile_col1)] = matrix_a[hook(0, matrix_a_start + matrix_a_row1_start + matrix_a_col_start + tile_col1)];
      tile_a[hook(6, tile_row1)][hook(5, tile_col2)] = matrix_a[hook(0, matrix_a_start + matrix_a_row1_start + matrix_a_col_start + tile_col2)];
      tile_a[hook(6, tile_row2)][hook(7, tile_col1)] = matrix_a[hook(0, matrix_a_start + matrix_a_row2_start + matrix_a_col_start + tile_col1)];
      tile_a[hook(6, tile_row2)][hook(7, tile_col2)] = matrix_a[hook(0, matrix_a_start + matrix_a_row2_start + matrix_a_col_start + tile_col2)];
    } else if (matrix_c_row1 < a_height) {
      const unsigned int matrix_a_start = start * a_width;
      const unsigned int matrix_a_row1_start = matrix_c_row1 * a_width;
      const unsigned int matrix_a_col_start = tile * 32;
      tile_a[hook(6, tile_row1)][hook(5, tile_col1)] = matrix_a[hook(0, matrix_a_start + matrix_a_row1_start + matrix_a_col_start + tile_col1)];
      tile_a[hook(6, tile_row1)][hook(5, tile_col2)] = matrix_a[hook(0, matrix_a_start + matrix_a_row1_start + matrix_a_col_start + tile_col2)];
      tile_a[hook(6, tile_row2)][hook(7, tile_col1)] = 0;
      tile_a[hook(6, tile_row2)][hook(7, tile_col2)] = 0;
    } else {
      tile_a[hook(6, tile_row1)][hook(5, tile_col1)] = 0;
      tile_a[hook(6, tile_row1)][hook(5, tile_col2)] = 0;
      tile_a[hook(6, tile_row2)][hook(7, tile_col1)] = 0;
      tile_a[hook(6, tile_row2)][hook(7, tile_col2)] = 0;
    }

    const unsigned int matrix_b_start1 = (tile * 32 + tile_row1) * b_width;
    const unsigned int matrix_b_start2 = (tile * 32 + tile_row2) * b_width;

    tile_b1[hook(9, tile_row1)][hook(8, tile_col1)] = matrix_b[hook(1, matrix_b_start1 + matrix_c_col1)];
    tile_b1[hook(9, tile_row1)][hook(8, tile_col2)] = matrix_b[hook(1, matrix_b_start1 + matrix_c_col2)];
    tile_b2[hook(11, tile_row1)][hook(10, tile_col1)] = matrix_b[hook(1, matrix_b_start1 + matrix_c_col3)];
    tile_b2[hook(11, tile_row1)][hook(10, tile_col2)] = matrix_b[hook(1, matrix_b_start1 + matrix_c_col4)];
    tile_b3[hook(13, tile_row1)][hook(12, tile_col1)] = matrix_b[hook(1, matrix_b_start1 + matrix_c_col5)];
    tile_b3[hook(13, tile_row1)][hook(12, tile_col2)] = matrix_b[hook(1, matrix_b_start1 + matrix_c_col6)];
    tile_b4[hook(15, tile_row1)][hook(14, tile_col1)] = matrix_b[hook(1, matrix_b_start1 + matrix_c_col7)];
    tile_b4[hook(15, tile_row1)][hook(14, tile_col2)] = matrix_b[hook(1, matrix_b_start1 + matrix_c_col8)];

    tile_b1[hook(9, tile_row2)][hook(16, tile_col1)] = matrix_b[hook(1, matrix_b_start2 + matrix_c_col1)];
    tile_b1[hook(9, tile_row2)][hook(16, tile_col2)] = matrix_b[hook(1, matrix_b_start2 + matrix_c_col2)];
    tile_b2[hook(11, tile_row2)][hook(17, tile_col1)] = matrix_b[hook(1, matrix_b_start2 + matrix_c_col3)];
    tile_b2[hook(11, tile_row2)][hook(17, tile_col2)] = matrix_b[hook(1, matrix_b_start2 + matrix_c_col4)];
    tile_b3[hook(13, tile_row2)][hook(18, tile_col1)] = matrix_b[hook(1, matrix_b_start2 + matrix_c_col5)];
    tile_b3[hook(13, tile_row2)][hook(18, tile_col2)] = matrix_b[hook(1, matrix_b_start2 + matrix_c_col6)];
    tile_b4[hook(15, tile_row2)][hook(19, tile_col1)] = matrix_b[hook(1, matrix_b_start2 + matrix_c_col7)];
    tile_b4[hook(15, tile_row2)][hook(19, tile_col2)] = matrix_b[hook(1, matrix_b_start2 + matrix_c_col8)];

    barrier(0x01);
    for (unsigned int k = 0; k < 32; k++) {
      const float a1 = tile_a[hook(6, tile_row1)][hook(5, k)];
      const float a2 = tile_a[hook(6, tile_row2)][hook(7, k)];
      c_01 += a1 * tile_b1[hook(9, k)][hook(20, tile_col1)];
      c_02 += a1 * tile_b1[hook(9, k)][hook(20, tile_col2)];
      c_03 += a1 * tile_b2[hook(11, k)][hook(21, tile_col1)];
      c_04 += a1 * tile_b2[hook(11, k)][hook(21, tile_col2)];
      c_05 += a1 * tile_b3[hook(13, k)][hook(22, tile_col1)];
      c_06 += a1 * tile_b3[hook(13, k)][hook(22, tile_col2)];
      c_07 += a1 * tile_b4[hook(15, k)][hook(23, tile_col1)];
      c_08 += a1 * tile_b4[hook(15, k)][hook(23, tile_col2)];

      c_09 += a2 * tile_b1[hook(9, k)][hook(20, tile_col1)];
      c_10 += a2 * tile_b1[hook(9, k)][hook(20, tile_col2)];
      c_11 += a2 * tile_b2[hook(11, k)][hook(21, tile_col1)];
      c_12 += a2 * tile_b2[hook(11, k)][hook(21, tile_col2)];
      c_13 += a2 * tile_b3[hook(13, k)][hook(22, tile_col1)];
      c_14 += a2 * tile_b3[hook(13, k)][hook(22, tile_col2)];
      c_15 += a2 * tile_b4[hook(15, k)][hook(23, tile_col1)];
      c_16 += a2 * tile_b4[hook(15, k)][hook(23, tile_col2)];
    }
    barrier(0x01);
  }

  if (matrix_c_row2 < c_height) {
    const unsigned int matrix_c_start = start * c_width;
    const unsigned int matrix_c_row_start1 = matrix_c_row1 * c_width;
    const unsigned int matrix_c_row_start2 = matrix_c_row2 * c_width;
    matrix_c[hook(2, matrix_c_start + matrix_c_row_start1 + matrix_c_col1)] = (c_01 <= 0) ? 0 : c_01;
    matrix_c[hook(2, matrix_c_start + matrix_c_row_start1 + matrix_c_col2)] = (c_02 <= 0) ? 0 : c_02;
    matrix_c[hook(2, matrix_c_start + matrix_c_row_start1 + matrix_c_col3)] = (c_03 <= 0) ? 0 : c_03;
    matrix_c[hook(2, matrix_c_start + matrix_c_row_start1 + matrix_c_col4)] = (c_04 <= 0) ? 0 : c_04;
    matrix_c[hook(2, matrix_c_start + matrix_c_row_start1 + matrix_c_col5)] = (c_05 <= 0) ? 0 : c_05;
    matrix_c[hook(2, matrix_c_start + matrix_c_row_start1 + matrix_c_col6)] = (c_06 <= 0) ? 0 : c_06;
    matrix_c[hook(2, matrix_c_start + matrix_c_row_start1 + matrix_c_col7)] = (c_07 <= 0) ? 0 : c_07;
    matrix_c[hook(2, matrix_c_start + matrix_c_row_start1 + matrix_c_col8)] = (c_08 <= 0) ? 0 : c_08;

    matrix_c[hook(2, matrix_c_start + matrix_c_row_start2 + matrix_c_col1)] = (c_09 <= 0) ? 0 : c_09;
    matrix_c[hook(2, matrix_c_start + matrix_c_row_start2 + matrix_c_col2)] = (c_10 <= 0) ? 0 : c_10;
    matrix_c[hook(2, matrix_c_start + matrix_c_row_start2 + matrix_c_col3)] = (c_11 <= 0) ? 0 : c_11;
    matrix_c[hook(2, matrix_c_start + matrix_c_row_start2 + matrix_c_col4)] = (c_12 <= 0) ? 0 : c_12;
    matrix_c[hook(2, matrix_c_start + matrix_c_row_start2 + matrix_c_col5)] = (c_13 <= 0) ? 0 : c_13;
    matrix_c[hook(2, matrix_c_start + matrix_c_row_start2 + matrix_c_col6)] = (c_14 <= 0) ? 0 : c_14;
    matrix_c[hook(2, matrix_c_start + matrix_c_row_start2 + matrix_c_col7)] = (c_15 <= 0) ? 0 : c_15;
    matrix_c[hook(2, matrix_c_start + matrix_c_row_start2 + matrix_c_col8)] = (c_16 <= 0) ? 0 : c_16;
  } else if (matrix_c_row1 < c_height) {
    const unsigned int matrix_c_start = start * c_width;
    const unsigned int matrix_c_row_start1 = matrix_c_row1 * c_width;
    matrix_c[hook(2, matrix_c_start + matrix_c_row_start1 + matrix_c_col1)] = (c_01 <= 0) ? 0 : c_01;
    matrix_c[hook(2, matrix_c_start + matrix_c_row_start1 + matrix_c_col2)] = (c_02 <= 0) ? 0 : c_02;
    matrix_c[hook(2, matrix_c_start + matrix_c_row_start1 + matrix_c_col3)] = (c_03 <= 0) ? 0 : c_03;
    matrix_c[hook(2, matrix_c_start + matrix_c_row_start1 + matrix_c_col4)] = (c_04 <= 0) ? 0 : c_04;
    matrix_c[hook(2, matrix_c_start + matrix_c_row_start1 + matrix_c_col5)] = (c_05 <= 0) ? 0 : c_05;
    matrix_c[hook(2, matrix_c_start + matrix_c_row_start1 + matrix_c_col6)] = (c_06 <= 0) ? 0 : c_06;
    matrix_c[hook(2, matrix_c_start + matrix_c_row_start1 + matrix_c_col7)] = (c_07 <= 0) ? 0 : c_07;
    matrix_c[hook(2, matrix_c_start + matrix_c_row_start1 + matrix_c_col8)] = (c_08 <= 0) ? 0 : c_08;
  }
}