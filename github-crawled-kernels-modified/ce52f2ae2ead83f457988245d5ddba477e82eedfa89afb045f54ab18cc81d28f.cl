//{"A":0,"i":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void foo(global unsigned int* A, unsigned int i) {
  A[hook(0, i)] = 0;
}