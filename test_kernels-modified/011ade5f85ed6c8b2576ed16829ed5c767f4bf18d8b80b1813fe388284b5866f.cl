//{"a":0,"b":1,"n":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void stream(global const float* a, global float* b, int n) {
  b[hook(1, get_global_id(0))] = a[hook(0, get_global_id(0))];
}