//{"matrix_a":0,"matrix_b":1,"matrix_c":2,"start":3,"tile_a":5,"tile_a[tile_row1]":4,"tile_a[tile_row2]":6,"tile_a[tile_row3]":7,"tile_a[tile_row4]":8,"tile_b1":10,"tile_b1[k]":15,"tile_b1[tile_row1]":9,"tile_b1[tile_row2]":11,"tile_b2":13,"tile_b2[k]":16,"tile_b2[tile_row1]":12,"tile_b2[tile_row2]":14}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void matrix_multiplication2(global float* matrix_a, global float* matrix_b, global float* matrix_c, const unsigned int start) {
  const unsigned int a_width = (32 * (5 * 5));
  const unsigned int b_height = a_width;
  const unsigned int b_width = ((((28 - 5 + 1) / 2) - 5 + 1) * (((28 - 5 + 1) / 2) - 5 + 1));
  const unsigned int c_height = 64;
  const unsigned int c_width = b_width;
  const unsigned int num_idx = get_group_id(0) * 2;

  local float tile_a[64][32];
  local float tile_b1[32][64];
  local float tile_b2[32][64];

  const unsigned int tile_row1 = get_local_id(1);
  const unsigned int tile_row2 = tile_row1 + 16;
  const unsigned int tile_row3 = tile_row2 + 16;
  const unsigned int tile_row4 = tile_row3 + 16;

  const unsigned int tile_col1 = get_local_id(0);
  const unsigned int tile_col2 = tile_col1 + 16;
  const unsigned int tile_col3 = tile_col2 + 16;
  const unsigned int tile_col4 = tile_col3 + 16;

  float c1_01 = 0;
  float c1_02 = 0;
  float c1_03 = 0;
  float c1_04 = 0;
  float c1_05 = 0;
  float c1_06 = 0;
  float c1_07 = 0;
  float c1_08 = 0;
  float c1_09 = 0;
  float c1_10 = 0;
  float c1_11 = 0;
  float c1_12 = 0;
  float c1_13 = 0;
  float c1_14 = 0;
  float c1_15 = 0;
  float c1_16 = 0;

  float c2_01 = 0;
  float c2_02 = 0;
  float c2_03 = 0;
  float c2_04 = 0;
  float c2_05 = 0;
  float c2_06 = 0;
  float c2_07 = 0;
  float c2_08 = 0;
  float c2_09 = 0;
  float c2_10 = 0;
  float c2_11 = 0;
  float c2_12 = 0;
  float c2_13 = 0;
  float c2_14 = 0;
  float c2_15 = 0;
  float c2_16 = 0;

  for (unsigned int tile = 0; tile < (5 * 5); tile++) {
    const unsigned int matrix_a_col1 = tile * 32 + tile_col1;
    const unsigned int matrix_a_col2 = tile * 32 + tile_col2;
    const unsigned int matrix_b_row1 = (tile * 32 + tile_row1) * b_width;
    const unsigned int matrix_b_row2 = (tile * 32 + tile_row2) * b_width;
    const unsigned int matrix_b_num1_start = (start + num_idx) * b_height * b_width;
    const unsigned int matrix_b_num2_start = (start + num_idx + 1) * b_height * b_width;

    tile_a[hook(5, tile_row1)][hook(4, tile_col1)] = matrix_a[hook(0, tile_row1 * a_width + matrix_a_col1)];
    tile_a[hook(5, tile_row2)][hook(6, tile_col1)] = matrix_a[hook(0, tile_row2 * a_width + matrix_a_col1)];
    tile_a[hook(5, tile_row3)][hook(7, tile_col1)] = matrix_a[hook(0, tile_row3 * a_width + matrix_a_col1)];
    tile_a[hook(5, tile_row4)][hook(8, tile_col1)] = matrix_a[hook(0, tile_row4 * a_width + matrix_a_col1)];
    tile_a[hook(5, tile_row1)][hook(4, tile_col2)] = matrix_a[hook(0, tile_row1 * a_width + matrix_a_col2)];
    tile_a[hook(5, tile_row2)][hook(6, tile_col2)] = matrix_a[hook(0, tile_row2 * a_width + matrix_a_col2)];
    tile_a[hook(5, tile_row3)][hook(7, tile_col2)] = matrix_a[hook(0, tile_row3 * a_width + matrix_a_col2)];
    tile_a[hook(5, tile_row4)][hook(8, tile_col2)] = matrix_a[hook(0, tile_row4 * a_width + matrix_a_col2)];

    tile_b1[hook(10, tile_row1)][hook(9, tile_col1)] = matrix_b[hook(1, matrix_b_num1_start + matrix_b_row1 + tile_col1)];
    tile_b1[hook(10, tile_row2)][hook(11, tile_col1)] = matrix_b[hook(1, matrix_b_num1_start + matrix_b_row2 + tile_col1)];
    tile_b1[hook(10, tile_row1)][hook(9, tile_col2)] = matrix_b[hook(1, matrix_b_num1_start + matrix_b_row1 + tile_col2)];
    tile_b1[hook(10, tile_row2)][hook(11, tile_col2)] = matrix_b[hook(1, matrix_b_num1_start + matrix_b_row2 + tile_col2)];
    tile_b1[hook(10, tile_row1)][hook(9, tile_col3)] = matrix_b[hook(1, matrix_b_num1_start + matrix_b_row1 + tile_col3)];
    tile_b1[hook(10, tile_row2)][hook(11, tile_col3)] = matrix_b[hook(1, matrix_b_num1_start + matrix_b_row2 + tile_col3)];
    tile_b1[hook(10, tile_row1)][hook(9, tile_col4)] = matrix_b[hook(1, matrix_b_num1_start + matrix_b_row1 + tile_col4)];
    tile_b1[hook(10, tile_row2)][hook(11, tile_col4)] = matrix_b[hook(1, matrix_b_num1_start + matrix_b_row2 + tile_col4)];

    tile_b2[hook(13, tile_row1)][hook(12, tile_col1)] = matrix_b[hook(1, matrix_b_num2_start + matrix_b_row1 + tile_col1)];
    tile_b2[hook(13, tile_row2)][hook(14, tile_col1)] = matrix_b[hook(1, matrix_b_num2_start + matrix_b_row2 + tile_col1)];
    tile_b2[hook(13, tile_row1)][hook(12, tile_col2)] = matrix_b[hook(1, matrix_b_num2_start + matrix_b_row1 + tile_col2)];
    tile_b2[hook(13, tile_row2)][hook(14, tile_col2)] = matrix_b[hook(1, matrix_b_num2_start + matrix_b_row2 + tile_col2)];
    tile_b2[hook(13, tile_row1)][hook(12, tile_col3)] = matrix_b[hook(1, matrix_b_num2_start + matrix_b_row1 + tile_col3)];
    tile_b2[hook(13, tile_row2)][hook(14, tile_col3)] = matrix_b[hook(1, matrix_b_num2_start + matrix_b_row2 + tile_col3)];
    tile_b2[hook(13, tile_row1)][hook(12, tile_col4)] = matrix_b[hook(1, matrix_b_num2_start + matrix_b_row1 + tile_col4)];
    tile_b2[hook(13, tile_row2)][hook(14, tile_col4)] = matrix_b[hook(1, matrix_b_num2_start + matrix_b_row2 + tile_col4)];

    barrier(0x01);
    for (unsigned int k = 0; k < 32; k++) {
      const float a_01 = tile_a[hook(5, tile_row1)][hook(4, k)];
      const float a_02 = tile_a[hook(5, tile_row2)][hook(6, k)];
      const float a_03 = tile_a[hook(5, tile_row3)][hook(7, k)];
      const float a_04 = tile_a[hook(5, tile_row4)][hook(8, k)];
      const float b1_01 = tile_b1[hook(10, k)][hook(15, tile_col1)];
      const float b1_02 = tile_b1[hook(10, k)][hook(15, tile_col2)];
      const float b1_03 = tile_b1[hook(10, k)][hook(15, tile_col3)];
      const float b1_04 = tile_b1[hook(10, k)][hook(15, tile_col4)];
      const float b2_01 = tile_b2[hook(13, k)][hook(16, tile_col1)];
      const float b2_02 = tile_b2[hook(13, k)][hook(16, tile_col2)];
      const float b2_03 = tile_b2[hook(13, k)][hook(16, tile_col3)];
      const float b2_04 = tile_b2[hook(13, k)][hook(16, tile_col4)];

      c1_01 += a_01 * b1_01;
      c1_02 += a_01 * b1_02;
      c1_03 += a_01 * b1_03;
      c1_04 += a_01 * b1_04;
      c1_05 += a_02 * b1_01;
      c1_06 += a_02 * b1_02;
      c1_07 += a_02 * b1_03;
      c1_08 += a_02 * b1_04;
      c1_09 += a_03 * b1_01;
      c1_10 += a_03 * b1_02;
      c1_11 += a_03 * b1_03;
      c1_12 += a_03 * b1_04;
      c1_13 += a_04 * b1_01;
      c1_14 += a_04 * b1_02;
      c1_15 += a_04 * b1_03;
      c1_16 += a_04 * b1_04;

      c2_01 += a_01 * b2_01;
      c2_02 += a_01 * b2_02;
      c2_03 += a_01 * b2_03;
      c2_04 += a_01 * b2_04;
      c2_05 += a_02 * b2_01;
      c2_06 += a_02 * b2_02;
      c2_07 += a_02 * b2_03;
      c2_08 += a_02 * b2_04;
      c2_09 += a_03 * b2_01;
      c2_10 += a_03 * b2_02;
      c2_11 += a_03 * b2_03;
      c2_12 += a_03 * b2_04;
      c2_13 += a_04 * b2_01;
      c2_14 += a_04 * b2_02;
      c2_15 += a_04 * b2_03;
      c2_16 += a_04 * b2_04;
    }
    barrier(0x01);
  }

  const unsigned int matrix_c_num1_start = (start + num_idx) * c_height * c_width;
  const unsigned int matrix_c_num2_start = (start + num_idx + 1) * c_height * c_width;
  const unsigned int matrix_c_row1_start = tile_row1 * c_width;
  const unsigned int matrix_c_row2_start = tile_row2 * c_width;
  const unsigned int matrix_c_row3_start = tile_row3 * c_width;
  const unsigned int matrix_c_row4_start = tile_row4 * c_width;

  matrix_c[hook(2, matrix_c_num1_start + matrix_c_row1_start + tile_col1)] = (c1_01 <= 0) ? 0 : c1_01;
  matrix_c[hook(2, matrix_c_num1_start + matrix_c_row1_start + tile_col2)] = (c1_02 <= 0) ? 0 : c1_02;
  matrix_c[hook(2, matrix_c_num1_start + matrix_c_row1_start + tile_col3)] = (c1_03 <= 0) ? 0 : c1_03;
  matrix_c[hook(2, matrix_c_num1_start + matrix_c_row1_start + tile_col4)] = (c1_04 <= 0) ? 0 : c1_04;
  matrix_c[hook(2, matrix_c_num1_start + matrix_c_row2_start + tile_col1)] = (c1_05 <= 0) ? 0 : c1_05;
  matrix_c[hook(2, matrix_c_num1_start + matrix_c_row2_start + tile_col2)] = (c1_06 <= 0) ? 0 : c1_06;
  matrix_c[hook(2, matrix_c_num1_start + matrix_c_row2_start + tile_col3)] = (c1_07 <= 0) ? 0 : c1_07;
  matrix_c[hook(2, matrix_c_num1_start + matrix_c_row2_start + tile_col4)] = (c1_08 <= 0) ? 0 : c1_08;
  matrix_c[hook(2, matrix_c_num1_start + matrix_c_row3_start + tile_col1)] = (c1_09 <= 0) ? 0 : c1_09;
  matrix_c[hook(2, matrix_c_num1_start + matrix_c_row3_start + tile_col2)] = (c1_10 <= 0) ? 0 : c1_10;
  matrix_c[hook(2, matrix_c_num1_start + matrix_c_row3_start + tile_col3)] = (c1_11 <= 0) ? 0 : c1_11;
  matrix_c[hook(2, matrix_c_num1_start + matrix_c_row3_start + tile_col4)] = (c1_12 <= 0) ? 0 : c1_12;
  matrix_c[hook(2, matrix_c_num1_start + matrix_c_row4_start + tile_col1)] = (c1_13 <= 0) ? 0 : c1_13;
  matrix_c[hook(2, matrix_c_num1_start + matrix_c_row4_start + tile_col2)] = (c1_14 <= 0) ? 0 : c1_14;
  matrix_c[hook(2, matrix_c_num1_start + matrix_c_row4_start + tile_col3)] = (c1_15 <= 0) ? 0 : c1_15;
  matrix_c[hook(2, matrix_c_num1_start + matrix_c_row4_start + tile_col4)] = (c1_16 <= 0) ? 0 : c1_16;

  matrix_c[hook(2, matrix_c_num2_start + matrix_c_row1_start + tile_col1)] = (c2_01 <= 0) ? 0 : c2_01;
  matrix_c[hook(2, matrix_c_num2_start + matrix_c_row1_start + tile_col2)] = (c2_02 <= 0) ? 0 : c2_02;
  matrix_c[hook(2, matrix_c_num2_start + matrix_c_row1_start + tile_col3)] = (c2_03 <= 0) ? 0 : c2_03;
  matrix_c[hook(2, matrix_c_num2_start + matrix_c_row1_start + tile_col4)] = (c2_04 <= 0) ? 0 : c2_04;
  matrix_c[hook(2, matrix_c_num2_start + matrix_c_row2_start + tile_col1)] = (c2_05 <= 0) ? 0 : c2_05;
  matrix_c[hook(2, matrix_c_num2_start + matrix_c_row2_start + tile_col2)] = (c2_06 <= 0) ? 0 : c2_06;
  matrix_c[hook(2, matrix_c_num2_start + matrix_c_row2_start + tile_col3)] = (c2_07 <= 0) ? 0 : c2_07;
  matrix_c[hook(2, matrix_c_num2_start + matrix_c_row2_start + tile_col4)] = (c2_08 <= 0) ? 0 : c2_08;
  matrix_c[hook(2, matrix_c_num2_start + matrix_c_row3_start + tile_col1)] = (c2_09 <= 0) ? 0 : c2_09;
  matrix_c[hook(2, matrix_c_num2_start + matrix_c_row3_start + tile_col2)] = (c2_10 <= 0) ? 0 : c2_10;
  matrix_c[hook(2, matrix_c_num2_start + matrix_c_row3_start + tile_col3)] = (c2_11 <= 0) ? 0 : c2_11;
  matrix_c[hook(2, matrix_c_num2_start + matrix_c_row3_start + tile_col4)] = (c2_12 <= 0) ? 0 : c2_12;
  matrix_c[hook(2, matrix_c_num2_start + matrix_c_row4_start + tile_col1)] = (c2_13 <= 0) ? 0 : c2_13;
  matrix_c[hook(2, matrix_c_num2_start + matrix_c_row4_start + tile_col2)] = (c2_14 <= 0) ? 0 : c2_14;
  matrix_c[hook(2, matrix_c_num2_start + matrix_c_row4_start + tile_col3)] = (c2_15 <= 0) ? 0 : c2_15;
  matrix_c[hook(2, matrix_c_num2_start + matrix_c_row4_start + tile_col4)] = (c2_16 <= 0) ? 0 : c2_16;
}