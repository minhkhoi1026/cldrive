//{"lda":3,"matrix":1,"matrix_offset":2,"n":0,"sA":5,"sA[i]":6,"sA[j]":4,"sB":8,"sB[i]":9,"sB[j]":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void dtranspose_inplace_odd(int n, global double* matrix, unsigned long matrix_offset, int lda) {
  matrix += matrix_offset;

  local double sA[16][16 + 1];
  local double sB[16][16 + 1];

  int i = get_local_id(0);
  int j = get_local_id(1);

  bool lower = (get_group_id(0) >= get_group_id(1));
  int ii = (lower ? get_group_id(0) : (get_group_id(1) + get_num_groups(1) - 1));
  int jj = (lower ? get_group_id(1) : (get_group_id(0) + get_num_groups(1)));

  ii *= 16;
  jj *= 16;

  global double* A = matrix + ii + i + (jj + j) * lda;
  if (ii == jj) {
    if (ii + i < n && jj + j < n) {
      sA[hook(5, j)][hook(4, i)] = *A;
    }
    barrier(0x01);
    if (ii + i < n && jj + j < n) {
      *A = sA[hook(5, i)][hook(6, j)];
    }
  } else {
    global double* B = matrix + jj + i + (ii + j) * lda;
    if (ii + i < n && jj + j < n) {
      sA[hook(5, j)][hook(4, i)] = *A;
    }
    if (jj + i < n && ii + j < n) {
      sB[hook(8, j)][hook(7, i)] = *B;
    }
    barrier(0x01);
    if (ii + i < n && jj + j < n) {
      *A = sB[hook(8, i)][hook(9, j)];
    }
    if (jj + i < n && ii + j < n) {
      *B = sA[hook(5, i)][hook(6, j)];
    }
  }
}