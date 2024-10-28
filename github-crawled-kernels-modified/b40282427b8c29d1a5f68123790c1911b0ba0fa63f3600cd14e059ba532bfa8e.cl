//{"x":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void hello(global float* x) {
  int ind = get_global_id(0);
  x[hook(0, ind)] = x[hook(0, ind)] * 2;
}