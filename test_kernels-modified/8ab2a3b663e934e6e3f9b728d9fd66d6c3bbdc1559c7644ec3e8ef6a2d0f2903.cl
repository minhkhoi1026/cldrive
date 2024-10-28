//{"a":0,"alpha":2,"b":1,"beta":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void alloc(global double* a, global double* b, double alpha, double beta) {
  unsigned long i = get_global_id(0);
  a[hook(0, i)] = alpha;
  if (beta != 0.0) {
    b[hook(1, i)] = beta;
  }
}