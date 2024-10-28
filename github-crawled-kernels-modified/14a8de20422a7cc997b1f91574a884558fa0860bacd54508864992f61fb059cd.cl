//{"A":0,"n":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void foo(global uchar4* A, int n) {
  *A = (uchar4)(1, 2, (uchar)n, 4);
}