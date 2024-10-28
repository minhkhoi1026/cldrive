//{"cols":1,"nzval":0,"out":3,"vec":2}
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

kernel void __attribute__((task)) workload(global double* nzval, global int* cols, global double* vec, global double* out) {
  int i, j;
  double Si;

ellpack_1:
  for (i = 0; i < (1 << 12); i++) {
    double sum = out[hook(3, i)];
  ellpack_2:
    for (j = 0; j < (1 << 9); j++) {
      Si = nzval[hook(0, j + i * (1 << 9))] * vec[hook(2, cols[jhook(1, j + i * (1 << 9)))];
      sum += Si;
    }
    out[hook(3, i)] = sum;
  }
}