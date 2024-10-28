//{"A":0,"f":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void foo(global char4* A, float f) {
  *A = (char4)(1, 2, (char)f, 4);
}