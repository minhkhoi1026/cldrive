//{"block_width":6,"cols":3,"i":5,"matrix_opencl":1,"matrix_opencl_out":2,"penalty":4,"ref":10,"ref[t_index_y - 1]":15,"ref[ty]":9,"referrence":0,"temp":8,"temp[0]":12,"temp[t_index_y - 1]":14,"temp[t_index_y]":13,"temp[tx + 1]":11,"temp[tx]":7,"temp[ty + 1]":16}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int maximum(int a, int b, int c) {
  int k;
  if (a <= b)
    k = b;
  else
    k = a;

  if (k <= c)
    return (c);
  else
    return (k);
}

kernel void needle_opencl_shared_1(global int* referrence, global int* matrix_opencl, global int* matrix_opencl_out, int cols, int penalty, int i, int block_width) {
  int bx = get_group_id(0);
  int tx = get_local_id(0);

  int b_index_x = bx;
  int b_index_y = i - 1 - bx;

  int index = cols * 16 * b_index_y + 16 * b_index_x + tx + (cols + 1);
  int index_n = cols * 16 * b_index_y + 16 * b_index_x + tx + (1);
  int index_w = cols * 16 * b_index_y + 16 * b_index_x + (cols);
  int index_nw = cols * 16 * b_index_y + 16 * b_index_x;

  local int temp[16 + 1][16 + 1];
  local int ref[16][16];

  if (tx == 0)
    temp[hook(8, tx)][hook(7, 0)] = matrix_opencl[hook(1, index_nw)];

  for (int ty = 0; ty < 16; ty++)
    ref[hook(10, ty)][hook(9, tx)] = referrence[hook(0, index + cols * ty)];

  barrier(0x01);

  temp[hook(8, tx + 1)][hook(11, 0)] = matrix_opencl[hook(1, index_w + cols * tx)];

  barrier(0x01);

  temp[hook(8, 0)][hook(12, tx + 1)] = matrix_opencl[hook(1, index_n)];

  barrier(0x01);

  for (int m = 0; m < 16; m++) {
    if (tx <= m) {
      int t_index_x = tx + 1;
      int t_index_y = m - tx + 1;

      temp[hook(8, t_index_y)][hook(13, t_index_x)] = maximum(temp[hook(8, t_index_y - 1)][hook(14, t_index_x - 1)] + ref[hook(10, t_index_y - 1)][hook(15, t_index_x - 1)], temp[hook(8, t_index_y)][hook(13, t_index_x - 1)] - penalty, temp[hook(8, t_index_y - 1)][hook(14, t_index_x)] - penalty);
    }

    barrier(0x01);
  }

  for (int m = 16 - 2; m >= 0; m--) {
    if (tx <= m) {
      int t_index_x = tx + 16 - m;
      int t_index_y = 16 - tx;

      temp[hook(8, t_index_y)][hook(13, t_index_x)] = maximum(temp[hook(8, t_index_y - 1)][hook(14, t_index_x - 1)] + ref[hook(10, t_index_y - 1)][hook(15, t_index_x - 1)], temp[hook(8, t_index_y)][hook(13, t_index_x - 1)] - penalty, temp[hook(8, t_index_y - 1)][hook(14, t_index_x)] - penalty);
    }

    barrier(0x01);
  }

  for (int ty = 0; ty < 16; ty++)
    matrix_opencl[hook(1, index + ty * cols)] = temp[hook(8, ty + 1)][hook(16, tx + 1)];
}