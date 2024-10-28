//{"A":0,"f":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void foo(global uchar4* A, float f) {
  *A = (uchar4)(1, 2, (uchar)f, 4);
}