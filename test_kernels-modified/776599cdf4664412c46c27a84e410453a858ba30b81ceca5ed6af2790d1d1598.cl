//{"ncol":3,"nrow":2,"r":1,"v":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void matvecmult_sum(global float* v, global float* r, unsigned int nrow, unsigned int ncol) {
  unsigned int i = get_global_id(0);
  r[hook(1, i)] = 0;
  v += i * ncol;
  for (unsigned int k = 1; k < ncol; ++k)
    r[hook(1, i)] += v[hook(0, k)];
}