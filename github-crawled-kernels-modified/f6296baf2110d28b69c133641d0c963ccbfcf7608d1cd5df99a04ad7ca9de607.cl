//{"a":0,"b":1,"c":3,"num":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mainKernel(global const float4* a, const float4 b, const long num, global float4* c) {
  int iGID = get_global_id(0);

  c[hook(3, iGID)] = a[hook(0, iGID)] + b;
}