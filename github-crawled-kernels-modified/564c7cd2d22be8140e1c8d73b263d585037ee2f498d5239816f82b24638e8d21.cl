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
  int i, j, k;
  int k_col, i_col;
  double mult;

outer:
  for (i = 0; i < 64; i++) {
  middle:
    for (j = 0; j < 64; j++) {
      i_col = i * 64;
      double sum = 0;
    inner:
      for (k = 0; k < 64; k++) {
        k_col = k * 64;
        mult = m1[hook(0, i_col + k)] * m2[hook(1, k_col + j)];
        sum += mult;
      }
      prod[hook(2, i_col + j)] = sum;
    }
  }
}