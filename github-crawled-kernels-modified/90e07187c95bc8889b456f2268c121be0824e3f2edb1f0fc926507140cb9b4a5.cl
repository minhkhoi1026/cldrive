//{"a":0,"b":1,"out":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void add3(global float* a, global float* b, global float* out) {
  int id = get_global_id(0);

  out[hook(2, id)] = a[hook(0, id)] + b[hook(1, id)];
}