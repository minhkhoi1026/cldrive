//{"a":2,"b":1,"n":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void copy_kern(int n, global float4* b, global float4* a) {
  int gti = get_global_id(0);

  b[hook(1, gti)] = a[hook(2, gti)];
}