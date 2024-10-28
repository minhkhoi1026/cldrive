//{"m":0,"ncol":3,"nrow":2,"v":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void matvecmult_mult(global float* m, global float* v, unsigned int nrow, unsigned int ncol) {
  unsigned int i = get_global_id(0);
  m[hook(0, i)] *= v[hook(1, i % ncol)];
}