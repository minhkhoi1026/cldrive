//{"a":0,"b":1,"result":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kern(global int* a, global int* b, global int* result) {
  result[hook(2, 0)] = a[hook(0, 0)] / b[hook(1, 0)];
}