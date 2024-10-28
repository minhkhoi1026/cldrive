//{"a":0,"b":1,"out":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mult(global float4* a, global float4* b, global float4* out) {
  int gX = get_global_id(0);

  out[hook(2, gX)] = a[hook(0, gX)] * b[hook(1, gX)];
}