//{"dst":2,"quo":3,"x":0,"y":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void builtin_remquo(global float* x, global float* y, global float* dst, global int* quo) {
  int i = get_global_id(0);
  int q;
  dst[hook(2, i)] = remquo(x[hook(0, i)], y[hook(1, i)], &q);
  quo[hook(3, i)] = q;
}