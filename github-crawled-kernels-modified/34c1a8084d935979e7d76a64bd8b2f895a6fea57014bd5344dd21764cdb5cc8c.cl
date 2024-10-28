//{"a":0,"b":1,"result":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kern(global float* a, global float* b, global float* result) {
  result[hook(2, 0)] = (a[hook(0, 0)] > b[hook(1, 0)]) ? a[hook(0, 0)] : b[hook(1, 0)];
  result[hook(2, 1)] = (a[hook(0, 1)] >= b[hook(1, 1)]) ? a[hook(0, 1)] : b[hook(1, 1)];
  result[hook(2, 2)] = (a[hook(0, 2)] < b[hook(1, 2)]) ? a[hook(0, 2)] : b[hook(1, 2)];
  result[hook(2, 3)] = (a[hook(0, 3)] <= b[hook(1, 3)]) ? a[hook(0, 3)] : b[hook(1, 3)];
}