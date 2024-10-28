//{"cols":1,"out":4,"rowDelimiters":2,"val":0,"vec":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
struct bench_args_t {
  double nzval[(1 << 12) * (1 << 9)];
  short cols[(1 << 12) * (1 << 9)];
  double vec[(1 << 12)];
  double out[(1 << 12)];
};

kernel void __attribute__((task)) workload(global double* restrict val, global int* restrict cols, global int* restrict rowDelimiters, global double* restrict vec, global double* restrict out) {
  int i, j;
  double sum, Si;

spmv_1:
  for (i = 0; i < (1 << 12); i++) {
    sum = 0;
    Si = 0;
    int tmp_begin = rowDelimiters[hook(2, i)];
    int tmp_end = rowDelimiters[hook(2, i + 1)];
  spmv_2:
    for (j = tmp_begin; j < tmp_end; j++) {
      Si = val[hook(0, j)] * vec[hook(3, cols[jhook(1, j))];
      sum = sum + Si;
    }
    out[hook(4, i)] = sum;
  }
}