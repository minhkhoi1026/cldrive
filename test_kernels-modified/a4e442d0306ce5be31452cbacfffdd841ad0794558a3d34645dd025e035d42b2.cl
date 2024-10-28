//{"a":0,"b":1,"c":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vector_sum(global float* a, global float* b, global float* c) {
  int tx = get_global_id(0);
  c[hook(2, tx)] = a[hook(0, tx)] + b[hook(1, tx)];
}