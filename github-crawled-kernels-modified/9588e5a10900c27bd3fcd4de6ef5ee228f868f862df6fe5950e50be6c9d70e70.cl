//{"A":2,"lda":3,"m":0,"n":1,"offsetX":5,"offsetY":7,"x":4,"y":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mvm_trans_kernel_naive(int m, int n, global float* A, int lda, global float* x, int offsetX, global float* y, int offsetY) {
  unsigned int i, j;
  unsigned int tid = get_local_id(0);
  unsigned int totalThreads = get_num_groups(0) * (128);
  unsigned int offset = (128) * get_group_id(0);
  int n_size, m_size;

  float sum;
  if (lda == m) {
    n_size = n;
    m_size = m;
  } else {
    n_size = m;
    m_size = n;
  }

  for (i = offset + tid; i < m_size; i += totalThreads) {
    sum = 0.f;
    for (j = 0; j < n_size; j++) {
      sum += A[hook(2, j * n_size + i)] * x[hook(4, j + offsetX)];
    }
    y[hook(6, i + offsetY)] = sum;
  }
}