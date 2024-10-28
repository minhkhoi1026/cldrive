//{"A":0,"B":2,"M":1,"imat":5,"n":3,"tile_size":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void tensor_tile(global const double* A, global const double* M, global double* B, int n, int tile_size, int imat) {
  int i_outer = get_global_id(0);
  const int stride = get_global_size(0);
  const int T = tile_size;

  int ni, nj, nk, nm;
  if (imat == 0) {
    ni = 1;
    nj = 1;
    nk = n * n;
    nm = n;
  } else if (imat == 1) {
    ni = n;
    nj = n;
    nk = 1;
    nm = n * n;
  } else if (imat == 2) {
    ni = n * n;
    nj = n * n;
    nk = 1;
    nm = n;
  }

  int i_ind, j_ind, k_ind, m_ind;
  double sum;
  while (i_outer < n / T) {
    for (int m_outer = 0; m_outer < n / T; ++m_outer) {
      for (int j_outer = 0; j_outer < n / T; ++j_outer) {
        for (int k_outer = 0; k_outer < n / T; ++k_outer) {
          for (int m_inner = 0; m_inner < T; ++m_inner) {
            m_ind = m_outer * T + m_inner;
            for (int i_inner = 0; i_inner < T; ++i_inner) {
              i_ind = i_outer * T + i_inner;
              for (int k_inner = 0; k_inner < T; ++k_inner) {
                k_ind = k_outer * T + k_inner;

                sum = 0.0;
                for (int j_inner = 0; j_inner < T; ++j_inner) {
                  j_ind = j_outer * T + j_inner;
                  sum += A[hook(0, i_ind * n + j_ind)] * M[hook(1, m_ind * nm + j_ind * nj + k_ind * nk)];
                }

                B[hook(2, m_ind * nm + i_ind * ni + k_ind * nk)] += sum;
              }
            }
          }
        }
      }
    }

    i_outer += stride;
  }
}