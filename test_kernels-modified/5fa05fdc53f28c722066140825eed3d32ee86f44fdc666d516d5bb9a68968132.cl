//{"a":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void square_array(global float* a) {
  unsigned int idx = get_global_id(0);
  a[hook(0, idx)] = a[hook(0, idx)] * a[hook(0, idx)];
}