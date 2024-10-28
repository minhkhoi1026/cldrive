//{"A":0,"x":1,"y":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void foo(global float* A, float x, float y) {
  *A = atan2pi(x, y);
}