//{"A":0,"f":1,"g":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void foo(global float* A, float f, float g) {
  *A = f + g;
}