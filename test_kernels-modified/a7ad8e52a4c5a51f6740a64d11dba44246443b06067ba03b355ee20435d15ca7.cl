//{"m1":0,"m2":1,"prod":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
struct bench_args_t {
  double m1[64 * 64];
  double m2[64 * 64];
  double prod[64 * 64];
};

kernel void __attribute__((task)) workload(global double* restrict m1, global double* restrict m2, global double* restrict prod) {
  int i, k, j, jj, kk;
  int i_row, k_row;
  double temp_x, mul;

loopjj:
  for (jj = 0; jj < 64; jj += 8) {
  loopkk:
    for (kk = 0; kk < 64; kk += 8) {
    loopi:
      for (i = 0; i < 64; ++i) {
      loopk:
        for (k = 0; k < 8; ++k) {
          i_row = i * 64;
          k_row = (k + kk) * 64;
          temp_x = m1[hook(0, i_row + k + kk)];
        loopj:
          for (j = 0; j < 8; ++j) {
            mul = temp_x * m2[hook(1, k_row + j + jj)];
            prod[hook(2, i_row + j + jj)] += mul;
          }
        }
      }
    }
  }
}