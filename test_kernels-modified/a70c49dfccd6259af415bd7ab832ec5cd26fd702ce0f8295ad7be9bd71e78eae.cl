//{"A":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vector_double(global float* A) {
  int i = get_global_id(0);

  A[hook(0, i)] *= 2;
}