//{"a":0,"b":1,"result":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void adder(global const float* a, global const float* b, global float* result) {
  int idx = get_global_id(0);
  result[hook(2, idx)] = a[hook(0, idx)] + b[hook(1, idx)];
}