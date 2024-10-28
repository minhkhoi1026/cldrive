//{"A":0,"b":2,"n":3,"tile_size":4,"x":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void matvec_tile(global const double* A, global const double* x, global double* b, int n, int tile_size) {
  int gid = get_global_id(0) * tile_size;
  const int stride = get_global_size(0) * tile_size;
  const int T = tile_size;

  double sum;
  while (gid < n) {
    for (int j_outer = 0; j_outer < n / T; ++j_outer) {
      for (int i_inner = 0; i_inner < T; ++i_inner) {
        sum = 0.0;
        for (int j_inner = 0; j_inner < T; ++j_inner)
          sum += A[hook(0, (gid + i_inner) * n + j_outer * T + j_inner)] * x[hook(1, j_outer * T + j_inner)];

        b[hook(2, gid + i_inner)] += sum;
      }
    }

    gid += stride;
  }
}