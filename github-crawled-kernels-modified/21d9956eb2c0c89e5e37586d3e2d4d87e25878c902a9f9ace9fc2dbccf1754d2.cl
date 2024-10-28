//{"a":0,"b":1,"out":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void double_test(global float* a, global float* b, global float* out) {
  *out = *a * *b;
}