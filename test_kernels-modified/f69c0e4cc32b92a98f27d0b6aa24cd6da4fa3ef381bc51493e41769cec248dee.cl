//{"a":0,"b":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void r_plus(global float* a, global float* b) {
  int idx = get_global_id(0);
  a[hook(0, idx)] += b[hook(1, idx)];
}