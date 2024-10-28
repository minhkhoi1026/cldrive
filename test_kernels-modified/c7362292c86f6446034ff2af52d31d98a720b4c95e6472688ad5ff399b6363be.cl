//{"a":0,"b":1,"result":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vectorAddition(global float* a, global float* b, global float* result) {
  int index = get_global_id(0);
  result[hook(2, index)] = a[hook(0, index)] + b[hook(1, index)];
}