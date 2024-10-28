//{"A":1,"b":2,"k":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void foo(int k, global int* A, int b) {
  *A = k + b;
}