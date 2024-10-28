//{"A":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void element_op(global float* A) {
  const unsigned pos = get_global_id(0);
  A[hook(0, pos)] = sqrt(A[hook(0, pos)]);
}