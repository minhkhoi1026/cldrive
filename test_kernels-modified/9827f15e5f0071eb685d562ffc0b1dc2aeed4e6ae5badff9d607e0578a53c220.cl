//{"A":0,"B":2,"M":1,"k":4,"n":3,"tile_size":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void matmat_tile(global const double* A, global const double* M, global double* B, int n, int k, int tile_size) {
  int gid = get_global_id(0) * tile_size;
  const int stride = get_global_size(0) * tile_size;
  const int T = tile_size;

  double sum;
  while (gid < n) {
    for (int j_outer = 0; j_outer < n / T; ++j_outer) {
      for (int k_outer = 0; k_outer < k / T; ++k_outer) {
        for (int i_inner = 0; i_inner < T; ++i_inner) {
          for (int k_inner = 0; k_inner < T; ++k_inner) {
            sum = 0.0;
            for (int j_inner = 0; j_inner < T; ++j_inner)
              sum += A[hook(0, (gid + i_inner) * n + j_outer * T + j_inner)] * M[hook(1, (j_outer * T + j_inner) * k + k_outer * T + k_inner)];

            B[hook(2, (gid + i_inner) * k + k_outer * T + k_inner)] += sum;
          }
        }
      }
    }

    gid += stride;
  }
}