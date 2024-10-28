//{"a":0,"b":1,"c":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void add(global const float* a, global const float* b, global float* c) {
  int id = get_global_id(0);
  c[hook(2, id)] = a[hook(0, id)] + b[hook(1, id)];
}