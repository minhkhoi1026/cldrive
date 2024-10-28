//{"a":0,"result":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kern(global float* a, global float* result) {
  result[hook(1, 0)] = sin(a[hook(0, 0)]);
}