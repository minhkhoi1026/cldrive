//{"A":0,"a":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void foo(global float* A, unsigned int a) {
  *A = __builtin_astype((a), float);
}