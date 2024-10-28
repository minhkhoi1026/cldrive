//{"A":0,"A_cols":2,"A_internal_cols":4,"A_internal_rows":3,"A_rows":1,"B":5,"B_cols":7,"B_internal_cols":9,"B_internal_rows":8,"B_rows":6,"C":10,"C_cols":12,"C_internal_cols":14,"C_internal_rows":13,"C_rows":11,"bufA":15,"bufB":16}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void prod_TA(global const float* A, unsigned int A_rows, unsigned int A_cols, unsigned int A_internal_rows, unsigned int A_internal_cols, global const float* B, unsigned int B_rows, unsigned int B_cols, unsigned int B_internal_rows, unsigned int B_internal_cols, global float* C, unsigned int C_rows, unsigned int C_cols, unsigned int C_internal_rows, unsigned int C_internal_cols, local float* bufA, local float* bufB) {
  int block_size = get_local_size(0);
  int row_block_id = get_group_id(0);
  int col_block_id = get_group_id(1);
  int row_thread_id = get_local_id(0);
  int col_thread_id = get_local_id(1);
  int aBegin = row_block_id * block_size;
  int aStep = block_size * A_internal_cols;
  int bBegin = col_block_id * block_size * B_internal_rows;
  int bStep = block_size;
  int block_num = A_rows / block_size;
  if (block_num * block_size != A_rows)
    ++block_num;
  float Csub = 0;
  int aOffset = row_thread_id + col_thread_id * A_internal_cols;
  int bOffset = row_thread_id + col_thread_id * B_internal_rows;
  for (int block = 0; block < block_num; ++block) {
    if (block * block_size + col_thread_id < A_rows && get_global_id(0) < A_cols)
      bufA[hook(15, row_thread_id * block_size + col_thread_id)] = A[hook(0, aBegin + aOffset)];
    else
      bufA[hook(15, row_thread_id * block_size + col_thread_id)] = 0;
    if ((block * block_size + row_thread_id < B_rows) && get_global_id(1) < B_cols)
      bufB[hook(16, row_thread_id * block_size + col_thread_id)] = B[hook(5, bBegin + bOffset)];
    else
      bufB[hook(16, row_thread_id * block_size + col_thread_id)] = 0;
    barrier(0x01);
    for (int k = 0; k < block_size; ++k)
      Csub += bufA[hook(15, row_thread_id * block_size + k)] * bufB[hook(16, k * block_size + col_thread_id)];
    barrier(0x01);
    aBegin += aStep;
    bBegin += bStep;
  }
  if (get_global_id(0) < A_cols && get_global_id(1) < B_cols)
    C[hook(10, get_global_id(0) * C_internal_cols + get_global_id(1))] = Csub;
}