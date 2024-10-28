//{"a":0,"b":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mic(global float* a, global float* b) {
  const size_t ix = get_global_id(0);

  a[hook(0, ix)] = a[hook(0, ix)] + b[hook(1, ix)];
}