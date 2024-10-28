//{"a":1,"b":2,"number":0,"result":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void testKernel(float number, global float* a, global float* b, global float* result) {
  int index = get_global_id(0);

  result[hook(3, index)] = a[hook(1, index)] + b[hook(2, index)] + number;
}