//{"matrix_a":0,"matrix_b":1,"matrix_c":2,"start":3,"tile_a":5,"tile_a[tile_row1]":4,"tile_a[tile_row2]":6,"tile_b_1":8,"tile_b_1[k]":16,"tile_b_1[tile_row1]":7,"tile_b_1[tile_row2]":13,"tile_b_2":10,"tile_b_2[k]":17,"tile_b_2[tile_row1]":9,"tile_b_2[tile_row2]":14,"tile_b_3":12,"tile_b_3[k]":18,"tile_b_3[tile_row1]":11,"tile_b_3[tile_row2]":15}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void matrix_multiplication1(global float* matrix_a, global float* matrix_b, global float* matrix_c, const unsigned int start) {
  const unsigned int a_width = (1 * (5 * 5));
  const unsigned int b_height = (5 * 5);
  const unsigned int b_width = ((28 - 5 + 1) * (28 - 5 + 1));
  const unsigned int c_height = 32;
  const unsigned int c_width = b_width;

  const unsigned int num_idx = get_group_id(1);

  const unsigned int matrix_c_row1 = get_local_id(1);
  const unsigned int matrix_c_row2 = matrix_c_row1 + 16;

  const unsigned int matrix_c_col1 = get_group_id(0) * (((28 - 5 + 1) * (28 - 5 + 1)) / 6) + get_local_id(0);
  const unsigned int matrix_c_col2 = matrix_c_col1 + 16;
  const unsigned int matrix_c_col3 = matrix_c_col2 + 16;
  const unsigned int matrix_c_col4 = matrix_c_col3 + 16;
  const unsigned int matrix_c_col5 = matrix_c_col4 + 16;
  const unsigned int matrix_c_col6 = matrix_c_col5 + 16;

  local float tile_a[32][32];
  local float tile_b_1[32][32];
  local float tile_b_2[32][32];
  local float tile_b_3[32][32];

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

  tile_a[hook(5, tile_row1)][hook(4, tile_col1)] = matrix_a[hook(0, matrix_c_row1 * a_width + tile_col1)];
  tile_a[hook(5, tile_row2)][hook(6, tile_col1)] = matrix_a[hook(0, matrix_c_row2 * a_width + tile_col1)];
  if (tile_col2 < a_width) {
    tile_a[hook(5, tile_row1)][hook(4, tile_col2)] = matrix_a[hook(0, matrix_c_row1 * a_width + tile_col2)];
    tile_a[hook(5, tile_row2)][hook(6, tile_col2)] = matrix_a[hook(0, matrix_c_row2 * a_width + tile_col2)];
  } else {
    tile_a[hook(5, tile_row1)][hook(4, tile_col2)] = 0;
    tile_a[hook(5, tile_row2)][hook(6, tile_col2)] = 0;
  }

  const unsigned int matrix_b_start = (start + num_idx) * b_height * b_width;
  const unsigned int matrix_b_row1 = tile_row1 * b_width;

  tile_b_1[hook(8, tile_row1)][hook(7, tile_col1)] = matrix_b[hook(1, matrix_b_start + matrix_b_row1 + matrix_c_col1)];
  tile_b_1[hook(8, tile_row1)][hook(7, tile_col2)] = matrix_b[hook(1, matrix_b_start + matrix_b_row1 + matrix_c_col2)];
  tile_b_2[hook(10, tile_row1)][hook(9, tile_col1)] = matrix_b[hook(1, matrix_b_start + matrix_b_row1 + matrix_c_col3)];
  tile_b_2[hook(10, tile_row1)][hook(9, tile_col2)] = matrix_b[hook(1, matrix_b_start + matrix_b_row1 + matrix_c_col4)];
  tile_b_3[hook(12, tile_row1)][hook(11, tile_col1)] = matrix_b[hook(1, matrix_b_start + matrix_b_row1 + matrix_c_col5)];
  tile_b_3[hook(12, tile_row1)][hook(11, tile_col2)] = matrix_b[hook(1, matrix_b_start + matrix_b_row1 + matrix_c_col6)];

  if (tile_row2 < b_height) {
    const unsigned int matrix_b_row2 = tile_row2 * b_width;
    tile_b_1[hook(8, tile_row2)][hook(13, tile_col1)] = matrix_b[hook(1, matrix_b_start + matrix_b_row2 + matrix_c_col1)];
    tile_b_1[hook(8, tile_row2)][hook(13, tile_col2)] = matrix_b[hook(1, matrix_b_start + matrix_b_row2 + matrix_c_col2)];
    tile_b_2[hook(10, tile_row2)][hook(14, tile_col1)] = matrix_b[hook(1, matrix_b_start + matrix_b_row2 + matrix_c_col3)];
    tile_b_2[hook(10, tile_row2)][hook(14, tile_col2)] = matrix_b[hook(1, matrix_b_start + matrix_b_row2 + matrix_c_col4)];
    tile_b_3[hook(12, tile_row2)][hook(15, tile_col1)] = matrix_b[hook(1, matrix_b_start + matrix_b_row2 + matrix_c_col5)];
    tile_b_3[hook(12, tile_row2)][hook(15, tile_col2)] = matrix_b[hook(1, matrix_b_start + matrix_b_row2 + matrix_c_col6)];
  } else {
    tile_b_1[hook(8, tile_row2)][hook(13, tile_col1)] = 0;
    tile_b_1[hook(8, tile_row2)][hook(13, tile_col2)] = 0;
    tile_b_2[hook(10, tile_row2)][hook(14, tile_col1)] = 0;
    tile_b_2[hook(10, tile_row2)][hook(14, tile_col2)] = 0;
    tile_b_3[hook(12, tile_row2)][hook(15, tile_col1)] = 0;
    tile_b_3[hook(12, tile_row2)][hook(15, tile_col2)] = 0;
  }

  barrier(0x01);
  for (unsigned int k = 0; k < (5 * 5); k++) {
    const float a_1 = tile_a[hook(5, tile_row1)][hook(4, k)];
    const float a_2 = tile_a[hook(5, tile_row2)][hook(6, k)];
    const float b_1 = tile_b_1[hook(8, k)][hook(16, tile_col1)];
    const float b_2 = tile_b_1[hook(8, k)][hook(16, tile_col2)];
    const float b_3 = tile_b_2[hook(10, k)][hook(17, tile_col1)];
    const float b_4 = tile_b_2[hook(10, k)][hook(17, tile_col2)];
    const float b_5 = tile_b_3[hook(12, k)][hook(18, tile_col1)];
    const float b_6 = tile_b_3[hook(12, k)][hook(18, tile_col2)];

    c_01 += a_1 * b_1;
    c_02 += a_1 * b_2;
    c_03 += a_1 * b_3;
    c_04 += a_1 * b_4;
    c_05 += a_1 * b_5;
    c_06 += a_1 * b_6;

    c_07 += a_2 * b_1;
    c_08 += a_2 * b_2;
    c_09 += a_2 * b_3;
    c_10 += a_2 * b_4;
    c_11 += a_2 * b_5;
    c_12 += a_2 * b_6;
  }

  const unsigned int matrix_c_num_start = (start + num_idx) * c_height * c_width;
  const unsigned int matrix_c_row1_start = matrix_c_row1 * c_width;
  const unsigned int matrix_c_row2_start = matrix_c_row2 * c_width;

  matrix_c[hook(2, matrix_c_num_start + matrix_c_row1_start + matrix_c_col1)] = (c_01 <= 0) ? 0 : c_01;
  matrix_c[hook(2, matrix_c_num_start + matrix_c_row1_start + matrix_c_col2)] = (c_02 <= 0) ? 0 : c_02;
  matrix_c[hook(2, matrix_c_num_start + matrix_c_row1_start + matrix_c_col3)] = (c_03 <= 0) ? 0 : c_03;
  matrix_c[hook(2, matrix_c_num_start + matrix_c_row1_start + matrix_c_col4)] = (c_04 <= 0) ? 0 : c_04;
  matrix_c[hook(2, matrix_c_num_start + matrix_c_row1_start + matrix_c_col5)] = (c_05 <= 0) ? 0 : c_05;
  matrix_c[hook(2, matrix_c_num_start + matrix_c_row1_start + matrix_c_col6)] = (c_06 <= 0) ? 0 : c_06;

  matrix_c[hook(2, matrix_c_num_start + matrix_c_row2_start + matrix_c_col1)] = (c_07 <= 0) ? 0 : c_07;
  matrix_c[hook(2, matrix_c_num_start + matrix_c_row2_start + matrix_c_col2)] = (c_08 <= 0) ? 0 : c_08;
  matrix_c[hook(2, matrix_c_num_start + matrix_c_row2_start + matrix_c_col3)] = (c_09 <= 0) ? 0 : c_09;
  matrix_c[hook(2, matrix_c_num_start + matrix_c_row2_start + matrix_c_col4)] = (c_10 <= 0) ? 0 : c_10;
  matrix_c[hook(2, matrix_c_num_start + matrix_c_row2_start + matrix_c_col5)] = (c_11 <= 0) ? 0 : c_11;
  matrix_c[hook(2, matrix_c_num_start + matrix_c_row2_start + matrix_c_col6)] = (c_12 <= 0) ? 0 : c_12;
}