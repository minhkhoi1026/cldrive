//{"block_width":5,"cols":2,"i":4,"matrix_opencl":1,"penalty":3,"referrence":0}
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

__attribute__((num_simd_work_items(2))) __attribute__((num_compute_units(2))) __attribute__((reqd_work_group_size(16, 1, 1))) kernel void needle_opencl_shared_1(global int* restrict referrence, global int* restrict matrix_opencl, int cols, int penalty, int i, int block_width) {
  int bx = get_group_id(0);
  int tx = get_local_id(0);

  int b_index_x = bx;
  int b_index_y = i - 1 - bx;
  int index = cols * 16 * b_index_y + 16 * b_index_x + tx + (cols + 1);

  for (int m = 0; m < 16; m++) {
    if (tx <= m) {
      int ref_x = index + (m - tx) * cols;

      matrix_opencl[hook(1, ref_x)] = maximum(matrix_opencl[hook(1, ref_x - (cols + 1))] + referrence[hook(0, ref_x)], matrix_opencl[hook(1, ref_x - 1)] - penalty, matrix_opencl[hook(1, ref_x - cols)] - penalty);
    }

    barrier(0x02);
  }

  for (int m = 16 - 2; m >= 0; m--) {
    if (tx <= m) {
      int ref_x = index + (m - tx) * cols + (cols + 1) * (16 - 1 - m);

      matrix_opencl[hook(1, ref_x)] = maximum(matrix_opencl[hook(1, ref_x - (cols + 1))] + referrence[hook(0, ref_x)], matrix_opencl[hook(1, ref_x - 1)] - penalty, matrix_opencl[hook(1, ref_x - cols)] - penalty);
    }

    barrier(0x02);
  }
}