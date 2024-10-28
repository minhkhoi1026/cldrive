//{"a":0,"b":1,"c":2,"result":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kern(global float4* a, global float4* b, global float4* c, global float4* result) {
  result[hook(3, 0)] = a[hook(0, 0)] * b[hook(1, 0)] + c[hook(2, 0)] - a[hook(0, 0)];
  result[hook(3, 1)] = mad(a[hook(0, 1)], b[hook(1, 1)], c[hook(2, 1)]);
}